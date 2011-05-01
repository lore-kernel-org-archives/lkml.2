Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761307Ab1EASDK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 14:03:10 -0400
Received: from [173.245.73.87] ([173.245.73.87]:56908 "EHLO nocko.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755358Ab1EASDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 14:03:06 -0400
From: Shawn Nock <nock@nocko.org>
To: Larry.Finger@lwfinger.net
Cc: linux-kernel@vger.kernel.org
Subject: rtlwifi: regression 39-rc5 (rtl8192ce)
User-Agent: Gnus/5.110016 (No Gnus v0.16) Emacs/23.2 (gnu/linux)
Date: Sun, 01 May 2011 13:59:10 -0400
Message-ID: <m3zkn6paj5.fsf@nocko.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain


During heavy network traffic (esp. flash video) I see the attached NULL
pointer dereference in 2.6.39-rc5 on an IBM Thinkpad x120e. Immediately
afterward a "scheduling while atomic" bug is reported and the system
becomes unresponsive. I am unable to produce this problem in 2.6.38.4.

See attached backtrace and dmesg. Please let me know what I can collect
to make this problem easier to troubleshoot.


--=-=-=
Content-Type: text/plain
Content-Disposition: attachment; filename=rtlwifi_bug.txt
Content-Description: rtlwifi bug backtrace

BUG: unable to handle kernel NULL pointer dereference at 00000020
IP: [<f995d28b>] rtl92ce_rx_query_desc+0x1de/0x783 [rtl8192ce]
*pde = 63fe9067 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
Modules linked in: aes_i586 aes_generic fuse tun cpufreq_ondemand powernow_k8 mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 uinput arc4 ecb snd_hda_codec_conexant rtl8192ce snd_hda_codec_hdmi rtl8192c_common snd_hda_intel rtlwifi snd_hda_codec mac80211 snd_hwdep snd_seq snd_seq_device uvcvideo snd_pcm videodev microcode cfg80211 k10temp pcspkr joydev serio_raw snd_timer snd video rfkill r8169 soundcore i2c_piix4 snd_page_alloc mii usb_storage radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Not tainted 2.6.39-rc5 #1 LENOVO 05962PU/05962PU
EIP: 0060:[<f995d28b>] EFLAGS: 00010202 CPU: 0
EIP is at rtl92ce_rx_query_desc+0x1de/0x783 [rtl8192ce]
EAX: 00000000 EBX: f2c6f5c0 ECX: f2c510e0 EDX: 00000000
ESI: f4c23f14 EDI: 00000020 EBP: f4c23ec0 ESP: f4c23e94
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process swapper (pid: 0, ti=f4c22000 task=c0a0ffe0 task.ti=c09c2000)
Stack:
 00000281 00000000 00000000 00000000 f5806a80 f2c502e0 00000000 f4c23f68
 f995fb7c f2c510e0 f4c23f68 f4c23fa0 f97e0cf8 f2c6f5c0 f1ea5c00 000001f0
 f5806a90 000100d8 f4c23f68 f2c5314c ffffffff f5806a80 0000797c 00000000
Call Trace:
 [<f97e0cf8>] _rtl_pci_rx_interrupt+0x106/0x4e8 [rtlwifi]
 [<f97e10e7>] _rtl_pci_irq_tasklet+0xd/0x12 [rtlwifi]
 [<c0441f09>] tasklet_action+0x6a/0xae
 [<c04421ab>] __do_softirq+0xa5/0x160
 [<c0442106>] ? local_bh_enable+0xf/0xf

--=-=-=
Content-Type: text/plain
Content-Disposition: attachment; filename=dmesg-39rc5.txt
Content-Description: dmesg from affected host

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.39-rc5 (nock@netbook) (gcc version 4.5.1 20100924 (Red Hat 4.5.1-4) (GCC) ) #1 SMP Sun May 1 11:57:11 EDT 2011
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
[    0.000000] RAMDISK: 37196000 - 37ff0000
[    0.000000] Allocated new RAMDISK: 361a4000 - 36ffdee6
[    0.000000] Move RAMDISK from 0000000037196000 - 0000000037fefee5 to 361a4000 - 36ffdee5
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
[    0.000000] free_area_init_node: node 0, pgdat c0a2bb00, node_mem_map f54c3200
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
[    0.000000] PERCPU: Embedded 12 pages/cpu @f5000000 s27712 r0 d21440 u2097152
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
[    0.000000] Memory: 1636624k/1685504k available (3911k kernel code, 43364k reserved, 2461k data, 564k init, 779336k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xff575000 - 0xfffff000   (10792 kB)
[    0.000000]     pkmap   : 0xff000000 - 0xff400000   (4096 kB)
[    0.000000]     vmalloc : 0xf77fe000 - 0xfeffe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf6ffe000   ( 879 MB)
[    0.000000]       .init : 0xc0a3a000 - 0xc0ac7000   ( 564 kB)
[    0.000000]       .data : 0xc07d1c4a - 0xc0a39300   (2461 kB)
[    0.000000]       .text : 0xc0400000 - 0xc07d1c4a   (3911 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] NR_IRQS:2304
[    0.000000] CPU 0 irqstacks, hard=f4420000 soft=f4422000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1596.705 MHz processor.
[    0.001004] Calibrating delay loop (skipped), value calculated using timer frequency.. 3193.41 BogoMIPS (lpj=1596705)
[    0.001014] pid_max: default: 32768 minimum: 301
[    0.001383] Security Framework initialized
[    0.001397] SELinux:  Initializing.
[    0.001446] SELinux:  Starting in permissive mode
[    0.001690] Mount-cache hash table entries: 512
[    0.002982] Initializing cgroup subsys ns
[    0.003010] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.003017] Initializing cgroup subsys cpuacct
[    0.003133] Initializing cgroup subsys memory
[    0.003187] Initializing cgroup subsys devices
[    0.003192] Initializing cgroup subsys freezer
[    0.003196] Initializing cgroup subsys net_cls
[    0.003201] Initializing cgroup subsys blkio
[    0.003330] CPU: Physical Processor ID: 0
[    0.003334] CPU: Processor Core ID: 0
[    0.003340] mce: CPU supports 6 MCE banks
[    0.004346] ACPI: Core revision 20110316
[    0.018024] ftrace: allocating 23260 entries in 46 pages
[    0.019142] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.020368] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.030353] CPU0: AMD E-350 Processor stepping 00
[    0.030997] Performance Events: AMD PMU driver.
[    0.030997] ... version:                0
[    0.030997] ... bit width:              48
[    0.030997] ... generic registers:      4
[    0.030997] ... value mask:             0000ffffffffffff
[    0.030997] ... max period:             00007fffffffffff
[    0.030997] ... fixed-purpose events:   0
[    0.030997] ... event mask:             000000000000000f
[    0.031057] CPU 1 irqstacks, hard=f44de000 soft=f44e8000
[    0.031062] Booting Node   0, Processors  #1 Ok.
[    0.031066] smpboot cpu 1: start_ip = 99000
[    0.001999] Initializing CPU#1
[    0.103014] Brought up 2 CPUs
[    0.103019] Total of 2 processors activated (6386.33 BogoMIPS).
[    0.104457] devtmpfs: initialized
[    0.105012] PM: Registering ACPI NVS region at 66312000 (524288 bytes)
[    0.106916] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.107013] Time: 17:15:20  Date: 05/01/11
[    0.107225] NET: Registered protocol family 16
[    0.107565] Extended Config Space enabled on 0 nodes
[    0.107681] ACPI: bus type pci registered
[    0.108181] PCI: MMCONFIG for domain 0000 [bus 00-1f] at [mem 0xf8000000-0xf9ffffff] (base 0xf8000000)
[    0.108187] PCI: not using MMCONFIG
[    0.108294] PCI: PCI BIOS revision 3.00 entry at 0xfc030, last bus=31
[    0.108297] PCI: Using configuration type 1 for base access
[    0.108300] PCI: Using configuration type 1 for extended access
[    0.110224] bio: create slab <bio-0> at 0
[    0.114108] ACPI: EC: Look up EC in DSDT
[    0.124222] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.131271] ACPI: Interpreter enabled
[    0.131282] ACPI: (supports S0 S3 S4 S5)
[    0.131324] ACPI: Using IOAPIC for interrupt routing
[    0.131641] PCI: MMCONFIG for domain 0000 [bus 00-1f] at [mem 0xf8000000-0xf9ffffff] (base 0xf8000000)
[    0.132200] PCI: MMCONFIG at [mem 0xf8000000-0xf9ffffff] reserved in ACPI motherboard resources
[    0.132205] PCI: Using MMCONFIG for extended config space
[    0.133069] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[    0.142639] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[    0.145016] ACPI: EC: GPE = 0x3, I/O: command/status = 0x66, data = 0x62
[    0.148365] ACPI: No dock devices found.
[    0.148374] HEST: Table not found.
[    0.148382] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.149804] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.151937] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.151943] pci_root PNP0A08:00: host bridge window [mem 0x000c0000-0x000c1fff]
[    0.151948] pci_root PNP0A08:00: host bridge window [mem 0x000c2000-0x000c3fff]
[    0.151953] pci_root PNP0A08:00: host bridge window [mem 0x000c4000-0x000c5fff]
[    0.151957] pci_root PNP0A08:00: host bridge window [mem 0x000c6000-0x000c7fff]
[    0.151962] pci_root PNP0A08:00: host bridge window [mem 0x000c8000-0x000c9fff]
[    0.151966] pci_root PNP0A08:00: host bridge window [mem 0x000ca000-0x000cbfff]
[    0.151971] pci_root PNP0A08:00: host bridge window [mem 0x000cc000-0x000cdfff]
[    0.151975] pci_root PNP0A08:00: host bridge window [mem 0x000ce000-0x000cffff]
[    0.151980] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d1fff]
[    0.151991] pci_root PNP0A08:00: host bridge window [mem 0x000d2000-0x000d3fff]
[    0.151996] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d5fff]
[    0.152000] pci_root PNP0A08:00: host bridge window [mem 0x000d6000-0x000d7fff]
[    0.152005] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000d9fff]
[    0.152009] pci_root PNP0A08:00: host bridge window [mem 0x000da000-0x000dbfff]
[    0.152013] pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x000ddfff]
[    0.152018] pci_root PNP0A08:00: host bridge window [mem 0x000de000-0x000dffff]
[    0.152022] pci_root PNP0A08:00: host bridge window [mem 0x000e0000-0x000e1fff]
[    0.152027] pci_root PNP0A08:00: host bridge window [mem 0x000e2000-0x000e3fff]
[    0.152031] pci_root PNP0A08:00: host bridge window [mem 0x000e4000-0x000e5fff]
[    0.152035] pci_root PNP0A08:00: host bridge window [mem 0x000e6000-0x000e7fff]
[    0.152040] pci_root PNP0A08:00: host bridge window [mem 0x000e8000-0x000e9fff]
[    0.152044] pci_root PNP0A08:00: host bridge window [mem 0x000ea000-0x000ebfff]
[    0.152049] pci_root PNP0A08:00: host bridge window [mem 0x000ec000-0x000edfff]
[    0.152053] pci_root PNP0A08:00: host bridge window [mem 0x000ee000-0x000effff]
[    0.152057] pci_root PNP0A08:00: host bridge window [mem 0x7f000000-0xf7ffffff]
[    0.152062] pci_root PNP0A08:00: host bridge window [mem 0xf8000000-0xffffffff]
[    0.152067] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.152071] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.152090] pci_root PNP0A08:00: address space collision: host bridge window [mem 0x000ce000-0x000cffff] conflicts with Video ROM [mem 0x000c0000-0x000ce1ff]
[    0.152224] pci 0000:00:00.0: [1022:1510] type 0 class 0x000600
[    0.152285] pci 0000:00:01.0: [1002:9802] type 0 class 0x000300
[    0.152301] pci 0000:00:01.0: reg 10: [mem 0x80000000-0x8fffffff pref]
[    0.152313] pci 0000:00:01.0: reg 14: [io  0x4000-0x40ff]
[    0.152324] pci 0000:00:01.0: reg 18: [mem 0x90200000-0x9023ffff]
[    0.152374] pci 0000:00:01.0: supports D1 D2
[    0.152400] pci 0000:00:01.1: [1002:1314] type 0 class 0x000403
[    0.152415] pci 0000:00:01.1: reg 10: [mem 0x90244000-0x90247fff]
[    0.152476] pci 0000:00:01.1: supports D1 D2
[    0.152515] pci 0000:00:06.0: [1022:1514] type 1 class 0x000604
[    0.152577] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.152583] pci 0000:00:06.0: PME# disabled
[    0.152680] pci 0000:00:11.0: [1002:4391] type 0 class 0x000106
[    0.152709] pci 0000:00:11.0: reg 10: [io  0x4118-0x411f]
[    0.152724] pci 0000:00:11.0: reg 14: [io  0x4124-0x4127]
[    0.152739] pci 0000:00:11.0: reg 18: [io  0x4110-0x4117]
[    0.152753] pci 0000:00:11.0: reg 1c: [io  0x4120-0x4123]
[    0.152768] pci 0000:00:11.0: reg 20: [io  0x4100-0x410f]
[    0.152782] pci 0000:00:11.0: reg 24: [mem 0x9024a000-0x9024a3ff]
[    0.152849] pci 0000:00:12.0: [1002:4397] type 0 class 0x000c03
[    0.152869] pci 0000:00:12.0: reg 10: [mem 0x90249000-0x90249fff]
[    0.152967] pci 0000:00:12.2: [1002:4396] type 0 class 0x000c03
[    0.153005] pci 0000:00:12.2: reg 10: [mem 0x9024a500-0x9024a5ff]
[    0.153101] pci 0000:00:12.2: supports D1 D2
[    0.153105] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.153112] pci 0000:00:12.2: PME# disabled
[    0.153145] pci 0000:00:13.0: [1002:4397] type 0 class 0x000c03
[    0.153166] pci 0000:00:13.0: reg 10: [mem 0x90248000-0x90248fff]
[    0.153263] pci 0000:00:13.2: [1002:4396] type 0 class 0x000c03
[    0.153291] pci 0000:00:13.2: reg 10: [mem 0x9024a400-0x9024a4ff]
[    0.153386] pci 0000:00:13.2: supports D1 D2
[    0.153390] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.153397] pci 0000:00:13.2: PME# disabled
[    0.153429] pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
[    0.153537] pci 0000:00:14.2: [1002:4383] type 0 class 0x000403
[    0.153569] pci 0000:00:14.2: reg 10: [mem 0x90240000-0x90243fff 64bit]
[    0.153648] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.153655] pci 0000:00:14.2: PME# disabled
[    0.153676] pci 0000:00:14.3: [1002:439d] type 0 class 0x000601
[    0.153779] pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
[    0.153850] pci 0000:00:15.0: [1002:43a0] type 1 class 0x000604
[    0.153932] pci 0000:00:15.0: supports D1 D2
[    0.153971] pci 0000:00:15.1: [1002:43a1] type 1 class 0x000604
[    0.154062] pci 0000:00:15.1: supports D1 D2
[    0.154107] pci 0000:00:18.0: [1022:1700] type 0 class 0x000600
[    0.154159] pci 0000:00:18.1: [1022:1701] type 0 class 0x000600
[    0.154206] pci 0000:00:18.2: [1022:1702] type 0 class 0x000600
[    0.154254] pci 0000:00:18.3: [1022:1703] type 0 class 0x000600
[    0.154310] pci 0000:00:18.4: [1022:1704] type 0 class 0x000600
[    0.154356] pci 0000:00:18.5: [1022:1718] type 0 class 0x000600
[    0.154403] pci 0000:00:18.6: [1022:1716] type 0 class 0x000600
[    0.154449] pci 0000:00:18.7: [1022:1719] type 0 class 0x000600
[    0.154575] pci 0000:01:00.0: [10ec:8168] type 0 class 0x000200
[    0.154597] pci 0000:01:00.0: reg 10: [io  0x3000-0x30ff]
[    0.154629] pci 0000:01:00.0: reg 18: [mem 0x90004000-0x90004fff 64bit pref]
[    0.154651] pci 0000:01:00.0: reg 20: [mem 0x90000000-0x90003fff 64bit pref]
[    0.154667] pci 0000:01:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    0.154711] pci 0000:01:00.0: supports D1 D2
[    0.154715] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.154722] pci 0000:01:00.0: PME# disabled
[    0.156055] pci 0000:00:06.0: PCI bridge to [bus 01-01]
[    0.156077] pci 0000:00:06.0:   bridge window [io  0x3000-0x3fff]
[    0.156090] pci 0000:00:06.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.156107] pci 0000:00:06.0:   bridge window [mem 0x90000000-0x900fffff 64bit pref]
[    0.156252] pci 0000:00:14.4: PCI bridge to [bus 02-02] (subtractive decode)
[    0.156260] pci 0000:00:14.4:   bridge window [io  0xf000-0x0000] (disabled)
[    0.156268] pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.156277] pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.156283] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.156288] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000c1fff] (subtractive decode)
[    0.156293] pci 0000:00:14.4:   bridge window [mem 0x000c2000-0x000c3fff] (subtractive decode)
[    0.156298] pci 0000:00:14.4:   bridge window [mem 0x000c4000-0x000c5fff] (subtractive decode)
[    0.156303] pci 0000:00:14.4:   bridge window [mem 0x000c6000-0x000c7fff] (subtractive decode)
[    0.156308] pci 0000:00:14.4:   bridge window [mem 0x000c8000-0x000c9fff] (subtractive decode)
[    0.156313] pci 0000:00:14.4:   bridge window [mem 0x000ca000-0x000cbfff] (subtractive decode)
[    0.156318] pci 0000:00:14.4:   bridge window [mem 0x000cc000-0x000cdfff] (subtractive decode)
[    0.156323] pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000d1fff] (subtractive decode)
[    0.156328] pci 0000:00:14.4:   bridge window [mem 0x000d2000-0x000d3fff] (subtractive decode)
[    0.156333] pci 0000:00:14.4:   bridge window [mem 0x000d4000-0x000d5fff] (subtractive decode)
[    0.156337] pci 0000:00:14.4:   bridge window [mem 0x000d6000-0x000d7fff] (subtractive decode)
[    0.156342] pci 0000:00:14.4:   bridge window [mem 0x000d8000-0x000d9fff] (subtractive decode)
[    0.156347] pci 0000:00:14.4:   bridge window [mem 0x000da000-0x000dbfff] (subtractive decode)
[    0.156352] pci 0000:00:14.4:   bridge window [mem 0x000dc000-0x000ddfff] (subtractive decode)
[    0.156357] pci 0000:00:14.4:   bridge window [mem 0x000de000-0x000dffff] (subtractive decode)
[    0.156362] pci 0000:00:14.4:   bridge window [mem 0x000e0000-0x000e1fff] (subtractive decode)
[    0.156367] pci 0000:00:14.4:   bridge window [mem 0x000e2000-0x000e3fff] (subtractive decode)
[    0.156372] pci 0000:00:14.4:   bridge window [mem 0x000e4000-0x000e5fff] (subtractive decode)
[    0.156377] pci 0000:00:14.4:   bridge window [mem 0x000e6000-0x000e7fff] (subtractive decode)
[    0.156381] pci 0000:00:14.4:   bridge window [mem 0x000e8000-0x000e9fff] (subtractive decode)
[    0.156386] pci 0000:00:14.4:   bridge window [mem 0x000ea000-0x000ebfff] (subtractive decode)
[    0.156391] pci 0000:00:14.4:   bridge window [mem 0x000ec000-0x000edfff] (subtractive decode)
[    0.156409] pci 0000:00:14.4:   bridge window [mem 0x000ee000-0x000effff] (subtractive decode)
[    0.156414] pci 0000:00:14.4:   bridge window [mem 0x7f000000-0xf7ffffff] (subtractive decode)
[    0.156419] pci 0000:00:14.4:   bridge window [mem 0xf8000000-0xffffffff] (subtractive decode)
[    0.156424] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.156429] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.156518] pci 0000:00:15.0: PCI bridge to [bus 03-03]
[    0.156528] pci 0000:00:15.0:   bridge window [io  0xfffff000-0x0000] (disabled)
[    0.156535] pci 0000:00:15.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.156545] pci 0000:00:15.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.156645] pci 0000:04:00.0: [10ec:8176] type 0 class 0x000280
[    0.156677] pci 0000:04:00.0: reg 10: [io  0x2000-0x20ff]
[    0.156722] pci 0000:04:00.0: reg 18: [mem 0x90100000-0x90103fff 64bit]
[    0.156829] pci 0000:04:00.0: supports D1 D2
[    0.156833] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.156842] pci 0000:04:00.0: PME# disabled
[    0.159050] pci 0000:00:15.1: PCI bridge to [bus 04-04]
[    0.159067] pci 0000:00:15.1:   bridge window [io  0x2000-0x2fff]
[    0.159079] pci 0000:00:15.1:   bridge window [mem 0x90100000-0x901fffff]
[    0.159096] pci 0000:00:15.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.159140] pci_bus 0000:00: on NUMA node 0
[    0.159154] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.159505] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB6_._PRT]
[    0.159703] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.159829] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.SPB0._PRT]
[    0.159916] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.SPB1._PRT]
[    0.160284]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.160735]  pci0000:00: ACPI _OSC control (0x1d) granted
[    0.171000] ACPI: PCI Interrupt Link [LNKA] (IRQs 10 11) *0
[    0.171213] ACPI: PCI Interrupt Link [LNKB] (IRQs 10 11) *0
[    0.171392] ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11) *0
[    0.171564] ACPI: PCI Interrupt Link [LNKD] (IRQs 10 11) *0
[    0.171716] ACPI: PCI Interrupt Link [LNKE] (IRQs 10 11) *0
[    0.171845] ACPI: PCI Interrupt Link [LNKF] (IRQs 10 11) *0
[    0.171973] ACPI: PCI Interrupt Link [LNKG] (IRQs 10 11) *0
[    0.172112] ACPI: PCI Interrupt Link [LNKH] (IRQs 10 11) *0
[    0.172288] vgaarb: device added: PCI:0000:00:01.0,decodes=io+mem,owns=io+mem,locks=none
[    0.172316] vgaarb: loaded
[    0.172609] SCSI subsystem initialized
[    0.172678] libata version 3.00 loaded.
[    0.172678] usbcore: registered new interface driver usbfs
[    0.172678] usbcore: registered new interface driver hub
[    0.173036] usbcore: registered new device driver usb
[    0.173182] PCI: Using ACPI for IRQ routing
[    0.174516] PCI: pci_cache_line_size set to 64 bytes
[    0.174718] reserve RAM buffer: 000000000009d800 - 000000000009ffff 
[    0.174723] reserve RAM buffer: 0000000065f02000 - 0000000067ffffff 
[    0.174729] reserve RAM buffer: 0000000066e00000 - 0000000067ffffff 
[    0.174998] NetLabel: Initializing
[    0.175002] NetLabel:  domain hash size = 128
[    0.175005] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.175027] NetLabel:  unlabeled traffic allowed by default
[    0.175086] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.175094] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.177010] Switching to clocksource hpet
[    0.177661] Switched to NOHz mode on CPU #0
[    0.177847] Switched to NOHz mode on CPU #1
[    0.191451] pnp: PnP ACPI init
[    0.191488] ACPI: bus type pnp registered
[    0.192664] pnp 00:00: [bus 00-ff]
[    0.192670] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.192676] pnp 00:00: [mem 0x000c0000-0x000c1fff window]
[    0.192681] pnp 00:00: [mem 0x000c2000-0x000c3fff window]
[    0.192685] pnp 00:00: [mem 0x000c4000-0x000c5fff window]
[    0.192690] pnp 00:00: [mem 0x000c6000-0x000c7fff window]
[    0.192694] pnp 00:00: [mem 0x000c8000-0x000c9fff window]
[    0.192699] pnp 00:00: [mem 0x000ca000-0x000cbfff window]
[    0.192703] pnp 00:00: [mem 0x000cc000-0x000cdfff window]
[    0.192707] pnp 00:00: [mem 0x000ce000-0x000cffff window]
[    0.192712] pnp 00:00: [mem 0x000d0000-0x000d1fff window]
[    0.192716] pnp 00:00: [mem 0x000d2000-0x000d3fff window]
[    0.192720] pnp 00:00: [mem 0x000d4000-0x000d5fff window]
[    0.192724] pnp 00:00: [mem 0x000d6000-0x000d7fff window]
[    0.192729] pnp 00:00: [mem 0x000d8000-0x000d9fff window]
[    0.192736] pnp 00:00: [mem 0x000da000-0x000dbfff window]
[    0.192741] pnp 00:00: [mem 0x000dc000-0x000ddfff window]
[    0.192745] pnp 00:00: [mem 0x000de000-0x000dffff window]
[    0.192749] pnp 00:00: [mem 0x000e0000-0x000e1fff window]
[    0.192754] pnp 00:00: [mem 0x000e2000-0x000e3fff window]
[    0.192758] pnp 00:00: [mem 0x000e4000-0x000e5fff window]
[    0.192762] pnp 00:00: [mem 0x000e6000-0x000e7fff window]
[    0.192766] pnp 00:00: [mem 0x000e8000-0x000e9fff window]
[    0.192771] pnp 00:00: [mem 0x000ea000-0x000ebfff window]
[    0.192775] pnp 00:00: [mem 0x000ec000-0x000edfff window]
[    0.192779] pnp 00:00: [mem 0x000ee000-0x000effff window]
[    0.192783] pnp 00:00: [mem 0x7f000000-0xf7ffffff window]
[    0.192788] pnp 00:00: [mem 0xf8000000-0xffffffff window]
[    0.192793] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.192797] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.192802] pnp 00:00: [io  0x0d00-0xffff window]
[    0.192913] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.193030] pnp 00:01: [io  0x0f50-0x0f51]
[    0.193035] pnp 00:01: [mem 0xfec00000-0xfec00fff]
[    0.193040] pnp 00:01: [mem 0xfee00000-0xfee00fff]
[    0.193044] pnp 00:01: [mem 0xf8000000-0xf9ffffff]
[    0.193144] system 00:01: [io  0x0f50-0x0f51] has been reserved
[    0.193151] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.193157] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.193163] system 00:01: [mem 0xf8000000-0xf9ffffff] has been reserved
[    0.193170] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.193920] pnp 00:02: [io  0x0000-0x001f]
[    0.193925] pnp 00:02: [io  0x0081-0x008f]
[    0.193929] pnp 00:02: [io  0x00c0-0x00de]
[    0.193933] pnp 00:02: [io  0x040b]
[    0.193937] pnp 00:02: [io  0x04d6]
[    0.193942] pnp 00:02: [dma 4]
[    0.194027] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.194048] pnp 00:03: [io  0x00f0-0x00fe]
[    0.194069] pnp 00:03: [irq 13]
[    0.194133] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.194155] pnp 00:04: [io  0x0070-0x0071]
[    0.194211] pnp 00:04: [irq 8]
[    0.194275] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.194294] pnp 00:05: [io  0x0061]
[    0.194357] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.194378] pnp 00:06: [io  0x0060]
[    0.194382] pnp 00:06: [io  0x0064]
[    0.194392] pnp 00:06: [irq 1]
[    0.194461] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.194547] pnp 00:07: [irq 12]
[    0.194614] pnp 00:07: Plug and Play ACPI device, IDs LEN0017 PNP0f13 (active)
[    0.194644] pnp 00:08: [io  0x0022-0x0023]
[    0.194648] pnp 00:08: [io  0x002e-0x002f]
[    0.194652] pnp 00:08: [io  0x0072-0x0073]
[    0.194656] pnp 00:08: [io  0x0080]
[    0.194660] pnp 00:08: [io  0x0092]
[    0.194664] pnp 00:08: [io  0x00b0-0x00b1]
[    0.194667] pnp 00:08: [io  0x00b2]
[    0.194671] pnp 00:08: [io  0x00b8]
[    0.194675] pnp 00:08: [io  0x00bc]
[    0.194678] pnp 00:08: [io  0x00f0]
[    0.194682] pnp 00:08: [io  0x04d0-0x04d1]
[    0.194686] pnp 00:08: [io  0x0530-0x0537]
[    0.194690] pnp 00:08: [io  0x0800-0x0827]
[    0.194694] pnp 00:08: [io  0x0830]
[    0.194697] pnp 00:08: [io  0x0840-0x0847]
[    0.194701] pnp 00:08: [io  0x0b00-0x0b1f]
[    0.194705] pnp 00:08: [io  0x0b20-0x0b3f]
[    0.194709] pnp 00:08: [io  0x0c00-0x0c01]
[    0.194713] pnp 00:08: [io  0x0c14]
[    0.194717] pnp 00:08: [io  0x0c50-0x0c52]
[    0.194720] pnp 00:08: [io  0x0cd0-0x0cd1]
[    0.194724] pnp 00:08: [io  0x0cd2-0x0cd3]
[    0.194728] pnp 00:08: [io  0x0cd4-0x0cd5]
[    0.194732] pnp 00:08: [io  0x0cd6-0x0cd7]
[    0.194736] pnp 00:08: [io  0x0cd8-0x0cdf]
[    0.194740] pnp 00:08: [io  0x0cf9]
[    0.194744] pnp 00:08: [io  0x8100-0x81ff window]
[    0.194748] pnp 00:08: [io  0x8200-0x82ff window]
[    0.194910] system 00:08: [io  0x04d0-0x04d1] has been reserved
[    0.194916] system 00:08: [io  0x0530-0x0537] has been reserved
[    0.194921] system 00:08: [io  0x0800-0x0827] has been reserved
[    0.194926] system 00:08: [io  0x0830] has been reserved
[    0.194931] system 00:08: [io  0x0840-0x0847] has been reserved
[    0.194936] system 00:08: [io  0x0b00-0x0b1f] has been reserved
[    0.194941] system 00:08: [io  0x0b20-0x0b3f] has been reserved
[    0.194946] system 00:08: [io  0x0c00-0x0c01] has been reserved
[    0.194951] system 00:08: [io  0x0c14] has been reserved
[    0.194956] system 00:08: [io  0x0c50-0x0c52] has been reserved
[    0.194961] system 00:08: [io  0x0cd0-0x0cd1] has been reserved
[    0.194966] system 00:08: [io  0x0cd2-0x0cd3] has been reserved
[    0.194971] system 00:08: [io  0x0cd4-0x0cd5] has been reserved
[    0.194976] system 00:08: [io  0x0cd6-0x0cd7] has been reserved
[    0.194981] system 00:08: [io  0x0cd8-0x0cdf] has been reserved
[    0.194986] system 00:08: [io  0x0cf9] could not be reserved
[    0.194991] system 00:08: [io  0x8100-0x81ff window] has been reserved
[    0.194997] system 00:08: [io  0x8200-0x82ff window] has been reserved
[    0.195019] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.195139] pnp 00:09: [mem 0x000e0000-0x000fffff]
[    0.195147] pnp 00:09: [mem 0xffe00000-0xffffffff]
[    0.195152] pnp 00:09: [mem 0x00000000-0xffffffff disabled]
[    0.195157] pnp 00:09: [mem 0xfec10000-0xfec1001f]
[    0.195161] pnp 00:09: [mem 0xfed00000-0xfed003ff]
[    0.195165] pnp 00:09: [mem 0xfed61000-0xfed613ff]
[    0.195170] pnp 00:09: [mem 0xfed80000-0xfed80fff]
[    0.195278] system 00:09: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.195284] system 00:09: [mem 0xffe00000-0xffffffff] has been reserved
[    0.195289] system 00:09: [mem 0xfec10000-0xfec1001f] has been reserved
[    0.195295] system 00:09: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.195300] system 00:09: [mem 0xfed61000-0xfed613ff] has been reserved
[    0.195306] system 00:09: [mem 0xfed80000-0xfed80fff] has been reserved
[    0.195312] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.195839] pnp: PnP ACPI: found 10 devices
[    0.195847] ACPI: ACPI bus type pnp unregistered
[    0.234438] pci 0000:01:00.0: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]
[    0.234549] pci 0000:00:06.0: BAR 14: assigned [mem 0x7f000000-0x7f0fffff]
[    0.234568] pci 0000:00:15.1: BAR 15: assigned [mem 0x7f100000-0x7f2fffff 64bit pref]
[    0.234576] pci 0000:01:00.0: BAR 6: assigned [mem 0x90020000-0x9003ffff pref]
[    0.234582] pci 0000:00:06.0: PCI bridge to [bus 01-01]
[    0.234588] pci 0000:00:06.0:   bridge window [io  0x3000-0x3fff]
[    0.234595] pci 0000:00:06.0:   bridge window [mem 0x7f000000-0x7f0fffff]
[    0.234602] pci 0000:00:06.0:   bridge window [mem 0x90000000-0x900fffff 64bit pref]
[    0.234610] pci 0000:00:14.4: PCI bridge to [bus 02-02]
[    0.234614] pci 0000:00:14.4:   bridge window [io  disabled]
[    0.234668] pci 0000:00:14.4:   bridge window [mem disabled]
[    0.234674] pci 0000:00:14.4:   bridge window [mem pref disabled]
[    0.234685] pci 0000:00:15.0: PCI bridge to [bus 03-03]
[    0.234688] pci 0000:00:15.0:   bridge window [io  disabled]
[    0.234695] pci 0000:00:15.0:   bridge window [mem disabled]
[    0.234701] pci 0000:00:15.0:   bridge window [mem pref disabled]
[    0.234711] pci 0000:00:15.1: PCI bridge to [bus 04-04]
[    0.234717] pci 0000:00:15.1:   bridge window [io  0x2000-0x2fff]
[    0.234724] pci 0000:00:15.1:   bridge window [mem 0x90100000-0x901fffff]
[    0.234731] pci 0000:00:15.1:   bridge window [mem 0x7f100000-0x7f2fffff 64bit pref]
[    0.234764] pci 0000:00:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.234772] pci 0000:00:06.0: setting latency timer to 64
[    0.234793] pci 0000:00:15.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.234802] pci 0000:00:15.0: setting latency timer to 64
[    0.234813] pci 0000:00:15.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.234821] pci 0000:00:15.1: setting latency timer to 64
[    0.234827] pci_bus 0000:00: resource 4 [mem 0x000a0000-0x000bffff]
[    0.234832] pci_bus 0000:00: resource 5 [mem 0x000c0000-0x000c1fff]
[    0.234837] pci_bus 0000:00: resource 6 [mem 0x000c2000-0x000c3fff]
[    0.234841] pci_bus 0000:00: resource 7 [mem 0x000c4000-0x000c5fff]
[    0.234846] pci_bus 0000:00: resource 8 [mem 0x000c6000-0x000c7fff]
[    0.234850] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000c9fff]
[    0.234855] pci_bus 0000:00: resource 10 [mem 0x000ca000-0x000cbfff]
[    0.234859] pci_bus 0000:00: resource 11 [mem 0x000cc000-0x000cdfff]
[    0.234864] pci_bus 0000:00: resource 12 [mem 0x000d0000-0x000d1fff]
[    0.234868] pci_bus 0000:00: resource 13 [mem 0x000d2000-0x000d3fff]
[    0.234873] pci_bus 0000:00: resource 14 [mem 0x000d4000-0x000d5fff]
[    0.234877] pci_bus 0000:00: resource 15 [mem 0x000d6000-0x000d7fff]
[    0.234881] pci_bus 0000:00: resource 16 [mem 0x000d8000-0x000d9fff]
[    0.234886] pci_bus 0000:00: resource 17 [mem 0x000da000-0x000dbfff]
[    0.234890] pci_bus 0000:00: resource 18 [mem 0x000dc000-0x000ddfff]
[    0.234894] pci_bus 0000:00: resource 19 [mem 0x000de000-0x000dffff]
[    0.234899] pci_bus 0000:00: resource 20 [mem 0x000e0000-0x000e1fff]
[    0.234903] pci_bus 0000:00: resource 21 [mem 0x000e2000-0x000e3fff]
[    0.234907] pci_bus 0000:00: resource 22 [mem 0x000e4000-0x000e5fff]
[    0.234912] pci_bus 0000:00: resource 23 [mem 0x000e6000-0x000e7fff]
[    0.234916] pci_bus 0000:00: resource 24 [mem 0x000e8000-0x000e9fff]
[    0.234920] pci_bus 0000:00: resource 25 [mem 0x000ea000-0x000ebfff]
[    0.234925] pci_bus 0000:00: resource 26 [mem 0x000ec000-0x000edfff]
[    0.234929] pci_bus 0000:00: resource 27 [mem 0x000ee000-0x000effff]
[    0.234934] pci_bus 0000:00: resource 28 [mem 0x7f000000-0xf7ffffff]
[    0.234938] pci_bus 0000:00: resource 29 [mem 0xf8000000-0xffffffff]
[    0.234943] pci_bus 0000:00: resource 30 [io  0x0000-0x0cf7]
[    0.234947] pci_bus 0000:00: resource 31 [io  0x0d00-0xffff]
[    0.234952] pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
[    0.234956] pci_bus 0000:01: resource 1 [mem 0x7f000000-0x7f0fffff]
[    0.234960] pci_bus 0000:01: resource 2 [mem 0x90000000-0x900fffff 64bit pref]
[    0.234965] pci_bus 0000:02: resource 4 [mem 0x000a0000-0x000bffff]
[    0.234970] pci_bus 0000:02: resource 5 [mem 0x000c0000-0x000c1fff]
[    0.234974] pci_bus 0000:02: resource 6 [mem 0x000c2000-0x000c3fff]
[    0.234978] pci_bus 0000:02: resource 7 [mem 0x000c4000-0x000c5fff]
[    0.234983] pci_bus 0000:02: resource 8 [mem 0x000c6000-0x000c7fff]
[    0.234987] pci_bus 0000:02: resource 9 [mem 0x000c8000-0x000c9fff]
[    0.234991] pci_bus 0000:02: resource 10 [mem 0x000ca000-0x000cbfff]
[    0.234996] pci_bus 0000:02: resource 11 [mem 0x000cc000-0x000cdfff]
[    0.235000] pci_bus 0000:02: resource 12 [mem 0x000d0000-0x000d1fff]
[    0.235018] pci_bus 0000:02: resource 13 [mem 0x000d2000-0x000d3fff]
[    0.235022] pci_bus 0000:02: resource 14 [mem 0x000d4000-0x000d5fff]
[    0.235026] pci_bus 0000:02: resource 15 [mem 0x000d6000-0x000d7fff]
[    0.235031] pci_bus 0000:02: resource 16 [mem 0x000d8000-0x000d9fff]
[    0.235036] pci_bus 0000:02: resource 17 [mem 0x000da000-0x000dbfff]
[    0.235040] pci_bus 0000:02: resource 18 [mem 0x000dc000-0x000ddfff]
[    0.235044] pci_bus 0000:02: resource 19 [mem 0x000de000-0x000dffff]
[    0.235049] pci_bus 0000:02: resource 20 [mem 0x000e0000-0x000e1fff]
[    0.235053] pci_bus 0000:02: resource 21 [mem 0x000e2000-0x000e3fff]
[    0.235057] pci_bus 0000:02: resource 22 [mem 0x000e4000-0x000e5fff]
[    0.235062] pci_bus 0000:02: resource 23 [mem 0x000e6000-0x000e7fff]
[    0.235066] pci_bus 0000:02: resource 24 [mem 0x000e8000-0x000e9fff]
[    0.235070] pci_bus 0000:02: resource 25 [mem 0x000ea000-0x000ebfff]
[    0.235075] pci_bus 0000:02: resource 26 [mem 0x000ec000-0x000edfff]
[    0.235079] pci_bus 0000:02: resource 27 [mem 0x000ee000-0x000effff]
[    0.235083] pci_bus 0000:02: resource 28 [mem 0x7f000000-0xf7ffffff]
[    0.235088] pci_bus 0000:02: resource 29 [mem 0xf8000000-0xffffffff]
[    0.235092] pci_bus 0000:02: resource 30 [io  0x0000-0x0cf7]
[    0.235097] pci_bus 0000:02: resource 31 [io  0x0d00-0xffff]
[    0.235101] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
[    0.235106] pci_bus 0000:04: resource 1 [mem 0x90100000-0x901fffff]
[    0.235110] pci_bus 0000:04: resource 2 [mem 0x7f100000-0x7f2fffff 64bit pref]
[    0.235308] NET: Registered protocol family 2
[    0.235520] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.235918] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.236644] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.236979] TCP: Hash tables configured (established 131072 bind 65536)
[    0.236983] TCP reno registered
[    0.236992] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.237047] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.237706] NET: Registered protocol family 1
[    0.237733] pci 0000:00:01.0: Boot video device
[    0.260402] PCI: CLS 32 bytes, default 64
[    0.260531] Trying to unpack rootfs image as initramfs...
[    0.980693] Freeing initrd memory: 14696k freed
[    0.991191] apm: BIOS not found.
[    0.991511] audit: initializing netlink socket (disabled)
[    0.991533] type=2000 audit(1304270119.990:1): initialized
[    1.047283] highmem bounce pool size: 64 pages
[    1.047295] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.051578] VFS: Disk quotas dquot_6.5.2
[    1.052096] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.054064] msgmni has been set to 1703
[    1.054286] SELinux:  Registering netfilter hooks
[    1.055375] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.055384] io scheduler noop registered
[    1.055388] io scheduler deadline registered
[    1.055420] io scheduler cfq registered (default)
[    1.055627] pcieport 0000:00:06.0: setting latency timer to 64
[    1.055689] pcieport 0000:00:06.0: irq 40 for MSI/MSI-X
[    1.055837] pcieport 0000:00:15.0: setting latency timer to 64
[    1.055903] pcieport 0000:00:15.0: irq 41 for MSI/MSI-X
[    1.056031] pcieport 0000:00:15.1: setting latency timer to 64
[    1.056097] pcieport 0000:00:15.1: irq 42 for MSI/MSI-X
[    1.056316] pcieport 0000:00:06.0: Signaling PME through PCIe PME interrupt
[    1.056322] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    1.056329] pcie_pme 0000:00:06.0:pcie01: service driver pcie_pme loaded
[    1.056405] pcieport 0000:00:15.0: Signaling PME through PCIe PME interrupt
[    1.056413] pcie_pme 0000:00:15.0:pcie01: service driver pcie_pme loaded
[    1.056446] pcieport 0000:00:15.1: Signaling PME through PCIe PME interrupt
[    1.056451] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
[    1.056458] pcie_pme 0000:00:15.1:pcie01: service driver pcie_pme loaded
[    1.058188] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    1.058621] ACPI: AC Adapter [ACAD] (on-line)
[    1.059068] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    1.059078] ACPI: Power Button [PWRB]
[    1.059275] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    1.059282] ACPI: Sleep Button [SLPB]
[    1.059420] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
[    1.059766] ACPI: Lid Switch [LID]
[    1.059870] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    1.059877] ACPI: Power Button [PWRF]
[    1.060297] ACPI: acpi_idle registered with cpuidle
[    1.065312] thermal LNXTHERM:00: registered as thermal_zone0
[    1.065320] ACPI: Thermal Zone [THZ0] (66 C)
[    1.065369] ERST: Table is not found!
[    1.065407] isapnp: Scanning for PnP cards...
[    1.097293] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    1.097308] ACPI: Battery Slot [BAT1] (battery present)
[    1.461469] isapnp: No Plug & Play device found
[    1.461612] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.464789] Non-volatile memory driver v1.3
[    1.464796] Linux agpgart interface v0.103
[    1.469893] brd: module loaded
[    1.472362] loop: module loaded
[    1.472503] ahci 0000:00:11.0: version 3.0
[    1.472582] ahci 0000:00:11.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.472687] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 1 ports 3 Gbps 0x1 impl SATA mode
[    1.472694] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio ccc 
[    1.473309] scsi0 : ahci
[    1.473688] ata1: SATA max UDMA/133 abar m1024@0x9024a000 port 0x9024a100 irq 19
[    1.473849] Fixed MDIO Bus: probed
[    1.473989] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.474125] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.474159] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    1.474355] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    1.474457] ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.474497] QUIRK: Enable AMD PLL fix
[    1.474564] ehci_hcd 0000:00:12.2: debug port 1
[    1.474598] ehci_hcd 0000:00:12.2: irq 17, io mem 0x9024a500
[    1.480091] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    1.480162] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.480168] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.480173] usb usb1: Product: EHCI Host Controller
[    1.480176] usb usb1: Manufacturer: Linux 2.6.39-rc5 ehci_hcd
[    1.480180] usb usb1: SerialNumber: 0000:00:12.2
[    1.480424] hub 1-0:1.0: USB hub found
[    1.480435] hub 1-0:1.0: 5 ports detected
[    1.480669] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.480697] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    1.480784] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    1.481392] ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.481454] ehci_hcd 0000:00:13.2: debug port 1
[    1.481481] ehci_hcd 0000:00:13.2: irq 17, io mem 0x9024a400
[    1.487306] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    1.487365] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.487370] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.487375] usb usb2: Product: EHCI Host Controller
[    1.487379] usb usb2: Manufacturer: Linux 2.6.39-rc5 ehci_hcd
[    1.487382] usb usb2: SerialNumber: 0000:00:13.2
[    1.487649] hub 2-0:1.0: USB hub found
[    1.487659] hub 2-0:1.0: 5 ports detected
[    1.487859] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.487939] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.487974] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    1.488088] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
[    1.489448] ohci_hcd 0000:00:12.0: irq 18, io mem 0x90249000
[    1.544279] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.544288] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.544293] usb usb3: Product: OHCI Host Controller
[    1.544297] usb usb3: Manufacturer: Linux 2.6.39-rc5 ohci_hcd
[    1.544300] usb usb3: SerialNumber: 0000:00:12.0
[    1.544559] hub 3-0:1.0: USB hub found
[    1.544618] hub 3-0:1.0: 5 ports detected
[    1.544869] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.544904] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    1.544993] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 4
[    1.545212] ohci_hcd 0000:00:13.0: irq 18, io mem 0x90248000
[    1.600357] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.600365] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.600370] usb usb4: Product: OHCI Host Controller
[    1.600374] usb usb4: Manufacturer: Linux 2.6.39-rc5 ohci_hcd
[    1.600378] usb usb4: SerialNumber: 0000:00:13.0
[    1.600647] hub 4-0:1.0: USB hub found
[    1.600705] hub 4-0:1.0: 5 ports detected
[    1.600902] uhci_hcd: USB Universal Host Controller Interface driver
[    1.601119] i8042: PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
[    1.603529] i8042: Detected active multiplexing controller, rev 1.1
[    1.606762] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.606776] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.606831] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.606877] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.606926] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.607157] mousedev: PS/2 mouse device common for all mice
[    1.607969] rtc_cmos 00:04: RTC can wake from S4
[    1.608226] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    1.608294] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
[    1.608501] device-mapper: uevent: version 1.0.3
[    1.608709] device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised: dm-devel@redhat.com
[    1.608955] cpuidle: using governor ladder
[    1.609155] cpuidle: using governor menu
[    1.609159] EFI Variables Facility v0.08 2004-May-17
[    1.609471] usbcore: registered new interface driver usbhid
[    1.609474] usbhid: USB HID core driver
[    1.609550] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    1.610097] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.610162] TCP cubic registered
[    1.610165] Initializing XFRM netlink socket
[    1.610182] NET: Registered protocol family 17
[    1.610212] Registering the dns_resolver key type
[    1.610246] Using IPI No-Shortcut mode
[    1.610452] PM: Hibernation image not present or could not be loaded.
[    1.610478] registered taskstats version 1
[    1.610552] IMA: No TPM chip found, activating TPM-bypass!
[    1.611302]   Magic number: 11:589:288
[    1.611354] tty tty21: hash matches
[    1.611495] rtc_cmos 00:04: setting system clock to 2011-05-01 17:15:22 UTC (1304270122)
[    1.611570] Initializing network drop monitor service
[    1.644620] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    1.789127] usb 2-2: new high speed USB device number 2 using ehci_hcd
[    1.916736] usb 2-2: New USB device found, idVendor=0bda, idProduct=0158
[    1.916750] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.916759] usb 2-2: Product: USB2.0-CRW
[    1.916767] usb 2-2: Manufacturer: Generic
[    1.916774] usb 2-2: SerialNumber: 20071114173400000
[    1.933192] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.933697] ata1.00: ATA-8: INTEL SSDSA2CW080G3, 4PC10302, max UDMA/133
[    1.933705] ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.934173] ata1.00: configured for UDMA/133
[    1.934803] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2CW08 4PC1 PQ: 0 ANSI: 5
[    1.935321] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.935341] sd 0:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
[    1.935608] sd 0:0:0:0: [sda] Write Protect is off
[    1.935614] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.935930] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.937080]  sda: sda1 sda2 sda3
[    1.938004] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.938219] Freeing unused kernel memory: 564k freed
[    1.938775] Write protecting the kernel text: 3912k
[    1.938890] Write protecting the kernel read-only data: 1836k
[    1.978957] dracut: dracut-006-6.fc14
[    1.992044] Refined TSC clocksource calibration: 1596.599 MHz.
[    1.992053] Switching to clocksource tsc
[    1.995661] dracut: rd_NO_LUKS: removing cryptoluks activation
[    2.006713] udev[63]: starting version 161
[    2.023100] usb 2-5: new high speed USB device number 3 using ehci_hcd
[    2.138363] [drm] Initialized drm 1.1.0 20060810
[    2.144430] usb 2-5: New USB device found, idVendor=5986, idProduct=01a7
[    2.144438] usb 2-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.144443] usb 2-5: Product: Integrated Camera
[    2.144447] usb 2-5: Manufacturer: Image Processor
[    2.144451] usb 2-5: SerialNumber: Integrated Camera
[    2.267026] [drm] radeon defaulting to kernel modesetting.
[    2.267033] [drm] radeon kernel modesetting enabled.
[    2.267116] radeon 0000:00:01.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.267126] radeon 0000:00:01.0: setting latency timer to 64
[    2.267459] [drm] initializing kernel modesetting (PALM 0x1002:0x9802).
[    2.267534] [drm] register mmio base: 0x90200000
[    2.267538] [drm] register mmio size: 262144
[    2.267754] ATOM BIOS: Lenovo
[    2.267802] radeon 0000:00:01.0: VRAM: 384M 0x0000000000000000 - 0x0000000017FFFFFF (384M used)
[    2.267808] radeon 0000:00:01.0: GTT: 512M 0x0000000018000000 - 0x0000000037FFFFFF
[    2.267821] mtrr: no more MTRRs available
[    2.267825] [drm] Detected VRAM RAM=384M, BAR=256M
[    2.267828] [drm] RAM width 16bits DDR
[    2.268255] [TTM] Zone  kernel: Available graphics memory: 436274 kiB.
[    2.268262] [TTM] Zone highmem: Available graphics memory: 825942 kiB.
[    2.268266] [TTM] Initializing pool allocator.
[    2.268332] [drm] radeon: 384M of VRAM memory ready
[    2.268337] [drm] radeon: 512M of GTT memory ready.
[    2.268372] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    2.268376] [drm] Driver supports precise vblank timestamp query.
[    2.268427] radeon 0000:00:01.0: irq 43 for MSI/MSI-X
[    2.268436] radeon 0000:00:01.0: radeon: using MSI.
[    2.268486] [drm] radeon: irq initialized.
[    2.268495] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    2.269697] [drm] Loading PALM Microcode
[    2.284754] radeon 0000:00:01.0: WB enabled
[    2.301536] [drm] ring test succeeded in 1 usecs
[    2.301866] [drm] radeon: ib pool ready.
[    2.302396] [drm] ib test succeeded in 0 usecs
[    2.303205] [drm] Radeon Display Connectors
[    2.303209] [drm] Connector 0:
[    2.303212] [drm]   LVDS
[    2.303214] [drm]   HPD1
[    2.303219] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438 0x643c 0x643c
[    2.303222] [drm]   Encoders:
[    2.303225] [drm]     LCD1: INTERNAL_UNIPHY
[    2.303228] [drm] Connector 1:
[    2.303231] [drm]   HDMI-A
[    2.303233] [drm]   HPD2
[    2.303237] [drm]   DDC: 0x6440 0x6440 0x6444 0x6444 0x6448 0x6448 0x644c 0x644c
[    2.303240] [drm]   Encoders:
[    2.303242] [drm]     DFP1: INTERNAL_UNIPHY
[    2.303245] [drm] Connector 2:
[    2.303247] [drm]   VGA
[    2.303251] [drm]   DDC: 0x64d8 0x64d8 0x64dc 0x64dc 0x64e0 0x64e0 0x64e4 0x64e4
[    2.303254] [drm]   Encoders:
[    2.303257] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    2.384722] [drm] Internal thermal controller without fan control
[    2.384814] [drm] radeon: power management initialized
[    2.651613] Synaptics Touchpad, model: 1, fw: 7.5, id: 0x1e0b1, caps: 0xd000b3/0x340000/0xa0400
[    2.651636] serio: Synaptics pass-through port at isa0060/serio4/input0
[    2.690907] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input5
[    2.841748] [drm] fb mappable at 0x80141000
[    2.841754] [drm] vram apper at 0x80000000
[    2.841757] [drm] size 4325376
[    2.841760] [drm] fb depth is 24
[    2.841763] [drm]    pitch is 5632
[    2.841915] fbcon: radeondrmfb (fb0) is primary device
[    3.365444] Console: switching to colour frame buffer device 170x48
[    3.373242] fb0: radeondrmfb frame buffer device
[    3.373246] drm: registered panic notifier
[    3.373277] [drm] Initialized radeon 2.9.0 20080528 for 0000:00:01.0 on minor 0
[    3.415299] dracut: Starting plymouth daemon
[    3.856756] Initializing USB Mass Storage driver...
[    3.857825] scsi1 : usb-storage 2-2:1.0
[    3.862966] usbcore: registered new interface driver usb-storage
[    3.862973] USB Mass Storage support registered.
[    3.958451] EXT4-fs (sda3): INFO: recovery required on readonly filesystem
[    3.958460] EXT4-fs (sda3): write access will be enabled during recovery
[    3.996026] EXT4-fs (sda3): recovery complete
[    3.996441] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
[    4.008824] dracut: Remounting /dev/disk/by-uuid/5dc7080b-9a2a-443d-8860-12f951845d5a with -o noatime,discard,ro
[    4.035149] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: discard
[    4.038132] dracut: Mounted root filesystem /dev/sda3
[    4.087272] dracut: Loading SELinux policy
[    4.131725] type=1404 audit(1304270125.019:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[    4.173466] SELinux: 2048 avtab hash slots, 215688 rules.
[    4.287620] SELinux: 2048 avtab hash slots, 215688 rules.
[    4.866643] scsi 1:0:0:0: Direct-Access     Generic- Multi-Card       1.00 PQ: 0 ANSI: 0 CCS
[    4.870831] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    4.874610] sd 1:0:0:0: [sdb] Attached SCSI removable disk
[    5.070469] SELinux:  9 users, 14 roles, 3521 types, 184 bools, 1 sens, 1024 cats
[    5.070478] SELinux:  81 classes, 215688 rules
[    5.081517] SELinux:  Permission read_policy in class security not defined in policy.
[    5.081776] SELinux:  Permission syslog in class capability2 not defined in policy.
[    5.081788] SELinux: the above unknown classes and permissions will be allowed
[    5.081804] SELinux:  Completing initialization.
[    5.081807] SELinux:  Setting up existing superblocks.
[    5.081823] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    5.081835] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[    5.082045] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    5.082058] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    5.082075] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    5.082120] SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
[    5.083325] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    5.083337] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[    5.084856] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    5.084874] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[    5.084884] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[    5.084929] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    5.084942] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[    5.084961] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[    5.084990] SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
[    5.085028] SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
[    5.085040] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    5.085743] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    5.085782] SELinux: initialized (dev sda3, type ext4), uses xattr
[    5.090300] type=1403 audit(1304270125.978:3): policy loaded auid=4294967295 ses=4294967295
[    5.744214] dracut: Switching root
[    6.873461] udev[301]: starting version 161
[    7.209560] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[    7.211284] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[    7.224596] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    7.224648] r8169 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    7.224705] r8169 0000:01:00.0: setting latency timer to 64
[    7.224769] r8169 0000:01:00.0: irq 44 for MSI/MSI-X
[    7.224985] r8169 0000:01:00.0: eth0: RTL8168d/8111d at 0xf9f08000, 60:eb:69:f0:33:cb, XID 083000c0 IRQ 44
[    7.228552] acpi device:34: registered as cooling_device2
[    7.228746] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input6
[    7.228878] ACPI: Video Device [VGA1] (multi-head: yes  rom: no  post: no)
[    7.345461] input: PC Speaker as /devices/platform/pcspkr/input/input7
[    7.618684] microcode: CPU0: patch_level=0x05000028
[    7.744915] Linux video capture interface: v2.00
[    7.846171] microcode: CPU1: patch_level=0x05000028
[    7.867523] uvcvideo: Found UVC 1.00 device Integrated Camera (5986:01a7)
[    7.869788] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    7.892332] input: Integrated Camera as /devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.0/input/input8
[    7.893464] usbcore: registered new interface driver uvcvideo
[    7.893471] USB Video Class driver (v1.0.0)
[    8.010873] cfg80211: Calling CRDA to update world regulatory domain
[    8.059258] HDA Intel 0000:00:01.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    8.059381] HDA Intel 0000:00:01.1: irq 45 for MSI/MSI-X
[    8.059462] HDA Intel 0000:00:01.1: setting latency timer to 64
[    8.114897] cfg80211: World regulatory domain updated:
[    8.114906] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    8.114912] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.114918] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    8.114923] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    8.114927] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.114932] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.142999] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    8.214845] microcode: AMD microcode update via /dev/cpu/microcode not supported
[    8.272039] microcode: AMD microcode update via /dev/cpu/microcode not supported
[    8.283693] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    8.290378] microcode: AMD microcode update via /dev/cpu/microcode not supported
[    8.302000] microcode: AMD microcode update via /dev/cpu/microcode not supported
[    8.337845] microcode: AMD microcode update via /dev/cpu/microcode not supported
[    8.362460] IPv4 FIB: Using LC-trie version 0.409
[    8.420161] rtl8192ce 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    8.420176] rtl8192ce 0000:04:00.0: setting latency timer to 64
[    8.436143] cfg80211: Calling CRDA for country: EC
[    8.447106] cfg80211: Regulatory domain changed to country: EC
[    8.447113] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    8.447119] cfg80211:     (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[    8.447124] cfg80211:     (5170000 KHz - 5250000 KHz @ 20000 KHz), (300 mBi, 1700 mBm)
[    8.447129] cfg80211:     (5250000 KHz - 5330000 KHz @ 20000 KHz), (300 mBi, 2300 mBm)
[    8.447134] cfg80211:     (5735000 KHz - 5835000 KHz @ 20000 KHz), (300 mBi, 3000 mBm)
[    8.478253] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[    8.478634] rtlwifi: wireless switch is off
[    8.505729] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio4/serio5/input/input9
[    8.555345] cfg80211: Calling CRDA for country: US
[    8.567178] cfg80211: Regulatory domain changed to country: US
[    8.567186] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    8.567192] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[    8.567197] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[    8.567202] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.567207] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.567211] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.567216] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[    9.372588] EXT4-fs (sda3): re-mounted. Opts: discard
[    9.919473] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    9.919738] SELinux: initialized (dev sda1, type ext4), uses xattr
[    9.942420] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   11.446722] Adding 2097148k swap on /dev/sda2.  Priority:-1 extents:1 across:2097148k SS
[   11.457686] SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
[   11.820625] NET: Registered protocol family 10
[   11.837264] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   12.214526] powernow-k8: Found 1 AMD E-350 Processor (2 cpu cores) (version 2.20.00)
[   12.214622] powernow-k8:    0 : pstate 0 (1600 MHz)
[   12.214627] powernow-k8:    1 : pstate 1 (1280 MHz)
[   12.214630] powernow-k8:    2 : pstate 2 (800 MHz)
[   12.760581] tun: Universal TUN/TAP device driver, 1.6
[   12.760589] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   13.013896] r8169 0000:01:00.0: eth0: link down
[   13.014231] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   13.022262] rtl8192cu: Loading firmware file rtlwifi/rtl8192cfw.bin
[   13.386904] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   18.687389] hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
[   25.685782] fuse init (API version 7.16)
[   25.712423] SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
[   25.767747] SELinux: initialized (dev fusectl, type fusectl), uses genfs_contexts
[   30.370071] wlan0: deauthenticating from 30:46:9a:99:c5:80 by local choice (reason=3)
[   30.590272] wlan0: authenticate with 30:46:9a:99:c5:80 (try 1)
[   30.599276] wlan0: authenticated
[   30.619864] wlan0: associate with 30:46:9a:99:c5:80 (try 1)
[   30.623540] wlan0: RX AssocResp from 30:46:9a:99:c5:80 (capab=0x411 status=0 aid=2)
[   30.623549] wlan0: associated
[   30.635782] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   30.724267] padlock_aes: VIA PadLock not detected.
[   41.602113] wlan0: no IPv6 routers present

--=-=-=
Content-Type: text/plain


-- 
Shawn Nock (OpenPGP: 0x8132E623)

--=-=-=--
