Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965228Ab1KJQmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 11:42:37 -0500
Received: from ackle.nomi.cz ([81.31.33.35]:46211 "EHLO ackle.nomi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756703Ab1KJQmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 11:42:33 -0500
Date: Thu, 10 Nov 2011 17:42:30 +0100
From: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlagn: memory corruption with WPA enterprise
Message-ID: <20111110164230.GB24533@nomi.cz>
References: <20111029171554.GA16596@nomi.cz> <20111031160342.GB2225@redhat.com> <20111109155411.GA1669@nomi.cz> <20111109165158.GA2254@redhat.com> <20111110091816.GA2247@nomi.cz> <20111110114732.GA2217@redhat.com> <20111110125347.GA29415@nomi.cz> <20111110160703.GA2775@redhat.com> <1320938685.31823.200.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1320938685.31823.200.camel@wwguy-huron>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hello,

On Thu, Nov 10, 2011 at 07:24:45AM -0800, Guy, Wey-Yi wrote:
> 2. could you provide your system information (model, CPU, memory,
> graphic, ...), also the OS/kernel version and .config file. not sure we
> have the similar system available, but I will like to see if there
> anything stand out.

I'm attaching outputs of dmesg, lspci, dmidecode, my .config (the one I used
with 3.1+net-next). The distro I use is a 32-bit Debian wheezy, with most
packages not being older than 4 months. Do you need anything else?

(Don't be scared by the vboxdrv messages. Those modules don't compile with
3.2-rc1, and the bug happens there as well.)

Regards,
-- 
Tomáš Janoušek, a.k.a. Liskni_si, http://work.lisk.in/

