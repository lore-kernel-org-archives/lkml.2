Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab1I2CkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 22:40:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237Ab1I2CkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 22:40:05 -0400
Message-ID: <4E83DAEA.6010505@redhat.com>
Date: Thu, 29 Sep 2011 10:41:46 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [BUG?] e1000e Detected Hardware Unit Hang
Content-Type: multipart/mixed;
 boundary="------------000105060902050707080506"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000105060902050707080506
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

suspend to ram, after resume, I got below info: (attached the full dmesg)

[106900.343520] e1000e 0000:00:19.0: eth0: Detected Hardware Unit Hang:
[106900.343521]   TDH                  <1>
[106900.343522]   TDT                  <2>
[106900.343523]   next_to_use          <2>
[106900.343523]   next_to_clean        <1>
[106900.343524] buffer_info[next_to_clean]:
[106900.343525]   time_stamp           <101e7f773>
[106900.343526]   next_to_watch        <1>
[106900.343526]   jiffies              <101e7fa4a>
[106900.343527]   next_to_watch.status <0>
[106900.343528] MAC Status             <80683>
[106900.343529] PHY Status             <796d>
[106900.343529] PHY 1000BASE-T Status  <3800>
[106900.343530] PHY Extended Status    <3000>
[106900.343531] PCI Status             <10>
[106902.342904] e1000e 0000:00:19.0: eth0: Detected Hardware Unit Hang:
[106902.342905]   TDH                  <1>
[106902.342906]   TDT                  <2>
[106902.342907]   next_to_use          <2>
[106902.342907]   next_to_clean        <1>
[106902.342908] buffer_info[next_to_clean]:
[106902.342909]   time_stamp           <101e7f773>
[106902.342909]   next_to_watch        <1>
[106902.342910]   jiffies              <101e7fca2>
[106902.342911]   next_to_watch.status <0>
[106902.342912] MAC Status             <80683>
[106902.342912] PHY Status             <796d>
[106902.342913] PHY 1000BASE-T Status  <3800>
[106902.342914] PHY Extended Status    <3000>
[106902.342915] PCI Status             <10>
[106903.349326] ------------[ cut here ]------------
[106903.349336] WARNING: at net/sched/sch_generic.c:255
dev_watchdog+0xeb/0x14b()
[106903.349339] Hardware name: OptiPlex 760
[106903.349342] NETDEV WATCHDOG: eth0 (e1000e): transmit queue 0 timed out
[106903.349344] Modules linked in: cdc_ether usbnet mii tun kvm_intel
kvm snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
snd_pcm_oss snd_mixer_oss fuse snd_hda_codec_analog snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm radeon snd_timer snd_page_alloc ttm
dell_wmi sparse_keymap wmi
[106903.349379] Pid: 0, comm: swapper Not tainted 3.1.0-rc6+ #202
[106903.349382] Call Trace:
[106903.349384]  <IRQ>  [<ffffffff8103c5a7>] warn_slowpath_common+0x80/0x98
[106903.349394]  [<ffffffff8103c653>] warn_slowpath_fmt+0x41/0x43
[106903.349399]  [<ffffffff81560149>] dev_watchdog+0xeb/0x14b
[106903.349404]  [<ffffffff810497c6>] run_timer_softirq+0x217/0x300
[106903.349408]  [<ffffffff81049733>] ? run_timer_softirq+0x184/0x300
[106903.349413]  [<ffffffff8156005e>] ? netif_tx_unlock+0x51/0x51
[106903.349419]  [<ffffffff810423c6>] __do_softirq+0xe2/0x1bc
[106903.349424]  [<ffffffff81007a81>] ? paravirt_read_tsc+0x9/0xd
[106903.349428]  [<ffffffff81007fc8>] ? sched_clock+0x9/0xd
[106903.349434]  [<ffffffff8160063c>] call_softirq+0x1c/0x30
[106903.349438]  [<ffffffff81003ba2>] do_softirq+0x46/0x9c
[106903.349442]  [<ffffffff81042696>] irq_exit+0x5b/0xbe
[106903.349446]  [<ffffffff8100384a>] do_IRQ+0x89/0xa0
[106903.349452]  [<ffffffff815f8e33>] common_interrupt+0x73/0x73
[106903.349454]  <EOI>  [<ffffffff81008d81>] ? mwait_idle+0x8a/0xc1
[106903.349462]  [<ffffffff81008d78>] ? mwait_idle+0x81/0xc1
[106903.349467]  [<ffffffff810012ab>] cpu_idle+0xb3/0xd5
[106903.349473]  [<ffffffff815d8dbe>] rest_init+0xb2/0xb9
[106903.349477]  [<ffffffff815d8d0c>] ?
csum_partial_copy_generic+0x16c/0x16c
[106903.349483]  [<ffffffff81a22b49>] start_kernel+0x390/0x39b
[106903.349487]  [<ffffffff81a222af>] x86_64_start_reservations+0xb6/0xba
[106903.349491]  [<ffffffff81a223b4>] x86_64_start_kernel+0x101/0x110
[106903.349495] ---[ end trace 1d36d9ed335e092c ]---
[106903.349722] e1000e 0000:00:19.0: eth0: Reset adapter

-- 
Thanks
Dave

--------------000105060902050707080506
Content-Type: text/plain;
 name="e1000e.bug"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="e1000e.bug"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.1.0-rc6+ (dave@darkstar) (gcc version 4.5.2 (GCC) ) #202 SMP Tue Sep 20 12:55:02 HKT 2011
