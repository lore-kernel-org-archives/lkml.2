Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592Ab1FGSGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:06:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:35833 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab1FGSGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:06:05 -0400
Date: Tue, 7 Jun 2011 20:05:58 +0200
From: Michal Hocko <mhocko@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: alsa-devel@alsa-project.org
Subject: Headphone output doesn't work with 3.0.0-rc* anymore
Message-ID: <20110607180522.GA4004@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="i0/AhcQY5QxfSsSZ"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
before 3.0.0-rc1, when I plugged anything into headphone output of my
laptop, speakers were disabled and the sound has been routed to the
headphone output. This doesn't seem to work anymore starting with
3.0.0-rc1. Speakers stay on even if I plug something to the headphone
output.
Is this a bug or a new behavior that userspace has to cope
with?

I am sorry for the lack of information but I have no idea what to
provide. Let's add dmesg and config at least.
Btw. I have noticed the following message which might be related:

input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11

I do not see anything like this in .39 kernel.

I am using Intel HDA integrated soundcard:
$ lspci -vv
[...]
00:1b.0 Audio device: Intel Corporation N10/ICH 7 Family High Definition Audio Controller (rev 02)
        Subsystem: Fujitsu Limited. Device 1397
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 42
        Region 0: Memory at f0640000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee0300c  Data: 4189
        Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                        ExtTag- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                        Status: NegoPending- InProgress-
                VC1:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=1 ArbSelect=Fixed TC/VC=80
                        Status: NegoPending- InProgress-
        Capabilities: [130 v1] Root Complex Link
                Desc:   PortNumber=0f ComponentID=02 EltType=Config
                Link0:  Desc:   TargetPort=00 TargetComponent=02 AssocRCRB- LinkType=MemMapped LinkValid+
                        Addr:   00000000fed1c000
        Kernel driver in use: HDA Intel
[...]

$ lsmod | grep snd
snd_hda_codec_realtek   236509  1
snd_hda_intel          23614  1
snd_hda_codec          66591  2 snd_hda_codec_realtek,snd_hda_intel
snd_pcm_oss            36561  0
snd_mixer_oss          17908  1 snd_pcm_oss
snd_pcm                64165  3 snd_hda_intel,snd_hda_codec,snd_pcm_oss
snd_seq_oss            29025  0
snd_seq_midi_event     14076  1 snd_seq_oss
snd_seq                42319  4 snd_seq_oss,snd_seq_midi_event
snd_timer              23709  2 snd_pcm,snd_seq
snd_seq_device         13797  2 snd_seq_oss,snd_seq
snd                    49969  12 snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_seq,snd_timer,snd_seq_device
snd_page_alloc         13709  2 snd_hda_intel,snd_pcm