--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename=dmesg

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.1.0-lis-01804-g761d49b (tomi@notes.lisk.in) (gcc version 4.6.1 (Debian 4.6.1-4) ) #24 SMP Sat Oct 29 17:50:54 CEST 2011
[    0.000000] Disabled fast string operations
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
[    0.000000]  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000ba59f000 (usable)
[    0.000000]  BIOS-e820: 00000000ba59f000 - 00000000baa9f000 (reserved)
[    0.000000]  BIOS-e820: 00000000baa9f000 - 00000000bab9f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bab9f000 - 00000000babff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000babff000 - 00000000bac00000 (usable)
[    0.000000]  BIOS-e820: 00000000bac00000 - 00000000bfa00000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed08000 - 00000000fed09000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffd20000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000023e600000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: LENOVO 4178A3G/4178A3G, BIOS 83ET61WW (1.31 ) 07/07/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x23e600 max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0BC000000 mask FFC000000 uncachable
[    0.000000]   3 base 0BB000000 mask FFF000000 uncachable
[    0.000000]   4 base 0BAC00000 mask FFFC00000 uncachable
[    0.000000]   5 base 100000000 mask F00000000 write-back
[    0.000000]   6 base 200000000 mask FC0000000 write-back
[    0.000000]   7 base 23F000000 mask FFF000000 uncachable
[    0.000000]   8 base 23E800000 mask FFF800000 uncachable
[    0.000000]   9 base 23E600000 mask FFFE00000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000bac00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] initial memory mapped : 0 - 00e00000
[    0.000000] Base memory trampoline at [c0099000] 99000 size 16384
[    0.000000] init_memory_mapping: 0000000000000000-000000002f3fe000
[    0.000000]  0000000000 - 0000200000 page 4k
[    0.000000]  0000200000 - 002f200000 page 2M
[    0.000000]  002f200000 - 002f3fe000 page 4k
[    0.000000] kernel direct mapping tables up to 2f3fe000 @ dfb000-e00000
[    0.000000] ACPI: RSDP 000f00e0 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT babfe120 000AC (v01 LENOVO TP-83    00001310 PTEC 00000002)
[    0.000000] ACPI: FACP babe9000 000F4 (v04 LENOVO TP-83    00001310 PTL  00000002)
[    0.000000] ACPI: DSDT babec000 0DFA4 (v01 LENOVO TP-83    00001310 INTL 20061109)
[    0.000000] ACPI: FACS bab2d000 00040
[    0.000000] ACPI: SLIC babfd000 00176 (v01 LENOVO TP-83    00001310 PTEC 00000001)
[    0.000000] ACPI: SSDT babfc000 00249 (v01 LENOVO TP-SSDT2 00000200 INTL 20061109)
[    0.000000] ACPI: SSDT babfb000 00033 (v01 LENOVO TP-SSDT1 00000100 INTL 20061109)
[    0.000000] ACPI: SSDT babfa000 00797 (v01 LENOVO SataAhci 00001000 INTL 20061109)
[    0.000000] ACPI: HPET babe8000 00038 (v01 LENOVO TP-83    00001310 PTL  00000002)
[    0.000000] ACPI: APIC babe7000 00098 (v01 LENOVO TP-83    00001310 PTL  00000002)
[    0.000000] ACPI: MCFG babe6000 0003C (v01 LENOVO TP-83    00001310 PTL  00000002)
[    0.000000] ACPI: ECDT babe5000 00052 (v01 LENOVO TP-83    00001310 PTL  00000002)
[    0.000000] ACPI: ASF! babeb000 000A5 (v32 LENOVO TP-83    00001310 PTL  00000002)
[    0.000000] ACPI: TCPA babe4000 00032 (v02    PTL   LENOVO 06040000 LNVO 00000001)
[    0.000000] ACPI: SSDT babe3000 00A27 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT babe2000 00996 (v01  PmRef    CpuPm 00003000 INTL 20061109)
[    0.000000] ACPI: DMAR babe1000 000E8 (v01 INTEL      SNB  00000001 INTL 00000001)
[    0.000000] ACPI: UEFI babe0000 0003E (v01 LENOVO TP-83    00001310 PTL  00000002)
[    0.000000] ACPI: UEFI babdf000 00042 (v01 PTL      COMBUF 00000001 PTL  00000001)
[    0.000000] ACPI: UEFI babde000 0027E (v01 LENOVO TP-83    00001310 PTL  00000002)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 8434MB HIGHMEM available.
[    0.000000] 755MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 2f3fe000
[    0.000000]   low ram: 0 - 2f3fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x0002f3fe
[    0.000000]   HighMem  0x0002f3fe -> 0x0023e600
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000ba59f
[    0.000000]     0: 0x000babff -> 0x000bac00
[    0.000000]     0: 0x00100000 -> 0x0023e600
[    0.000000] On node 0 totalpages: 2067245
[    0.000000] free_area_init_node: node 0, pgdat c07c34c0, node_mem_map eac2d200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3949 pages, LIFO batch:0
[    0.000000]   Normal zone: 1480 pages used for memmap
[    0.000000]   Normal zone: 187958 pages, LIFO batch:31
[    0.000000]   HighMem zone: 16869 pages used for memmap
[    0.000000]   HighMem zone: 1856957 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] Allocating PCI resources starting at bfa00000 (gap: bfa00000:38600000)
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @eaa00000 s28288 r0 d20864 u262144
[    0.000000] pcpu-alloc: s28288 r0 d20864 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2048864
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.1.0-lis-01804-g761d49b root=/dev/sdb2 ro no_console_suspend apparmor=1 i915.i915_enable_rc6=1 i915.i915_enable_fbc=1 i915.lvds_downclock=1 intel_iommu=off pcie_aspm=force vmalloc=256M corrupt_dbg=1
[    0.000000] Intel-IOMMU: disabled
[    0.000000] PCIe ASPM is forcibly enabled
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Initializing HighMem for node 0 (0002f3fe:0023e600)
[    0.000000] Memory: 8186208k/9410560k available (4703k kernel code, 82772k reserved, 2253k data, 412k init, 7495304k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff17000 - 0xfffff000   ( 928 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xefbfe000 - 0xffbfe000   ( 256 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xef3fe000   ( 755 MB)
[    0.000000]       .init : 0xc07cc000 - 0xc0833000   ( 412 kB)
[    0.000000]       .data : 0xc0597f12 - 0xc07cb380   (2253 kB)
[    0.000000]       .text : 0xc0100000 - 0xc0597f12   (4703 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:512
[    0.000000] CPU 0 irqstacks, hard=ea40c000 soft=ea40e000
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.003333] Detected 2492.017 MHz processor.
[    0.000001] Calibrating delay loop (skipped), value calculated using timer frequency.. 4986.70 BogoMIPS (lpj=8306723)
[    0.000120] pid_max: default: 32768 minimum: 301
[    0.000213] Security Framework initialized
[    0.000278] AppArmor: AppArmor initialized
[    0.000347] Mount-cache hash table entries: 512
[    0.000576] Disabled fast string operations
[    0.000634] CPU: Physical Processor ID: 0
[    0.000689] CPU: Processor Core ID: 0
[    0.000747] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.000748] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.000869] mce: CPU supports 7 MCE banks
[    0.000935] CPU0: Thermal monitoring enabled (TM1)
[    0.000997] using mwait in idle threads.
[    0.001134] ACPI: Core revision 20110623
[    0.013027] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.013435] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.046424] CPU0: Intel(R) Core(TM) i5-2520M CPU @ 2.50GHz stepping 07
[    0.150836] Performance Events: PEBS fmt1+, SandyBridge events, Intel PMU driver.
[    0.151028] ... version:                3
[    0.151086] ... bit width:              48
[    0.151143] ... generic registers:      4
[    0.151200] ... value mask:             0000ffffffffffff
[    0.151259] ... max period:             000000007fffffff
[    0.151317] ... fixed-purpose events:   3
[    0.151374] ... event mask:             000000070000000f
[    0.151561] CPU 1 irqstacks, hard=ea492000 soft=ea494000
[    0.151563] Booting Node   0, Processors  #1
[    0.151648] smpboot cpu 1: start_ip = 99000
[    0.161941] Initializing CPU#1
[    0.243962] Disabled fast string operations
[    0.264042] CPU 2 irqstacks, hard=ea49e000 soft=ea4a0000
[    0.264155]  #2
[    0.264197] smpboot cpu 2: start_ip = 99000
[    0.274547] Initializing CPU#2
[    0.357034] Disabled fast string operations
[    0.377109] CPU 3 irqstacks, hard=ea4aa000 soft=ea4ac000
[    0.377222]  #3
[    0.377264] smpboot cpu 3: start_ip = 99000
[    0.387613] Initializing CPU#3
[    0.470105] Disabled fast string operations
[    0.490124] Brought up 4 CPUs
[    0.490293] Total of 4 processors activated (19942.55 BogoMIPS).
[    0.492469] NET: Registered protocol family 16
[    0.492846] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.492920] ACPI: bus type pci registered
[    0.493228] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.493306] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.493367] PCI: Using MMCONFIG for extended config space
[    0.493433] PCI: Using configuration type 1 for base access
[    0.496910] bio: create slab <bio-0> at 0
[    0.497067] ACPI: Added _OSI(Module Device)
[    0.497124] ACPI: Added _OSI(Processor Device)
[    0.497181] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.497239] ACPI: Added _OSI(Processor Aggregator Device)
[    0.499253] ACPI: EC: EC description table is found, configuring boot EC
[    0.507963] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.541265] ACPI: SSDT baa8c018 008C0 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.541953] ACPI: Dynamic OEM Table Load:
[    0.542089] ACPI: SSDT   (null) 008C0 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.550525] ACPI: SSDT baa8da98 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.551839] ACPI: Dynamic OEM Table Load:
[    0.551975] ACPI: SSDT   (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.560157] ACPI: SSDT baa8bd98 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.560829] ACPI: Dynamic OEM Table Load:
[    0.560964] ACPI: SSDT   (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.571065] ACPI: Interpreter enabled
[    0.571124] ACPI: (supports S0 S3 S5)
[    0.571313] ACPI: Using IOAPIC for interrupt routing
[    0.587155] ACPI: Power Resource [PUBS] (on)
[    0.592214] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.593486] ACPI: ACPI Dock Station Driver: 2 docks/bays found
[    0.593547] HEST: Table not found.
[    0.593604] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.593911] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.594046] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.594109] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.594170] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.594245] pci_root PNP0A08:00: host bridge window [mem 0xbfa00000-0xfebfffff]
[    0.594319] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed4bfff]
[    0.594401] pci 0000:00:00.0: [8086:0104] type 0 class 0x000600
[    0.594433] pci 0000:00:01.0: [8086:0101] type 1 class 0x000604
[    0.594456] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.594458] pci 0000:00:01.0: PME# disabled
[    0.594475] pci 0000:00:02.0: [8086:0126] type 0 class 0x000300
[    0.594484] pci 0000:00:02.0: reg 10: [mem 0xd0000000-0xd03fffff 64bit]
[    0.594490] pci 0000:00:02.0: reg 18: [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.594494] pci 0000:00:02.0: reg 20: [io  0x5000-0x503f]
[    0.594542] pci 0000:00:16.0: [8086:1c3a] type 0 class 0x000780
[    0.594566] pci 0000:00:16.0: reg 10: [mem 0xd2625000-0xd262500f 64bit]
[    0.594628] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.594632] pci 0000:00:16.0: PME# disabled
[    0.594655] pci 0000:00:16.3: [8086:1c3d] type 0 class 0x000700
[    0.594673] pci 0000:00:16.3: reg 10: [io  0x50b0-0x50b7]
[    0.594682] pci 0000:00:16.3: reg 14: [mem 0xd262c000-0xd262cfff]
[    0.594767] pci 0000:00:19.0: [8086:1502] type 0 class 0x000200
[    0.594786] pci 0000:00:19.0: reg 10: [mem 0xd2600000-0xd261ffff]
[    0.594794] pci 0000:00:19.0: reg 14: [mem 0xd262b000-0xd262bfff]
[    0.594803] pci 0000:00:19.0: reg 18: [io  0x5080-0x509f]
[    0.594851] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.594855] pci 0000:00:19.0: PME# disabled
[    0.594880] pci 0000:00:1a.0: [8086:1c2d] type 0 class 0x000c03
[    0.594900] pci 0000:00:1a.0: reg 10: [mem 0xd262a000-0xd262a3ff]
[    0.594972] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.594977] pci 0000:00:1a.0: PME# disabled
[    0.595002] pci 0000:00:1b.0: [8086:1c20] type 0 class 0x000403
[    0.595017] pci 0000:00:1b.0: reg 10: [mem 0xd2620000-0xd2623fff 64bit]
[    0.595071] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.595075] pci 0000:00:1b.0: PME# disabled
[    0.595100] pci 0000:00:1c.0: [8086:1c10] type 1 class 0x000604
[    0.595201] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.595206] pci 0000:00:1c.0: PME# disabled
[    0.595240] pci 0000:00:1c.1: [8086:1c12] type 1 class 0x000604
[    0.595341] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.595346] pci 0000:00:1c.1: PME# disabled
[    0.595381] pci 0000:00:1c.3: [8086:1c16] type 1 class 0x000604
[    0.595482] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.595487] pci 0000:00:1c.3: PME# disabled
[    0.595520] pci 0000:00:1c.4: [8086:1c18] type 1 class 0x000604
[    0.595620] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.595625] pci 0000:00:1c.4: PME# disabled
[    0.595661] pci 0000:00:1d.0: [8086:1c26] type 0 class 0x000c03
[    0.595682] pci 0000:00:1d.0: reg 10: [mem 0xd2629000-0xd26293ff]
[    0.595754] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.595759] pci 0000:00:1d.0: PME# disabled
[    0.595784] pci 0000:00:1f.0: [8086:1c4f] type 0 class 0x000601
[    0.595898] pci 0000:00:1f.2: [8086:1c03] type 0 class 0x000106
[    0.595916] pci 0000:00:1f.2: reg 10: [io  0x50a8-0x50af]
[    0.595924] pci 0000:00:1f.2: reg 14: [io  0x50bc-0x50bf]
[    0.595932] pci 0000:00:1f.2: reg 18: [io  0x50a0-0x50a7]
[    0.595940] pci 0000:00:1f.2: reg 1c: [io  0x50b8-0x50bb]
[    0.595948] pci 0000:00:1f.2: reg 20: [io  0x5060-0x507f]
[    0.595956] pci 0000:00:1f.2: reg 24: [mem 0xd2628000-0xd26287ff]
[    0.595989] pci 0000:00:1f.2: PME# supported from D3hot
[    0.595992] pci 0000:00:1f.2: PME# disabled
[    0.596011] pci 0000:00:1f.3: [8086:1c22] type 0 class 0x000c05
[    0.596026] pci 0000:00:1f.3: reg 10: [mem 0xd2624000-0xd26240ff 64bit]
[    0.596047] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
[    0.596091] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.596221] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.596542] pci 0000:03:00.0: [8086:0085] type 0 class 0x000280
[    0.596722] pci 0000:03:00.0: reg 10: [mem 0xd2500000-0xd2501fff 64bit]
[    0.597271] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.597305] pci 0000:03:00.0: PME# disabled
[    0.603278] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.603343] pci 0000:00:1c.1:   bridge window [mem 0xd2500000-0xd25fffff]
[    0.603422] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.603484] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.603489] pci 0000:00:1c.3:   bridge window [mem 0xd1d00000-0xd24fffff]
[    0.603498] pci 0000:00:1c.3:   bridge window [mem 0xd0400000-0xd0bfffff 64bit pref]
[    0.603638] pci 0000:0d:00.0: [1180:e823] type 0 class 0x000880
[    0.603665] pci 0000:0d:00.0: reg 10: [mem 0xd1401000-0xd14010ff]
[    0.603828] pci 0000:0d:00.0: supports D1 D2
[    0.603829] pci 0000:0d:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.603835] pci 0000:0d:00.0: PME# disabled
[    0.603897] pci 0000:0d:00.3: [1180:e832] type 0 class 0x000c00
[    0.603923] pci 0000:0d:00.3: reg 10: [mem 0xd1400000-0xd14007ff]
[    0.604086] pci 0000:0d:00.3: supports D1 D2
[    0.604087] pci 0000:0d:00.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.604093] pci 0000:0d:00.3: PME# disabled
[    0.609857] pci 0000:00:1c.4: PCI bridge to [bus 0d-0d]
[    0.609949] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.609954] pci 0000:00:1c.4:   bridge window [mem 0xd1400000-0xd1cfffff]
[    0.609963] pci 0000:00:1c.4:   bridge window [mem 0xd0c00000-0xd13fffff 64bit pref]
[    0.609996] pci_bus 0000:00: on NUMA node 0
[    0.609999] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.610139] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG_._PRT]
[    0.610181] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.610222] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    0.610263] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.610308] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP5._PRT]
[    0.610578]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.611021]  pci0000:00: ACPI _OSC request failed (AE_SUPPORT), returned control mask: 0x0d
[    0.611096] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.615320] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.615876] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *7 9 10 11)
[    0.616434] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.616990] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.617544] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11)
[    0.618075] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.618719] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 9 10 11)
[    0.619273] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11)
[    0.619864] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.619943] vgaarb: loaded
[    0.619998] vgaarb: bridge control possible 0000:00:02.0
[    0.620167] SCSI subsystem initialized
[    0.620309] libata version 3.00 loaded.
[    0.620423] PCI: Using ACPI for IRQ routing
[    0.622143] PCI: pci_cache_line_size set to 64 bytes
[    0.622355] reserve RAM buffer: 000000000009d800 - 000000000009ffff 
[    0.622357] reserve RAM buffer: 00000000ba59f000 - 00000000bbffffff 
[    0.622359] reserve RAM buffer: 00000000bac00000 - 00000000bbffffff 
[    0.622361] reserve RAM buffer: 000000023e600000 - 000000023fffffff 
[    0.622568] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.622980] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.625050] Switching to clocksource hpet
[    0.626413] Switched to NOHz mode on CPU #0
[    0.626487] Switched to NOHz mode on CPU #3
[    0.626493] Switched to NOHz mode on CPU #2
[    0.626495] Switched to NOHz mode on CPU #1
[    0.626758] AppArmor: AppArmor Filesystem Enabled
[    0.626875] pnp: PnP ACPI init
[    0.626938] ACPI: bus type pnp registered
[    0.627728] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    0.627730] pnp 00:00: [mem 0x000c0000-0x000c3fff]
[    0.627731] pnp 00:00: [mem 0x000c4000-0x000c7fff]
[    0.627733] pnp 00:00: [mem 0x000c8000-0x000cbfff]
[    0.627734] pnp 00:00: [mem 0x000cc000-0x000cffff]
[    0.627736] pnp 00:00: [mem 0x000d0000-0x000d3fff]
[    0.627737] pnp 00:00: [mem 0x000d4000-0x000d7fff]
[    0.627739] pnp 00:00: [mem 0x000d8000-0x000dbfff]
[    0.627740] pnp 00:00: [mem 0x000dc000-0x000dffff]
[    0.627742] pnp 00:00: [mem 0x000e0000-0x000e3fff]
[    0.627744] pnp 00:00: [mem 0x000e4000-0x000e7fff]
[    0.627746] pnp 00:00: [mem 0x000e8000-0x000ebfff]
[    0.627747] pnp 00:00: [mem 0x000ec000-0x000effff]
[    0.627749] pnp 00:00: [mem 0x000f0000-0x000fffff]
[    0.627750] pnp 00:00: [mem 0x00100000-0xbf9fffff]
[    0.627752] pnp 00:00: [mem 0xfec00000-0xfed3ffff]
[    0.627753] pnp 00:00: [mem 0xfed4c000-0xffffffff]
[    0.627830] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.627894] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.627956] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.628018] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.628080] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.628142] system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
[    0.628203] system 00:00: [mem 0x000d4000-0x000d7fff] has been reserved
[    0.628265] system 00:00: [mem 0x000d8000-0x000dbfff] has been reserved
[    0.628326] system 00:00: [mem 0x000dc000-0x000dffff] has been reserved
[    0.628388] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.628450] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.628526] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.628589] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.628651] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.628714] system 00:00: [mem 0x00100000-0xbf9fffff] could not be reserved
[    0.628776] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.628839] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.628903] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.628931] pnp 00:01: [bus 00-fe]
[    0.628933] pnp 00:01: [io  0x0cf8-0x0cff]
[    0.628934] pnp 00:01: [io  0x0000-0x0cf7 window]
[    0.628936] pnp 00:01: [io  0x0d00-0xffff window]
[    0.628938] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    0.628939] pnp 00:01: [mem 0x000c0000-0x000c3fff window]
[    0.628941] pnp 00:01: [mem 0x000c4000-0x000c7fff window]
[    0.628943] pnp 00:01: [mem 0x000c8000-0x000cbfff window]
[    0.628944] pnp 00:01: [mem 0x000cc000-0x000cffff window]
[    0.628946] pnp 00:01: [mem 0x000d0000-0x000d3fff window]
[    0.628947] pnp 00:01: [mem 0x000d4000-0x000d7fff window]
[    0.628949] pnp 00:01: [mem 0x000d8000-0x000dbfff window]
[    0.628951] pnp 00:01: [mem 0x000dc000-0x000dffff window]
[    0.628952] pnp 00:01: [mem 0x000e0000-0x000e3fff window]
[    0.628954] pnp 00:01: [mem 0x000e4000-0x000e7fff window]
[    0.628955] pnp 00:01: [mem 0x000e8000-0x000ebfff window]
[    0.628957] pnp 00:01: [mem 0x000ec000-0x000effff window]
[    0.628959] pnp 00:01: [mem 0xbfa00000-0xfebfffff window]
[    0.628960] pnp 00:01: [mem 0xfed40000-0xfed4bfff window]
[    0.629037] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.629136] pnp 00:02: [io  0x0010-0x001f]
[    0.629138] pnp 00:02: [io  0x0090-0x009f]
[    0.629139] pnp 00:02: [io  0x0024-0x0025]
[    0.629140] pnp 00:02: [io  0x0028-0x0029]
[    0.629142] pnp 00:02: [io  0x002c-0x002d]
[    0.629143] pnp 00:02: [io  0x0030-0x0031]
[    0.629145] pnp 00:02: [io  0x0034-0x0035]
[    0.629146] pnp 00:02: [io  0x0038-0x0039]
[    0.629147] pnp 00:02: [io  0x003c-0x003d]
[    0.629149] pnp 00:02: [io  0x00a4-0x00a5]
[    0.629150] pnp 00:02: [io  0x00a8-0x00a9]
[    0.629151] pnp 00:02: [io  0x00ac-0x00ad]
[    0.629153] pnp 00:02: [io  0x00b0-0x00b5]
[    0.629154] pnp 00:02: [io  0x00b8-0x00b9]
[    0.629155] pnp 00:02: [io  0x00bc-0x00bd]
[    0.629157] pnp 00:02: [io  0x0050-0x0053]
[    0.629158] pnp 00:02: [io  0x0072-0x0077]
[    0.629159] pnp 00:02: [io  0x0400-0x047f]
[    0.629161] pnp 00:02: [io  0x0500-0x057f]
[    0.629162] pnp 00:02: [io  0x0800-0x080f]
[    0.629164] pnp 00:02: [io  0x15e0-0x15ef]
[    0.629165] pnp 00:02: [io  0x1600-0x167f]
[    0.629166] pnp 00:02: [mem 0xf8000000-0xfbffffff]
[    0.629168] pnp 00:02: [mem 0x00000000-0x00000fff]
[    0.629169] pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
[    0.629171] pnp 00:02: [mem 0xfed10000-0xfed13fff]
[    0.629173] pnp 00:02: [mem 0xfed18000-0xfed18fff]
[    0.629174] pnp 00:02: [mem 0xfed19000-0xfed19fff]
[    0.629176] pnp 00:02: [mem 0xfed45000-0xfed4bfff]
[    0.629256] system 00:02: [io  0x0400-0x047f] has been reserved
[    0.629317] system 00:02: [io  0x0500-0x057f] has been reserved
[    0.629378] system 00:02: [io  0x0800-0x080f] has been reserved
[    0.629439] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    0.629500] system 00:02: [io  0x1600-0x167f] has been reserved
[    0.629561] system 00:02: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.629622] system 00:02: [mem 0x00000000-0x00000fff] could not be reserved
[    0.629685] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.629747] system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.629809] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.629871] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.629934] system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.629996] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.630064] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.630120] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.630132] pnp 00:04: [io  0x0000-0x000f]
[    0.630133] pnp 00:04: [io  0x0080-0x008f]
[    0.630135] pnp 00:04: [io  0x00c0-0x00df]
[    0.630137] pnp 00:04: [dma 4]
[    0.630189] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.630199] pnp 00:05: [io  0x0061]
[    0.630253] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.630264] pnp 00:06: [io  0x00f0]
[    0.630271] pnp 00:06: [irq 13]
[    0.630324] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.630335] pnp 00:07: [io  0x0070-0x0071]
[    0.630339] pnp 00:07: [irq 8]
[    0.630392] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.630403] pnp 00:08: [io  0x0060]
[    0.630404] pnp 00:08: [io  0x0064]
[    0.630408] pnp 00:08: [irq 1]
[    0.630461] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.630475] pnp 00:09: [irq 12]
[    0.630530] pnp 00:09: Plug and Play ACPI device, IDs LEN0015 PNP0f13 (active)
[    0.630582] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    0.630640] pnp 00:0a: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
[    0.631213] pnp: PnP ACPI: found 11 devices
[    0.631271] ACPI: ACPI bus type pnp unregistered
[    0.669243] PCI: max bus depth: 1 pci_try_num: 2
[    0.669294] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.669358] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.669433] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.669497] pci 0000:00:1c.1:   bridge window [mem 0xd2500000-0xd25fffff]
[    0.669568] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.669629] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.669696] pci 0000:00:1c.3:   bridge window [mem 0xd1d00000-0xd24fffff]
[    0.669761] pci 0000:00:1c.3:   bridge window [mem 0xd0400000-0xd0bfffff 64bit pref]
[    0.669842] pci 0000:00:1c.4: PCI bridge to [bus 0d-0d]
[    0.669904] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.669970] pci 0000:00:1c.4:   bridge window [mem 0xd1400000-0xd1cfffff]
[    0.670035] pci 0000:00:1c.4:   bridge window [mem 0xd0c00000-0xd13fffff 64bit pref]
[    0.670122] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.670185] pci 0000:00:01.0: setting latency timer to 64
[    0.670192] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.670259] pci 0000:00:1c.0: setting latency timer to 64
[    0.670267] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.670331] pci 0000:00:1c.1: setting latency timer to 64
[    0.670340] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.670405] pci 0000:00:1c.3: setting latency timer to 64
[    0.670412] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.670477] pci 0000:00:1c.4: setting latency timer to 64
[    0.670480] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.670482] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.670484] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.670486] pci_bus 0000:00: resource 7 [mem 0xbfa00000-0xfebfffff]
[    0.670487] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed4bfff]
[    0.670489] pci_bus 0000:03: resource 1 [mem 0xd2500000-0xd25fffff]
[    0.670491] pci_bus 0000:05: resource 0 [io  0x4000-0x4fff]
[    0.670493] pci_bus 0000:05: resource 1 [mem 0xd1d00000-0xd24fffff]
[    0.670495] pci_bus 0000:05: resource 2 [mem 0xd0400000-0xd0bfffff 64bit pref]
[    0.670496] pci_bus 0000:0d: resource 0 [io  0x3000-0x3fff]
[    0.670498] pci_bus 0000:0d: resource 1 [mem 0xd1400000-0xd1cfffff]
[    0.670500] pci_bus 0000:0d: resource 2 [mem 0xd0c00000-0xd13fffff 64bit pref]
[    0.670533] NET: Registered protocol family 2
[    0.670648] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.670868] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.671138] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.671289] TCP: Hash tables configured (established 131072 bind 65536)
[    0.671351] TCP reno registered
[    0.671407] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.671469] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.671599] NET: Registered protocol family 1
[    0.671665] pci 0000:00:02.0: Boot video device
[    0.671811] PCI: CLS 64 bytes, default 64
[    0.671846] DMAR: Host address width 36
[    0.671902] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.671966] IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
[    0.672040] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.672102] IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
[    0.672175] DMAR: RMRR base: 0x000000ba8d5000 end: 0x000000ba8ebfff
[    0.672236] DMAR: RMRR base: 0x000000bb800000 end: 0x000000bf9fffff
[    0.672297] DMAR: No ATSR found
[    0.673576] audit: initializing netlink socket (disabled)
[    0.673641] type=2000 audit(1320919288.519:1): initialized
[    0.702999] highmem bounce pool size: 64 pages
[    0.707090] msgmni has been set to 1349
[    0.707411] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.707485] io scheduler noop registered
[    0.707541] io scheduler deadline registered
[    0.707607] io scheduler cfq registered (default)
[    0.707745] pcieport 0000:00:01.0: setting latency timer to 64
[    0.707765] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.708381] intel_idle: MWAIT substates: 0x21120
[    0.708383] intel_idle: v0.4 model 0x2A
[    0.708384] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.708593] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    0.708888] ACPI: Lid Switch [LID]
[    0.709005] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    0.709083] ACPI: Sleep Button [SLPB]
[    0.709203] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.709278] ACPI: Power Button [PWRF]
[    0.709418] ACPI: acpi_idle yielding to intel_idle
[    0.713143] thermal LNXTHERM:00: registered as thermal_zone0
[    0.713204] ACPI: Thermal Zone [THM0] (62 C)
[    0.713381] ERST: Table is not found!
[    0.713438] GHES: HEST is not enabled!
[    0.714877] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.948076] serial 0000:00:16.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.968525] 0000:00:16.3: ttyS0 at I/O 0x50b0 (irq = 19) is a 16550A
[    1.027867] Linux agpgart interface v0.103
[    1.027973] agpgart-intel 0000:00:00.0: Intel Sandybridge Chipset
[    1.028078] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    1.028965] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
[    1.029172] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    1.029325] [drm] Initialized drm 1.1.0 20060810
[    1.029413] i915 0000:00:02.0: power state changed by ACPI to D0
[    1.029476] i915 0000:00:02.0: power state changed by ACPI to D0
[    1.029539] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.029602] i915 0000:00:02.0: setting latency timer to 64
[    1.040005] mtrr: no more MTRRs available
[    1.040063] [drm] MTRR allocation failed.  Graphics performance may suffer.
[    1.040716] i915 0000:00:02.0: irq 41 for MSI/MSI-X
[    1.040720] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    1.040781] [drm] Driver supports precise vblank timestamp query.
[    1.040865] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.507956] fbcon: inteldrmfb (fb0) is primary device
[    1.672793] Refined TSC clocksource calibration: 2491.905 MHz.
[    1.672801] Switching to clocksource tsc
[    1.907151] Console: switching to colour frame buffer device 200x56
[    1.911062] fb0: inteldrmfb frame buffer device
[    1.911063] drm: registered panic notifier
[    1.941392] acpi device:01: registered as cooling_device4
[    1.941621] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input3
[    1.941668] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    1.941756] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.943366] brd: module loaded
[    1.943385] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    1.943473] osst :I: Tape driver with OnStream support version 0.99.4
[    1.943474] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    1.943712] SCSI Media Changer driver v0.25 
[    1.943798] ahci 0000:00:1f.2: version 3.0
[    1.943808] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.943874] ahci 0000:00:1f.2: irq 42 for MSI/MSI-X
[    1.943903] ahci: SSS flag set, parallel bus scan disabled
[    1.955511] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x1f impl SATA mode
[    1.955616] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pio slum part ems sxs apst 
[    1.955662] ahci 0000:00:1f.2: setting latency timer to 64
[    1.982850] scsi0 : ahci
[    1.982963] scsi1 : ahci
[    1.983060] scsi2 : ahci
[    1.983156] scsi3 : ahci
[    1.983251] scsi4 : ahci
[    1.983347] scsi5 : ahci
[    1.984184] ata1: SATA max UDMA/133 abar m2048@0xd2628000 port 0xd2628100 irq 42
[    1.984222] ata2: SATA max UDMA/133 abar m2048@0xd2628000 port 0xd2628180 irq 42
[    1.984260] ata3: SATA max UDMA/133 abar m2048@0xd2628000 port 0xd2628200 irq 42
[    1.985377] ata4: SATA max UDMA/133 abar m2048@0xd2628000 port 0xd2628280 irq 42
[    1.986475] ata5: SATA max UDMA/133 abar m2048@0xd2628000 port 0xd2628300 irq 42
[    1.987549] ata6: DUMMY
[    1.988877] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    1.993632] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.994726] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.995914] mousedev: PS/2 mouse device common for all mice
[    1.997039] rtc_cmos 00:07: RTC can wake from S4
[    1.998183] rtc (null): alarm rollover: day
[    1.998224] rtc_cmos: dev (254:0)
[    1.998229] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    1.999326] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    2.000624] device-mapper: ioctl: 4.21.0-ioctl (2011-07-06) initialised: dm-devel@redhat.com
[    2.001739] EDAC MC: Ver: 2.1.0
[    2.003455] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    2.003709] cpuidle: using governor ladder
[    2.007414] cpuidle: using governor menu
[    2.008561] zram: num_devices not specified. Using default: 1
[    2.009695] zram: Creating 1 devices ...
[    2.011243] TCP bic registered
[    2.012922] NET: Registered protocol family 10
[    2.014339] Mobile IPv6
[    2.015410] IPv6 over IPv4 tunneling driver
[    2.016871] NET: Registered protocol family 17
[    2.017966] lib80211: common routines for IEEE802.11 drivers
[    2.019083] lib80211_crypt: registered algorithm 'NULL'
[    2.019084] Registering the dns_resolver key type
[    2.020201] Using IPI No-Shortcut mode
[    2.021552] registered taskstats version 1
[    2.023112] rtc_cmos 00:07: setting system clock to 2011-11-10 10:01:30 UTC (1320919290)
[    2.304795] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.307766] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.307778] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.309004] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.311793] ata1.00: ATA-8: ST9500420AS, 0003LVM1, max UDMA/100
[    2.312972] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.316357] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.316370] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.317532] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.320382] ata1.00: configured for UDMA/100
[    2.321686] scsi 0:0:0:0: Direct-Access     ATA      ST9500420AS      0003 PQ: 0 ANSI: 5
[    2.323151] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    2.323343] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.325473] sd 0:0:0:0: [sda] Write Protect is off
[    2.326569] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.326584] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.397612]  sda: sda1 sda2 sda4 < sda5 sda6 sda7 >
[    2.399414] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.640675] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.644301] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    2.644601] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    2.644613] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.647339] ata2.00: ATAPI: HL-DT-STDVDRAM GT33N, LT20, max UDMA/66
[    2.651274] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    2.651572] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    2.651583] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.654349] ata2.00: configured for UDMA/66
[    2.657431] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GT33N     LT20 PQ: 0 ANSI: 5
[    2.661730] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.662972] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.664429] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.664599] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.983230] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.985080] ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.985084] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.986357] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.987844] ata3.00: ATA-7: INTEL SSDMAEMC080G2, 2CV102M3, max UDMA/133
[    2.989162] ata3.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.990869] ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.990882] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.992150] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.993638] ata3.00: configured for UDMA/133
[    2.995122] scsi 2:0:0:0: Direct-Access     ATA      INTEL SSDMAEMC08 2CV1 PQ: 0 ANSI: 5
[    2.996610] sd 2:0:0:0: [sdb] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
[    2.996734] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    2.999203] sd 2:0:0:0: [sdb] Write Protect is off
[    3.000444] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.000458] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.002348]  sdb: sdb1 sdb2 sdb3
[    3.004162] sd 2:0:0:0: [sdb] Attached SCSI disk
[    3.315806] ata4: SATA link down (SStatus 0 SControl 300)
[    3.635082] ata5: SATA link down (SStatus 0 SControl 300)
[    3.636828] EXT3-fs (sdb2): error: couldn't mount because of unsupported optional features (240)
[    3.685277] EXT2-fs (sdb2): error: couldn't mount because of unsupported optional features (240)
[    3.733257] EXT4-fs (sdb2): mounted filesystem with ordered data mode. Opts: (null)
[    3.734556] VFS: Mounted root (ext4 filesystem) readonly on device 8:18.
[    3.735948] Freeing unused kernel memory: 412k freed
[    3.975391] wmi: Mapper loaded
[    3.993523] Non-volatile memory driver v1.3
[    3.996863] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    3.998772] ACPI: Battery Slot [BAT0] (battery present)
[    4.001036] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    4.003220] ACPI: AC Adapter [AC] (on-line)
[    4.006038] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    4.019592] tpm_tis 00:0a: 1.2 TPM (device-id 0x0, rev-id 78)
[    4.032872] usbcore: registered new interface driver usbfs
[    4.035727] e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
[    4.037696] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    4.038298] firewire_ohci 0000:0d:00.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    4.038344] firewire_ohci 0000:0d:00.3: setting latency timer to 64
[    4.040272] usbcore: registered new interface driver hub
[    4.041614] usbcore: registered new device driver usb
[    4.046012] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.048509] e1000e 0000:00:19.0: setting latency timer to 64
[    4.049045] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[    4.053567] sdhci: Secure Digital Host Controller Interface driver
[    4.055501] sdhci: Copyright(c) Pierre Ossman
[    4.058229] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.092102] cfg80211: Calling CRDA to update world regulatory domain
[    4.098753] firewire_ohci 0000:0d:00.3: irq 44 for MSI/MSI-X
[    4.098805] firewire_ohci: Added fw-ohci device 0000:0d:00.3, OHCI v1.10, 4 IR + 4 IT contexts, quirks 0x1
[    4.100623] sdhci-pci 0000:0d:00.0: SDHCI controller found [1180:e823] (rev 5)
[    4.100645] sdhci-pci 0000:0d:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.100683] sdhci-pci 0000:0d:00.0: setting latency timer to 64
[    4.100738] Registered led device: mmc0::
[    4.100784] mmc0: SDHCI controller on PCI [0000:0d:00.0] using DMA
[    4.174136] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[    4.175500] thinkpad_acpi: http://ibm-acpi.sf.net/
[    4.176894] thinkpad_acpi: ThinkPad BIOS 83ET61WW (1.31 ), EC unknown
[    4.178319] thinkpad_acpi: Lenovo ThinkPad T420, model 4178A3G
[    4.180406] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[    4.181930] thinkpad_acpi: radio switch found; radios are enabled
[    4.186448] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[    4.188793] Registered led device: tpacpi::thinklight
[    4.188822] Registered led device: tpacpi::power
[    4.188839] Registered led device: tpacpi::standby
[    4.188854] Registered led device: tpacpi::thinkvantage
[    4.188862] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
[    4.192054] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[    4.197313] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input5
[    4.202548] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[    4.204074] Copyright(c) 2003-2011 Intel Corporation
[    4.205804] iwlwifi 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    4.207189] iwlwifi 0000:03:00.0: setting latency timer to 64
[    4.207214] iwlwifi 0000:03:00.0: pci_resource_len = 0x00002000
[    4.208646] iwlwifi 0000:03:00.0: pci_resource_base = f344c000
[    4.210125] iwlwifi 0000:03:00.0: HW Revision ID = 0x34
[    4.211595] iwlwifi 0000:03:00.0: irq 45 for MSI/MSI-X
[    4.211632] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Advanced-N 6205 AGN, REV=0xB0
[    4.213084] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[    4.224926] iwlwifi 0000:03:00.0: device EEPROM VER=0x715, CALIB=0x6
[    4.226242] iwlwifi 0000:03:00.0: Device SKU: 0X1f0
[    4.227879] iwlwifi 0000:03:00.0: Valid Tx ant: 0X3, Valid Rx ant: 0X3
[    4.229742] iwlwifi 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[    4.239565] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:21:cc:63:7c:f4
[    4.241024] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    4.242393] e1000e 0000:00:19.0: eth0: MAC: 10, PHY: 11, PBA No: 1000FF-0FF
[    4.243852] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    4.246091] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    4.247768] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.249505] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.249511] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    4.251439] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    4.253000] ehci_hcd 0000:00:1a.0: debug port 2
[    4.255722] iwlwifi 0000:03:00.0: loaded firmware version 17.168.5.3 build 42301
[    4.257564] Registered led device: phy0-led
[    4.258525] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    4.258554] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xd262a000
[    4.269524] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[    4.273551] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    4.275289] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    4.276718] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.277950] usb usb1: Product: EHCI Host Controller
[    4.279141] usb usb1: Manufacturer: Linux 3.1.0-lis-01804-g761d49b ehci_hcd
[    4.280363] usb usb1: SerialNumber: 0000:00:1a.0
[    4.281634] hub 1-0:1.0: USB hub found
[    4.282817] hub 1-0:1.0: 3 ports detected
[    4.284263] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    4.285446] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    4.286596] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    4.287812] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.287816] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    4.288973] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    4.290139] ehci_hcd 0000:00:1d.0: debug port 2
[    4.295121] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    4.295137] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xd2629000
[    4.303842] udev[933]: renamed network interface wlan0 to wlan1
[    4.310158] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    4.311368] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    4.312502] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.313656] usb usb2: Product: EHCI Host Controller
[    4.314870] usb usb2: Manufacturer: Linux 3.1.0-lis-01804-g761d49b ehci_hcd
[    4.316449] usb usb2: SerialNumber: 0000:00:1d.0
[    4.317658] hub 2-0:1.0: USB hub found
[    4.319198] hub 2-0:1.0: 3 ports detected
[    4.321126] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    4.322710] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[    4.322742] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[    4.360077] hda_codec: CX20590: BIOS auto-probing.
[    4.362569] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input6
[    4.589549] usb 1-1: new high speed USB device number 2 using ehci_hcd
[    4.602961] firewire_core: created device fw0: GUID 0021cc200607d02f, S400
[    4.712913] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    4.714038] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.715434] hub 1-1:1.0: USB hub found
[    4.717016] hub 1-1:1.0: 6 ports detected
[    4.828978] usb 2-1: new high speed USB device number 2 using ehci_hcd
[    4.913647] Synaptics Touchpad, model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd047b3/0xb40000/0xa0000
[    4.914860] serio: Synaptics pass-through port at isa0060/serio1/input0
[    4.952324] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    4.953558] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.954871] hub 2-1:1.0: USB hub found
[    4.956301] hub 2-1:1.0: 8 ports detected
[    4.972415] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input7
[    5.025385] usb 1-1.3: new full speed USB device number 3 using ehci_hcd
[    5.109875] usb 1-1.3: New USB device found, idVendor=147e, idProduct=2016
[    5.111101] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.112585] usb 1-1.3: Product: Biometric Coprocessor
[    5.112588] usb 1-1.3: Manufacturer: UPEK
[    5.178345] usb 1-1.4: new full speed USB device number 4 using ehci_hcd
[    5.180102] EXT4-fs (sdb2): re-mounted. Opts: (null)
[    5.204207] EXT4-fs (sdb2): re-mounted. Opts: errors=remount-ro,discard
[    5.266143] usb 1-1.4: New USB device found, idVendor=0a5c, idProduct=217f
[    5.266146] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    5.266149] usb 1-1.4: Product: Broadcom Bluetooth Device
[    5.266151] usb 1-1.4: Manufacturer: Broadcom Corp
[    5.266153] usb 1-1.4: SerialNumber: CCAF78EC8B4F
[    5.289729] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    5.312856] Bluetooth: Core ver 2.16
[    5.312879] NET: Registered protocol family 31
[    5.312880] Bluetooth: HCI device and connection manager initialized
[    5.312883] Bluetooth: HCI socket layer initialized
[    5.312884] Bluetooth: L2CAP socket layer initialized
[    5.313024] Bluetooth: SCO socket layer initialized
[    5.316661] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    5.317056] usbcore: registered new interface driver btusb
[    5.333247] Netfilter messages via NETLINK v0.30.
[    5.337452] ctnetlink v0.93: registering with nfnetlink.
[    5.347844] usb 1-1.6: new high speed USB device number 5 using ehci_hcd
[    5.363702] Bluetooth: RFCOMM TTY layer initialized
[    5.365102] Bluetooth: RFCOMM socket layer initialized
[    5.366417] Bluetooth: RFCOMM ver 1.11
[    5.393381] fuse init (API version 7.17)
[    5.398597] tun: Universal TUN/TAP device driver, 1.6
[    5.399506] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    5.402912] acpi_call: Module loaded successfully
[    5.438390] usb 1-1.6: New USB device found, idVendor=04f2, idProduct=b221
[    5.441018] usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.443588] usb 1-1.6: Product: Integrated Camera
[    5.446195] usb 1-1.6: Manufacturer: Chicony Electronics Co., Ltd.
[    5.502961] Linux video capture interface: v2.00
[    5.512598] uvcvideo: Found UVC 1.00 device Integrated Camera (04f2:b221)
[    5.515653] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input8
[    5.517163] usbcore: registered new interface driver uvcvideo
[    5.518408] USB Video Class driver (1.1.1)
[    6.572895] EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts: errors=remount-ro,discard
[    6.594088] EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: errors=remount-ro
[    6.913782] ip_tables: (C) 2000-2006 Netfilter Core Team
[    7.046128] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    7.784952] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[    7.785972] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[    8.076533] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[    8.080245] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[    8.211080] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[    8.607918] type=1400 audit(1320915697.097:2): apparmor="STATUS" operation="profile_load" name="/sbin/klogd" pid=2333 comm="apparmor_parser"
[    8.612265] type=1400 audit(1320915697.100:3): apparmor="STATUS" operation="profile_load" name="/bin/ping" pid=2331 comm="apparmor_parser"
[    8.613864] type=1400 audit(1320915697.103:4): apparmor="STATUS" operation="profile_load" name="/sbin/syslog-ng" pid=2334 comm="apparmor_parser"
[    8.615437] type=1400 audit(1320915697.103:5): apparmor="STATUS" operation="profile_load" name="/sbin/syslogd" pid=2335 comm="apparmor_parser"
[    8.618968] type=1400 audit(1320915697.107:6): apparmor="STATUS" operation="profile_load" name="/usr/lib/dovecot/deliver" pid=2337 comm="apparmor_parser"
[    8.623407] type=1400 audit(1320915697.110:7): apparmor="STATUS" operation="profile_load" name="/usr/lib/dovecot/imap" pid=2339 comm="apparmor_parser"
[    8.624986] type=1400 audit(1320915697.113:8): apparmor="STATUS" operation="profile_load" name="/usr/lib/dovecot/dovecot-auth" pid=2338 comm="apparmor_parser"
[    8.629446] type=1400 audit(1320915697.117:9): apparmor="STATUS" operation="profile_load" name="/home/tomi/bin/seamonkey-*/seamonkey-bin" pid=2332 comm="apparmor_parser"
[    8.631697] type=1400 audit(1320915697.120:10): apparmor="STATUS" operation="profile_load" name="/usr/lib/dovecot/imap-login" pid=2340 comm="apparmor_parser"
[    8.633363] type=1400 audit(1320915697.120:11): apparmor="STATUS" operation="profile_load" name="/home/tomi/bin/seamonkey-*/seamonkey-bin//libflashplayer.so" pid=2332 comm="apparmor_parser"
[    9.258956] vboxdrv: Found 4 processor cores.
[    9.259076] vboxdrv: fAsync=0 offMin=0x1f2 offMax=0x19da
[    9.260515] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
[    9.261940] vboxdrv: Successfully loaded version 4.1.4_Debian (interface 0x00190000).
[    9.276555] vboxpci: IOMMU not found (not registered)
[    9.356610] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[    9.408752] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[    9.409066] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   10.192146] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   10.192150] Bluetooth: BNEP filters: protocol multicast
[   11.307723] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   11.554510] wlan1: authenticate with 64:d9:89:d4:11:f2 (try 1)
[   11.557109] wlan1: authenticated
[   11.558031] wlan1: associate with 64:d9:89:d4:11:f2 (try 1)
[   11.564415] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input9
[   11.566315] wlan1: RX AssocResp from 64:d9:89:d4:11:f2 (capab=0x431 status=0 aid=27)
[   11.566326] wlan1: associated
[   11.571110] ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
[   11.580124] wlan1: deauthenticated from 64:d9:89:d4:11:f2 (Reason: 10)
[   11.600662] cfg80211: Calling CRDA for country: CZ
[   11.727415] acpi_call: Calling \_SB.PCI0.PEG.VID._DSM
[   11.728187] acpi_call: Call successful: {0x59, 0x00, 0x00, 0x11}
[   11.729083] acpi_call: Calling \_SB.PCI0.PEG.VID._PS3
[   11.729970] thinkpad_acpi: EC reports that Thermal Table has changed
[   12.329484] acpi_call: Call successful: 0x2
[   14.696653] wlan1: authenticate with 64:d9:89:d4:11:f2 (try 1)
[   14.699305] wlan1: authenticated
[   14.700138] wlan1: associate with 64:d9:89:d4:11:f2 (try 1)
[   14.703626] wlan1: RX AssocResp from 64:d9:89:d4:11:f2 (capab=0x431 status=0 aid=27)
[   14.703628] wlan1: associated
[   15.269076] padlock_aes: VIA PadLock not detected.
[   19.030692] wlan1: deauthenticating from 64:d9:89:d4:11:f2 by local choice (reason=3)
[   19.186593] cfg80211: Calling CRDA to update world regulatory domain
[   35.858738] [drm:pch_irq_handler] *ERROR* PCH poison interrupt
[   40.281864] e1000e: eth0 NIC Link is Up 100 Mbps Half Duplex, Flow Control: None
[   40.281877] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   40.286193] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   40.823488] device eth0 entered promiscuous mode
[   40.875774] device eth0 left promiscuous mode
[   93.125731] e1000e: eth0 NIC Link is Down
[  104.424247] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[  104.477213] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[  104.477625] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  113.914937] wlan1: direct probe to 50:67:f0:8b:6a:f8 (try 1/3)
[  114.113736] wlan1: direct probe to 50:67:f0:8b:6a:f8 (try 2/3)
[  114.117499] wlan1: direct probe responded
[  114.150249] wlan1: authenticate with 50:67:f0:8b:6a:f8 (try 1)
[  114.154689] wlan1: authenticated
[  114.155575] wlan1: associate with 50:67:f0:8b:6a:f8 (try 1)
[  114.159459] wlan1: RX AssocResp from 50:67:f0:8b:6a:f8 (capab=0x411 status=0 aid=4)
[  114.159471] wlan1: associated
[  138.804293] wlan1: deauthenticating from 50:67:f0:8b:6a:f8 by local choice (reason=3)
[  138.951622] cfg80211: Calling CRDA to update world regulatory domain
[  139.455898] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[  139.456036] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[  139.579530] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  145.822738] e1000e: eth0 NIC Link is Up 100 Mbps Half Duplex, Flow Control: None
[  145.822752] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[  145.827051] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  146.746652] device eth0 entered promiscuous mode
[  146.802372] device eth0 left promiscuous mode
[ 2665.258232] audit_printk_skb: 57 callbacks suppressed
[ 2665.258235] type=1400 audit(1320918360.240:31): apparmor="DENIED" operation="open" parent=5409 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libflashplayer.so" name="/usr/lib/mesa-diverted/i386-linux-gnu/libGL.so.1.2" pid=5458 comm="plugin-containe" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
[ 2665.258261] type=1400 audit(1320918360.240:32): apparmor="DENIED" operation="open" parent=5409 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libflashplayer.so" name="/usr/lib/mesa-diverted/i386-linux-gnu/libGL.so.1.2" pid=5458 comm="plugin-containe" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
[ 2665.406574] type=1400 audit(1320918360.390:33): apparmor="DENIED" operation="open" parent=5409 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libflashplayer.so" name="/usr/lib/mesa-diverted/i386-linux-gnu/libGL.so.1.2" pid=5458 comm="plugin-containe" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
[ 2665.406637] type=1400 audit(1320918360.390:34): apparmor="DENIED" operation="open" parent=5409 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libflashplayer.so" name="/usr/lib/mesa-diverted/i386-linux-gnu/libGL.so.1.2" pid=5458 comm="plugin-containe" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
[ 2674.074048] type=1400 audit(1320918369.077:35): apparmor="DENIED" operation="open" parent=5409 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libflashplayer.so" name="/usr/lib/mesa-diverted/i386-linux-gnu/libGL.so.1.2" pid=5458 comm="plugin-containe" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
[ 2674.074111] type=1400 audit(1320918369.077:36): apparmor="DENIED" operation="open" parent=5409 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libflashplayer.so" name="/usr/lib/mesa-diverted/i386-linux-gnu/libGL.so.1.2" pid=5458 comm="plugin-containe" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
[ 4338.363790] type=1400 audit(1320920037.143:37): apparmor="DENIED" operation="open" parent=5409 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libflashplayer.so" name="/usr/lib/mesa-diverted/i386-linux-gnu/libGL.so.1.2" pid=5458 comm="plugin-containe" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
[ 4338.363806] type=1400 audit(1320920037.143:38): apparmor="DENIED" operation="open" parent=5409 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libflashplayer.so" name="/usr/lib/mesa-diverted/i386-linux-gnu/libGL.so.1.2" pid=5458 comm="plugin-containe" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
[ 4338.410570] type=1400 audit(1320920037.190:39): apparmor="DENIED" operation="open" parent=5409 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libnpgoogletalk.so" name="/home/tomi/bin/seamonkey-2.6a2-2011-10-21/omni.jar" pid=15749 comm="plugin-containe" requested_mask="r" denied_mask="r" fsuid=1000 ouid=1000
[ 4338.410587] type=1400 audit(1320920037.190:40): apparmor="DENIED" operation="open" parent=5409 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libnpgoogletalk.so" name="/home/tomi/bin/seamonkey-2.6a2-2011-10-21/omni.jar" pid=15749 comm="plugin-containe" requested_mask="r" denied_mask="r" fsuid=1000 ouid=1000
[ 4338.454030] type=1400 audit(1320920037.233:41): apparmor="DENIED" operation="open" parent=15749 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libnpgoogletalk.so" name="/proc/15751/fd/" pid=15751 comm="plugin-containe" requested_mask="r" denied_mask="r" fsuid=1000 ouid=1000
[ 4338.493229] type=1400 audit(1320920037.273:42): apparmor="DENIED" operation="open" parent=1 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libnpgoogletalk.so" name="/sys/devices/system/cpu/present" pid=15752 comm="GoogleTalkPlugi" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
[ 4338.493812] type=1400 audit(1320920037.273:43): apparmor="DENIED" operation="open" parent=1 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libnpgoogletalk.so" name="/etc/udev/udev.conf" pid=15752 comm="GoogleTalkPlugi" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
[ 4338.671736] type=1400 audit(1320920037.453:44): apparmor="DENIED" operation="open" parent=5409 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libflashplayer.so" name="/usr/lib/mesa-diverted/i386-linux-gnu/libGL.so.1.2" pid=5458 comm="plugin-containe" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
[ 4338.671754] type=1400 audit(1320920037.453:45): apparmor="DENIED" operation="open" parent=5409 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libflashplayer.so" name="/usr/lib/mesa-diverted/i386-linux-gnu/libGL.so.1.2" pid=5458 comm="plugin-containe" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
[ 4338.761703] type=1400 audit(1320920037.543:46): apparmor="DENIED" operation="open" parent=5409 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libflashplayer.so" name="/usr/lib/mesa-diverted/i386-linux-gnu/libGL.so.1.2" pid=5458 comm="plugin-containe" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
[ 5935.339168] audit_printk_skb: 15 callbacks suppressed
[ 5935.339174] type=1400 audit(1320921637.743:52): apparmor="DENIED" operation="open" parent=5409 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libflashplayer.so" name="/usr/lib/mesa-diverted/i386-linux-gnu/libGL.so.1.2" pid=5458 comm="plugin-containe" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
[ 5935.339208] type=1400 audit(1320921637.743:53): apparmor="DENIED" operation="open" parent=5409 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libflashplayer.so" name="/usr/lib/mesa-diverted/i386-linux-gnu/libGL.so.1.2" pid=5458 comm="plugin-containe" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
[ 5935.478389] type=1400 audit(1320921637.883:54): apparmor="DENIED" operation="open" parent=5409 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libflashplayer.so" name="/usr/lib/mesa-diverted/i386-linux-gnu/libGL.so.1.2" pid=5458 comm="plugin-containe" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
[ 5935.478406] type=1400 audit(1320921637.883:55): apparmor="DENIED" operation="open" parent=5409 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libflashplayer.so" name="/usr/lib/mesa-diverted/i386-linux-gnu/libGL.so.1.2" pid=5458 comm="plugin-containe" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
[ 5938.563373] type=1400 audit(1320921640.977:56): apparmor="DENIED" operation="open" parent=5409 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libflashplayer.so" name="/usr/lib/mesa-diverted/i386-linux-gnu/libGL.so.1.2" pid=5458 comm="plugin-containe" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
[ 5938.563391] type=1400 audit(1320921640.977:57): apparmor="DENIED" operation="open" parent=5409 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libflashplayer.so" name="/usr/lib/mesa-diverted/i386-linux-gnu/libGL.so.1.2" pid=5458 comm="plugin-containe" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
[ 6462.267110] type=1400 audit(1320922165.867:58): apparmor="DENIED" operation="open" parent=5409 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libflashplayer.so" name="/usr/lib/mesa-diverted/i386-linux-gnu/libGL.so.1.2" pid=5458 comm="plugin-containe" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
[ 6462.267127] type=1400 audit(1320922165.867:59): apparmor="DENIED" operation="open" parent=5409 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libflashplayer.so" name="/usr/lib/mesa-diverted/i386-linux-gnu/libGL.so.1.2" pid=5458 comm="plugin-containe" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
[ 6462.390577] type=1400 audit(1320922165.990:60): apparmor="DENIED" operation="open" parent=5409 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libflashplayer.so" name="/usr/lib/mesa-diverted/i386-linux-gnu/libGL.so.1.2" pid=5458 comm="plugin-containe" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
[ 6462.390646] type=1400 audit(1320922165.990:61): apparmor="DENIED" operation="open" parent=5409 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libflashplayer.so" name="/usr/lib/mesa-diverted/i386-linux-gnu/libGL.so.1.2" pid=5458 comm="plugin-containe" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
[ 6463.101938] type=1400 audit(1320922166.703:62): apparmor="DENIED" operation="open" parent=5409 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libflashplayer.so" name="/usr/lib/mesa-diverted/i386-linux-gnu/libGL.so.1.2" pid=5458 comm="plugin-containe" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
[ 6463.101970] type=1400 audit(1320922166.703:63): apparmor="DENIED" operation="open" parent=5409 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libflashplayer.so" name="/usr/lib/mesa-diverted/i386-linux-gnu/libGL.so.1.2" pid=5458 comm="plugin-containe" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
[ 7021.168740] type=1400 audit(1320922726.037:64): apparmor="DENIED" operation="open" parent=5409 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libflashplayer.so" name="/usr/lib/mesa-diverted/i386-linux-gnu/libGL.so.1.2" pid=5458 comm="plugin-containe" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
[ 7021.168782] type=1400 audit(1320922726.037:65): apparmor="DENIED" operation="open" parent=5409 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libflashplayer.so" name="/usr/lib/mesa-diverted/i386-linux-gnu/libGL.so.1.2" pid=5458 comm="plugin-containe" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
[ 7021.317327] type=1400 audit(1320922726.187:66): apparmor="DENIED" operation="open" parent=5409 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libflashplayer.so" name="/usr/lib/mesa-diverted/i386-linux-gnu/libGL.so.1.2" pid=5458 comm="plugin-containe" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
[ 7021.317388] type=1400 audit(1320922726.187:67): apparmor="DENIED" operation="open" parent=5409 profile="/home/tomi/bin/seamonkey-*/seamonkey-bin//libflashplayer.so" name="/usr/lib/mesa-diverted/i386-linux-gnu/libGL.so.1.2" pid=5458 comm="plugin-containe" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
[24655.688725] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[24655.742543] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[24655.746813] ADDRCONF(NETDEV_UP): eth0: link is not ready
[24656.601698] PM: Syncing filesystems ... done.
[24656.627078] Freezing user space processes ... (elapsed 0.01 seconds) done.
[24656.640575] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[24656.829217] sd 2:0:0:0: [sdb] Synchronizing SCSI cache
[24656.829314] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[24656.829559] sd 2:0:0:0: [sdb] Stopping disk
[24657.069555] rtc0: suspend, alarm may wake, ctrl 22
[24657.070092] ehci_hcd 0000:00:1d.0: PCI INT A disabled
[24657.070160] sdhci-pci 0000:0d:00.0: PCI INT A disabled
[24657.070284] ehci_hcd 0000:00:1a.0: PCI INT A disabled
[24657.070482] ACPI handle has no context!
[24657.076301] ACPI handle has no context!
[24657.082911] i915 0000:00:02.0: power state changed by ACPI to D3
[24657.172917] snd_hda_intel 0000:00:1b.0: PCI INT A disabled
[24657.278328] e1000e 0000:00:19.0: PCI INT A disabled
[24657.278426] e1000e 0000:00:19.0: PME# enabled
[24657.278542] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[24659.673498] sd 0:0:0:0: [sda] Stopping disk
[24660.062746] PM: suspend of devices complete after 3416.378 msecs
[24660.089288] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[24660.119261] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[24660.119487] PM: late suspend of devices complete after 56.755 msecs
[24660.120241] ACPI: Preparing to enter system sleep state S3
[24660.269011] PM: Saving platform NVS memory
[24660.269095] Disabling non-boot CPUs ...
[24660.371978] CPU 1 is now offline
[24660.475046] CPU 2 is now offline
[24660.476668] Broke affinity for irq 1
[24660.476689] Broke affinity for irq 23
[24660.578140] CPU 3 is now offline
[24660.578943] Extended CMOS year: 2000
[24660.579757] ACPI: Low-level resume complete
[24660.579825] PM: Restoring platform NVS memory
[24660.580122] Extended CMOS year: 2000
[24660.580163] Enabling non-boot CPUs ...
[24660.580238] Booting Node 0 Processor 1 APIC 0x1
[24660.580262] smpboot cpu 1: start_ip = 99000
[24660.590636] Initializing CPU#1
[24660.591370] Calibrating delay loop (skipped) already calibrated this CPU
[24660.591381] Disabled fast string operations
[24660.612479] Switched to NOHz mode on CPU #1
[24660.662739] CPU1 is up
[24660.663027] Booting Node 0 Processor 2 APIC 0x2
[24660.663487] smpboot cpu 2: start_ip = 99000
[24660.674196] Initializing CPU#2
[24660.674982] Calibrating delay loop (skipped) already calibrated this CPU
[24660.674992] Disabled fast string operations
[24660.695620] Switched to NOHz mode on CPU #2
[24660.745856] CPU2 is up
[24660.746742] Booting Node 0 Processor 3 APIC 0x3
[24660.748022] smpboot cpu 3: start_ip = 99000
[24660.759966] Initializing CPU#3
[24660.760664] Calibrating delay loop (skipped) already calibrated this CPU
[24660.760673] Disabled fast string operations
[24660.782095] Switched to NOHz mode on CPU #3
[24660.832478] CPU3 is up
[24660.835483] ACPI: Waking up from system sleep state S3
[24661.001886] ACPI: \_SB_.PCI0.LPC_.EC__.BAT1 - docking
[24661.028459] ACPI: Unable to dock!
[24661.131613] pcieport 0000:00:01.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[24661.134865] pcieport 0000:00:01.0: restoring config space at offset 0x6 (was 0x0, writing 0x10100)
[24661.138058] pcieport 0000:00:01.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[24661.141219] pcieport 0000:00:01.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100404)
[24661.144427] i915 0000:00:02.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[24661.145406] i915 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900407)
[24661.146289] pci 0000:00:16.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[24661.147183] pci 0000:00:16.0: restoring config space at offset 0x4 (was 0xfed0a004, writing 0xd2625004)
[24661.148086] pci 0000:00:16.0: restoring config space at offset 0x1 (was 0x100006, writing 0x180006)
[24661.148993] serial 0000:00:16.3: restoring config space at offset 0xf (was 0x200, writing 0x20b)
[24661.149898] serial 0000:00:16.3: restoring config space at offset 0x5 (was 0x0, writing 0xd262c000)
[24661.150786] serial 0000:00:16.3: restoring config space at offset 0x4 (was 0x1, writing 0x50b1)
[24661.151681] serial 0000:00:16.3: restoring config space at offset 0x1 (was 0xb00000, writing 0xb00007)
[24661.152587] e1000e 0000:00:19.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[24661.153477] e1000e 0000:00:19.0: restoring config space at offset 0x6 (was 0x1, writing 0x5081)
[24661.154353] e1000e 0000:00:19.0: restoring config space at offset 0x1 (was 0x100002, writing 0x100007)
[24661.155244] ehci_hcd 0000:00:1a.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[24661.156144] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x4 (was 0x0, writing 0xd262a000)
[24661.157024] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900002)
[24661.174673] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[24661.177944] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[24661.181112] snd_hda_intel 0000:00:1b.0: restoring config space at offset 0xf (was 0x100, writing 0x107)
[24661.184403] snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x4 (was 0x4, writing 0xd2620004)
[24661.187677] snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[24661.190944] snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100002)
[24661.194304] pcieport 0000:00:1c.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[24661.197669] pcieport 0000:00:1c.0: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
[24661.201018] pcieport 0000:00:1c.0: restoring config space at offset 0x8 (was 0x0, writing 0xfff0)
[24661.204368] pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0x20000000, writing 0x200000f0)
[24661.207736] pcieport 0000:00:1c.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[24661.211084] pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100004)
[24661.214504] pcieport 0000:00:1c.1: restoring config space at offset 0xf (was 0x200, writing 0x207)
[24661.215486] pcieport 0000:00:1c.1: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
[24661.216370] pcieport 0000:00:1c.1: restoring config space at offset 0x8 (was 0x0, writing 0xd250d250)
[24661.217251] pcieport 0000:00:1c.1: restoring config space at offset 0x7 (was 0x0, writing 0xf0)
[24661.218128] pcieport 0000:00:1c.1: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[24661.218986] pcieport 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
[24661.219881] pcieport 0000:00:1c.3: restoring config space at offset 0xf (was 0x400, writing 0x40b)
[24661.220742] pcieport 0000:00:1c.3: restoring config space at offset 0x9 (was 0x10001, writing 0xd0b1d041)
[24661.221601] pcieport 0000:00:1c.3: restoring config space at offset 0x8 (was 0x0, writing 0xd240d1d0)
[24661.222451] pcieport 0000:00:1c.3: restoring config space at offset 0x7 (was 0x20000000, writing 0x4040)
[24661.223306] pcieport 0000:00:1c.3: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[24661.224151] pcieport 0000:00:1c.3: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
[24661.225023] pcieport 0000:00:1c.4: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[24661.225856] pcieport 0000:00:1c.4: restoring config space at offset 0x9 (was 0x10001, writing 0xd131d0c1)
[24661.226678] pcieport 0000:00:1c.4: restoring config space at offset 0x8 (was 0x0, writing 0xd1c0d140)
[24661.227497] pcieport 0000:00:1c.4: restoring config space at offset 0x7 (was 0x20000000, writing 0x3030)
[24661.228326] pcieport 0000:00:1c.4: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[24661.229144] pcieport 0000:00:1c.4: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
[24661.229976] ehci_hcd 0000:00:1d.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[24661.230778] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x4 (was 0x0, writing 0xd2629000)
[24661.231582] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900002)
[24661.232390] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[24661.233190] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[24661.234017] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00403, writing 0x2b00407)
[24661.234994] iwlwifi 0000:03:00.0: restoring config space at offset 0xf (was 0x100, writing 0x107)
[24661.235826] iwlwifi 0000:03:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xd2500004)
[24661.236629] iwlwifi 0000:03:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[24661.237430] iwlwifi 0000:03:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100006)
[24661.238386] sdhci-pci 0000:0d:00.0: restoring config space at offset 0xf (was 0x1ff, writing 0x10b)
[24661.239264] sdhci-pci 0000:0d:00.0: restoring config space at offset 0x1 (was 0x100002, writing 0x100006)
[24661.240155] firewire_ohci 0000:0d:00.3: restoring config space at offset 0xf (was 0x4ff, writing 0x40b)
[24661.241032] firewire_ohci 0000:0d:00.3: restoring config space at offset 0x1 (was 0x100002, writing 0x100006)
[24661.241937] PM: early resume of devices complete after 110.664 msecs
[24661.243111] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[24661.243129] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[24661.244820] e1000e 0000:00:19.0: PME# disabled
[24661.245705] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[24661.246594] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[24661.246650] i915 0000:00:02.0: power state changed by ACPI to D0
[24661.246671] ahci 0000:00:1f.2: setting latency timer to 64
[24661.246761] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[24661.246774] sd 0:0:0:0: [sda] Starting disk
[24661.246789] sd 2:0:0:0: [sdb] Starting disk
[24661.247102] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[24661.247152] sdhci-pci 0000:0d:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[24661.247155] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[24661.247157] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[24661.247164] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[24661.247166] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[24661.247172] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[24661.247202] i915 0000:00:02.0: power state changed by ACPI to D0
[24661.247205] i915 0000:00:02.0: setting latency timer to 64
[24661.260643] rtc0: resume, ctrl 02
[24661.263298] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[24661.264259] snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[24661.314438] firewire_ohci 0000:0d:00.3: irq 46 for MSI/MSI-X
[24661.317966] firewire_core: skipped bus generations, destroying all nodes
[24661.377483] thinkpad_acpi: fan watchdog: enabling fan
[24661.491112] usb 1-1.4: reset full speed USB device number 4 using ehci_hcd
[24661.567100] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[24661.569591] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[24661.573165] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[24661.578066] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[24661.581281] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[24661.582927] ata5: SATA link down (SStatus 0 SControl 300)
[24661.582947] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[24661.591075] ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[24661.592150] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[24661.593125] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[24661.594185] ata4: SATA link down (SStatus 0 SControl 300)
[24661.595985] ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[24661.597040] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[24661.598062] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[24661.599306] ata3.00: configured for UDMA/133
[24661.605951] btusb 1-1.4:1.0: no reset_resume for driver btusb?
[24661.607156] btusb 1-1.4:1.1: no reset_resume for driver btusb?
[24661.622011] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[24661.625954] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[24661.629936] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[24661.635418] ata1.00: configured for UDMA/100
[24661.670366] usb 1-1.6: reset high speed USB device number 5 using ehci_hcd
[24661.711747] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[24661.716040] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[24661.719939] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[24661.728700] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[24661.732770] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[24661.736580] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[24661.741886] ata2.00: configured for UDMA/66
[24661.746775] sdhci-pci 0000:0d:00.0: setting latency timer to 64
[24661.819911] firewire_core: rediscovered device fw0
[24661.824039] Extended CMOS year: 2000
[24661.827874] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[24661.831702] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[24661.835451] usb 1-1.3: reset full speed USB device number 3 using ehci_hcd
[24661.961923] PM: resume of devices complete after 720.765 msecs
[24661.966276] Restarting tasks ... done.
[24661.969525] video LNXVIDEO:00: Restoring backlight state
[24662.131712] acpi_call: Calling \_SB.PCI0.PEG.VID._DSM
[24662.133390] acpi_call: Call successful: {0x59, 0x00, 0x00, 0x11}
[24662.135313] acpi_call: Calling \_SB.PCI0.PEG.VID._PS3
[24662.137517] thinkpad_acpi: EC reports that Thermal Table has changed
[24662.741856] acpi_call: Call successful: 0x2
[24665.304707] wlan1: authenticate with 00:15:f2:6a:e1:83 (try 1)
[24665.306500] wlan1: authenticated
[24665.306719] wlan1: waiting for beacon from 00:15:f2:6a:e1:83
[24665.391252] wlan1: beacon received
[24665.436007] wlan1: associate with 00:15:f2:6a:e1:83 (try 1)
[24665.439874] wlan1: RX AssocResp from 00:15:f2:6a:e1:83 (capab=0x411 status=0 aid=1)
[24665.439883] wlan1: associated
[24665.453350] ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready

