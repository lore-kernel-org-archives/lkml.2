Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab1D3PeA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 11:34:00 -0400
Received: from nocko.org ([173.245.73.87]:54354 "EHLO nocko.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524Ab1D3Pdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 11:33:52 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Apr 2011 11:33:52 EDT
From: Shawn Nock <nock@nocko.org>
To: linux-kernel@vger.kernel.org
Subject: GPF, 39-rc5
User-Agent: Gnus/5.110016 (No Gnus v0.16) Emacs/23.2 (gnu/linux)
Date: Sat, 30 Apr 2011 11:22:33 -0400
Message-ID: <m362pvg3wm.fsf@nocko.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain


IBM Thinkpad x120e (AMD Fusion E-350).

How to reproduce: There is a primary problem (I haven't been able to
capture it yet), that causes the system to hang. The PC speaker emits a
tone and I cannot return to a text console. The logs show nothing for
this problem... however, rebooting after this panic seems to reliably
(4/5) cause the following GPF:

general protection fault: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:14.2/sound/card1/uevent
Modules linked in: fuse tun cpufreq_ondemand powernow_k8 mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 uinput arc4 ecb rtl8192ce snd_hda_codec_conexant rtl8192c_common rtlwifi snd_hda_codec_hdmi snd_hda_intel mac80211 snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm uvcvideo cfg80211 r8169 microcode snd_timer videodev snd video rfkill i2c_piix4 soundcore joydev snd_page_alloc mii pcspkr k10temp serio_raw usb_storage radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]

Pid: 1417, comm: gvfsd Not tainted 2.6.39-rc5 #1 LENOVO 05962PU/05962PU
EIP: 0060:[<c0403a92>] EFLAGS: 00010086 CPU: 0
EIP is at __math_state_restore+0x52/0x5c
EAX: f26d7080 EBX: f26d7080 ECX: f5800000 EDX: 00000000
ESI: f4688000 EDI: f26e8800 EBP: f4689edc ESP: f4689ed0
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process gvfsd (pid: 1417, ti=f4688000 task=f462f000 task.ti=f3764000)
Stack:
 f26d7080 f5801440 f462f080 f4689f04 c0402539 c0431856 0000fe37 017a8000
 00000000 f26d737c b7b3a38b f26d7080 f3765b58 c07e080a f4689fac f4689fac
 00000086 c073b5ca 00000246 f4689f40 c042cf9e 23360420 00000006 c0aee480
Call Trace:
 [<c0402539>] __switch_to+0xd5/0xe6
 [<c0431856>] ? pick_next_task_fair+0x144/0x14d
 [<c07e080a>] schedule+0x642/0x696
 [<c073b5ca>] ? sock_alloc_file+0x99/0xef
 [<c042cf9e>] ? __might_sleep+0x29/0xe4
 [<c073cda3>] ? sys_socketcall+0xba/0x28c
 [<c041b24a>] ? smp_apic_timer_interrupt+0x6b/0x78
 [<c04032ed>] ? conditional_sti.clone.4+0x12/0x14
 [<c07e1f32>] ? work_resched+0x5/0x20
Code: 85 c9 74 1b e8 b0 f7 ff ff 83 c8 08 e8 b8 f7 ff ff 89 da b8 0b 00 00 00 e8 60 73 04 00 eb 11 83 4e 0c 01 fe 0c 01 fe 83 80 01 00 00 eb 05 <0f> ae 0f eb ef 5b 5e 5f c9 c3 55 89 e5 53 3e 8d 74 26 00 89 e0
EIP: [<c0403a92>] __math_state_restore+0x52/0x5c SS:ESP 0068:f4689ed0

dmesg attached, please let me know what I could provide to help
troubleshoot this further.

Shawn

