Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab2GITkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 15:40:23 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:65313 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab2GITkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 15:40:10 -0400
MIME-Version: 1.0
Date: Mon, 9 Jul 2012 13:40:09 -0600
Message-ID: <CADLC3L3dDOG8BBXR0zWn9SqM0BUotpW0Y+C=HUMEK-SAGCFLJg@mail.gmail.com>
Subject: 3.4.4: Oops in snd_hda_codec_realtek (alc_auto_create_multi_out_ctls)
From: Robert Hancock <hancockrwd@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        Alsa-Devel <alsa-devel@alsa-project.org>, Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got a sort of industrial portable PC that uses a Supermicro C2SBX
motherboard. Running an RHEL6 kernel (2.6.32-ish) it works fine, but
if I run a 3.4.4 kernel (using the kernel-ml builds provided by ELRepo
for RHEL6) it blows up on boot inside snd_hda_codec_realtek. Below is
the dmesg output from bootup up to the oops, after I blacklisted
snd_hda_intel from auto-loading and then manually modprobed it. Is
this a known problem?

The lspci for the controller is:

00:1b.0 Audio device [0403]: Intel Corporation 82801I (ICH9 Family) HD
Audio Controller [8086:293e] (rev 02)
	Subsystem: Super Micro Computer Inc Device [15d9:d980]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at d0620000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0
<64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [130] Root Complex Link <?>
	Kernel modules: snd-hda-intel

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 3.4.4-1.el6.elrepo.x86_64 (mockbuild@Build64R6) (gcc
version 4.4.6 20120305 (Red Hat 4.4.6-4) (GCC) ) #1 SMP Fri Jun 22
21:43:41 EDT 2012
Command line: ro root=/dev/mapper/vg_add-lv_root rd_NO_LUKS
rd_LVM_LV=vg_add/lv_root LANG=en_US.UTF-8 rd_LVM_LV=vg_add/lv_swap
rd_NO_MD quiet SYSFONT=latarcyrheb-sun16 rhgb crashkernel=auto
KEYBOARDTYPE=pc KEYTABLE=us rd_NO_DM
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
 BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fed0000 (usable)
 BIOS-e820: 000000007fed0000 - 000000007fedc000 (ACPI data)
 BIOS-e820: 000000007fedc000 - 000000007fedf000 (ACPI NVS)
 BIOS-e820: 000000007fedf000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
NX (Execute Disable) protection: active
DMI present.
DMI: Supermicro C2SBX/C2SBX, BIOS 2.00 09/17/2010
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x7fed0 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-C7FFF write-protect
  C8000-DFFFF uncachable
  E0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask F80000000 write-back
  1 disabled
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
found SMP MP-table at [ffff8800000f67d0] f67d0
initial memory mapped : 0 - 20000000
Base memory trampoline at [ffff880000097000] 97000 size 20480
init_memory_mapping: 0000000000000000-000000007fed0000
 0000000000 - 007fe00000 page 2M
 007fe00000 - 007fed0000 page 4k
kernel direct mapping tables up to 7fed0000 @ 1fffc000-20000000
RAMDISK: 36f5b000 - 37ff0000
crashkernel: memory value expected
ACPI: RSDP 00000000000f67a0 00024 (v02 PTLTD )
ACPI: XSDT 000000007fed1333 000A4 (v01 PTLTD  ? XSDT   06040000  LTP 00000000)
ACPI: FACP 000000007fedbd7c 000F4 (v03 INTEL           06040000 PTL  00000002)
ACPI: DSDT 000000007fed5447 068C1 (v01  INTEL BEARLAKE 06040000 MSFT 03000001)
ACPI: FACS 000000007fedefc0 00040
ACPI: _MAR 000000007fedbe70 00030 (v01 Intel  OEMDMAR  06040000 LOHR 00000001)
ACPI: MCFG 000000007fedbea0 0003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
ACPI: HPET 000000007fedbedc 00038 (v01 PTLTD  HPETTBL  06040000  LTP 00000001)
ACPI: APIC 000000007fedbf14 00074 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
ACPI: BOOT 000000007fedbf88 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
ACPI: SPCR 000000007fedbfb0 00050 (v01 PTLTD  $UCRTBL$ 06040000 PTL  00000001)
ACPI: SSDT 000000007fed2c4a 0025F (v01  PmRef  Cpu0Tst 00003000 INTL 20050228)
ACPI: SSDT 000000007fed2ba4 000A6 (v01  PmRef  Cpu7Tst 00003000 INTL 20050228)
ACPI: SSDT 000000007fed2afe 000A6 (v01  PmRef  Cpu6Tst 00003000 INTL 20050228)
ACPI: SSDT 000000007fed2a58 000A6 (v01  PmRef  Cpu5Tst 00003000 INTL 20050228)
ACPI: SSDT 000000007fed29b2 000A6 (v01  PmRef  Cpu4Tst 00003000 INTL 20050228)
ACPI: SSDT 000000007fed290c 000A6 (v01  PmRef  Cpu3Tst 00003000 INTL 20050228)
ACPI: SSDT 000000007fed2866 000A6 (v01  PmRef  Cpu2Tst 00003000 INTL 20050228)
ACPI: SSDT 000000007fed27c0 000A6 (v01  PmRef  Cpu1Tst 00003000 INTL 20050228)
ACPI: SSDT 000000007fed13d7 013E9 (v01  PmRef    CpuPm 00003000 INTL 20050228)
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at 0000000000000000-000000007fed0000
Initmem setup node 0 0000000000000000-000000007fed0000
  NODE_DATA [000000007feaa000 - 000000007fecffff]
 [ffffea0000000000-ffffea0001bfffff] PMD ->
