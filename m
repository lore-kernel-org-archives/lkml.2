Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab0HOQpY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 12:45:24 -0400
Received: from www17.your-server.de ([213.133.104.17]:59854 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932579Ab0HOQpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 12:45:19 -0400
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.35-07956-g92fa5bd9: BUG: scheduling while atomic
Date: Sun, 15 Aug 2010 13:43:55 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-07956-g92fa5bd9; KDE/4.4.5; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008151343.55693.thomas@m3y3r.de>
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

My kernel log has some "BUG: scheduling while atomic: ??" entries:

E.g.:

[65120.500387] BUG: scheduling while atomic: sh/13475/0x10000001
[65120.500392] Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput snd_hda_codec_intelhdmi arc4 snd_hda_codec_realtek ecb iwlagn snd_hda_intel iwlcore snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm mac80211 snd_timer snd soundcore cfg80211 rfkill iTCO_wdt snd_page_alloc uvcvideo iTCO_vendor_support wmi serio_raw videodev i2c_i801 joydev v4l1_compat pcspkr sha256_generic aes_i586 aes_generic cbc dm_crypt [last unloaded: scsi_wait_scan]
[65120.500437] Pid: 13475, comm: sh Tainted: G      D   I 2.6.35-07956-g92fa5bd9 #164
[65120.500441] Call Trace:
[65120.500449]  [<c085306b>] ? schedule+0x30b/0x4c0
[65120.500455]  [<c048c7a1>] ? generic_file_aio_read+0x5d1/0x710
[65120.500459]  [<c0853329>] ? _cond_resched+0x29/0x40
[65120.500466]  [<c04a77b4>] ? anon_vma_prepare+0x14/0xd0
[65120.500470]  [<c04a3bac>] ? expand_downwards+0x1c/0x150
[65120.500476]  [<c0423c8b>] ? pte_alloc_one+0x1b/0x40
[65120.500480]  [<c04a0ef7>] ? handle_mm_fault+0x957/0x9a0
[65120.500485]  [<c049e63d>] ? follow_page+0x6d/0x290
[65120.500489]  [<c04a1059>] ? __get_user_pages+0x119/0x3d0
[65120.500494]  [<c04c58cd>] ? get_arg_page+0x4d/0xb0
[65120.500500]  [<c0604d53>] ? strnlen_user+0x23/0x50
[65120.500504]  [<c04c59fc>] ? copy_strings+0xcc/0x190
[65120.500508]  [<c04c5ae1>] ? copy_strings_kernel+0x21/0x40
[65120.500512]  [<c04c6f01>] ? do_execve+0x181/0x250
[65120.500518]  [<c0408343>] ? sys_execve+0x33/0x70
[65120.500522]  [<c0402e0e>] ? ptregs_execve+0x12/0x18
[65120.500526]  [<c0402d53>] ? sysenter_do_call+0x12/0x22

Full kernel log:
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.35-07956-g92fa5bd9 (thomas@localhost.localdomain) (gcc version 4.4.4 20100630 (Red Hat 4.4.4-10) (GCC) ) #164 Sat Aug 14 19:24:20 CEST 2010
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e000 (usable)
[    0.000000]  BIOS-e820: 000000000009e000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007ba63000 (usable)
[    0.000000]  BIOS-e820: 000000007ba63000 - 000000007babf000 (reserved)
[    0.000000]  BIOS-e820: 000000007babf000 - 000000007bb80000 (usable)
[    0.000000]  BIOS-e820: 000000007bb80000 - 000000007bbbf000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007bbbf000 - 000000007bbe0000 (usable)
[    0.000000]  BIOS-e820: 000000007bbe0000 - 000000007bbf7000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007bbf7000 - 000000007bc00000 (usable)
[    0.000000]  BIOS-e820: 000000007bc00000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] DMI 2.6 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x7bc00 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 base 0FFE00000 mask FFFE00000 write-protect
[    0.000000]   2 base 040000000 mask FC0000000 write-back
[    0.000000]   3 base 07C000000 mask FFC000000 uncachable
[    0.000000]   4 base 07BC00000 mask FFFC00000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped : 0 - 01000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-c000
[    0.000000] RAMDISK: 3794b000 - 37ff0000
[    0.000000] Allocated new RAMDISK: 00b52000 - 011f6f81
[    0.000000] Move RAMDISK from 000000003794b000 - 0000000037feff80 to 00b52000 - 011f6f80
[    0.000000] ACPI: RSDP 000fe020 00024 (v02 ACRSYS)
[    0.000000] ACPI: XSDT 7bbf6120 0007C (v01 ACRSYS ACRPRDCT 00000001      01000013)
[    0.000000] ACPI: FACP 7bbf4000 000F4 (v04 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: DSDT 7bbe8000 073EA (v01 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: FACS 7bb8d000 00040
[    0.000000] ACPI: DMAR 7bbf5000 00068 (v01               ? 00000001      00000000)
[    0.000000] ACPI: HPET 7bbf3000 00038 (v01 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: APIC 7bbf2000 0006C (v02 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: MCFG 7bbf1000 0003C (v01 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: ASF! 7bbf0000 000A5 (v32 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: SLIC 7bbe7000 00176 (v01 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: BOOT 7bbe6000 00028 (v01 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: SSDT 7bbe2000 00223 (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 7bbe1000 00537 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.000000] ACPI: SSDT 7bbe0000 00655 (v01  PmRef    CpuPm 00003000 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1092MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0007bc00
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[5] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x0007ba63
[    0.000000]     0: 0x0007babf -> 0x0007bb80
[    0.000000]     0: 0x0007bbbf -> 0x0007bbe0
[    0.000000]     0: 0x0007bbf7 -> 0x0007bc00
[    0.000000] On node 0 totalpages: 506603
[    0.000000] free_area_init_node: node 0, pgdat c0a2f960, node_mem_map c11f8020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3965 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2185 pages used for memmap
[    0.000000]   HighMem zone: 277191 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x00] disabled)
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
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [5000 - 57ff]
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:78000000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 502642
[    0.000000] Kernel command line: ro root=UUID=5764c1f2-f119-4f97-b8e2-d827b8655edb LANG=de_DE.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=de-latin1-nodeadkeys rhgb quiet kgdboc=kms,kbd resume=/dev/mapper/luks-swap
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] allocated 10137580 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at drivers/pci/dmar.c:633 warn_invalid_dmar+0x9a/0xb0()
[    0.000000] Hardware name: Aspire 1810T
[    0.000000] Your BIOS is broken; DMAR reported at address 0!
[    0.000000] BIOS vendor: INSYDE; Ver: v1.3310; Product Version: v1.3310
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.35-07956-g92fa5bd9 #164
[    0.000000] Call Trace:
[    0.000000]  [<c042c508>] ? warn_slowpath_common+0x78/0xb0
[    0.000000]  [<c062840a>] ? warn_invalid_dmar+0x9a/0xb0
[    0.000000]  [<c062840a>] ? warn_invalid_dmar+0x9a/0xb0
[    0.000000]  [<c042c593>] ? warn_slowpath_fmt_taint+0x33/0x40
[    0.000000]  [<c062840a>] ? warn_invalid_dmar+0x9a/0xb0
[    0.000000]  [<c0a55049>] ? check_zero_address+0x51/0x131
[    0.000000]  [<c06609f4>] ? acpi_tb_verify_table+0x1d/0x46
[    0.000000]  [<c0660431>] ? acpi_get_table_with_size+0x48/0x98
[    0.000000]  [<c0a55137>] ? detect_intel_iommu+0xe/0x65
[    0.000000]  [<c0a45ad5>] ? mem_init+0xc/0x283
[    0.000000]  [<c0a4b6a2>] ? __alloc_bootmem_node_nopanic+0x71/0xa3
[    0.000000]  [<c0852c0e>] ? printk+0x27/0x31
[    0.000000]  [<c0a4db94>] ? page_cgroup_init_flatmem+0x99/0xdc
[    0.000000]  [<c0a35647>] ? start_kernel+0x190/0x314
[    0.000000]  [<c0a352f5>] ? unknown_bootoption+0x0/0x190
[    0.000000]  [<c0a350ac>] ? i386_start_kernel+0xac/0xb7
[    0.000000] ---[ end trace a7919e7f17c0a725 ]---
[    0.000000] Disabling lock debugging due to kernel taint
[    0.000000] Subtract (46 early reservations)
[    0.000000]   #1 [0000400000 - 0000b4cf98]   TEXT DATA BSS
[    0.000000]   #2 [000009e000 - 0000100000]   BIOS reserved
[    0.000000]   #3 [0000b4d000 - 0000b51258]             BRK
[    0.000000]   #4 [0000001000 - 0000005000]     ACPI WAKEUP
[    0.000000]   #5 [0000007000 - 0000008000]         PGTABLE
[    0.000000]   #6 [0000b52000 - 00011f7000]     NEW RAMDISK
[    0.000000]   #7 [00011f7000 - 00011f8000]         BOOTMEM
[    0.000000]   #8 [00011f8000 - 0002170000]         BOOTMEM
[    0.000000]   #9 [0002170000 - 0002170004]         BOOTMEM
[    0.000000]   #10 [0002170040 - 00021700c0]         BOOTMEM
[    0.000000]   #11 [00021700c0 - 0002170114]         BOOTMEM
[    0.000000]   #12 [0002170140 - 0002172140]         BOOTMEM
[    0.000000]   #13 [0002172140 - 00021721a8]         BOOTMEM
[    0.000000]   #14 [00021721c0 - 00021761c0]         BOOTMEM
[    0.000000]   #15 [00021761c0 - 00021761e5]         BOOTMEM
[    0.000000]   #16 [0002176200 - 0002176227]         BOOTMEM
[    0.000000]   #17 [0002176240 - 0002176454]         BOOTMEM
[    0.000000]   #18 [0002176480 - 00021764c0]         BOOTMEM
[    0.000000]   #19 [00021764c0 - 0002176500]         BOOTMEM
[    0.000000]   #20 [0002176500 - 0002176540]         BOOTMEM
[    0.000000]   #21 [0002176540 - 0002176580]         BOOTMEM
[    0.000000]   #22 [0002176580 - 00021765c0]         BOOTMEM
[    0.000000]   #23 [00021765c0 - 0002176600]         BOOTMEM
[    0.000000]   #24 [0002176600 - 0002176640]         BOOTMEM
[    0.000000]   #25 [0002176640 - 0002176680]         BOOTMEM
[    0.000000]   #26 [0002176680 - 00021766c0]         BOOTMEM
[    0.000000]   #27 [00021766c0 - 0002176700]         BOOTMEM
[    0.000000]   #28 [0002176700 - 0002176740]         BOOTMEM
[    0.000000]   #29 [0002176740 - 0002176780]         BOOTMEM
[    0.000000]   #30 [0002176780 - 00021767c0]         BOOTMEM
[    0.000000]   #31 [00021767c0 - 0002176800]         BOOTMEM
[    0.000000]   #32 [0002176800 - 0002176840]         BOOTMEM
[    0.000000]   #33 [0002176840 - 0002176880]         BOOTMEM
[    0.000000]   #34 [0002176880 - 00021768c0]         BOOTMEM
[    0.000000]   #35 [00021768c0 - 0002176900]         BOOTMEM
[    0.000000]   #36 [0002176900 - 0002176910]         BOOTMEM
[    0.000000]   #37 [0002176940 - 0002176a02]         BOOTMEM
[    0.000000]   #38 [0002176a40 - 0002176b02]         BOOTMEM
[    0.000000]   #39 [0002176b40 - 000217ab40]         BOOTMEM
[    0.000000]   #40 [000217ab40 - 00021fab40]         BOOTMEM
[    0.000000]   #41 [00021fab40 - 000223ab40]         BOOTMEM
[    0.000000]   #42 [000223ab40 - 000223ab48]         BOOTMEM
[    0.000000]   #43 [000223ab80 - 000223ab88]         BOOTMEM
[    0.000000]   #44 [000223abc0 - 000223ae00]         BOOTMEM
[    0.000000]   #45 [000223b000 - 0002be5fec]         BOOTMEM
[    0.000000] Initializing HighMem for node 0 (000377fe:0007bc00)
[    0.000000] Memory: 1985536k/2027520k available (4455k kernel code, 40876k reserved, 1897k data, 392k init, 1117504k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa3000 - 0xfffff000   ( 368 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc0a35000 - 0xc0a97000   ( 392 kB)
[    0.000000]       .data : 0xc0859ca2 - 0xc0a34128   (1897 kB)
[    0.000000]       .text : 0xc0400000 - 0xc0859ca2   (4455 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:288
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1396.274 MHz processor.
[    0.003338] Calibrating delay loop (skipped), value calculated using timer frequency.. 2793.90 BogoMIPS (lpj=4654246)
[    0.003344] pid_max: default: 32768 minimum: 301
[    0.003358] Security Framework initialized
[    0.003363] SELinux:  Initializing.
[    0.003371] SELinux:  Starting in permissive mode
[    0.003434] Mount-cache hash table entries: 512
[    0.003565] Initializing cgroup subsys ns
[    0.003570] Initializing cgroup subsys cpuacct
[    0.003573] Initializing cgroup subsys memory
[    0.003580] Initializing cgroup subsys devices
[    0.003583] Initializing cgroup subsys freezer
[    0.003585] Initializing cgroup subsys net_cls
[    0.003587] Initializing cgroup subsys blkio
[    0.003621] mce: CPU supports 6 MCE banks
[    0.003630] CPU0: Thermal monitoring enabled (TM2)
[    0.003634] using mwait in idle threads.
[    0.003642] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.003650] ... version:                2
[    0.003652] ... bit width:              40
[    0.003654] ... generic registers:      2
[    0.003656] ... value mask:             000000ffffffffff
[    0.003658] ... max period:             000000007fffffff
[    0.003660] ... fixed-purpose events:   3
[    0.003662] ... event mask:             0000000700000003
[    0.003666] CPU: Intel(R) Core(TM)2 Solo CPU    U3500  @ 1.40GHz stepping 0a
[    0.006920] ACPI: Core revision 20100702
[    0.023439] DMAR: Host address width 36
[    0.023443] DMAR: DRHD base: 0x00000000000000 flags: 0x1
[    0.023447] DMAR: parse DMAR table failure.
[    0.023449] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.023798] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.059999] regulator: core version 0.5
[    0.059999] NET: Registered protocol family 16
[    0.059999] ACPI: bus type pci registered
[    0.059999] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.059999] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.059999] PCI: Using MMCONFIG for extended config space
[    0.059999] PCI: Using configuration type 1 for base access
[    0.059999] bio: create slab <bio-0> at 0
[    0.059999] ACPI: EC: Look up EC in DSDT
[    0.061555] ACPI: Executed 1 blocks of module-level executable AML code
[    0.065346] ACPI: BIOS _OSI(Linux) query ignored
[    0.066510] ACPI Error: Could not map memory at 0x0000000079DD2018, size 463 (20100702/exregion-178)
[    0.066517] ACPI Exception: AE_NO_MEMORY, Returned by Handler for [SystemMemory] (20100702/evregion-474)
[    0.066525] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.CPU1.APPT] (Node f704b108), AE_NO_MEMORY
[    0.066533] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.CPU1.GCAP] (Node f704b0d8), AE_NO_MEMORY
[    0.066541] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.CPU1._PDC] (Node f704b0a8), AE_NO_MEMORY
[    0.067087] ACPI Error: Could not map memory at 0x0000000079DCC918, size 141 (20100702/exregion-178)
[    0.067094] ACPI Exception: AE_NO_MEMORY, Returned by Handler for [SystemMemory] (20100702/evregion-474)
[    0.067101] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.CPU1.APCT] (Node f704b0f0), AE_NO_MEMORY
[    0.067109] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.CPU2.GCAP] (Node f704b150), AE_NO_MEMORY
[    0.067117] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.CPU2._PDC] (Node f704b120), AE_NO_MEMORY
[    0.067676] ACPI: Interpreter enabled
[    0.067680] ACPI: (supports S0 S3 S4 S5)
[    0.067719] ACPI: Using IOAPIC for interrupt routing
[    0.074119] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
[    0.074625] ACPI: No dock devices found.
[    0.074631] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.075292] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.076611] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.076615] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.076619] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.076625] pci_root PNP0A08:00: host bridge window [mem 0x80000000-0xfebfffff]
[    0.076661] DMAR: Forcing write-buffer flush capability
[    0.076663] DMAR: Disabling IOMMU for graphics on this chipset
[    0.076704] pci 0000:00:02.0: reg 10: [mem 0x90000000-0x903fffff 64bit]
[    0.076714] pci 0000:00:02.0: reg 18: [mem 0x80000000-0x8fffffff 64bit pref]
[    0.076722] pci 0000:00:02.0: reg 20: [io  0x30d0-0x30d7]
[    0.076767] pci 0000:00:02.1: reg 10: [mem 0x92400000-0x924fffff 64bit]
[    0.076935] pci 0000:00:1a.0: reg 20: [io  0x30a0-0x30bf]
[    0.080002] pci 0000:00:1a.7: reg 10: [mem 0x94504c00-0x94504fff]
[    0.103373] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.103379] pci 0000:00:1a.7: PME# disabled
[    0.103434] pci 0000:00:1b.0: reg 10: [mem 0x94500000-0x94503fff 64bit]
[    0.103515] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.103521] pci 0000:00:1b.0: PME# disabled
[    0.103631] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.103637] pci 0000:00:1c.0: PME# disabled
[    0.103751] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.103757] pci 0000:00:1c.3: PME# disabled
[    0.103871] pci 0000:00:1d.0: reg 20: [io  0x3080-0x309f]
[    0.104026] pci 0000:00:1d.1: reg 20: [io  0x3060-0x307f]
[    0.104163] pci 0000:00:1d.2: reg 20: [io  0x3040-0x305f]
[    0.108637] pci 0000:00:1d.7: reg 10: [mem 0x94504800-0x94504bff]
[    0.132018] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.132024] pci 0000:00:1d.7: PME# disabled
[    0.133524] pci 0000:00:1f.2: reg 10: [io  0x30c8-0x30cf]
[    0.133537] pci 0000:00:1f.2: reg 14: [io  0x30dc-0x30df]
[    0.133549] pci 0000:00:1f.2: reg 18: [io  0x30c0-0x30c7]
[    0.133561] pci 0000:00:1f.2: reg 1c: [io  0x30d8-0x30db]
[    0.133574] pci 0000:00:1f.2: reg 20: [io  0x3020-0x303f]
[    0.133586] pci 0000:00:1f.2: reg 24: [mem 0x94504000-0x945047ff]
[    0.133636] pci 0000:00:1f.2: PME# supported from D3hot
[    0.133641] pci 0000:00:1f.2: PME# disabled
[    0.133685] pci 0000:00:1f.3: reg 10: [mem 0x94505000-0x945050ff 64bit]
[    0.133718] pci 0000:00:1f.3: reg 20: [io  0x3000-0x301f]
[    0.133861] pci 0000:01:00.0: reg 10: [mem 0x93500000-0x9353ffff 64bit]
[    0.133877] pci 0000:01:00.0: reg 18: [io  0x2000-0x207f]
[    0.133977] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.133983] pci 0000:01:00.0: PME# disabled
[    0.140018] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.140025] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.140031] pci 0000:00:1c.0:   bridge window [mem 0x93500000-0x944fffff]
[    0.140040] pci 0000:00:1c.0:   bridge window [mem 0x90400000-0x913fffff 64bit pref]
[    0.140208] pci 0000:02:00.0: reg 10: [mem 0x92500000-0x92501fff 64bit]
[    0.140389] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.140417] pci 0000:02:00.0: PME# disabled
[    0.140538] pci 0000:00:1c.3: PCI bridge to [bus 02-02]
[    0.140544] pci 0000:00:1c.3:   bridge window [io  0x1000-0x1fff]
[    0.140549] pci 0000:00:1c.3:   bridge window [mem 0x92500000-0x934fffff]
[    0.140558] pci 0000:00:1c.3:   bridge window [mem 0x91400000-0x923fffff 64bit pref]
[    0.140646] pci 0000:00:1e.0: PCI bridge to [bus 03-03] (subtractive decode)
[    0.140652] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.140659] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.140668] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.140672] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.140675] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.140679] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.140683] pci 0000:00:1e.0:   bridge window [mem 0x80000000-0xfebfffff] (subtractive decode)
[    0.140704] pci_bus 0000:00: on NUMA node 0
[    0.140709] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.141127] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.141227] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.141320] Unable to assume PCIe control: Disabling ASPM
[    0.147572] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
[    0.147675] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 *11 12)
[    0.147774] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
[    0.147874] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 *10 11 12)
[    0.147974] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
[    0.148075] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
[    0.148177] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 10 *11 12)
[    0.148278] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
[    0.148320] HEST: Table is not found!
[    0.148370] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.148380] vgaarb: loaded
[    0.148491] SCSI subsystem initialized
[    0.148509] libata version 3.00 loaded.
[    0.148568] usbcore: registered new interface driver usbfs
[    0.148586] usbcore: registered new interface driver hub
[    0.148611] usbcore: registered new device driver usb
[    0.148674] PCI: Using ACPI for IRQ routing
[    0.148678] PCI: pci_cache_line_size set to 64 bytes
[    0.148803] reserve RAM buffer: 000000000009e000 - 000000000009ffff 
[    0.148807] reserve RAM buffer: 000000007ba63000 - 000000007bffffff 
[    0.148812] reserve RAM buffer: 000000007bb80000 - 000000007bffffff 
[    0.148816] reserve RAM buffer: 000000007bbe0000 - 000000007bffffff 
[    0.148819] reserve RAM buffer: 000000007bc00000 - 000000007bffffff 
[    0.148914] NetLabel: Initializing
[    0.148917] NetLabel:  domain hash size = 128
[    0.148919] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.148932] NetLabel:  unlabeled traffic allowed by default
[    0.148939] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.148947] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.148953] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.153361] Switching to clocksource tsc
[    0.153383] pnp: PnP ACPI init
[    0.153394] ACPI: bus type pnp registered
[    0.154379] pnp 00:01: disabling [io  0x164e-0x164f] because it overlaps 0000:00:1c.3 BAR 13 [io  0x1000-0x1fff]
[    0.154990] pnp: PnP ACPI: found 9 devices
[    0.154993] ACPI: ACPI bus type pnp unregistered
[    0.155004] system 00:01: [io  0x0600-0x060f] has been reserved
[    0.155008] system 00:01: [io  0x0610] has been reserved
[    0.155012] system 00:01: [io  0x0800-0x080f] has been reserved
[    0.155016] system 00:01: [io  0x0810-0x0817] has been reserved
[    0.155020] system 00:01: [io  0x0820-0x0823] has been reserved
[    0.155024] system 00:01: [io  0x0400-0x047f] has been reserved
[    0.155027] system 00:01: [io  0x0500-0x053f] has been reserved
[    0.155032] system 00:01: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.155036] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.155040] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.155044] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.155048] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.155052] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.155056] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.155060] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.155064] system 00:01: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.155069] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.191157] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.191163] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.191171] pci 0000:00:1c.0:   bridge window [mem 0x93500000-0x944fffff]
[    0.191177] pci 0000:00:1c.0:   bridge window [mem 0x90400000-0x913fffff 64bit pref]
[    0.191186] pci 0000:00:1c.3: PCI bridge to [bus 02-02]
[    0.191191] pci 0000:00:1c.3:   bridge window [io  0x1000-0x1fff]
[    0.191199] pci 0000:00:1c.3:   bridge window [mem 0x92500000-0x934fffff]
[    0.191205] pci 0000:00:1c.3:   bridge window [mem 0x91400000-0x923fffff 64bit pref]
[    0.191214] pci 0000:00:1e.0: PCI bridge to [bus 03-03]
[    0.191216] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.191223] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.191229] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.191248] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.191254] pci 0000:00:1c.0: setting latency timer to 64
[    0.191266] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.191272] pci 0000:00:1c.3: setting latency timer to 64
[    0.191280] pci 0000:00:1e.0: setting latency timer to 64
[    0.191285] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.191289] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.191292] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.191296] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.191299] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    0.191303] pci_bus 0000:01: resource 1 [mem 0x93500000-0x944fffff]
[    0.191306] pci_bus 0000:01: resource 2 [mem 0x90400000-0x913fffff 64bit pref]
[    0.191310] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    0.191314] pci_bus 0000:02: resource 1 [mem 0x92500000-0x934fffff]
[    0.191317] pci_bus 0000:02: resource 2 [mem 0x91400000-0x923fffff 64bit pref]
[    0.191321] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    0.191324] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    0.191328] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    0.191331] pci_bus 0000:03: resource 7 [mem 0x80000000-0xfebfffff]
[    0.191351] NET: Registered protocol family 2
[    0.191375] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.191504] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.192137] TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
[    0.192286] TCP: Hash tables configured (established 131072 bind 65536)
[    0.192289] TCP reno registered
[    0.192292] UDP hash table entries: 512 (order: 1, 8192 bytes)
[    0.192300] UDP-Lite hash table entries: 512 (order: 1, 8192 bytes)
[    0.192344] NET: Registered protocol family 1
[    0.192357] pci 0000:00:02.0: Boot video device
[    0.220029] PCI: CLS 64 bytes, default 64
[    0.220087] Trying to unpack rootfs image as initramfs...
[    0.446803] Freeing initrd memory: 6804k freed
[    0.450502] Simple Boot Flag value 0x5 read from CMOS RAM was invalid
[    0.450506] Simple Boot Flag at 0x44 set to 0x1
[    0.450761] microcode: CPU0 sig=0x1067a, pf=0x80, revision=0xa07
[    0.450786] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.450902] audit: initializing netlink socket (disabled)
[    0.450925] type=2000 audit(1281807387.449:1): initialized
[    0.472714] highmem bounce pool size: 64 pages
[    0.472720] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.474577] VFS: Disk quotas dquot_6.5.2
[    0.474622] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.475255] Btrfs loaded
[    0.475260] msgmni has been set to 1708
[    0.475331] SELinux:  Registering netfilter hooks
[    0.475625] alg: No test for stdrng (krng)
[    0.475683] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.475686] io scheduler noop registered
[    0.475689] io scheduler deadline registered
[    0.475706] io scheduler cfq registered (default)
[    0.475801] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.475860] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.475977] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.476031] pcieport 0000:00:1c.3: irq 41 for MSI/MSI-X
[    0.476160] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.476231] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.476234] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.476508] pci-stub: invalid id string ""
[    0.476531] intel_idle: MWAIT substates: 0x3122220
[    0.476533] intel_idle: does not run on family 6 model 23
[    0.476905] ACPI: AC Adapter [ACAD] (on-line)
[    0.476992] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.476997] ACPI: Power Button [PWRB]
[    0.477051] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[    0.480061] ACPI: Lid Switch [LID0]
[    0.480115] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    0.480120] ACPI: Sleep Button [SLPB]
[    0.480181] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.480185] ACPI: Power Button [PWRF]
[    0.480351] ACPI: acpi_idle registered with cpuidle
[    0.480525] Monitor-Mwait will be used to enter C-1 state
[    0.480528] Monitor-Mwait will be used to enter C-2 state
[    0.480531] Monitor-Mwait will be used to enter C-3 state
[    0.480535] Marking TSC unstable due to TSC halts in idle
[    0.482234] ERST: Table is not found!
[    0.482494] Non-volatile memory driver v1.3
[    0.482497] Linux agpgart interface v0.103
[    0.482538] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[    0.483803] agpgart-intel 0000:00:00.0: detected 65532K stolen memory, trimming to 32768K
[    0.512963] Switching to clocksource hpet
[    0.513051] ACPI: Battery Slot [BAT1] (battery absent)
[    0.513139] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x80000000
[    0.513212] [drm] Initialized drm 1.1.0 20060810
[    0.513242] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.513248] i915 0000:00:02.0: setting latency timer to 64
[    0.546039] [drm] detected 63M stolen memory, trimming to 32M
[    0.546107] i915 0000:00:02.0: irq 42 for MSI/MSI-X
[    0.546118] [drm] set up 32M of stolen space
[    0.546288] [drm:init_ring_common] *ERROR* render ring head not reset to zero ctl 00000000 head 02001000 tail 00000000 start 02001000
[    0.546360] [drm:init_ring_common] *ERROR* render ring head forced to zero ctl 00000000 head 00000000 tail 00000000 start 02001000
[    1.284466] fbcon: inteldrmfb (fb0) is primary device
[    2.239518] Console: switching to colour frame buffer device 170x48
[    2.243833] fb0: inteldrmfb frame buffer device
[    2.243836] drm: registered panic notifier
[    2.245586] acpi device:02: registered as cooling_device1
[    2.245798] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input4
[    2.245806] ACPI: Video Device [OVGA] (multi-head: yes  rom: no  post: no)
[    2.245827] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    2.245857] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.247408] brd: module loaded
[    2.247486] ahci 0000:00:1f.2: version 3.0
[    2.247501] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.247548] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    2.247596] ahci: SSS flag set, parallel bus scan disabled
[    2.247641] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x33 impl SATA mode
[    2.247647] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led pmp pio slum part ccc ems 
[    2.247654] ahci 0000:00:1f.2: setting latency timer to 64
[    2.266720] scsi0 : ahci
[    2.266814] scsi1 : ahci
[    2.266883] scsi2 : ahci
[    2.266946] scsi3 : ahci
[    2.267008] scsi4 : ahci
[    2.267068] scsi5 : ahci
[    2.267120] ata1: SATA max UDMA/133 abar m2048@0x94504000 port 0x94504100 irq 43
[    2.267125] ata2: SATA max UDMA/133 abar m2048@0x94504000 port 0x94504180 irq 43
[    2.267127] ata3: DUMMY
[    2.267129] ata4: DUMMY
[    2.267133] ata5: SATA max UDMA/133 abar m2048@0x94504000 port 0x94504300 irq 43
[    2.267137] ata6: SATA max UDMA/133 abar m2048@0x94504000 port 0x94504380 irq 43
[    2.267210] atl1c 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.267220] atl1c 0000:01:00.0: setting latency timer to 64
[    2.353581] atl1c 0000:01:00.0: version 1.0.1.0-NAPI
[    2.353614] console [netcon0] enabled
[    2.353616] netconsole: network logging started
[    2.353661] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.353681] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    2.353696] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    2.353701] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    2.353750] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    2.353783] ehci_hcd 0000:00:1a.7: debug port 1
[    2.357680] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    2.357694] ehci_hcd 0000:00:1a.7: irq 19, io mem 0x94504c00
[    2.370018] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    2.370039] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.370043] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.370046] usb usb1: Product: EHCI Host Controller
[    2.370049] usb usb1: Manufacturer: Linux 2.6.35-07956-g92fa5bd9 ehci_hcd
[    2.370052] usb usb1: SerialNumber: 0000:00:1a.7
[    2.370148] hub 1-0:1.0: USB hub found
[    2.370154] hub 1-0:1.0: 2 ports detected
[    2.370224] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.370238] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.370242] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.370284] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    2.370314] ehci_hcd 0000:00:1d.7: debug port 1
[    2.374189] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    2.374201] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x94504800
[    2.386685] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.386719] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    2.386723] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.386726] usb usb2: Product: EHCI Host Controller
[    2.386728] usb usb2: Manufacturer: Linux 2.6.35-07956-g92fa5bd9 ehci_hcd
[    2.386731] usb usb2: SerialNumber: 0000:00:1d.7
[    2.386824] hub 2-0:1.0: USB hub found
[    2.386828] hub 2-0:1.0: 6 ports detected
[    2.386904] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.386918] uhci_hcd: USB Universal Host Controller Interface driver
[    2.386941] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.386949] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    2.386953] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    2.386995] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    2.387031] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000030a0
[    2.387068] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.387071] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.387074] usb usb3: Product: UHCI Host Controller
[    2.387077] usb usb3: Manufacturer: Linux 2.6.35-07956-g92fa5bd9 uhci_hcd
[    2.387080] usb usb3: SerialNumber: 0000:00:1a.0
[    2.387171] hub 3-0:1.0: USB hub found
[    2.387176] hub 3-0:1.0: 2 ports detected
[    2.387241] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.387249] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.387254] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.387299] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    2.387327] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00003080
[    2.387364] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.387367] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.387371] usb usb4: Product: UHCI Host Controller
[    2.387374] usb usb4: Manufacturer: Linux 2.6.35-07956-g92fa5bd9 uhci_hcd
[    2.387376] usb usb4: SerialNumber: 0000:00:1d.0
[    2.387468] hub 4-0:1.0: USB hub found
[    2.387474] hub 4-0:1.0: 2 ports detected
[    2.387539] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.387547] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.387551] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.387589] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
[    2.387619] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00003060
[    2.387653] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.387657] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.387660] usb usb5: Product: UHCI Host Controller
[    2.387663] usb usb5: Manufacturer: Linux 2.6.35-07956-g92fa5bd9 uhci_hcd
[    2.387666] usb usb5: SerialNumber: 0000:00:1d.1
[    2.387759] hub 5-0:1.0: USB hub found
[    2.387764] hub 5-0:1.0: 2 ports detected
[    2.387830] uhci_hcd 0000:00:1d.2: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    2.387837] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.387842] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.387879] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
[    2.387909] uhci_hcd 0000:00:1d.2: irq 16, io base 0x00003040
[    2.387946] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    2.387949] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.387953] usb usb6: Product: UHCI Host Controller
[    2.387955] usb usb6: Manufacturer: Linux 2.6.35-07956-g92fa5bd9 uhci_hcd
[    2.387958] usb usb6: SerialNumber: 0000:00:1d.2
[    2.388053] hub 6-0:1.0: USB hub found
[    2.388058] hub 6-0:1.0: 2 ports detected
[    2.388196] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUE] at 0x60,0x64 irq 1,12
[    2.396006] i8042.c: Detected active multiplexing controller, rev 1.1.
[    2.399588] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.399594] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    2.399625] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    2.399651] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    2.399678] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    2.399759] mice: PS/2 mouse device common for all mice
[    2.399967] rtc_cmos 00:03: RTC can wake from S4
[    2.400020] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    2.400050] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    2.400166] device-mapper: uevent: version 1.0.3
[    2.400260] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initialised: dm-devel@redhat.com
[    2.400391] cpuidle: using governor ladder
[    2.400455] cpuidle: using governor menu
[    2.400776] usbcore: registered new interface driver hiddev
[    2.400796] usbcore: registered new interface driver usbhid
[    2.400798] usbhid: USB HID core driver
[    2.400847] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    2.401057] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.401070] TCP cubic registered
[    2.401072] Initializing XFRM netlink socket
[    2.401082] NET: Registered protocol family 17
[    2.401095] Using IPI Shortcut mode
[    2.421862] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[    2.693377] usb 2-5: new high speed USB device using ehci_hcd and address 2
[    2.746731] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.795604] ata1.00: ATA-8: TOSHIBA MK2555GSX, FG001J, max UDMA/100
[    2.795608] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.796507] ata1.00: configured for UDMA/100
[    2.806825] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK2555GS FG00 PQ: 0 ANSI: 5
[    2.806957] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.807045] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    2.807092] sd 0:0:0:0: [sda] Write Protect is off
[    2.807096] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.807118] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.857652] usb 2-5: New USB device found, idVendor=064e, idProduct=a102
[    2.857656] usb 2-5: New USB device strings: Mfr=2, Product=1, SerialNumber=3
[    2.857659] usb 2-5: Product: WebCam
[    2.857661] usb 2-5: Manufacturer: SuYin
[    2.857664] usb 2-5: SerialNumber: CN0316-S30C-OV061-VA-R02.02.02
[    2.860752]  sda: sda1 sda2 sda3 sda4
[    2.861013] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.126729] ata2: SATA link down (SStatus 0 SControl 300)
[    3.186934] Synaptics Touchpad, model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd04731/0xa40000/0xa0000
[    3.231985] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio2/input/input6
[    3.460047] ata5: SATA link down (SStatus 0 SControl 300)
[    3.793435] ata6: SATA link down (SStatus 0 SControl 300)
[    3.806780] registered taskstats version 1
[    3.806783] IMA: No TPM chip found, activating TPM-bypass!
[    3.807140] rtc_cmos 00:03: setting system clock to 2010-08-14 17:36:31 UTC (1281807391)
[    3.807238] Freeing unused kernel memory: 392k freed
[    3.807399] Write protecting the kernel text: 4456k
[    3.807427] Write protecting the kernel read-only data: 1592k
[    3.827984] dracut: dracut-005-3.fc13
[    3.846799] udev: starting version 151
[    3.846858] udevd (85): /proc/85/oom_adj is deprecated, please use /proc/85/oom_score_adj instead.
[    3.924917] dracut: Starting plymouth daemon
[    4.765437] dracut: luksOpen /dev/sda3 luks-home
[  128.790161] dracut: luksOpen /dev/sda4 luks-swap
[  129.513456] PM: Starting manual resume from disk
[  129.623874] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[  129.656948] dracut: Remounting /dev/disk/by-uuid/5764c1f2-f119-4f97-b8e2-d827b8655edb with -o noatime,data=writeback,ro
[  129.701655] EXT4-fs (sda2): mounted filesystem with writeback data mode. Opts: data=writeback
[  129.715607] dracut: Mounted root filesystem /dev/sda2
[  129.898271] dracut: Loading SELinux policy
[  130.287743] type=1404 audit(1281807517.980:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[  130.410134] SELinux: 2048 avtab hash slots, 200713 rules.
[  130.507095] SELinux: 2048 avtab hash slots, 200713 rules.
[  130.728765] SELinux:  9 users, 13 roles, 3346 types, 170 bools, 1 sens, 1024 cats
[  130.728772] SELinux:  77 classes, 200713 rules
[  130.734532] SELinux:  Permission audit_access in class file not defined in policy.
[  130.734544] SELinux:  Permission audit_access in class dir not defined in policy.
[  130.734547] SELinux:  Permission execmod in class dir not defined in policy.
[  130.734557] SELinux:  Permission audit_access in class lnk_file not defined in policy.
[  130.734560] SELinux:  Permission open in class lnk_file not defined in policy.
[  130.734563] SELinux:  Permission execmod in class lnk_file not defined in policy.
[  130.734570] SELinux:  Permission audit_access in class chr_file not defined in policy.
[  130.734578] SELinux:  Permission audit_access in class blk_file not defined in policy.
[  130.734581] SELinux:  Permission execmod in class blk_file not defined in policy.
[  130.734589] SELinux:  Permission audit_access in class sock_file not defined in policy.
[  130.734592] SELinux:  Permission execmod in class sock_file not defined in policy.
[  130.734600] SELinux:  Permission audit_access in class fifo_file not defined in policy.
[  130.734603] SELinux:  Permission execmod in class fifo_file not defined in policy.
[  130.734766] SELinux: the above unknown classes and permissions will be allowed
[  130.734775] SELinux:  Completing initialization.
[  130.734777] SELinux:  Setting up existing superblocks.
[  130.734785] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[  130.734794] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[  130.734962] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[  130.734970] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[  130.734985] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[  130.735006] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[  130.735012] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[  130.735039] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[  130.735046] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[  130.735052] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[  130.735077] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[  130.735085] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[  130.735091] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[  130.735106] SELinux: initialized (dev configfs, type configfs), uses genfs_contexts
[  130.735112] SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
[  130.735119] SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
[  130.735124] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[  130.735363] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[  130.736194] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[  130.736206] SELinux: initialized (dev sda2, type ext4), uses xattr
[  130.738865] type=1403 audit(1281807518.426:3): policy loaded auid=4294967295 ses=4294967295
[  130.860898] dracut: Switching root
[  131.674080] type=1400 audit(1281807519.363:4): avc:  denied  { read write } for  pid=481 comm="hostname" path="/dev/console" dev=tmpfs ino=1350 scontext=system_u:system_r:hostname_t:s0 tcontext=system_u:object_r:device_t:s0 tclass=chr_file
[  131.674975] type=1400 audit(1281807519.363:5): avc:  denied  { read write } for  pid=481 comm="hostname" path="/dev/console" dev=tmpfs ino=1350 scontext=system_u:system_r:hostname_t:s0 tcontext=system_u:object_r:device_t:s0 tclass=chr_file
[  131.681122] type=1400 audit(1281807519.370:6): avc:  denied  { read write } for  pid=484 comm="consoletype" path="/dev/null" dev=tmpfs ino=1344 scontext=system_u:system_r:consoletype_t:s0 tcontext=system_u:object_r:device_t:s0 tclass=chr_file
[  131.682007] type=1400 audit(1281807519.370:7): avc:  denied  { read write } for  pid=484 comm="consoletype" path="/dev/null" dev=tmpfs ino=1344 scontext=system_u:system_r:consoletype_t:s0 tcontext=system_u:object_r:device_t:s0 tclass=chr_file
[  131.684772] type=1400 audit(1281807519.373:8): avc:  denied  { read write } for  pid=485 comm="consoletype" path="/dev/console" dev=tmpfs ino=1350 scontext=system_u:system_r:consoletype_t:s0 tcontext=system_u:object_r:device_t:s0 tclass=chr_file
[  131.684791] type=1400 audit(1281807519.373:9): avc:  denied  { read write } for  pid=485 comm="consoletype" path="/dev/console" dev=tmpfs ino=1350 scontext=system_u:system_r:consoletype_t:s0 tcontext=system_u:object_r:device_t:s0 tclass=chr_file
[  131.939597] readahead: starting
[  131.955196] type=1400 audit(1281807519.643:10): avc:  denied  { read write } for  pid=480 comm="readahead" path="/dev/console" dev=tmpfs ino=1350 scontext=system_u:system_r:readahead_t:s0 tcontext=system_u:object_r:device_t:s0 tclass=chr_file
[  131.955271] type=1400 audit(1281807519.643:11): avc:  denied  { read write } for  pid=480 comm="readahead" path="/dev/console" dev=tmpfs ino=1350 scontext=system_u:system_r:readahead_t:s0 tcontext=system_u:object_r:device_t:s0 tclass=chr_file
[  134.165610] udev: starting version 151
[  134.727527] input: PC Speaker as /devices/platform/pcspkr/input/input7
[  134.844217] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[  134.890681] iTCO_vendor_support: vendor-support=0
[  134.894161] ACPI: WMI: Mapper loaded
[  134.900240] Linux video capture interface: v2.00
[  134.954049] uvcvideo: Found UVC 1.00 device WebCam (064e:a102)
[  134.969517] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[  134.969870] iTCO_wdt: Found a ICH9M-E TCO device (Version=2, TCOBASE=0x0460)
[  134.971244] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[  134.972461] input: WebCam as /devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5:1.0/input/input8
[  134.972787] usbcore: registered new interface driver uvcvideo
[  134.972791] USB Video Class driver (v0.1.0)
[  135.054561] cfg80211: Calling CRDA to update world regulatory domain
[  135.865838] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[  135.866013] HDA Intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[  135.866035] HDA Intel 0000:00:1b.0: setting latency timer to 64
[  135.998314] cfg80211: World regulatory domain updated:
[  135.998319]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  135.998323]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  135.998327]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  135.998330]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  135.998333]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  135.998337]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  136.104679] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
[  136.104683] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[  136.104788] iwlagn 0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[  136.104826] iwlagn 0000:02:00.0: setting latency timer to 64
[  136.104903] iwlagn 0000:02:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
[  136.127046] iwlagn 0000:02:00.0: device EEPROM VER=0x11f, CALIB=0x4
[  136.141304] iwlagn 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[  136.141480] iwlagn 0000:02:00.0: irq 45 for MSI/MSI-X
[  136.206772] iwlagn 0000:02:00.0: loaded firmware version 8.24.2.12
[  136.399129] ALSA sound/pci/hda/patch_realtek.c:1355: SKU: Nid=0x1d sku_cfg=0x4015812d
[  136.399135] ALSA sound/pci/hda/patch_realtek.c:1357: SKU: port_connectivity=0x1
[  136.399138] ALSA sound/pci/hda/patch_realtek.c:1358: SKU: enable_pcbeep=0x1
[  136.399142] ALSA sound/pci/hda/patch_realtek.c:1359: SKU: check_sum=0x00000005
[  136.399145] ALSA sound/pci/hda/patch_realtek.c:1360: SKU: customization=0x00000081
[  136.399149] ALSA sound/pci/hda/patch_realtek.c:1361: SKU: external_amp=0x5
[  136.399152] ALSA sound/pci/hda/patch_realtek.c:1362: SKU: platform_type=0x1
[  136.399156] ALSA sound/pci/hda/patch_realtek.c:1363: SKU: swap=0x0
[  136.399159] ALSA sound/pci/hda/patch_realtek.c:1364: SKU: override=0x1
[  136.399301] hda_codec: ALC269: BIOS auto-probing.
[  136.399306] ALSA sound/pci/hda/hda_codec.c:4594: autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0)
[  136.399311] ALSA sound/pci/hda/hda_codec.c:4598:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[  136.399315] ALSA sound/pci/hda/hda_codec.c:4602:    hp_outs=1 (0x15/0x0/0x0/0x0/0x0)
[  136.399319] ALSA sound/pci/hda/hda_codec.c:4603:    mono: mono_out=0x0
[  136.399322] ALSA sound/pci/hda/hda_codec.c:4606:    dig-out=0x1e/0x0
[  136.399326] ALSA sound/pci/hda/hda_codec.c:4614:    inputs: mic=0x18, fmic=0x12, line=0x0, fline=0x0, cd=0x0, aux=0x0
[  136.399863] ALSA sound/pci/hda/patch_realtek.c:1405: realtek: No valid SSID, checking pincfg 0x4015812d for NID 0x1d
[  136.399868] ALSA sound/pci/hda/patch_realtek.c:1421: realtek: Enabling init ASM_ID=0x812d CODEC_ID=10ec0269
[  136.400725] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input9
[  136.630026] phy0: Selected rate control algorithm 'iwl-agn-rs'
[  137.603862] cfg80211: Calling CRDA for country: DE
[  137.605784] cfg80211: Regulatory domain changed to country: DE
[  137.605788]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  137.605792]     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  137.605795]     (5150000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  137.605799]     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[  142.660265] EXT4-fs (sda2): re-mounted. Opts: data=writeback
[  143.124304] EXT4-fs (sda1): mounted filesystem without journal. Opts: (null)
[  143.124682] SELinux: initialized (dev sda1, type ext2), uses xattr
[  143.187948] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[  143.187957] SELinux: initialized (dev dm-0, type ext4), uses xattr
[  144.972246] Adding 2007604k swap on /dev/mapper/luks-swap.  Priority:-1 extents:1 across:2007604k 
[  144.975217] SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
[  145.510901] NET: Registered protocol family 10
[  145.511062] lo: Disabled Privacy Extensions
[  145.523733] ip6_tables: (C) 2000-2006 Netfilter Core Team
[  148.908458] atl1c 0000:01:00.0: irq 46 for MSI/MSI-X
[  148.964939] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  149.119782] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  183.918948] fuse init (API version 7.15)
[  184.101613] SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
[  222.918607] wlan0: deauthenticating from 00:23:08:1d:f2:bb by local choice (reason=3)
[  223.046154] wlan0: authenticate with 00:23:08:1d:f2:bb (try 1)
[  223.243343] wlan0: authenticate with 00:23:08:1d:f2:bb (try 2)
[  223.256686] wlan0: authenticated
[  223.260417] wlan0: associate with 00:23:08:1d:f2:bb (try 1)
[  223.460235] wlan0: associate with 00:23:08:1d:f2:bb (try 2)
[  223.482339] wlan0: RX AssocResp from 00:23:08:1d:f2:bb (capab=0x431 status=0 aid=3)
[  223.482347] wlan0: associated
[  223.486856] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  234.350017] wlan0: no IPv6 routers present
[  552.473906] TCP lp registered
[ 1992.506717] No probe response from AP 00:23:08:1d:f2:bb after 500ms, disconnecting.
[ 1992.510303] cfg80211: Calling CRDA to update world regulatory domain
[ 1992.510337] cfg80211: Calling CRDA for country: DE
[ 1992.534790] cfg80211: Regulatory domain changed to country: DE
[ 1992.534794]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 1992.534798]     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 1992.534802]     (5150000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 1992.534805]     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[53014.074749] BUG: scheduling while atomic: crond/5636/0x10000001
[53014.074755] Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput snd_hda_codec_intelhdmi arc4 snd_hda_codec_realtek ecb iwlagn snd_hda_intel iwlcore snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm mac80211 snd_timer snd soundcore cfg80211 rfkill iTCO_wdt snd_page_alloc uvcvideo iTCO_vendor_support wmi serio_raw videodev i2c_i801 joydev v4l1_compat pcspkr sha256_generic aes_i586 aes_generic cbc dm_crypt [last unloaded: scsi_wait_scan]
[53014.074829] Pid: 5636, comm: crond Tainted: G          I 2.6.35-07956-g92fa5bd9 #164
[53014.074834] Call Trace:
[53014.074848]  [<c085306b>] ? schedule+0x30b/0x4c0
[53014.074857]  [<c048c7a1>] ? generic_file_aio_read+0x5d1/0x710
[53014.074865]  [<c0853329>] ? _cond_resched+0x29/0x40
[53014.074874]  [<c04a77b4>] ? anon_vma_prepare+0x14/0xd0
[53014.074881]  [<c04a3bac>] ? expand_downwards+0x1c/0x150
[53014.074892]  [<c0423c8b>] ? pte_alloc_one+0x1b/0x40
[53014.074899]  [<c04a0ef7>] ? handle_mm_fault+0x957/0x9a0
[53014.074907]  [<c049e63d>] ? follow_page+0x6d/0x290
[53014.074914]  [<c04a1059>] ? __get_user_pages+0x119/0x3d0
[53014.074923]  [<c04c58cd>] ? get_arg_page+0x4d/0xb0
[53014.074932]  [<c0604d53>] ? strnlen_user+0x23/0x50
[53014.074939]  [<c04c59fc>] ? copy_strings+0xcc/0x190
[53014.074947]  [<c04c5ae1>] ? copy_strings_kernel+0x21/0x40
[53014.074954]  [<c04c6f01>] ? do_execve+0x181/0x250
[53014.074963]  [<c0408343>] ? sys_execve+0x33/0x70
[53014.074970]  [<c0402e0e>] ? ptregs_execve+0x12/0x18
[53014.074976]  [<c0402d53>] ? sysenter_do_call+0x12/0x22
[59183.256705] wlan0: authenticate with 00:23:08:1d:f2:bb (try 1)
[59183.263457] wlan0: authenticated
[59183.263506] wlan0: associate with 00:23:08:1d:f2:bb (try 1)
[59183.281267] wlan0: RX AssocResp from 00:23:08:1d:f2:bb (capab=0x431 status=0 aid=3)
[59183.281272] wlan0: associated
[64711.390243] BUG: scheduling while atomic: sh/6746/0x10000001
[64711.390254] Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput snd_hda_codec_intelhdmi arc4 snd_hda_codec_realtek ecb iwlagn snd_hda_intel iwlcore snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm mac80211 snd_timer snd soundcore cfg80211 rfkill iTCO_wdt snd_page_alloc uvcvideo iTCO_vendor_support wmi serio_raw videodev i2c_i801 joydev v4l1_compat pcspkr sha256_generic aes_i586 aes_generic cbc dm_crypt [last unloaded: scsi_wait_scan]
[64711.390325] Pid: 6746, comm: sh Tainted: G          I 2.6.35-07956-g92fa5bd9 #164
[64711.390330] Call Trace:
[64711.390345]  [<c085306b>] ? schedule+0x30b/0x4c0
[64711.390355]  [<c043159c>] ? irq_exit+0x2c/0x70
[64711.390364]  [<c0418713>] ? smp_apic_timer_interrupt+0x43/0x80
[64711.390373]  [<c048c7a1>] ? generic_file_aio_read+0x5d1/0x710
[64711.390380]  [<c0853329>] ? _cond_resched+0x29/0x40
[64711.390389]  [<c04a77b4>] ? anon_vma_prepare+0x14/0xd0
[64711.390397]  [<c04a3bac>] ? expand_downwards+0x1c/0x150
[64711.390407]  [<c0424eb4>] ? kmap_atomic_prot+0x24/0xc0
[64711.390415]  [<c04a0ef7>] ? handle_mm_fault+0x957/0x9a0
[64711.390422]  [<c049e63d>] ? follow_page+0x6d/0x290
[64711.390430]  [<c04a1059>] ? __get_user_pages+0x119/0x3d0
[64711.390439]  [<c04c58cd>] ? get_arg_page+0x4d/0xb0
[64711.390449]  [<c0604d53>] ? strnlen_user+0x23/0x50
[64711.390456]  [<c04c59fc>] ? copy_strings+0xcc/0x190
[64711.390463]  [<c04c5ae1>] ? copy_strings_kernel+0x21/0x40
[64711.390470]  [<c04c6f01>] ? do_execve+0x181/0x250
[64711.390479]  [<c0408343>] ? sys_execve+0x33/0x70
[64711.390486]  [<c0402e0e>] ? ptregs_execve+0x12/0x18
[64711.390492]  [<c0402d53>] ? sysenter_do_call+0x12/0x22
[64810.322542] BUG: scheduling while atomic: gcc/8002/0x10000001
[64810.322546] Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput snd_hda_codec_intelhdmi arc4 snd_hda_codec_realtek ecb iwlagn snd_hda_intel iwlcore snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm mac80211 snd_timer snd soundcore cfg80211 rfkill iTCO_wdt snd_page_alloc uvcvideo iTCO_vendor_support wmi serio_raw videodev i2c_i801 joydev v4l1_compat pcspkr sha256_generic aes_i586 aes_generic cbc dm_crypt [last unloaded: scsi_wait_scan]
[64810.322590] Pid: 8002, comm: gcc Tainted: G          I 2.6.35-07956-g92fa5bd9 #164
[64810.322593] Call Trace:
[64810.322602]  [<c085306b>] ? schedule+0x30b/0x4c0
[64810.322609]  [<c0403e53>] ? do_IRQ+0x43/0xb0
[64810.322613]  [<c0853329>] ? _cond_resched+0x29/0x40
[64810.322618]  [<c04a77b4>] ? anon_vma_prepare+0x14/0xd0
[64810.322623]  [<c04a3bac>] ? expand_downwards+0x1c/0x150
[64810.322627]  [<c04a30e3>] ? find_vma+0x23/0x70
[64810.322631]  [<c04a0ef7>] ? handle_mm_fault+0x957/0x9a0
[64810.322636]  [<c049e82c>] ? follow_page+0x25c/0x290
[64810.322640]  [<c04a1059>] ? __get_user_pages+0x119/0x3d0
[64810.322645]  [<c04c58cd>] ? get_arg_page+0x4d/0xb0
[64810.322651]  [<c0605015>] ? _copy_from_user+0x35/0x120
[64810.322655]  [<c04c59fc>] ? copy_strings+0xcc/0x190
[64810.322659]  [<c04c6f26>] ? do_execve+0x1a6/0x250
[64810.322664]  [<c0408343>] ? sys_execve+0x33/0x70
[64810.322668]  [<c0402e0e>] ? ptregs_execve+0x12/0x18
[64810.322672]  [<c0402d53>] ? sysenter_do_call+0x12/0x22
[64814.460219] BUG: scheduling while atomic: gcc/8032/0x10000001
[64814.460223] Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput snd_hda_codec_intelhdmi arc4 snd_hda_codec_realtek ecb iwlagn snd_hda_intel iwlcore snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm mac80211 snd_timer snd soundcore cfg80211 rfkill iTCO_wdt snd_page_alloc uvcvideo iTCO_vendor_support wmi serio_raw videodev i2c_i801 joydev v4l1_compat pcspkr sha256_generic aes_i586 aes_generic cbc dm_crypt [last unloaded: scsi_wait_scan]
[64814.460267] Pid: 8032, comm: gcc Tainted: G          I 2.6.35-07956-g92fa5bd9 #164
[64814.460270] Call Trace:
[64814.460278]  [<c085306b>] ? schedule+0x30b/0x4c0
[64814.460285]  [<c048c7a1>] ? generic_file_aio_read+0x5d1/0x710
[64814.460289]  [<c0853329>] ? _cond_resched+0x29/0x40
[64814.460294]  [<c04a77b4>] ? anon_vma_prepare+0x14/0xd0
[64814.460299]  [<c04a3bac>] ? expand_downwards+0x1c/0x150
[64814.460304]  [<c0423c8b>] ? pte_alloc_one+0x1b/0x40
[64814.460309]  [<c04a0ef7>] ? handle_mm_fault+0x957/0x9a0
[64814.460313]  [<c049e63d>] ? follow_page+0x6d/0x290
[64814.460317]  [<c04a1059>] ? __get_user_pages+0x119/0x3d0
[64814.460323]  [<c04c58cd>] ? get_arg_page+0x4d/0xb0
[64814.460329]  [<c0604d53>] ? strnlen_user+0x23/0x50
[64814.460333]  [<c04c59fc>] ? copy_strings+0xcc/0x190
[64814.460337]  [<c04c5ae1>] ? copy_strings_kernel+0x21/0x40
[64814.460341]  [<c04c6f01>] ? do_execve+0x181/0x250
[64814.460346]  [<c0408343>] ? sys_execve+0x33/0x70
[64814.460350]  [<c0402e0e>] ? ptregs_execve+0x12/0x18
[64814.460354]  [<c0402d53>] ? sysenter_do_call+0x12/0x22
[64816.948932] BUG: scheduling while atomic: make/8056/0x10000001
[64816.948936] Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput snd_hda_codec_intelhdmi arc4 snd_hda_codec_realtek ecb iwlagn snd_hda_intel iwlcore snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm mac80211 snd_timer snd soundcore cfg80211 rfkill iTCO_wdt snd_page_alloc uvcvideo iTCO_vendor_support wmi serio_raw videodev i2c_i801 joydev v4l1_compat pcspkr sha256_generic aes_i586 aes_generic cbc dm_crypt [last unloaded: scsi_wait_scan]
[64816.948980] Pid: 8056, comm: make Tainted: G          I 2.6.35-07956-g92fa5bd9 #164
[64816.948983] Call Trace:
[64816.948991]  [<c085306b>] ? schedule+0x30b/0x4c0
[64816.948996]  [<c048007b>] ? taskstats_exit+0x2bb/0x2c0
[64816.949001]  [<c0853329>] ? _cond_resched+0x29/0x40
[64816.949006]  [<c04a77b4>] ? anon_vma_prepare+0x14/0xd0
[64816.949011]  [<c04a3bac>] ? expand_downwards+0x1c/0x150
[64816.949016]  [<c0423c8b>] ? pte_alloc_one+0x1b/0x40
[64816.949021]  [<c04a0ef7>] ? handle_mm_fault+0x957/0x9a0
[64816.949025]  [<c049e63d>] ? follow_page+0x6d/0x290
[64816.949029]  [<c04a1059>] ? __get_user_pages+0x119/0x3d0
[64816.949035]  [<c04c58cd>] ? get_arg_page+0x4d/0xb0
[64816.949040]  [<c0604d53>] ? strnlen_user+0x23/0x50
[64816.949044]  [<c04c59fc>] ? copy_strings+0xcc/0x190
[64816.949048]  [<c04c5ae1>] ? copy_strings_kernel+0x21/0x40
[64816.949052]  [<c04c6f01>] ? do_execve+0x181/0x250
[64816.949057]  [<c0408343>] ? sys_execve+0x33/0x70
[64816.949061]  [<c0402e0e>] ? ptregs_execve+0x12/0x18
[64816.949065]  [<c0402d53>] ? sysenter_do_call+0x12/0x22
[64871.923534] BUG: scheduling while atomic: make/9064/0x10000001
[64871.923539] Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput snd_hda_codec_intelhdmi arc4 snd_hda_codec_realtek ecb iwlagn snd_hda_intel iwlcore snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm mac80211 snd_timer snd soundcore cfg80211 rfkill iTCO_wdt snd_page_alloc uvcvideo iTCO_vendor_support wmi serio_raw videodev i2c_i801 joydev v4l1_compat pcspkr sha256_generic aes_i586 aes_generic cbc dm_crypt [last unloaded: scsi_wait_scan]
[64871.923582] Pid: 9064, comm: make Tainted: G          I 2.6.35-07956-g92fa5bd9 #164
[64871.923585] Call Trace:
[64871.923595]  [<c085306b>] ? schedule+0x30b/0x4c0
[64871.923600]  [<c048c7a1>] ? generic_file_aio_read+0x5d1/0x710
[64871.923604]  [<c0853329>] ? _cond_resched+0x29/0x40
[64871.923609]  [<c04a77b4>] ? anon_vma_prepare+0x14/0xd0
[64871.923614]  [<c04a3bac>] ? expand_downwards+0x1c/0x150
[64871.923619]  [<c0423c8b>] ? pte_alloc_one+0x1b/0x40
[64871.923624]  [<c04a0ef7>] ? handle_mm_fault+0x957/0x9a0
[64871.923628]  [<c049e63d>] ? follow_page+0x6d/0x290
[64871.923632]  [<c04a1059>] ? __get_user_pages+0x119/0x3d0
[64871.923639]  [<c04c58cd>] ? get_arg_page+0x4d/0xb0
[64871.923644]  [<c0604d53>] ? strnlen_user+0x23/0x50
[64871.923648]  [<c04c59fc>] ? copy_strings+0xcc/0x190
[64871.923653]  [<c04c5ae1>] ? copy_strings_kernel+0x21/0x40
[64871.923657]  [<c04c6f01>] ? do_execve+0x181/0x250
[64871.923663]  [<c0408343>] ? sys_execve+0x33/0x70
[64871.923667]  [<c0402e0e>] ? ptregs_execve+0x12/0x18
[64871.923671]  [<c0402d53>] ? sysenter_do_call+0x12/0x22
[64899.358837] BUG: scheduling while atomic: make/9826/0x10000001
[64899.358850] Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput snd_hda_codec_intelhdmi arc4 snd_hda_codec_realtek ecb iwlagn snd_hda_intel iwlcore snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm mac80211 snd_timer snd soundcore cfg80211 rfkill iTCO_wdt snd_page_alloc uvcvideo iTCO_vendor_support wmi serio_raw videodev i2c_i801 joydev v4l1_compat pcspkr sha256_generic aes_i586 aes_generic cbc dm_crypt [last unloaded: scsi_wait_scan]
[64899.358893] Pid: 9826, comm: make Tainted: G          I 2.6.35-07956-g92fa5bd9 #164
[64899.358896] Call Trace:
[64899.358906]  [<c085306b>] ? schedule+0x30b/0x4c0
[64899.358911]  [<c048c7a1>] ? generic_file_aio_read+0x5d1/0x710
[64899.358915]  [<c0853329>] ? _cond_resched+0x29/0x40
[64899.358921]  [<c04a77b4>] ? anon_vma_prepare+0x14/0xd0
[64899.358925]  [<c04a3bac>] ? expand_downwards+0x1c/0x150
[64899.358931]  [<c0423c8b>] ? pte_alloc_one+0x1b/0x40
[64899.358935]  [<c04a0ef7>] ? handle_mm_fault+0x957/0x9a0
[64899.358940]  [<c049e63d>] ? follow_page+0x6d/0x290
[64899.358944]  [<c04a1059>] ? __get_user_pages+0x119/0x3d0
[64899.358950]  [<c04c58cd>] ? get_arg_page+0x4d/0xb0
[64899.358956]  [<c0604d53>] ? strnlen_user+0x23/0x50
[64899.358961]  [<c04c59fc>] ? copy_strings+0xcc/0x190
[64899.358965]  [<c04c5ae1>] ? copy_strings_kernel+0x21/0x40
[64899.358969]  [<c04c6f01>] ? do_execve+0x181/0x250
[64899.358975]  [<c0408343>] ? sys_execve+0x33/0x70
[64899.358980]  [<c0402e0e>] ? ptregs_execve+0x12/0x18
[64899.358983]  [<c0402d53>] ? sysenter_do_call+0x12/0x22
[64930.940757] BUG: scheduling while atomic: make/10140/0x10000001
[64930.940761] Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput snd_hda_codec_intelhdmi arc4 snd_hda_codec_realtek ecb iwlagn snd_hda_intel iwlcore snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm mac80211 snd_timer snd soundcore cfg80211 rfkill iTCO_wdt snd_page_alloc uvcvideo iTCO_vendor_support wmi serio_raw videodev i2c_i801 joydev v4l1_compat pcspkr sha256_generic aes_i586 aes_generic cbc dm_crypt [last unloaded: scsi_wait_scan]
[64930.940804] Pid: 10140, comm: make Tainted: G          I 2.6.35-07956-g92fa5bd9 #164
[64930.940807] Call Trace:
[64930.940816]  [<c085306b>] ? schedule+0x30b/0x4c0
[64930.940822]  [<c048c7a1>] ? generic_file_aio_read+0x5d1/0x710
[64930.940826]  [<c0853329>] ? _cond_resched+0x29/0x40
[64930.940832]  [<c04a77b4>] ? anon_vma_prepare+0x14/0xd0
[64930.940836]  [<c04a3bac>] ? expand_downwards+0x1c/0x150
[64930.940842]  [<c0423c8b>] ? pte_alloc_one+0x1b/0x40
[64930.940846]  [<c04a0ef7>] ? handle_mm_fault+0x957/0x9a0
[64930.940850]  [<c049e63d>] ? follow_page+0x6d/0x290
[64930.940855]  [<c04a1059>] ? __get_user_pages+0x119/0x3d0
[64930.940860]  [<c04c58cd>] ? get_arg_page+0x4d/0xb0
[64930.940866]  [<c0604d53>] ? strnlen_user+0x23/0x50
[64930.940869]  [<c04c59fc>] ? copy_strings+0xcc/0x190
[64930.940874]  [<c04c5ae1>] ? copy_strings_kernel+0x21/0x40
[64930.940878]  [<c04c6f01>] ? do_execve+0x181/0x250
[64930.940883]  [<c0408343>] ? sys_execve+0x33/0x70
[64930.940887]  [<c0402e0e>] ? ptregs_execve+0x12/0x18
[64930.940891]  [<c0402d53>] ? sysenter_do_call+0x12/0x22
[64936.640448] BUG: scheduling while atomic: wish/10202/0x10000001
[64936.640452] Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput snd_hda_codec_intelhdmi arc4 snd_hda_codec_realtek ecb iwlagn snd_hda_intel iwlcore snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm mac80211 snd_timer snd soundcore cfg80211 rfkill iTCO_wdt snd_page_alloc uvcvideo iTCO_vendor_support wmi serio_raw videodev i2c_i801 joydev v4l1_compat pcspkr sha256_generic aes_i586 aes_generic cbc dm_crypt [last unloaded: scsi_wait_scan]
[64936.640496] Pid: 10202, comm: wish Tainted: G          I 2.6.35-07956-g92fa5bd9 #164
[64936.640499] Call Trace:
[64936.640509]  [<c085306b>] ? schedule+0x30b/0x4c0
[64936.640513]  [<c0853329>] ? _cond_resched+0x29/0x40
[64936.640519]  [<c04a77b4>] ? anon_vma_prepare+0x14/0xd0
[64936.640524]  [<c04a3bac>] ? expand_downwards+0x1c/0x150
[64936.640531]  [<c0423c8b>] ? pte_alloc_one+0x1b/0x40
[64936.640535]  [<c04a0ef7>] ? handle_mm_fault+0x957/0x9a0
[64936.640539]  [<c049e63d>] ? follow_page+0x6d/0x290
[64936.640544]  [<c04a1059>] ? __get_user_pages+0x119/0x3d0
[64936.640549]  [<c04c58cd>] ? get_arg_page+0x4d/0xb0
[64936.640555]  [<c0604d53>] ? strnlen_user+0x23/0x50
[64936.640559]  [<c04c59fc>] ? copy_strings+0xcc/0x190
[64936.640563]  [<c04c5ae1>] ? copy_strings_kernel+0x21/0x40
[64936.640567]  [<c04c6f01>] ? do_execve+0x181/0x250
[64936.640572]  [<c0408343>] ? sys_execve+0x33/0x70
[64936.640576]  [<c0402e0e>] ? ptregs_execve+0x12/0x18
[64936.640580]  [<c0402d53>] ? sysenter_do_call+0x12/0x22
[64936.643338] ------------[ cut here ]------------
[64936.643379] kernel BUG at arch/x86/mm/highmem_32.c:45!
[64936.643418] invalid opcode: 0000 [#1] 
[64936.643449] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/uevent
[64936.643515] Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput snd_hda_codec_intelhdmi arc4 snd_hda_codec_realtek ecb iwlagn snd_hda_intel iwlcore snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm mac80211 snd_timer snd soundcore cfg80211 rfkill iTCO_wdt snd_page_alloc uvcvideo iTCO_vendor_support wmi serio_raw videodev i2c_i801 joydev v4l1_compat pcspkr sha256_generic aes_i586 aes_generic cbc dm_crypt [last unloaded: scsi_wait_scan]
[64936.643515] 
[64936.643515] Pid: 21, comm: kswapd0 Tainted: G          I 2.6.35-07956-g92fa5bd9 #164 JM11-MS/Aspire 1810T
[64936.643515] EIP: 0060:[<c0424f4a>] EFLAGS: 00010206 CPU: 0
[64936.643515] EIP is at kmap_atomic_prot+0xba/0xc0
[64936.643515] EAX: c2161aa0 EBX: fffff000 ECX: 00000163 EDX: 00000007
[64936.643515] ESI: c0a9aecc EDI: 546a4163 EBP: f717dda4 ESP: f717dd24
[64936.643515]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[64936.643515] Process kswapd0 (pid: 21, ti=f717c000 task=f7137400 task.ti=f717c000)
[64936.643515] Stack:
[64936.643515]  f30f2380 c1ecee40 00000234 c04a72c9 f3123160 c1ecee40 00000000 c04a73cd
[64936.643515] <0> f717dd58 00000000 000000d0 f30f2380 0808d000 c049123d f3123160 c1ecee40
[64936.643515] <0> 0808d000 00000000 c04a875d f717dda4 f717de24 00000000 00000000 c18e6540
[64936.643515] Call Trace:
[64936.643515]  [<c04a72c9>] ? page_check_address+0x69/0x130
[64936.643515]  [<c04a73cd>] ? page_referenced_one+0x3d/0x130
[64936.643515]  [<c049123d>] ? __pagevec_free+0x1d/0x30
[64936.643515]  [<c04a875d>] ? page_referenced+0xfd/0x2c0
[64936.643515]  [<c0495cb9>] ? shrink_page_list+0x149/0x630
[64936.643515]  [<c0494f27>] ? move_active_pages_to_lru+0xa7/0x100
[64936.643515]  [<c04baeeb>] ? mem_cgroup_del_lru_list+0x1b/0x70
[64936.643515]  [<c0494d16>] ? isolate_lru_pages+0xa6/0x210
[64936.643515]  [<c0496284>] ? shrink_inactive_list+0xe4/0x300
[64936.643515]  [<c04968fb>] ? shrink_zone+0x45b/0x590
[64936.643515]  [<c0496fdf>] ? kswapd+0x50f/0x6e0
[64936.643515]  [<c0442500>] ? autoremove_wake_function+0x0/0x40
[64936.643515]  [<c0496ad0>] ? kswapd+0x0/0x6e0
[64936.643515]  [<c0442174>] ? kthread+0x74/0x80
[64936.643515]  [<c0442100>] ? kthread+0x0/0x80
[64936.643515]  [<c04032be>] ? kernel_thread_helper+0x6/0x18
[64936.643515] Code: 45 cf 2b 05 00 88 b2 c0 83 c2 45 c1 f8 05 c1 e2 0c c1 e0 0c 09 c1 89 d8 89 0e 29 d0 8b 1c 24 8b 74 24 04 8b 7c 24 08 83 c4 0c c3 <0f> 0b eb fe 66 90 8b 0d 04 60 aa c0 e9 35 ff ff ff 90 8d 74 26 
[64936.643515] EIP: [<c0424f4a>] kmap_atomic_prot+0xba/0xc0 SS:ESP 0068:f717dd24
[64936.643515] BUG: scheduling while atomic: kswapd0/21/0x00000001
[64936.643515] Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput snd_hda_codec_intelhdmi arc4 snd_hda_codec_realtek ecb iwlagn snd_hda_intel iwlcore snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm mac80211 snd_timer snd soundcore cfg80211 rfkill iTCO_wdt snd_page_alloc uvcvideo iTCO_vendor_support wmi serio_raw videodev i2c_i801 joydev v4l1_compat pcspkr sha256_generic aes_i586 aes_generic cbc dm_crypt [last unloaded: scsi_wait_scan]
[64936.643515] Pid: 21, comm: kswapd0 Tainted: G          I 2.6.35-07956-g92fa5bd9 #164
[64936.643515] Call Trace:
[64936.643515]  [<c085306b>] ? schedule+0x30b/0x4c0
[64936.643515]  [<c08535ed>] ? schedule_timeout+0xed/0x1b0
[64936.643515]  [<c04366b0>] ? process_timeout+0x0/0x10
[64936.643515]  [<c0436e25>] ? msleep+0x15/0x20
[64936.643515]  [<c06cc536>] ? g4x_disable_fbc+0x26/0x50
[64936.643515]  [<c06c7402>] ? intel_disable_fbc+0x12/0x20
[64936.643515]  [<c06cd0ae>] ? intel_pipe_set_base+0x3ae/0x480
[64936.643515]  [<c069e970>] ? drm_crtc_helper_set_config+0x700/0x910
[64936.643515]  [<c069b6c0>] ? drm_fb_helper_pan_display+0x70/0xb0
[64936.643515]  [<c069b650>] ? drm_fb_helper_pan_display+0x0/0xb0
[64936.643515]  [<c062ff3d>] ? fb_pan_display+0xfd/0x150
[64936.643515]  [<c063e74a>] ? bit_update_start+0x1a/0x40
[64936.643515]  [<c063b02c>] ? fbcon_switch+0x30c/0x480
[64936.643515]  [<c068a633>] ? redraw_screen+0x113/0x240
[64936.643515]  [<c0689b60>] ? vt_console_print+0x0/0x340
[64936.643515]  [<c063ac63>] ? fbcon_blank+0x203/0x2c0
[64936.643515]  [<c072eb80>] ? write_msg+0x0/0xd0
[64936.643515]  [<c0404687>] ? show_registers+0x87/0x1f0
[64936.643515]  [<c068af97>] ? do_unblank_screen+0xa7/0x1c0
[64936.643515]  [<c0605ca5>] ? bust_spinlocks+0x15/0x40
[64936.643515]  [<c085560e>] ? oops_end+0x2e/0xb0
[64936.643515]  [<c0403950>] ? do_invalid_op+0x0/0xa0
[64936.643515]  [<c04039cf>] ? do_invalid_op+0x7f/0xa0
[64936.643515]  [<c0424f4a>] ? kmap_atomic_prot+0xba/0xc0
[64936.643515]  [<c0760a7c>] ? psmouse_handle_byte+0xc/0x110
[64936.643515]  [<c0760d38>] ? psmouse_interrupt+0xb8/0x2e0
[64936.643515]  [<c07559be>] ? i8042_interrupt+0xfe/0x340
[64936.643515]  [<c0854b39>] ? error_code+0x65/0x6c
[64936.643515]  [<c0424f4a>] ? kmap_atomic_prot+0xba/0xc0
[64936.643515]  [<c04a72c9>] ? page_check_address+0x69/0x130
[64936.643515]  [<c04a73cd>] ? page_referenced_one+0x3d/0x130
[64936.643515]  [<c049123d>] ? __pagevec_free+0x1d/0x30
[64936.643515]  [<c04a875d>] ? page_referenced+0xfd/0x2c0
[64936.643515]  [<c0495cb9>] ? shrink_page_list+0x149/0x630
[64936.643515]  [<c0494f27>] ? move_active_pages_to_lru+0xa7/0x100
[64936.643515]  [<c04baeeb>] ? mem_cgroup_del_lru_list+0x1b/0x70
[64936.643515]  [<c0494d16>] ? isolate_lru_pages+0xa6/0x210
[64936.643515]  [<c0496284>] ? shrink_inactive_list+0xe4/0x300
[64936.643515]  [<c04968fb>] ? shrink_zone+0x45b/0x590
[64936.643515]  [<c0496fdf>] ? kswapd+0x50f/0x6e0
[64936.643515]  [<c0442500>] ? autoremove_wake_function+0x0/0x40
[64936.643515]  [<c0496ad0>] ? kswapd+0x0/0x6e0
[64936.643515]  [<c0442174>] ? kthread+0x74/0x80
[64936.643515]  [<c0442100>] ? kthread+0x0/0x80
[64936.643515]  [<c04032be>] ? kernel_thread_helper+0x6/0x18
[64936.727561] BUG: scheduling while atomic: wish/10202/0x10000001
[64936.728612] Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput snd_hda_codec_intelhdmi arc4 snd_hda_codec_realtek ecb iwlagn snd_hda_intel iwlcore snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm mac80211 snd_timer snd soundcore cfg80211 rfkill iTCO_wdt snd_page_alloc uvcvideo iTCO_vendor_support wmi serio_raw videodev i2c_i801 joydev v4l1_compat pcspkr sha256_generic aes_i586 aes_generic cbc dm_crypt [last unloaded: scsi_wait_scan]
[64936.733825] Pid: 10202, comm: wish Tainted: G          I 2.6.35-07956-g92fa5bd9 #164
[64936.735266] Call Trace:
[64936.736675]  [<c085306b>] ? schedule+0x30b/0x4c0
[64936.738114]  [<c0853329>] ? _cond_resched+0x29/0x40
[64936.739501]  [<c04a77b4>] ? anon_vma_prepare+0x14/0xd0
[64936.740899]  [<c04a3bac>] ? expand_downwards+0x1c/0x150
[64936.742284]  [<c0423c8b>] ? pte_alloc_one+0x1b/0x40
[64936.743710]  [<c04a0ef7>] ? handle_mm_fault+0x957/0x9a0
[64936.745126]  [<c049e63d>] ? follow_page+0x6d/0x290
[64936.746529]  [<c04a1059>] ? __get_user_pages+0x119/0x3d0
[64936.747957]  [<c04c58cd>] ? get_arg_page+0x4d/0xb0
[64936.749394]  [<c0604d53>] ? strnlen_user+0x23/0x50
[64936.750838]  [<c04c59fc>] ? copy_strings+0xcc/0x190
[64936.752247]  [<c04c5ae1>] ? copy_strings_kernel+0x21/0x40
[64936.753686]  [<c04c6f01>] ? do_execve+0x181/0x250
[64936.755121]  [<c0408343>] ? sys_execve+0x33/0x70
[64936.756536]  [<c0402e0e>] ? ptregs_execve+0x12/0x18
[64936.758012]  [<c0402d53>] ? sysenter_do_call+0x12/0x22
[64936.760793] ------------[ cut here ]------------
[64936.762250] kernel BUG at arch/x86/mm/highmem_32.c:45!
[64936.763512] invalid opcode: 0000 [#2] 
[64936.763512] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/uevent
[64936.763512] Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput snd_hda_codec_intelhdmi arc4 snd_hda_codec_realtek ecb iwlagn snd_hda_intel iwlcore snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm mac80211 snd_timer snd soundcore cfg80211 rfkill iTCO_wdt snd_page_alloc uvcvideo iTCO_vendor_support wmi serio_raw videodev i2c_i801 joydev v4l1_compat pcspkr sha256_generic aes_i586 aes_generic cbc dm_crypt [last unloaded: scsi_wait_scan]
[64936.763512] 
[64936.763512] Pid: 8003, comm: rsyslogd Tainted: G          I 2.6.35-07956-g92fa5bd9 #164 JM11-MS/Aspire 1810T
[64936.763512] EIP: 0060:[<c0424f4a>] EFLAGS: 00010206 CPU: 0
[64936.763512] EIP is at kmap_atomic_prot+0xba/0xc0
[64936.763512] EAX: c2141bc0 EBX: fffff000 ECX: 00000163 EDX: 00000007
[64936.763512] ESI: c0a9aecc EDI: 546a4163 EBP: 00000fd8 ESP: ef1f9ee0
[64936.763512]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[64936.763512] Process rsyslogd (pid: 8003, ti=ef1f8000 task=f0888400 task.ti=ef1f8000)
[64936.763512] Stack:
[64936.763512]  f4ffb210 f4ffb210 4f3f6e60 c04a0625 00000081 00000000 00000001 ffffffff
[64936.763512] <0> f4371d00 00000000 f4dcf380 f4ff84f0 00000000 f0888400 00000000 00000000
[64936.763512] <0> 00007b98 c04eb9aa ef1f9fb4 f4ffb210 c0857060 4f3f6e60 c0857184 00000000
[64936.763512] Call Trace:
[64936.763512]  [<c04a0625>] ? handle_mm_fault+0x85/0x9a0
[64936.763512]  [<c04eb9aa>] ? fsnotify+0x18a/0x2c0
[64936.763512]  [<c0857060>] ? do_page_fault+0x0/0x3f0
[64936.763512]  [<c0857184>] ? do_page_fault+0x124/0x3f0
[64936.763512]  [<c04c0ea3>] ? vfs_write+0x103/0x170
[64936.763512]  [<c046e975>] ? audit_syscall_exit+0x1f5/0x220
[64936.763512]  [<c0857060>] ? do_page_fault+0x0/0x3f0
[64936.763512]  [<c0854b39>] ? error_code+0x65/0x6c
[64936.763512] Code: 45 cf 2b 05 00 88 b2 c0 83 c2 45 c1 f8 05 c1 e2 0c c1 e0 0c 09 c1 89 d8 89 0e 29 d0 8b 1c 24 8b 74 24 04 8b 7c 24 08 83 c4 0c c3 <0f> 0b eb fe 66 90 8b 0d 04 60 aa c0 e9 35 ff ff ff 90 8d 74 26 
[64936.763512] EIP: [<c0424f4a>] kmap_atomic_prot+0xba/0xc0 SS:ESP 0068:ef1f9ee0
[64936.819943] ---[ end trace a7919e7f17c0a727 ]---
[64936.821858] note: rsyslogd[8003] exited with preempt_count 1
[64936.823730] BUG: scheduling while atomic: rsyslogd/8003/0x10000001
[64936.825607] Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput snd_hda_codec_intelhdmi arc4 snd_hda_codec_realtek ecb iwlagn snd_hda_intel iwlcore snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm mac80211 snd_timer snd soundcore cfg80211 rfkill iTCO_wdt snd_page_alloc uvcvideo iTCO_vendor_support wmi serio_raw videodev i2c_i801 joydev v4l1_compat pcspkr sha256_generic aes_i586 aes_generic cbc dm_crypt [last unloaded: scsi_wait_scan]
[64936.834231] Pid: 8003, comm: rsyslogd Tainted: G      D   I 2.6.35-07956-g92fa5bd9 #164
[64936.836425] Call Trace:
[64936.838688]  [<c085306b>] ? schedule+0x30b/0x4c0
[64936.840917]  [<c042d08b>] ? vprintk+0x13b/0x420
[64936.843116]  [<c0853329>] ? _cond_resched+0x29/0x40
[64936.845334]  [<c0451785>] ? exit_robust_list+0x45/0x140
[64936.847560]  [<c042a74a>] ? mm_release+0xda/0xf0
[64936.849791]  [<c042f6e6>] ? exit_mm+0x16/0xd0
[64936.852045]  [<c042f9f6>] ? do_exit+0xd6/0x670
[64936.854248]  [<c0852c0e>] ? printk+0x27/0x31
[64936.856428]  [<c0855653>] ? oops_end+0x73/0xb0
[64936.858606]  [<c0403950>] ? do_invalid_op+0x0/0xa0
[64936.860804]  [<c04039cf>] ? do_invalid_op+0x7f/0xa0
[64936.862885]  [<c0424f4a>] ? kmap_atomic_prot+0xba/0xc0
[64936.864889]  [<c048d1e4>] ? __generic_file_aio_write+0x204/0x4e0
[64936.866836]  [<c0854b39>] ? error_code+0x65/0x6c
[64936.868723]  [<c0424f4a>] ? kmap_atomic_prot+0xba/0xc0
[64936.870628]  [<c04a0625>] ? handle_mm_fault+0x85/0x9a0
[64936.872481]  [<c04eb9aa>] ? fsnotify+0x18a/0x2c0
[64936.874319]  [<c0857060>] ? do_page_fault+0x0/0x3f0
[64936.876140]  [<c0857184>] ? do_page_fault+0x124/0x3f0
[64936.877939]  [<c04c0ea3>] ? vfs_write+0x103/0x170
[64936.879730]  [<c046e975>] ? audit_syscall_exit+0x1f5/0x220
[64936.881537]  [<c0857060>] ? do_page_fault+0x0/0x3f0
[64936.883314]  [<c0854b39>] ? error_code+0x65/0x6c
[64936.885151] ------------[ cut here ]------------
[64936.886863] kernel BUG at arch/x86/mm/highmem_32.c:45!
[64936.888391] invalid opcode: 0000 [#3] 
[64936.888391] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/uevent
[64936.888391] Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput snd_hda_codec_intelhdmi arc4 snd_hda_codec_realtek ecb iwlagn snd_hda_intel iwlcore snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm mac80211 snd_timer snd soundcore cfg80211 rfkill iTCO_wdt snd_page_alloc uvcvideo iTCO_vendor_support wmi serio_raw videodev i2c_i801 joydev v4l1_compat pcspkr sha256_generic aes_i586 aes_generic cbc dm_crypt [last unloaded: scsi_wait_scan]
[64936.888391] 
[64936.888391] Pid: 4108, comm: rsyslogd Tainted: G      D   I 2.6.35-07956-g92fa5bd9 #164 JM11-MS/Aspire 1810T
[64936.888391] EIP: 0060:[<c0424f4a>] EFLAGS: 00010206 CPU: 0
[64936.888391] EIP is at kmap_atomic_prot+0xba/0xc0
[64936.888391] EAX: c215b180 EBX: fffff000 ECX: 00000163 EDX: 00000007
[64936.888391] ESI: c0a9aecc EDI: 546a4163 EBP: 00000414 ESP: f1b59ee0
[64936.888391]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[64936.888391] Process rsyslogd (pid: 4108, ti=f1b58000 task=ef0a7400 task.ti=f1b58000)
[64936.888391] Stack:
[64936.888391]  f68e39f8 f68e39f8 b5d05014 c04a0625 c0450ccd c0ad6d9c 00000001 c045310a
[64936.888391] <0> ef0a7400 ef0a7400 f4dcf380 f4ff8b5c b34bd0af 0000012f 4bf8bb17 ffd9cc4f
[64936.888391] <0> ffffffff 000000a1 f1b59fb4 f68e39f8 c0857060 b5d05014 c0857184 00000001
[64936.888391] Call Trace:
[64936.888391]  [<c04a0625>] ? handle_mm_fault+0x85/0x9a0
[64936.888391]  [<c0450ccd>] ? wake_futex+0x2d/0x60
[64936.888391]  [<c045310a>] ? do_futex+0x59a/0x900
[64936.888391]  [<c0857060>] ? do_page_fault+0x0/0x3f0
[64936.888391]  [<c0857184>] ? do_page_fault+0x124/0x3f0
[64936.888391]  [<c0426fc7>] ? put_prev_task_fair+0xe7/0x120
[64936.888391]  [<c0427429>] ? pick_next_task_fair+0xf9/0x120
[64936.888391]  [<c044a326>] ? getnstimeofday+0x46/0xf0
[64936.888391]  [<c046e975>] ? audit_syscall_exit+0x1f5/0x220
[64936.888391]  [<c0857060>] ? do_page_fault+0x0/0x3f0
[64936.888391]  [<c0854b39>] ? error_code+0x65/0x6c
[64936.888391] Code: 45 cf 2b 05 00 88 b2 c0 83 c2 45 c1 f8 05 c1 e2 0c c1 e0 0c 09 c1 89 d8 89 0e 29 d0 8b 1c 24 8b 74 24 04 8b 7c 24 08 83 c4 0c c3 <0f> 0b eb fe 66 90 8b 0d 04 60 aa c0 e9 35 ff ff ff 90 8d 74 26 
[64936.888391] EIP: [<c0424f4a>] kmap_atomic_prot+0xba/0xc0 SS:ESP 0068:f1b59ee0
[64936.949777] ---[ end trace a7919e7f17c0a728 ]---
[64936.951695] note: rsyslogd[4108] exited with preempt_count 1
[64936.953562] BUG: scheduling while atomic: rsyslogd/4108/0x10000001
[64936.955435] Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput snd_hda_codec_intelhdmi arc4 snd_hda_codec_realtek ecb iwlagn snd_hda_intel iwlcore snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm mac80211 snd_timer snd soundcore cfg80211 rfkill iTCO_wdt snd_page_alloc uvcvideo iTCO_vendor_support wmi serio_raw videodev i2c_i801 joydev v4l1_compat pcspkr sha256_generic aes_i586 aes_generic cbc dm_crypt [last unloaded: scsi_wait_scan]
[64936.964052] Pid: 4108, comm: rsyslogd Tainted: G      D   I 2.6.35-07956-g92fa5bd9 #164
[64936.966246] Call Trace:
[64936.968486]  [<c085306b>] ? schedule+0x30b/0x4c0
[64936.970716]  [<c042d08b>] ? vprintk+0x13b/0x420
[64936.972910]  [<c0853329>] ? _cond_resched+0x29/0x40
[64936.975128]  [<c0451785>] ? exit_robust_list+0x45/0x140
[64936.977331]  [<c042a74a>] ? mm_release+0xda/0xf0
[64936.979518]  [<c042f6e6>] ? exit_mm+0x16/0xd0
[64936.981701]  [<c042f9f6>] ? do_exit+0xd6/0x670
[64936.983866]  [<c0852c0e>] ? printk+0x27/0x31
[64936.985947]  [<c0855653>] ? oops_end+0x73/0xb0
[64936.987972]  [<c0403950>] ? do_invalid_op+0x0/0xa0
[64936.989942]  [<c04039cf>] ? do_invalid_op+0x7f/0xa0
[64936.991807]  [<c0424f4a>] ? kmap_atomic_prot+0xba/0xc0
[64936.993666]  [<c05ebca8>] ? __blk_run_queue+0x18/0x60
[64936.995487]  [<c06faa37>] ? scsi_run_queue+0xc7/0x200
[64936.997296]  [<c06f5859>] ? __scsi_put_command+0x29/0x60
[64936.999092]  [<c06f5859>] ? __scsi_put_command+0x29/0x60
[64937.000878]  [<c0426d1b>] ? enqueue_entity+0x12b/0x180
[64937.002693]  [<c0854b39>] ? error_code+0x65/0x6c
[64937.004505]  [<c042007b>] ? generic_load_microcode+0x13b/0x410
[64937.006301]  [<c0424f4a>] ? kmap_atomic_prot+0xba/0xc0
[64937.008046]  [<c04a0625>] ? handle_mm_fault+0x85/0x9a0
[64937.009747]  [<c0450ccd>] ? wake_futex+0x2d/0x60
[64937.011452]  [<c045310a>] ? do_futex+0x59a/0x900
[64937.013142]  [<c0857060>] ? do_page_fault+0x0/0x3f0
[64937.014791]  [<c0857184>] ? do_page_fault+0x124/0x3f0
[64937.016432]  [<c0426fc7>] ? put_prev_task_fair+0xe7/0x120
[64937.018084]  [<c0427429>] ? pick_next_task_fair+0xf9/0x120
[64937.019761]  [<c044a326>] ? getnstimeofday+0x46/0xf0
[64937.021432]  [<c046e975>] ? audit_syscall_exit+0x1f5/0x220
[64937.023113]  [<c0857060>] ? do_page_fault+0x0/0x3f0
[64937.024818]  [<c0854b39>] ? error_code+0x65/0x6c
[64937.026668] BUG: scheduling while atomic: kswapd0/21/0x00000001
[64937.028371] Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput snd_hda_codec_intelhdmi arc4 snd_hda_codec_realtek ecb iwlagn snd_hda_intel iwlcore snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm mac80211 snd_timer snd soundcore cfg80211 rfkill iTCO_wdt snd_page_alloc uvcvideo iTCO_vendor_support wmi serio_raw videodev i2c_i801 joydev v4l1_compat pcspkr sha256_generic aes_i586 aes_generic cbc dm_crypt [last unloaded: scsi_wait_scan]
[64937.036136] Pid: 21, comm: kswapd0 Tainted: G      D   I 2.6.35-07956-g92fa5bd9 #164
[64937.038014] Call Trace:
[64937.039855]  [<c085306b>] ? schedule+0x30b/0x4c0
[64937.041717]  [<c08535f4>] ? schedule_timeout+0xf4/0x1b0
[64937.043604]  [<c08535ed>] ? schedule_timeout+0xed/0x1b0
[64937.045401]  [<c04366b0>] ? process_timeout+0x0/0x10
[64937.047163]  [<c04366b0>] ? process_timeout+0x0/0x10
[64937.048816]  [<c0436e25>] ? msleep+0x15/0x20
[64937.050416]  [<c06ccfa6>] ? intel_pipe_set_base+0x2a6/0x480
[64937.051926]  [<c069e970>] ? drm_crtc_helper_set_config+0x700/0x910
[64937.053435]  [<c069b6c0>] ? drm_fb_helper_pan_display+0x70/0xb0
[64937.054928]  [<c069b650>] ? drm_fb_helper_pan_display+0x0/0xb0
[64937.056408]  [<c062ff3d>] ? fb_pan_display+0xfd/0x150
[64937.057893]  [<c063e74a>] ? bit_update_start+0x1a/0x40
[64937.059373]  [<c063b02c>] ? fbcon_switch+0x30c/0x480
[64937.060874]  [<c068a633>] ? redraw_screen+0x113/0x240
[64937.062333]  [<c0689b60>] ? vt_console_print+0x0/0x340
[64937.063818]  [<c063ac63>] ? fbcon_blank+0x203/0x2c0
[64937.065291]  [<c072eb80>] ? write_msg+0x0/0xd0
[64937.066766]  [<c0404687>] ? show_registers+0x87/0x1f0
[64937.068281]  [<c068af97>] ? do_unblank_screen+0xa7/0x1c0
[64937.069784]  [<c0605ca5>] ? bust_spinlocks+0x15/0x40
[64937.071315]  [<c085560e>] ? oops_end+0x2e/0xb0
[64937.072820]  [<c0403950>] ? do_invalid_op+0x0/0xa0
[64937.074324]  [<c04039cf>] ? do_invalid_op+0x7f/0xa0
[64937.075812]  [<c0424f4a>] ? kmap_atomic_prot+0xba/0xc0
[64937.077310]  [<c0760a7c>] ? psmouse_handle_byte+0xc/0x110
[64937.078836]  [<c0760d38>] ? psmouse_interrupt+0xb8/0x2e0
[64937.080354]  [<c07559be>] ? i8042_interrupt+0xfe/0x340
[64937.081862]  [<c0854b39>] ? error_code+0x65/0x6c
[64937.083363]  [<c0424f4a>] ? kmap_atomic_prot+0xba/0xc0
[64937.084881]  [<c04a72c9>] ? page_check_address+0x69/0x130
[64937.086380]  [<c04a73cd>] ? page_referenced_one+0x3d/0x130
[64937.087888]  [<c049123d>] ? __pagevec_free+0x1d/0x30
[64937.089387]  [<c04a875d>] ? page_referenced+0xfd/0x2c0
[64937.090916]  [<c0495cb9>] ? shrink_page_list+0x149/0x630
[64937.092427]  [<c0494f27>] ? move_active_pages_to_lru+0xa7/0x100
[64937.093973]  [<c04baeeb>] ? mem_cgroup_del_lru_list+0x1b/0x70
[64937.095495]  [<c0494d16>] ? isolate_lru_pages+0xa6/0x210
[64937.097040]  [<c0496284>] ? shrink_inactive_list+0xe4/0x300
[64937.098571]  [<c04968fb>] ? shrink_zone+0x45b/0x590
[64937.100092]  [<c0496fdf>] ? kswapd+0x50f/0x6e0
[64937.101639]  [<c0442500>] ? autoremove_wake_function+0x0/0x40
[64937.103155]  [<c0496ad0>] ? kswapd+0x0/0x6e0
[64937.104620]  [<c0442174>] ? kthread+0x74/0x80
[64937.105982]  [<c0442100>] ? kthread+0x0/0x80
[64937.107308]  [<c04032be>] ? kernel_thread_helper+0x6/0x18
[64937.131163] BUG: scheduling while atomic: kswapd0/21/0x10000001
[64937.132370] Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput snd_hda_codec_intelhdmi arc4 snd_hda_codec_realtek ecb iwlagn snd_hda_intel iwlcore snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm mac80211 snd_timer snd soundcore cfg80211 rfkill iTCO_wdt snd_page_alloc uvcvideo iTCO_vendor_support wmi serio_raw videodev i2c_i801 joydev v4l1_compat pcspkr sha256_generic aes_i586 aes_generic cbc dm_crypt [last unloaded: scsi_wait_scan]
[64937.138178] Pid: 21, comm: kswapd0 Tainted: G      D   I 2.6.35-07956-g92fa5bd9 #164
[64937.139697] Call Trace:
[64937.141253]  [<c085306b>] ? schedule+0x30b/0x4c0
[64937.142792]  [<c0638f3a>] ? get_color+0x2a/0x120
[64937.144337]  [<c0853329>] ? _cond_resched+0x29/0x40
[64937.145893]  [<c0853ac8>] ? mutex_lock+0x8/0x20
[64937.147430]  [<c069b674>] ? drm_fb_helper_pan_display+0x24/0xb0
[64937.148987]  [<c069b650>] ? drm_fb_helper_pan_display+0x0/0xb0
[64937.150537]  [<c062ff3d>] ? fb_pan_display+0xfd/0x150
[64937.152064]  [<c063e74a>] ? bit_update_start+0x1a/0x40
[64937.153608]  [<c063b02c>] ? fbcon_switch+0x30c/0x480
[64937.155141]  [<c068a633>] ? redraw_screen+0x113/0x240
[64937.156684]  [<c068b066>] ? do_unblank_screen+0x176/0x1c0
[64937.158248]  [<c0605ca5>] ? bust_spinlocks+0x15/0x40
[64937.159800]  [<c085560e>] ? oops_end+0x2e/0xb0
[64937.161352]  [<c0403950>] ? do_invalid_op+0x0/0xa0
[64937.162884]  [<c04039cf>] ? do_invalid_op+0x7f/0xa0
[64937.164445]  [<c0424f4a>] ? kmap_atomic_prot+0xba/0xc0
[64937.165962]  [<c0760a7c>] ? psmouse_handle_byte+0xc/0x110
[64937.167503]  [<c0760d38>] ? psmouse_interrupt+0xb8/0x2e0
[64937.169030]  [<c07559be>] ? i8042_interrupt+0xfe/0x340
[64937.170574]  [<c0854b39>] ? error_code+0x65/0x6c
[64937.172103]  [<c0424f4a>] ? kmap_atomic_prot+0xba/0xc0
[64937.173655]  [<c04a72c9>] ? page_check_address+0x69/0x130
[64937.175195]  [<c04a73cd>] ? page_referenced_one+0x3d/0x130
[64937.176740]  [<c049123d>] ? __pagevec_free+0x1d/0x30
[64937.178295]  [<c04a875d>] ? page_referenced+0xfd/0x2c0
[64937.179841]  [<c0495cb9>] ? shrink_page_list+0x149/0x630
[64937.181385]  [<c0494f27>] ? move_active_pages_to_lru+0xa7/0x100
[64937.182929]  [<c04baeeb>] ? mem_cgroup_del_lru_list+0x1b/0x70
[64937.184495]  [<c0494d16>] ? isolate_lru_pages+0xa6/0x210
[64937.186042]  [<c0496284>] ? shrink_inactive_list+0xe4/0x300
[64937.187600]  [<c04968fb>] ? shrink_zone+0x45b/0x590
[64937.189142]  [<c0496fdf>] ? kswapd+0x50f/0x6e0
[64937.190687]  [<c0442500>] ? autoremove_wake_function+0x0/0x40
[64937.192222]  [<c0496ad0>] ? kswapd+0x0/0x6e0
[64937.193762]  [<c0442174>] ? kthread+0x74/0x80
[64937.195295]  [<c0442100>] ? kthread+0x0/0x80
[64937.196816]  [<c04032be>] ? kernel_thread_helper+0x6/0x18
[64937.223910] ---[ end trace a7919e7f17c0a729 ]---
[64937.223916] note: kswapd0[21] exited with preempt_count 1
[64937.223929] BUG: scheduling while atomic: kswapd0/21/0x10000001
[64937.223931] Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput snd_hda_codec_intelhdmi arc4 snd_hda_codec_realtek ecb iwlagn snd_hda_intel iwlcore snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm mac80211 snd_timer snd soundcore cfg80211 rfkill iTCO_wdt snd_page_alloc uvcvideo iTCO_vendor_support wmi serio_raw videodev i2c_i801 joydev v4l1_compat pcspkr sha256_generic aes_i586 aes_generic cbc dm_crypt [last unloaded: scsi_wait_scan]
[64937.223976] Pid: 21, comm: kswapd0 Tainted: G      D   I 2.6.35-07956-g92fa5bd9 #164
[64937.223979] Call Trace:
[64937.223988]  [<c085306b>] ? schedule+0x30b/0x4c0
[64937.223993]  [<c042a6be>] ? mm_release+0x4e/0xf0
[64937.223997]  [<c0853329>] ? _cond_resched+0x29/0x40
[64937.224003]  [<c0446837>] ? switch_task_namespaces+0x17/0x60
[64937.224008]  [<c042fcb7>] ? do_exit+0x397/0x670
[64937.224013]  [<c0855653>] ? oops_end+0x73/0xb0
[64937.224017]  [<c0403950>] ? do_invalid_op+0x0/0xa0
[64937.224021]  [<c04039cf>] ? do_invalid_op+0x7f/0xa0
[64937.224027]  [<c0424f4a>] ? kmap_atomic_prot+0xba/0xc0
[64937.224033]  [<c0760a7c>] ? psmouse_handle_byte+0xc/0x110
[64937.224037]  [<c0760d38>] ? psmouse_interrupt+0xb8/0x2e0
[64937.224043]  [<c07559be>] ? i8042_interrupt+0xfe/0x340
[64937.224047]  [<c0854b39>] ? error_code+0x65/0x6c
[64937.224051]  [<c0424f4a>] ? kmap_atomic_prot+0xba/0xc0
[64937.224057]  [<c04a72c9>] ? page_check_address+0x69/0x130
[64937.224062]  [<c04a73cd>] ? page_referenced_one+0x3d/0x130
[64937.224067]  [<c049123d>] ? __pagevec_free+0x1d/0x30
[64937.224072]  [<c04a875d>] ? page_referenced+0xfd/0x2c0
[64937.224077]  [<c0495cb9>] ? shrink_page_list+0x149/0x630
[64937.224082]  [<c0494f27>] ? move_active_pages_to_lru+0xa7/0x100
[64937.224088]  [<c04baeeb>] ? mem_cgroup_del_lru_list+0x1b/0x70
[64937.224092]  [<c0494d16>] ? isolate_lru_pages+0xa6/0x210
[64937.224097]  [<c0496284>] ? shrink_inactive_list+0xe4/0x300
[64937.224102]  [<c04968fb>] ? shrink_zone+0x45b/0x590
[64937.224107]  [<c0496fdf>] ? kswapd+0x50f/0x6e0
[64937.224114]  [<c0442500>] ? autoremove_wake_function+0x0/0x40
[64937.224118]  [<c0496ad0>] ? kswapd+0x0/0x6e0
[64937.224122]  [<c0442174>] ? kthread+0x74/0x80
[64937.224127]  [<c0442100>] ? kthread+0x0/0x80
[64937.224130]  [<c04032be>] ? kernel_thread_helper+0x6/0x18
[64964.983526] BUG: scheduling while atomic: sh/11113/0x10000001
[64964.983529] Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput snd_hda_codec_intelhdmi arc4 snd_hda_codec_realtek ecb iwlagn snd_hda_intel iwlcore snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm mac80211 snd_timer snd soundcore cfg80211 rfkill iTCO_wdt snd_page_alloc uvcvideo iTCO_vendor_support wmi serio_raw videodev i2c_i801 joydev v4l1_compat pcspkr sha256_generic aes_i586 aes_generic cbc dm_crypt [last unloaded: scsi_wait_scan]
[64964.983564] Pid: 11113, comm: sh Tainted: G      D   I 2.6.35-07956-g92fa5bd9 #164
[64964.983566] Call Trace:
[64964.983576]  [<c085306b>] ? schedule+0x30b/0x4c0
[64964.983580]  [<c0853329>] ? _cond_resched+0x29/0x40
[64964.983586]  [<c04a77b4>] ? anon_vma_prepare+0x14/0xd0
[64964.983590]  [<c04a3bac>] ? expand_downwards+0x1c/0x150
[64964.983596]  [<c0418713>] ? smp_apic_timer_interrupt+0x43/0x80
[64964.983600]  [<c08548dd>] ? apic_timer_interrupt+0x31/0x38
[64964.983604]  [<c04a0ef7>] ? handle_mm_fault+0x957/0x9a0
[64964.983608]  [<c049e82c>] ? follow_page+0x25c/0x290
[64964.983612]  [<c04a1059>] ? __get_user_pages+0x119/0x3d0
[64964.983616]  [<c04c58cd>] ? get_arg_page+0x4d/0xb0
[64964.983623]  [<c0605015>] ? _copy_from_user+0x35/0x120
[64964.983627]  [<c04c59fc>] ? copy_strings+0xcc/0x190
[64964.983631]  [<c04c6f26>] ? do_execve+0x1a6/0x250
[64964.983635]  [<c0408343>] ? sys_execve+0x33/0x70
[64964.983639]  [<c0402e0e>] ? ptregs_execve+0x12/0x18
[64964.983642]  [<c0402d53>] ? sysenter_do_call+0x12/0x22
[65087.533524] BUG: scheduling while atomic: gcc/12086/0x10000001
[65087.533529] Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput snd_hda_codec_intelhdmi arc4 snd_hda_codec_realtek ecb iwlagn snd_hda_intel iwlcore snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm mac80211 snd_timer snd soundcore cfg80211 rfkill iTCO_wdt snd_page_alloc uvcvideo iTCO_vendor_support wmi serio_raw videodev i2c_i801 joydev v4l1_compat pcspkr sha256_generic aes_i586 aes_generic cbc dm_crypt [last unloaded: scsi_wait_scan]
[65087.533573] Pid: 12086, comm: gcc Tainted: G      D   I 2.6.35-07956-g92fa5bd9 #164
[65087.533576] Call Trace:
[65087.533586]  [<c085306b>] ? schedule+0x30b/0x4c0
[65087.533592]  [<c048c7a1>] ? generic_file_aio_read+0x5d1/0x710
[65087.533596]  [<c0853329>] ? _cond_resched+0x29/0x40
[65087.533601]  [<c04a77b4>] ? anon_vma_prepare+0x14/0xd0
[65087.533606]  [<c04a3bac>] ? expand_downwards+0x1c/0x150
[65087.533612]  [<c0423c8b>] ? pte_alloc_one+0x1b/0x40
[65087.533616]  [<c04a0ef7>] ? handle_mm_fault+0x957/0x9a0
[65087.533621]  [<c049e63d>] ? follow_page+0x6d/0x290
[65087.533625]  [<c04a1059>] ? __get_user_pages+0x119/0x3d0
[65087.533631]  [<c04c58cd>] ? get_arg_page+0x4d/0xb0
[65087.533637]  [<c0604d53>] ? strnlen_user+0x23/0x50
[65087.533641]  [<c04c59fc>] ? copy_strings+0xcc/0x190
[65087.533646]  [<c04c5ae1>] ? copy_strings_kernel+0x21/0x40
[65087.533650]  [<c04c6f01>] ? do_execve+0x181/0x250
[65087.533656]  [<c0408343>] ? sys_execve+0x33/0x70
[65087.533660]  [<c0402e0e>] ? ptregs_execve+0x12/0x18
[65087.533664]  [<c0402d53>] ? sysenter_do_call+0x12/0x22
[65089.280190] BUG: scheduling while atomic: sh/12161/0x10000001
[65089.280195] Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput snd_hda_codec_intelhdmi arc4 snd_hda_codec_realtek ecb iwlagn snd_hda_intel iwlcore snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm mac80211 snd_timer snd soundcore cfg80211 rfkill iTCO_wdt snd_page_alloc uvcvideo iTCO_vendor_support wmi serio_raw videodev i2c_i801 joydev v4l1_compat pcspkr sha256_generic aes_i586 aes_generic cbc dm_crypt [last unloaded: scsi_wait_scan]
[65089.280240] Pid: 12161, comm: sh Tainted: G      D   I 2.6.35-07956-g92fa5bd9 #164
[65089.280243] Call Trace:
[65089.280253]  [<c085306b>] ? schedule+0x30b/0x4c0
[65089.280259]  [<c048c7a1>] ? generic_file_aio_read+0x5d1/0x710
[65089.280263]  [<c0853329>] ? _cond_resched+0x29/0x40
[65089.280268]  [<c04a77b4>] ? anon_vma_prepare+0x14/0xd0
[65089.280273]  [<c04a3bac>] ? expand_downwards+0x1c/0x150
[65089.280279]  [<c0423c8b>] ? pte_alloc_one+0x1b/0x40
[65089.280283]  [<c04a0ef7>] ? handle_mm_fault+0x957/0x9a0
[65089.280288]  [<c049e63d>] ? follow_page+0x6d/0x290
[65089.280292]  [<c04a1059>] ? __get_user_pages+0x119/0x3d0
[65089.280298]  [<c04c58cd>] ? get_arg_page+0x4d/0xb0
[65089.280305]  [<c0604d53>] ? strnlen_user+0x23/0x50
[65089.280309]  [<c04c59fc>] ? copy_strings+0xcc/0x190
[65089.280313]  [<c04c5ae1>] ? copy_strings_kernel+0x21/0x40
[65089.280317]  [<c04c6f01>] ? do_execve+0x181/0x250
[65089.280323]  [<c0408343>] ? sys_execve+0x33/0x70
[65089.280327]  [<c0402e0e>] ? ptregs_execve+0x12/0x18
[65089.280331]  [<c0402d53>] ? sysenter_do_call+0x12/0x22
[65090.213531] BUG: scheduling while atomic: sh/12208/0x10000001
[65090.213536] Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput snd_hda_codec_intelhdmi arc4 snd_hda_codec_realtek ecb iwlagn snd_hda_intel iwlcore snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm mac80211 snd_timer snd soundcore cfg80211 rfkill iTCO_wdt snd_page_alloc uvcvideo iTCO_vendor_support wmi serio_raw videodev i2c_i801 joydev v4l1_compat pcspkr sha256_generic aes_i586 aes_generic cbc dm_crypt [last unloaded: scsi_wait_scan]
[65090.213580] Pid: 12208, comm: sh Tainted: G      D   I 2.6.35-07956-g92fa5bd9 #164
[65090.213583] Call Trace:
[65090.213592]  [<c085306b>] ? schedule+0x30b/0x4c0
[65090.213597]  [<c048c7a1>] ? generic_file_aio_read+0x5d1/0x710
[65090.213601]  [<c0853329>] ? _cond_resched+0x29/0x40
[65090.213607]  [<c04a77b4>] ? anon_vma_prepare+0x14/0xd0
[65090.213611]  [<c04a3bac>] ? expand_downwards+0x1c/0x150
[65090.213618]  [<c0423c8b>] ? pte_alloc_one+0x1b/0x40
[65090.213623]  [<c04a0ef7>] ? handle_mm_fault+0x957/0x9a0
[65090.213627]  [<c049e63d>] ? follow_page+0x6d/0x290
[65090.213632]  [<c04a1059>] ? __get_user_pages+0x119/0x3d0
[65090.213637]  [<c04c58cd>] ? get_arg_page+0x4d/0xb0
[65090.213644]  [<c0604d53>] ? strnlen_user+0x23/0x50
[65090.213648]  [<c04c59fc>] ? copy_strings+0xcc/0x190
[65090.213652]  [<c04c5ae1>] ? copy_strings_kernel+0x21/0x40
[65090.213656]  [<c04c6f01>] ? do_execve+0x181/0x250
[65090.213662]  [<c0408343>] ? sys_execve+0x33/0x70
[65090.213666]  [<c0402e0e>] ? ptregs_execve+0x12/0x18
[65090.213670]  [<c0402d53>] ? sysenter_do_call+0x12/0x22
[65099.983521] BUG: scheduling while atomic: make/12632/0x10000001
[65099.983526] Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput snd_hda_codec_intelhdmi arc4 snd_hda_codec_realtek ecb iwlagn snd_hda_intel iwlcore snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm mac80211 snd_timer snd soundcore cfg80211 rfkill iTCO_wdt snd_page_alloc uvcvideo iTCO_vendor_support wmi serio_raw videodev i2c_i801 joydev v4l1_compat pcspkr sha256_generic aes_i586 aes_generic cbc dm_crypt [last unloaded: scsi_wait_scan]
[65099.983575] Pid: 12632, comm: make Tainted: G      D   I 2.6.35-07956-g92fa5bd9 #164
[65099.983578] Call Trace:
[65099.983587]  [<c085306b>] ? schedule+0x30b/0x4c0
[65099.983592]  [<c048c7a1>] ? generic_file_aio_read+0x5d1/0x710
[65099.983596]  [<c0853329>] ? _cond_resched+0x29/0x40
[65099.983602]  [<c04a77b4>] ? anon_vma_prepare+0x14/0xd0
[65099.983606]  [<c04a3bac>] ? expand_downwards+0x1c/0x150
[65099.983612]  [<c0423c8b>] ? pte_alloc_one+0x1b/0x40
[65099.983617]  [<c04a0ef7>] ? handle_mm_fault+0x957/0x9a0
[65099.983621]  [<c049e63d>] ? follow_page+0x6d/0x290
[65099.983625]  [<c04a1059>] ? __get_user_pages+0x119/0x3d0
[65099.983631]  [<c04c58cd>] ? get_arg_page+0x4d/0xb0
[65099.983637]  [<c0604d53>] ? strnlen_user+0x23/0x50
[65099.983641]  [<c04c59fc>] ? copy_strings+0xcc/0x190
[65099.983645]  [<c04c5ae1>] ? copy_strings_kernel+0x21/0x40
[65099.983649]  [<c04c6f01>] ? do_execve+0x181/0x250
[65099.983654]  [<c0408343>] ? sys_execve+0x33/0x70
[65099.983658]  [<c0402e0e>] ? ptregs_execve+0x12/0x18
[65099.983662]  [<c0402d53>] ? sysenter_do_call+0x12/0x22
[65105.686843] BUG: scheduling while atomic: make/12821/0x10000001
[65105.686848] Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput snd_hda_codec_intelhdmi arc4 snd_hda_codec_realtek ecb iwlagn snd_hda_intel iwlcore snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm mac80211 snd_timer snd soundcore cfg80211 rfkill iTCO_wdt snd_page_alloc uvcvideo iTCO_vendor_support wmi serio_raw videodev i2c_i801 joydev v4l1_compat pcspkr sha256_generic aes_i586 aes_generic cbc dm_crypt [last unloaded: scsi_wait_scan]
[65105.686894] Pid: 12821, comm: make Tainted: G      D   I 2.6.35-07956-g92fa5bd9 #164
[65105.686897] Call Trace:
[65105.686908]  [<c085306b>] ? schedule+0x30b/0x4c0
[65105.686914]  [<c047da2e>] ? rcu_process_callbacks+0x1e/0x20
[65105.686918]  [<c0853329>] ? _cond_resched+0x29/0x40
[65105.686924]  [<c04a77b4>] ? anon_vma_prepare+0x14/0xd0
[65105.686928]  [<c04a3bac>] ? expand_downwards+0x1c/0x150
[65105.686934]  [<c0418713>] ? smp_apic_timer_interrupt+0x43/0x80
[65105.686939]  [<c04be847>] ? mem_cgroup_charge_common+0x57/0x70
[65105.686943]  [<c08548dd>] ? apic_timer_interrupt+0x31/0x38
[65105.686948]  [<c04a0ef7>] ? handle_mm_fault+0x957/0x9a0
[65105.686952]  [<c049e82c>] ? follow_page+0x25c/0x290
[65105.686956]  [<c04a1059>] ? __get_user_pages+0x119/0x3d0
[65105.686962]  [<c04c58cd>] ? get_arg_page+0x4d/0xb0
[65105.686967]  [<c0605015>] ? _copy_from_user+0x35/0x120
[65105.686971]  [<c04c59fc>] ? copy_strings+0xcc/0x190
[65105.686976]  [<c04c6f3b>] ? do_execve+0x1bb/0x250
[65105.686981]  [<c0408343>] ? sys_execve+0x33/0x70
[65105.686985]  [<c0402e0e>] ? ptregs_execve+0x12/0x18
[65105.686989]  [<c0402d53>] ? sysenter_do_call+0x12/0x22
[65113.374762] BUG: scheduling while atomic: sh/13185/0x10000001
[65113.374776] Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput snd_hda_codec_intelhdmi arc4 snd_hda_codec_realtek ecb iwlagn snd_hda_intel iwlcore snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm mac80211 snd_timer snd soundcore cfg80211 rfkill iTCO_wdt snd_page_alloc uvcvideo iTCO_vendor_support wmi serio_raw videodev i2c_i801 joydev v4l1_compat pcspkr sha256_generic aes_i586 aes_generic cbc dm_crypt [last unloaded: scsi_wait_scan]
[65113.374820] Pid: 13185, comm: sh Tainted: G      D   I 2.6.35-07956-g92fa5bd9 #164
[65113.374823] Call Trace:
[65113.374832]  [<c085306b>] ? schedule+0x30b/0x4c0
[65113.374836]  [<c0853329>] ? _cond_resched+0x29/0x40
[65113.374842]  [<c04a77b4>] ? anon_vma_prepare+0x14/0xd0
[65113.374847]  [<c04a3bac>] ? expand_downwards+0x1c/0x150
[65113.374852]  [<c04a0ef7>] ? handle_mm_fault+0x957/0x9a0
[65113.374856]  [<c049e82c>] ? follow_page+0x25c/0x290
[65113.374860]  [<c04a1059>] ? __get_user_pages+0x119/0x3d0
[65113.374866]  [<c04c58cd>] ? get_arg_page+0x4d/0xb0
[65113.374872]  [<c0605015>] ? _copy_from_user+0x35/0x120
[65113.374876]  [<c04c59fc>] ? copy_strings+0xcc/0x190
[65113.374880]  [<c04c6f26>] ? do_execve+0x1a6/0x250
[65113.374885]  [<c0408343>] ? sys_execve+0x33/0x70
[65113.374889]  [<c0402e0e>] ? ptregs_execve+0x12/0x18
[65113.374893]  [<c0402d53>] ? sysenter_do_call+0x12/0x22
[65120.500387] BUG: scheduling while atomic: sh/13475/0x10000001
[65120.500392] Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput snd_hda_codec_intelhdmi arc4 snd_hda_codec_realtek ecb iwlagn snd_hda_intel iwlcore snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm mac80211 snd_timer snd soundcore cfg80211 rfkill iTCO_wdt snd_page_alloc uvcvideo iTCO_vendor_support wmi serio_raw videodev i2c_i801 joydev v4l1_compat pcspkr sha256_generic aes_i586 aes_generic cbc dm_crypt [last unloaded: scsi_wait_scan]
[65120.500437] Pid: 13475, comm: sh Tainted: G      D   I 2.6.35-07956-g92fa5bd9 #164
[65120.500441] Call Trace:
[65120.500449]  [<c085306b>] ? schedule+0x30b/0x4c0
[65120.500455]  [<c048c7a1>] ? generic_file_aio_read+0x5d1/0x710
[65120.500459]  [<c0853329>] ? _cond_resched+0x29/0x40
[65120.500466]  [<c04a77b4>] ? anon_vma_prepare+0x14/0xd0
[65120.500470]  [<c04a3bac>] ? expand_downwards+0x1c/0x150
[65120.500476]  [<c0423c8b>] ? pte_alloc_one+0x1b/0x40
[65120.500480]  [<c04a0ef7>] ? handle_mm_fault+0x957/0x9a0
[65120.500485]  [<c049e63d>] ? follow_page+0x6d/0x290
[65120.500489]  [<c04a1059>] ? __get_user_pages+0x119/0x3d0
[65120.500494]  [<c04c58cd>] ? get_arg_page+0x4d/0xb0
[65120.500500]  [<c0604d53>] ? strnlen_user+0x23/0x50
[65120.500504]  [<c04c59fc>] ? copy_strings+0xcc/0x190
[65120.500508]  [<c04c5ae1>] ? copy_strings_kernel+0x21/0x40
[65120.500512]  [<c04c6f01>] ? do_execve+0x181/0x250
[65120.500518]  [<c0408343>] ? sys_execve+0x33/0x70
[65120.500522]  [<c0402e0e>] ? ptregs_execve+0x12/0x18
[65120.500526]  [<c0402d53>] ? sysenter_do_call+0x12/0x22