--=-=-=
Content-Type: text/plain
Content-Disposition: attachment; filename=dmesg-39rc5.txt

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.39-rc5 (nock@netbook) (gcc version 4.5.1 20100924 (Red Hat 4.5.1-4) (GCC) ) #1 SMP Wed Apr 27 22:02:32 EDT 2011
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
[    0.000000]  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000065f02000 (usable)
[    0.000000]  BIOS-e820: 0000000065f02000 - 0000000066312000 (reserved)
[    0.000000]  BIOS-e820: 0000000066312000 - 0000000066392000 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000066392000 - 00000000663f2000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000663f2000 - 0000000066e00000 (usable)
[    0.000000]  BIOS-e820: 0000000066e00000 - 0000000067000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed80000 - 00000000fed81000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: LENOVO 05962PU/05962PU, BIOS 8FET26WW (1.10 ) 03/09/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x66e00 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 base 040000000 mask FE0000000 write-back
[    0.000000]   2 base 060000000 mask FFC000000 write-back
[    0.000000]   3 base 064000000 mask FFE000000 write-back
[    0.000000]   4 base 066000000 mask FFF000000 write-back
[    0.000000]   5 base 0FFF90000 mask FFFFF0000 uncachable
[    0.000000]   6 base 0FED80000 mask FFFFFF000 uncachable
[    0.000000]   7 base 0FFE00000 mask FFFE00000 write-protect
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] found SMP MP-table at [c00fbba0] fbba0
[    0.000000] initial memory mapped : 0 - 01000000
[    0.000000] Base memory trampoline at [c0099000] 99000 size 16384
[    0.000000] init_memory_mapping: 0000000000000000-0000000036ffe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0036c00000 page 2M
[    0.000000]  0036c00000 - 0036ffe000 page 4k
[    0.000000] kernel direct mapping tables up to 36ffe000 @ ff9000-1000000
[    0.000000] RAMDISK: 379b0000 - 37ff0000
[    0.000000] Allocated new RAMDISK: 369be000 - 36ffd950
[    0.000000] Move RAMDISK from 00000000379b0000 - 0000000037fef94f to 369be000 - 36ffd94f
[    0.000000] ACPI: RSDP 000f00e0 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 663f1120 00074 (v01 LENOVO TP-8F    00000003 PTEC 00000002)
[    0.000000] ACPI: FACP 663e1000 000F4 (v04 LENOVO TP-8F    00001100 PTL  00000002)
[    0.000000] ACPI: DSDT 663e3000 0C02A (v01 LENOVO TP-8F    00001000 PTEC 00001100)
[    0.000000] ACPI: FACS 6637d000 00040
[    0.000000] ACPI: SLIC 663f0000 00176 (v01 LENOVO TP-8F    00001100 PTEC 00000001)
[    0.000000] ACPI: HPET 663e0000 00038 (v01 LENOVO TP-8F    00001100 PTL  00000002)
[    0.000000] ACPI: APIC 663df000 0005E (v02 LENOVO TP-8F    00001100 PTL  00000002)
[    0.000000] ACPI: MCFG 663de000 0003C (v01 LENOVO TP-8F    00001100 PTL  00000002)
[    0.000000] ACPI: UEFI 663dd000 0003E (v01 LENOVO TP-8F    00001100 PTL  00000002)
[    0.000000] ACPI: UEFI 663dc000 00042 (v01 PTL      COMBUF 00000001 PTL  00000001)
[    0.000000] ACPI: SSDT 663db000 003DE (v01 AMD    POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: SSDT 663d9000 012FA (v02    AMD     ALIB 00000001 MSFT 04000000)
[    0.000000] ACPI: UEFI 663d8000 0012A (v01 LENOVO TP-8F    00001100 PTL  00000002)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 766MB HIGHMEM available.
[    0.000000] 879MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 36ffe000
[    0.000000]   low ram: 0 - 36ffe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00036ffe
[    0.000000]   HighMem  0x00036ffe -> 0x00066e00
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x00065f02
[    0.000000]     0: 0x000663f2 -> 0x00066e00
[    0.000000] On node 0 totalpages: 419997
[    0.000000] free_area_init_node: node 0, pgdat c0a50340, node_mem_map f5cdd200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3949 pages, LIFO batch:0
[    0.000000]   Normal zone: 1728 pages used for memmap
[    0.000000]   Normal zone: 219454 pages, LIFO batch:31
[    0.000000]   HighMem zone: 1533 pages used for memmap
[    0.000000]   HighMem zone: 193301 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x43538210 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 67000000 (gap: 67000000:97c00000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @f5800000 s27712 r0 d21440 u2097152
[    0.000000] pcpu-alloc: s27712 r0 d21440 u2097152 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 416704
[    0.000000] Kernel command line: ro root=UUID=5dc7080b-9a2a-443d-8860-12f951845d5a rd_NO_LUKS rd_NO_LVM rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us rhgb quiet
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 6741760 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Initializing HighMem for node 0 (00036ffe:00066e00)
[    0.000000] Memory: 1644760k/1685504k available (4002k kernel code, 35228k reserved, 2520k data, 576k init, 779336k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xff575000 - 0xfffff000   (10792 kB)
[    0.000000]     pkmap   : 0xff000000 - 0xff400000   (4096 kB)
[    0.000000]     vmalloc : 0xf77fe000 - 0xfeffe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf6ffe000   ( 879 MB)
[    0.000000]       .init : 0xc0a5f000 - 0xc0aef000   ( 576 kB)
[    0.000000]       .data : 0xc07e884a - 0xc0a5e880   (2520 kB)
[    0.000000]       .text : 0xc0400000 - 0xc07e884a   (4002 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] NR_IRQS:2304
[    0.000000] CPU 0 irqstacks, hard=f4c20000 soft=f4c22000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1596.734 MHz processor.
[    0.001005] Calibrating delay loop (skipped), value calculated using timer frequency.. 3193.46 BogoMIPS (lpj=1596734)
[    0.001015] pid_max: default: 32768 minimum: 301
[    0.001389] Security Framework initialized
[    0.001402] SELinux:  Initializing.
[    0.001453] SELinux:  Starting in permissive mode
[    0.001693] Mount-cache hash table entries: 512
[    0.003047] Initializing cgroup subsys ns
[    0.003056] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.003062] Initializing cgroup subsys cpuacct
[    0.003179] Initializing cgroup subsys memory
[    0.003233] Initializing cgroup subsys devices
[    0.003238] Initializing cgroup subsys freezer
[    0.003243] Initializing cgroup subsys net_cls
[    0.003248] Initializing cgroup subsys blkio
[    0.003379] CPU: Physical Processor ID: 0
[    0.003383] CPU: Processor Core ID: 0
[    0.003388] mce: CPU supports 6 MCE banks
[    0.004414] ACPI: Core revision 20110316
[    0.018025] ftrace: allocating 23757 entries in 47 pages
[    0.020142] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.020533] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.030987] CPU0: AMD E-350 Processor stepping 00
[    0.030997] Performance Events: AMD PMU driver.
[    0.030997] ... version:                0
[    0.030997] ... bit width:              48
[    0.030997] ... generic registers:      4
[    0.030997] ... value mask:             0000ffffffffffff
[    0.030997] ... max period:             00007fffffffffff
[    0.030997] ... fixed-purpose events:   0
[    0.030997] ... event mask:             000000000000000f
[    0.031055] CPU 1 irqstacks, hard=f4cde000 soft=f4ce8000
[    0.031060] Booting Node   0, Processors  #1 Ok.
[    0.031065] smpboot cpu 1: start_ip = 99000
[    0.001999] Initializing CPU#1
[    0.103015] Brought up 2 CPUs
[    0.103021] Total of 2 processors activated (6386.39 BogoMIPS).
[    0.104458] devtmpfs: initialized
[    0.105045] PM: Registering ACPI NVS region at 66312000 (524288 bytes)
[    0.106962] atomic64 test passed for i386+ platform with CX8 and with SSE
[    0.107069] Time: 15:00:11  Date: 04/30/11
[    0.107297] NET: Registered protocol family 16
[    0.107636] Extended Config Space enabled on 0 nodes
[    0.107762] ACPI: bus type pci registered
[    0.108261] PCI: MMCONFIG for domain 0000 [bus 00-1f] at [mem 0xf8000000-0xf9ffffff] (base 0xf8000000)
[    0.108268] PCI: not using MMCONFIG
[    0.108377] PCI: PCI BIOS revision 3.00 entry at 0xfc030, last bus=31
[    0.108381] PCI: Using configuration type 1 for base access
[    0.108384] PCI: Using configuration type 1 for extended access
[    0.111234] bio: create slab <bio-0> at 0
[    0.114620] ACPI: EC: Look up EC in DSDT
[    0.125234] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.131253] ACPI: Interpreter enabled
[    0.131266] ACPI: (supports S0 S3 S4 S5)
[    0.131304] ACPI: Using IOAPIC for interrupt routing
[    0.131603] PCI: MMCONFIG for domain 0000 [bus 00-1f] at [mem 0xf8000000-0xf9ffffff] (base 0xf8000000)
[    0.132097] PCI: MMCONFIG at [mem 0xf8000000-0xf9ffffff] reserved in ACPI motherboard resources
[    0.132102] PCI: Using MMCONFIG for extended config space
[    0.132915] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[    0.142610] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[    0.146275] ACPI: EC: GPE = 0x3, I/O: command/status = 0x66, data = 0x62
[    0.149353] ACPI: No dock devices found.
[    0.149362] HEST: Table not found.
[    0.149371] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.150684] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.152602] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.152608] pci_root PNP0A08:00: host bridge window [mem 0x000c0000-0x000c1fff]
[    0.152614] pci_root PNP0A08:00: host bridge window [mem 0x000c2000-0x000c3fff]
[    0.152619] pci_root PNP0A08:00: host bridge window [mem 0x000c4000-0x000c5fff]
[    0.152624] pci_root PNP0A08:00: host bridge window [mem 0x000c6000-0x000c7fff]
[    0.152629] pci_root PNP0A08:00: host bridge window [mem 0x000c8000-0x000c9fff]
[    0.152633] pci_root PNP0A08:00: host bridge window [mem 0x000ca000-0x000cbfff]
[    0.152638] pci_root PNP0A08:00: host bridge window [mem 0x000cc000-0x000cdfff]
[    0.152643] pci_root PNP0A08:00: host bridge window [mem 0x000ce000-0x000cffff]
[    0.152648] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d1fff]
[    0.152652] pci_root PNP0A08:00: host bridge window [mem 0x000d2000-0x000d3fff]
[    0.152657] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d5fff]
[    0.152662] pci_root PNP0A08:00: host bridge window [mem 0x000d6000-0x000d7fff]
[    0.152666] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000d9fff]
[    0.152671] pci_root PNP0A08:00: host bridge window [mem 0x000da000-0x000dbfff]
[    0.152676] pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x000ddfff]
[    0.152680] pci_root PNP0A08:00: host bridge window [mem 0x000de000-0x000dffff]
[    0.152685] pci_root PNP0A08:00: host bridge window [mem 0x000e0000-0x000e1fff]
[    0.152690] pci_root PNP0A08:00: host bridge window [mem 0x000e2000-0x000e3fff]
[    0.152694] pci_root PNP0A08:00: host bridge window [mem 0x000e4000-0x000e5fff]
[    0.152699] pci_root PNP0A08:00: host bridge window [mem 0x000e6000-0x000e7fff]
[    0.152704] pci_root PNP0A08:00: host bridge window [mem 0x000e8000-0x000e9fff]
[    0.152708] pci_root PNP0A08:00: host bridge window [mem 0x000ea000-0x000ebfff]
[    0.152713] pci_root PNP0A08:00: host bridge window [mem 0x000ec000-0x000edfff]
[    0.152718] pci_root PNP0A08:00: host bridge window [mem 0x000ee000-0x000effff]
[    0.152723] pci_root PNP0A08:00: host bridge window [mem 0x7f000000-0xf7ffffff]
[    0.152728] pci_root PNP0A08:00: host bridge window [mem 0xf8000000-0xffffffff]
[    0.152732] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.152737] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.152756] pci_root PNP0A08:00: address space collision: host bridge window [mem 0x000ce000-0x000cffff] conflicts with Video ROM [mem 0x000c0000-0x000ce1ff]
[    0.152843] pci 0000:00:00.0: [1022:1510] type 0 class 0x000600
[    0.152903] pci 0000:00:01.0: [1002:9802] type 0 class 0x000300
[    0.152921] pci 0000:00:01.0: reg 10: [mem 0x80000000-0x8fffffff pref]
[    0.152932] pci 0000:00:01.0: reg 14: [io  0x4000-0x40ff]
[    0.152943] pci 0000:00:01.0: reg 18: [mem 0x90200000-0x9023ffff]
[    0.153002] pci 0000:00:01.0: supports D1 D2
[    0.153029] pci 0000:00:01.1: [1002:1314] type 0 class 0x000403
[    0.153044] pci 0000:00:01.1: reg 10: [mem 0x90244000-0x90247fff]
[    0.153106] pci 0000:00:01.1: supports D1 D2
[    0.153191] pci 0000:00:06.0: [1022:1514] type 1 class 0x000604
[    0.153253] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.153260] pci 0000:00:06.0: PME# disabled
[    0.153357] pci 0000:00:11.0: [1002:4391] type 0 class 0x000106
[    0.153386] pci 0000:00:11.0: reg 10: [io  0x4118-0x411f]
[    0.153401] pci 0000:00:11.0: reg 14: [io  0x4124-0x4127]
[    0.153416] pci 0000:00:11.0: reg 18: [io  0x4110-0x4117]
[    0.153431] pci 0000:00:11.0: reg 1c: [io  0x4120-0x4123]
[    0.153446] pci 0000:00:11.0: reg 20: [io  0x4100-0x410f]
[    0.153461] pci 0000:00:11.0: reg 24: [mem 0x9024a000-0x9024a3ff]
[    0.153528] pci 0000:00:12.0: [1002:4397] type 0 class 0x000c03
[    0.153548] pci 0000:00:12.0: reg 10: [mem 0x90249000-0x90249fff]
[    0.153646] pci 0000:00:12.2: [1002:4396] type 0 class 0x000c03
[    0.153675] pci 0000:00:12.2: reg 10: [mem 0x9024a500-0x9024a5ff]
[    0.153770] pci 0000:00:12.2: supports D1 D2
[    0.153774] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.153781] pci 0000:00:12.2: PME# disabled
[    0.153813] pci 0000:00:13.0: [1002:4397] type 0 class 0x000c03
[    0.153833] pci 0000:00:13.0: reg 10: [mem 0x90248000-0x90248fff]
[    0.153931] pci 0000:00:13.2: [1002:4396] type 0 class 0x000c03
[    0.153959] pci 0000:00:13.2: reg 10: [mem 0x9024a400-0x9024a4ff]
[    0.154062] pci 0000:00:13.2: supports D1 D2
[    0.154067] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.154074] pci 0000:00:13.2: PME# disabled
[    0.154107] pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
[    0.154215] pci 0000:00:14.2: [1002:4383] type 0 class 0x000403
[    0.154248] pci 0000:00:14.2: reg 10: [mem 0x90240000-0x90243fff 64bit]
[    0.154327] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.154335] pci 0000:00:14.2: PME# disabled
[    0.154355] pci 0000:00:14.3: [1002:439d] type 0 class 0x000601
[    0.154458] pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
[    0.154528] pci 0000:00:15.0: [1002:43a0] type 1 class 0x000604
[    0.154610] pci 0000:00:15.0: supports D1 D2
[    0.154653] pci 0000:00:15.1: [1002:43a1] type 1 class 0x000604
[    0.154737] pci 0000:00:15.1: supports D1 D2
[    0.154781] pci 0000:00:18.0: [1022:1700] type 0 class 0x000600
[    0.154830] pci 0000:00:18.1: [1022:1701] type 0 class 0x000600
[    0.154875] pci 0000:00:18.2: [1022:1702] type 0 class 0x000600
[    0.154923] pci 0000:00:18.3: [1022:1703] type 0 class 0x000600
[    0.154978] pci 0000:00:18.4: [1022:1704] type 0 class 0x000600
[    0.155031] pci 0000:00:18.5: [1022:1718] type 0 class 0x000600
[    0.155076] pci 0000:00:18.6: [1022:1716] type 0 class 0x000600
[    0.155122] pci 0000:00:18.7: [1022:1719] type 0 class 0x000600
[    0.155292] pci 0000:01:00.0: [10ec:8168] type 0 class 0x000200
[    0.155314] pci 0000:01:00.0: reg 10: [io  0x3000-0x30ff]
[    0.155346] pci 0000:01:00.0: reg 18: [mem 0x90004000-0x90004fff 64bit pref]
[    0.155369] pci 0000:01:00.0: reg 20: [mem 0x90000000-0x90003fff 64bit pref]
[    0.155385] pci 0000:01:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    0.155429] pci 0000:01:00.0: supports D1 D2
[    0.155433] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.155441] pci 0000:01:00.0: PME# disabled
[    0.157059] pci 0000:00:06.0: PCI bridge to [bus 01-01]
[    0.157081] pci 0000:00:06.0:   bridge window [io  0x3000-0x3fff]
[    0.157095] pci 0000:00:06.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.157112] pci 0000:00:06.0:   bridge window [mem 0x90000000-0x900fffff 64bit pref]
[    0.157260] pci 0000:00:14.4: PCI bridge to [bus 02-02] (subtractive decode)
[    0.157268] pci 0000:00:14.4:   bridge window [io  0xf000-0x0000] (disabled)
[    0.157276] pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.157284] pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.157291] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.157296] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000c1fff] (subtractive decode)
[    0.157302] pci 0000:00:14.4:   bridge window [mem 0x000c2000-0x000c3fff] (subtractive decode)
[    0.157307] pci 0000:00:14.4:   bridge window [mem 0x000c4000-0x000c5fff] (subtractive decode)
[    0.157312] pci 0000:00:14.4:   bridge window [mem 0x000c6000-0x000c7fff] (subtractive decode)
[    0.157318] pci 0000:00:14.4:   bridge window [mem 0x000c8000-0x000c9fff] (subtractive decode)
[    0.157323] pci 0000:00:14.4:   bridge window [mem 0x000ca000-0x000cbfff] (subtractive decode)
[    0.157329] pci 0000:00:14.4:   bridge window [mem 0x000cc000-0x000cdfff] (subtractive decode)
[    0.157334] pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000d1fff] (subtractive decode)
[    0.157339] pci 0000:00:14.4:   bridge window [mem 0x000d2000-0x000d3fff] (subtractive decode)
[    0.157345] pci 0000:00:14.4:   bridge window [mem 0x000d4000-0x000d5fff] (subtractive decode)
[    0.157350] pci 0000:00:14.4:   bridge window [mem 0x000d6000-0x000d7fff] (subtractive decode)
[    0.157356] pci 0000:00:14.4:   bridge window [mem 0x000d8000-0x000d9fff] (subtractive decode)
[    0.157361] pci 0000:00:14.4:   bridge window [mem 0x000da000-0x000dbfff] (subtractive decode)
[    0.157367] pci 0000:00:14.4:   bridge window [mem 0x000dc000-0x000ddfff] (subtractive decode)
[    0.157372] pci 0000:00:14.4:   bridge window [mem 0x000de000-0x000dffff] (subtractive decode)
[    0.157377] pci 0000:00:14.4:   bridge window [mem 0x000e0000-0x000e1fff] (subtractive decode)
[    0.157383] pci 0000:00:14.4:   bridge window [mem 0x000e2000-0x000e3fff] (subtractive decode)
[    0.157388] pci 0000:00:14.4:   bridge window [mem 0x000e4000-0x000e5fff] (subtractive decode)
[    0.157394] pci 0000:00:14.4:   bridge window [mem 0x000e6000-0x000e7fff] (subtractive decode)
[    0.157399] pci 0000:00:14.4:   bridge window [mem 0x000e8000-0x000e9fff] (subtractive decode)
[    0.157405] pci 0000:00:14.4:   bridge window [mem 0x000ea000-0x000ebfff] (subtractive decode)
[    0.157410] pci 0000:00:14.4:   bridge window [mem 0x000ec000-0x000edfff] (subtractive decode)
[    0.157416] pci 0000:00:14.4:   bridge window [mem 0x000ee000-0x000effff] (subtractive decode)
[    0.157422] pci 0000:00:14.4:   bridge window [mem 0x7f000000-0xf7ffffff] (subtractive decode)
[    0.157427] pci 0000:00:14.4:   bridge window [mem 0xf8000000-0xffffffff] (subtractive decode)
[    0.157433] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.157438] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.157558] pci 0000:00:15.0: PCI bridge to [bus 03-03]
[    0.157568] pci 0000:00:15.0:   bridge window [io  0xfffff000-0x0000] (disabled)
[    0.157575] pci 0000:00:15.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.157585] pci 0000:00:15.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.157686] pci 0000:04:00.0: [10ec:8176] type 0 class 0x000280
[    0.157718] pci 0000:04:00.0: reg 10: [io  0x2000-0x20ff]
[    0.157763] pci 0000:04:00.0: reg 18: [mem 0x90100000-0x90103fff 64bit]
[    0.157869] pci 0000:04:00.0: supports D1 D2
[    0.157874] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.157883] pci 0000:04:00.0: PME# disabled
[    0.160067] pci 0000:00:15.1: PCI bridge to [bus 04-04]
[    0.160091] pci 0000:00:15.1:   bridge window [io  0x2000-0x2fff]
[    0.160105] pci 0000:00:15.1:   bridge window [mem 0x90100000-0x901fffff]
[    0.160123] pci 0000:00:15.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.160165] pci_bus 0000:00: on NUMA node 0
[    0.160181] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.160522] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB6_._PRT]
[    0.160705] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.160824] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.SPB0._PRT]
[    0.160906] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.SPB1._PRT]
[    0.161278]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.161657]  pci0000:00: ACPI _OSC control (0x1d) granted
[    0.171396] ACPI: PCI Interrupt Link [LNKA] (IRQs 10 11) *0
[    0.171608] ACPI: PCI Interrupt Link [LNKB] (IRQs 10 11) *0
[    0.171733] ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11) *0
[    0.171855] ACPI: PCI Interrupt Link [LNKD] (IRQs 10 11) *0
[    0.172005] ACPI: PCI Interrupt Link [LNKE] (IRQs 10 11) *0
[    0.172131] ACPI: PCI Interrupt Link [LNKF] (IRQs 10 11) *0
[    0.172256] ACPI: PCI Interrupt Link [LNKG] (IRQs 10 11) *0
[    0.172385] ACPI: PCI Interrupt Link [LNKH] (IRQs 10 11) *0
[    0.172564] vgaarb: device added: PCI:0000:00:01.0,decodes=io+mem,owns=io+mem,locks=none
[    0.172586] vgaarb: loaded
[    0.172861] SCSI subsystem initialized
[    0.173053] libata version 3.00 loaded.
[    0.173182] usbcore: registered new interface driver usbfs
[    0.173215] usbcore: registered new interface driver hub
[    0.173228] usbcore: registered new device driver usb
[    0.173228] PCI: Using ACPI for IRQ routing
[    0.175127] PCI: pci_cache_line_size set to 64 bytes
[    0.175374] reserve RAM buffer: 000000000009d800 - 000000000009ffff 
[    0.175379] reserve RAM buffer: 0000000065f02000 - 0000000067ffffff 
[    0.175385] reserve RAM buffer: 0000000066e00000 - 0000000067ffffff 
[    0.175670] NetLabel: Initializing
[    0.175675] NetLabel:  domain hash size = 128
[    0.175677] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.175698] NetLabel:  unlabeled traffic allowed by default
[    0.175726] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.175734] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.178008] Switching to clocksource hpet
[    0.178195] Switched to NOHz mode on CPU #0
[    0.178296] Switched to NOHz mode on CPU #1
[    0.192116] pnp: PnP ACPI init
[    0.192148] ACPI: bus type pnp registered
[    0.193263] pnp 00:00: [bus 00-ff]
[    0.193270] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.193275] pnp 00:00: [mem 0x000c0000-0x000c1fff window]
[    0.193280] pnp 00:00: [mem 0x000c2000-0x000c3fff window]
[    0.193284] pnp 00:00: [mem 0x000c4000-0x000c5fff window]
[    0.193289] pnp 00:00: [mem 0x000c6000-0x000c7fff window]
[    0.193293] pnp 00:00: [mem 0x000c8000-0x000c9fff window]
[    0.193298] pnp 00:00: [mem 0x000ca000-0x000cbfff window]
[    0.193302] pnp 00:00: [mem 0x000cc000-0x000cdfff window]
[    0.193307] pnp 00:00: [mem 0x000ce000-0x000cffff window]
[    0.193311] pnp 00:00: [mem 0x000d0000-0x000d1fff window]
[    0.193315] pnp 00:00: [mem 0x000d2000-0x000d3fff window]
[    0.193319] pnp 00:00: [mem 0x000d4000-0x000d5fff window]
[    0.193324] pnp 00:00: [mem 0x000d6000-0x000d7fff window]
[    0.193328] pnp 00:00: [mem 0x000d8000-0x000d9fff window]
[    0.193332] pnp 00:00: [mem 0x000da000-0x000dbfff window]
[    0.193337] pnp 00:00: [mem 0x000dc000-0x000ddfff window]
[    0.193341] pnp 00:00: [mem 0x000de000-0x000dffff window]
[    0.193345] pnp 00:00: [mem 0x000e0000-0x000e1fff window]
[    0.193349] pnp 00:00: [mem 0x000e2000-0x000e3fff window]
[    0.193354] pnp 00:00: [mem 0x000e4000-0x000e5fff window]
[    0.193358] pnp 00:00: [mem 0x000e6000-0x000e7fff window]
[    0.193362] pnp 00:00: [mem 0x000e8000-0x000e9fff window]
[    0.193367] pnp 00:00: [mem 0x000ea000-0x000ebfff window]
[    0.193371] pnp 00:00: [mem 0x000ec000-0x000edfff window]
[    0.193375] pnp 00:00: [mem 0x000ee000-0x000effff window]
[    0.193380] pnp 00:00: [mem 0x7f000000-0xf7ffffff window]
[    0.193384] pnp 00:00: [mem 0xf8000000-0xffffffff window]
[    0.193389] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.193393] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.193397] pnp 00:00: [io  0x0d00-0xffff window]
[    0.193510] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.193604] pnp 00:01: [io  0x0f50-0x0f51]
[    0.193609] pnp 00:01: [mem 0xfec00000-0xfec00fff]
[    0.193614] pnp 00:01: [mem 0xfee00000-0xfee00fff]
[    0.193618] pnp 00:01: [mem 0xf8000000-0xf9ffffff]
[    0.193715] system 00:01: [io  0x0f50-0x0f51] has been reserved
[    0.193723] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.193728] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.193734] system 00:01: [mem 0xf8000000-0xf9ffffff] has been reserved
[    0.193741] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.194537] pnp 00:02: [io  0x0000-0x001f]
[    0.194542] pnp 00:02: [io  0x0081-0x008f]
[    0.194546] pnp 00:02: [io  0x00c0-0x00de]
[    0.194550] pnp 00:02: [io  0x040b]
[    0.194554] pnp 00:02: [io  0x04d6]
[    0.194558] pnp 00:02: [dma 4]
[    0.194623] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.194642] pnp 00:03: [io  0x00f0-0x00fe]
[    0.194709] pnp 00:03: [irq 13]
[    0.194772] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.194794] pnp 00:04: [io  0x0070-0x0071]
[    0.194850] pnp 00:04: [irq 8]
[    0.194914] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.194931] pnp 00:05: [io  0x0061]
[    0.194999] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.195038] pnp 00:06: [io  0x0060]
[    0.195042] pnp 00:06: [io  0x0064]
[    0.195052] pnp 00:06: [irq 1]
[    0.195117] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.195202] pnp 00:07: [irq 12]
[    0.195269] pnp 00:07: Plug and Play ACPI device, IDs LEN0017 PNP0f13 (active)
[    0.195298] pnp 00:08: [io  0x0022-0x0023]
[    0.195302] pnp 00:08: [io  0x002e-0x002f]
[    0.195306] pnp 00:08: [io  0x0072-0x0073]
[    0.195309] pnp 00:08: [io  0x0080]
[    0.195313] pnp 00:08: [io  0x0092]
[    0.195317] pnp 00:08: [io  0x00b0-0x00b1]
[    0.195321] pnp 00:08: [io  0x00b2]
[    0.195325] pnp 00:08: [io  0x00b8]
[    0.195328] pnp 00:08: [io  0x00bc]
[    0.195332] pnp 00:08: [io  0x00f0]
[    0.195335] pnp 00:08: [io  0x04d0-0x04d1]
[    0.195339] pnp 00:08: [io  0x0530-0x0537]
[    0.195343] pnp 00:08: [io  0x0800-0x0827]
[    0.195347] pnp 00:08: [io  0x0830]
[    0.195350] pnp 00:08: [io  0x0840-0x0847]
[    0.195354] pnp 00:08: [io  0x0b00-0x0b1f]
[    0.195358] pnp 00:08: [io  0x0b20-0x0b3f]
[    0.195361] pnp 00:08: [io  0x0c00-0x0c01]
[    0.195365] pnp 00:08: [io  0x0c14]
[    0.195369] pnp 00:08: [io  0x0c50-0x0c52]
[    0.195372] pnp 00:08: [io  0x0cd0-0x0cd1]
[    0.195377] pnp 00:08: [io  0x0cd2-0x0cd3]
[    0.195381] pnp 00:08: [io  0x0cd4-0x0cd5]
[    0.195384] pnp 00:08: [io  0x0cd6-0x0cd7]
[    0.195388] pnp 00:08: [io  0x0cd8-0x0cdf]
[    0.195392] pnp 00:08: [io  0x0cf9]
[    0.195396] pnp 00:08: [io  0x8100-0x81ff window]
[    0.195400] pnp 00:08: [io  0x8200-0x82ff window]
[    0.195555] system 00:08: [io  0x04d0-0x04d1] has been reserved
[    0.195560] system 00:08: [io  0x0530-0x0537] has been reserved
[    0.195566] system 00:08: [io  0x0800-0x0827] has been reserved
[    0.195571] system 00:08: [io  0x0830] has been reserved
[    0.195576] system 00:08: [io  0x0840-0x0847] has been reserved
[    0.195581] system 00:08: [io  0x0b00-0x0b1f] has been reserved
[    0.195586] system 00:08: [io  0x0b20-0x0b3f] has been reserved
[    0.195591] system 00:08: [io  0x0c00-0x0c01] has been reserved
[    0.195596] system 00:08: [io  0x0c14] has been reserved
[    0.195601] system 00:08: [io  0x0c50-0x0c52] has been reserved
[    0.195606] system 00:08: [io  0x0cd0-0x0cd1] has been reserved
[    0.195611] system 00:08: [io  0x0cd2-0x0cd3] has been reserved
[    0.195616] system 00:08: [io  0x0cd4-0x0cd5] has been reserved
[    0.195621] system 00:08: [io  0x0cd6-0x0cd7] has been reserved
[    0.195627] system 00:08: [io  0x0cd8-0x0cdf] has been reserved
[    0.195632] system 00:08: [io  0x0cf9] could not be reserved
[    0.195637] system 00:08: [io  0x8100-0x81ff window] has been reserved
[    0.195643] system 00:08: [io  0x8200-0x82ff window] has been reserved
[    0.195650] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.195796] pnp 00:09: [mem 0x000e0000-0x000fffff]
[    0.195801] pnp 00:09: [mem 0xffe00000-0xffffffff]
[    0.195806] pnp 00:09: [mem 0x00000000-0xffffffff disabled]
[    0.195810] pnp 00:09: [mem 0xfec10000-0xfec1001f]
[    0.195814] pnp 00:09: [mem 0xfed00000-0xfed003ff]
[    0.195818] pnp 00:09: [mem 0xfed61000-0xfed613ff]
[    0.195822] pnp 00:09: [mem 0xfed80000-0xfed80fff]
[    0.195932] system 00:09: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.195939] system 00:09: [mem 0xffe00000-0xffffffff] has been reserved
[    0.195944] system 00:09: [mem 0xfec10000-0xfec1001f] has been reserved
[    0.195950] system 00:09: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.195955] system 00:09: [mem 0xfed61000-0xfed613ff] has been reserved
[    0.195960] system 00:09: [mem 0xfed80000-0xfed80fff] has been reserved
[    0.195967] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.197489] pnp: PnP ACPI: found 10 devices
[    0.197495] ACPI: ACPI bus type pnp unregistered
[    0.236205] pci 0000:01:00.0: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]
[    0.236317] pci 0000:00:06.0: BAR 14: assigned [mem 0x7f000000-0x7f0fffff]
[    0.236338] pci 0000:00:15.1: BAR 15: assigned [mem 0x7f100000-0x7f2fffff 64bit pref]
[    0.236346] pci 0000:01:00.0: BAR 6: assigned [mem 0x90020000-0x9003ffff pref]
[    0.236352] pci 0000:00:06.0: PCI bridge to [bus 01-01]
[    0.236358] pci 0000:00:06.0:   bridge window [io  0x3000-0x3fff]
[    0.236366] pci 0000:00:06.0:   bridge window [mem 0x7f000000-0x7f0fffff]
[    0.236373] pci 0000:00:06.0:   bridge window [mem 0x90000000-0x900fffff 64bit pref]
[    0.236383] pci 0000:00:14.4: PCI bridge to [bus 02-02]
[    0.236387] pci 0000:00:14.4:   bridge window [io  disabled]
[    0.236441] pci 0000:00:14.4:   bridge window [mem disabled]
[    0.236448] pci 0000:00:14.4:   bridge window [mem pref disabled]
[    0.236458] pci 0000:00:15.0: PCI bridge to [bus 03-03]
[    0.236462] pci 0000:00:15.0:   bridge window [io  disabled]
[    0.236470] pci 0000:00:15.0:   bridge window [mem disabled]
[    0.236476] pci 0000:00:15.0:   bridge window [mem pref disabled]
[    0.236486] pci 0000:00:15.1: PCI bridge to [bus 04-04]
[    0.236492] pci 0000:00:15.1:   bridge window [io  0x2000-0x2fff]
[    0.236500] pci 0000:00:15.1:   bridge window [mem 0x90100000-0x901fffff]
[    0.236507] pci 0000:00:15.1:   bridge window [mem 0x7f100000-0x7f2fffff 64bit pref]
[    0.236541] pci 0000:00:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.236550] pci 0000:00:06.0: setting latency timer to 64
[    0.236572] pci 0000:00:15.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.236581] pci 0000:00:15.0: setting latency timer to 64
[    0.236592] pci 0000:00:15.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.236600] pci 0000:00:15.1: setting latency timer to 64
[    0.236607] pci_bus 0000:00: resource 4 [mem 0x000a0000-0x000bffff]
[    0.236612] pci_bus 0000:00: resource 5 [mem 0x000c0000-0x000c1fff]
[    0.236617] pci_bus 0000:00: resource 6 [mem 0x000c2000-0x000c3fff]
[    0.236621] pci_bus 0000:00: resource 7 [mem 0x000c4000-0x000c5fff]
[    0.236626] pci_bus 0000:00: resource 8 [mem 0x000c6000-0x000c7fff]
[    0.236631] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000c9fff]
[    0.236635] pci_bus 0000:00: resource 10 [mem 0x000ca000-0x000cbfff]
[    0.236640] pci_bus 0000:00: resource 11 [mem 0x000cc000-0x000cdfff]
[    0.236645] pci_bus 0000:00: resource 12 [mem 0x000d0000-0x000d1fff]
[    0.236650] pci_bus 0000:00: resource 13 [mem 0x000d2000-0x000d3fff]
[    0.236654] pci_bus 0000:00: resource 14 [mem 0x000d4000-0x000d5fff]
[    0.236659] pci_bus 0000:00: resource 15 [mem 0x000d6000-0x000d7fff]
[    0.236663] pci_bus 0000:00: resource 16 [mem 0x000d8000-0x000d9fff]
[    0.236668] pci_bus 0000:00: resource 17 [mem 0x000da000-0x000dbfff]
[    0.236673] pci_bus 0000:00: resource 18 [mem 0x000dc000-0x000ddfff]
[    0.236677] pci_bus 0000:00: resource 19 [mem 0x000de000-0x000dffff]
[    0.236682] pci_bus 0000:00: resource 20 [mem 0x000e0000-0x000e1fff]
[    0.236687] pci_bus 0000:00: resource 21 [mem 0x000e2000-0x000e3fff]
[    0.236691] pci_bus 0000:00: resource 22 [mem 0x000e4000-0x000e5fff]
[    0.236696] pci_bus 0000:00: resource 23 [mem 0x000e6000-0x000e7fff]
[    0.236701] pci_bus 0000:00: resource 24 [mem 0x000e8000-0x000e9fff]
[    0.236705] pci_bus 0000:00: resource 25 [mem 0x000ea000-0x000ebfff]
[    0.236710] pci_bus 0000:00: resource 26 [mem 0x000ec000-0x000edfff]
[    0.236715] pci_bus 0000:00: resource 27 [mem 0x000ee000-0x000effff]
[    0.236719] pci_bus 0000:00: resource 28 [mem 0x7f000000-0xf7ffffff]
[    0.236724] pci_bus 0000:00: resource 29 [mem 0xf8000000-0xffffffff]
[    0.236729] pci_bus 0000:00: resource 30 [io  0x0000-0x0cf7]
[    0.236734] pci_bus 0000:00: resource 31 [io  0x0d00-0xffff]
[    0.236738] pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
[    0.236743] pci_bus 0000:01: resource 1 [mem 0x7f000000-0x7f0fffff]
[    0.236748] pci_bus 0000:01: resource 2 [mem 0x90000000-0x900fffff 64bit pref]
[    0.236753] pci_bus 0000:02: resource 4 [mem 0x000a0000-0x000bffff]
[    0.236757] pci_bus 0000:02: resource 5 [mem 0x000c0000-0x000c1fff]
[    0.236762] pci_bus 0000:02: resource 6 [mem 0x000c2000-0x000c3fff]
[    0.236767] pci_bus 0000:02: resource 7 [mem 0x000c4000-0x000c5fff]
[    0.236771] pci_bus 0000:02: resource 8 [mem 0x000c6000-0x000c7fff]
[    0.236776] pci_bus 0000:02: resource 9 [mem 0x000c8000-0x000c9fff]
[    0.236780] pci_bus 0000:02: resource 10 [mem 0x000ca000-0x000cbfff]
[    0.236785] pci_bus 0000:02: resource 11 [mem 0x000cc000-0x000cdfff]
[    0.236790] pci_bus 0000:02: resource 12 [mem 0x000d0000-0x000d1fff]
[    0.236794] pci_bus 0000:02: resource 13 [mem 0x000d2000-0x000d3fff]
[    0.236799] pci_bus 0000:02: resource 14 [mem 0x000d4000-0x000d5fff]
[    0.236803] pci_bus 0000:02: resource 15 [mem 0x000d6000-0x000d7fff]
[    0.236808] pci_bus 0000:02: resource 16 [mem 0x000d8000-0x000d9fff]
[    0.236813] pci_bus 0000:02: resource 17 [mem 0x000da000-0x000dbfff]
[    0.236817] pci_bus 0000:02: resource 18 [mem 0x000dc000-0x000ddfff]
[    0.236822] pci_bus 0000:02: resource 19 [mem 0x000de000-0x000dffff]
[    0.236827] pci_bus 0000:02: resource 20 [mem 0x000e0000-0x000e1fff]
[    0.236831] pci_bus 0000:02: resource 21 [mem 0x000e2000-0x000e3fff]
[    0.236836] pci_bus 0000:02: resource 22 [mem 0x000e4000-0x000e5fff]
[    0.236841] pci_bus 0000:02: resource 23 [mem 0x000e6000-0x000e7fff]
[    0.236845] pci_bus 0000:02: resource 24 [mem 0x000e8000-0x000e9fff]
[    0.236850] pci_bus 0000:02: resource 25 [mem 0x000ea000-0x000ebfff]
[    0.236855] pci_bus 0000:02: resource 26 [mem 0x000ec000-0x000edfff]
[    0.236860] pci_bus 0000:02: resource 27 [mem 0x000ee000-0x000effff]
[    0.236864] pci_bus 0000:02: resource 28 [mem 0x7f000000-0xf7ffffff]
[    0.236869] pci_bus 0000:02: resource 29 [mem 0xf8000000-0xffffffff]
[    0.236874] pci_bus 0000:02: resource 30 [io  0x0000-0x0cf7]
[    0.236878] pci_bus 0000:02: resource 31 [io  0x0d00-0xffff]
[    0.236883] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
[    0.236888] pci_bus 0000:04: resource 1 [mem 0x90100000-0x901fffff]
[    0.236892] pci_bus 0000:04: resource 2 [mem 0x7f100000-0x7f2fffff 64bit pref]
[    0.237109] NET: Registered protocol family 2
[    0.237324] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.237726] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.238453] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.238795] TCP: Hash tables configured (established 131072 bind 65536)
[    0.238801] TCP reno registered
[    0.238809] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.238825] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.239543] NET: Registered protocol family 1
[    0.239573] pci 0000:00:01.0: Boot video device
[    0.261403] PCI: CLS 32 bytes, default 64
[    0.261533] Trying to unpack rootfs image as initramfs...
[    0.593202] Freeing initrd memory: 6400k freed
[    0.598326] apm: BIOS not found.
[    0.598648] audit: initializing netlink socket (disabled)
[    0.598671] type=2000 audit(1304175610.597:1): initialized
[    0.653722] highmem bounce pool size: 64 pages
[    0.653735] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.658168] VFS: Disk quotas dquot_6.5.2
[    0.658608] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.660577] msgmni has been set to 1702
[    0.660798] SELinux:  Registering netfilter hooks
[    0.661719] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.661726] io scheduler noop registered
[    0.661730] io scheduler deadline registered
[    0.661761] io scheduler cfq registered (default)
[    0.661983] pcieport 0000:00:06.0: setting latency timer to 64
[    0.662111] pcieport 0000:00:06.0: irq 40 for MSI/MSI-X
[    0.662259] pcieport 0000:00:15.0: setting latency timer to 64
[    0.662326] pcieport 0000:00:15.0: irq 41 for MSI/MSI-X
[    0.662434] pcieport 0000:00:15.1: setting latency timer to 64
[    0.662499] pcieport 0000:00:15.1: irq 42 for MSI/MSI-X
[    0.662728] pcieport 0000:00:06.0: Signaling PME through PCIe PME interrupt
[    0.662734] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    0.662742] pcie_pme 0000:00:06.0:pcie01: service driver pcie_pme loaded
[    0.662819] pcieport 0000:00:15.0: Signaling PME through PCIe PME interrupt
[    0.662827] pcie_pme 0000:00:15.0:pcie01: service driver pcie_pme loaded
[    0.662857] pcieport 0000:00:15.1: Signaling PME through PCIe PME interrupt
[    0.662862] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
[    0.662870] pcie_pme 0000:00:15.1:pcie01: service driver pcie_pme loaded
[    0.662906] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.663177] pciehp 0000:00:15.1:pcie04: HPC vendor_id 1002 device_id 43a1 ss_vid 1002 ss_did 0
[    0.663214] pciehp 0000:00:15.1:pcie04: service driver pciehp loaded
[    0.663229] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.663234] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.664344] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.664915] ACPI: AC Adapter [ACAD] (off-line)
[    0.665421] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.665431] ACPI: Power Button [PWRB]
[    0.665623] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    0.665630] ACPI: Sleep Button [SLPB]
[    0.665770] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
[    0.666236] ACPI: Lid Switch [LID]
[    0.666391] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.666401] ACPI: Power Button [PWRF]
[    0.666770] ACPI: acpi_idle registered with cpuidle
[    0.670863] thermal LNXTHERM:00: registered as thermal_zone0
[    0.670871] ACPI: Thermal Zone [THZ0] (69 C)
[    0.670920] ERST: Table is not found!
[    0.670956] isapnp: Scanning for PnP cards...
[    0.705370] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.705387] ACPI: Battery Slot [BAT1] (battery present)
[    1.066818] isapnp: No Plug & Play device found
[    1.066968] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.070840] Non-volatile memory driver v1.3
[    1.070847] Linux agpgart interface v0.103
[    1.075999] brd: module loaded
[    1.078484] loop: module loaded
[    1.078626] ahci 0000:00:11.0: version 3.0
[    1.078704] ahci 0000:00:11.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.078807] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 1 ports 3 Gbps 0x1 impl SATA mode
[    1.078815] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio ccc 
[    1.079384] scsi0 : ahci
[    1.079750] ata1: SATA max UDMA/133 abar m1024@0x9024a000 port 0x9024a100 irq 19
[    1.079932] Fixed MDIO Bus: probed
[    1.080163] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.080254] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.080288] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    1.080483] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    1.080584] ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.080631] QUIRK: Enable AMD PLL fix
[    1.080695] ehci_hcd 0000:00:12.2: debug port 1
[    1.080726] ehci_hcd 0000:00:12.2: irq 17, io mem 0x9024a500
[    1.086091] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    1.086163] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.086169] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.086173] usb usb1: Product: EHCI Host Controller
[    1.086177] usb usb1: Manufacturer: Linux 2.6.39-rc5 ehci_hcd
[    1.086181] usb usb1: SerialNumber: 0000:00:12.2
[    1.086421] hub 1-0:1.0: USB hub found
[    1.086432] hub 1-0:1.0: 5 ports detected
[    1.086669] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.086697] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    1.086787] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    1.087393] ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.087456] ehci_hcd 0000:00:13.2: debug port 1
[    1.087483] ehci_hcd 0000:00:13.2: irq 17, io mem 0x9024a400
[    1.093164] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    1.093227] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.093233] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.093238] usb usb2: Product: EHCI Host Controller
[    1.093242] usb usb2: Manufacturer: Linux 2.6.39-rc5 ehci_hcd
[    1.093246] usb usb2: SerialNumber: 0000:00:13.2
[    1.093511] hub 2-0:1.0: USB hub found
[    1.093521] hub 2-0:1.0: 5 ports detected
[    1.093724] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.093806] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.093840] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    1.093926] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
[    1.094073] ohci_hcd 0000:00:12.0: irq 18, io mem 0x90249000
[    1.149378] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.149386] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.149392] usb usb3: Product: OHCI Host Controller
[    1.149396] usb usb3: Manufacturer: Linux 2.6.39-rc5 ohci_hcd
[    1.149400] usb usb3: SerialNumber: 0000:00:12.0
[    1.149671] hub 3-0:1.0: USB hub found
[    1.149730] hub 3-0:1.0: 5 ports detected
[    1.149982] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.150032] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    1.150117] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 4
[    1.150362] ohci_hcd 0000:00:13.0: irq 18, io mem 0x90248000
[    1.205366] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.205375] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.205380] usb usb4: Product: OHCI Host Controller
[    1.205384] usb usb4: Manufacturer: Linux 2.6.39-rc5 ohci_hcd
[    1.205389] usb usb4: SerialNumber: 0000:00:13.0
[    1.205668] hub 4-0:1.0: USB hub found
[    1.205727] hub 4-0:1.0: 5 ports detected
[    1.205920] uhci_hcd: USB Universal Host Controller Interface driver
[    1.206130] i8042: PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
[    1.209101] i8042: Detected active multiplexing controller, rev 1.1
[    1.210772] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.210787] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.210844] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.210892] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.210942] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.211167] mousedev: PS/2 mouse device common for all mice
[    1.211679] rtc_cmos 00:04: RTC can wake from S4
[    1.212422] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    1.212510] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
[    1.212731] device-mapper: uevent: version 1.0.3
[    1.212935] device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised: dm-devel@redhat.com
[    1.213223] cpuidle: using governor ladder
[    1.213405] cpuidle: using governor menu
[    1.213409] EFI Variables Facility v0.08 2004-May-17
[    1.213725] usbcore: registered new interface driver usbhid
[    1.213729] usbhid: USB HID core driver
[    1.213805] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    1.214347] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.214410] TCP cubic registered
[    1.214413] Initializing XFRM netlink socket
[    1.214430] NET: Registered protocol family 17
[    1.214464] Registering the dns_resolver key type
[    1.214497] Using IPI No-Shortcut mode
[    1.214666] PM: Hibernation image not present or could not be loaded.
[    1.214697] registered taskstats version 1
[    1.214771] IMA: No TPM chip found, activating TPM-bypass!
[    1.215574]   Magic number: 7:793:33
[    1.215766] rtc_cmos 00:04: setting system clock to 2011-04-30 15:00:12 UTC (1304175612)
[    1.215831] Initializing network drop monitor service
[    1.252205] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    1.395124] usb 2-2: new high speed USB device number 2 using ehci_hcd
[    1.522632] usb 2-2: New USB device found, idVendor=0bda, idProduct=0158
[    1.522647] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.522657] usb 2-2: Product: USB2.0-CRW
[    1.522664] usb 2-2: Manufacturer: Generic
[    1.522672] usb 2-2: SerialNumber: 20071114173400000
[    1.539103] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.539492] ata1.00: ATA-8: INTEL SSDSA2CW080G3, 4PC10302, max UDMA/133
[    1.539503] ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.540100] ata1.00: configured for UDMA/133
[    1.540758] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2CW08 4PC1 PQ: 0 ANSI: 5
[    1.541216] sd 0:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
[    1.541274] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.541396] sd 0:0:0:0: [sda] Write Protect is off
[    1.541402] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.541642] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.544916]  sda: sda1 sda2 sda3
[    1.546148] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.546365] Freeing unused kernel memory: 576k freed
[    1.546937] Write protecting the kernel text: 4004k
[    1.547095] Write protecting the kernel read-only data: 1888k
[    1.583733] dracut: dracut-006-6.fc14
[    1.601345] Refined TSC clocksource calibration: 1596.599 MHz.
[    1.601355] Switching to clocksource tsc
[    1.601872] dracut: rd_NO_LUKS: removing cryptoluks activation
[    1.613159] udev[62]: starting version 161
[    1.629166] usb 2-5: new high speed USB device number 3 using ehci_hcd
[    1.727639] [drm] Initialized drm 1.1.0 20060810
[    1.749187] usb 2-5: New USB device found, idVendor=5986, idProduct=01a7
[    1.749195] usb 2-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.749200] usb 2-5: Product: Integrated Camera
[    1.749204] usb 2-5: Manufacturer: Image Processor
[    1.749208] usb 2-5: SerialNumber: Integrated Camera
[    1.817262] [drm] radeon defaulting to kernel modesetting.
[    1.817269] [drm] radeon kernel modesetting enabled.
[    1.817350] radeon 0000:00:01.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.817360] radeon 0000:00:01.0: setting latency timer to 64
[    1.817697] [drm] initializing kernel modesetting (PALM 0x1002:0x9802).
[    1.817778] [drm] register mmio base: 0x90200000
[    1.817782] [drm] register mmio size: 262144
[    1.818029] ATOM BIOS: Lenovo
[    1.818081] radeon 0000:00:01.0: VRAM: 384M 0x0000000000000000 - 0x0000000017FFFFFF (384M used)
[    1.818087] radeon 0000:00:01.0: GTT: 512M 0x0000000018000000 - 0x0000000037FFFFFF
[    1.818106] mtrr: no more MTRRs available
[    1.818111] [drm] Detected VRAM RAM=384M, BAR=256M
[    1.818114] [drm] RAM width 16bits DDR
[    1.818294] [TTM] Zone  kernel: Available graphics memory: 436200 kiB.
[    1.818299] [TTM] Zone highmem: Available graphics memory: 825868 kiB.
[    1.818303] [TTM] Initializing pool allocator.
[    1.818344] [drm] radeon: 384M of VRAM memory ready
[    1.818349] [drm] radeon: 512M of GTT memory ready.
[    1.818372] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    1.818376] [drm] Driver supports precise vblank timestamp query.
[    1.818424] radeon 0000:00:01.0: irq 43 for MSI/MSI-X
[    1.818432] radeon 0000:00:01.0: radeon: using MSI.
[    1.818478] [drm] radeon: irq initialized.
[    1.818489] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    1.819765] [drm] Loading PALM Microcode
[    1.833414] radeon 0000:00:01.0: WB enabled
[    1.850252] [drm] ring test succeeded in 1 usecs
[    1.850644] [drm] radeon: ib pool ready.
[    1.850833] [drm] ib test succeeded in 0 usecs
[    1.851970] [drm] Radeon Display Connectors
[    1.851976] [drm] Connector 0:
[    1.851979] [drm]   LVDS
[    1.851981] [drm]   HPD1
[    1.851986] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438 0x643c 0x643c
[    1.851990] [drm]   Encoders:
[    1.851993] [drm]     LCD1: INTERNAL_UNIPHY
[    1.851997] [drm] Connector 1:
[    1.851999] [drm]   HDMI-A
[    1.852023] [drm]   HPD2
[    1.852029] [drm]   DDC: 0x6440 0x6440 0x6444 0x6444 0x6448 0x6448 0x644c 0x644c
[    1.852032] [drm]   Encoders:
[    1.852035] [drm]     DFP1: INTERNAL_UNIPHY
[    1.852038] [drm] Connector 2:
[    1.852040] [drm]   VGA
[    1.852044] [drm]   DDC: 0x64d8 0x64d8 0x64dc 0x64dc 0x64e0 0x64e0 0x64e4 0x64e4
[    1.852048] [drm]   Encoders:
[    1.852050] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    1.930717] [drm] Internal thermal controller without fan control
[    1.930809] [drm] radeon: power management initialized
[    2.257002] Synaptics Touchpad, model: 1, fw: 7.5, id: 0x1e0b1, caps: 0xd000b3/0x340000/0xa0400
[    2.257042] serio: Synaptics pass-through port at isa0060/serio4/input0
[    2.296556] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input5
[    2.396783] [drm] fb mappable at 0x80141000
[    2.396790] [drm] vram apper at 0x80000000
[    2.396793] [drm] size 4325376
[    2.396796] [drm] fb depth is 24
[    2.396799] [drm]    pitch is 5632
[    2.396940] fbcon: radeondrmfb (fb0) is primary device
[    2.924031] Console: switching to colour frame buffer device 170x48
[    2.931835] fb0: radeondrmfb frame buffer device
[    2.931838] drm: registered panic notifier
[    2.931850] [drm] Initialized radeon 2.9.0 20080528 for 0000:00:01.0 on minor 0
[    2.972153] dracut: Starting plymouth daemon
[    3.326815] Initializing USB Mass Storage driver...
[    3.327259] scsi1 : usb-storage 2-2:1.0
[    3.327470] usbcore: registered new interface driver usb-storage
[    3.327474] USB Mass Storage support registered.
[    3.516591] EXT4-fs (sda3): INFO: recovery required on readonly filesystem
[    3.516601] EXT4-fs (sda3): write access will be enabled during recovery
[    3.557229] EXT4-fs (sda3): recovery complete
[    3.559058] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
[    3.573967] dracut: Remounting /dev/disk/by-uuid/5dc7080b-9a2a-443d-8860-12f951845d5a with -o noatime,discard,ro
[    3.605959] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: discard
[    3.609585] dracut: Mounted root filesystem /dev/sda3
[    3.662032] dracut: Loading SELinux policy
[    3.712224] type=1404 audit(1304175614.995:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[    3.760591] SELinux: 2048 avtab hash slots, 215688 rules.
[    3.903442] SELinux: 2048 avtab hash slots, 215688 rules.
[    4.330791] scsi 1:0:0:0: Direct-Access     Generic- Multi-Card       1.00 PQ: 0 ANSI: 0 CCS
[    4.336176] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    4.342544] sd 1:0:0:0: [sdb] Attached SCSI removable disk
[    4.733295] psmouse serio5: ID: 10 00 64
[    4.825494] SELinux:  9 users, 14 roles, 3521 types, 184 bools, 1 sens, 1024 cats
[    4.825504] SELinux:  81 classes, 215688 rules
[    4.839404] SELinux:  Permission read_policy in class security not defined in policy.
[    4.839656] SELinux:  Permission syslog in class capability2 not defined in policy.
[    4.839668] SELinux: the above unknown classes and permissions will be allowed
[    4.839684] SELinux:  Completing initialization.
[    4.839687] SELinux:  Setting up existing superblocks.
[    4.839705] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    4.839718] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[    4.839880] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    4.839892] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    4.839907] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    4.840234] SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
[    4.841582] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    4.841595] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[    4.844650] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    4.844671] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[    4.844680] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[    4.844729] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    4.844742] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[    4.844760] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[    4.844790] SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
[    4.844802] SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
[    4.844812] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    4.846160] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    4.846201] SELinux: initialized (dev sda3, type ext4), uses xattr
[    4.850354] type=1403 audit(1304175616.133:3): policy loaded auid=4294967295 ses=4294967295
[    5.618936] dracut: Switching root
[    6.846300] udev[297]: starting version 161
[    7.096847] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[    7.157842] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    7.157935] r8169 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    7.157994] r8169 0000:01:00.0: setting latency timer to 64
[    7.158086] r8169 0000:01:00.0: irq 44 for MSI/MSI-X
[    7.158307] r8169 0000:01:00.0: eth0: RTL8168d/8111d at 0xf8ede000, 60:eb:69:f0:33:cb, XID 083000c0 IRQ 44
[    7.229279] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[    7.291100] acpi device:34: registered as cooling_device2
[    7.291297] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input6
[    7.291416] ACPI: Video Device [VGA1] (multi-head: yes  rom: no  post: no)
[    7.491828] input: PC Speaker as /devices/platform/pcspkr/input/input7
[    7.534414] Linux video capture interface: v2.00
[    7.619538] microcode: CPU0: patch_level=0x05000028
[    7.768397] uvcvideo: Found UVC 1.00 device Integrated Camera (5986:01a7)
[    7.798071] input: Integrated Camera as /devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.0/input/input8
[    7.798222] usbcore: registered new interface driver uvcvideo
[    7.798226] USB Video Class driver (v1.0.0)
[    7.878930] microcode: CPU1: patch_level=0x05000028
[    7.900780] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    7.945790] HDA Intel 0000:00:01.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    7.945915] HDA Intel 0000:00:01.1: irq 45 for MSI/MSI-X
[    7.946025] HDA Intel 0000:00:01.1: setting latency timer to 64
[    7.957727] cfg80211: Calling CRDA to update world regulatory domain
[    8.012405] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    8.063836] microcode: AMD microcode update via /dev/cpu/microcode not supported
[    8.064156] cfg80211: World regulatory domain updated:
[    8.064165] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    8.064172] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.064177] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    8.064183] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    8.064188] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.064193] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.142602] type=1400 audit(1304175619.425:4): avc:  denied  { read } for  pid=548 comm="alsactl" name="controlC1" dev=devtmpfs ino=7664 scontext=system_u:system_r:alsa_t:s0-s0:c0.c1023 tcontext=system_u:object_r:device_t:s0 tclass=chr_file
[    8.237349] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    8.270743] microcode: AMD microcode update via /dev/cpu/microcode not supported
[    8.275239] microcode: AMD microcode update via /dev/cpu/microcode not supported
[    8.283432] microcode: AMD microcode update via /dev/cpu/microcode not supported
[    8.290131] microcode: AMD microcode update via /dev/cpu/microcode not supported
[    8.299414] rtl8192ce 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    8.299429] rtl8192ce 0000:04:00.0: setting latency timer to 64
[    8.331305] IPv4 FIB: Using LC-trie version 0.409
[    8.349312] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[    8.349687] rtlwifi: wireless switch is off
[    8.400090] cfg80211: Calling CRDA for country: US
[    8.410402] cfg80211: Regulatory domain changed to country: US
[    8.410410] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    8.410416] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[    8.410422] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[    8.410427] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.410433] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.410438] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.410443] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[    8.456714] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio4/serio5/input/input9
[    9.334445] EXT4-fs (sda3): re-mounted. Opts: discard
[    9.881694] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    9.882100] SELinux: initialized (dev sda1, type ext4), uses xattr
[    9.903116] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   11.409638] Adding 2097148k swap on /dev/sda2.  Priority:-1 extents:1 across:2097148k SS
[   11.422110] SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
[   11.743438] NET: Registered protocol family 10
[   11.758365] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   12.123485] powernow-k8: Found 1 AMD E-350 Processor (2 cpu cores) (version 2.20.00)
[   12.123576] powernow-k8:    0 : pstate 0 (1600 MHz)
[   12.123581] powernow-k8:    1 : pstate 1 (1280 MHz)
[   12.123585] powernow-k8:    2 : pstate 2 (800 MHz)
[   12.653907] tun: Universal TUN/TAP device driver, 1.6
[   12.653915] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   12.887121] r8169 0000:01:00.0: eth0: link down
[   12.887540] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   12.898239] rtl8192cu: Loading firmware file rtlwifi/rtl8192cfw.bin
[   13.249254] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   18.590976] hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
[   30.055474] fuse init (API version 7.16)
[   30.098765] SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
[   30.188781] SELinux: initialized (dev fusectl, type fusectl), uses genfs_contexts
[   34.656636] wlan0: deauthenticating from 30:46:9a:99:c5:80 by local choice (reason=3)
[   34.879029] wlan0: authenticate with 30:46:9a:99:c5:80 (try 1)
[   34.934580] wlan0: authenticated
[   34.956360] wlan0: associate with 30:46:9a:99:c5:80 (try 1)
[   34.996625] wlan0: RX AssocResp from 30:46:9a:99:c5:80 (capab=0x411 status=0 aid=2)
[   34.996640] wlan0: associated
[   35.008990] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   35.215606] padlock_aes: VIA PadLock not detected.
[   45.106276] wlan0: no IPv6 routers present
[   97.060705] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[  107.834344] exe (1906): /proc/1906/oom_adj is deprecated, please use /proc/1906/oom_score_adj instead.

--=-=-=
Content-Type: text/plain


-- 
Shawn Nock (OpenPGP: 0x8132E623)

--=-=-=--