$ grep -I . /sys/devices/pci0000\:00/0000\:00\:1b.0/*
/sys/devices/pci0000:00/0000:00:1b.0/broken_parity_status:0
/sys/devices/pci0000:00/0000:00:1b.0/class:0x040300
/sys/devices/pci0000:00/0000:00:1b.0/consistent_dma_mask_bits:64
/sys/devices/pci0000:00/0000:00:1b.0/device:0x27d8
/sys/devices/pci0000:00/0000:00:1b.0/dma_mask_bits:64
/sys/devices/pci0000:00/0000:00:1b.0/enable:1
/sys/devices/pci0000:00/0000:00:1b.0/irq:42
/sys/devices/pci0000:00/0000:00:1b.0/local_cpulist:0-7
/sys/devices/pci0000:00/0000:00:1b.0/local_cpus:ff
/sys/devices/pci0000:00/0000:00:1b.0/modalias:pci:v00008086d000027D8sv000010CFsd00001397bc04sc03i00
/sys/devices/pci0000:00/0000:00:1b.0/resource:0x00000000f0640000 0x00000000f0643fff 0x0000000000140204
/sys/devices/pci0000:00/0000:00:1b.0/resource:0x0000000000000000 0x0000000000000000 0x0000000000000000
/sys/devices/pci0000:00/0000:00:1b.0/resource:0x0000000000000000 0x0000000000000000 0x0000000000000000
/sys/devices/pci0000:00/0000:00:1b.0/resource:0x0000000000000000 0x0000000000000000 0x0000000000000000
/sys/devices/pci0000:00/0000:00:1b.0/resource:0x0000000000000000 0x0000000000000000 0x0000000000000000
/sys/devices/pci0000:00/0000:00:1b.0/resource:0x0000000000000000 0x0000000000000000 0x0000000000000000
/sys/devices/pci0000:00/0000:00:1b.0/resource:0x0000000000000000 0x0000000000000000 0x0000000000000000
/sys/devices/pci0000:00/0000:00:1b.0/subsystem_device:0x1397
/sys/devices/pci0000:00/0000:00:1b.0/subsystem_vendor:0x10cf
/sys/devices/pci0000:00/0000:00:1b.0/uevent:DRIVER=HDA Intel
/sys/devices/pci0000:00/0000:00:1b.0/uevent:PCI_CLASS=40300
/sys/devices/pci0000:00/0000:00:1b.0/uevent:PCI_ID=8086:27D8
/sys/devices/pci0000:00/0000:00:1b.0/uevent:PCI_SUBSYS_ID=10CF:1397
/sys/devices/pci0000:00/0000:00:1b.0/uevent:PCI_SLOT_NAME=0000:00:1b.0
/sys/devices/pci0000:00/0000:00:1b.0/uevent:MODALIAS=pci:v00008086d000027D8sv000010CFsd00001397bc04sc03i00
/sys/devices/pci0000:00/0000:00:1b.0/vendor:0x8086

Let me know if you need any further information.

--
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9
Czech Republic

--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.3.0.0-rc2-00002-g740daf6"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.0.0-rc2-00002-g740daf6 (root@tiehlicka) (gcc version 4.5.3 (Debian 4.5.3-1) ) #159 SMP PREEMPT Tue Jun 7 14:10:27 CEST 2011
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f6c0000 (usable)
[    0.000000]  BIOS-e820: 000000007f6c0000 - 000000007f6d4000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007f6d4000 - 000000007f700000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007f700000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: FUJITSU SIEMENS LIFEBOOK S7110/FJNB1B5, BIOS Version 1.35  09/10/2008
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x7f6c0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-DBFFF uncachable
[    0.000000]   DC000-DFFFF write-back
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 07F700000 mask FFFF00000 uncachable
[    0.000000]   2 base 07F800000 mask FFF800000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped : 0 - 00c00000
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ b1f000-c00000
[    0.000000] RAMDISK: 37e08000 - 37ff0000
[    0.000000] Allocated new RAMDISK: 37616000 - 377fd1a7
[    0.000000] Move RAMDISK from 0000000037e08000 - 0000000037fef1a6 to 37616000 - 377fd1a6
[    0.000000] ACPI: RSDP 000f5760 00014 (v00 FUJ   )
[    0.000000] ACPI: RSDT 7f6cb93f 00048 (v01 FSC    PC       01350000 FUJ  00000100)
[    0.000000] ACPI: FACP 7f6d3f8c 00074 (v01 FSC    PC       01350000 FUJ  00000100)
[    0.000000] ACPI: DSDT 7f6cb997 06E6A (v01 FUJ    FJNB1B5  01350000 MSFT 0100000E)
[    0.000000] ACPI: FACS 7f6d4fc0 00040
[    0.000000] ACPI: SSDT 7f6d2801 00265 (v01 FUJ    FJNB1B5  01350000 MSFT 0100000E)
[    0.000000] ACPI: MCFG 7f6d2a66 0003C (v01 FUJ    FJNB1B5  01350000 FUJ  00000100)
[    0.000000] ACPI: SSDT 7f6d2aa2 004DC (v01 FUJ    FJNB1B5  01350000 INTL 20050624)
[    0.000000] ACPI: SSDT 7f6d365c 006F2 (v01 FUJ    FJNB1B5  01350000 INTL 20050624)
[    0.000000] ACPI: APIC 7f6d3d4e 00068 (v01 FUJ    FJNB1B5  01350000  LTP 00000000)
[    0.000000] ACPI: HPET 7f6d3db6 00038 (v01 FUJ    FJNB1B5  01350000 FUJ  00000100)
[    0.000000] ACPI: BOOT 7f6d3dee 00028 (v01 FUJ    FJNB1B5  01350000 FUJ  00000100)
[    0.000000] ACPI: SLIC 7f6d3e16 00176 (v01 FSC    PC       01350000 FSC  00000100)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1150MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0007f6c0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007f6c0
[    0.000000] On node 0 totalpages: 521807
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2302 pages used for memmap
[    0.000000]   HighMem zone: 292292 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:78000000)
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 11 pages/cpu @f6000000 s23744 r0 d21312 u2097152
[    0.000000] pcpu-alloc: s23744 r0 d21312 u2097152 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 517729
[    0.000000] Kernel command line: root=UUID=c9f5f89b-4678-47d8-9eea-4fa92bda25e5 ro 
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000377fe:0007f6c0)
[    0.000000] Memory: 2060564k/2087680k available (3433k kernel code, 26664k reserved, 1918k data, 444k init, 1178376k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff17000 - 0xfffff000   ( 928 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc063b000 - 0xc06aa000   ( 444 kB)
[    0.000000]       .data : 0xc045a626 - 0xc063a0c0   (1918 kB)
[    0.000000]       .text : 0xc0100000 - 0xc045a626   (3433 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:512
[    0.000000] CPU 0 irqstacks, hard=f5c0c000 soft=f5c0e000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1828.544 MHz processor.
[    0.004004] Calibrating delay loop (skipped), value calculated using timer frequency.. 3657.08 BogoMIPS (lpj=7314176)
[    0.004259] pid_max: default: 32768 minimum: 301
[    0.004486] Mount-cache hash table entries: 512
[    0.004910] Initializing cgroup subsys perf_event
[    0.005087] CPU: Physical Processor ID: 0
[    0.008005] CPU: Processor Core ID: 0
[    0.008130] mce: CPU supports 6 MCE banks
[    0.008262] CPU0: Thermal monitoring enabled (TM2)
[    0.008391] using mwait in idle threads.
[    0.008597] ACPI: Core revision 20110413
[    0.019236] ftrace: allocating 18260 entries in 36 pages
[    0.029000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.029507] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.069322] CPU0: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz stepping 02
[    0.072003] Performance Events: PEBS fmt0-, Core2 events, Intel PMU driver.
[    0.072003] PEBS disabled due to CPU errata.
[    0.072003] ... version:                2
[    0.072003] ... bit width:              40
[    0.072003] ... generic registers:      2
[    0.072003] ... value mask:             000000ffffffffff
[    0.072003] ... max period:             000000007fffffff
[    0.072003] ... fixed-purpose events:   3
[    0.072003] ... event mask:             0000000700000003
[    0.100032] CPU 1 irqstacks, hard=f5ce0000 soft=f5ce2000
[    0.100035] Booting Node   0, Processors  #1 Ok.
[    0.100203] smpboot cpu 1: start_ip = 9b000
[    0.008000] Initializing CPU#1
[    0.008000] calibrate_delay_direct() timer_rate_max=7314813 timer_rate_min=7314455 pre_start=3104574585 pre_end=3119203881
[    0.008000] calibrate_delay_direct() timer_rate_max=7315665 timer_rate_min=7315324 pre_start=3133833309 pre_end=3148464277
[    0.008000] calibrate_delay_direct() timer_rate_max=7314868 timer_rate_min=7314538 pre_start=3163092396 pre_end=3177721791
[    0.008000] calibrate_delay_direct() timer_rate_max=7314906 timer_rate_min=7314576 pre_start=3192351285 pre_end=3206980757
[    0.008000] calibrate_delay_direct() timer_rate_max=7314901 timer_rate_min=7314576 pre_start=3221610152 pre_end=3236239624
[    0.192036] Brought up 2 CPUs
[    0.192283] Total of 2 processors activated (7314.60 BogoMIPS).
[    0.193265] PM: Registering ACPI NVS region at 7f6d4000 (180224 bytes)
[    0.193568] NET: Registered protocol family 16
[    0.193720] ACPI: bus type pci registered
[    0.193720] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.193720] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.196020] PCI: Using MMCONFIG for extended config space
[    0.196145] PCI: Using configuration type 1 for base access
[    0.204076] bio: create slab <bio-0> at 0
[    0.206494] ACPI: EC: Look up EC in DSDT
[    0.211327] ACPI: SSDT 7f6d45c3 00893 (v01 FUJ    FJNB1B5  01350000 INTL 20050624)
[    0.212524] ACPI: Dynamic OEM Table Load:
[    0.212731] ACPI: SSDT   (null) 00893 (v01 FUJ    FJNB1B5  01350000 INTL 20050624)
[    0.215753] ACPI: SSDT 7f6d2f7e 001A3 (v01 FUJ    FJNB1B5  01350000 INTL 20050624)
[    0.216644] ACPI: Dynamic OEM Table Load:
[    0.216851] ACPI: SSDT   (null) 001A3 (v01 FUJ    FJNB1B5  01350000 INTL 20050624)
[    0.217322] ACPI: SSDT 7f6d3407 001D0 (v01 FUJ    FJNB1B5  01350000 INTL 20050624)
[    0.218211] ACPI: Dynamic OEM Table Load:
[    0.218418] ACPI: SSDT   (null) 001D0 (v01 FUJ    FJNB1B5  01350000 INTL 20050624)
[    0.219103] ACPI: SSDT 7f6d3373 00094 (v01 FUJ    FJNB1B5  01350000 INTL 20050624)
[    0.220045] ACPI: Dynamic OEM Table Load:
[    0.220251] ACPI: SSDT   (null) 00094 (v01 FUJ    FJNB1B5  01350000 INTL 20050624)
[    0.220706] ACPI: SSDT 7f6d35d7 00085 (v01 FUJ    FJNB1B5  01350000 INTL 20050624)
[    0.221594] ACPI: Dynamic OEM Table Load:
[    0.221799] ACPI: SSDT   (null) 00085 (v01 FUJ    FJNB1B5  01350000 INTL 20050624)
[    0.222497] ACPI: Interpreter enabled
[    0.222627] ACPI: (supports S0 S3 S4 S5)
[    0.222940] ACPI: Using IOAPIC for interrupt routing
[    0.236338] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.236610] ACPI: ACPI Dock Station Driver: 2 docks/bays found
[    0.236719] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.237517] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.241078] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.241208] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.241338] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.241543] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    0.241747] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    0.241955] pci_root PNP0A08:00: host bridge window [mem 0x80000000-0xfebfffff]
[    0.244032] pci 0000:00:00.0: [8086:27a0] type 0 class 0x000600
[    0.244086] pci 0000:00:02.0: [8086:27a2] type 0 class 0x000300
[    0.244101] pci 0000:00:02.0: reg 10: [mem 0xf0300000-0xf037ffff]
[    0.244109] pci 0000:00:02.0: reg 14: [io  0x1800-0x1807]
[    0.244117] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff pref]
[    0.244125] pci 0000:00:02.0: reg 1c: [mem 0xf0400000-0xf043ffff]
[    0.244173] pci 0000:00:02.1: [8086:27a6] type 0 class 0x000380
[    0.244185] pci 0000:00:02.1: reg 10: [mem 0xf0380000-0xf03fffff]
[    0.244299] pci 0000:00:1b.0: [8086:27d8] type 0 class 0x000403
[    0.244323] pci 0000:00:1b.0: reg 10: [mem 0xf0640000-0xf0643fff 64bit]
[    0.244412] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.244418] pci 0000:00:1b.0: PME# disabled
[    0.244446] pci 0000:00:1c.0: [8086:27d0] type 1 class 0x000604
[    0.244538] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.244544] pci 0000:00:1c.0: PME# disabled
[    0.244575] pci 0000:00:1c.1: [8086:27d2] type 1 class 0x000604
[    0.244667] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.244672] pci 0000:00:1c.1: PME# disabled
[    0.244703] pci 0000:00:1c.2: [8086:27d4] type 1 class 0x000604
[    0.244795] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.244801] pci 0000:00:1c.2: PME# disabled
[    0.244836] pci 0000:00:1d.0: [8086:27c8] type 0 class 0x000c03
[    0.244896] pci 0000:00:1d.0: reg 20: [io  0x1820-0x183f]
[    0.244939] pci 0000:00:1d.1: [8086:27c9] type 0 class 0x000c03
[    0.245000] pci 0000:00:1d.1: reg 20: [io  0x1840-0x185f]
[    0.245042] pci 0000:00:1d.2: [8086:27ca] type 0 class 0x000c03
[    0.245103] pci 0000:00:1d.2: reg 20: [io  0x1860-0x187f]
[    0.245145] pci 0000:00:1d.3: [8086:27cb] type 0 class 0x000c03
[    0.245205] pci 0000:00:1d.3: reg 20: [io  0x1880-0x189f]
[    0.245261] pci 0000:00:1d.7: [8086:27cc] type 0 class 0x000c03
[    0.245288] pci 0000:00:1d.7: reg 10: [mem 0xf0644000-0xf06443ff]
[    0.245383] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.245390] pci 0000:00:1d.7: PME# disabled
[    0.245415] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.245507] pci 0000:00:1f.0: [8086:27b9] type 0 class 0x000601
[    0.245626] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
[    0.245838] pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
[    0.245969] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at fd00 (mask 007f)
[    0.246178] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 06e8 (mask 0007)
[    0.246427] pci 0000:00:1f.1: [8086:27df] type 0 class 0x000101
[    0.246446] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    0.246459] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    0.246472] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
[    0.246486] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
[    0.246499] pci 0000:00:1f.1: reg 20: [io  0x1810-0x181f]
[    0.246547] pci 0000:00:1f.2: [8086:27c4] type 0 class 0x000101
[    0.246571] pci 0000:00:1f.2: reg 10: [io  0x18d0-0x18d7]
[    0.246584] pci 0000:00:1f.2: reg 14: [io  0x18c4-0x18c7]
[    0.246597] pci 0000:00:1f.2: reg 18: [io  0x18c8-0x18cf]
[    0.246610] pci 0000:00:1f.2: reg 1c: [io  0x18c0-0x18c3]
[    0.246623] pci 0000:00:1f.2: reg 20: [io  0x18b0-0x18bf]
[    0.246637] pci 0000:00:1f.2: reg 24: [mem 0xf0644400-0xf06447ff]
[    0.246674] pci 0000:00:1f.2: PME# supported from D3hot
[    0.246679] pci 0000:00:1f.2: PME# disabled
[    0.246698] pci 0000:00:1f.3: [8086:27da] type 0 class 0x000c05
[    0.246776] pci 0000:00:1f.3: reg 20: [io  0x18e0-0x18ff]
[    0.247056] pci 0000:02:00.0: [11ab:4363] type 0 class 0x000200
[    0.247233] pci 0000:02:00.0: reg 10: [mem 0xf0000000-0xf0003fff 64bit]
[    0.247327] pci 0000:02:00.0: reg 18: [io  0x2000-0x20ff]
[    0.248097] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.248419] pci 0000:02:00.0: supports D1 D2
[    0.248422] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.248447] pci 0000:02:00.0: PME# disabled
[    0.248516] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.248645] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.248652] pci 0000:00:1c.0:   bridge window [mem 0xf0000000-0xf00fffff]
[    0.248661] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.248727] pci 0000:00:1c.1: PCI bridge to [bus 03-04]
[    0.248857] pci 0000:00:1c.1:   bridge window [io  0x0000-0x0000] (disabled)
[    0.248864] pci 0000:00:1c.1:   bridge window [mem 0x00000000-0x000fffff] (disabled)
[    0.248873] pci 0000:00:1c.1:   bridge window [mem 0x00000000-0x000fffff pref] (disabled)
[    0.249042] pci 0000:05:00.0: [8086:4222] type 0 class 0x000280
[    0.249100] pci 0000:05:00.0: reg 10: [mem 0xf0100000-0xf0100fff]
[    0.249447] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    0.249461] pci 0000:05:00.0: PME# disabled
[    0.249517] pci 0000:00:1c.2: PCI bridge to [bus 05-05]
[    0.249647] pci 0000:00:1c.2:   bridge window [io  0x0000-0x0000] (disabled)
[    0.249653] pci 0000:00:1c.2:   bridge window [mem 0x00000000-0x000fffff] (disabled)
[    0.249663] pci 0000:00:1c.2:   bridge window [mem 0x00000000-0x000fffff pref] (disabled)
[    0.249720] pci 0000:08:03.0: [1217:7134] type 2 class 0x000607
[    0.249747] pci 0000:08:03.0: reg 10: [mem 0x00000000-0x00000fff]
[    0.249778] pci 0000:08:03.0: supports D1 D2
[    0.249780] pci 0000:08:03.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.249787] pci 0000:08:03.0: PME# disabled
[    0.249816] pci 0000:08:03.4: [1217:00f7] type 0 class 0x000c00
[    0.249839] pci 0000:08:03.4: reg 10: [mem 0xf0200000-0xf0200fff]
[    0.249853] pci 0000:08:03.4: reg 14: [mem 0xf0201000-0xf02017ff]
[    0.249932] pci 0000:08:03.4: supports D1 D2
[    0.249934] pci 0000:08:03.4: PME# supported from D0 D1 D2 D3hot
[    0.249940] pci 0000:08:03.4: PME# disabled
[    0.250010] pci 0000:00:1e.0: PCI bridge to [bus 08-09] (subtractive decode)
[    0.250144] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.250150] pci 0000:00:1e.0:   bridge window [mem 0xf0200000-0xf02fffff]
[    0.250159] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.250163] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.250166] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.250170] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.250174] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.250177] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.250181] pci 0000:00:1e.0:   bridge window [mem 0x80000000-0xfebfffff] (subtractive decode)
[    0.250237] pci_bus 0000:09: [bus 09-0c] partially hidden behind transparent bridge 0000:08 [bus 08-09]
[    0.250475] pci_bus 0000:00: on NUMA node 0
[    0.250480] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.250731] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.250859] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.250948] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.251026] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.251109]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x19)
[    0.256924] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.260099] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.260794] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.261597] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.262283] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.263085] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.263773] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.264655] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
[    0.265269] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.265269] vgaarb: loaded
[    0.265269] vgaarb: bridge control possible 0000:00:02.0
[    0.265269] SCSI subsystem initialized
[    0.265269] libata version 3.00 loaded.
[    0.265269] usbcore: registered new interface driver usbfs
[    0.265269] usbcore: registered new interface driver hub
[    0.265269] usbcore: registered new device driver usb
[    0.265269] PCI: Using ACPI for IRQ routing
[    0.270301] PCI: pci_cache_line_size set to 64 bytes
[    0.270426] pci 0000:05:00.0: no compatible bridge window for [mem 0xf0100000-0xf0100fff]
[    0.270755] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
[    0.270759] reserve RAM buffer: 000000007f6c0000 - 000000007fffffff 
[    0.270785] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.270785] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.270785] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.280120] Switching to clocksource hpet
[    0.283913] Switched to NOHz mode on CPU #0
[    0.283824] Switched to NOHz mode on CPU #1
[    0.291112] pnp: PnP ACPI init
[    0.291256] ACPI: bus type pnp registered
[    0.291426] pnp 00:00: [mem 0xf8000000-0xfbffffff]
[    0.291548] system 00:00: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.291679] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.292323] pnp 00:01: [bus 00-ff]
[    0.292327] pnp 00:01: [io  0x0000-0x0cf7 window]
[    0.292330] pnp 00:01: [io  0x0cf8-0x0cff]
[    0.292333] pnp 00:01: [io  0x0d00-0xffff window]
[    0.292336] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    0.292339] pnp 00:01: [mem 0x000c0000-0x000c3fff window]
[    0.292343] pnp 00:01: [mem 0x000c4000-0x000c7fff window]
[    0.292345] pnp 00:01: [mem 0x000c8000-0x000cbfff window]
[    0.292348] pnp 00:01: [mem 0x000cc000-0x000cffff window]
[    0.292351] pnp 00:01: [mem 0x000d0000-0x000d3fff window]
[    0.292354] pnp 00:01: [mem 0x000d4000-0x000d7fff window]
[    0.292358] pnp 00:01: [mem 0x000d8000-0x000dbfff window]
[    0.292360] pnp 00:01: [mem 0x000dc000-0x000dffff window]
[    0.292364] pnp 00:01: [mem 0x000e0000-0x000e3fff window]
[    0.292367] pnp 00:01: [mem 0x000e4000-0x000e7fff window]
[    0.292370] pnp 00:01: [mem 0x000e8000-0x000ebfff window]
[    0.292373] pnp 00:01: [mem 0x000ec000-0x000effff window]
[    0.292376] pnp 00:01: [mem 0x000f0000-0x000fffff window]
[    0.292379] pnp 00:01: [mem 0x80000000-0xfebfffff window]
[    0.292382] pnp 00:01: [mem 0x00000000 window]
[    0.292533] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.292660] pnp 00:02: [io  0x0010-0x001f]
[    0.292664] pnp 00:02: [io  0x0024-0x0025]
[    0.292666] pnp 00:02: [io  0x0028-0x0029]
[    0.292669] pnp 00:02: [io  0x002c-0x002d]
[    0.292672] pnp 00:02: [io  0x002e-0x002f]
[    0.292674] pnp 00:02: [io  0x0030-0x0031]
[    0.292677] pnp 00:02: [io  0x0034-0x0035]
[    0.292679] pnp 00:02: [io  0x0038-0x0039]
[    0.292682] pnp 00:02: [io  0x003c-0x003d]
[    0.292685] pnp 00:02: [io  0x0050-0x0053]
[    0.292687] pnp 00:02: [io  0x0072-0x0077]
[    0.292690] pnp 00:02: [io  0x0080]
[    0.292692] pnp 00:02: [io  0x0090-0x009f]
[    0.292695] pnp 00:02: [io  0x00a4-0x00a5]
[    0.292698] pnp 00:02: [io  0x00a8-0x00a9]
[    0.292700] pnp 00:02: [io  0x00ac-0x00ad]
[    0.292703] pnp 00:02: [io  0x00b0-0x00b1]
[    0.292710] pnp 00:02: [io  0x00b2-0x00b3]
[    0.292713] pnp 00:02: [io  0x00b4-0x00b5]
[    0.292716] pnp 00:02: [io  0x00b8-0x00b9]
[    0.292718] pnp 00:02: [io  0x00bc-0x00bd]
[    0.292721] pnp 00:02: [io  0x04d0-0x04d1]
[    0.292724] pnp 00:02: [io  0x0800-0x080f]
[    0.292726] pnp 00:02: [io  0x1000-0x107f]
[    0.292729] pnp 00:02: [io  0x1080-0x10ff]
[    0.292731] pnp 00:02: [io  0x1100-0x111f]
[    0.292734] pnp 00:02: [io  0x1180-0x11bf]
[    0.292737] pnp 00:02: [io  0xf800-0xf87f]
[    0.292739] pnp 00:02: [io  0xf880-0xf8ff]
[    0.292742] pnp 00:02: [io  0xfc00-0xfc7f]
[    0.292745] pnp 00:02: [io  0xfc80-0xfcff]
[    0.292747] pnp 00:02: [io  0xfd0c-0xfd7f]
[    0.292750] pnp 00:02: [io  0xfe00-0xfe01]
[    0.292753] pnp 00:02: [mem 0xf8000000-0xfbffffff]
[    0.292756] pnp 00:02: [mem 0xfed14000-0xfed17fff]
[    0.292758] pnp 00:02: [mem 0xfed18000-0xfed18fff]
[    0.292761] pnp 00:02: [mem 0xfed19000-0xfed19fff]
[    0.292764] pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
[    0.292767] pnp 00:02: [mem 0xfed20000-0xfed3ffff]
[    0.292770] pnp 00:02: [mem 0xfed45000-0xfed8ffff]
[    0.292772] pnp 00:02: [mem 0xfec00000-0xfec00fff]
[    0.292775] pnp 00:02: [mem 0xfee00000-0xfee00fff]
[    0.292778] pnp 00:02: [mem 0xfef00000-0xfeffffff]
[    0.292781] pnp 00:02: [mem 0x000cec00-0x000cefff]
[    0.292784] pnp 00:02: [mem 0xffb00000-0xffbfffff]
[    0.292787] pnp 00:02: [mem 0xfed40000-0xfed44fff]
[    0.292963] system 00:02: [io  0x04d0-0x04d1] has been reserved
[    0.293091] system 00:02: [io  0x0800-0x080f] has been reserved
[    0.293219] system 00:02: [io  0x1000-0x107f] has been reserved
[    0.293347] system 00:02: [io  0x1080-0x10ff] has been reserved
[    0.293474] system 00:02: [io  0x1100-0x111f] has been reserved
[    0.293604] system 00:02: [io  0x1180-0x11bf] has been reserved
[    0.293733] system 00:02: [io  0xf800-0xf87f] has been reserved
[    0.293863] system 00:02: [io  0xf880-0xf8ff] has been reserved
[    0.293991] system 00:02: [io  0xfc00-0xfc7f] has been reserved
[    0.294119] system 00:02: [io  0xfc80-0xfcff] has been reserved
[    0.294247] system 00:02: [io  0xfd0c-0xfd7f] has been reserved
[    0.294375] system 00:02: [io  0xfe00-0xfe01] has been reserved
[    0.294504] system 00:02: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.294633] system 00:02: [mem 0xfed14000-0xfed17fff] has been reserved
[    0.294762] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.294892] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.295022] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.295151] system 00:02: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.295280] system 00:02: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.295410] system 00:02: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.295539] system 00:02: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.295667] system 00:02: [mem 0xfef00000-0xfeffffff] has been reserved
[    0.295796] system 00:02: [mem 0x000cec00-0x000cefff] has been reserved
[    0.295926] system 00:02: [mem 0xffb00000-0xffbfffff] has been reserved
[    0.296087] system 00:02: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.296217] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.296356] pnp 00:03: [io  0x0000-0x000f]
[    0.296359] pnp 00:03: [io  0x0081-0x008f]
[    0.296361] pnp 00:03: [io  0x00c0-0x00df]
[    0.296365] pnp 00:03: [dma 4]
[    0.296451] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.296503] pnp 00:04: [io  0x0070-0x0071]
[    0.296517] pnp 00:04: [irq 8]
[    0.296600] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.296627] pnp 00:05: [io  0x0061]
[    0.296711] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.296739] pnp 00:06: [io  0x00f0-0x00fe]
[    0.296746] pnp 00:06: [irq 13]
[    0.296835] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.296863] pnp 00:07: [io  0x0060]
[    0.296866] pnp 00:07: [io  0x0064]
[    0.296873] pnp 00:07: [irq 1]
[    0.296957] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.296989] pnp 00:08: [irq 12]
[    0.297073] pnp 00:08: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.297211] pnp 00:09: [mem 0xfed00000-0xfed003ff]
[    0.297333] system 00:09: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.297465] system 00:09: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    0.297810] pnp 00:0a: [io  0x03f8-0x03ff]
[    0.297818] pnp 00:0a: [irq 4]
[    0.297943] pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.298468] pnp 00:0b: [io  0x02e8-0x02ef]
[    0.298472] pnp 00:0b: [io  0x06e8-0x06ef]
[    0.298479] pnp 00:0b: [irq 3]
[    0.298482] pnp 00:0b: [dma 3]
[    0.298616] pnp 00:0b: Plug and Play ACPI device, IDs SMCf010 (active)
[    0.299078] pnp 00:0c: [io  0x0378-0x037f]
[    0.299082] pnp 00:0c: [io  0x0778-0x077b]
[    0.299089] pnp 00:0c: [irq 7]
[    0.299229] pnp 00:0c: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.299916] pnp: PnP ACPI: found 13 devices
[    0.300076] ACPI: ACPI bus type pnp unregistered
[    0.340229] PCI: max bus depth: 2 pci_try_num: 3
[    0.340305] pci 0000:00:1e.0: BAR 9: assigned [mem 0x80000000-0x83ffffff pref]
[    0.340514] pci 0000:00:1c.0: BAR 9: assigned [mem 0x84000000-0x840fffff pref]
[    0.340722] pci 0000:00:1c.2: BAR 8: assigned [mem 0x84100000-0x841fffff]
[    0.340853] pci 0000:00:1e.0: BAR 7: assigned [io  0x3000-0x3fff]
[    0.340986] pci 0000:00:1c.2: BAR 9: assigned [mem 0x84300000-0x844fffff 64bit pref]
[    0.341193] pci 0000:00:1c.2: BAR 7: assigned [io  0x4000-0x4fff]
[    0.341323] pci 0000:00:1c.1: BAR 8: assigned [mem 0x84500000-0x846fffff]
[    0.341455] pci 0000:00:1c.1: BAR 9: assigned [mem 0x84700000-0x848fffff 64bit pref]
[    0.341663] pci 0000:00:1c.1: BAR 7: assigned [io  0x5000-0x5fff]
[    0.341792] pci 0000:02:00.0: BAR 6: assigned [mem 0x84000000-0x8401ffff pref]
[    0.341996] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.342123] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.342256] pci 0000:00:1c.0:   bridge window [mem 0xf0000000-0xf00fffff]
[    0.342388] pci 0000:00:1c.0:   bridge window [mem 0x84000000-0x840fffff pref]
[    0.342598] pci 0000:00:1c.1: PCI bridge to [bus 03-04]
[    0.342728] pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
[    0.342860] pci 0000:00:1c.1:   bridge window [mem 0x84500000-0x846fffff]
[    0.342994] pci 0000:00:1c.1:   bridge window [mem 0x84700000-0x848fffff 64bit pref]
[    0.343207] pci 0000:05:00.0: BAR 0: assigned [mem 0x84100000-0x84100fff]
[    0.343389] pci 0000:05:00.0: BAR 0: set to [mem 0x84100000-0x84100fff] (PCI address [0x84100000-0x84100fff])
[    0.343600] pci 0000:00:1c.2: PCI bridge to [bus 05-05]
[    0.343728] pci 0000:00:1c.2:   bridge window [io  0x4000-0x4fff]
[    0.343861] pci 0000:00:1c.2:   bridge window [mem 0x84100000-0x842fffff]
[    0.343993] pci 0000:00:1c.2:   bridge window [mem 0x84300000-0x844fffff 64bit pref]
[    0.344220] pci 0000:08:03.0: BAR 9: assigned [mem 0x80000000-0x83ffffff pref]
[    0.344428] pci 0000:08:03.0: BAR 10: assigned [mem 0x88000000-0x8bffffff]
[    0.344559] pci 0000:08:03.0: BAR 0: assigned [mem 0xf0202000-0xf0202fff]
[    0.344693] pci 0000:08:03.0: BAR 0: set to [mem 0xf0202000-0xf0202fff] (PCI address [0xf0202000-0xf0202fff])
[    0.344905] pci 0000:08:03.0: BAR 7: assigned [io  0x3000-0x30ff]
[    0.345033] pci 0000:08:03.0: BAR 8: assigned [io  0x3400-0x34ff]
[    0.345162] pci 0000:08:03.0: CardBus bridge to [bus 09-0c]
[    0.345288] pci 0000:08:03.0:   bridge window [io  0x3000-0x30ff]
[    0.345419] pci 0000:08:03.0:   bridge window [io  0x3400-0x34ff]
[    0.345551] pci 0000:08:03.0:   bridge window [mem 0x80000000-0x83ffffff pref]
[    0.345761] pci 0000:08:03.0:   bridge window [mem 0x88000000-0x8bffffff]
[    0.345894] pci 0000:00:1e.0: PCI bridge to [bus 08-09]
[    0.346021] pci 0000:00:1e.0:   bridge window [io  0x3000-0x3fff]
[    0.346154] pci 0000:00:1e.0:   bridge window [mem 0xf0200000-0xf02fffff]
[    0.346288] pci 0000:00:1e.0:   bridge window [mem 0x80000000-0x83ffffff pref]
[    0.346513] pci 0000:00:1c.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.346648] pci 0000:00:1c.0: setting latency timer to 64
[    0.346657] pci 0000:00:1c.1: enabling device (0000 -> 0003)
[    0.346789] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.346923] pci 0000:00:1c.1: setting latency timer to 64
[    0.346931] pci 0000:00:1c.2: enabling device (0000 -> 0003)
[    0.347061] pci 0000:00:1c.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
[    0.347193] pci 0000:00:1c.2: setting latency timer to 64
[    0.347203] pci 0000:00:1e.0: setting latency timer to 64
[    0.347215] pci 0000:08:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.347349] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.347352] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.347355] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.347358] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.347361] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.347364] pci_bus 0000:00: resource 9 [mem 0x80000000-0xfebfffff]
[    0.347367] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.347370] pci_bus 0000:02: resource 1 [mem 0xf0000000-0xf00fffff]
[    0.347374] pci_bus 0000:02: resource 2 [mem 0x84000000-0x840fffff pref]
[    0.347377] pci_bus 0000:03: resource 0 [io  0x5000-0x5fff]
[    0.347380] pci_bus 0000:03: resource 1 [mem 0x84500000-0x846fffff]
[    0.347383] pci_bus 0000:03: resource 2 [mem 0x84700000-0x848fffff 64bit pref]
[    0.347386] pci_bus 0000:05: resource 0 [io  0x4000-0x4fff]
[    0.347389] pci_bus 0000:05: resource 1 [mem 0x84100000-0x842fffff]
[    0.347392] pci_bus 0000:05: resource 2 [mem 0x84300000-0x844fffff 64bit pref]
[    0.347396] pci_bus 0000:08: resource 0 [io  0x3000-0x3fff]
[    0.347399] pci_bus 0000:08: resource 1 [mem 0xf0200000-0xf02fffff]
[    0.347402] pci_bus 0000:08: resource 2 [mem 0x80000000-0x83ffffff pref]
[    0.347405] pci_bus 0000:08: resource 4 [io  0x0000-0x0cf7]
[    0.347408] pci_bus 0000:08: resource 5 [io  0x0d00-0xffff]
[    0.347411] pci_bus 0000:08: resource 6 [mem 0x000a0000-0x000bffff]
[    0.347414] pci_bus 0000:08: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.347417] pci_bus 0000:08: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.347420] pci_bus 0000:08: resource 9 [mem 0x80000000-0xfebfffff]
[    0.347423] pci_bus 0000:09: resource 0 [io  0x3000-0x30ff]
[    0.347426] pci_bus 0000:09: resource 1 [io  0x3400-0x34ff]
[    0.347429] pci_bus 0000:09: resource 2 [mem 0x80000000-0x83ffffff pref]
[    0.347432] pci_bus 0000:09: resource 3 [mem 0x88000000-0x8bffffff]
[    0.347500] NET: Registered protocol family 2
[    0.347714] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.348189] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.348954] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.349335] TCP: Hash tables configured (established 131072 bind 65536)
[    0.349465] TCP reno registered
[    0.349590] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.349727] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.350013] NET: Registered protocol family 1
[    0.350307] RPC: Registered named UNIX socket transport module.
[    0.350435] RPC: Registered udp transport module.
[    0.350560] RPC: Registered tcp transport module.
[    0.350685] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.350828] pci 0000:00:02.0: Boot video device
[    0.351053] PCI: CLS 64 bytes, default 64
[    0.351121] Trying to unpack rootfs image as initramfs...
[    0.413841] debug: unmapping init memory f7616000..f77fe000
[    0.414017] Simple Boot Flag at 0x37 set to 0x1
[    0.415541] microcode: CPU0 sig=0x6f2, pf=0x20, revision=0x57
[    0.415674] microcode: CPU1 sig=0x6f2, pf=0x20, revision=0x57
[    0.415875] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.455729] highmem bounce pool size: 64 pages
[    0.455863] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.470913] msgmni has been set to 1723
[    0.471485] io scheduler noop registered
[    0.471613] io scheduler deadline registered
[    0.471749] io scheduler cfq registered (default)
[    0.472677] ACPI: AC Adapter [AC] (on-line)
[    0.473071] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    0.473310] ACPI: Lid Switch [LID]
[    0.473536] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.473745] ACPI: Power Button [PWRB]
[    0.473976] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    0.474187] ACPI: Sleep Button [SLPB]
[    0.474410] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.474617] ACPI: Power Button [PWRF]
[    0.474876] ACPI: acpi_idle registered with cpuidle
[    0.475013] Marking TSC unstable due to TSC halts in idle
[    0.479654] thermal LNXTHERM:00: registered as thermal_zone0
[    0.479781] ACPI: Thermal Zone [TZ00] (37 C)
[    0.480740] thermal LNXTHERM:01: registered as thermal_zone1
[    0.480867] ACPI: Thermal Zone [TZ01] (48 C)
[    0.482487] ACPI: Battery Slot [CMB1] (battery present)
[    0.485002] ACPI: Battery Slot [CMB2] (battery absent)
[    0.527103] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.547873] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.640584] serial8250: ttyS3 at I/O 0x2e8 (irq = 3) is a 16550A
[    0.701027] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.712463] Real Time Clock Driver v1.12b
[    0.712942] intel_rng: FWH not detected
[    0.713076] Linux agpgart interface v0.103
[    0.713393] agpgart-intel 0000:00:00.0: Intel 945GM Chipset
[    0.713614] agpgart-intel 0000:00:00.0: detected gtt size: 262144K total, 262144K mappable
[    0.714427] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
[    0.714789] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    3.736232] floppy0: no floppy controllers found
[    3.739695] brd: module loaded
[    3.741432] loop: module loaded
[    3.742038] ata_piix 0000:00:1f.1: version 2.13
[    3.742062] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.742238] ata_piix 0000:00:1f.1: setting latency timer to 64
[    3.742952] scsi0 : ata_piix
[    3.743283] scsi1 : ata_piix
[    3.744179] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
[    3.744310] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
[    3.744466] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    3.744498] ata2: port disabled. ignoring.
[    3.744675] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
[    3.900046] ata_piix 0000:00:1f.2: setting latency timer to 64
[    3.900794] scsi2 : ata_piix
[    3.901095] scsi3 : ata_piix
[    3.901774] ata3: SATA max UDMA/133 cmd 0x18d0 ctl 0x18c4 bmdma 0x18b0 irq 19
[    3.901906] ata4: SATA max UDMA/133 cmd 0x18c8 ctl 0x18c0 bmdma 0x18b8 irq 19
[    3.902296] sky2: driver version 1.28
[    3.902483] sky2 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.902662] sky2 0000:02:00.0: setting latency timer to 64
[    3.902769] sky2 0000:02:00.0: Yukon-2 EC Ultra chip revision 2
[    3.903600] sky2 0000:02:00.0: irq 40 for MSI/MSI-X
[    3.904623] sky2 0000:02:00.0: eth0: addr 00:17:42:64:2d:d4
[    3.904833] console [netcon0] enabled
[    3.904956] netconsole: network logging started
[    3.905288] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.905441] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.905583] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    3.905588] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    3.905804] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    3.906036] ehci_hcd 0000:00:1d.7: using broken periodic workaround
[    3.906174] ehci_hcd 0000:00:1d.7: debug port 1
[    3.908409] ata1.00: ATAPI: MATSHITADVD-RAM UJ-841S, 1.31, max UDMA/33
[    3.910186] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    3.910207] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf0644000
[    3.924032] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    3.924332] ata1.00: configured for UDMA/33
[    3.924533] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.924666] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.924922] usb usb1: Product: EHCI Host Controller
[    3.925047] usb usb1: Manufacturer: Linux 3.0.0-rc2-00002-g740daf6 ehci_hcd
[    3.925175] usb usb1: SerialNumber: 0000:00:1d.7
[    3.925509] hub 1-0:1.0: USB hub found
[    3.925638] hub 1-0:1.0: 8 ports detected
[    3.925974] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.926164] uhci_hcd: USB Universal Host Controller Interface driver
[    3.926361] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.926548] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.926552] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.926773] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    3.927070] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001820
[    3.927241] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    3.927371] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.927575] usb usb2: Product: UHCI Host Controller
[    3.927700] usb usb2: Manufacturer: Linux 3.0.0-rc2-00002-g740daf6 uhci_hcd
[    3.927827] usb usb2: SerialNumber: 0000:00:1d.0
[    3.928174] hub 2-0:1.0: USB hub found
[    3.928337] hub 2-0:1.0: 2 ports detected
[    3.928647] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 20 (level, low) -> IRQ 20
[    3.928782] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    3.928786] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.929006] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    3.929256] uhci_hcd 0000:00:1d.1: irq 20, io base 0x00001840
[    3.929428] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    3.929557] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.929773] usb usb3: Product: UHCI Host Controller
[    3.929781] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-841S  1.31 PQ: 0 ANSI: 5
[    3.930142] usb usb3: Manufacturer: Linux 3.0.0-rc2-00002-g740daf6 uhci_hcd
[    3.930272] usb usb3: SerialNumber: 0000:00:1d.1
[    3.930649] hub 3-0:1.0: USB hub found
[    3.930782] hub 3-0:1.0: 2 ports detected
[    3.931182] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.931319] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    3.931323] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.931545] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    3.931793] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001860
[    3.931968] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    3.932126] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.932132] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    3.932135] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.932335] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    3.932597] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    3.932857] usb usb4: Product: UHCI Host Controller
[    3.932984] usb usb4: Manufacturer: Linux 3.0.0-rc2-00002-g740daf6 uhci_hcd
[    3.933122] usb usb4: SerialNumber: 0000:00:1d.2
[    3.933448] hub 4-0:1.0: USB hub found
[    3.933577] hub 4-0:1.0: 2 ports detected
[    3.933848] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    3.933986] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    3.933991] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    3.934212] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    3.934460] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00001880
[    3.934632] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    3.934762] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.934969] usb usb5: Product: UHCI Host Controller
[    3.935095] usb usb5: Manufacturer: Linux 3.0.0-rc2-00002-g740daf6 uhci_hcd
[    3.935226] usb usb5: SerialNumber: 0000:00:1d.3
[    3.935547] hub 5-0:1.0: USB hub found
[    3.935674] hub 5-0:1.0: 2 ports detected
[    3.936021] Initializing USB Mass Storage driver...
[    3.936240] usbcore: registered new interface driver usb-storage
[    3.936368] USB Mass Storage support registered.
[    3.936576] usbcore: registered new interface driver libusual
[    3.936764] usbcore: registered new interface driver ums-alauda
[    3.936952] usbcore: registered new interface driver ums-datafab
[    3.937139] usbcore: registered new interface driver ums-freecom
[    3.937327] usbcore: registered new interface driver ums-isd200
[    3.937515] usbcore: registered new interface driver ums-jumpshot
[    3.937704] usbcore: registered new interface driver ums-karma
[    3.937891] usbcore: registered new interface driver ums-sddr09
[    3.938081] usbcore: registered new interface driver ums-sddr55
[    3.938270] usbcore: registered new interface driver ums-usbat
[    3.938566] i8042: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    3.941379] i8042: Detected active multiplexing controller, rev 1.1
[    3.943091] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.943252] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    3.943417] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    3.943581] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    3.943744] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    3.944216] mousedev: PS/2 mouse device common for all mice
[    3.945319] cpuidle: using governor ladder
[    3.946338] cpuidle: using governor menu
[    3.949255] usbcore: registered new interface driver usbhid
[    3.949382] usbhid: USB HID core driver
[    3.949506] oprofile: using NMI interrupt.
[    3.949982] TCP cubic registered
[    3.950728] NET: Registered protocol family 10
[    3.951838] IPv6 over IPv4 tunneling driver
[    3.952902] NET: Registered protocol family 17
[    3.953041] Registering the dns_resolver key type
[    3.953189] Using IPI No-Shortcut mode
[    3.953664] Kernel not built with RTC support, ALARM timers will not wake from suspend
[    3.953796] PM: Hibernation image not present or could not be loaded.
[    3.953927] registered taskstats version 1
[    3.975101] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    4.072438] ata3.00: ATA-7: ST9120822AS, 3.ALE, max UDMA/133
[    4.072583] ata3.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    4.088710] ata3.00: configured for UDMA/133
[    4.089131] scsi 2:0:0:0: Direct-Access     ATA      ST9120822AS      3.AL PQ: 0 ANSI: 5
[    4.089824] sd 2:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)
[    4.090173] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    4.090360] sd 2:0:0:0: [sda] Write Protect is off
[    4.090488] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.090558] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.163866]  sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 >
[    4.165366] sd 2:0:0:0: [sda] Attached SCSI disk
[    4.165508] debug: unmapping init memory c063b000..c06aa000
[    4.165697] Write protecting the kernel text: 3436k
[    4.165854] Write protecting the kernel read-only data: 1564k
[    4.532054] usb 2-2: new low speed USB device number 2 using uhci_hcd
[    4.709029] usb 2-2: New USB device found, idVendor=046d, idProduct=c040
[    4.709172] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.709301] usb 2-2: Product: USB-PS/2 Optical Mouse
[    4.709425] usb 2-2: Manufacturer: Logitech
[    4.726441] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input5
[    4.726804] generic-usb 0003:046D:C040.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-2/input0
[    4.823439] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x1a0b1, caps: 0xa04793/0x302000/0x0
[    4.825927] serio: Synaptics pass-through port at isa0060/serio4/input0
[    4.864701] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input6
[    4.976078] usb 5-2: new full speed USB device number 2 using uhci_hcd
[    5.148448] usb 5-2: New USB device found, idVendor=0c24, idProduct=000f
[    5.148598] usb 5-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    9.013407] input: PS/2 Generic Mouse as /devices/platform/i8042/serio4/serio5/input/input7
[    9.110578] PM: Starting manual resume from disk
[    9.110782] PM: Hibernation image partition 8:8 present
[    9.110784] PM: Looking for hibernation image.
[    9.111006] PM: Image not found (code -22)
[    9.111012] PM: Hibernation image not present or could not be loaded.
[    9.114995] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
[    9.115001] PM: Basic memory bitmaps created
[    9.127855] PM: Basic memory bitmaps freed
[    9.137080] EXT3-fs: barriers not enabled
[    9.150306] kjournald starting.  Commit interval 5 seconds
[    9.150573] EXT3-fs (sda1): mounted filesystem with writeback data mode
[   10.742885] udev[1645]: starting version 167
[   11.097298] acpi device:02: registered as cooling_device2
[   11.097563] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input8
[   11.097848] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   11.222783] udev[1676]: renamed network interface eth0 to lan0
[   11.306563] cfg80211: Calling CRDA to update world regulatory domain
[   11.323438] input: Fujitsu FUJ02B1 as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:06/FUJ02B1:00/input/input9
[   11.323775] fujitsu_laptop: ACPI: Fujitsu FUJ02B1 [FJEX] (on)
[   11.325734] input: Fujitsu FUJ02E3 as /devices/LNXSYSTM:00/device:00/FUJ02E3:00/input/input10
[   11.326114] fujitsu_laptop: ACPI: Fujitsu FUJ02E3 [FEXT] (on)
[   11.326775] fujitsu_laptop: BTNI: [0xff0101]
[   11.327152] fujitsu_laptop: driver 0.6.0 successfully loaded
[   11.523112] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[   11.523256] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[   11.523397] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   11.523658] HDA Intel 0000:00:1b.0: irq 41 for MSI/MSI-X
[   11.523697] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   11.537666] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:ds
[   11.537888] iwl3945: Copyright(c) 2003-2011 Intel Corporation
[   11.538114] iwl3945 0000:05:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   11.538295] iwl3945 0000:05:00.0: setting latency timer to 64
[   11.599363] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   11.601075] iwl3945 0000:05:00.0: Tunable channels: 13 802.11bg, 23 802.11a channels
[   11.601293] iwl3945 0000:05:00.0: Detected Intel Wireless WiFi Link 3945ABG
[   11.603093] iwl3945 0000:05:00.0: irq 42 for MSI/MSI-X
[   11.603328] Registered led device: phy0-led
[   11.655681] ieee80211 phy0: Selected rate control algorithm 'iwl-3945-rs'
[   13.189947] Adding 979928k swap on /dev/sda8.  Priority:-1 extents:1 across:979928k 
[   13.807598] EXT3-fs (sda1): using internal journal
[   13.981472] coretemp coretemp.0: Using relative temperature scale!
[   13.981699] coretemp coretemp.0: Using relative temperature scale!
[   13.998672] tun: Universal TUN/TAP device driver, 1.6
[   13.998818] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   15.526757] fuse init (API version 7.16)
[   16.015407] EXT3-fs: barriers not enabled
[   16.015857] kjournald starting.  Commit interval 5 seconds
[   16.016126] EXT3-fs (sda7): using internal journal
[   16.016274] EXT3-fs (sda7): mounted filesystem with writeback data mode
[   16.152898] EXT3-fs: barriers not enabled
[   16.153343] kjournald starting.  Commit interval 5 seconds
[   16.153678] EXT3-fs (sda9): using internal journal
[   16.153825] EXT3-fs (sda9): mounted filesystem with writeback data mode
[   16.216714] EXT3-fs: barriers not enabled
[   16.217148] kjournald starting.  Commit interval 5 seconds
[   16.217408] EXT3-fs (sda5): using internal journal
[   16.217560] EXT3-fs (sda5): mounted filesystem with writeback data mode
[   16.313075] EXT3-fs: barriers not enabled
[   16.313522] kjournald starting.  Commit interval 5 seconds
[   16.313773] EXT3-fs (sda6): using internal journal
[   16.313926] EXT3-fs (sda6): mounted filesystem with writeback data mode
[   24.518255] sshd (2830): /proc/2830/oom_adj is deprecated, please use /proc/2830/oom_score_adj instead.
[   27.710884] sky2 0000:02:00.0: lan0: enabling interface
[   27.711662] ADDRCONF(NETDEV_UP): lan0: link is not ready
[   28.169762] iwl3945 0000:05:00.0: loaded firmware version 15.32.2.9
[   28.244047] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   34.075085] [drm] Initialized drm 1.1.0 20060810
[   34.191727] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   34.191736] i915 0000:00:02.0: setting latency timer to 64
[   34.212714] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   34.212719] [drm] Driver supports precise vblank timestamp query.
[   34.212805] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   34.941211] [drm] initialized overlay support
[   35.130768] fbcon: inteldrmfb (fb0) is primary device
[   35.130983] Console: switching to colour frame buffer device 175x65
[   35.130991] fb0: inteldrmfb frame buffer device
[   35.130993] drm: registered panic notifier
[   35.131039] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   48.492078] CE: hpet increased min_delta_ns to 20113 nsec
[  114.917139] wlan%d: direct probe to 00:24:01:93:0a:00 (try 1/3)
[  114.921347] wlan%d: direct probe responded
[  114.944046] wlan%d: authenticate with 00:24:01:93:0a:00 (try 1)
[  114.946208] wlan%d: authenticated
[  114.946242] wlan%d: associate with 00:24:01:93:0a:00 (try 1)
[  114.948591] wlan%d: RX AssocResp from 00:24:01:93:0a:00 (capab=0x431 status=0 aid=6)
[  114.948595] wlan%d: associated
[  114.950222] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  125.560057] wlan0: no IPv6 routers present

--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.0.0-rc2-00002-g740daf6"

#
# Automatically generated make config: don't edit
# Linux/i386 3.0.0-rc2 Kernel Configuration
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
# CONFIG_NEED_DMA_MAP_STATE is not set
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
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_KTIME_SCALAR=y
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
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
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_FHANDLE is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
# CONFIG_AUDIT is not set
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
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=32
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_BOOST is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=18
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_BLK_CGROUP is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
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
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
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
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
# CONFIG_BLK_DEV_BSG is not set
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
CONFIG_X86_MPPARSE=y
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
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
CONFIG_MPENTIUMIII=y
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
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_CMPXCHG_LOCAL=y
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
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
# CONFIG_ARCH_DMA_ADDR_T_64BIT is not set
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_CLEANCACHE is not set
CONFIG_HIGHPTE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_CAN_PM_TRACE=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
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
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=2001
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_DEBUG_FUNC_TRACE is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=y
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
# CONFIG_INTEL_IDLE is not set

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
# CONFIG_DMAR is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
# CONFIG_PCI_IOV is not set
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CONNTRACK_TIMESTAMP is not set
# CONFIG_NF_CT_PROTO_DCCP is not set
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
# CONFIG_NF_CONNTRACK_AMANDA is not set
CONFIG_NF_CONNTRACK_FTP=m
# CONFIG_NF_CONNTRACK_H323 is not set
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
# CONFIG_NF_CONNTRACK_SNMP is not set
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
# CONFIG_NF_CONNTRACK_SIP is not set
CONFIG_NF_CONNTRACK_TFTP=m
# CONFIG_NF_CT_NETLINK is not set
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
# CONFIG_NETFILTER_XT_TARGET_CHECKSUM is not set
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
# CONFIG_NETFILTER_XT_TARGET_CONNMARK is not set
# CONFIG_NETFILTER_XT_TARGET_CT is not set
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
CONFIG_NETFILTER_XT_TARGET_HL=m
# CONFIG_NETFILTER_XT_TARGET_IDLETIMER is not set
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
# CONFIG_NETFILTER_XT_TARGET_NOTRACK is not set
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
# CONFIG_NETFILTER_XT_TARGET_TEE is not set
# CONFIG_NETFILTER_XT_TARGET_TRACE is not set
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
# CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP is not set

#
# Xtables matches
#
# CONFIG_NETFILTER_XT_MATCH_ADDRTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_CLUSTER is not set
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
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
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
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
# CONFIG_NF_NAT_SIP is not set
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV6 is not set
# CONFIG_NF_CONNTRACK_IPV6 is not set
# CONFIG_IP6_NF_QUEUE is not set
# CONFIG_IP6_NF_IPTABLES is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_NET_SCTPPROBE is not set
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
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
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_MQPRIO is not set
# CONFIG_NET_SCH_CHOKE is not set
# CONFIG_NET_SCH_QFQ is not set

#
# Classification
#
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_CLS_CGROUP is not set
# CONFIG_NET_EMATCH is not set
# CONFIG_NET_CLS_ACT is not set
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
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=m
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set

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
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
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
# CONFIG_CB710_CORE is not set

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
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set

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
# CONFIG_PATA_ARASAN_CF is not set
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
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_DUMMY=m
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_MII is not set
# CONFIG_PHYLIB is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
CONFIG_SKY2=y
# CONFIG_SKY2_DEBUG is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
# CONFIG_STMMAC_ETH is not set
# CONFIG_PCH_GBE is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set
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
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_HOSTAP is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWLAGN is not set
CONFIG_IWLWIFI_LEGACY=m

#
# Debugging Options
#
CONFIG_IWLWIFI_LEGACY_DEBUG=y
# CONFIG_IWLWIFI_LEGACY_DEVICE_TRACING is not set
# CONFIG_IWL4965 is not set
CONFIG_IWL3945=m
# CONFIG_LIBERTAS is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
# CONFIG_RT2X00 is not set
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192CU is not set
# CONFIG_WL1251 is not set
# CONFIG_WL12XX_MENU is not set
# CONFIG_ZD1211RW is not set
# CONFIG_MWIFIEX is not set

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
# CONFIG_USB_IPHETH is not set
# CONFIG_WAN is not set

#
# CAIF transport drivers
#
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
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
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
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
CONFIG_MOUSE_PS2=y
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
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
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
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
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
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

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
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_GEODE is not set
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_NVRAM is not set
CONFIG_RTC=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
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
# CONFIG_I2C_I801 is not set
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
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
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
# CONFIG_SENSORS_SCH5627 is not set
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
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set
CONFIG_MFD_SUPPORT=y
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_CS5535 is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=m
CONFIG_DRM_KMS_HELPER=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_I915=m
# CONFIG_DRM_I915_KMS is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=m
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_WMT_GE_ROPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
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
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=m
CONFIG_BACKLIGHT_GENERIC=m
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_APPLE is not set
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
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=128
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=m
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_RTCTIMER=m
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_ALOOP is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
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
# CONFIG_SND_HDA_HWDEP is not set
# CONFIG_SND_HDA_INPUT_BEEP is not set
CONFIG_SND_HDA_INPUT_JACK=y
# CONFIG_SND_HDA_PATCH_LOADER is not set
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
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=60
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
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
# CONFIG_SND_USB is not set
# CONFIG_SND_SOC is not set
CONFIG_SOUND_PRIME=y
# CONFIG_SOUND_OSS is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWII_FF is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_QUANTA is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_ROCCAT_ARVO is not set
# CONFIG_HID_ROCCAT_KONE is not set
# CONFIG_HID_ROCCAT_KONEPLUS is not set
# CONFIG_HID_ROCCAT_KOVAPLUS is not set
# CONFIG_HID_ROCCAT_PYRA is not set
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TOPSEED=y
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
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
# CONFIG_USB_DEVICEFS is not set
CONFIG_USB_DEVICE_CLASS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
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
CONFIG_USB_ACM=m
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_ONETOUCH is not set
CONFIG_USB_STORAGE_KARMA=y
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
# CONFIG_USB_UAS is not set
CONFIG_USB_LIBUSUAL=y

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
# CONFIG_USB_APPLEDISPLAY is not set
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
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
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
# CONFIG_NFC_DEVICES is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
CONFIG_FUJITSU_LAPTOP=m
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
CONFIG_CLKSRC_I8253=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
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
# CONFIG_EXT2_FS_SECURITY is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
# CONFIG_EXT3_FS_SECURITY is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
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
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

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
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
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
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=m
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=y
# CONFIG_NFS_V4_1 is not set
# CONFIG_ROOT_NFS is not set
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
# CONFIG_NFS_USE_NEW_IDMAPPER is not set
# CONFIG_NFSD is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_UPCALL is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_NFSD_EXPORT is not set
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
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
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
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y

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
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_PREEMPT=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
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
CONFIG_DEBUG_LIST=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_VERBOSE=y
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_LKDTM is not set
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_DEBUG_PAGEALLOC=y
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
CONFIG_RING_BUFFER=y
CONFIG_FTRACE_NMI_ENTER=y
CONFIG_EVENT_TRACING=y
CONFIG_EVENT_POWER_TRACING_DEPRECATED=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_PREEMPT_TRACER is not set
# CONFIG_SCHED_TRACER is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_STACK_TRACER=y
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_KPROBE_EVENT=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
# CONFIG_KGDB_TESTS is not set
# CONFIG_KGDB_LOW_LEVEL_TRAP is not set
# CONFIG_KGDB_KDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
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
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
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
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=m
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_TEST is not set

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
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=m
CONFIG_CRYPTO_XCBC=m
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_586=m
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=y
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
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_CRC_CCITT=m
# CONFIG_CRC16 is not set
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
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
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_NLATTR=y
CONFIG_AVERAGE=y

--i0/AhcQY5QxfSsSZ--