[    0.000000] Command line: BOOT_IMAGE=slack64-13.37 ro root=802 vt.default_utf8=1
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bfdffc00 (usable)
[    0.000000]  BIOS-e820: 00000000bfdffc00 - 00000000bfe53c00 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfe53c00 - 00000000bfe55c00 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfe55c00 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000feda0000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000238000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.5 present.
[    0.000000] DMI: Dell Inc. OptiPlex 760                 /0M860N, BIOS A02 02/18/2009
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x238000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0BFF00000 mask FFFF00000 uncachable
[    0.000000]   1 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xbfdff max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000fe710] fe710
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000bfdff000
[    0.000000]  0000000000 - 00bfc00000 page 2M
[    0.000000]  00bfc00000 - 00bfdff000 page 4k
[    0.000000] kernel direct mapping tables up to bfdff000 @ bfdfa000-bfdff000
[    0.000000] init_memory_mapping: 0000000100000000-0000000238000000
[    0.000000]  0100000000 - 0238000000 page 2M
[    0.000000] kernel direct mapping tables up to 238000000 @ 237ff6000-238000000
[    0.000000] ACPI: RSDP 00000000000fec00 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000000fc7ef 0006C (v01 DELL    B10K    00000015 ASL  00000061)
[    0.000000] ACPI: FACP 00000000000fc91f 000F4 (v03 DELL    B10K    00000015 ASL  00000061)
[    0.000000] ACPI: DSDT 00000000fff1be4b 0536F (v01   DELL    dt_ex 00001000 INTL 20050624)
[    0.000000] ACPI: FACS 00000000bfdffc00 00040
[    0.000000] ACPI: SSDT 00000000fff212d9 000AA (v01   DELL    st_ex 00001000 INTL 20050624)
[    0.000000] ACPI: APIC 00000000000fca13 00092 (v01 DELL    B10K    00000015 ASL  00000061)
[    0.000000] ACPI: BOOT 00000000000fcaa5 00028 (v01 DELL    B10K    00000015 ASL  00000061)
[    0.000000] ACPI: ASF! 00000000000fcacd 00096 (v32 DELL    B10K    00000015 ASL  00000061)
[    0.000000] ACPI: MCFG 00000000000fcb63 0003E (v01 DELL    B10K    00000015 ASL  00000061)
[    0.000000] ACPI: HPET 00000000000fcba1 00038 (v01 DELL    B10K    00000015 ASL  00000061)
[    0.000000] ACPI: TCPA 00000000000fcdfd 00032 (v01 DELL    B10K    00000015 ASL  00000061)
[    0.000000] ACPI: DMAR 00000000000fce2f 000D8 (v01 DELL    B10K    00000015 ASL  00000061)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0008dfffff] PMD -> [ffff88022f800000-ffff8802375fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00238000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000bfdff
[    0.000000]     0: 0x00100000 -> 0x00238000
[    0.000000] On node 0 totalpages: 2063758
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3914 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 765503 pages, LIFO batch:31
[    0.000000]   Normal zone: 19968 pages used for memmap
[    0.000000]   Normal zone: 1257984 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 2 reached.  Processor 2/0x2 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 2 reached.  Processor 3/0x3 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] 8 Processors exceeds NR_CPUS limit of 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bfdff000 - 00000000bfe00000
[    0.000000] PM: Registered nosave memory: 00000000bfe00000 - 00000000bfe53000
[    0.000000] PM: Registered nosave memory: 00000000bfe53000 - 00000000bfe54000
[    0.000000] PM: Registered nosave memory: 00000000bfe54000 - 00000000bfe55000
[    0.000000] PM: Registered nosave memory: 00000000bfe55000 - 00000000bfe56000
[    0.000000] PM: Registered nosave memory: 00000000bfe56000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000feda0000
[    0.000000] PM: Registered nosave memory: 00000000feda0000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fef00000
[    0.000000] PM: Registered nosave memory: 00000000fef00000 - 00000000ffb00000
[    0.000000] PM: Registered nosave memory: 00000000ffb00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff880237c00000 s82560 r8192 d23936 u1048576
[    0.000000] pcpu-alloc: s82560 r8192 d23936 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2027401
[    0.000000] Kernel command line: BOOT_IMAGE=slack64-13.37 ro root=802 vt.default_utf8=1
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 8026468k/9306112k available (6156k kernel code, 1051080k absent, 228564k reserved, 4131k data, 560k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU debugfs-based tracing is enabled.
[    0.000000] 	CONFIG_RCU_FANOUT set to non-default value of 32
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
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
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2660.127 MHz processor.
[    0.003337] Calibrating delay loop (skipped), value calculated using timer frequency.. 5322.93 BogoMIPS (lpj=8867090)
[    0.003570] pid_max: default: 32768 minimum: 301
[    0.003754] Security Framework initialized
[    0.003932] Mount-cache hash table entries: 256
[    0.004859] Initializing cgroup subsys cpuacct
[    0.004983] Initializing cgroup subsys blkio
[    0.005188] CPU: Physical Processor ID: 0
[    0.005303] CPU: Processor Core ID: 0
[    0.005419] mce: CPU supports 6 MCE banks
[    0.005540] CPU0: Thermal monitoring enabled (TM2)
[    0.005658] using mwait in idle threads.
[    0.006694] ACPI: Core revision 20110623
[    0.155904] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.189033] CPU0: Intel(R) Core(TM)2 Quad CPU    Q9400  @ 2.66GHz stepping 0a
[    0.189988] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.189988] ... version:                2
[    0.189988] ... bit width:              40
[    0.189988] ... generic registers:      2
[    0.189988] ... value mask:             000000ffffffffff
[    0.189988] ... max period:             000000007fffffff
[    0.189988] ... fixed-purpose events:   3
[    0.189988] ... event mask:             0000000700000003
[    0.189988] NMI watchdog enabled, takes one hw-pmu counter.
[    0.189988] lockdep: fixing up alternatives.
[    0.189988] Booting Node   0, Processors  #1 Ok.
[    0.189988] smpboot cpu 1: start_ip = 9a000
[    0.283393] NMI watchdog enabled, takes one hw-pmu counter.
[    0.283574] Brought up 2 CPUs
[    0.283690] Total of 2 processors activated (10644.54 BogoMIPS).
[    0.284898] kworker/u:0 used greatest stack depth: 5720 bytes left
[    0.284898] PM: Registering ACPI NVS region at bfdffc00 (344064 bytes)
[    0.286936] print_constraints: dummy: 
[    0.286936] RTC time:  8:57:16, date: 09/26/11
[    0.286979] NET: Registered protocol family 16
[    0.287140] kworker/u:0 used greatest stack depth: 5568 bytes left
[    0.287140] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.287140] ACPI: bus type pci registered
[    0.287256] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.287256] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.352866] PCI: Using configuration type 1 for base access
[    0.352989] dmi type 0xB1 record - unknown flag
[    0.353371] kworker/u:0 used greatest stack depth: 5384 bytes left
[    0.370483] bio: create slab <bio-0> at 0
[    0.370483] ACPI: Added _OSI(Module Device)
[    0.370483] ACPI: Added _OSI(Processor Device)
[    0.370483] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.370483] ACPI: Added _OSI(Processor Aggregator Device)
[    0.375528] ACPI: EC: Look up EC in DSDT
[    0.415734] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.449205] ACPI Warning: Incorrect checksum in table [TCPA] - 0x00, should be 0x7F (20110623/tbutils-314)
[    0.451228] ACPI: Interpreter enabled
[    0.451341] ACPI: (supports S0 S1 S3 S4 S5)
[    0.451682] ACPI: Using IOAPIC for interrupt routing
[    0.610919] ACPI: ACPI Dock Station Driver: 1 docks/bays found
[    0.611032] HEST: Table not found.
[    0.611144] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.630031] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.666661] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.666783] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.666896] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.667081] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000effff]
[    0.667265] pci_root PNP0A03:00: host bridge window [mem 0x000f0000-0x000fffff]
[    0.667449] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfec00000]
[    0.667633] pci_root PNP0A03:00: host bridge window [mem 0xbff00000-0xdfffffff]
[    0.667817] pci_root PNP0A03:00: host bridge window [mem 0xff980000-0xff980fff]
[    0.668001] pci_root PNP0A03:00: host bridge window [mem 0xff97c000-0xff97ffff]
[    0.668185] pci_root PNP0A03:00: host bridge window [mem 0xfed20000-0xfed9ffff]
[    0.668369] pci_root PNP0A03:00: host bridge window [mem 0xfeda7000-0xfeda7fff]
[    0.668598] pci 0000:00:00.0: [8086:2e10] type 0 class 0x000600
[    0.668695] pci 0000:00:01.0: [8086:2e11] type 1 class 0x000604
[    0.668755] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.668759] pci 0000:00:01.0: PME# disabled
[    0.668793] pci 0000:00:03.0: [8086:2e14] type 0 class 0x000780
[    0.668830] pci 0000:00:03.0: reg 10: [mem 0xfeda6000-0xfeda600f 64bit]
[    0.668935] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.668940] pci 0000:00:03.0: PME# disabled
[    0.668965] pci 0000:00:03.2: [8086:2e16] type 0 class 0x000101
[    0.668987] pci 0000:00:03.2: reg 10: [io  0xfe80-0xfe87]
[    0.668998] pci 0000:00:03.2: reg 14: [io  0xfe90-0xfe93]
[    0.669008] pci 0000:00:03.2: reg 18: [io  0xfea0-0xfea7]
[    0.669018] pci 0000:00:03.2: reg 1c: [io  0xfeb0-0xfeb3]
[    0.669029] pci 0000:00:03.2: reg 20: [io  0xfef0-0xfeff]
[    0.669092] pci 0000:00:03.3: [8086:2e17] type 0 class 0x000700
[    0.669115] pci 0000:00:03.3: reg 10: [io  0xec98-0xec9f]
[    0.669124] pci 0000:00:03.3: reg 14: [mem 0xfebd8000-0xfebd8fff]
[    0.669289] pci 0000:00:19.0: [8086:10de] type 0 class 0x000200
[    0.669315] pci 0000:00:19.0: reg 10: [mem 0xfebe0000-0xfebfffff]
[    0.669327] pci 0000:00:19.0: reg 14: [mem 0xfebd9000-0xfebd9fff]
[    0.669339] pci 0000:00:19.0: reg 18: [io  0xecc0-0xecdf]
[    0.669413] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.669418] pci 0000:00:19.0: PME# disabled
[    0.669444] pci 0000:00:1a.0: [8086:3a67] type 0 class 0x000c03
[    0.669505] pci 0000:00:1a.0: reg 20: [io  0xff20-0xff3f]
[    0.669568] pci 0000:00:1a.1: [8086:3a68] type 0 class 0x000c03
[    0.669629] pci 0000:00:1a.1: reg 20: [io  0xff00-0xff1f]
[    0.669693] pci 0000:00:1a.2: [8086:3a69] type 0 class 0x000c03
[    0.669754] pci 0000:00:1a.2: reg 20: [io  0xfc00-0xfc1f]
[    0.669830] pci 0000:00:1a.7: [8086:3a6c] type 0 class 0x000c03
[    0.669859] pci 0000:00:1a.7: reg 10: [mem 0xfebda000-0xfebda3ff]
[    0.669981] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.669987] pci 0000:00:1a.7: PME# disabled
[    0.670020] pci 0000:00:1b.0: [8086:3a6e] type 0 class 0x000403
[    0.670042] pci 0000:00:1b.0: reg 10: [mem 0xfebdc000-0xfebdffff 64bit]
[    0.670123] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.670128] pci 0000:00:1b.0: PME# disabled
[    0.670155] pci 0000:00:1c.0: [8086:3a70] type 1 class 0x000604
[    0.670237] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.670242] pci 0000:00:1c.0: PME# disabled
[    0.670271] pci 0000:00:1c.1: [8086:3a72] type 1 class 0x000604
[    0.670353] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.670358] pci 0000:00:1c.1: PME# disabled
[    0.670398] pci 0000:00:1d.0: [8086:3a64] type 0 class 0x000c03
[    0.670459] pci 0000:00:1d.0: reg 20: [io  0xff80-0xff9f]
[    0.670523] pci 0000:00:1d.1: [8086:3a65] type 0 class 0x000c03
[    0.670583] pci 0000:00:1d.1: reg 20: [io  0xff60-0xff7f]
[    0.670647] pci 0000:00:1d.2: [8086:3a66] type 0 class 0x000c03
[    0.670708] pci 0000:00:1d.2: reg 20: [io  0xff40-0xff5f]
[    0.670785] pci 0000:00:1d.7: [8086:3a6a] type 0 class 0x000c03
[    0.670814] pci 0000:00:1d.7: reg 10: [mem 0xff980000-0xff9803ff]
[    0.670917] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.670923] pci 0000:00:1d.7: PME# disabled
[    0.670949] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    0.671032] pci 0000:00:1f.0: [8086:3a1a] type 0 class 0x000601
[    0.671176] pci 0000:00:1f.2: [8086:3a00] type 0 class 0x000101
[    0.671198] pci 0000:00:1f.2: reg 10: [io  0xfe00-0xfe07]
[    0.671210] pci 0000:00:1f.2: reg 14: [io  0xfe10-0xfe13]
[    0.671221] pci 0000:00:1f.2: reg 18: [io  0xfe20-0xfe27]
[    0.671232] pci 0000:00:1f.2: reg 1c: [io  0xfe30-0xfe33]
[    0.671244] pci 0000:00:1f.2: reg 20: [io  0xfec0-0xfecf]
[    0.671255] pci 0000:00:1f.2: reg 24: [io  0xeca0-0xecaf]
[    0.671311] pci 0000:00:1f.3: [8086:3a60] type 0 class 0x000c05
[    0.671332] pci 0000:00:1f.3: reg 10: [mem 0xfebdb000-0xfebdb0ff 64bit]
[    0.671363] pci 0000:00:1f.3: reg 20: [io  0xece0-0xecff]
[    0.671413] pci 0000:00:1f.5: [8086:3a06] type 0 class 0x000101
[    0.671435] pci 0000:00:1f.5: reg 10: [io  0xfe40-0xfe47]
[    0.671446] pci 0000:00:1f.5: reg 14: [io  0xfe50-0xfe53]
[    0.671458] pci 0000:00:1f.5: reg 18: [io  0xfe60-0xfe67]
[    0.671469] pci 0000:00:1f.5: reg 1c: [io  0xfe70-0xfe73]
[    0.671481] pci 0000:00:1f.5: reg 20: [io  0xfed0-0xfedf]
[    0.671492] pci 0000:00:1f.5: reg 24: [io  0xecb0-0xecbf]
[    0.671603] pci 0000:01:00.0: [1002:95c5] type 0 class 0x000300
[    0.671623] pci 0000:01:00.0: reg 10: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.671640] pci 0000:01:00.0: reg 18: [mem 0xfe9f0000-0xfe9fffff 64bit]
[    0.671651] pci 0000:01:00.0: reg 20: [io  0xdc00-0xdcff]
[    0.671671] pci 0000:01:00.0: reg 30: [mem 0xfea00000-0xfea1ffff pref]
[    0.671703] pci 0000:01:00.0: supports D1 D2
[    0.671771] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.671886] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.671890] pci 0000:00:01.0:   bridge window [mem 0xfe900000-0xfeafffff]
[    0.671896] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.671954] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.672072] pci 0000:00:1c.0:   bridge window [mem 0xfe800000-0xfe8fffff]
[    0.672135] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.672252] pci 0000:00:1c.1:   bridge window [mem 0xfe700000-0xfe7fffff]
[    0.672348] pci 0000:00:1e.0: PCI bridge to [bus 04-04] (subtractive decode)
[    0.672473] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.672476] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.672478] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.672481] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000effff] (subtractive decode)
[    0.672484] pci 0000:00:1e.0:   bridge window [mem 0x000f0000-0x000fffff] (subtractive decode)
[    0.672487] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfec00000] (subtractive decode)
[    0.672489] pci 0000:00:1e.0:   bridge window [mem 0xbff00000-0xdfffffff] (subtractive decode)
[    0.672492] pci 0000:00:1e.0:   bridge window [mem 0xff980000-0xff980fff] (subtractive decode)
[    0.672495] pci 0000:00:1e.0:   bridge window [mem 0xff97c000-0xff97ffff] (subtractive decode)
[    0.672498] pci 0000:00:1e.0:   bridge window [mem 0xfed20000-0xfed9ffff] (subtractive decode)
[    0.672500] pci 0000:00:1e.0:   bridge window [mem 0xfeda7000-0xfeda7fff] (subtractive decode)
[    0.672536] pci_bus 0000:00: on NUMA node 0
[    0.672541] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.673512] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI4._PRT]
[    0.674047] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2._PRT]
[    0.674272] ACPI Warning: For \_SB_.PCI0.PCI2._PRT: Return Package has no elements (empty) (20110623/nspredef-463)
[    0.674606] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI3._PRT]
[    0.674981] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.675495]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.675610]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    0.675795] ACPI _OSC control for PCIe not granted, disabling ASPM
[    2.687193] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 15)
[    2.688565] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    2.690657] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *9 10 11 12 15)
[    2.692015] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11 12 15)
[    2.693450] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
[    2.694950] ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 9 10 11 12 15)
[    2.696318] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    2.697669] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12 15)
[    2.698434] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    2.698434] vgaarb: loaded
[    2.698434] vgaarb: bridge control possible 0000:01:00.0
[    2.699843] SCSI subsystem initialized
[    2.699966] libata version 3.00 loaded.
[    2.699966] usbcore: registered new interface driver usbfs
[    2.700002] usbcore: registered new interface driver hub
[    2.700002] usbcore: registered new device driver usb
[    2.700002] Advanced Linux Sound Architecture Driver Version 1.0.24.
[    2.700032] PCI: Using ACPI for IRQ routing
[    2.709474] PCI: pci_cache_line_size set to 64 bytes
[    2.709492] pci 0000:00:03.0: no compatible bridge window for [mem 0xfeda6000-0xfeda600f 64bit]
[    2.709842] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    2.709956] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    2.710070] reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
[    2.710073] reserve RAM buffer: 00000000bfdffc00 - 00000000bfffffff 
[    2.710190] NFC: NFC Core ver 0.1
[    2.710190] NET: Registered protocol family 39
[    2.710190] HPET: 8 timers in total, 2 timers will be used for per-cpu timer
[    2.710190] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 40, 41, 0, 0, 0, 0
[    2.710573] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    2.716680] hpet: hpet2 irq 40 for MSI
[    2.773212] hpet: hpet3 irq 41 for MSI
[    2.776548] Switching to clocksource hpet
[    2.780002] Switched to NOHz mode on CPU #0
[    2.779989] Switched to NOHz mode on CPU #1
[    2.801295] pnp: PnP ACPI init
[    2.801453] ACPI: bus type pnp registered
[    2.823385] pnp 00:00: [bus 00-ff]
[    2.823389] pnp 00:00: [io  0x0cf8-0x0cff]
[    2.823393] pnp 00:00: [io  0x0000-0x0cf7 window]
[    2.823396] pnp 00:00: [io  0x0d00-0xffff window]
[    2.823400] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    2.823404] pnp 00:00: [mem 0x000c0000-0x000effff window]
[    2.823407] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    2.823411] pnp 00:00: [mem 0xf0000000-0xfec00000 window]
[    2.823414] pnp 00:00: [mem 0xbff00000-0xdfffffff window]
[    2.823418] pnp 00:00: [mem 0xf0000000-0xefffffff window disabled]
[    2.823422] pnp 00:00: [mem 0xff980000-0xff980fff window]
[    2.823425] pnp 00:00: [mem 0xff97c000-0xff97ffff window]
[    2.823429] pnp 00:00: [mem 0xfed20000-0xfed9ffff window]
[    2.823432] pnp 00:00: [mem 0xfeda7000-0xfeda7fff window]
[    2.823633] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    2.828858] pnp 00:01: [io  0x0060]
[    2.828861] pnp 00:01: [io  0x0064]
[    2.828863] pnp 00:01: [io  0x0062-0x0063]
[    2.828866] pnp 00:01: [io  0x0065-0x006f]
[    2.828868] pnp 00:01: [io  0x00e0-0x00ef]
[    2.828870] pnp 00:01: [io  0x0800-0x085f]
[    2.828873] pnp 00:01: [io  0x0c00-0x0c7f]
[    2.828876] pnp 00:01: [io  0x0860-0x08ff]
[    2.829092] system 00:01: [io  0x0800-0x085f] has been reserved
[    2.829206] system 00:01: [io  0x0c00-0x0c7f] has been reserved
[    2.829320] system 00:01: [io  0x0860-0x08ff] has been reserved
[    2.829435] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    2.829729] pnp 00:02: [io  0x0080-0x009f]
[    2.829732] pnp 00:02: [io  0x0000-0x001f]
[    2.829734] pnp 00:02: [io  0x00c0-0x00df]
[    2.829737] pnp 00:02: [dma 4]
[    2.829869] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    2.830115] pnp 00:03: [io  0x00f0-0x00ff]
[    2.830130] pnp 00:03: [irq 13]
[    2.830263] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    2.830487] pnp 00:04: [io  0x0061]
[    2.830617] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    2.830844] pnp 00:05: [io  0x0070-0x007f]
[    2.830852] pnp 00:05: [irq 8]
[    2.830985] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.849109] pnp 00:06: [io  0x0378-0x037f]
[    2.849112] pnp 00:06: [io  0x0778-0x077f]
[    2.849121] pnp 00:06: [irq 7]
[    2.849123] pnp 00:06: [dma 0 disabled]
[    2.850494] pnp 00:06: Plug and Play ACPI device, IDs PNP0401 (active)
[    2.856401] pnp 00:07: [io  0x03f8-0x03ff]
[    2.856410] pnp 00:07: [irq 4]
[    2.856959] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.877494] pnp 00:08: [mem 0xfed00000-0xfed003ff]
[    2.877652] pnp 00:08: Plug and Play ACPI device, IDs PNP0103 (active)
[    2.877669] pnp: PnP ACPI: found 9 devices
[    2.877781] ACPI: ACPI bus type pnp unregistered
[    2.890885] PCI: max bus depth: 1 pci_try_num: 2
[    2.890934] pci 0000:00:03.0: BAR 0: assigned [mem 0xf0000000-0xf000000f 64bit]
[    2.891128] pci 0000:00:03.0: BAR 0: set to [mem 0xf0000000-0xf000000f 64bit] (PCI address [0xf0000000-0xf000000f])
[    2.891318] pci 0000:00:1c.1: BAR 9: assigned [mem 0xf0100000-0xf02fffff 64bit pref]
[    2.891504] pci 0000:00:1c.1: BAR 7: assigned [io  0x1000-0x1fff]
[    2.891620] pci 0000:00:1c.0: BAR 9: assigned [mem 0xf0300000-0xf04fffff 64bit pref]
[    2.891807] pci 0000:00:1c.0: BAR 7: assigned [io  0x2000-0x2fff]
[    2.891922] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    2.892036] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    2.892153] pci 0000:00:01.0:   bridge window [mem 0xfe900000-0xfeafffff]
[    2.892268] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    2.892456] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    2.892570] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    2.892688] pci 0000:00:1c.0:   bridge window [mem 0xfe800000-0xfe8fffff]
[    2.892805] pci 0000:00:1c.0:   bridge window [mem 0xf0300000-0xf04fffff 64bit pref]
[    2.892996] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    2.893110] pci 0000:00:1c.1:   bridge window [io  0x1000-0x1fff]
[    2.893226] pci 0000:00:1c.1:   bridge window [mem 0xfe700000-0xfe7fffff]
[    2.893376] pci 0000:00:1c.1:   bridge window [mem 0xf0100000-0xf02fffff 64bit pref]
[    2.893566] pci 0000:00:1e.0: PCI bridge to [bus 04-04]
[    2.893713] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.893829] pci 0000:00:01.0: setting latency timer to 64
[    2.893838] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.893954] pci 0000:00:1c.0: setting latency timer to 64
[    2.893971] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.894087] pci 0000:00:1c.1: setting latency timer to 64
[    2.894096] pci 0000:00:1e.0: setting latency timer to 64
[    2.894100] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.894103] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.894105] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.894108] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000effff]
[    2.894110] pci_bus 0000:00: resource 8 [mem 0x000f0000-0x000fffff]
[    2.894113] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfec00000]
[    2.894115] pci_bus 0000:00: resource 10 [mem 0xbff00000-0xdfffffff]
[    2.894118] pci_bus 0000:00: resource 11 [mem 0xff980000-0xff980fff]
[    2.894120] pci_bus 0000:00: resource 12 [mem 0xff97c000-0xff97ffff]
[    2.894123] pci_bus 0000:00: resource 13 [mem 0xfed20000-0xfed9ffff]
[    2.894125] pci_bus 0000:00: resource 14 [mem 0xfeda7000-0xfeda7fff]
[    2.894128] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    2.894130] pci_bus 0000:01: resource 1 [mem 0xfe900000-0xfeafffff]
[    2.894133] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    2.894135] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    2.894138] pci_bus 0000:02: resource 1 [mem 0xfe800000-0xfe8fffff]
[    2.894140] pci_bus 0000:02: resource 2 [mem 0xf0300000-0xf04fffff 64bit pref]
[    2.894143] pci_bus 0000:03: resource 0 [io  0x1000-0x1fff]
[    2.894145] pci_bus 0000:03: resource 1 [mem 0xfe700000-0xfe7fffff]
[    2.894148] pci_bus 0000:03: resource 2 [mem 0xf0100000-0xf02fffff 64bit pref]
[    2.894151] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]
[    2.894153] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]
[    2.894155] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
[    2.894158] pci_bus 0000:04: resource 7 [mem 0x000c0000-0x000effff]
[    2.894160] pci_bus 0000:04: resource 8 [mem 0x000f0000-0x000fffff]
[    2.894163] pci_bus 0000:04: resource 9 [mem 0xf0000000-0xfec00000]
[    2.894165] pci_bus 0000:04: resource 10 [mem 0xbff00000-0xdfffffff]
[    2.894168] pci_bus 0000:04: resource 11 [mem 0xff980000-0xff980fff]
[    2.894170] pci_bus 0000:04: resource 12 [mem 0xff97c000-0xff97ffff]
[    2.894173] pci_bus 0000:04: resource 13 [mem 0xfed20000-0xfed9ffff]
[    2.894175] pci_bus 0000:04: resource 14 [mem 0xfeda7000-0xfeda7fff]
[    2.894243] NET: Registered protocol family 2
[    2.894524] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    2.895705] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    2.897341] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
[    2.904071] TCP: Hash tables configured (established 262144 bind 65536)
[    2.904235] TCP reno registered
[    2.904381] UDP hash table entries: 4096 (order: 7, 655360 bytes)
[    2.905377] UDP-Lite hash table entries: 4096 (order: 7, 655360 bytes)
[    2.906512] NET: Registered protocol family 1
[    2.907062] pci 0000:01:00.0: Boot video device
[    2.907067] PCI: CLS 64 bytes, default 64
[    2.907239] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.907354] Placing 64MB software IO TLB between ffff8800bbdfa000 - ffff8800bfdfa000
[    2.907538] software IO TLB at phys 0xbbdfa000 - 0xbfdfa000
[    2.907660] Simple Boot Flag at 0x7a set to 0x80
[    2.908839] Machine check injector initialized
[    2.909825] microcode: CPU0 sig=0x1067a, pf=0x10, revision=0xa07
[    2.909948] microcode: CPU1 sig=0x1067a, pf=0x10, revision=0xa07
[    2.910190] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    2.910669] kworker/u:0 used greatest stack depth: 4904 bytes left
[    2.911161] audit: initializing netlink socket (disabled)
[    2.911306] type=2000 audit(1317027438.909:1): initialized
[    2.962011] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.009615] VFS: Disk quotas dquot_6.5.2
[    3.009925] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.012440] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, debug enabled
[    3.013965] SGI XFS Quota Management subsystem
[    3.015183] Btrfs loaded
[    3.015300] msgmni has been set to 15676
[    3.016269] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    3.016467] io scheduler noop registered
[    3.016578] io scheduler deadline registered
[    3.016897] io scheduler cfq registered (default)
[    3.017328] pcieport 0000:00:01.0: setting latency timer to 64
[    3.017411] pcieport 0000:00:01.0: irq 42 for MSI/MSI-X
[    3.017590] pcieport 0000:00:1c.0: setting latency timer to 64
[    3.017648] pcieport 0000:00:1c.0: irq 43 for MSI/MSI-X
[    3.017823] pcieport 0000:00:1c.1: setting latency timer to 64
[    3.017880] pcieport 0000:00:1c.1: irq 44 for MSI/MSI-X
[    3.019089] ALI M7101 PMU not found.
[    3.019805] intel_idle: MWAIT substates: 0x22220
[    3.019808] intel_idle: does not run on family 6 model 23
[    3.020153] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    3.020385] ACPI: Power Button [VBTN]
[    3.020671] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    3.020862] ACPI: Power Button [PWRF]
[    3.022204] ACPI: acpi_idle registered with cpuidle
[    3.024805] Monitor-Mwait will be used to enter C-1 state
[    3.152907] ERST: Table is not found!
[    3.153019] GHES: HEST is not enabled!
[    3.153129] EINJ: Table is not found!
[    3.153572] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.426836] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.491401] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.503506] serial 0000:00:03.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.524052] 0000:00:03.3: ttyS1 at I/O 0xec98 (irq = 17) is a 16550A
[    3.540968] Non-volatile memory driver v1.3
[    3.541339] Linux agpgart interface v0.103
[    3.542220] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    3.542405] Hangcheck: Using getrawmonotonic().
[    3.542661] ramoops: platform device not found, using module parameters
[    3.542879] ramoops: The memory size and the record size must be non-zero
[    3.542998] ramoops: probe of ramoops failed with error -22
[    3.543452] [drm] Initialized drm 1.1.0 20060810
[    3.543564] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
[    3.548097] brd: module loaded
[    3.550836] loop: module loaded
[    3.551362] Loading iSCSI transport class v2.0-870.
[    3.552538] ata_piix 0000:00:1f.2: version 2.13
[    3.552579] ata_piix 0000:00:1f.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.552697] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    3.703408] ata_piix 0000:00:1f.2: setting latency timer to 64
[    3.704907] scsi0 : ata_piix
[    3.705393] scsi1 : ata_piix
[    3.711927] ata1: SATA max UDMA/133 cmd 0xfe00 ctl 0xfe10 bmdma 0xfec0 irq 18
[    3.712044] ata2: SATA max UDMA/133 cmd 0xfe20 ctl 0xfe30 bmdma 0xfec8 irq 18
[    3.712285] ata_piix 0000:00:1f.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.712430] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    3.863392] ata_piix 0000:00:1f.5: setting latency timer to 64
[    3.864437] scsi2 : ata_piix
[    3.864818] scsi3 : ata_piix
[    3.865186] ata3: SATA max UDMA/133 cmd 0xfe40 ctl 0xfe50 bmdma 0xfed0 irq 18
[    3.865301] ata4: SATA max UDMA/133 cmd 0xfe60 ctl 0xfe70 bmdma 0xfed8 irq 18
[    3.867701] ata_generic 0000:00:03.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.867919] ata_generic 0000:00:03.2: setting latency timer to 64
[    3.869145] scsi4 : ata_generic
[    3.869514] scsi5 : ata_generic
[    3.869843] ata5: PATA max UDMA/100 cmd 0xfe80 ctl 0xfe90 bmdma 0xfef0 irq 18
[    3.869957] ata6: PATA max UDMA/100 cmd 0xfea0 ctl 0xfeb0 bmdma 0xfef8 irq 18
[    3.872024] e1000e: Intel(R) PRO/1000 Network Driver - 1.4.4-k
[    3.872137] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    3.872288] e1000e 0000:00:19.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    3.872408] e1000e 0000:00:19.0: setting latency timer to 64
[    3.872563] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[    3.910077] Refined TSC clocksource calibration: 2659.983 MHz.
[    3.910216] Switching to clocksource tsc
[    4.067415] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:23:ae:98:ce:24
[    4.067601] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    4.067777] e1000e 0000:00:19.0: eth0: MAC: 8, PHY: 8, PBA No: 8021FF-0FF
[    4.068193] sky2: driver version 1.29
[    4.068405] PPP generic driver version 2.4.2
[    4.068770] PPP Deflate Compression module registered
[    4.068882] PPP BSD Compression module registered
[    4.069259] PPP MPPE Compression module registered
[    4.069372] NET: Registered protocol family 24
[    4.069497] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256) (6 bit encapsulation enabled).
[    4.069682] CSLIP: code copyright 1989 Regents of the University of California.
[    4.069866] SLIP linefill/keepalive option.
[    4.070022] console [netcon0] enabled
[    4.070132] netconsole: network logging started
[    4.070647] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.070798] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    4.070927] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    4.070931] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    4.071147] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    4.071391] ehci_hcd 0000:00:1a.7: debug port 1
[    4.075383] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    4.075415] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfebda000
[    4.086696] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    4.086992] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    4.087106] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.087290] usb usb1: Product: EHCI Host Controller
[    4.087402] usb usb1: Manufacturer: Linux 3.1.0-rc6+ ehci_hcd
[    4.087514] usb usb1: SerialNumber: 0000:00:1a.7
[    4.088216] hub 1-0:1.0: USB hub found
[    4.088358] hub 1-0:1.0: 6 ports detected
[    4.088802] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    4.088929] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.088933] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.089055] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    4.089270] ehci_hcd 0000:00:1d.7: debug port 1
[    4.093262] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    4.093293] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xff980000
[    4.106690] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.106863] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    4.106983] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.107170] usb usb2: Product: EHCI Host Controller
[    4.107282] usb usb2: Manufacturer: Linux 3.1.0-rc6+ ehci_hcd
[    4.107394] usb usb2: SerialNumber: 0000:00:1d.7
[    4.107840] hub 2-0:1.0: USB hub found
[    4.107960] hub 2-0:1.0: 6 ports detected
[    4.108345] uhci_hcd: USB Universal Host Controller Interface driver
[    4.108503] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.108623] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.108626] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    4.108747] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    4.108981] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000ff20
[    4.109174] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    4.109287] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.109472] usb usb3: Product: UHCI Host Controller
[    4.109583] usb usb3: Manufacturer: Linux 3.1.0-rc6+ uhci_hcd
[    4.109695] usb usb3: SerialNumber: 0000:00:1a.0
[    4.110155] hub 3-0:1.0: USB hub found
[    4.110275] hub 3-0:1.0: 2 ports detected
[    4.110581] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    4.110700] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    4.110704] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    4.110825] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    4.111058] uhci_hcd 0000:00:1a.1: irq 17, io base 0x0000ff00
[    4.111231] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    4.111344] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.111528] usb usb4: Product: UHCI Host Controller
[    4.111640] usb usb4: Manufacturer: Linux 3.1.0-rc6+ uhci_hcd
[    4.111752] usb usb4: SerialNumber: 0000:00:1a.1
[    4.112172] hub 4-0:1.0: USB hub found
[    4.112291] hub 4-0:1.0: 2 ports detected
[    4.112581] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    4.112702] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    4.112706] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    4.112827] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    4.113038] uhci_hcd 0000:00:1a.2: irq 22, io base 0x0000fc00
[    4.113211] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    4.113325] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.113526] usb usb5: Product: UHCI Host Controller
[    4.113638] usb usb5: Manufacturer: Linux 3.1.0-rc6+ uhci_hcd
[    4.113750] usb usb5: SerialNumber: 0000:00:1a.2
[    4.114165] hub 5-0:1.0: USB hub found
[    4.114283] hub 5-0:1.0: 2 ports detected
[    4.114577] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    4.114697] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.114700] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.114821] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    4.115031] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000ff80
[    4.115204] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    4.115317] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.115501] usb usb6: Product: UHCI Host Controller
[    4.115613] usb usb6: Manufacturer: Linux 3.1.0-rc6+ uhci_hcd
[    4.115725] usb usb6: SerialNumber: 0000:00:1d.0
[    4.116156] hub 6-0:1.0: USB hub found
[    4.116274] hub 6-0:1.0: 2 ports detected
[    4.116564] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    4.116697] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.116701] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.116822] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    4.117032] uhci_hcd 0000:00:1d.1: irq 17, io base 0x0000ff60
[    4.117207] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    4.117320] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.117504] usb usb7: Product: UHCI Host Controller
[    4.117616] usb usb7: Manufacturer: Linux 3.1.0-rc6+ uhci_hcd
[    4.117728] usb usb7: SerialNumber: 0000:00:1d.1
[    4.118163] hub 7-0:1.0: USB hub found
[    4.118281] hub 7-0:1.0: 2 ports detected
[    4.118572] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    4.118691] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    4.118695] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.118817] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    4.119029] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000ff40
[    4.119202] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    4.119315] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.119499] usb usb8: Product: UHCI Host Controller
[    4.119610] usb usb8: Manufacturer: Linux 3.1.0-rc6+ uhci_hcd
[    4.119723] usb usb8: SerialNumber: 0000:00:1d.2
[    4.120154] hub 8-0:1.0: USB hub found
[    4.120272] hub 8-0:1.0: 2 ports detected
[    4.120635] Initializing USB Mass Storage driver...
[    4.120853] usbcore: registered new interface driver usb-storage
[    4.120965] USB Mass Storage support registered.
[    4.121269] usbcore: registered new interface driver libusual
[    4.121697] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    4.124622] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.124779] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.125370] mousedev: PS/2 mouse device common for all mice
[    4.126157] rtc_cmos 00:05: RTC can wake from S4
[    4.126586] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    4.126745] rtc0: alarms up to one day, 242 bytes nvram, hpet irqs
[    4.126929] i2c /dev entries driver
[    4.127241] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    4.128847] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[    4.129202] iTCO_wdt: Found a ICH10D TCO device (Version=2, TCOBASE=0x0860)
[    4.129490] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    4.129606] iTCO_vendor_support: vendor-support=0
[    4.130171] device-mapper: ioctl: 4.21.0-ioctl (2011-07-06) initialised: dm-devel@redhat.com
[    4.130515] device-mapper: dm-log-userspace: version 1.1.0 loaded
[    4.130733] cpuidle: using governor ladder
[    4.130845] cpuidle: using governor menu
[    4.131099] sdhci: Secure Digital Host Controller Interface driver
[    4.131212] sdhci: Copyright(c) Pierre Ossman
[    4.131608] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    4.134102] usbcore: registered new interface driver usbhid
[    4.134216] usbhid: USB HID core driver
[    4.134419] ALSA device list:
[    4.134530]   No soundcards found.
[    4.134659] Netfilter messages via NETLINK v0.30.
[    4.134824] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    4.135428] ctnetlink v0.93: registering with nfnetlink.
[    4.136956] ip_tables: (C) 2000-2006 Netfilter Core Team
[    4.137148] TCP cubic registered
[    4.137260] NET: Registered protocol family 17
[    4.137431] 8021q: 802.1Q VLAN Support v1.8
[    4.137574] lib80211: common routines for IEEE802.11 drivers
[    4.137695] lib80211_crypt: registered algorithm 'NULL'
[    4.137697] Registering the dns_resolver key type
[    4.138266] PM: Hibernation image not present or could not be loaded.
[    4.138295] registered taskstats version 1
[    4.159341]   Magic number: 11:262:979
[    4.161691] p4-clockmod: Warning: EST-capable CPU detected. The acpi-cpufreq module offers voltage scaling in addition to frequency scaling. You should use that instead of p4-clockmod, if possible.
[    4.161957] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[    4.162312] Initializing network drop monitor service
[    4.183391] ata3: SATA link down (SStatus 4 SControl 300)
[    4.183571] ata4: SATA link down (SStatus 4 SControl 300)
[    4.503414] ata2.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.503546] ata2.01: SATA link down (SStatus 4 SControl 300)
[    4.503666] ata2.01: link offline, clearing class 3 to NONE
[    4.503817] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.503937] ata1.01: SATA link down (SStatus 4 SControl 300)
[    4.504298] ata2.00: ATAPI: TSSTcorp DVD+/-RW TS-H653G, D200, max UDMA/100
[    4.504414] ata2.00: applying bridge limits
[    4.516808] ata2.00: configured for UDMA/100
[    4.533643] ata1.00: ATA-8: Hitachi HDP725032GLA360, GM3OA5BA, max UDMA/133
[    4.533761] ata1.00: 625142448 sectors, multi 8: LBA48 NCQ (depth 0/32)
[    4.546977] ata1.00: configured for UDMA/133
[    4.547677] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HDP72503 GM3O PQ: 0 ANSI: 5
[    4.548663] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    4.548956] sd 0:0:0:0: [sda] Write Protect is off
[    4.549070] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.549115] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.549139] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.552408] scsi 1:0:0:0: CD-ROM            TSSTcorp DVD+-RW TS-H653G D200 PQ: 0 ANSI: 5
[    4.555074] sr0: scsi3-mmc drive: 94x/94x writer dvd-ram cd/rw xa/form2 cdda tray
[    4.555269] cdrom: Uniform CD-ROM driver Revision: 3.20
[    4.555944] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    4.556293] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    4.603990]  sda: sda1 sda2 sda3 sda4 < sda5 >
[    4.605279] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.620032] usb 3-1: new low speed USB device number 2 using uhci_hcd
[    4.721236] md: Waiting for all devices to be available before autodetect
[    4.721349] md: If you don't use raid, use raid=noautodetect
[    4.722211] md: Autodetecting RAID arrays.
[    4.722323] md: Scanned 0 and added 0 devices.
[    4.722435] md: autorun ...
[    4.722544] md: ... autorun DONE.
[    4.739795] EXT3-fs (sda2): error: couldn't mount because of unsupported optional features (240)
[    4.749728] EXT4-fs (sda2): INFO: recovery required on readonly filesystem
[    4.749842] EXT4-fs (sda2): write access will be enabled during recovery
[    4.824174] usb 3-1: New USB device found, idVendor=413c, idProduct=2106
[    4.824298] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.824415] usb 3-1: Product: Dell QuietKey Keyboard
[    4.824530] usb 3-1: Manufacturer: Dell
[    4.859896] input: Dell Dell QuietKey Keyboard as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.0/input/input2
[    4.860916] generic-usb 0003:413C:2106.0001: input,hidraw0: USB HID v1.10 Keyboard [Dell Dell QuietKey Keyboard] on usb-0000:00:1a.0-1/input0
[    5.086782] usb 3-2: new low speed USB device number 3 using uhci_hcd
[    5.144906] EXT4-fs (sda2): orphan cleanup on readonly fs
[    5.177782] EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 2498340
[    5.216467] EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 6569583
[    5.245834] EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 8126468
[    5.245873] EXT4-fs (sda2): 3 orphan inodes deleted
[    5.245991] EXT4-fs (sda2): recovery complete
[    5.253162] usb 3-2: New USB device found, idVendor=413c, idProduct=3012
[    5.253281] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.253420] usb 3-2: Product: Dell USB Optical Mouse
[    5.253532] usb 3-2: Manufacturer: Dell
[    5.269503] input: Dell Dell USB Optical Mouse as /devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2:1.0/input/input3
[    5.270113] generic-usb 0003:413C:3012.0002: input,hidraw1: USB HID v1.11 Mouse [Dell Dell USB Optical Mouse] on usb-0000:00:1a.0-2/input0
[    5.521029] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    5.521280] VFS: Mounted root (ext4 filesystem) readonly on device 8:2.
[    5.522433] Freeing unused kernel memory: 560k freed
[    6.197920] mount used greatest stack depth: 4336 bytes left
[    6.399187] sed used greatest stack depth: 4032 bytes left
[    7.172334] wmi: Mapper loaded
[    7.208497] input: Dell WMI hotkeys as /devices/virtual/input/input4
[    7.503399] cdrom_id used greatest stack depth: 3648 bytes left
[    8.484264] [drm] radeon defaulting to kernel modesetting.
[    8.484380] [drm] radeon kernel modesetting enabled.
[    8.484599] radeon 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    8.484718] radeon 0000:01:00.0: setting latency timer to 64
[    8.485366] [drm] initializing kernel modesetting (RV620 0x1002:0x95C5 0x1028:0x0342).
[    8.485623] [drm] register mmio base: 0xFE9F0000
[    8.485734] [drm] register mmio size: 65536
[    8.486082] ATOM BIOS: 113
[    8.486244] radeon 0000:01:00.0: VRAM: 256M 0x0000000000000000 - 0x000000000FFFFFFF (256M used)
[    8.486430] radeon 0000:01:00.0: GTT: 512M 0x0000000010000000 - 0x000000002FFFFFFF
[    8.487497] [drm] Detected VRAM RAM=256M, BAR=256M
[    8.487612] [drm] RAM width 64bits DDR
[    8.488063] [TTM] Zone  kernel: Available graphics memory: 4013514 kiB.
[    8.488176] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[    8.488289] [TTM] Initializing pool allocator.
[    8.488757] [drm] radeon: 256M of VRAM memory ready
[    8.488870] [drm] radeon: 512M of GTT memory ready.
[    8.489039] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    8.489152] [drm] Driver supports precise vblank timestamp query.
[    8.489358] radeon 0000:01:00.0: irq 46 for MSI/MSI-X
[    8.489367] radeon 0000:01:00.0: radeon: using MSI.
[    8.489539] [drm] radeon: irq initialized.
[    8.489653] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    8.490391] [drm] Loading RV620 Microcode
[    8.649072] radeon 0000:01:00.0: WB enabled
[    8.680836] [drm] ring test succeeded in 0 usecs
[    8.681267] [drm] radeon: ib pool ready.
[    8.681813] [drm] ib test succeeded in 0 usecs
[    8.681931] failed to evaluate ATIF got AE_BAD_PARAMETER
[    8.685549] [drm] Radeon Display Connectors
[    8.685665] [drm] Connector 0:
[    8.685793] [drm]   DIN
[    8.685919] [drm]   Encoders:
[    8.686117] [drm]     TV1: INTERNAL_KLDSCP_DAC2
[    8.686232] [drm] Connector 1:
[    8.686352] [drm]   DVI-I
[    8.686546] [drm]   HPD1
[    8.686697] [drm]   DDC: 0x7e60 0x7e60 0x7e64 0x7e64 0x7e68 0x7e68 0x7e6c 0x7e6c
[    8.686938] [drm]   Encoders:
[    8.687078] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    8.687221] [drm]     DFP2: INTERNAL_KLDSCP_LVTMA
[    8.687353] [drm] Connector 2:
[    8.687474] [drm]   DVI-I
[    8.687589] [drm]   HPD2
[    8.687699] [drm]   DDC: 0x7e20 0x7e20 0x7e24 0x7e24 0x7e28 0x7e28 0x7e2c 0x7e2c
[    8.687883] [drm]   Encoders:
[    8.687996] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
[    8.688115] [drm]     DFP1: INTERNAL_UNIPHY
[    8.698693] [drm] Radeon display connector DVI-I-1: No monitor connected or invalid EDID
[    8.751120] [drm] Radeon display connector DVI-I-2: Found valid EDID
[    8.751356] [drm] Internal thermal controller with fan control
[    8.751739] [drm] radeon: power management initialized
[    8.840859] [drm] fb mappable at 0xD0141000
[    8.840990] [drm] vram apper at 0xD0000000
[    8.841115] [drm] size 7299072
[    8.841232] [drm] fb depth is 24
[    8.841346] [drm]    pitch is 6912
[    8.841876] fbcon: radeondrmfb (fb0) is primary device
[    8.912320] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    8.912403] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[    8.912458] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[    9.261224] Console: switching to colour frame buffer device 210x65
[    9.265653] fb0: radeondrmfb frame buffer device
[    9.265655] drm: registered panic notifier
[    9.265755] [drm] Initialized radeon 2.11.0 20080528 for 0000:01:00.0 on minor 0
[    9.268132] modprobe used greatest stack depth: 3040 bytes left
[   11.967906] Adding 10241432k swap on /dev/sda3.  Priority:-1 extents:1 across:10241432k 
[   12.068620] fuse init (API version 7.17)
[   12.683672] EXT4-fs (sda2): re-mounted. Opts: (null)
[   12.769135] EXT4-fs (sda2): re-mounted. Opts: (null)
[   22.600387] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[   22.653453] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[   25.694231] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[  224.243413] tun: Universal TUN/TAP device driver, 1.6
[  224.243416] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[  289.902607] device eth0 entered promiscuous mode
[  289.928305] device tap0 entered promiscuous mode
[  289.936098] device tap1 entered promiscuous mode
[  289.943304] device tap2 entered promiscuous mode
[  290.118821] br0: port 1(eth0) entering forwarding state
[  290.118874] br0: port 1(eth0) entering forwarding state
[  300.281274] br0: port 2(tap0) entering forwarding state
[  300.281313] br0: port 2(tap0) entering forwarding state
[  414.597126] qemu-system-x86 used greatest stack depth: 2960 bytes left
[ 7110.523708] oosplash.bin[2460]: segfault at 968 ip 00007f2f3c06aaa6 sp 00007fff22538700 error 4 in libX11.so.6.3.0[7f2f3c02c000+13a000]
[ 8075.347144] br0: port 2(tap0) entering forwarding state
[ 8081.390462] br0: port 2(tap0) entering forwarding state
[ 8081.390480] br0: port 2(tap0) entering forwarding state
[26437.224061] usb 2-1: new high speed USB device number 2 using ehci_hcd
[26437.349020] usb 2-1: New USB device found, idVendor=0421, idProduct=01c7
[26437.349025] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[26437.349028] usb 2-1: Product: N900 (Storage Mode)
[26437.349031] usb 2-1: Manufacturer: Nokia
[26437.349034] usb 2-1: SerialNumber: 372041756775
[26437.350435] scsi6 : usb-storage 2-1:1.0
[26438.351987] scsi 6:0:0:0: Direct-Access     Nokia    N900              031 PQ: 0 ANSI: 2
[26438.352918] sd 6:0:0:0: Attached scsi generic sg2 type 0
[26438.355564] scsi 6:0:0:1: Direct-Access     Nokia    N900              031 PQ: 0 ANSI: 2
[26438.357401] sd 6:0:0:1: Attached scsi generic sg3 type 0
[26438.358080] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[26438.364416] sd 6:0:0:1: [sdc] Attached SCSI removable disk
[26442.529189] usb 2-1: USB disconnect, device number 2
[26443.144062] usb 2-1: new high speed USB device number 3 using ehci_hcd
[26443.268396] usb 2-1: New USB device found, idVendor=0421, idProduct=01c8
[26443.268401] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[26443.268404] usb 2-1: Product: N900 (PC-Suite Mode)
[26443.268407] usb 2-1: Manufacturer: Nokia
[26443.365490] cdc_ether 2-1:1.8: usb0: register 'cdc_ether' at usb-0000:00:1d.7-1, CDC Ethernet Device, f6:5b:28:e8:18:45
[26443.365530] usbcore: registered new interface driver cdc_ether
[33448.713892] qemu-system-x86 used greatest stack depth: 2528 bytes left
[34184.306286] usb 2-1: USB disconnect, device number 3
[34184.307420] cdc_ether 2-1:1.8: usb0: unregister 'cdc_ether' usb-0000:00:1d.7-1, CDC Ethernet Device
[86746.888131] device tap2 left promiscuous mode
[86746.888138] br0: port 4(tap2) entering disabled state
[86746.922713] device tap1 left promiscuous mode
[86746.922719] br0: port 3(tap1) entering disabled state
[86746.949350] device tap0 left promiscuous mode
[86746.949357] br0: port 2(tap0) entering forwarding state
[86746.951942] device eth0 left promiscuous mode
[86746.951958] br0: port 1(eth0) entering forwarding state
[86746.953325] br0: mixed no checksumming and other settings.
[86750.415764] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[86750.468104] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[86752.418321] device eth0 entered promiscuous mode
[86752.424530] device tap0 entered promiscuous mode
[86752.431298] device tap1 entered promiscuous mode
[86752.441423] device tap2 entered promiscuous mode
[86752.536484] br0: port 2(tap0) entering forwarding state
[86752.536496] br0: port 2(tap0) entering forwarding state
[86753.508888] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[86753.509857] br0: port 1(eth0) entering forwarding state
[86753.509867] br0: port 1(eth0) entering forwarding state
[86857.334684] usb 2-1: new high speed USB device number 4 using ehci_hcd
[86857.459847] usb 2-1: New USB device found, idVendor=0421, idProduct=01c7
[86857.459852] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[86857.459855] usb 2-1: Product: N900 (Storage Mode)
[86857.459858] usb 2-1: Manufacturer: Nokia
[86857.459860] usb 2-1: SerialNumber: 372041756775
[86857.461253] scsi7 : usb-storage 2-1:1.0
[86858.462260] scsi 7:0:0:0: Direct-Access     Nokia    N900              031 PQ: 0 ANSI: 2
[86858.462968] sd 7:0:0:0: Attached scsi generic sg2 type 0
[86858.465270] scsi 7:0:0:1: Direct-Access     Nokia    N900              031 PQ: 0 ANSI: 2
[86858.467216] sd 7:0:0:1: Attached scsi generic sg3 type 0
[86858.469636] sd 7:0:0:0: [sdb] Attached SCSI removable disk
[86858.474489] sd 7:0:0:1: [sdc] Attached SCSI removable disk
[90843.577335] oosplash.bin[29918]: segfault at 968 ip 00007ffebd53baa6 sp 00007fff91ca06b0 error 4 in libX11.so.6.3.0[7ffebd4fd000+13a000]
[96087.834687] usb 2-1: USB disconnect, device number 4
[96109.793770] usb 2-1: new high speed USB device number 5 using ehci_hcd
[96109.918253] usb 2-1: New USB device found, idVendor=0421, idProduct=01c7
[96109.918258] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[96109.918261] usb 2-1: Product: N900 (Storage Mode)
[96109.918264] usb 2-1: Manufacturer: Nokia
[96109.918266] usb 2-1: SerialNumber: 372041756775
[96109.919618] scsi8 : usb-storage 2-1:1.0
[96110.917787] scsi 8:0:0:0: Direct-Access     Nokia    N900              031 PQ: 0 ANSI: 2
[96110.918432] sd 8:0:0:0: Attached scsi generic sg2 type 0
[96110.920956] scsi 8:0:0:1: Direct-Access     Nokia    N900              031 PQ: 0 ANSI: 2
[96110.921753] sd 8:0:0:1: Attached scsi generic sg3 type 0
[96110.925773] sd 8:0:0:0: [sdb] Attached SCSI removable disk
[96110.927020] sd 8:0:0:1: [sdc] Attached SCSI removable disk
[96111.868423] usb 2-1: USB disconnect, device number 5
[96112.337114] usb 2-1: new high speed USB device number 6 using ehci_hcd
[96112.461502] usb 2-1: New USB device found, idVendor=0421, idProduct=01c8
[96112.461507] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[96112.461510] usb 2-1: Product: N900 (PC-Suite Mode)
[96112.461513] usb 2-1: Manufacturer: Nokia
[96112.466176] cdc_ether 2-1:1.8: usb0: register 'cdc_ether' at usb-0000:00:1d.7-1, CDC Ethernet Device, ba:df:23:e1:84:43
[96123.655301] usb 2-1: USB disconnect, device number 6
[96123.659556] cdc_ether 2-1:1.8: usb0: unregister 'cdc_ether' usb-0000:00:1d.7-1, CDC Ethernet Device
[99072.790141] usb 2-1: new high speed USB device number 7 using ehci_hcd
[99072.914497] usb 2-1: New USB device found, idVendor=0421, idProduct=01c8
[99072.914501] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[99072.914504] usb 2-1: Product: N900 (PC-Suite Mode)
[99072.914506] usb 2-1: Manufacturer: Nokia
[99072.920300] cdc_ether 2-1:1.8: usb0: register 'cdc_ether' at usb-0000:00:1d.7-1, CDC Ethernet Device, ba:df:23:e1:84:43
[105814.266213] usb 2-1: USB disconnect, device number 7
[105814.268472] cdc_ether 2-1:1.8: usb0: unregister 'cdc_ether' usb-0000:00:1d.7-1, CDC Ethernet Device
[106889.082975] ata1.00: configured for UDMA/133
[106889.082983] ata1: EH complete
[106889.951098] EXT4-fs (sda2): re-mounted. Opts: commit=0
[106890.932965] PM: Syncing filesystems ... done.
[106891.025711] PM: Preparing system for mem sleep
[106891.053585] Freezing user space processes ... (elapsed 0.01 seconds) done.
[106891.066030] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[106891.079352] PM: Entering mem sleep
[106891.079423] Suspending console(s) (use no_console_suspend to debug)
[106891.080993] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[106891.081195] sd 0:0:0:0: [sda] Stopping disk
[106891.083419] serial 00:07: disabled
[106891.092872] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[106891.092902] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[106891.092920] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[106891.092938] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[106891.093602] ehci_hcd 0000:00:1a.7: PCI INT C disabled
[106891.093628] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[106891.093652] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[106891.093833] ACPI handle has no context!
[106891.094171] ata_generic 0000:00:03.2: PCI INT C disabled
[106891.094267] ata_piix 0000:00:1f.5: PCI INT C disabled
[106891.096106] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[106891.116419] br0: port 1(eth0) entering forwarding state
[106891.178357] e1000e 0000:00:19.0: PCI INT A disabled
[106891.178364] e1000e 0000:00:19.0: PME# enabled
[106891.178404]  pci0000:00: wake-up capability enabled by ACPI
[106891.196510] snd_hda_intel 0000:00:1b.0: PCI INT A disabled
[106891.196555] ACPI handle has no context!
[106891.558722] ata_piix 0000:00:1f.2: PCI INT C disabled
[106891.569378] PM: suspend of devices complete after 489.024 msecs
[106891.596272] PM: late suspend of devices complete after 26.891 msecs
[106891.596582] ACPI: Preparing to enter system sleep state S3
[106891.598392] PM: Saving platform NVS memory
[106891.599386] Disabling non-boot CPUs ...
[106891.600458] Broke affinity for irq 41
[106891.601470] kvm: disabling virtualization on CPU1
[106891.601480] CPU 1 is now offline
[106891.601482] lockdep: fixing up alternatives.
[106891.603934] ACPI: Low-level resume complete
[106891.603934] PM: Restoring platform NVS memory
[106891.603934] Enabling non-boot CPUs ...
[106891.603934] lockdep: fixing up alternatives.
[106891.603934] Booting Node 0 Processor 1 APIC 0x1
[106891.603934] smpboot cpu 1: start_ip = 9a000
[106891.601477] Calibrating delay loop (skipped) already calibrated this CPU
[106891.601477] kvm: enabling virtualization on CPU1
[106891.635760] NMI watchdog enabled, takes one hw-pmu counter.
[106891.635987] Switched to NOHz mode on CPU #1
[106891.639410] hpet: hpet3 irq 41 for MSI
[106891.639428] CPU1 is up
[106891.640830] ACPI: Waking up from system sleep state S3
[106891.649584] ACPI: \_SB_.PCI0.IDE1.PRI1.MAS1 - docking
[106891.660957] pci 0000:00:00.0: restoring config space at offset 0x1 (was 0x20900006, writing 0x20900106)
[106891.661099] pcieport 0000:00:01.0: restoring config space at offset 0xf (was 0xa0100, writing 0xa010b)
[106891.661170] pcieport 0000:00:01.0: restoring config space at offset 0x3 (was 0x10000, writing 0x10010)
[106891.661183] pcieport 0000:00:01.0: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[106891.661353] pci 0000:00:03.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[106891.661764] pci 0000:00:03.0: restoring config space at offset 0x4 (was 0xfeda6004, writing 0xf0000004)
[106891.662241] ata_generic 0000:00:03.2: restoring config space at offset 0xf (was 0x300, writing 0x309)
[106891.662334] ata_generic 0000:00:03.2: restoring config space at offset 0x1 (was 0xb00000, writing 0xb00005)
[106891.662428] serial 0000:00:03.3: restoring config space at offset 0x5 (was 0x0, writing 0xfebd8000)
[106891.662445] serial 0000:00:03.3: restoring config space at offset 0x4 (was 0x1, writing 0xec99)
[106891.662479] serial 0000:00:03.3: restoring config space at offset 0x1 (was 0xb00000, writing 0xb00007)
[106891.662593] e1000e 0000:00:19.0: restoring config space at offset 0xf (was 0x100, writing 0x103)
[106891.662631] e1000e 0000:00:19.0: restoring config space at offset 0x6 (was 0x1, writing 0xecc1)
[106891.662661] e1000e 0000:00:19.0: restoring config space at offset 0x5 (was 0x0, writing 0xfebd9000)
[106891.662670] e1000e 0000:00:19.0: restoring config space at offset 0x4 (was 0x0, writing 0xfebe0000)
[106891.662701] e1000e 0000:00:19.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
[106891.662884] uhci_hcd 0000:00:1a.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[106891.662931] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900001)
[106891.663016] uhci_hcd 0000:00:1a.1: restoring config space at offset 0xf (was 0x200, writing 0x205)
[106891.663042] uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900001)
[106891.663068] uhci_hcd 0000:00:1a.2: restoring config space at offset 0xf (was 0x300, writing 0x305)
[106891.663094] uhci_hcd 0000:00:1a.2: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900001)
[106891.663126] ehci_hcd 0000:00:1a.7: restoring config space at offset 0xf (was 0x300, writing 0x305)
[106891.663149] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x4 (was 0x0, writing 0xfebda000)
[106891.663153] acpi LNXIOBAY:00: parent PNP0A03:00 should not be sleeping
[106891.663158] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900102)
[106891.663196] snd_hda_intel 0000:00:1b.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[106891.663217] snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x4 (was 0xff97c004, writing 0xfebdc004)
[106891.663222] snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[106891.663230] snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100002, writing 0x100102)
[106891.663268] pcieport 0000:00:1c.0: restoring config space at offset 0xf (was 0x20100, writing 0x2010b)
[106891.663281] pcieport 0000:00:1c.0: restoring config space at offset 0x9 (was 0x10001, writing 0xf041f031)
[106891.663286] pcieport 0000:00:1c.0: restoring config space at offset 0x8 (was 0x0, writing 0xfe80fe80)
[106891.663292] pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0x0, writing 0x2020)
[106891.663297] pcieport 0000:00:1c.0: restoring config space at offset 0x6 (was 0x0, writing 0x20200)
[106891.663306] pcieport 0000:00:1c.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[106891.663313] pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100507)
[106891.663370] pcieport 0000:00:1c.1: restoring config space at offset 0xf (was 0x200, writing 0x20205)
[106891.663383] pcieport 0000:00:1c.1: restoring config space at offset 0x9 (was 0x10001, writing 0xf021f011)
[106891.663388] pcieport 0000:00:1c.1: restoring config space at offset 0x8 (was 0x0, writing 0xfe70fe70)
[106891.663394] pcieport 0000:00:1c.1: restoring config space at offset 0x7 (was 0x0, writing 0x1010)
[106891.663399] pcieport 0000:00:1c.1: restoring config space at offset 0x6 (was 0x0, writing 0x30300)
[106891.663407] pcieport 0000:00:1c.1: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[106891.663414] pcieport 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100000, writing 0x100507)
[106891.663461] uhci_hcd 0000:00:1d.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[106891.663487] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
[106891.663512] uhci_hcd 0000:00:1d.1: restoring config space at offset 0xf (was 0x200, writing 0x205)
[106891.663537] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
[106891.663562] uhci_hcd 0000:00:1d.2: restoring config space at offset 0xf (was 0x300, writing 0x309)
[106891.663587] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
[106891.663619] ehci_hcd 0000:00:1d.7: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[106891.663641] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x4 (was 0x0, writing 0xff980000)
[106891.663650] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900100, writing 0x2900102)
[106891.663688] pci 0000:00:1e.0: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
[106891.663694] pci 0000:00:1e.0: restoring config space at offset 0x8 (was 0x0, writing 0xfff0)
[106891.663699] pci 0000:00:1e.0: restoring config space at offset 0x7 (was 0x22800000, writing 0x228000f0)
[106891.663712] pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
[106891.663761] pci 0000:00:1f.0: restoring config space at offset 0x1 (was 0x2100007, writing 0x2100107)
[106891.663787] ata_piix 0000:00:1f.2: restoring config space at offset 0xf (was 0x300, writing 0x309)
[106891.663841] i801_smbus 0000:00:1f.3: restoring config space at offset 0x4 (was 0x4, writing 0xfebdb004)
[106891.663850] i801_smbus 0000:00:1f.3: restoring config space at offset 0x1 (was 0x2800101, writing 0x2800103)
[106891.663870] ata_piix 0000:00:1f.5: restoring config space at offset 0xf (was 0x300, writing 0x309)
[106891.663928] radeon 0000:01:00.0: restoring config space at offset 0xf (was 0x1ff, writing 0x10b)
[106891.663937] radeon 0000:01:00.0: restoring config space at offset 0xc (was 0x0, writing 0xfea00000)
[106891.663947] radeon 0000:01:00.0: restoring config space at offset 0x8 (was 0x1, writing 0xdc01)
[106891.663954] radeon 0000:01:00.0: restoring config space at offset 0x6 (was 0x4, writing 0xfe9f0004)
[106891.663961] radeon 0000:01:00.0: restoring config space at offset 0x4 (was 0xc, writing 0xd000000c)
[106891.663967] radeon 0000:01:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[106891.663974] radeon 0000:01:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x20100407)
[106891.664421] PM: early resume of devices complete after 3.653 msecs
[106891.664599] ata_generic 0000:00:03.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[106891.664605] ata_generic 0000:00:03.2: setting latency timer to 64
[106891.664650]  pci0000:00: wake-up capability disabled by ACPI
[106891.664655] e1000e 0000:00:19.0: PME# disabled
[106891.664760] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[106891.665065] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[106891.665073] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[106891.665096] usb usb3: root hub lost power or was reset
[106891.665116] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[106891.665123] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[106891.665145] usb usb4: root hub lost power or was reset
[106891.665162] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[106891.665169] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[106891.665191] usb usb5: root hub lost power or was reset
[106891.665208] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[106891.665215] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[106891.665297] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[106891.665304] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[106891.665359] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[106891.665442] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[106891.665449] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[106891.665471] usb usb6: root hub lost power or was reset
[106891.665488] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[106891.665495] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[106891.665517] usb usb7: root hub lost power or was reset
[106891.665534] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[106891.665541] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[106891.665563] usb usb8: root hub lost power or was reset
[106891.665580] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[106891.665587] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[106891.665667] pci 0000:00:1e.0: setting latency timer to 64
[106891.665691] ata_piix 0000:00:1f.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[106891.665696] ata_piix 0000:00:1f.2: setting latency timer to 64
[106891.665725] ata_piix 0000:00:1f.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[106891.665730] ata_piix 0000:00:1f.5: setting latency timer to 64
[106891.665756] radeon 0000:01:00.0: setting latency timer to 64
[106891.668081] sd 0:0:0:0: [sda] Starting disk
[106891.677996] serial 00:07: activated
[106891.678955] radeon 0000:01:00.0: WB enabled
[106891.710209] [drm] ring test succeeded in 0 usecs
[106891.710284] [drm] ib test succeeded in 0 usecs
[106891.986032] ata3: SATA link down (SStatus 4 SControl 300)
[106891.986093] ata4: SATA link down (SStatus 4 SControl 300)
[106892.142784] usb 3-1: reset low speed USB device number 2 using uhci_hcd
[106892.462716] ata2.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[106892.462729] ata2.01: SATA link down (SStatus 4 SControl 300)
[106892.462741] ata2.01: link offline, clearing class 3 to NONE
[106892.532790] ata2.00: configured for UDMA/100
[106892.689376] usb 3-2: reset low speed USB device number 3 using uhci_hcd
[106894.146859] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[106894.147829] br0: port 1(eth0) entering forwarding state
[106894.147839] br0: port 1(eth0) entering forwarding state
[106894.773777] e1000e: eth0 NIC Link is Down
[106895.146973] br0: port 1(eth0) entering forwarding state
[106897.476001] ata1.00: link is slow to respond, please be patient (ready=0)
[106897.916860] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[106897.917795] br0: port 1(eth0) entering forwarding state
[106897.917801] br0: port 1(eth0) entering forwarding state
[106898.756043] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[106898.756054] ata1.01: SATA link down (SStatus 4 SControl 300)
[106898.776286] ata1.00: configured for UDMA/133
[106898.802973] PM: resume of devices complete after 7138.501 msecs
[106898.803836] PM: Finishing wakeup.
[106898.803837] Restarting tasks ... done.
[106899.222949] ata1.00: configured for UDMA/133
[106899.222957] ata1: EH complete
[106899.418595] EXT4-fs (sda2): re-mounted. Opts: commit=0
[106900.343520] e1000e 0000:00:19.0: eth0: Detected Hardware Unit Hang:
[106900.343521]   TDH                  <1>
[106900.343522]   TDT                  <2>
[106900.343523]   next_to_use          <2>
[106900.343523]   next_to_clean        <1>
[106900.343524] buffer_info[next_to_clean]:
[106900.343525]   time_stamp           <101e7f773>
[106900.343526]   next_to_watch        <1>
[106900.343526]   jiffies              <101e7fa4a>
[106900.343527]   next_to_watch.status <0>
[106900.343528] MAC Status             <80683>
[106900.343529] PHY Status             <796d>
[106900.343529] PHY 1000BASE-T Status  <3800>
[106900.343530] PHY Extended Status    <3000>
[106900.343531] PCI Status             <10>
[106902.342904] e1000e 0000:00:19.0: eth0: Detected Hardware Unit Hang:
[106902.342905]   TDH                  <1>
[106902.342906]   TDT                  <2>
[106902.342907]   next_to_use          <2>
[106902.342907]   next_to_clean        <1>
[106902.342908] buffer_info[next_to_clean]:
[106902.342909]   time_stamp           <101e7f773>
[106902.342909]   next_to_watch        <1>
[106902.342910]   jiffies              <101e7fca2>
[106902.342911]   next_to_watch.status <0>
[106902.342912] MAC Status             <80683>
[106902.342912] PHY Status             <796d>
[106902.342913] PHY 1000BASE-T Status  <3800>
[106902.342914] PHY Extended Status    <3000>
[106902.342915] PCI Status             <10>
[106903.349326] ------------[ cut here ]------------
[106903.349336] WARNING: at net/sched/sch_generic.c:255 dev_watchdog+0xeb/0x14b()
[106903.349339] Hardware name: OptiPlex 760                 
[106903.349342] NETDEV WATCHDOG: eth0 (e1000e): transmit queue 0 timed out
[106903.349344] Modules linked in: cdc_ether usbnet mii tun kvm_intel kvm snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss fuse snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep snd_pcm radeon snd_timer snd_page_alloc ttm dell_wmi sparse_keymap wmi
[106903.349379] Pid: 0, comm: swapper Not tainted 3.1.0-rc6+ #202
[106903.349382] Call Trace:
[106903.349384]  <IRQ>  [<ffffffff8103c5a7>] warn_slowpath_common+0x80/0x98
[106903.349394]  [<ffffffff8103c653>] warn_slowpath_fmt+0x41/0x43
[106903.349399]  [<ffffffff81560149>] dev_watchdog+0xeb/0x14b
[106903.349404]  [<ffffffff810497c6>] run_timer_softirq+0x217/0x300
[106903.349408]  [<ffffffff81049733>] ? run_timer_softirq+0x184/0x300
[106903.349413]  [<ffffffff8156005e>] ? netif_tx_unlock+0x51/0x51
[106903.349419]  [<ffffffff810423c6>] __do_softirq+0xe2/0x1bc
[106903.349424]  [<ffffffff81007a81>] ? paravirt_read_tsc+0x9/0xd
[106903.349428]  [<ffffffff81007fc8>] ? sched_clock+0x9/0xd
[106903.349434]  [<ffffffff8160063c>] call_softirq+0x1c/0x30
[106903.349438]  [<ffffffff81003ba2>] do_softirq+0x46/0x9c
[106903.349442]  [<ffffffff81042696>] irq_exit+0x5b/0xbe
[106903.349446]  [<ffffffff8100384a>] do_IRQ+0x89/0xa0
[106903.349452]  [<ffffffff815f8e33>] common_interrupt+0x73/0x73
[106903.349454]  <EOI>  [<ffffffff81008d81>] ? mwait_idle+0x8a/0xc1
[106903.349462]  [<ffffffff81008d78>] ? mwait_idle+0x81/0xc1
[106903.349467]  [<ffffffff810012ab>] cpu_idle+0xb3/0xd5
[106903.349473]  [<ffffffff815d8dbe>] rest_init+0xb2/0xb9
[106903.349477]  [<ffffffff815d8d0c>] ? csum_partial_copy_generic+0x16c/0x16c
[106903.349483]  [<ffffffff81a22b49>] start_kernel+0x390/0x39b
[106903.349487]  [<ffffffff81a222af>] x86_64_start_reservations+0xb6/0xba
[106903.349491]  [<ffffffff81a223b4>] x86_64_start_kernel+0x101/0x110
[106903.349495] ---[ end trace 1d36d9ed335e092c ]---
[106903.349722] e1000e 0000:00:19.0: eth0: Reset adapter
[106903.451598] br0: port 1(eth0) entering forwarding state
[106906.606867] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[106906.607835] br0: port 1(eth0) entering forwarding state
[106906.607845] br0: port 1(eth0) entering forwarding state

--------------000105060902050707080506--