[ffff88007d600000-ffff88007f1fffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   empty
Movable zone start PFN for each node
Early memory PFN ranges
    0: 0x00000010 -> 0x0000009c
    0: 0x00000100 -> 0x0007fed0
On node 0 totalpages: 523868
  DMA zone: 56 pages used for memmap
  DMA zone: 5 pages reserved
  DMA zone: 3919 pages, LIFO batch:0
  DMA32 zone: 7108 pages used for memmap
  DMA32 zone: 512780 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x03] address[0xfec10000] gsi_base[24])
IOAPIC[1]: apic_id 3, version 32, address 0xfec10000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0xffffffff base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 64
PM: Registered nosave memory: 000000000009c000 - 000000000009d000
PM: Registered nosave memory: 000000000009d000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
PM: Registered nosave memory: 00000000000d2000 - 00000000000d4000
PM: Registered nosave memory: 00000000000d4000 - 00000000000e4000
PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
Allocating PCI resources starting at 80000000 (gap: 80000000:60000000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:4096 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 28 pages/cpu @ffff88007fc00000 s82368 r8192 d24128 u1048576
pcpu-alloc: s82368 r8192 d24128 u1048576 alloc=1*2097152
pcpu-alloc: [0] 0 1
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 516699
Policy zone: DMA32
Kernel command line: ro root=/dev/mapper/vg_add-lv_root rd_NO_LUKS
rd_LVM_LV=vg_add/lv_root LANG=en_US.UTF-8 rd_LVM_LV=vg_add/lv_swap
rd_NO_MD quiet SYSFONT=latarcyrheb-sun16 rhgb crashkernel=auto
KEYBOARDTYPE=pc KEYTABLE=us rd_NO_DM
PID hash table entries: 4096 (order: 3, 32768 bytes)
xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
Checking aperture...
No AGP bridge found
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 2033980k/2095936k available (5608k kernel code, 464k absent,
61492k reserved, 5658k data, 1532k init)
Hierarchical RCU implementation.
NR_IRQS:262400 nr_irqs:512 16
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
allocated 8388608 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2999.769 MHz processor.
Calibrating delay loop (skipped), value calculated using timer
frequency.. 5999.53 BogoMIPS (lpj=2999769)
pid_max: default: 32768 minimum: 301
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
Initializing cgroup subsys perf_event
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
CPU0: Thermal monitoring handled by SMI
using mwait in idle threads.
ACPI: Core revision 20120320
ftrace: allocating 22392 entries in 88 pages
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel Pentium(R) Dual-Core  CPU      E5700  @ 3.00GHz stepping 0a
Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
NMI watchdog: enabled, takes one hw-pmu counter.
Booting Node   0, Processors  #1 Ok.
CPU1: Thermal monitoring handled by SMI
NMI watchdog: enabled, takes one hw-pmu counter.
Brought up 2 CPUs
Total of 2 processors activated (11999.07 BogoMIPS).
devtmpfs: initialized
PM: Registering ACPI NVS region [mem 0x7fedc000-0x7fedefff] (12288 bytes)
dummy:
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-10] at [mem
0xe0000000-0xe10fffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xe10fffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: EC: Look up EC in DSDT
ACPI: SSDT 000000007fed3764 002A3 (v01  PmRef  Cpu0Ist 00003000 INTL 20050228)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 002A3 (v01  PmRef  Cpu0Ist 00003000 INTL 20050228)
ACPI: SSDT 000000007fed2ea9 00518 (v01  PmRef  Cpu0Cst 00003001 INTL 20050228)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00518 (v01  PmRef  Cpu0Cst 00003001 INTL 20050228)
ACPI: SSDT 000000007fed3a07 00234 (v01  PmRef  Cpu1Ist 00003000 INTL 20050228)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00234 (v01  PmRef  Cpu1Ist 00003000 INTL 20050228)
ACPI: SSDT 000000007fed33c1 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20050228)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20050228)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
PCI: Using host bridge windows from ACPI; if necessary, use
"pci=nocrs" and report a bug
ACPI Error: [CAPB] Namespace lookup failure, AE_ALREADY_EXISTS
(20120320/dsfield-143)
ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node
ffff88007c793970), AE_ALREADY_EXISTS (20120320/psparse-536)
ACPI: Marking method _OSC as Serialized because of AE_ALREADY_EXISTS error
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3f])
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A03:00: host bridge window [mem 0x000d4000-0x000d7fff]
pci_root PNP0A03:00: host bridge window [mem 0x000d8000-0x000dbfff]
pci_root PNP0A03:00: host bridge window [mem 0x000dc000-0x000dffff]
pci_root PNP0A03:00: host bridge window [mem 0x000e0000-0x000e3fff]
pci_root PNP0A03:00: host bridge window [mem 0x80000000-0xdfffffff]
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xfdff]
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
pci_bus 0000:00: root bus resource [mem 0x80000000-0xdfffffff]
pci_bus 0000:00: root bus resource [io  0x0d00-0xfdff]
pci 0000:00:00.0: [8086:29e0] type 00 class 0x060000
pci 0000:00:01.0: [8086:29e1] type 01 class 0x060400
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:06.0: [8086:29e9] type 01 class 0x060400
pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
pci 0000:00:19.0: [8086:10bd] type 00 class 0x020000
pci 0000:00:19.0: reg 10: [mem 0xd0600000-0xd061ffff]
pci 0000:00:19.0: reg 14: [mem 0xd0624000-0xd0624fff]
pci 0000:00:19.0: reg 18: [io  0x1820-0x183f]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.0: [8086:2937] type 00 class 0x0c0300
pci 0000:00:1a.0: reg 20: [io  0x1840-0x185f]
pci 0000:00:1a.1: [8086:2938] type 00 class 0x0c0300
pci 0000:00:1a.1: reg 20: [io  0x1860-0x187f]
pci 0000:00:1a.2: [8086:2939] type 00 class 0x0c0300
pci 0000:00:1a.2: reg 20: [io  0x1880-0x189f]
pci 0000:00:1a.7: [8086:293c] type 00 class 0x0c0320
pci 0000:00:1a.7: reg 10: [mem 0xd0625000-0xd06253ff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: [8086:293e] type 00 class 0x040300
pci 0000:00:1b.0: reg 10: [mem 0xd0620000-0xd0623fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: [8086:2940] type 01 class 0x060400
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.0: [8086:2934] type 00 class 0x0c0300
pci 0000:00:1d.0: reg 20: [io  0x18a0-0x18bf]
pci 0000:00:1d.1: [8086:2935] type 00 class 0x0c0300
pci 0000:00:1d.1: reg 20: [io  0x18c0-0x18df]
pci 0000:00:1d.2: [8086:2936] type 00 class 0x0c0300
pci 0000:00:1d.2: reg 20: [io  0x18e0-0x18ff]
pci 0000:00:1d.7: [8086:293a] type 00 class 0x0c0320
pci 0000:00:1d.7: reg 10: [mem 0xd0626000-0xd06263ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
pci 0000:00:1f.0: [8086:2916] type 00 class 0x060100
pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0290 (mask 0097)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca8 (mask 00af)
pci 0000:00:1f.2: [8086:2922] type 00 class 0x010601
pci 0000:00:1f.2: reg 10: [io  0x1c70-0x1c77]
pci 0000:00:1f.2: reg 14: [io  0x1c64-0x1c67]
pci 0000:00:1f.2: reg 18: [io  0x1c68-0x1c6f]
pci 0000:00:1f.2: reg 1c: [io  0x1c60-0x1c63]
pci 0000:00:1f.2: reg 20: [io  0x1c00-0x1c1f]
pci 0000:00:1f.2: reg 24: [mem 0xd0627000-0xd06277ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.3: [8086:2930] type 00 class 0x0c0500
pci 0000:00:1f.3: reg 10: [mem 0xd0628000-0xd06280ff 64bit]
pci 0000:00:1f.3: reg 20: [io  0x1100-0x111f]
pci 0000:00:1f.6: [8086:2932] type 00 class 0x118000
pci 0000:00:1f.6: reg 10: [mem 0xd0629000-0xd0629fff 64bit]
pci 0000:01:00.0: [10de:06e4] type 00 class 0x030000
pci 0000:01:00.0: reg 10: [mem 0xd1000000-0xd1ffffff]
pci 0000:01:00.0: reg 14: [mem 0xc0000000-0xcfffffff 64bit pref]
pci 0000:01:00.0: reg 1c: [mem 0xd2000000-0xd3ffffff 64bit]
pci 0000:01:00.0: reg 24: [io  0x2000-0x207f]
pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:01.0:   bridge window [mem 0xd1000000-0xd3ffffff]
pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
pci 0000:03:00.0: [104c:8240] type 01 class 0x060400
pci 0000:03:00.0: supports D1 D2
pci 0000:00:06.0: PCI bridge to [bus 03-04]
pci 0000:00:06.0:   bridge window [mem 0xd0100000-0xd01fffff]
pci 0000:04:00.0: [104c:ac60] type 00 class 0x040100
pci 0000:04:00.0: reg 10: [mem 0xd0108000-0xd0108fff]
pci 0000:04:00.0: reg 14: [mem 0xd0100000-0xd0107fff]
pci 0000:04:00.0: supports D1 D2
pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:00.0: PCI bridge to [bus 04-04]
pci 0000:03:00.0:   bridge window [mem 0xd0100000-0xd01fffff]
pci 0000:05:00.0: [8086:032c] type 01 class 0x060400
pci 0000:05:00.0: PXH quirk detected; SHPC device MSI disabled
pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
pci 0000:05:00.1: [8086:0326] type 00 class 0x080020
pci 0000:05:00.1: reg 10: [mem 0xd0300000-0xd0300fff]
pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can
enable it with 'pcie_aspm=force'
pci 0000:00:1c.0: PCI bridge to [bus 05-06]
pci 0000:00:1c.0:   bridge window [mem 0xd0300000-0xd03fffff]
pci 0000:00:1c.0:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
pci 0000:06:07.0: [10ee:ebf1] type 00 class 0x0b4000
pci 0000:06:07.0: reg 10: [mem 0xd0000000-0xd0000fff pref]
pci 0000:05:00.0: PCI bridge to [bus 06-06]
pci 0000:05:00.0:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
pci 0000:11:03.0: [104c:8023] type 00 class 0x0c0010
pci 0000:11:03.0: reg 10: [mem 0xd0204000-0xd02047ff]
pci 0000:11:03.0: reg 14: [mem 0xd0200000-0xd0203fff]
pci 0000:11:03.0: supports D1 D2
pci 0000:11:03.0: PME# supported from D0 D1 D2 D3hot
pci 0000:11:04.0: [1283:8213] type 00 class 0x010185
pci 0000:11:04.0: reg 10: [io  0x3020-0x3027]
pci 0000:11:04.0: reg 14: [io  0x3014-0x3017]
pci 0000:11:04.0: reg 18: [io  0x3018-0x301f]
pci 0000:11:04.0: reg 1c: [io  0x3010-0x3013]
pci 0000:11:04.0: reg 20: [io  0x3000-0x300f]
pci 0000:00:1e.0: PCI bridge to [bus 11-11] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1e.0:   bridge window [mem 0xd0200000-0xd02fffff]
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff]
(subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff]
(subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff]
(subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000dc000-0x000dffff]
(subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000e0000-0x000e3fff]
(subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x80000000-0xdfffffff]
(subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xfdff] (subtractive decode)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1.PXHA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI Error: [CAPB] Namespace lookup failure, AE_ALREADY_EXISTS
(20120320/dsfield-143)
ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node
ffff88007c793970), AE_ALREADY_EXISTS (20120320/psparse-536)
 pci0000:00: Requesting ACPI _OSC control (0x1d)
ACPI Error: [CAPB] Namespace lookup failure, AE_ALREADY_EXISTS
(20120320/dsfield-143)
ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node
ffff88007c793970), AE_ALREADY_EXISTS (20120320/psparse-536)
 pci0000:00: ACPI _OSC request failed (AE_ALREADY_EXISTS), returned
control mask: 0x1d
ACPI _OSC control for PCIe not granted, disabling ASPM
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15)
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:01:00.0
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009cc00 - 000000000009ffff
reserve RAM buffer: 000000007fed0000 - 000000007fffffff
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
nfc: nfc_init: NFC Core ver 0.1
NET: Registered protocol family 39
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [bus 00-3f]
pnp 00:00: [io  0x0cf8-0x0cff]
pnp 00:00: [io  0x0000-0x0cf7 window]
pnp 00:00: [mem 0x000a0000-0x000bffff window]
pnp 00:00: [mem 0x000c0000-0x000c3fff window]
pnp 00:00: [mem 0x000c4000-0x000c7fff window]
pnp 00:00: [mem 0x000c8000-0x000cbfff window]
pnp 00:00: [mem 0x000cc000-0x000cffff window]
pnp 00:00: [mem 0x000d0000-0x000d3fff window]
pnp 00:00: [mem 0x000d4000-0x000d7fff window]
pnp 00:00: [mem 0x000d8000-0x000dbfff window]
pnp 00:00: [mem 0x000dc000-0x000dffff window]
pnp 00:00: [mem 0x000e0000-0x000e3fff window]
pnp 00:00: [mem 0x000e4000-0x000e7fff window]
pnp 00:00: [mem 0x000e8000-0x000ebfff window]
pnp 00:00: [mem 0x000ec000-0x000effff window]
pnp 00:00: [mem 0x000f0000-0x000fffff window]
pnp 00:00: [mem 0x80000000-0xdfffffff window]
pnp 00:00: [io  0x0d00-0xfdff window]
pnp 00:00: [mem 0x00000000 window]
pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
pnp 00:01: [io  0x0010-0x001f]
pnp 00:01: [io  0x0024-0x0025]
pnp 00:01: [io  0x0028-0x0029]
pnp 00:01: [io  0x002c-0x002d]
pnp 00:01: [io  0x002e-0x002f]
pnp 00:01: [io  0x0030-0x0031]
pnp 00:01: [io  0x0034-0x0035]
pnp 00:01: [io  0x0038-0x0039]
pnp 00:01: [io  0x003c-0x003d]
pnp 00:01: [io  0x0072-0x0077]
pnp 00:01: [io  0x0080]
pnp 00:01: [io  0x0090-0x009f]
pnp 00:01: [io  0x00a4-0x00a5]
pnp 00:01: [io  0x00a8-0x00a9]
pnp 00:01: [io  0x00ac-0x00ad]
pnp 00:01: [io  0x00b0-0x00b5]
pnp 00:01: [io  0x00b8-0x00b9]
pnp 00:01: [io  0x00bc-0x00bd]
pnp 00:01: [io  0x0295-0x0296]
pnp 00:01: [io  0x0800-0x080f]
pnp 00:01: [io  0x1000-0x107f]
pnp 00:01: [io  0x1180-0x11bf]
pnp 00:01: [io  0x04d0-0x04d1]
pnp 00:01: [io  0xfe00]
pnp 00:01: [mem 0xfed14000-0xfed17fff]
pnp 00:01: [mem 0xe0000000-0xefffffff]
pnp 00:01: [mem 0xfef00000-0xfeffffff]
system 00:01: [io  0x0295-0x0296] has been reserved
system 00:01: [io  0x0800-0x080f] has been reserved
system 00:01: [io  0x1000-0x107f] has been reserved
system 00:01: [io  0x1180-0x11bf] has been reserved
system 00:01: [io  0x04d0-0x04d1] has been reserved
system 00:01: [io  0xfe00] has been reserved
system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
system 00:01: [mem 0xfef00000-0xfeffffff] has been reserved
system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:02: [io  0x0000-0x000f]
pnp 00:02: [io  0x0081-0x008f]
pnp 00:02: [io  0x00c0-0x00df]
pnp 00:02: [dma 4]
pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:03: [io  0x00f0-0x00fe]
pnp 00:03: [irq 13]
pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:04: [irq 0 disabled]
pnp 00:04: [irq 8]
pnp 00:04: [mem 0xfed00000-0xfed003ff]
pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:05: [io  0x0070-0x0071]
pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:06: [io  0x0061]
pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:07: [mem 0xff800000-0xffffffff]
pnp 00:07: Plug and Play ACPI device, IDs INT0800 (active)
pnp 00:08: [io  0x0060]
pnp 00:08: [io  0x0064]
pnp 00:08: [irq 1]
pnp 00:08: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
pnp 00:09: [irq 12]
pnp 00:09: Plug and Play ACPI device, IDs PNP0f13 (active)
pnp 00:0a: [io  0x03f8-0x03ff]
pnp 00:0a: [irq 4]
pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:0b: [io  0x02f8-0x02ff]
pnp 00:0b: [irq 3]
pnp 00:0b: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:0c: [io  0x03f0-0x03f5]
pnp 00:0c: [io  0x03f7]
pnp 00:0c: [irq 6]
pnp 00:0c: [dma 2]
pnp 00:0c: Plug and Play ACPI device, IDs PNP0700 (active)
pnp 00:0d: [io  0x0378-0x037f]
pnp 00:0d: [io  0x0778-0x077f]
pnp 00:0d: [irq 7]
pnp 00:0d: [dma 3]
pnp 00:0d: Plug and Play ACPI device, IDs PNP0401 (active)
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 05-06] add_size 1000
pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
pci 0000:00:1c.0: BAR 13: assigned [io  0x4000-0x4fff]
pci 0000:01:00.0: BAR 6: can't assign mem pref (size 0x20000)
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:01.0:   bridge window [mem 0xd1000000-0xd3ffffff]
pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
pci 0000:03:00.0: PCI bridge to [bus 04-04]
pci 0000:03:00.0:   bridge window [mem 0xd0100000-0xd01fffff]
pci 0000:00:06.0: PCI bridge to [bus 03-04]
pci 0000:00:06.0:   bridge window [mem 0xd0100000-0xd01fffff]
pci 0000:05:00.0: PCI bridge to [bus 06-06]
pci 0000:05:00.0:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
pci 0000:00:1c.0: PCI bridge to [bus 05-06]
pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
pci 0000:00:1c.0:   bridge window [mem 0xd0300000-0xd03fffff]
pci 0000:00:1c.0:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
pci 0000:00:1e.0: PCI bridge to [bus 11-11]
pci 0000:00:1e.0:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1e.0:   bridge window [mem 0xd0200000-0xd02fffff]
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 6 [mem 0x000d4000-0x000d7fff]
pci_bus 0000:00: resource 7 [mem 0x000d8000-0x000dbfff]
pci_bus 0000:00: resource 8 [mem 0x000dc000-0x000dffff]
pci_bus 0000:00: resource 9 [mem 0x000e0000-0x000e3fff]
pci_bus 0000:00: resource 10 [mem 0x80000000-0xdfffffff]
pci_bus 0000:00: resource 11 [io  0x0d00-0xfdff]
pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:01: resource 1 [mem 0xd1000000-0xd3ffffff]
pci_bus 0000:01: resource 2 [mem 0xc0000000-0xcfffffff 64bit pref]
pci_bus 0000:03: resource 1 [mem 0xd0100000-0xd01fffff]
pci_bus 0000:04: resource 1 [mem 0xd0100000-0xd01fffff]
pci_bus 0000:05: resource 0 [io  0x4000-0x4fff]
pci_bus 0000:05: resource 1 [mem 0xd0300000-0xd03fffff]
pci_bus 0000:05: resource 2 [mem 0xd0000000-0xd00fffff 64bit pref]
pci_bus 0000:06: resource 2 [mem 0xd0000000-0xd00fffff 64bit pref]
pci_bus 0000:11: resource 0 [io  0x3000-0x3fff]
pci_bus 0000:11: resource 1 [mem 0xd0200000-0xd02fffff]
pci_bus 0000:11: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:11: resource 5 [mem 0x000a0000-0x000bffff]
pci_bus 0000:11: resource 6 [mem 0x000d4000-0x000d7fff]
pci_bus 0000:11: resource 7 [mem 0x000d8000-0x000dbfff]
pci_bus 0000:11: resource 8 [mem 0x000dc000-0x000dffff]
pci_bus 0000:11: resource 9 [mem 0x000e0000-0x000e3fff]
pci_bus 0000:11: resource 10 [mem 0x80000000-0xdfffffff]
pci_bus 0000:11: resource 11 [io  0x0d00-0xfdff]
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP: reno registered
UDP hash table entries: 1024 (order: 3, 32768 bytes)
UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
NET: Registered protocol family 1
pci 0000:01:00.0: Boot video device
pci 0000:05:00.0: rerouting interrupts for [8086:032c]
PCI: CLS mismatch (32 != 64), using 64 bytes
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 16980k freed
Simple Boot Flag at 0x36 set to 0x1
audit: initializing netlink socket (disabled)
type=2000 audit(1341861849.373:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 4005
SELinux:  Registering netfilter hooks
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:01.0: irq 64 for MSI/MSI-X
pcieport 0000:00:06.0: irq 65 for MSI/MSI-X
pcieport 0000:00:1c.0: irq 66 for MSI/MSI-X
ioapic: probe of 0000:05:00.1 failed with error -22
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
intel_idle: does not run on family 6 model 23
input: Power Button as
/devices/LNXSYSTM:00/device:00/PNP0A03:00/PNP0C0C:00/input/input0
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
ACPI: Requesting acpi_cpufreq
Monitor-Mwait will be used to enter C-1 state
GHES: HEST is not enabled!
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0b: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
[drm] Initialized drm 1.1.0 20060810
brd: module loaded
loop: module loaded
Fixed MDIO Bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xd0625000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 3.4.4-1.el6.elrepo.x86_64 ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xd0626000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 3.4.4-1.el6.elrepo.x86_64 ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x00001840
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 3.4.4-1.el6.elrepo.x86_64 uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 17, io base 0x00001860
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 3.4.4-1.el6.elrepo.x86_64 uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.2: setting latency timer to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1a.2: irq 18, io base 0x00001880
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 3.4.4-1.el6.elrepo.x86_64 uhci_hcd
usb usb5: SerialNumber: 0000:00:1a.2
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.0: irq 23, io base 0x000018a0
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 3.4.4-1.el6.elrepo.x86_64 uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.0
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.1: irq 22, io base 0x000018c0
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 3.4.4-1.el6.elrepo.x86_64 uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.1
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018e0
usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb8: Product: UHCI Host Controller
usb usb8: Manufacturer: Linux 3.4.4-1.el6.elrepo.x86_64 uhci_hcd
usb usb8: SerialNumber: 0000:00:1d.2
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
usbcore: registered new interface driver libusual
i8042: PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
rtc_cmos 00:05: RTC can wake from S4
rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
cpuidle: using governor ladder
cpuidle: using governor menu
EFI Variables Facility v0.08 2004-May-17
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
TCP: cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
IMA: No TPM chip found, activating TPM-bypass!
rtc_cmos 00:05: setting system clock to 2012-07-09 19:24:11 UTC (1341861851)
Initializing network drop monitor service
Freeing unused kernel memory: 1532k freed
Write protecting the kernel read-only data: 10240k
Freeing unused kernel memory: 516k freed
Freeing unused kernel memory: 1436k freed
dracut: dracut-004-256.el6
dracut: rd_NO_LUKS: removing cryptoluks activation
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
udev: starting version 147
udevd (79): /proc/79/oom_adj is deprecated, please use
/proc/79/oom_score_adj instead.
wmi: Mapper loaded
[drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x298200a2)
[drm] nouveau 0000:01:00.0: Checking PRAMIN for VBIOS
[drm] nouveau 0000:01:00.0: ... appears to be valid
[drm] nouveau 0000:01:00.0: Using VBIOS from PRAMIN
[drm] nouveau 0000:01:00.0: BIT BIOS found
[drm] nouveau 0000:01:00.0: Bios version 62.98.74.00
[drm] nouveau 0000:01:00.0: TMDS table version 2.0
[drm] nouveau 0000:01:00.0: MXM: no VBIOS data, nothing to do
[drm] nouveau 0000:01:00.0: DCB version 4.0
[drm] nouveau 0000:01:00.0: DCB outp 00: 02000300 00000000
[drm] nouveau 0000:01:00.0: DCB outp 01: 01000302 00020030
[drm] nouveau 0000:01:00.0: DCB outp 02: 02011332 00020010
[drm] nouveau 0000:01:00.0: DCB outp 03: 04022310 00000000
[drm] nouveau 0000:01:00.0: DCB conn 00: 00001030
[drm] nouveau 0000:01:00.0: DCB conn 01: 00002161
[drm] nouveau 0000:01:00.0: DCB conn 02: 00000200
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xD695
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xDA9A
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xE2A5
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xE373
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xE629
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xE68E
[drm] nouveau 0000:01:00.0: 0xE68E: Condition still not met after
20ms, skipping following opcodes
[TTM] Zone  kernel: Available graphics memory: 1027222 kiB
[TTM] Initializing pool allocator
[TTM] Initializing DMA pool allocator
[drm] nouveau 0000:01:00.0: Detected 128MiB VRAM (GDDR3)
[drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] No driver support for vblank timestamp query.
[drm] nouveau 0000:01:00.0: 1 available performance level(s)
[drm] nouveau 0000:01:00.0: 3: core 450MHz shader 1111MHz memory
900MHz fanspeed 100%
[drm] nouveau 0000:01:00.0: c: core 566MHz shader 1400MHz memory 499MHz
[drm] nouveau 0000:01:00.0: allocated 1280x1024 fb: 0x310000, bo
ffff8800375b8000
fbcon: nouveaufb (fb0) is primary device
Console: switching to colour frame buffer device 160x64
fb0: nouveaufb frame buffer device
drm: registered panic notifier
[drm] Initialized nouveau 1.0.0 20120316 for 0000:01:00.0 on minor 0
Refined TSC clocksource calibration: 2999.999 MHz.
Switching to clocksource tsc
dracut: Starting plymouth daemon
usb 3-1: new low-speed USB device number 2 using uhci_hcd
dracut: rd_NO_DM: removing DM RAID activation
dracut: rd_NO_MD: removing MD RAID activation
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: irq 67 for MSI/MSI-X
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pmp pio slum part ccc ems sxs
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m2048@0xd0627000 port 0xd0627100 irq 67
ata2: SATA max UDMA/133 abar m2048@0xd0627000 port 0xd0627180 irq 67
ata3: SATA max UDMA/133 abar m2048@0xd0627000 port 0xd0627200 irq 67
ata4: SATA max UDMA/133 abar m2048@0xd0627000 port 0xd0627280 irq 67
ata5: SATA max UDMA/133 abar m2048@0xd0627000 port 0xd0627300 irq 67
ata6: SATA max UDMA/133 abar m2048@0xd0627000 port 0xd0627380 irq 67
usb 3-1: New USB device found, idVendor=0488, idProduct=0020
usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-1: Product: USB GlidePoint
usb 3-1: Manufacturer: Cirque Corporation
input: Cirque Corporation USB GlidePoint as
/devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.0/input/input2
generic-usb 0003:0488:0020.0001: input,hidraw0: USB HID v1.00 Mouse
[Cirque Corporation USB GlidePoint] on usb-0000:00:1a.0-1/input0
usb 3-2: new low-speed USB device number 3 using uhci_hcd
ata5: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
ata3: SATA link down (SStatus 0 SControl 300)
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-8: ST3500418AS, CC46, max UDMA/133
ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata2.00: ATAPI: Optiarc DVD RW AD-7700S, 1.03, max UDMA/100
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      ST3500418AS      CC46 PQ: 0 ANSI: 5
ata2.00: configured for UDMA/100
scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7700S  1.03 PQ: 0 ANSI: 5
usb 3-2: New USB device found, idVendor=1241, idProduct=1503
usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-2: Product: USB Keyboard
usb 3-2: Manufacturer:
firewire_ohci 0000:11:03.0: added OHCI v1.10 device as card 0, 4 IR +
8 IT contexts, quirks 0x2
pata_it8213 0000:11:04.0: version 0.0.3
scsi6 : pata_it8213
scsi7 : pata_it8213
ata7: PATA max UDMA/133 cmd 0x3020 ctl 0x3014 bmdma 0x3000 irq 23
ata8: DUMMY
input:   USB Keyboard as
/devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2:1.0/input/input3
generic-usb 0003:1241:1503.0002: input,hidraw1: USB HID v1.10 Keyboard
[  USB Keyboard] on usb-0000:00:1a.0-2/input0
input:   USB Keyboard as
/devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2:1.1/input/input4
generic-usb 0003:1241:1503.0003: input,hidraw2: USB HID v1.10 Device [
 USB Keyboard] on usb-0000:00:1a.0-2/input1
sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
FDC 0 is a post-1991 82077
firewire_core 0000:11:03.0: created device fw0: GUID 0030480000207f92, S400
dracut: Scanning devices sda2  for LVM logical volumes vg_add/lv_root
vg_add/lv_swap
dracut: inactive '/dev/vg_add/lv_root' [50.00 GiB] inherit
dracut: inactive '/dev/vg_add/lv_home' [411.33 GiB] inherit
dracut: inactive '/dev/vg_add/lv_swap' [3.94 GiB] inherit
EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
dracut: Mounted root filesystem /dev/mapper/vg_add-lv_root
dracut: Loading SELinux policy
type=1404 audit(1341861853.839:2): enforcing=1 old_enforcing=0
auid=4294967295 ses=4294967295
SELinux: 2048 avtab hash slots, 225596 rules.
SELinux: 2048 avtab hash slots, 225596 rules.
SELinux:  9 users, 12 roles, 3576 types, 179 bools, 1 sens, 1024 cats
SELinux:  81 classes, 225596 rules
SELinux:  Permission audit_access in class file not defined in policy.
SELinux:  Permission audit_access in class dir not defined in policy.
SELinux:  Permission execmod in class dir not defined in policy.
SELinux:  Permission audit_access in class lnk_file not defined in policy.
SELinux:  Permission open in class lnk_file not defined in policy.
SELinux:  Permission execmod in class lnk_file not defined in policy.
SELinux:  Permission audit_access in class chr_file not defined in policy.
SELinux:  Permission audit_access in class blk_file not defined in policy.
SELinux:  Permission execmod in class blk_file not defined in policy.
SELinux:  Permission audit_access in class sock_file not defined in policy.
SELinux:  Permission execmod in class sock_file not defined in policy.
SELinux:  Permission audit_access in class fifo_file not defined in policy.
SELinux:  Permission execmod in class fifo_file not defined in policy.
SELinux:  Permission syslog in class capability2 not defined in policy.
SELinux: the above unknown classes and permissions will be allowed
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev dm-0, type ext4), uses xattr
type=1403 audit(1341861854.372:3): policy loaded auid=4294967295 ses=4294967295
dracut:
dracut: Switching root
readahead: starting
udev: starting version 147
WARNING! power/level is deprecated; use power/control instead
EDAC MC: Ver: 2.1.0
EDAC MC0: Giving out device to 'x38_edac' 'x38': DEV 0000:00:00.0
e1000e: Intel(R) PRO/1000 Network Driver - 1.9.5-k
e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: (unregistered net_device): Interrupt Throttling
Rate (ints/sec) set to dynamic conservative mode
e1000e 0000:00:19.0: irq 68 for MSI/MSI-X
e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:25:90:30:a7:eb
e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 6, PBA No: FFFFFF-0FF
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
iTCO_wdt: Found a ICH9R TCO device (Version=2, TCOBASE=0x1060)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
i801_smbus 0000:00:1f.3: enabling device (0001 -> 0003)
input: PC Speaker as /devices/platform/pcspkr/input/input5
microcode: CPU0 sig=0x1067a, pf=0x1, revision=0xa07
microcode: CPU1 sig=0x1067a, pf=0x1, revision=0xa07
microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
microcode: CPU0 updated to revision 0xa0b, date = 2010-09-28
microcode: CPU1 updated to revision 0xa0b, date = 2010-09-28
parport_pc 00:0d: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE,EPP]
sd 0:0:0:0: Attached scsi generic sg0 type 0
sr 1:0:0:0: Attached scsi generic sg1 type 5
ASIHPI driver 4.10.01
snd_asihpi 0000:04:00.0: probe 104c:ac60,175c:5200,0000
snd_asihpi 0000:04:00.0: setting latency timer to 64
snd_asihpi 0000:04:00.0: Incompatible firmware version DSP image 9DD1
!= Driver 40A01
hpioctl.c:420 adapter_probe failed
ppdev: user-space parallel port driver
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
EXT4-fs (dm-0): re-mounted. Opts: (null)
EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
SELinux: initialized (dev sda1, type ext4), uses xattr
EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
SELinux: initialized (dev dm-2, type ext4), uses xattr
Adding 4128764k swap on /dev/mapper/vg_add-lv_swap.  Priority:-1
extents:1 across:4128764k
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
NET: Registered protocol family 10
e1000e 0000:00:19.0: irq 68 for MSI/MSI-X
e1000e 0000:00:19.0: irq 68 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
fuse init (API version 7.18)
eth0: no IPv6 routers present
snd_hda_intel 0000:00:1b.0: irq 69 for MSI/MSI-X
hda_codec: ALC888: SKU not ready 0x411111f0
BUG: unable to handle kernel NULL pointer dereference at 0000000000000002
IP: [<ffffffffa049211f>] alc_auto_create_multi_out_ctls+0xaf/0x3f0
[snd_hda_codec_realtek]
PGD 7b2e6067 PUD 65b80067 PMD 0
Oops: 0000 [#1] SMP
CPU 0
Modules linked in: snd_hda_codec_realtek snd_hda_intel(+)
snd_hda_codec fuse autofs4 cpufreq_ondemand acpi_cpufreq freq_table
mperf ipv6 vhost_net macvtap macvlan tun kvm_intel kvm ppdev
snd_asihpi snd_seq snd_seq_device snd_pcm snd_timer snd_page_alloc
snd_hwdep snd soundcore sg joydev parport_pc parport evdev coretemp
microcode serio_raw pcspkr i2c_i801 iTCO_wdt iTCO_vendor_support
shpchp e1000e x38_edac edac_core ext4 mbcache jbd2 floppy sr_mod cdrom
sd_mod crc_t10dif pata_acpi ata_generic pata_it8213 firewire_ohci
firewire_core crc_itu_t ahci libahci nouveau ttm drm_kms_helper hwmon
mxm_wmi video wmi dm_mirror dm_region_hash dm_log dm_mod [last
unloaded: scsi_wait_scan]

Pid: 2462, comm: modprobe Not tainted 3.4.4-1.el6.elrepo.x86_64 #1
Supermicro C2SBX/C2SBX
RIP: 0010:[<ffffffffa049211f>]  [<ffffffffa049211f>]
alc_auto_create_multi_out_ctls+0xaf/0x3f0 [snd_hda_codec_realtek]
RSP: 0018:ffff8800670edb38  EFLAGS: 00010246
RAX: 0000000000000026 RBX: 0000000000000008 RCX: 0000000000000005
RDX: 0000000000000010 RSI: 0000000000000002 RDI: ffffffffa0497023
RBP: ffff8800670edb98 R08: ffff8800788fd540 R09: 0000000000000000
R10: 0000000000000011 R11: 0000000080042000 R12: ffff880067142000
R13: ffff8800785e8800 R14: 0000000000000004 R15: 0000000000000002
FS:  00007f992c189700(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000002 CR3: 000000007b1aa000 CR4: 00000000000407f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 2462, threadinfo ffff8800670ec000, task ffff88007a740ab0)
Stack:
 ffff8800671423f4 00ff880000000000 0000000000000025 010100000000001b
 ffff8800671423f0 001b000000000005 ffff8800785e8800 ffff8800785e8800
 ffff8800671423f0 ffff88007c1ab090 0000000000000000 00000000fffffff4
Call Trace:
 [<ffffffffa0492a69>] alc_parse_auto_config+0x119/0x6a0 [snd_hda_codec_realtek]
 [<ffffffffa04934a0>] patch_alc882+0xe0/0x1f0 [snd_hda_codec_realtek]
 [<ffffffffa058596c>] snd_hda_codec_configure+0x7c/0x1e0 [snd_hda_codec]
 [<ffffffffa00735c4>] azx_probe+0x180/0x272 [snd_hda_intel]
 [<ffffffff8129314f>] local_pci_probe+0x5f/0xd0
 [<ffffffff812932b1>] __pci_device_probe+0xf1/0x100
 [<ffffffff81372529>] ? get_device+0x19/0x20
 [<ffffffff8129458a>] pci_device_probe+0x3a/0x60
 [<ffffffff813769cc>] really_probe+0x6c/0x310
 [<ffffffff81376cbe>] driver_probe_device+0x4e/0xb0
 [<ffffffff81376dcb>] __driver_attach+0xab/0xb0
 [<ffffffff81376d20>] ? driver_probe_device+0xb0/0xb0
 [<ffffffff81374c94>] bus_for_each_dev+0x64/0x90
 [<ffffffff8137677e>] driver_attach+0x1e/0x20
 [<ffffffff81376188>] bus_add_driver+0x1e8/0x2a0
 [<ffffffffa015a000>] ? 0xffffffffa0159fff
 [<ffffffff81377486>] driver_register+0x76/0x140
 [<ffffffff815717d5>] ? notifier_call_chain+0x55/0x80
 [<ffffffffa015a000>] ? 0xffffffffa0159fff
 [<ffffffff81294816>] __pci_register_driver+0x56/0xd0
 [<ffffffff810792e5>] ? __blocking_notifier_call_chain+0x65/0x80
 [<ffffffffa015a01e>] alsa_card_azx_init+0x1e/0x20 [snd_hda_intel]
 [<ffffffff81002042>] do_one_initcall+0x42/0x180
 [<ffffffff810b2fb0>] sys_init_module+0x90/0x1e0
 [<ffffffff81575d29>] system_call_fastpath+0x16/0x1b
Code: 89 ef 66 89 45 ce 89 ca 44 89 c6 e8 8c 9a ff ff 4d 85 ff 0f 84
5b 01 00 00 45 31 c9 4c 89 fe 48 c7 c7 23 70 49 a0 b9 05 00 00 00 <f3>
a6 0f 84 41 01 00 00 41 0f b7 95 e8 00 00 00 0f b7 c8 66 39
RIP  [<ffffffffa049211f>] alc_auto_create_multi_out_ctls+0xaf/0x3f0
[snd_hda_codec_realtek]
 RSP <ffff8800670edb38>
CR2: 0000000000000002
---[ end trace a2450e533fee9c3e ]---