--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename=lspci

00:00.0 Host bridge [0600]: Intel Corporation 2nd Generation Core Processor Family DRAM Controller [8086:0104] (rev 09)
	Subsystem: Lenovo Device [17aa:21ce]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: <access denied>
	Kernel driver in use: agpgart-intel

00:01.0 PCI bridge [0604]: Intel Corporation 2nd Generation Core Processor Family PCI Express Root Port [8086:0101] (rev 09) (prog-if 00 [Normal decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:02.0 VGA compatible controller [0300]: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller [8086:0126] (rev 09) (prog-if 00 [VGA controller])
	Subsystem: Lenovo Device [17aa:21d0]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 41
	Region 0: Memory at d0000000 (64-bit, non-prefetchable) [size=4M]
	Region 2: Memory at c0000000 (64-bit, prefetchable) [size=256M]
	Region 4: I/O ports at 5000 [size=64]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: <access denied>
	Kernel driver in use: i915

00:16.0 Communication controller [0780]: Intel Corporation 6 Series Chipset Family MEI Controller #1 [8086:1c3a] (rev 04)
	Subsystem: Lenovo Device [17aa:21ce]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at d2625000 (64-bit, non-prefetchable) [size=16]
	Capabilities: <access denied>

00:16.3 Serial controller [0700]: Intel Corporation 6 Series Chipset Family KT Controller [8086:1c3d] (rev 04) (prog-if 02 [16550])
	Subsystem: Lenovo Device [17aa:21ce]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 0: I/O ports at 50b0 [size=8]
	Region 1: Memory at d262c000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: serial

00:19.0 Ethernet controller [0200]: Intel Corporation 82579LM Gigabit Network Connection [8086:1502] (rev 04)
	Subsystem: Lenovo Device [17aa:21ce]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 43
	Region 0: Memory at d2600000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at d262b000 (32-bit, non-prefetchable) [size=4K]
	Region 2: I/O ports at 5080 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: e1000e

00:1a.0 USB Controller [0c03]: Intel Corporation 6 Series Chipset Family USB Enhanced Host Controller #2 [8086:1c2d] (rev 04) (prog-if 20 [EHCI])
	Subsystem: Lenovo Device [17aa:21ce]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at d262a000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd

00:1b.0 Audio device [0403]: Intel Corporation 6 Series Chipset Family High Definition Audio Controller [8086:1c20] (rev 04)
	Subsystem: Lenovo Device [17aa:21ce]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 44
	Region 0: Memory at d2620000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge [0604]: Intel Corporation 6 Series Chipset Family PCI Express Root Port 1 [8086:1c10] (rev b4) (prog-if 00 [Normal decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1c.1 PCI bridge [0604]: Intel Corporation 6 Series Chipset Family PCI Express Root Port 2 [8086:1c12] (rev b4) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: d2500000-d25fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1c.3 PCI bridge [0604]: Intel Corporation 6 Series Chipset Family PCI Express Root Port 4 [8086:1c16] (rev b4) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=05, subordinate=0c, sec-latency=0
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: d1d00000-d24fffff
	Prefetchable memory behind bridge: 00000000d0400000-00000000d0bfffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1c.4 PCI bridge [0604]: Intel Corporation 6 Series Chipset Family PCI Express Root Port 5 [8086:1c18] (rev b4) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=0d, subordinate=0d, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: d1400000-d1cfffff
	Prefetchable memory behind bridge: 00000000d0c00000-00000000d13fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1d.0 USB Controller [0c03]: Intel Corporation 6 Series Chipset Family USB Enhanced Host Controller #1 [8086:1c26] (rev 04) (prog-if 20 [EHCI])
	Subsystem: Lenovo Device [17aa:21ce]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at d2629000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd

00:1f.0 ISA bridge [0601]: Intel Corporation 6 Series Chipset Family LPC Controller [8086:1c4f] (rev 04)
	Subsystem: Lenovo Device [17aa:21ce]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: <access denied>

00:1f.2 SATA controller [0106]: Intel Corporation 6 Series Chipset Family 6 port SATA AHCI Controller [8086:1c03] (rev 04) (prog-if 01 [AHCI 1.0])
	Subsystem: Lenovo Device [17aa:21ce]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 42
	Region 0: I/O ports at 50a8 [size=8]
	Region 1: I/O ports at 50bc [size=4]
	Region 2: I/O ports at 50a0 [size=8]
	Region 3: I/O ports at 50b8 [size=4]
	Region 4: I/O ports at 5060 [size=32]
	Region 5: Memory at d2628000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: <access denied>
	Kernel driver in use: ahci

00:1f.3 SMBus [0c05]: Intel Corporation 6 Series Chipset Family SMBus Controller [8086:1c22] (rev 04)
	Subsystem: Lenovo Device [17aa:21ce]
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at d2624000 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at efa0 [size=32]
	Kernel driver in use: i801_smbus

03:00.0 Network controller [0280]: Intel Corporation Centrino Advanced-N 6205 [8086:0085] (rev 34)
	Subsystem: Intel Corporation Centrino Advanced-N 6205 AGN [8086:1311]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 45
	Region 0: Memory at d2500000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: <access denied>
	Kernel driver in use: iwlwifi

0d:00.0 System peripheral [0880]: Ricoh Co Ltd Device [1180:e823] (rev 05) (prog-if 01)
	Subsystem: Lenovo Device [17aa:21ce]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at d1401000 (32-bit, non-prefetchable) [size=256]
	Capabilities: <access denied>
	Kernel driver in use: sdhci-pci

0d:00.3 FireWire (IEEE 1394) [0c00]: Ricoh Co Ltd FireWire Host Controller [1180:e832] (rev 04) (prog-if 10 [OHCI])
	Subsystem: Lenovo Device [17aa:21ce]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin D routed to IRQ 46
	Region 0: Memory at d1400000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: <access denied>
	Kernel driver in use: firewire_ohci


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename=dmidecode

# dmidecode 2.9
SMBIOS 2.6 present.
67 structures occupying 2498 bytes.
Table at 0xBAA9C000.

Handle 0x0000, DMI type 134, 16 bytes
OEM-specific Type
        Header and Data:
                86 10 00 00 00 53 54 4D 20 01 01 00 00 03 01 02
        Strings:
                TPM INFO
                System Reserved

Handle 0x0001, DMI type 4, 42 bytes
Processor Information
        Socket Designation: CPU
        Type: Central Processor
        Family: <OUT OF SPEC>
        Manufacturer: Intel(R) Corporation
        ID: A7 06 02 00 FF FB EB BF
        Version: Intel(R) Core(TM) i5-2520M CPU @ 2.50GHz
        Voltage: 1.2 V
        External Clock: 100 MHz
        Max Speed: 2500 MHz
        Current Speed: 2500 MHz
        Status: Populated, Enabled
        Upgrade: ZIF Socket
        L1 Cache Handle: 0x0002
        L2 Cache Handle: 0x0003
        L3 Cache Handle: 0x0004
        Serial Number: Not Supported by CPU
        Asset Tag: None
        Part Number: None
        Core Count: 2
        Core Enabled: 2
        Thread Count: 4
        Characteristics:
                64-bit capable

Handle 0x0002, DMI type 7, 19 bytes
Cache Information
        Socket Designation: L1-Cache
        Configuration: Enabled, Not Socketed, Level 1
        Operational Mode: Write Through
        Location: Internal
        Installed Size: 64 KB
        Maximum Size: 64 KB
        Supported SRAM Types:
                Synchronous
        Installed SRAM Type: Synchronous
        Speed: Unknown
        Error Correction Type: Single-bit ECC
        System Type: Data
        Associativity: 8-way Set-associative

Handle 0x0003, DMI type 7, 19 bytes
Cache Information
        Socket Designation: L2-Cache
        Configuration: Enabled, Not Socketed, Level 2
        Operational Mode: Write Through
        Location: Internal
        Installed Size: 256 KB
        Maximum Size: 256 KB
        Supported SRAM Types:
                Synchronous
        Installed SRAM Type: Synchronous
        Speed: Unknown
        Error Correction Type: Single-bit ECC
        System Type: Data
        Associativity: 8-way Set-associative

Handle 0x0004, DMI type 7, 19 bytes
Cache Information
        Socket Designation: L3-Cache
        Configuration: Enabled, Not Socketed, Level 3
        Operational Mode: Write Back
        Location: Internal
        Installed Size: 3072 KB
        Maximum Size: 3072 KB
        Supported SRAM Types:
                Synchronous
        Installed SRAM Type: Synchronous
        Speed: Unknown
        Error Correction Type: Single-bit ECC
        System Type: Unified
        Associativity: <OUT OF SPEC>

Handle 0x0005, DMI type 16, 15 bytes
Physical Memory Array
        Location: System Board Or Motherboard
        Use: System Memory
        Error Correction Type: None
        Maximum Capacity: 16 GB
        Error Information Handle: Not Provided
        Number Of Devices: 2

Handle 0x0006, DMI type 17, 28 bytes
Memory Device
        Array Handle: 0x0005
        Error Information Handle: Not Provided
        Total Width: 64 bits
        Data Width: 64 bits
        Size: 4096 MB
        Form Factor: SODIMM
        Set: None
        Locator: ChannelA-DIMM0
        Bank Locator: BANK 0
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 1333 MHz (0.8 ns)
        Manufacturer: Samsung
        Serial Number: C194BFCB
        Asset Tag: 9876543210
        Part Number: M471B5273DH0-CH9  

Handle 0x0007, DMI type 20, 19 bytes
Memory Device Mapped Address
        Starting Address: 0x00000000000
        Ending Address: 0x000FFFFFFFF
        Range Size: 4 GB
        Physical Device Handle: 0x0006
        Memory Array Mapped Address Handle: 0x000A
        Partition Row Position: Unknown
        Interleave Position: 1
        Interleaved Data Depth: 1

Handle 0x0008, DMI type 17, 28 bytes
Memory Device
        Array Handle: 0x0005
        Error Information Handle: Not Provided
        Total Width: 64 bits
        Data Width: 64 bits
        Size: 4096 MB
        Form Factor: SODIMM
        Set: None
        Locator: ChannelB-DIMM0
        Bank Locator: BANK 2
        Type: <OUT OF SPEC>
        Type Detail: Synchronous
        Speed: 1333 MHz (0.8 ns)
        Manufacturer: Kingston
        Serial Number: 4C30D712
        Asset Tag: 9876543210
        Part Number: 99U5428-042.A00G  

Handle 0x0009, DMI type 20, 19 bytes
Memory Device Mapped Address
        Starting Address: 0x00100000000
        Ending Address: 0x001FFFFFFFF
        Range Size: 4 GB
        Physical Device Handle: 0x0008
        Memory Array Mapped Address Handle: 0x000A
        Partition Row Position: Unknown
        Interleave Position: 2
        Interleaved Data Depth: 1

Handle 0x000A, DMI type 19, 15 bytes
Memory Array Mapped Address
        Starting Address: 0x00000000000
        Ending Address: 0x001FFFFFFFF
        Range Size: 8 GB
        Physical Array Handle: 0x0005
        Partition Width: 0

Handle 0x000B, DMI type 129, 8 bytes
OEM-specific Type
        Header and Data:
                81 08 0B 00 01 01 02 01
        Strings:
                Intel_ASF
                Intel_ASF_001

Handle 0x000C, DMI type 130, 20 bytes
OEM-specific Type
        Header and Data:
                82 14 0C 00 24 41 4D 54 01 01 01 01 01 A5 FF 03
                00 00 01 00

Handle 0x000D, DMI type 131, 64 bytes
OEM-specific Type
        Header and Data:
                83 40 0D 00 3F 00 00 00 07 00 00 00 00 00 36 00
                F8 00 4F 1C FF FF FF FF 09 E0 00 00 01 00 07 00
                40 04 0D 00 00 00 00 00 C8 00 02 15 00 00 00 00
                00 00 00 00 F6 00 00 00 76 50 72 6F 00 00 00 00

Handle 0x000E, DMI type 134, 13 bytes
OEM-specific Type
        Header and Data:
                86 0D 0E 00 26 07 11 20 00 00 00 00 00

Handle 0x000F, DMI type 0, 24 bytes
BIOS Information
        Vendor: LENOVO
        Version: 83ET61WW (1.31 )
        Release Date: 07/07/2011
        Address: 0xE0000
        Runtime Size: 128 kB
        ROM Size: 8192 kB
        Characteristics:
                PCI is supported
                PNP is supported
                BIOS is upgradeable
                BIOS shadowing is allowed
                Boot from CD is supported
                Selectable boot is supported
                EDD is supported
                3.5"/720 KB floppy services are supported (int 13h)
                Print screen service is supported (int 5h)
                8042 keyboard services are supported (int 9h)
                Serial services are supported (int 14h)
                Printer services are supported (int 17h)
                CGA/mono video services are supported (int 10h)
                ACPI is supported
                USB legacy is supported
                BIOS boot specification is supported
                Targeted content distribution is supported
        BIOS Revision: 1.31
        Firmware Revision: 1.8

Handle 0x0010, DMI type 1, 27 bytes
System Information
        Manufacturer: LENOVO
        Product Name: 4178A3G
        Version: ThinkPad T420
        Serial Number: R8X1BWW
        UUID: 01208819-0C51-CB11-9E6A-9D9241BE9FCD
        Wake-up Type: Power Switch
        SKU Number: Not Specified
        Family: ThinkPad T420

Handle 0x0011, DMI type 2, 15 bytes
Base Board Information
        Manufacturer: LENOVO
        Product Name: 4178A3G
        Version: Not Available
        Serial Number: 1ZJJR1681BF
        Asset Tag: Not Available
        Features:
                Board is a hosting board
                Board is replaceable
        Location In Chassis: Not Available
        Chassis Handle: 0x0000
        Type: Motherboard
        Contained Object Handles: 0

Handle 0x0012, DMI type 3, 21 bytes
Chassis Information
        Manufacturer: LENOVO
        Type: Notebook
        Lock: Not Present
        Version: Not Available
        Serial Number: R8X1BWW
        Asset Tag: No Asset Information
        Boot-up State: Unknown
        Power Supply State: Unknown
        Thermal State: Unknown
        Security Status: Unknown
        OEM Information: 0x00000000
        Height: Unspecified
        Number Of Power Cords: Unspecified
        Contained Elements: 0

Handle 0x0013, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: Not Available
        Internal Connector Type: None
        External Reference Designator: External Monitor
        External Connector Type: DB-15 female
        Port Type: Video Port

Handle 0x0014, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: Not Available
        Internal Connector Type: None
        External Reference Designator: DisplayPort
        External Connector Type: Other
        Port Type: Video Port

Handle 0x0015, DMI type 126, 9 bytes
Inactive

Handle 0x0016, DMI type 126, 9 bytes
Inactive

Handle 0x0017, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: Not Available
        Internal Connector Type: None
        External Reference Designator: Headphone/Microphone Combo Jack
        External Connector Type: Mini Jack (headphones)
        Port Type: Audio Port

Handle 0x0018, DMI type 126, 9 bytes
Inactive

Handle 0x0019, DMI type 126, 9 bytes
Inactive

Handle 0x001A, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: Not Available
        Internal Connector Type: None
        External Reference Designator: Ethernet
        External Connector Type: RJ-45
        Port Type: Network Port

Handle 0x001B, DMI type 126, 9 bytes
Inactive

Handle 0x001C, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: Not Available
        Internal Connector Type: None
        External Reference Designator: USB 1
        External Connector Type: Access Bus (USB)
        Port Type: USB

Handle 0x001D, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: Not Available
        Internal Connector Type: None
        External Reference Designator: USB 2
        External Connector Type: Access Bus (USB)
        Port Type: USB

Handle 0x001E, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: Not Available
        Internal Connector Type: None
        External Reference Designator: USB 3
        External Connector Type: Access Bus (USB)
        Port Type: USB

Handle 0x001F, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: Not Available
        Internal Connector Type: None
        External Reference Designator: USB/eSATA Combo
        External Connector Type: Other
        Port Type: Other

Handle 0x0020, DMI type 126, 9 bytes
Inactive

Handle 0x0021, DMI type 126, 9 bytes
Inactive

Handle 0x0022, DMI type 126, 9 bytes
Inactive

Handle 0x0023, DMI type 126, 9 bytes
Inactive

Handle 0x0024, DMI type 126, 9 bytes
Inactive

Handle 0x0025, DMI type 126, 9 bytes
Inactive

Handle 0x0026, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: Not Available
        Internal Connector Type: None
        External Reference Designator: IEEE1394
        External Connector Type: IEEE 1394
        Port Type: Firewire (IEEE P1394)

Handle 0x0027, DMI type 126, 9 bytes
Inactive

Handle 0x0028, DMI type 9, 17 bytes
System Slot Information
        Designation: ExpressCard Slot
        Type: x1 PCI Express
        Current Usage: Available
        Length: Other
        ID: 1
        Characteristics:
                Hot-plug devices are supported

Handle 0x0029, DMI type 9, 17 bytes
System Slot Information
        Designation: Media Card Slot
        Type: Other
        Current Usage: Available
        Length: Other
        Characteristics:
                Hot-plug devices are supported

Handle 0x002A, DMI type 126, 17 bytes
Inactive

Handle 0x002B, DMI type 10, 6 bytes
On Board Device Information
        Type: Other
        Status: Enabled
        Description: IBM Embedded Security hardware

Handle 0x002C, DMI type 12, 5 bytes
System Configuration Options

Handle 0x002D, DMI type 13, 22 bytes
BIOS Language Information
        Installable Languages: 1
                en-US
        Currently Installed Language: en-US

Handle 0x002E, DMI type 22, 26 bytes
Portable Battery
        Location: Rear
        Manufacturer: LGC
        Name: 42T4911
        Design Capacity: 47520 mWh
        Design Voltage: 10800 mV
        SBDS Version: 03.01
        Maximum Error: Unknown
        SBDS Serial Number: EAFA
        SBDS Manufacture Date: 2011-06-26
        SBDS Chemistry: LION
        OEM-specific Information: 0x00000000

Handle 0x002F, DMI type 126, 26 bytes
Inactive

Handle 0x0030, DMI type 18, 23 bytes
32-bit Memory Error Information
        Type: OK
        Granularity: Unknown
        Operation: Unknown
        Vendor Syndrome: Unknown
        Memory Array Address: Unknown
        Device Address: Unknown
        Resolution: Unknown

Handle 0x0031, DMI type 21, 7 bytes
Built-in Pointing Device
        Type: Track Point
        Interface: PS/2
        Buttons: 3

Handle 0x0032, DMI type 21, 7 bytes
Built-in Pointing Device
        Type: Touch Pad
        Interface: PS/2
        Buttons: 2

Handle 0x0033, DMI type 131, 22 bytes
OEM-specific Type
        Header and Data:
                83 16 33 00 01 00 00 00 00 00 00 00 00 00 00 00
                00 00 00 00 00 01
        Strings:
                TVT-Enablement

Handle 0x0034, DMI type 136, 6 bytes
OEM-specific Type
        Header and Data:
                88 06 34 00 5A 5A

Handle 0x0035, DMI type 135, 74 bytes
OEM-specific Type
        Header and Data:
                87 4A 35 00 54 50 07 02 42 41 59 20 49 2F 4F 20
                02 00 06 FF 00 00 00 00 00 00 00 FF 00 00 00 00
                00 00 00 FF 00 00 00 00 00 00 00 FF 00 00 00 00
                00 00 00 FF 00 00 00 00 00 00 00 FF 00 00 00 00
                00 00 00 06 00 02 01 03 03 FF

Handle 0x0036, DMI type 140, 19 bytes
OEM-specific Type
        Header and Data:
                8C 13 36 00 4C 45 4E 4F 56 4F 0B 05 01 07 00 00
                00 00 00

Handle 0x0037, DMI type 140, 23 bytes
OEM-specific Type
        Header and Data:
                8C 17 37 00 4C 45 4E 4F 56 4F 0B 06 01 7E 14 00
                00 00 00 00 00 00 00

Handle 0x0038, DMI type 133, 5 bytes
OEM-specific Type
        Header and Data:
                85 05 38 00 01
        Strings:
                KHOIHGIUCCHHII

Handle 0x0039, DMI type 15, 29 bytes
System Event Log
        Area Length: 18 bytes
        Header Start Offset: 0x0000
        Header Length: 16 bytes
        Data Start Offset: 0x0010
        Access Method: General-purpose non-volatile data functions
        Access Address: 0x00F0
        Status: Valid, Not Full
        Change Token: 0x00000000
        Header Format: Type 1
        Supported Log Type Descriptors: 3
        Descriptor 1: POST error
        Data Format 1: POST results bitmap
        Descriptor 2: Single-bit ECC memory error
        Data Format 2: Multiple-event
        Descriptor 3: Multi-bit ECC memory error
        Data Format 3: Multiple-event

Handle 0x003A, DMI type 140, 67 bytes
OEM-specific Type
        Header and Data:
                8C 43 3A 00 4C 45 4E 4F 56 4F 0B 00 01 2F 1D 21
                6E 2C 1B C2 F7 0A 17 F9 4E D9 89 1A 01 01 00 00
                00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                00 68 23 0B CB 5F 93 6B 4B AA 86 D5 1B EC D5 F7
                6A 01 00

Handle 0x003B, DMI type 140, 47 bytes
OEM-specific Type
        Header and Data:
                8C 2F 3B 00 4C 45 4E 4F 56 4F 0B 01 01 09 00 B8
                EF E9 9E BD CC E0 45 19 25 BA 03 D1 BF E9 DA 00
                00 00 00 10 00 10 00 10 01 D0 00 20 01 00 01

Handle 0x003C, DMI type 140, 63 bytes
OEM-specific Type
        Header and Data:
                8C 3F 3C 00 4C 45 4E 4F 56 4F 0B 02 01 00 00 00
                00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

Handle 0x003D, DMI type 140, 17 bytes
OEM-specific Type
        Header and Data:
                8C 11 3D 00 4C 45 4E 4F 56 4F 0B 03 01 00 00 00
                00

Handle 0x003E, DMI type 140, 19 bytes
OEM-specific Type
        Header and Data:
                8C 13 3E 00 4C 45 4E 4F 56 4F 0B 04 01 B2 00 4D
                53 20 00

Handle 0x003F, DMI type 24, 5 bytes
Hardware Security
        Power-On Password Status: Disabled
        Keyboard Password Status: Not Implemented
        Administrator Password Status: Disabled
        Front Panel Reset Status: Not Implemented

Handle 0x0040, DMI type 132, 7 bytes
OEM-specific Type
        Header and Data:
                84 07 40 00 01 18 36

Handle 0x0041, DMI type 135, 18 bytes
OEM-specific Type
        Header and Data:
                87 12 41 00 54 50 07 01 01 C8 01 00 00 00 00 00
                00 00

Handle 0xFEFF, DMI type 127, 4 bytes
End Of Table

--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename=".config"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.1.0 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
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
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_KTIME_SCALAR=y
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION="-lis"
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_FHANDLE=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_HAVE_SPARSE_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_FORCED_THREADING=y
# CONFIG_SPARSE_IRQ is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=32
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_PERF_COUNTERS is not set
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=m
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
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
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
# CONFIG_BLK_DEV_INTEGRITY is not set

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
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_X86_32_IRIS is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
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
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
CONFIG_MCORE2=y
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_CMPXCHG_LOCAL=y
CONFIG_CMPXCHG_DOUBLE=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
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
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CLEANCACHE=y
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x100000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_DEBUG_FUNC_TRACE=y
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
# CONFIG_ACPI_APEI_EINJ is not set
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
# CONFIG_SFI is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_STAT=m
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=m
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_INTEL_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=m
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=m
# CONFIG_HOTPLUG_PCI_FAKE is not set
# CONFIG_HOTPLUG_PCI_COMPAQ is not set
# CONFIG_HOTPLUG_PCI_IBM is not set
CONFIG_HOTPLUG_PCI_ACPI=m
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=m
CONFIG_BINFMT_MISC=m
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_IP_MROUTE=y
# CONFIG_IP_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=y
# CONFIG_INET_LRO is not set
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=m
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
CONFIG_DEFAULT_BIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="bic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=y
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CONNTRACK_MARK=y
# CONFIG_NF_CONNTRACK_SECMARK is not set
# CONFIG_NF_CONNTRACK_EVENTS is not set
# CONFIG_NF_CONNTRACK_TIMESTAMP is not set
CONFIG_NF_CT_PROTO_DCCP=m
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
# CONFIG_NF_CONNTRACK_SNMP is not set
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
# CONFIG_NETFILTER_TPROXY is not set
CONFIG_NETFILTER_XTABLES=m

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_AUDIT is not set
# CONFIG_NETFILTER_XT_TARGET_CHECKSUM is not set
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
# CONFIG_NETFILTER_XT_TARGET_CT is not set
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
# CONFIG_NETFILTER_XT_TARGET_IDLETIMER is not set
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
# CONFIG_NETFILTER_XT_TARGET_TEE is not set
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
# CONFIG_NETFILTER_XT_MATCH_ADDRTYPE is not set
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
# CONFIG_NETFILTER_XT_MATCH_CPU is not set
CONFIG_NETFILTER_XT_MATCH_DCCP=m
# CONFIG_NETFILTER_XT_MATCH_DEVGROUP is not set
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
# CONFIG_NETFILTER_XT_MATCH_OSF is not set
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
# CONFIG_IP_SET is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_NF_NAT_PROTO_DCCP=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
# CONFIG_IP_NF_SECURITY is not set
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_QUEUE=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
# CONFIG_IP6_NF_SECURITY is not set
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
# CONFIG_BRIDGE_EBT_IP6 is not set
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_ULOG=m
# CONFIG_BRIDGE_EBT_NFLOG is not set
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_TFRC_LIB=y

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
# CONFIG_NET_DCCPPROBE is not set
CONFIG_IP_SCTP=m
# CONFIG_NET_SCTPPROBE is not set
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
# CONFIG_RDS is not set
CONFIG_TIPC=m
CONFIG_TIPC_ADVANCED=y
CONFIG_TIPC_PORTS=8191
CONFIG_TIPC_LOG=0
# CONFIG_TIPC_DEBUG is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
CONFIG_STP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
# CONFIG_VLAN_8021Q_GVRP is not set
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
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_PRIO=m
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=m
# CONFIG_NET_SCH_SFB is not set
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_MQPRIO is not set
# CONFIG_NET_SCH_CHOKE is not set
# CONFIG_NET_SCH_QFQ is not set
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
# CONFIG_CLS_U32_PERF is not set
# CONFIG_CLS_U32_MARK is not set
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
# CONFIG_NET_ACT_GACT is not set
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_IPT is not set
# CONFIG_NET_ACT_NAT is not set
# CONFIG_NET_ACT_PEDIT is not set
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
# CONFIG_NET_ACT_CSUM is not set
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_L2CAP=y
CONFIG_BT_SCO=y
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
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
# CONFIG_BT_HCIVHCI is not set
# CONFIG_BT_MRVL is not set
# CONFIG_BT_ATH3K is not set
CONFIG_AF_RXRPC=m
# CONFIG_AF_RXRPC_DEBUG is not set
# CONFIG_RXKAD is not set
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
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=y
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
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

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
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=m
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=8192
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_MISC_DEVICES=y
# CONFIG_AD525X_DPOT is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
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
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set
# CONFIG_IWMC3200TOP is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_SCSI_BNX2X_FCOE is not set
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
# CONFIG_MEGARAID_NEWGEN is not set
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
# CONFIG_SCSI_ISCI is not set
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
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_DH is not set
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
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CS5536 is not set
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
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
# CONFIG_DM_RAID is not set
# CONFIG_DM_LOG_USERSPACE is not set
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
# CONFIG_DM_MULTIPATH_QL is not set
# CONFIG_DM_MULTIPATH_ST is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_DM_FLAKEY is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
# CONFIG_FIREWIRE_NOSY is not set
CONFIG_I2O=m
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
CONFIG_I2O_CONFIG=m
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=m
CONFIG_I2O_BLOCK=m
CONFIG_I2O_SCSI=m
CONFIG_I2O_PROC=m
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_BONDING=m
CONFIG_DUMMY=m
CONFIG_EQUALIZER=m
# CONFIG_NET_FC is not set
CONFIG_MII=m
# CONFIG_IFB is not set
# CONFIG_MACVLAN is not set
CONFIG_NETCONSOLE=m
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=m
# CONFIG_VETH is not set
# CONFIG_VIRTIO_NET is not set
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#
CONFIG_ETHERNET=y
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_VENDOR_ATHEROS is not set
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
# CONFIG_NET_VENDOR_BROCADE is not set
# CONFIG_NET_VENDOR_CHELSIO is not set
# CONFIG_NET_VENDOR_CISCO is not set
# CONFIG_DNET is not set
# CONFIG_NET_VENDOR_DEC is not set
# CONFIG_NET_VENDOR_DLINK is not set
# CONFIG_NET_VENDOR_EMULEX is not set
# CONFIG_NET_VENDOR_EXAR is not set
# CONFIG_NET_VENDOR_HP is not set
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=m
CONFIG_E1000=m
CONFIG_E1000E=m
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
# CONFIG_IXGBE is not set
# CONFIG_IXGBEVF is not set
# CONFIG_NET_VENDOR_I825XX is not set
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
# CONFIG_NET_VENDOR_MARVELL is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MYRI is not set
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
# CONFIG_NET_VENDOR_OKI is not set
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_8139CP is not set
CONFIG_8139TOO=m
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=m
# CONFIG_SC92031 is not set
# CONFIG_NET_VENDOR_RDC is not set
# CONFIG_NET_VENDOR_SEEQ is not set
# CONFIG_NET_VENDOR_SIS is not set
# CONFIG_SFC is not set
# CONFIG_NET_VENDOR_SMSC is not set
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_FDDI is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_PHYLIB is not set
CONFIG_PPP=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOE=m
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
# CONFIG_SLIP is not set
CONFIG_SLHC=m
# CONFIG_TR is not set

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
# CONFIG_USB_NET_CDC_EEM is not set
CONFIG_USB_NET_CDC_NCM=m
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SMSC75XX is not set
# CONFIG_USB_NET_SMSC95XX is not set
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
# CONFIG_USB_NET_MCS7830 is not set
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
# CONFIG_USB_KC2190 is not set
CONFIG_USB_NET_ZAURUS=m
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_HSO is not set
# CONFIG_USB_NET_INT51X1 is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_USB_SIERRA_NET is not set
# CONFIG_USB_VL600 is not set
CONFIG_WLAN=y
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
# CONFIG_ATH_COMMON is not set
CONFIG_B43=m
CONFIG_B43_SSB=y
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
# CONFIG_B43_SDIO is not set
CONFIG_B43_PIO=y
# CONFIG_B43_PHY_N is not set
CONFIG_B43_PHY_LP=y
# CONFIG_B43_PHY_HT is not set
CONFIG_B43_LEDS=y
CONFIG_B43_HWRNG=y
# CONFIG_B43_DEBUG is not set
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMSMAC is not set
# CONFIG_BRCMFMAC is not set
CONFIG_HOSTAP=m
CONFIG_HOSTAP_FIRMWARE=y
CONFIG_HOSTAP_FIRMWARE_NVRAM=y
# CONFIG_HOSTAP_PLX is not set
# CONFIG_HOSTAP_PCI is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
CONFIG_IWLWIFI=m

#
# Debugging Options
#
# CONFIG_IWLWIFI_DEBUG is not set
# CONFIG_IWLWIFI_DEVICE_TRACING is not set
# CONFIG_IWLWIFI_DEVICE_SVTOOL is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_IWM is not set
# CONFIG_LIBERTAS is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
# CONFIG_RT2X00 is not set
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8192CU is not set
# CONFIG_WL1251 is not set
# CONFIG_WL12XX_MENU is not set
# CONFIG_ZD1211RW is not set
# CONFIG_MWIFIEX is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=m
# CONFIG_INPUT_SPARSEKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1280
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=800
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
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
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_AS5011 is not set
CONFIG_JOYSTICK_JOYDUMP=m
CONFIG_JOYSTICK_XPAD=m
# CONFIG_JOYSTICK_XPAD_FF is not set
# CONFIG_JOYSTICK_XPAD_LEDS is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=m
# CONFIG_TABLET_USB_HANWANG is not set
CONFIG_TABLET_USB_KBTAB=m
CONFIG_TABLET_USB_WACOM=m
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_WM97XX is not set
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
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=m
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
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
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=16
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=16
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=m
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_GEODE is not set
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_NVRAM=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=m
CONFIG_TCG_TIS=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_RAMOOPS is not set
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

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
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set
# CONFIG_I2C_EG20T is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set

#
# PPS generators support
#

#
# PTP clock support
#

#
# Enable Device Drivers -> PPS to see the PTP clock options.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ20Z75 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_HWMON=m
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
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_CORETEMP=m
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
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
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_ADS1015 is not set
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
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set
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
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set
CONFIG_MFD_SUPPORT=y
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS6507X is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_CS5535 is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_DVB_CORE=m
CONFIG_DVB_NET=y
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_RC_CORE=m
CONFIG_LIRC=m
CONFIG_RC_MAP=m
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_RC5_SZ_DECODER=m
CONFIG_IR_MCE_KBD_DECODER=m
CONFIG_IR_LIRC_CODEC=m
# CONFIG_IR_ENE is not set
# CONFIG_IR_IMON is not set
# CONFIG_IR_MCEUSB is not set
# CONFIG_IR_ITE_CIR is not set
# CONFIG_IR_FINTEK is not set
# CONFIG_IR_NUVOTON is not set
# CONFIG_IR_REDRAT3 is not set
# CONFIG_IR_STREAMZAP is not set
# CONFIG_IR_WINBOND_CIR is not set
# CONFIG_RC_LOOPBACK is not set
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_CUSTOMISE=y

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_MAX2165=m
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_MEDIA_TUNER_TDA18212=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=m

#
# Audio decoders, processors and mixers
#

#
# RDS decoders
#

#
# Video decoders
#

#
# Video and audio decoders
#

#
# MPEG video encoders
#

#
# Video encoders
#

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#

#
# Miscelaneous helper chips
#
# CONFIG_VIDEO_VIVI is not set
# CONFIG_VIDEO_BT848 is not set
# CONFIG_VIDEO_CPIA2 is not set
# CONFIG_VIDEO_ZORAN is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_CX88 is not set
# CONFIG_VIDEO_CX23885 is not set
# CONFIG_VIDEO_AU0828 is not set
# CONFIG_VIDEO_IVTV is not set
# CONFIG_VIDEO_CX18 is not set
# CONFIG_VIDEO_SAA7164 is not set
# CONFIG_VIDEO_CAFE_CCIC is not set
# CONFIG_VIDEO_SR030PC30 is not set
# CONFIG_VIDEO_NOON010PC30 is not set
# CONFIG_SOC_CAMERA is not set
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
# CONFIG_USB_M5602 is not set
# CONFIG_USB_STV06XX is not set
# CONFIG_USB_GL860 is not set
# CONFIG_USB_GSPCA_BENQ is not set
# CONFIG_USB_GSPCA_CONEX is not set
# CONFIG_USB_GSPCA_CPIA1 is not set
# CONFIG_USB_GSPCA_ETOMS is not set
# CONFIG_USB_GSPCA_FINEPIX is not set
# CONFIG_USB_GSPCA_JEILINJ is not set
# CONFIG_USB_GSPCA_KINECT is not set
# CONFIG_USB_GSPCA_KONICA is not set
# CONFIG_USB_GSPCA_MARS is not set
# CONFIG_USB_GSPCA_MR97310A is not set
# CONFIG_USB_GSPCA_NW80X is not set
# CONFIG_USB_GSPCA_OV519 is not set
# CONFIG_USB_GSPCA_OV534 is not set
# CONFIG_USB_GSPCA_OV534_9 is not set
# CONFIG_USB_GSPCA_PAC207 is not set
# CONFIG_USB_GSPCA_PAC7302 is not set
# CONFIG_USB_GSPCA_PAC7311 is not set
# CONFIG_USB_GSPCA_SE401 is not set
# CONFIG_USB_GSPCA_SN9C2028 is not set
# CONFIG_USB_GSPCA_SN9C20X is not set
# CONFIG_USB_GSPCA_SONIXB is not set
# CONFIG_USB_GSPCA_SONIXJ is not set
# CONFIG_USB_GSPCA_SPCA500 is not set
# CONFIG_USB_GSPCA_SPCA501 is not set
# CONFIG_USB_GSPCA_SPCA505 is not set
# CONFIG_USB_GSPCA_SPCA506 is not set
# CONFIG_USB_GSPCA_SPCA508 is not set
# CONFIG_USB_GSPCA_SPCA561 is not set
# CONFIG_USB_GSPCA_SPCA1528 is not set
# CONFIG_USB_GSPCA_SQ905 is not set
# CONFIG_USB_GSPCA_SQ905C is not set
# CONFIG_USB_GSPCA_SQ930X is not set
# CONFIG_USB_GSPCA_STK014 is not set
# CONFIG_USB_GSPCA_STV0680 is not set
# CONFIG_USB_GSPCA_SUNPLUS is not set
# CONFIG_USB_GSPCA_T613 is not set
# CONFIG_USB_GSPCA_TV8532 is not set
# CONFIG_USB_GSPCA_VC032X is not set
# CONFIG_USB_GSPCA_VICAM is not set
# CONFIG_USB_GSPCA_XIRLINK_CIT is not set
# CONFIG_USB_GSPCA_ZC3XX is not set
# CONFIG_VIDEO_PVRUSB2 is not set
# CONFIG_VIDEO_HDPVR is not set
# CONFIG_VIDEO_EM28XX is not set
# CONFIG_VIDEO_TLG2300 is not set
# CONFIG_VIDEO_CX231XX is not set
# CONFIG_VIDEO_USBVISION is not set
# CONFIG_USB_ET61X251 is not set
# CONFIG_USB_SN9C102 is not set
# CONFIG_USB_PWC is not set
# CONFIG_USB_ZR364XX is not set
# CONFIG_USB_STKWEBCAM is not set
# CONFIG_USB_S2255 is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_I2C_SI4713 is not set
# CONFIG_RADIO_SI4713 is not set
# CONFIG_USB_DSBR is not set
# CONFIG_RADIO_SI470X is not set
# CONFIG_USB_MR800 is not set
# CONFIG_RADIO_TEA5764 is not set
# CONFIG_RADIO_SAA7706H is not set
# CONFIG_RADIO_TEF6862 is not set
# CONFIG_RADIO_WL1273 is not set

#
# Texas Instruments WL128x FM driver (ST based)
#
# CONFIG_RADIO_WL128X is not set
CONFIG_DVB_MAX_ADAPTERS=8
# CONFIG_DVB_DYNAMIC_MINORS is not set
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
CONFIG_DVB_USB=m
# CONFIG_DVB_USB_DEBUG is not set
# CONFIG_DVB_USB_A800 is not set
# CONFIG_DVB_USB_DIBUSB_MB is not set
# CONFIG_DVB_USB_DIBUSB_MC is not set
# CONFIG_DVB_USB_DIB0700 is not set
# CONFIG_DVB_USB_UMT_010 is not set
# CONFIG_DVB_USB_CXUSB is not set
# CONFIG_DVB_USB_M920X is not set
# CONFIG_DVB_USB_GL861 is not set
# CONFIG_DVB_USB_AU6610 is not set
# CONFIG_DVB_USB_DIGITV is not set
# CONFIG_DVB_USB_VP7045 is not set
# CONFIG_DVB_USB_VP702X is not set
# CONFIG_DVB_USB_GP8PSK is not set
# CONFIG_DVB_USB_NOVA_T_USB2 is not set
# CONFIG_DVB_USB_TTUSB2 is not set
CONFIG_DVB_USB_DTT200U=m
# CONFIG_DVB_USB_OPERA1 is not set
# CONFIG_DVB_USB_AF9005 is not set
# CONFIG_DVB_USB_DW2102 is not set
# CONFIG_DVB_USB_CINERGY_T2 is not set
# CONFIG_DVB_USB_ANYSEE is not set
# CONFIG_DVB_USB_DTV5100 is not set
# CONFIG_DVB_USB_AF9015 is not set
# CONFIG_DVB_USB_CE6230 is not set
# CONFIG_DVB_USB_FRIIO is not set
# CONFIG_DVB_USB_EC168 is not set
# CONFIG_DVB_USB_AZ6027 is not set
# CONFIG_DVB_USB_LME2510 is not set
# CONFIG_DVB_USB_TECHNISAT_USB2 is not set
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

#
# Supported Pluto2 Adapters
#
# CONFIG_DVB_PLUTO2 is not set

#
# Supported SDMC DM1105 Adapters
#
# CONFIG_DVB_DM1105 is not set

#
# Supported FireWire (IEEE 1394) Adapters
#
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
# Supported ddbridge ('Octopus') Adapters
#
# CONFIG_DVB_DDBRIDGE is not set

#
# Supported DVB Frontends
#
# CONFIG_DVB_FE_CUSTOMISE is not set

#
# Multistandard (satellite) frontends
#

#
# Multistandard (cable + terrestrial) frontends
#

#
# DVB-S (satellite) frontends
#

#
# DVB-T (terrestrial) frontends
#

#
# DVB-C (cable) frontends
#

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#

#
# ISDB-T (terrestrial) frontends
#

#
# Digital terrestrial only tuners/PLL
#

#
# SEC control devices for DVB-S
#

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_TTM=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_I810 is not set
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_WMT_GE_ROPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
# CONFIG_FB_MODE_HELPERS is not set
# CONFIG_FB_TILEBLITTING is not set

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
# CONFIG_FB_VESA is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I810 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=m
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
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
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
# CONFIG_SND_HRTIMER is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
CONFIG_SND_DUMMY=m
# CONFIG_SND_ALOOP is not set
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
# CONFIG_SND_AC97_POWER_SAVE is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_PREALLOC_SIZE=64
# CONFIG_SND_HDA_HWDEP is not set
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=1
# CONFIG_SND_HDA_INPUT_JACK is not set
# CONFIG_SND_HDA_PATCH_LOADER is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_ENABLE_REALTEK_QUIRKS=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_HDMI=y
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CA0132=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
# CONFIG_SND_HDA_POWER_SAVE is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
# CONFIG_SND_USB_UA101 is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set
# CONFIG_SND_USB_US122L is not set
# CONFIG_SND_USB_6FIRE is not set
CONFIG_SND_FIREWIRE=y
# CONFIG_SND_FIREWIRE_SPEAKERS is not set
# CONFIG_SND_ISIGHT is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=m
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=m
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
CONFIG_HID_EZKEY=m
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=m
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LOGITECH=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWII_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
CONFIG_HID_NTRIG=m
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=m
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_QUANTA is not set
# CONFIG_HID_ROCCAT is not set
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_SUNPLUS=m
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TOPSEED=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
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
CONFIG_USB_MON=m
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=m
# CONFIG_USB_XHCI_HCD_DEBUGGING is not set
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=m
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
CONFIG_USB_STORAGE_ENE_UB6250=m
# CONFIG_USB_UAS is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m

#
# USB port drivers
#
CONFIG_USB_SERIAL=m
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
# CONFIG_USB_SERIAL_CP210X is not set
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
# CONFIG_USB_SERIAL_IUU is not set
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
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MOTOROLA is not set
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=m
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
# CONFIG_USB_SERIAL_SIEMENS_MPI is not set
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
# CONFIG_USB_SERIAL_SYMBOL is not set
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_VIVOPAY_SERIAL is not set
# CONFIG_USB_SERIAL_ZIO is not set
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=m
CONFIG_USB_IDMOUSE=m
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=m
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_YUREX is not set
CONFIG_USB_GADGET=m
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
# CONFIG_USB_R8A66597 is not set
# CONFIG_USB_M66592 is not set
# CONFIG_USB_AMD5536UDC is not set
# CONFIG_USB_CI13XXX_PCI is not set
# CONFIG_USB_NET2272 is not set
CONFIG_USB_NET2280=m
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
# CONFIG_USB_DUMMY_HCD is not set
CONFIG_USB_GADGET_DUALSPEED=y
CONFIG_USB_ZERO=m
# CONFIG_USB_AUDIO is not set
CONFIG_USB_ETH=m
CONFIG_USB_ETH_RNDIS=y
# CONFIG_USB_ETH_EEM is not set
# CONFIG_USB_G_NCM is not set
CONFIG_USB_GADGETFS=m
# CONFIG_USB_FUNCTIONFS is not set
CONFIG_USB_FILE_STORAGE=m
# CONFIG_USB_FILE_STORAGE_TEST is not set
# CONFIG_USB_MASS_STORAGE is not set
CONFIG_USB_G_SERIAL=m
# CONFIG_USB_MIDI_GADGET is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_USB_G_WEBCAM is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
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
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_VUB300 is not set
CONFIG_MMC_USHC=m
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_DELL_NETBOOKS is not set
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=y
# CONFIG_EDAC_MCE_INJ is not set
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_MCE=y
# CONFIG_EDAC_AMD76X is not set
# CONFIG_EDAC_E7XXX is not set
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82875P is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
CONFIG_EDAC_I7CORE=y
# CONFIG_EDAC_I82860 is not set
# CONFIG_EDAC_R82600 is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

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
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

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
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
CONFIG_VIRTIO=m
CONFIG_VIRTIO_RING=m

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_BALLOON=m
CONFIG_STAGING=y
# CONFIG_VIDEO_GO7007 is not set
# CONFIG_VIDEO_CX25821 is not set
# CONFIG_VIDEO_TM6000 is not set
# CONFIG_DVB_CXD2099 is not set
# CONFIG_USBIP_CORE is not set
# CONFIG_W35UND is not set
# CONFIG_PRISM2_USB is not set
# CONFIG_ECHO is not set
# CONFIG_COMEDI is not set
# CONFIG_ASUS_OLED is not set
# CONFIG_R8187SE is not set
# CONFIG_RTL8192U is not set
# CONFIG_RTL8192E is not set
# CONFIG_R8712U is not set
# CONFIG_RTS_PSTOR is not set
# CONFIG_TRANZPORT is not set
# CONFIG_POHMELFS is not set
# CONFIG_IDE_PHISON is not set
# CONFIG_LINE6_USB is not set
# CONFIG_DRM_VMWGFX is not set
CONFIG_DRM_NOUVEAU=m
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
CONFIG_DRM_NOUVEAU_DEBUG=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
# CONFIG_USB_SERIAL_QUATECH2 is not set
# CONFIG_USB_SERIAL_QUATECH_USB2 is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
# CONFIG_HYPERV is not set
# CONFIG_VME_BUS is not set
# CONFIG_DX_SEP is not set
# CONFIG_IIO is not set
CONFIG_XVMALLOC=y
CONFIG_ZRAM=y
# CONFIG_ZRAM_DEBUG is not set
CONFIG_ZCACHE=y
# CONFIG_FB_SM7XX is not set
# CONFIG_VIDEO_DT3155 is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_LIRC_STAGING is not set
# CONFIG_EASYCAP is not set
# CONFIG_SOLO6X10 is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_USB_ENESTORAGE is not set
# CONFIG_BCM_WIMAX is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
# CONFIG_DRM_PSB is not set
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_HP_ACCEL is not set
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
CONFIG_SENSORS_HDAPS=m
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ASUS_WMI is not set
CONFIG_ACPI_WMI=m
# CONFIG_MSI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
CONFIG_INTEL_IPS=m
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=m
CONFIG_INTEL_OAKTRAIL=m
# CONFIG_SAMSUNG_Q10 is not set
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_DMAR=y
CONFIG_DMAR_DEFAULT_ON=y
CONFIG_DMAR_FLOPPY_WA=y
# CONFIG_VIRT_DRIVERS is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_SIGMA is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m
CONFIG_CUSE=m

#
# Caches
#
CONFIG_FSCACHE=m
# CONFIG_FSCACHE_STATS is not set
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set

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
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-2"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

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
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=y
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
CONFIG_ROMFS_FS=m
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
# CONFIG_NFS_V4_1 is not set
# CONFIG_NFS_FSCACHE is not set
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
# CONFIG_NFS_USE_NEW_IDMAPPER is not set
CONFIG_NFSD=m
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
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_UPCALL is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DFS_UPCALL is not set
CONFIG_CIFS_FSCACHE=y
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
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
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_ATOMIC_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_REDUCED is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_LKDTM is not set
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_SYSCTL_SYSCALL_CHECK=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_EVENT_POWER_TRACING_DEPRECATED=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_ENABLE_DEFAULT_TRACERS is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_KPROBE_EVENT=y
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
# CONFIG_TEST_KSTRTOX is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
# CONFIG_INTEL_TXT is not set
# CONFIG_SECURITY_SELINUX is not set
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=0
CONFIG_SECURITY_APPARMOR_COMPAT_24=y
# CONFIG_IMA is not set
CONFIG_DEFAULT_SECURITY_APPARMOR=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="apparmor"
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
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
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

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
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_586=m
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
CONFIG_CRYPTO_SALSA20_586=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_586=m

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
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
CONFIG_CRYPTO_DEV_GEODE=m
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
CONFIG_VHOST_NET=m
# CONFIG_LGUEST is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
# CONFIG_CRC8 is not set
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_NLATTR=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
CONFIG_LLIST=y

--2oS5YaxWCcQjTEyO--
