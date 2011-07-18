Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab1GRQPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 12:15:42 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:13888 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab1GRQPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 12:15:39 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmxtMZ80VwmRNV7HU=
X-RZG-CLASS-ID: mo00
Date: Mon, 18 Jul 2011 18:15:18 +0200
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org
Subject: purpose of WARN_ON in kernel/workqueue.c:worker_enter_idle()
Message-ID: <20110718161518.GA8128@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21.rev5535 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

whats the purpose of "WARNING: at kernel/workqueue.c:1217 worker_enter_idle()"?
I put some debug in the function, cpu is always 1, nr_workers is either
2 or 3, current_work is NULL.
Is there some real bug lurking thats worth to track down?
Google has some hits for that warning, but no solution. Its not clear to
me what exactly triggers it, it seems to be network related but I'm not
sure.

Olaf

[   43.376143] worker_enter_idle: c 1 3           (null)
[   43.376148] ------------[ cut here ]------------
[   43.376157] WARNING: at /dist/mirror/Xen/linux-2.6/kernel/workqueue.c:1231 worker_enter_idle+0x16f/0x1b0()
[   43.376161] Hardware name: HP ProBook 6555b
[   43.376164] Modules linked in: snd_pcm_oss snd_mixer_oss powernow_k8 snd_seq snd_seq_device mperf sha256_generic cryptd aes_x86_64 aes_generic loop snd_hda_codec_hdmi snd_hda_codec_idt tpm_infineon kvm_amd kvm snd_hda_intel sdhci_pci sdhci tpm_tis hp_wmi mmc_core tpm sparse_keymap wmi snd_hda_codec snd_pcm snd_timer snd soundcore snd_page_alloc tpm_bios joydev i2c_piix4 hp_accel lis3lv02d k10temp input_polldev radeon ttm drm_kms_helper drm i2c_algo_bit xenbus_probe_frontend
[   43.376206] Pid: 42, comm: kworker/2:2 Not tainted 3.0.0-rc7-probook_6555b+ #26
[   43.376209] Call Trace:
[   43.376216]  [<ffffffff81047c4b>] ? warn_slowpath_common+0x7b/0xc0
[   43.376221]  [<ffffffff8105c3bf>] ? worker_enter_idle+0x16f/0x1b0
[   43.376226]  [<ffffffff8105cfe8>] ? worker_thread+0x208/0x330
[   43.376231]  [<ffffffff81038aa0>] ? __wake_up_common+0x50/0x80
[   43.376235]  [<ffffffff8105cde0>] ? manage_workers+0x220/0x220
[   43.376239]  [<ffffffff8105cde0>] ? manage_workers+0x220/0x220
[   43.376243]  [<ffffffff81062f76>] ? kthread+0x96/0xa0
[   43.376249]  [<ffffffff8147eb84>] ? kernel_thread_helper+0x4/0x10
[   43.376253]  [<ffffffff81062ee0>] ? kthread_worker_fn+0x180/0x180
[   43.376257]  [<ffffffff8147eb80>] ? gs_change+0x13/0x13
[   43.376260] ---[ end trace c763dbadb9d930c1 ]---


[    0.000000] Linux version 3.0.0-rc7-probook_6555b+ (olaf@probook.site) (gcc version 4.5.1 20101208 [gcc-4_5-branch revision 167585] (SUSE Linux) ) #26 SMP Mon Jul 18 17:23:30 CEST 2011
[    0.000000] Command line: root=/dev/disk/by-id/ata-WDC_WD7500BPVT-00HXZT1_WD-WX61A50R8246-part4 quiet panic=9 sysrq=yes resume=/dev/disk/by-id/ata-WDC_WD7500BPVT-00HXZT1_WD-WX61A50R8246-part8 splash=silent log_buf_len=32M
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000af6cf000 (usable)
[    0.000000]  BIOS-e820: 00000000af6cf000 - 00000000afdcf000 (reserved)
[    0.000000]  BIOS-e820: 00000000afdcf000 - 00000000afecf000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000afecf000 - 00000000afeff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000afeff000 - 00000000aff00000 (usable)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec10000 - 00000000fec11000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000240000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: Hewlett-Packard HP ProBook 6555b/1455, BIOS 68DTM Ver. F.09 05/04/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x240000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFE0000000 write-back
[    0.000000]   2 base 0000A0000000 mask FFFFF0000000 write-back
[    0.000000]   3 base 000100000000 mask FFFF00000000 write-back
[    0.000000]   4 base 000200000000 mask FFFFC0000000 write-back
[    0.000000]   5 base 0000FFE00000 mask FFFFFFE00000 write-protect
[    0.000000]   6 base 0000FFF40000 mask FFFFFFFF0000 write-protect
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000240000000 aka 9216M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xaff00 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 20480
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000aff00000
[    0.000000]  0000000000 - 0080000000 page 1G
[    0.000000]  0080000000 - 00afe00000 page 2M
[    0.000000]  00afe00000 - 00aff00000 page 4k
[    0.000000] kernel direct mapping tables up to aff00000 @ af6cc000-af6cf000
[    0.000000] init_memory_mapping: 0000000100000000-0000000240000000
[    0.000000]  0100000000 - 0240000000 page 1G
[    0.000000] kernel direct mapping tables up to 240000000 @ 23ffff000-240000000
[    0.000000] log_buf_len: 33554432
[    0.000000] early log buf free: 2093448(99%)
[    0.000000] RAMDISK: 374e3000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f2a70 00014 (v00 HPQOEM)
[    0.000000] ACPI: RSDT 00000000afefe038 00044 (v01 HPQOEM SLIC-MPC 00000003      01000013)
[    0.000000] ACPI: FACP 00000000afefd000 00074 (v01 HPQOEM 307E     00000003 HP   00000001)
[    0.000000] ACPI Warning: Optional field Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1 (20110413/tbfadt-560)
[    0.000000] ACPI: DSDT 00000000afedd000 1C046 (v01 HPQOEM   SB700  00000001 INTL 20060912)
[    0.000000] ACPI: FACS 00000000afe7e000 00040
[    0.000000] ACPI: APIC 00000000afefc000 00084 (v01 HPQOEM 307E     00000001 HP   00000001)
[    0.000000] ACPI: MCFG 00000000afefb000 0003C (v01 HPQOEM 307E     00000001 HP   00000001)
[    0.000000] ACPI: SLIC 00000000afefa000 00176 (v01 HPQOEM SLIC-MPC 00000001 HP   00000001)
[    0.000000] ACPI: SSDT 00000000afedc000 0005F (v01 HPQOEM   HPQNLP 00000001 INTL 20060912)
[    0.000000] ACPI: TCPA 00000000afedb000 00032 (v02 HPQOEM 307E     00000000 HP   00000001)
[    0.000000] ACPI: HPET 00000000afeda000 00038 (v01 HPQOEM 307E     00000001 HP   00000001)
[    0.000000] ACPI: SSDT 00000000afed9000 007AD (v01 AMD    POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0007dfffff] PMD -> [ffff880235a00000-ffff88023c7fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00240000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000af6cf
[    0.000000]     0: 0x000afeff -> 0x000aff00
[    0.000000]     0: 0x00100000 -> 0x00240000
[    0.000000] On node 0 totalpages: 2029151
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3922 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 700168 pages, LIFO batch:31
[    0.000000]   Normal zone: 17920 pages used for memmap
[    0.000000]   Normal zone: 1292800 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x43538301 base: 0xfed00000
[    0.000000] 4 Processors exceeds NR_CPUS limit of 3
[    0.000000] SMP: Allowing 3 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000af6cf000 - 00000000afdcf000
[    0.000000] PM: Registered nosave memory: 00000000afdcf000 - 00000000afecf000
[    0.000000] PM: Registered nosave memory: 00000000afecf000 - 00000000afeff000
[    0.000000] PM: Registered nosave memory: 00000000aff00000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fec11000
[    0.000000] PM: Registered nosave memory: 00000000fec11000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffe00000
[    0.000000] PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at aff00000 (gap: aff00000:30100000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:3 nr_cpumask_bits:3 nr_cpu_ids:3 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88023dc00000 s76224 r8192 d22080 u524288
[    0.000000] pcpu-alloc: s76224 r8192 d22080 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 - 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1996890
[    0.000000] Kernel command line: root=/dev/disk/by-id/ata-WDC_WD7500BPVT-00HXZT1_WD-WX61A50R8246-part4 quiet panic=9 sysrq=yes resume=/dev/disk/by-id/ata-WDC_WD7500BPVT-00HXZT1_WD-WX61A50R8246-part8 splash=silent log_buf_len=32M
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ a4000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ a4000000
[    0.000000] PM: Registered nosave memory: 00000000a4000000 - 00000000a8000000
[    0.000000] Memory: 7801892k/9437184k available (4613k kernel code, 1320580k absent, 314712k reserved, 6014k data, 528k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=3, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:352
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2094.627 MHz processor.
[    0.004003] Calibrating delay loop (skipped), value calculated using timer frequency.. 4189.25 BogoMIPS (lpj=8378508)
[    0.004007] pid_max: default: 32768 minimum: 301
[    0.004052] Mount-cache hash table entries: 256
[    0.004174] tseg: 00aff00000
[    0.004176] CPU: Physical Processor ID: 0
[    0.004178] CPU: Processor Core ID: 0
[    0.004180] mce: CPU supports 6 MCE banks
[    0.004188] using AMD E400 aware idle routine
[    0.004807] ACPI: Core revision 20110413
[    0.012322] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.052035] CPU0: AMD Phenom(tm) II N830 Triple-Core Processor stepping 03
[    0.056003] Performance Events: AMD PMU driver.
[    0.056003] ... version:                0
[    0.056003] ... bit width:              48
[    0.056003] ... generic registers:      4
[    0.056003] ... value mask:             0000ffffffffffff
[    0.056003] ... max period:             00007fffffffffff
[    0.056003] ... fixed-purpose events:   0
[    0.056003] ... event mask:             000000000000000f
[    0.056003] Booting Node   0, Processors  #1
[    0.056003] smpboot cpu 1: start_ip = 9a000
[    0.144019] System has AMD C1E enabled
[    0.144049]  #2 Ok.
[    0.144051] smpboot cpu 2: start_ip = 9a000
[    0.144070] Switch to broadcast mode on CPU1
[    0.236023] Brought up 3 CPUs
[    0.236026] Total of 3 processors activated (12568.29 BogoMIPS).
[    0.236026] Switch to broadcast mode on CPU2
[    0.236448] Switch to broadcast mode on CPU0
[    0.236479] devtmpfs: initialized
[    0.236479] PM: Registering ACPI NVS region at afdcf000 (1048576 bytes)
[    0.236479] NET: Registered protocol family 16
[    0.236479] node 0 link 0: io port [0, ffffff]
[    0.236479] TOM: 00000000c0000000 aka 3072M
[    0.236479] Fam 10h mmconf [e0000000, efffffff]
[    0.236479] node 0 link 0: mmio [c0000000, cfffffff]
[    0.236479] node 0 link 0: mmio [d0000000, d42fffff]
[    0.236479] node 0 link 0: mmio [d4300000, d44fffff]
[    0.236479] node 0 link 0: mmio [d4500000, dfffffff]
[    0.236479] node 0 link 0: mmio [e0000000, e0ffffff] ==> none
[    0.236479] node 0 link 0: mmio [e1000000, ffb7ffff] ==> [f0000000, ffb7ffff]
[    0.236479] TOM2: 0000000240000000 aka 9216M
[    0.236479] bus: [00, 1f] on node 0 link 0
[    0.236479] bus: 00 index 0 [io  0x0000-0xffff]
[    0.236479] bus: 00 index 1 [mem 0xc0000000-0xdfffffff]
[    0.236479] bus: 00 index 2 [mem 0xf0000000-0xffffffff]
[    0.236479] bus: 00 index 3 [mem 0x240000000-0xfcffffffff]
[    0.236479] Extended Config Space enabled on 1 nodes
[    0.236479] ACPI: bus type pci registered
[    0.236479] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.236479] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.264692] PCI: Using configuration type 1 for base access
[    0.264717] mtrr: your CPUs had inconsistent fixed MTRR settings
[    0.264719] mtrr: probably your BIOS does not setup all CPUs.
[    0.264720] mtrr: corrected configuration.
[    0.265284] bio: create slab <bio-0> at 0
[    0.265284] ACPI: EC: Look up EC in DSDT
[    0.266294] ACPI: Executed 1 blocks of module-level executable AML code
[    0.316190] ACPI: Interpreter enabled
[    0.316196] ACPI: (supports S0 S3 S4 S5)
[    0.316215] ACPI: Using IOAPIC for interrupt routing
[    0.317881] ACPI: Power Resource [APPR] (off)
[    0.397265] ACPI: Power Resource [PFN0] (off)
[    0.397300] ACPI: Power Resource [PFN1] (off)
[    0.397333] ACPI: Power Resource [PFN2] (off)
[    0.397365] ACPI: Power Resource [PFN3] (off)
[    0.397398] ACPI: Power Resource [PFN4] (off)
[    0.397847] ACPI: EC: GPE = 0x3, I/O: command/status = 0x66, data = 0x62
[    0.397877] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.397956] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.398096] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.398099] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.398101] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.398103] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000c3fff]
[    0.398106] pci_root PNP0A03:00: host bridge window [mem 0x000c4000-0x000c7fff]
[    0.398108] pci_root PNP0A03:00: host bridge window [mem 0x000c8000-0x000cbfff]
[    0.398110] pci_root PNP0A03:00: host bridge window [mem 0x000cc000-0x000cffff]
[    0.398112] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000d3fff]
[    0.398114] pci_root PNP0A03:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    0.398117] pci_root PNP0A03:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    0.398119] pci_root PNP0A03:00: host bridge window [mem 0x000dc000-0x000dffff]
[    0.398121] pci_root PNP0A03:00: host bridge window [mem 0x000e0000-0x000e3fff]
[    0.398123] pci_root PNP0A03:00: host bridge window [mem 0x000e4000-0x000e7fff]
[    0.398125] pci_root PNP0A03:00: host bridge window [mem 0x000e8000-0x000ebfff]
[    0.398128] pci_root PNP0A03:00: host bridge window [mem 0x000ec000-0x000effff]
[    0.398130] pci_root PNP0A03:00: host bridge window [mem 0xc0000000-0xdfffffff]
[    0.398132] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfffdffff]
[    0.398135] pci_root PNP0A03:00: host bridge window [mem 0xffe00000-0xffffffff]
[    0.398139] pci_root PNP0A03:00: host bridge window expanded to [mem 0xf0000000-0xffffffff]; [mem 0xffe00000-0xffffffff] ignored
[    0.398144] pci_root PNP0A03:00: address space collision: host bridge window [mem 0x000cc000-0x000cffff] conflicts with Video ROM [mem 0x000c0000-0x000cedff]
[    0.398222] pci_bus 0000:00: scanning bus
[    0.398233] pci 0000:00:00.0: [1022:9601] type 0 class 0x000600
[    0.398240] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0x12
[    0.398257] pci 0000:00:00.0: calling quirk_resource_alignment+0x0/0x16d
[    0.398284] pci 0000:00:01.0: [103c:9602] type 1 class 0x000604
[    0.398289] pci 0000:00:01.0: calling quirk_mmio_always_on+0x0/0x12
[    0.398303] pci 0000:00:01.0: calling quirk_resource_alignment+0x0/0x16d
[    0.398325] pci 0000:00:04.0: [1022:9604] type 1 class 0x000604
[    0.398328] pci 0000:00:04.0: calling quirk_mmio_always_on+0x0/0x12
[    0.398345] pci 0000:00:04.0: calling quirk_resource_alignment+0x0/0x16d
[    0.398356] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.398359] pci 0000:00:04.0: PME# disabled
[    0.398372] pci 0000:00:05.0: [1022:9605] type 1 class 0x000604
[    0.398375] pci 0000:00:05.0: calling quirk_mmio_always_on+0x0/0x12
[    0.398392] pci 0000:00:05.0: calling quirk_resource_alignment+0x0/0x16d
[    0.398402] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.398404] pci 0000:00:05.0: PME# disabled
[    0.398424] pci 0000:00:09.0: [1022:9608] type 1 class 0x000604
[    0.398427] pci 0000:00:09.0: calling quirk_mmio_always_on+0x0/0x12
[    0.398444] pci 0000:00:09.0: calling quirk_resource_alignment+0x0/0x16d
[    0.398454] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.398456] pci 0000:00:09.0: PME# disabled
[    0.398486] pci 0000:00:11.0: [1002:4391] type 0 class 0x000106
[    0.398495] pci 0000:00:11.0: calling quirk_no_ata_d3+0x0/0x16
[    0.398498] pci 0000:00:11.0: calling quirk_mmio_always_on+0x0/0x12
[    0.398509] pci 0000:00:11.0: reg 10: [io  0x6018-0x601f]
[    0.398518] pci 0000:00:11.0: reg 14: [io  0x6024-0x6027]
[    0.398527] pci 0000:00:11.0: reg 18: [io  0x6010-0x6017]
[    0.398536] pci 0000:00:11.0: reg 1c: [io  0x6020-0x6023]
[    0.398545] pci 0000:00:11.0: reg 20: [io  0x6000-0x600f]
[    0.398554] pci 0000:00:11.0: reg 24: [mem 0xd450b000-0xd450b3ff]
[    0.398567] pci 0000:00:11.0: calling quirk_resource_alignment+0x0/0x16d
[    0.398600] pci 0000:00:12.0: [1002:4397] type 0 class 0x000c03
[    0.398604] pci 0000:00:12.0: calling quirk_no_ata_d3+0x0/0x16
[    0.398607] pci 0000:00:12.0: calling quirk_mmio_always_on+0x0/0x12
[    0.398619] pci 0000:00:12.0: reg 10: [mem 0xd450a000-0xd450afff]
[    0.398666] pci 0000:00:12.0: calling quirk_resource_alignment+0x0/0x16d
[    0.398685] pci 0000:00:12.2: [1002:4396] type 0 class 0x000c03
[    0.398694] pci 0000:00:12.2: calling quirk_no_ata_d3+0x0/0x16
[    0.398697] pci 0000:00:12.2: calling quirk_mmio_always_on+0x0/0x12
[    0.398708] pci 0000:00:12.2: reg 10: [mem 0xd4509000-0xd45090ff]
[    0.398756] pci 0000:00:12.2: calling quirk_resource_alignment+0x0/0x16d
[    0.398774] pci 0000:00:12.2: supports D1 D2
[    0.398776] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.398780] pci 0000:00:12.2: PME# disabled
[    0.398800] pci 0000:00:13.0: [1002:4397] type 0 class 0x000c03
[    0.398804] pci 0000:00:13.0: calling quirk_no_ata_d3+0x0/0x16
[    0.398807] pci 0000:00:13.0: calling quirk_mmio_always_on+0x0/0x12
[    0.398818] pci 0000:00:13.0: reg 10: [mem 0xd4508000-0xd4508fff]
[    0.398866] pci 0000:00:13.0: calling quirk_resource_alignment+0x0/0x16d
[    0.398885] pci 0000:00:13.2: [1002:4396] type 0 class 0x000c03
[    0.398894] pci 0000:00:13.2: calling quirk_no_ata_d3+0x0/0x16
[    0.398897] pci 0000:00:13.2: calling quirk_mmio_always_on+0x0/0x12
[    0.398908] pci 0000:00:13.2: reg 10: [mem 0xd4507000-0xd45070ff]
[    0.398956] pci 0000:00:13.2: calling quirk_resource_alignment+0x0/0x16d
[    0.398974] pci 0000:00:13.2: supports D1 D2
[    0.398976] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.398979] pci 0000:00:13.2: PME# disabled
[    0.398999] pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
[    0.399003] pci 0000:00:14.0: calling quirk_no_ata_d3+0x0/0x16
[    0.399006] pci 0000:00:14.0: calling quirk_mmio_always_on+0x0/0x12
[    0.399009] pci 0000:00:14.0: calling sb600_disable_hpet_bar+0x0/0x50
[    0.399065] pci 0000:00:14.0: calling force_disable_hpet_msi+0x0/0x10
[    0.399068] pci 0000:00:14.0: calling quirk_resource_alignment+0x0/0x16d
[    0.399085] pci 0000:00:14.2: [1002:4383] type 0 class 0x000403
[    0.399092] pci 0000:00:14.2: calling quirk_no_ata_d3+0x0/0x16
[    0.399095] pci 0000:00:14.2: calling quirk_mmio_always_on+0x0/0x12
[    0.399110] pci 0000:00:14.2: reg 10: [mem 0xd4500000-0xd4503fff 64bit]
[    0.399151] pci 0000:00:14.2: calling quirk_resource_alignment+0x0/0x16d
[    0.399166] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.399169] pci 0000:00:14.2: PME# disabled
[    0.399182] pci 0000:00:14.3: [1002:439d] type 0 class 0x000601
[    0.399185] pci 0000:00:14.3: calling quirk_no_ata_d3+0x0/0x16
[    0.399188] pci 0000:00:14.3: calling quirk_mmio_always_on+0x0/0x12
[    0.399245] pci 0000:00:14.3: calling quirk_resource_alignment+0x0/0x16d
[    0.399258] pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
[    0.399262] pci 0000:00:14.4: calling quirk_no_ata_d3+0x0/0x16
[    0.399265] pci 0000:00:14.4: calling quirk_mmio_always_on+0x0/0x12
[    0.399291] pci 0000:00:14.4: calling quirk_resource_alignment+0x0/0x16d
[    0.399303] pci 0000:00:14.5: [1002:4399] type 0 class 0x000c03
[    0.399307] pci 0000:00:14.5: calling quirk_no_ata_d3+0x0/0x16
[    0.399310] pci 0000:00:14.5: calling quirk_mmio_always_on+0x0/0x12
[    0.399321] pci 0000:00:14.5: reg 10: [mem 0xd4506000-0xd4506fff]
[    0.399369] pci 0000:00:14.5: calling quirk_resource_alignment+0x0/0x16d
[    0.399385] pci 0000:00:16.0: [1002:4397] type 0 class 0x000c03
[    0.399389] pci 0000:00:16.0: calling quirk_no_ata_d3+0x0/0x16
[    0.399391] pci 0000:00:16.0: calling quirk_mmio_always_on+0x0/0x12
[    0.399403] pci 0000:00:16.0: reg 10: [mem 0xd4505000-0xd4505fff]
[    0.399450] pci 0000:00:16.0: calling quirk_resource_alignment+0x0/0x16d
[    0.399470] pci 0000:00:16.2: [1002:4396] type 0 class 0x000c03
[    0.399479] pci 0000:00:16.2: calling quirk_no_ata_d3+0x0/0x16
[    0.399481] pci 0000:00:16.2: calling quirk_mmio_always_on+0x0/0x12
[    0.399493] pci 0000:00:16.2: reg 10: [mem 0xd4504000-0xd45040ff]
[    0.399540] pci 0000:00:16.2: calling quirk_resource_alignment+0x0/0x16d
[    0.399559] pci 0000:00:16.2: supports D1 D2
[    0.399560] pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
[    0.399564] pci 0000:00:16.2: PME# disabled
[    0.399582] pci 0000:00:18.0: [1022:1200] type 0 class 0x000600
[    0.399585] pci 0000:00:18.0: calling quirk_mmio_always_on+0x0/0x12
[    0.399595] pci 0000:00:18.0: calling quirk_resource_alignment+0x0/0x16d
[    0.399603] pci 0000:00:18.1: [1022:1201] type 0 class 0x000600
[    0.399606] pci 0000:00:18.1: calling quirk_mmio_always_on+0x0/0x12
[    0.399615] pci 0000:00:18.1: calling quirk_resource_alignment+0x0/0x16d
[    0.399621] pci 0000:00:18.2: [1022:1202] type 0 class 0x000600
[    0.399624] pci 0000:00:18.2: calling quirk_mmio_always_on+0x0/0x12
[    0.399633] pci 0000:00:18.2: calling quirk_resource_alignment+0x0/0x16d
[    0.399640] pci 0000:00:18.3: [1022:1203] type 0 class 0x000600
[    0.399643] pci 0000:00:18.3: calling quirk_mmio_always_on+0x0/0x12
[    0.399652] pci 0000:00:18.3: calling quirk_resource_alignment+0x0/0x16d
[    0.399660] pci 0000:00:18.4: [1022:1204] type 0 class 0x000600
[    0.399663] pci 0000:00:18.4: calling quirk_mmio_always_on+0x0/0x12
[    0.399673] pci 0000:00:18.4: calling quirk_resource_alignment+0x0/0x16d
[    0.399689] pci_bus 0000:00: fixups for bus
[    0.399692] pci 0000:00:01.0: scanning [bus 01-01] behind bridge, pass 0
[    0.399704] pci_bus 0000:01: scanning bus
[    0.399717] pci 0000:01:05.0: [1002:9712] type 0 class 0x000300
[    0.399722] pci 0000:01:05.0: calling quirk_no_ata_d3+0x0/0x16
[    0.399725] pci 0000:01:05.0: calling quirk_mmio_always_on+0x0/0x12
[    0.399731] pci 0000:01:05.0: reg 10: [mem 0xc0000000-0xcfffffff pref]
[    0.399736] pci 0000:01:05.0: reg 14: [io  0x5000-0x50ff]
[    0.399740] pci 0000:01:05.0: reg 18: [mem 0xd4400000-0xd440ffff]
[    0.399750] pci 0000:01:05.0: reg 24: [mem 0xd4300000-0xd43fffff]
[    0.399757] pci 0000:01:05.0: calling quirk_resource_alignment+0x0/0x16d
[    0.399765] pci 0000:01:05.0: supports D1 D2
[    0.399774] pci 0000:01:05.1: [1002:970f] type 0 class 0x000403
[    0.399780] pci 0000:01:05.1: calling quirk_no_ata_d3+0x0/0x16
[    0.399782] pci 0000:01:05.1: calling quirk_mmio_always_on+0x0/0x12
[    0.399788] pci 0000:01:05.1: reg 10: [mem 0xd4410000-0xd4413fff]
[    0.399807] pci 0000:01:05.1: calling quirk_resource_alignment+0x0/0x16d
[    0.399815] pci 0000:01:05.1: supports D1 D2
[    0.399853] pci_bus 0000:01: fixups for bus
[    0.399855] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.399858] pci 0000:00:01.0:   bridge window [io  0x5000-0x5fff]
[    0.399861] pci 0000:00:01.0:   bridge window [mem 0xd4300000-0xd44fffff]
[    0.399865] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.399867] pci_bus 0000:01: bus scan returning with max=01
[    0.399870] pci 0000:00:04.0: scanning [bus 02-02] behind bridge, pass 0
[    0.399890] pci_bus 0000:02: scanning bus
[    0.400038] pci 0000:02:00.0: [11ab:4381] type 0 class 0x000200
[    0.400072] pci 0000:02:00.0: calling quirk_mmio_always_on+0x0/0x12
[    0.400089] pci 0000:02:00.0: reg 10: [mem 0xd3200000-0xd3203fff 64bit]
[    0.400100] pci 0000:02:00.0: reg 18: [io  0x3000-0x30ff]
[    0.400135] pci 0000:02:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    0.400141] pci 0000:02:00.0: calling quirk_resource_alignment+0x0/0x16d
[    0.400170] pci 0000:02:00.0: supports D1 D2
[    0.400172] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.400176] pci 0000:02:00.0: PME# disabled
[    1.408120] pci 0000:00:04.0: ASPM: Could not configure common clock
[    1.408204] pci_bus 0000:02: fixups for bus
[    1.408207] pci 0000:00:04.0: PCI bridge to [bus 02-02]
[    1.408212] pci 0000:00:04.0:   bridge window [io  0x3000-0x4fff]
[    1.408215] pci 0000:00:04.0:   bridge window [mem 0xd3200000-0xd42fffff]
[    1.408219] pci 0000:00:04.0:   bridge window [mem 0xd0000000-0xd0ffffff 64bit pref]
[    1.408222] pci_bus 0000:02: bus scan returning with max=02
[    1.408226] pci 0000:00:05.0: scanning [bus 03-03] behind bridge, pass 0
[    1.408250] pci_bus 0000:03: scanning bus
[    1.408275] pci 0000:03:00.0: [1180:e822] type 0 class 0x000805
[    1.408282] pci 0000:03:00.0: calling quirk_mmio_always_on+0x0/0x12
[    1.408296] pci 0000:03:00.0: reg 10: [mem 0x00000000-0x000000ff]
[    1.408352] pci 0000:03:00.0: calling quirk_resource_alignment+0x0/0x16d
[    1.408380] pci 0000:03:00.0: supports D1 D2
[    1.408382] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.408387] pci 0000:03:00.0: PME# disabled
[    1.420132] pci_bus 0000:03: fixups for bus
[    1.420137] pci 0000:00:05.0: PCI bridge to [bus 03-03]
[    1.420141] pci 0000:00:05.0:   bridge window [io  0x2000-0x2fff]
[    1.420144] pci 0000:00:05.0:   bridge window [mem 0xd2100000-0xd31fffff]
[    1.420148] pci 0000:00:05.0:   bridge window [mem 0xd1000000-0xd1ffffff 64bit pref]
[    1.420151] pci_bus 0000:03: bus scan returning with max=03
[    1.420155] pci 0000:00:09.0: scanning [bus 04-04] behind bridge, pass 0
[    1.420179] pci_bus 0000:04: scanning bus
[    1.420181] pci_bus 0000:04: fixups for bus
[    1.420183] pci 0000:00:09.0: PCI bridge to [bus 04-04]
[    1.420187] pci 0000:00:09.0:   bridge window [io  0xfffffffffffff000-0x0000] (disabled)
[    1.420190] pci 0000:00:09.0:   bridge window [mem 0xd2000000-0xd20fffff]
[    1.420194] pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.420196] pci_bus 0000:04: bus scan returning with max=04
[    1.420201] pci 0000:00:14.4: scanning [bus 05-05] behind bridge, pass 0
[    1.420210] pci_bus 0000:05: scanning bus
[    1.420256] pci_bus 0000:05: fixups for bus
[    1.420258] pci 0000:00:14.4: PCI bridge to [bus 05-05] (subtractive decode)
[    1.420263] pci 0000:00:14.4:   bridge window [io  0x1000-0x1fff]
[    1.420267] pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.420271] pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.420274] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    1.420276] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    1.420279] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.420281] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000c3fff] (subtractive decode)
[    1.420283] pci 0000:00:14.4:   bridge window [mem 0x000c4000-0x000c7fff] (subtractive decode)
[    1.420286] pci 0000:00:14.4:   bridge window [mem 0x000c8000-0x000cbfff] (subtractive decode)
[    1.420288] pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
[    1.420290] pci 0000:00:14.4:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    1.420293] pci 0000:00:14.4:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    1.420295] pci 0000:00:14.4:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
[    1.420297] pci 0000:00:14.4:   bridge window [mem 0x000e0000-0x000e3fff] (subtractive decode)
[    1.420300] pci 0000:00:14.4:   bridge window [mem 0x000e4000-0x000e7fff] (subtractive decode)
[    1.420302] pci 0000:00:14.4:   bridge window [mem 0x000e8000-0x000ebfff] (subtractive decode)
[    1.420304] pci 0000:00:14.4:   bridge window [mem 0x000ec000-0x000effff] (subtractive decode)
[    1.420307] pci 0000:00:14.4:   bridge window [mem 0xc0000000-0xdfffffff] (subtractive decode)
[    1.420309] pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xffffffff] (subtractive decode)
[    1.420311] pci_bus 0000:05: bus scan returning with max=05
[    1.420320] pci 0000:00:01.0: scanning [bus 01-01] behind bridge, pass 1
[    1.420324] pci 0000:00:04.0: scanning [bus 02-02] behind bridge, pass 1
[    1.420327] pci 0000:00:05.0: scanning [bus 03-03] behind bridge, pass 1
[    1.420331] pci 0000:00:09.0: scanning [bus 04-04] behind bridge, pass 1
[    1.420335] pci 0000:00:14.4: scanning [bus 05-05] behind bridge, pass 1
[    1.420340] pci_bus 0000:00: bus scan returning with max=05
[    1.420342] pci_bus 0000:00: on NUMA node 0
[    1.420349] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.420523] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    1.420558] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB4_._PRT]
[    1.420598] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB5_._PRT]
[    1.420630] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB9_._PRT]
[    1.420692]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    1.420695]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    1.420697] ACPI _OSC control for PCIe not granted, disabling ASPM
[    1.424120] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    1.424184] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    1.424248] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    1.424309] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    1.424356] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    1.424391] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    1.424427] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    1.424462] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    1.424546] vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    1.424549] vgaarb: loaded
[    1.424551] vgaarb: bridge control possible 0000:01:05.0
[    1.424604] SCSI subsystem initialized
[    1.428636] libata version 3.00 loaded.
[    1.428636] usbcore: registered new interface driver usbfs
[    1.428636] usbcore: registered new interface driver hub
[    1.428636] usbcore: registered new device driver usb
[    1.428636] PCI: Using ACPI for IRQ routing
[    1.436635] PCI: pci_cache_line_size set to 64 bytes
[    1.436654] pci 0000:00:11.0: BAR 0: reserving [io  0x6018-0x601f flags 0x40101] (d=0, p=0)
[    1.436658] pci 0000:00:11.0: BAR 1: reserving [io  0x6024-0x6027 flags 0x40101] (d=0, p=0)
[    1.436661] pci 0000:00:11.0: BAR 2: reserving [io  0x6010-0x6017 flags 0x40101] (d=0, p=0)
[    1.436664] pci 0000:00:11.0: BAR 3: reserving [io  0x6020-0x6023 flags 0x40101] (d=0, p=0)
[    1.436666] pci 0000:00:11.0: BAR 4: reserving [io  0x6000-0x600f flags 0x40101] (d=0, p=0)
[    1.436669] pci 0000:00:11.0: BAR 5: reserving [mem 0xd450b000-0xd450b3ff flags 0x40200] (d=0, p=0)
[    1.436675] pci 0000:00:12.0: BAR 0: reserving [mem 0xd450a000-0xd450afff flags 0x40200] (d=0, p=0)
[    1.436680] pci 0000:00:12.2: BAR 0: reserving [mem 0xd4509000-0xd45090ff flags 0x40200] (d=0, p=0)
[    1.436685] pci 0000:00:13.0: BAR 0: reserving [mem 0xd4508000-0xd4508fff flags 0x40200] (d=0, p=0)
[    1.436690] pci 0000:00:13.2: BAR 0: reserving [mem 0xd4507000-0xd45070ff flags 0x40200] (d=0, p=0)
[    1.436696] pci 0000:00:14.2: BAR 0: reserving [mem 0xd4500000-0xd4503fff flags 0x140204] (d=0, p=0)
[    1.436705] pci 0000:00:14.5: BAR 0: reserving [mem 0xd4506000-0xd4506fff flags 0x40200] (d=0, p=0)
[    1.436710] pci 0000:00:16.0: BAR 0: reserving [mem 0xd4505000-0xd4505fff flags 0x40200] (d=0, p=0)
[    1.436715] pci 0000:00:16.2: BAR 0: reserving [mem 0xd4504000-0xd45040ff flags 0x40200] (d=0, p=0)
[    1.436723] pci 0000:01:05.0: BAR 0: reserving [mem 0xc0000000-0xcfffffff flags 0x42208] (d=0, p=0)
[    1.436726] pci 0000:01:05.0: BAR 1: reserving [io  0x5000-0x50ff flags 0x40101] (d=0, p=0)
[    1.436729] pci 0000:01:05.0: BAR 2: reserving [mem 0xd4400000-0xd440ffff flags 0x40200] (d=0, p=0)
[    1.436732] pci 0000:01:05.0: BAR 5: reserving [mem 0xd4300000-0xd43fffff flags 0x40200] (d=0, p=0)
[    1.436736] pci 0000:01:05.1: BAR 0: reserving [mem 0xd4410000-0xd4413fff flags 0x40200] (d=0, p=0)
[    1.436771] pci 0000:02:00.0: BAR 0: reserving [mem 0xd3200000-0xd3203fff flags 0x140204] (d=0, p=0)
[    1.436774] pci 0000:02:00.0: BAR 2: reserving [io  0x3000-0x30ff flags 0x40101] (d=0, p=0)
[    1.436849] reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
[    1.436852] reserve RAM buffer: 00000000af6cf000 - 00000000afffffff 
[    1.436855] reserve RAM buffer: 00000000aff00000 - 00000000afffffff 
[    1.436960] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    1.436964] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    1.438998] Switching to clocksource hpet
[    1.439033] pnp: PnP ACPI init
[    1.439033] ACPI: bus type pnp registered
[    1.439033] pnp 00:00: [bus 00-ff]
[    1.439033] pnp 00:00: [io  0x0000-0x0cf7 window]
[    1.439033] pnp 00:00: [io  0x0d00-0xffff window]
[    1.439033] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    1.439033] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    1.439033] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    1.439033] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    1.439033] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    1.439033] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    1.439033] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    1.439033] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    1.439033] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    1.439033] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    1.439033] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    1.439033] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    1.439033] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    1.439033] pnp 00:00: [mem 0xc0000000-0xdfffffff window]
[    1.439033] pnp 00:00: [mem 0xf0000000-0xfffdffff window]
[    1.439033] pnp 00:00: [io  0x0cf8-0x0cff]
[    1.439033] pnp 00:00: [mem 0xffe00000-0xffffffff]
[    1.439033] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    1.439033] pnp 00:01: [io  0x0000-0x000f]
[    1.439033] pnp 00:01: [io  0x0081-0x008f]
[    1.439033] pnp 00:01: [io  0x00c0-0x00df]
[    1.439033] pnp 00:01: [dma 4]
[    1.439033] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.439033] pnp 00:02: [io  0x00f0-0x00fe]
[    1.439033] pnp 00:02: [irq 13]
[    1.439033] pnp 00:02: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.439033] pnp 00:03: [io  0xfe00-0xfe0f]
[    1.439033] pnp 00:03: [io  0xfe80-0xfe8f]
[    1.439033] pnp 00:03: [mem 0xfed40000-0xfed44fff]
[    1.439033] pnp 00:03: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
[    1.439033] pnp 00:04: [io  0x0061]
[    1.439033] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.439033] pnp 00:05: [io  0x0010-0x001f]
[    1.439033] pnp 00:05: [io  0x002e-0x002f]
[    1.439033] pnp 00:05: [io  0x004e-0x004f]
[    1.439033] pnp 00:05: [io  0x0072-0x0073]
[    1.439033] pnp 00:05: [io  0x0080]
[    1.439033] pnp 00:05: [io  0x00b0-0x00b1]
[    1.439033] pnp 00:05: [io  0x0092]
[    1.439033] pnp 00:05: [io  0x0400-0x04cf]
[    1.439033] pnp 00:05: [io  0x04d0-0x04d1]
[    1.439033] pnp 00:05: [io  0x04d6]
[    1.439033] pnp 00:05: [io  0x0680-0x06ff]
[    1.439033] pnp 00:05: [io  0x077a]
[    1.439033] pnp 00:05: [io  0x0c00-0x0c01]
[    1.439033] pnp 00:05: [io  0x0c14]
[    1.439033] pnp 00:05: [io  0x0c50-0x0c52]
[    1.439033] pnp 00:05: [io  0x0c6c]
[    1.439033] pnp 00:05: [io  0x0c6f]
[    1.439033] pnp 00:05: [io  0x0cd0-0x0cdb]
[    1.439033] pnp 00:05: [io  0x0220-0x0227]
[    1.439033] pnp 00:05: [io  0x0260-0x0273]
[    1.439033] pnp 00:05: [io  0x0800]
[    1.439033] pnp 00:05: [io  0x0804]
[    1.439033] pnp 00:05: [io  0x087f]
[    1.439033] pnp 00:05: [io  0x0cdc-0x0cdf]
[    1.439033] pnp 00:05: [io  0x00b8]
[    1.439033] pnp 00:05: [io  0x0022-0x0023]
[    1.439033] pnp 00:05: [io  0x0b00-0x0b0f]
[    1.439033] pnp 00:05: [io  0x0b20-0x0b3f]
[    1.439033] pnp 00:05: [io  0x0200-0x027f]
[    1.439033] system 00:05: [io  0x0400-0x04cf] has been reserved
[    1.439033] system 00:05: [io  0x04d0-0x04d1] has been reserved
[    1.439033] system 00:05: [io  0x04d6] has been reserved
[    1.439033] system 00:05: [io  0x0680-0x06ff] has been reserved
[    1.439033] system 00:05: [io  0x077a] has been reserved
[    1.439033] system 00:05: [io  0x0c00-0x0c01] has been reserved
[    1.439033] system 00:05: [io  0x0c14] has been reserved
[    1.439033] system 00:05: [io  0x0c50-0x0c52] has been reserved
[    1.439033] system 00:05: [io  0x0c6c] has been reserved
[    1.439033] system 00:05: [io  0x0c6f] has been reserved
[    1.439033] system 00:05: [io  0x0cd0-0x0cdb] has been reserved
[    1.439033] system 00:05: [io  0x0220-0x0227] has been reserved
[    1.439033] system 00:05: [io  0x0260-0x0273] has been reserved
[    1.439033] system 00:05: [io  0x0800] has been reserved
[    1.439033] system 00:05: [io  0x0804] has been reserved
[    1.439033] system 00:05: [io  0x087f] has been reserved
[    1.439033] system 00:05: [io  0x0cdc-0x0cdf] has been reserved
[    1.439033] system 00:05: [io  0x0b00-0x0b0f] has been reserved
[    1.439033] system 00:05: [io  0x0b20-0x0b3f] has been reserved
[    1.439033] system 00:05: [io  0x0200-0x027f] could not be reserved
[    1.439033] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.439033] pnp 00:06: [mem 0x00000000-0x0009ffff]
[    1.439033] pnp 00:06: [mem 0x000ec000-0x000fffff]
[    1.439033] pnp 00:06: [mem 0x00100000-0xbfffffff]
[    1.439033] pnp 00:06: [mem 0xe0000000-0xefffffff]
[    1.439033] pnp 00:06: [mem 0xfeb00000-0xfeb00fff]
[    1.439033] pnp 00:06: [mem 0xfec00000-0xfec00fff]
[    1.439033] pnp 00:06: [mem 0xfee00000-0xfee00fff]
[    1.439033] pnp 00:06: [mem 0xffe00000-0xffffffff]
[    1.439033] system 00:06: [mem 0x00000000-0x0009ffff] could not be reserved
[    1.439033] system 00:06: [mem 0x000ec000-0x000fffff] could not be reserved
[    1.439033] system 00:06: [mem 0x00100000-0xbfffffff] could not be reserved
[    1.439033] system 00:06: [mem 0xe0000000-0xefffffff] has been reserved
[    1.439033] system 00:06: [mem 0xfeb00000-0xfeb00fff] has been reserved
[    1.439033] system 00:06: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.439033] system 00:06: [mem 0xfee00000-0xfee00fff] has been reserved
[    1.439033] system 00:06: [mem 0xffe00000-0xffffffff] has been reserved
[    1.439033] system 00:06: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.439033] pnp 00:07: [io  0x0070-0x0071]
[    1.439033] pnp 00:07: [irq 8]
[    1.439033] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.439033] pnp 00:08: [mem 0xfed00000-0xfed003ff]
[    1.439033] pnp 00:08: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.439007] Switched to NOHz mode on CPU #2
[    1.439033] Switched to NOHz mode on CPU #0
[    1.439029] Switched to NOHz mode on CPU #1
[    1.439033] pnp 00:09: [io  0x0060]
[    1.439033] pnp 00:09: [io  0x0064]
[    1.439033] pnp 00:09: [irq 1]
[    1.439033] pnp 00:09: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.439033] pnp 00:0a: [irq 12]
[    1.439033] pnp 00:0a: Plug and Play ACPI device, IDs SYN0178 SYN0100 SYN0002 PNP0f13 (active)
[    1.664168] pnp 00:0b: [irq 23]
[    1.664236] pnp 00:0b: Plug and Play ACPI device, IDs HPQ0004 (active)
[    1.664485] pnp: PnP ACPI: found 12 devices
[    1.664487] ACPI: ACPI bus type pnp unregistered
[    1.670329] pci 0000:02:00.0: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]
[    1.670335] PCI: max bus depth: 1 pci_try_num: 2
[    1.670359] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.670362] pci 0000:00:01.0:   bridge window [io  0x5000-0x5fff]
[    1.670365] pci 0000:00:01.0:   bridge window [mem 0xd4300000-0xd44fffff]
[    1.670368] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
[    1.670374] pci 0000:02:00.0: BAR 6: assigned [mem 0xd0000000-0xd001ffff pref]
[    1.670377] pci 0000:00:04.0: PCI bridge to [bus 02-02]
[    1.670379] pci 0000:00:04.0:   bridge window [io  0x3000-0x4fff]
[    1.670382] pci 0000:00:04.0:   bridge window [mem 0xd3200000-0xd42fffff]
[    1.670385] pci 0000:00:04.0:   bridge window [mem 0xd0000000-0xd0ffffff 64bit pref]
[    1.670390] pci 0000:03:00.0: BAR 0: assigned [mem 0xd2100000-0xd21000ff]
[    1.670398] pci 0000:03:00.0: BAR 0: set to [mem 0xd2100000-0xd21000ff] (PCI address [0xd2100000-0xd21000ff])
[    1.670401] pci 0000:00:05.0: PCI bridge to [bus 03-03]
[    1.670403] pci 0000:00:05.0:   bridge window [io  0x2000-0x2fff]
[    1.670406] pci 0000:00:05.0:   bridge window [mem 0xd2100000-0xd31fffff]
[    1.670409] pci 0000:00:05.0:   bridge window [mem 0xd1000000-0xd1ffffff 64bit pref]
[    1.670413] pci 0000:00:09.0: PCI bridge to [bus 04-04]
[    1.670414] pci 0000:00:09.0:   bridge window [io  disabled]
[    1.670417] pci 0000:00:09.0:   bridge window [mem 0xd2000000-0xd20fffff]
[    1.670420] pci 0000:00:09.0:   bridge window [mem pref disabled]
[    1.670423] pci 0000:00:14.4: PCI bridge to [bus 05-05]
[    1.670430] pci 0000:00:14.4:   bridge window [io  0x1000-0x1fff]
[    1.670435] pci 0000:00:14.4:   bridge window [mem disabled]
[    1.670438] pci 0000:00:14.4:   bridge window [mem pref disabled]
[    1.670448] pci 0000:00:01.0: setting latency timer to 64
[    1.670458] pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.670461] pci 0000:00:04.0: setting latency timer to 64
[    1.670467] pci 0000:00:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.670470] pci 0000:00:05.0: setting latency timer to 64
[    1.670474] pci 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.670477] pci 0000:00:09.0: setting latency timer to 64
[    1.670484] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.670486] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.670488] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.670490] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff]
[    1.670493] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff]
[    1.670495] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff]
[    1.670497] pci_bus 0000:00: resource 10 [mem 0x000d0000-0x000d3fff]
[    1.670499] pci_bus 0000:00: resource 11 [mem 0x000d4000-0x000d7fff]
[    1.670501] pci_bus 0000:00: resource 12 [mem 0x000d8000-0x000dbfff]
[    1.670504] pci_bus 0000:00: resource 13 [mem 0x000dc000-0x000dffff]
[    1.670506] pci_bus 0000:00: resource 14 [mem 0x000e0000-0x000e3fff]
[    1.670508] pci_bus 0000:00: resource 15 [mem 0x000e4000-0x000e7fff]
[    1.670510] pci_bus 0000:00: resource 16 [mem 0x000e8000-0x000ebfff]
[    1.670512] pci_bus 0000:00: resource 17 [mem 0x000ec000-0x000effff]
[    1.670515] pci_bus 0000:00: resource 18 [mem 0xc0000000-0xdfffffff]
[    1.670517] pci_bus 0000:00: resource 19 [mem 0xf0000000-0xffffffff]
[    1.670519] pci_bus 0000:01: resource 0 [io  0x5000-0x5fff]
[    1.670522] pci_bus 0000:01: resource 1 [mem 0xd4300000-0xd44fffff]
[    1.670524] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xcfffffff 64bit pref]
[    1.670526] pci_bus 0000:02: resource 0 [io  0x3000-0x4fff]
[    1.670529] pci_bus 0000:02: resource 1 [mem 0xd3200000-0xd42fffff]
[    1.670531] pci_bus 0000:02: resource 2 [mem 0xd0000000-0xd0ffffff 64bit pref]
[    1.670533] pci_bus 0000:03: resource 0 [io  0x2000-0x2fff]
[    1.670536] pci_bus 0000:03: resource 1 [mem 0xd2100000-0xd31fffff]
[    1.670538] pci_bus 0000:03: resource 2 [mem 0xd1000000-0xd1ffffff 64bit pref]
[    1.670540] pci_bus 0000:04: resource 1 [mem 0xd2000000-0xd20fffff]
[    1.670543] pci_bus 0000:05: resource 0 [io  0x1000-0x1fff]
[    1.670545] pci_bus 0000:05: resource 4 [io  0x0000-0x0cf7]
[    1.670547] pci_bus 0000:05: resource 5 [io  0x0d00-0xffff]
[    1.670549] pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff]
[    1.670552] pci_bus 0000:05: resource 7 [mem 0x000c0000-0x000c3fff]
[    1.670554] pci_bus 0000:05: resource 8 [mem 0x000c4000-0x000c7fff]
[    1.670556] pci_bus 0000:05: resource 9 [mem 0x000c8000-0x000cbfff]
[    1.670558] pci_bus 0000:05: resource 10 [mem 0x000d0000-0x000d3fff]
[    1.670560] pci_bus 0000:05: resource 11 [mem 0x000d4000-0x000d7fff]
[    1.670563] pci_bus 0000:05: resource 12 [mem 0x000d8000-0x000dbfff]
[    1.670565] pci_bus 0000:05: resource 13 [mem 0x000dc000-0x000dffff]
[    1.670567] pci_bus 0000:05: resource 14 [mem 0x000e0000-0x000e3fff]
[    1.670569] pci_bus 0000:05: resource 15 [mem 0x000e4000-0x000e7fff]
[    1.670571] pci_bus 0000:05: resource 16 [mem 0x000e8000-0x000ebfff]
[    1.670574] pci_bus 0000:05: resource 17 [mem 0x000ec000-0x000effff]
[    1.670576] pci_bus 0000:05: resource 18 [mem 0xc0000000-0xdfffffff]
[    1.670578] pci_bus 0000:05: resource 19 [mem 0xf0000000-0xffffffff]
[    1.670608] NET: Registered protocol family 2
[    1.670646] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    1.671244] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    1.672561] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.672879] TCP: Hash tables configured (established 262144 bind 65536)
[    1.672882] TCP reno registered
[    1.672886] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    1.672937] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    1.673060] NET: Registered protocol family 1
[    1.673216] RPC: Registered named UNIX socket transport module.
[    1.673218] RPC: Registered udp transport module.
[    1.673219] RPC: Registered tcp transport module.
[    1.673221] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.673232] pci 0000:00:00.0: calling quirk_amd_780_apc_msi+0x0/0x42
[    1.673235] pci 0000:00:01.0: MSI quirk detected; subordinate MSI disabled
[    1.673241] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.673244] pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x55d
[    1.673249] pci 0000:00:00.0: calling pci_fixup_video+0x0/0xa8
[    1.673254] pci 0000:00:01.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.673257] pci 0000:00:01.0: calling quirk_usb_early_handoff+0x0/0x55d
[    1.673259] pci 0000:00:01.0: calling pci_fixup_video+0x0/0xa8
[    1.673264] pci 0000:00:04.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.673267] pci 0000:00:04.0: calling quirk_usb_early_handoff+0x0/0x55d
[    1.673270] pci 0000:00:04.0: calling pci_fixup_video+0x0/0xa8
[    1.673274] pci 0000:00:05.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.673277] pci 0000:00:05.0: calling quirk_usb_early_handoff+0x0/0x55d
[    1.673280] pci 0000:00:05.0: calling pci_fixup_video+0x0/0xa8
[    1.673284] pci 0000:00:09.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.673287] pci 0000:00:09.0: calling quirk_usb_early_handoff+0x0/0x55d
[    1.673289] pci 0000:00:09.0: calling pci_fixup_video+0x0/0xa8
[    1.673294] pci 0000:00:11.0: calling quirk_msi_intx_disable_ati_bug+0x0/0x38
[    1.673299] pci 0000:00:11.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.673302] pci 0000:00:11.0: calling quirk_usb_early_handoff+0x0/0x55d
[    1.673304] pci 0000:00:11.0: calling pci_fixup_video+0x0/0xa8
[    1.673309] pci 0000:00:12.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.673312] pci 0000:00:12.0: calling quirk_usb_early_handoff+0x0/0x55d
[    1.673358] pci 0000:00:12.0: calling pci_fixup_video+0x0/0xa8
[    1.673364] pci 0000:00:12.2: calling quirk_cardbus_legacy+0x0/0x30
[    1.673366] pci 0000:00:12.2: calling quirk_usb_early_handoff+0x0/0x55d
[    1.673387] pci 0000:00:12.2: calling pci_fixup_video+0x0/0xa8
[    1.673392] pci 0000:00:13.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.673395] pci 0000:00:13.0: calling quirk_usb_early_handoff+0x0/0x55d
[    1.673409] pci 0000:00:13.0: calling pci_fixup_video+0x0/0xa8
[    1.673414] pci 0000:00:13.2: calling quirk_cardbus_legacy+0x0/0x30
[    1.673417] pci 0000:00:13.2: calling quirk_usb_early_handoff+0x0/0x55d
[    1.673436] pci 0000:00:13.2: calling pci_fixup_video+0x0/0xa8
[    1.673441] pci 0000:00:14.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.673444] pci 0000:00:14.0: calling quirk_usb_early_handoff+0x0/0x55d
[    1.673446] pci 0000:00:14.0: calling pci_fixup_video+0x0/0xa8
[    1.673451] pci 0000:00:14.2: calling quirk_cardbus_legacy+0x0/0x30
[    1.673454] pci 0000:00:14.2: calling quirk_usb_early_handoff+0x0/0x55d
[    1.673457] pci 0000:00:14.2: calling pci_fixup_video+0x0/0xa8
[    1.673460] PCI: CLS mismatch (64 != 32), using 64 bytes
[    1.673464] pci 0000:00:14.3: calling quirk_cardbus_legacy+0x0/0x30
[    1.673466] pci 0000:00:14.3: calling quirk_usb_early_handoff+0x0/0x55d
[    1.673469] pci 0000:00:14.3: calling pci_fixup_video+0x0/0xa8
[    1.673473] pci 0000:00:14.4: calling quirk_cardbus_legacy+0x0/0x30
[    1.673476] pci 0000:00:14.4: calling quirk_usb_early_handoff+0x0/0x55d
[    1.673478] pci 0000:00:14.4: calling pci_fixup_video+0x0/0xa8
[    1.673483] pci 0000:00:14.5: calling quirk_cardbus_legacy+0x0/0x30
[    1.673485] pci 0000:00:14.5: calling quirk_usb_early_handoff+0x0/0x55d
[    1.673504] pci 0000:00:14.5: calling pci_fixup_video+0x0/0xa8
[    1.673508] pci 0000:00:16.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.673511] pci 0000:00:16.0: calling quirk_usb_early_handoff+0x0/0x55d
[    1.673525] pci 0000:00:16.0: calling pci_fixup_video+0x0/0xa8
[    1.673529] pci 0000:00:16.2: calling quirk_cardbus_legacy+0x0/0x30
[    1.673532] pci 0000:00:16.2: calling quirk_usb_early_handoff+0x0/0x55d
[    1.673550] pci 0000:00:16.2: calling pci_fixup_video+0x0/0xa8
[    1.673555] pci 0000:00:18.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.673557] pci 0000:00:18.0: calling quirk_usb_early_handoff+0x0/0x55d
[    1.673560] pci 0000:00:18.0: calling pci_fixup_video+0x0/0xa8
[    1.673564] pci 0000:00:18.1: calling quirk_cardbus_legacy+0x0/0x30
[    1.673567] pci 0000:00:18.1: calling quirk_usb_early_handoff+0x0/0x55d
[    1.673569] pci 0000:00:18.1: calling pci_fixup_video+0x0/0xa8
[    1.673573] pci 0000:00:18.2: calling quirk_cardbus_legacy+0x0/0x30
[    1.673576] pci 0000:00:18.2: calling quirk_usb_early_handoff+0x0/0x55d
[    1.673579] pci 0000:00:18.2: calling pci_fixup_video+0x0/0xa8
[    1.673583] pci 0000:00:18.3: calling quirk_cardbus_legacy+0x0/0x30
[    1.673585] pci 0000:00:18.3: calling quirk_usb_early_handoff+0x0/0x55d
[    1.673588] pci 0000:00:18.3: calling pci_fixup_video+0x0/0xa8
[    1.673592] pci 0000:00:18.4: calling quirk_cardbus_legacy+0x0/0x30
[    1.673595] pci 0000:00:18.4: calling quirk_usb_early_handoff+0x0/0x55d
[    1.673598] pci 0000:00:18.4: calling pci_fixup_video+0x0/0xa8
[    1.673602] pci 0000:01:05.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.673605] pci 0000:01:05.0: calling quirk_usb_early_handoff+0x0/0x55d
[    1.673607] pci 0000:01:05.0: calling pci_fixup_video+0x0/0xa8
[    1.673610] pci 0000:01:05.0: Boot video device
[    1.673614] pci 0000:01:05.1: calling quirk_cardbus_legacy+0x0/0x30
[    1.673616] pci 0000:01:05.1: calling quirk_usb_early_handoff+0x0/0x55d
[    1.673619] pci 0000:01:05.1: calling pci_fixup_video+0x0/0xa8
[    1.673623] pci 0000:02:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.673626] pci 0000:02:00.0: calling quirk_usb_early_handoff+0x0/0x55d
[    1.673629] pci 0000:02:00.0: calling pci_fixup_video+0x0/0xa8
[    1.673633] pci 0000:03:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.673635] pci 0000:03:00.0: calling quirk_usb_early_handoff+0x0/0x55d
[    1.673638] pci 0000:03:00.0: calling pci_fixup_video+0x0/0xa8
[    1.673678] Unpacking initramfs...
[    1.882094] Freeing initrd memory: 11316k freed
[    1.885746] PCI-DMA: Disabling AGP.
[    1.888947] PCI-DMA: aperture base @ a4000000 size 65536 KB
[    1.888948] PCI-DMA: using GART IOMMU.
[    1.888951] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    1.909452] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    1.909718] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    1.909727] NTFS driver 2.1.30 [Flags: R/O].
[    1.909828] fuse init (API version 7.16)
[    1.909940] msgmni has been set to 15388
[    1.910169] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.910172] io scheduler noop registered
[    1.910174] io scheduler deadline registered
[    1.910210] io scheduler cfq registered (default)
[    1.910282] pcieport 0000:00:04.0: setting latency timer to 64
[    1.910306] pcieport 0000:00:04.0: irq 40 for MSI/MSI-X
[    1.910343] pcieport 0000:00:05.0: setting latency timer to 64
[    1.910362] pcieport 0000:00:05.0: irq 41 for MSI/MSI-X
[    1.910393] pcieport 0000:00:09.0: setting latency timer to 64
[    1.910412] pcieport 0000:00:09.0: irq 42 for MSI/MSI-X
[    2.152170] ACPI: AC Adapter [AC] (on-line)
[    2.152252] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
[    2.152257] ACPI: Sleep Button [SLPB]
[    2.152294] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    2.152333] ACPI: Lid Switch [LID]
[    2.152371] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    2.152373] ACPI: Power Button [PWRF]
[    2.152637] ACPI: Fan [FAN0] (off)
[    2.152701] ACPI: Fan [FAN1] (off)
[    2.152732] ACPI: Fan [FAN2] (off)
[    2.152763] ACPI: Fan [FAN3] (off)
[    2.152790] ACPI: Fan [FAN4] (off)
[    2.152799] ACPI: acpi_idle registered with cpuidle
[    2.152821] ACPI: processor limited to max C-state 1
[    2.396854] thermal LNXTHERM:00: registered as thermal_zone0
[    2.396857] ACPI: Thermal Zone [CPUZ] (57 C)
[    2.407056] thermal LNXTHERM:01: registered as thermal_zone1
[    2.407059] ACPI: Thermal Zone [TZ3] (31 C)
[    2.407159] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.454557] ACPI: Battery Slot [BAT0] (battery present)
[    2.454636] ACPI: Battery Slot [BAT1] (battery absent)
[    2.636444] Non-volatile memory driver v1.3
[    2.636447] Linux agpgart interface v0.103
[    2.636521] ahci 0000:00:11.0: version 3.0
[    2.636539] ahci 0000:00:11.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.636664] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 5 ports 6 Gbps 0x1f impl SATA mode
[    2.636668] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part sxs 
[    2.637292] scsi0 : ahci
[    2.637493] scsi1 : ahci
[    2.637619] scsi2 : ahci
[    2.637727] scsi3 : ahci
[    2.637831] scsi4 : ahci
[    2.637965] ata1: SATA max UDMA/133 abar m1024@0xd450b000 port 0xd450b100 irq 19
[    2.637969] ata2: SATA max UDMA/133 abar m1024@0xd450b000 port 0xd450b180 irq 19
[    2.637972] ata3: SATA max UDMA/133 abar m1024@0xd450b000 port 0xd450b200 irq 19
[    2.637975] ata4: SATA max UDMA/133 abar m1024@0xd450b000 port 0xd450b280 irq 19
[    2.637978] ata5: SATA max UDMA/133 abar m1024@0xd450b000 port 0xd450b300 irq 19
[    2.638022] sky2: driver version 1.28
[    2.638076] sky2 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.638147] sky2 0000:02:00.0: setting latency timer to 64
[    2.638286] sky2 0000:02:00.0: Yukon-2 Optima chip revision 1
[    2.638457] sky2 0000:02:00.0: irq 43 for MSI/MSI-X
[    2.638813] sky2 0000:02:00.0: eth0: addr 1c:c1:de:91:f5:1c
[    2.638961] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.638981] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.639003] ehci_hcd 0000:00:12.2: setting latency timer to 64
[    2.639006] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    2.639029] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    2.639037] ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    2.639056] QUIRK: Enable AMD PLL fix
[    2.639067] ehci_hcd 0000:00:12.2: debug port 1
[    2.639075] ehci_hcd 0000:00:12.2: enabling Mem-Wr-Inval
[    2.639090] ehci_hcd 0000:00:12.2: irq 17, io mem 0xd4509000
[    2.648106] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    2.648130] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.648133] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.648135] usb usb1: Product: EHCI Host Controller
[    2.648137] usb usb1: Manufacturer: Linux 3.0.0-rc7-probook_6555b+ ehci_hcd
[    2.648139] usb usb1: SerialNumber: 0000:00:12.2
[    2.648244] hub 1-0:1.0: USB hub found
[    2.648247] hub 1-0:1.0: 5 ports detected
[    2.648341] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.648362] ehci_hcd 0000:00:13.2: setting latency timer to 64
[    2.648366] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    2.648372] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    2.648380] ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    2.648400] ehci_hcd 0000:00:13.2: debug port 1
[    2.648408] ehci_hcd 0000:00:13.2: enabling Mem-Wr-Inval
[    2.648416] ehci_hcd 0000:00:13.2: irq 17, io mem 0xd4507000
[    2.660094] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    2.660118] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    2.660120] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.660122] usb usb2: Product: EHCI Host Controller
[    2.660124] usb usb2: Manufacturer: Linux 3.0.0-rc7-probook_6555b+ ehci_hcd
[    2.660126] usb usb2: SerialNumber: 0000:00:13.2
[    2.660226] hub 2-0:1.0: USB hub found
[    2.660230] hub 2-0:1.0: 5 ports detected
[    2.660326] ehci_hcd 0000:00:16.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.660346] ehci_hcd 0000:00:16.2: setting latency timer to 64
[    2.660350] ehci_hcd 0000:00:16.2: EHCI Host Controller
[    2.660357] ehci_hcd 0000:00:16.2: new USB bus registered, assigned bus number 3
[    2.660365] ehci_hcd 0000:00:16.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    2.660385] ehci_hcd 0000:00:16.2: debug port 1
[    2.660393] ehci_hcd 0000:00:16.2: enabling Mem-Wr-Inval
[    2.660400] ehci_hcd 0000:00:16.2: irq 17, io mem 0xd4504000
[    2.672095] ehci_hcd 0000:00:16.2: USB 2.0 started, EHCI 1.00
[    2.672117] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    2.672119] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.672122] usb usb3: Product: EHCI Host Controller
[    2.672124] usb usb3: Manufacturer: Linux 3.0.0-rc7-probook_6555b+ ehci_hcd
[    2.672126] usb usb3: SerialNumber: 0000:00:16.2
[    2.672222] hub 3-0:1.0: USB hub found
[    2.672226] hub 3-0:1.0: 4 ports detected
[    2.672309] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.672334] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.672355] ohci_hcd 0000:00:12.0: setting latency timer to 64
[    2.672359] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    2.672365] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 4
[    2.672395] ohci_hcd 0000:00:12.0: irq 18, io mem 0xd450a000
[    2.732113] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.732116] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.732119] usb usb4: Product: OHCI Host Controller
[    2.732121] usb usb4: Manufacturer: Linux 3.0.0-rc7-probook_6555b+ ohci_hcd
[    2.732123] usb usb4: SerialNumber: 0000:00:12.0
[    2.732227] hub 4-0:1.0: USB hub found
[    2.732237] hub 4-0:1.0: 5 ports detected
[    2.732319] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.732341] ohci_hcd 0000:00:13.0: setting latency timer to 64
[    2.732344] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    2.732350] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    2.732368] ohci_hcd 0000:00:13.0: irq 18, io mem 0xd4508000
[    2.792113] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.792117] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.792119] usb usb5: Product: OHCI Host Controller
[    2.792121] usb usb5: Manufacturer: Linux 3.0.0-rc7-probook_6555b+ ohci_hcd
[    2.792123] usb usb5: SerialNumber: 0000:00:13.0
[    2.792222] hub 5-0:1.0: USB hub found
[    2.792232] hub 5-0:1.0: 5 ports detected
[    2.792316] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.792338] ohci_hcd 0000:00:14.5: setting latency timer to 64
[    2.792341] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    2.792348] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 6
[    2.792366] ohci_hcd 0000:00:14.5: irq 18, io mem 0xd4506000
[    2.852135] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    2.852138] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.852141] usb usb6: Product: OHCI Host Controller
[    2.852143] usb usb6: Manufacturer: Linux 3.0.0-rc7-probook_6555b+ ohci_hcd
[    2.852145] usb usb6: SerialNumber: 0000:00:14.5
[    2.852246] hub 6-0:1.0: USB hub found
[    2.852257] hub 6-0:1.0: 2 ports detected
[    2.852343] ohci_hcd 0000:00:16.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.852365] ohci_hcd 0000:00:16.0: setting latency timer to 64
[    2.852368] ohci_hcd 0000:00:16.0: OHCI Host Controller
[    2.852374] ohci_hcd 0000:00:16.0: new USB bus registered, assigned bus number 7
[    2.852393] ohci_hcd 0000:00:16.0: irq 18, io mem 0xd4505000
[    2.904108] Refined TSC clocksource calibration: 2094.754 MHz.
[    2.904113] Switching to clocksource tsc
[    2.916118] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    2.916122] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.916124] usb usb7: Product: OHCI Host Controller
[    2.916126] usb usb7: Manufacturer: Linux 3.0.0-rc7-probook_6555b+ ohci_hcd
[    2.916128] usb usb7: SerialNumber: 0000:00:16.0
[    2.916232] hub 7-0:1.0: USB hub found
[    2.916241] hub 7-0:1.0: 4 ports detected
[    2.916361] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    2.918078] i8042: Detected active multiplexing controller, rev 1.1
[    2.918797] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.918803] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    2.918805] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    2.918807] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    2.918810] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    2.918839] mousedev: PS/2 mouse device common for all mice
[    2.919013] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    2.919054] rtc_cmos 00:07: RTC can wake from S4
[    2.919132] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    2.919154] rtc0: alarms up to one day, 114 bytes nvram, hpet irqs
[    2.919259] device-mapper: uevent: version 1.0.3
[    2.919327] device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised: dm-devel@redhat.com
[    2.919364] cpuidle: using governor ladder
[    2.919366] cpuidle: using governor menu
[    2.919530] usbcore: registered new interface driver usbhid
[    2.919532] usbhid: USB HID core driver
[    2.919562] TCP cubic registered
[    2.919564] NET: Registered protocol family 17
[    2.919576] Registering the dns_resolver key type
[    2.941238] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    2.956141] ata3: SATA link down (SStatus 0 SControl 300)
[    2.956191] ata5: SATA link down (SStatus 0 SControl 300)
[    2.956220] ata4: SATA link down (SStatus 0 SControl 300)
[    3.128127] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.128159] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.133098] ata1.00: ATA-8: WDC WD7500BPVT-00HXZT1, 01.01A01, max UDMA/133
[    3.133102] ata1.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    3.138104] ata1.00: configured for UDMA/133
[    3.138282] scsi 0:0:0:0: Direct-Access     ATA      WDC WD7500BPVT-0 01.0 PQ: 0 ANSI: 5
[    3.138434] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.138509] sd 0:0:0:0: [sda] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[    3.138613] sd 0:0:0:0: [sda] Write Protect is off
[    3.138618] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.138643] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.139013] ata2.00: ATAPI: hp      DVD RW AD-7586H, KH04, max UDMA/100
[    3.151025] ata2.00: configured for UDMA/100
[    3.154278] scsi 1:0:0:0: CD-ROM            hp       DVD RW AD-7586H  KH04 PQ: 0 ANSI: 5
[    3.159515] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    3.159520] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.159610] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    3.159658] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    3.251170]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 > sda4
[    3.251671] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.252027] rtc_cmos 00:07: setting system clock to 2011-07-18 15:26:19 UTC (1311002779)
[    3.252031] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[    3.252886] Freeing unused kernel memory: 528k freed
[    3.253004] Write protecting the kernel read-only data: 10240k
[    3.258079] Freeing unused kernel memory: 1512k freed
[    3.265234] Freeing unused kernel memory: 2036k freed
[    3.437810] udev[82]: starting version 166
[    3.686265] [drm] Initialized drm 1.1.0 20060810
[    3.696412] [drm] radeon defaulting to kernel modesetting.
[    3.696415] [drm] radeon kernel modesetting enabled.
[    3.696495] radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.696499] radeon 0000:01:05.0: setting latency timer to 64
[    3.696735] [drm] initializing kernel modesetting (RS880 0x1002:0x9712).
[    3.696773] [drm] register mmio base: 0xD4400000
[    3.696775] [drm] register mmio size: 65536
[    3.697469] ATOM BIOS: HP_Timex
[    3.697490] radeon 0000:01:05.0: VRAM: 320M 0x00000000C0000000 - 0x00000000D3FFFFFF (320M used)
[    3.697492] radeon 0000:01:05.0: GTT: 512M 0x00000000A0000000 - 0x00000000BFFFFFFF
[    3.697706] [drm] Detected VRAM RAM=320M, BAR=256M
[    3.697710] [drm] RAM width 32bits DDR
[    3.697782] [TTM] Zone  kernel: Available graphics memory: 3941618 kiB.
[    3.697786] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[    3.697788] [TTM] Initializing pool allocator.
[    3.697817] [drm] radeon: 320M of VRAM memory ready
[    3.697819] [drm] radeon: 512M of GTT memory ready.
[    3.697833] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    3.697835] [drm] Driver supports precise vblank timestamp query.
[    3.697854] [drm] radeon: irq initialized.
[    3.697859] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    3.698898] [drm] Loading RS780 Microcode
[    3.707144] radeon 0000:01:05.0: WB enabled
[    3.739014] [drm] ring test succeeded in 1 usecs
[    3.739092] [drm] radeon: ib pool ready.
[    3.739150] [drm] ib test succeeded in 0 usecs
[    3.739672] [drm] Radeon Display Connectors
[    3.739675] [drm] Connector 0:
[    3.739677] [drm]   VGA
[    3.739679] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[    3.739681] [drm]   Encoders:
[    3.739683] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    3.739684] [drm] Connector 1:
[    3.739685] [drm]   LVDS
[    3.739687] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[    3.739689] [drm]   Encoders:
[    3.739690] [drm]     LCD1: INTERNAL_KLDSCP_LVTMA
[    3.739691] [drm] Connector 2:
[    3.739693] [drm]   DisplayPort
[    3.739694] [drm]   HPD1
[    3.739696] [drm]   DDC: 0x7e60 0x7e60 0x7e64 0x7e64 0x7e68 0x7e68 0x7e6c 0x7e6c
[    3.739697] [drm]   Encoders:
[    3.739698] [drm]     DFP1: INTERNAL_UNIPHY
[    3.739700] [drm] Connector 3:
[    3.739701] [drm]   DisplayPort
[    3.739702] [drm]   HPD2
[    3.739704] [drm]   DDC: 0x7e20 0x7e20 0x7e24 0x7e24 0x7e28 0x7e28 0x7e2c 0x7e2c
[    3.739705] [drm]   Encoders:
[    3.739706] [drm]     DFP2: INTERNAL_UNIPHY
[    3.749428] Synaptics Touchpad, model: 1, fw: 7.4, id: 0x1c0b1, caps: 0xd04773/0xa40000/0xa0400
[    3.792332] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input5
[    4.760567] [drm] radeon: power management initialized
[    5.806074] [drm] fb mappable at 0xC0141000
[    5.806077] [drm] vram apper at 0xC0000000
[    5.806079] [drm] size 5787648
[    5.806080] [drm] fb depth is 24
[    5.806081] [drm]    pitch is 6400
[    5.806148] fbcon: radeondrmfb (fb0) is primary device
[    5.881617] Console: switching to colour frame buffer device 200x56
[    5.895026] fb0: radeondrmfb frame buffer device
[    5.895028] drm: registered panic notifier
[    5.895035] [drm] Initialized radeon 2.10.0 20080528 for 0000:01:05.0 on minor 0
[    6.032873] PM: Starting manual resume from disk
[    6.363415] EXT4-fs (sda4): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[    6.430754] EXT4-fs (sda4): re-mounted. Opts: acl,user_xattr
[   10.266407] udev[408]: starting version 166
[   10.726800] hp_accel: laptop model unknown, using default axes configuration
[   10.727419] lis3lv02d: 8 bits sensor found
[   10.735153] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[   10.772105] input: ST LIS3LV02DL Accelerometer as /devices/platform/lis3lv02d/input/input6
[   10.772235] Registered led device: hp::hddprotect
[   10.772252] hp_accel: driver loaded
[   10.843234] wmi: Mapper loaded
[   10.996784] tpm_tis 00:03: 1.2 TPM (device-id 0xB, rev-id 16)
[   11.003590] sdhci: Secure Digital Host Controller Interface driver
[   11.003593] sdhci: Copyright(c) Pierre Ossman
[   11.005587] sdhci-pci 0000:03:00.0: SDHCI controller found [1180:e822] (rev 1)
[   11.005606] sdhci-pci 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   11.005658] sdhci-pci 0000:03:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
[   11.005664] sdhci-pci 0000:03:00.0: setting latency timer to 64
[   11.005702] Registered led device: mmc0::
[   11.005737] mmc0: SDHCI controller on PCI [0000:03:00.0] using DMA
[   11.072323] input: HP WMI hotkeys as /devices/virtual/input/input7
[   11.080253] udev[416]: renamed network interface eth0 to en0
[   11.117775] kvm: Nested Virtualization enabled
[   11.117779] kvm: Nested Paging enabled
[   11.204216] HDA Intel 0000:00:14.2: power state changed by ACPI to D0
[   11.204221] hp_wmi: device hp-wifi blocked by BIOS
[   11.204233] HDA Intel 0000:00:14.2: power state changed by ACPI to D0
[   11.204243] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   11.384254] input: HDA ATI SB Line In at Sep Rear Jack as /devices/pci0000:00/0000:00:14.2/sound/card0/input8
[   11.384329] input: HDA ATI SB Mic at Ext Left Jack as /devices/pci0000:00/0000:00:14.2/sound/card0/input9
[   11.384375] input: HDA ATI SB Line Out at Ext Left Jack as /devices/pci0000:00/0000:00:14.2/sound/card0/input10
[   11.384419] input: HDA ATI SB HP Out at Sep Rear Jack as /devices/pci0000:00/0000:00:14.2/sound/card0/input11
[   11.384527] HDA Intel 0000:01:05.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   11.384586] HDA Intel 0000:01:05.1: setting latency timer to 64
[   12.352584] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:14.2/input/input12
[   12.940509] Adding 8384508k swap on /dev/sda8.  Priority:-1 extents:1 across:8384508k 
[   13.857027] loop: module loaded
[   33.622111] Intel AES-NI instructions are not detected.
[   38.570937] EXT3-fs: barriers not enabled
[   38.581122] kjournald starting.  Commit interval 5 seconds
[   38.581151] EXT3-fs (sda2): mounted filesystem with ordered data mode
[   38.654026] EXT3-fs: barriers not enabled
[   38.687932] kjournald starting.  Commit interval 5 seconds
[   38.708876] EXT3-fs (sda5): using internal journal
[   38.708882] EXT3-fs (sda5): mounted filesystem with journal data mode
[   38.748977] EXT3-fs: barriers not enabled
[   38.765446] kjournald starting.  Commit interval 5 seconds
[   38.766214] EXT3-fs (dm-3): using internal journal
[   38.766220] EXT3-fs (dm-3): mounted filesystem with journal data mode
[   38.844251] EXT3-fs: barriers not enabled
[   38.858684] kjournald starting.  Commit interval 5 seconds
[   38.859275] EXT3-fs (dm-4): using internal journal
[   38.859280] EXT3-fs (dm-4): mounted filesystem with journal data mode
[   38.903854] EXT3-fs: barriers not enabled
[   38.917801] kjournald starting.  Commit interval 5 seconds
[   38.918743] EXT3-fs (dm-2): using internal journal
[   38.918749] EXT3-fs (dm-2): mounted filesystem with writeback data mode
[   39.026488] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
[   39.240339] ISO 9660 Extensions: Microsoft Joliet Level 3
[   39.252733] ISO 9660 Extensions: RRIP_1991A
[   39.327686] ISO 9660 Extensions: Microsoft Joliet Level 3
[   39.345286] ISO 9660 Extensions: RRIP_1991A
[   39.601468] ISO 9660 Extensions: Microsoft Joliet Level 3
[   39.615626] ISO 9660 Extensions: RRIP_1991A
[   39.720579] ISO 9660 Extensions: Microsoft Joliet Level 3
[   39.744793] ISO 9660 Extensions: RRIP_1991A
[   40.174469] ISO 9660 Extensions: Microsoft Joliet Level 3
[   40.195664] ISO 9660 Extensions: RRIP_1991A
[   40.415080] ISO 9660 Extensions: Microsoft Joliet Level 3
[   40.438688] ISO 9660 Extensions: RRIP_1991A
[   40.645527] ISO 9660 Extensions: Microsoft Joliet Level 3
[   40.671578] ISO 9660 Extensions: RRIP_1991A
[   40.831329] ISO 9660 Extensions: Microsoft Joliet Level 3
[   40.865503] ISO 9660 Extensions: RRIP_1991A
[   41.045986] ISO 9660 Extensions: Microsoft Joliet Level 3
[   41.076816] ISO 9660 Extensions: RRIP_1991A
[   41.420023] ISO 9660 Extensions: Microsoft Joliet Level 3
[   41.489447] ISO 9660 Extensions: RRIP_1991A
[   42.596830] powernow-k8: Found 1 AMD Phenom(tm) II N830 Triple-Core Processor (3 cpu cores) (version 2.20.00)
[   42.596870] powernow-k8:    0 : pstate 0 (2100 MHz)
[   42.596872] powernow-k8:    1 : pstate 1 (1800 MHz)
[   42.596874] powernow-k8:    2 : pstate 2 (1500 MHz)
[   42.596875] powernow-k8:    3 : pstate 3 (1200 MHz)
[   42.596877] powernow-k8:    4 : pstate 4 (800 MHz)
[   43.162046] sky2 0000:02:00.0: en0: enabling interface
[   43.376143] worker_enter_idle: c 1 3           (null)
[   43.376148] ------------[ cut here ]------------
[   43.376157] WARNING: at /dist/mirror/Xen/linux-2.6/kernel/workqueue.c:1231 worker_enter_idle+0x16f/0x1b0()
[   43.376161] Hardware name: HP ProBook 6555b
[   43.376164] Modules linked in: snd_pcm_oss snd_mixer_oss powernow_k8 snd_seq snd_seq_device mperf sha256_generic cryptd aes_x86_64 aes_generic loop snd_hda_codec_hdmi snd_hda_codec_idt tpm_infineon kvm_amd kvm snd_hda_intel sdhci_pci sdhci tpm_tis hp_wmi mmc_core tpm sparse_keymap wmi snd_hda_codec snd_pcm snd_timer snd soundcore snd_page_alloc tpm_bios joydev i2c_piix4 hp_accel lis3lv02d k10temp input_polldev radeon ttm drm_kms_helper drm i2c_algo_bit xenbus_probe_frontend
[   43.376206] Pid: 42, comm: kworker/2:2 Not tainted 3.0.0-rc7-probook_6555b+ #26
[   43.376209] Call Trace:
[   43.376216]  [<ffffffff81047c4b>] ? warn_slowpath_common+0x7b/0xc0
[   43.376221]  [<ffffffff8105c3bf>] ? worker_enter_idle+0x16f/0x1b0
[   43.376226]  [<ffffffff8105cfe8>] ? worker_thread+0x208/0x330
[   43.376231]  [<ffffffff81038aa0>] ? __wake_up_common+0x50/0x80
[   43.376235]  [<ffffffff8105cde0>] ? manage_workers+0x220/0x220
[   43.376239]  [<ffffffff8105cde0>] ? manage_workers+0x220/0x220
[   43.376243]  [<ffffffff81062f76>] ? kthread+0x96/0xa0
[   43.376249]  [<ffffffff8147eb84>] ? kernel_thread_helper+0x4/0x10
[   43.376253]  [<ffffffff81062ee0>] ? kthread_worker_fn+0x180/0x180
[   43.376257]  [<ffffffff8147eb80>] ? gs_change+0x13/0x13
[   43.376260] ---[ end trace c763dbadb9d930c1 ]---
[   45.646762] hda-intel: IRQ timing workaround is activated for card #1. Suggest a bigger bdl_pos_adj.
[   50.792150] EXT4-fs (sda4): re-mounted. Opts: acl,user_xattr,commit=0
[   50.868946] EXT4-fs (dm-1): re-mounted. Opts: commit=0
[  821.936288] worker_enter_idle: c 1 2           (null)
[ 1026.860177] usb 1-3: new high speed USB device number 2 using ehci_hcd
[ 1027.005805] usb 1-3: New USB device found, idVendor=19d2, idProduct=2000
[ 1027.005815] usb 1-3: New USB device strings: Mfr=2, Product=1, SerialNumber=3
[ 1027.005822] usb 1-3: Product: ZTE CDMA Technologies MSM
[ 1027.005827] usb 1-3: Manufacturer: ZTE,Incorporated
[ 1027.005832] usb 1-3: SerialNumber: P673A2VDF_MS
[ 1027.212344] Initializing USB Mass Storage driver...
[ 1027.213060] scsi5 : usb-storage 1-3:1.0
[ 1027.213344] usbcore: registered new interface driver usb-storage
[ 1027.213351] USB Mass Storage support registered.
[ 1029.848597] usb 1-3: USB disconnect, device number 2
[ 1035.132175] usb 1-3: new high speed USB device number 3 using ehci_hcd
[ 1035.275747] usb 1-3: New USB device found, idVendor=19d2, idProduct=0063
[ 1035.275756] usb 1-3: New USB device strings: Mfr=2, Product=1, SerialNumber=0
[ 1035.275764] usb 1-3: Product: ZTE CDMA Technologies MSM
[ 1035.275770] usb 1-3: Manufacturer: ZTE,Incorporated
[ 1035.278283] scsi6 : usb-storage 1-3:1.5
[ 1035.345398] usbcore: registered new interface driver usbserial
[ 1035.345404] usbserial: USB Serial Driver core
[ 1035.386906] USB Serial support registered for GSM modem (1-port)
[ 1035.387051] option 1-3:1.0: GSM modem (1-port) converter detected
[ 1035.387243] usb 1-3: GSM modem (1-port) converter now attached to ttyUSB0
[ 1035.387287] option 1-3:1.1: GSM modem (1-port) converter detected
[ 1035.387388] usb 1-3: GSM modem (1-port) converter now attached to ttyUSB1
[ 1035.387428] option 1-3:1.2: GSM modem (1-port) converter detected
[ 1035.387527] usb 1-3: GSM modem (1-port) converter now attached to ttyUSB2
[ 1035.387567] option 1-3:1.3: GSM modem (1-port) converter detected
[ 1035.387729] usb 1-3: GSM modem (1-port) converter now attached to ttyUSB3
[ 1035.387770] option 1-3:1.4: GSM modem (1-port) converter detected
[ 1035.387881] usb 1-3: GSM modem (1-port) converter now attached to ttyUSB4
[ 1035.387920] usbcore: registered new interface driver option
[ 1035.387924] option: v0.7.2:USB Driver for GSM modems
[ 1036.279632] scsi 6:0:0:0: Direct-Access     ZTE      MMC Storage      2.31 PQ: 0 ANSI: 2
[ 1036.279964] sd 6:0:0:0: Attached scsi generic sg2 type 0
[ 1036.289413] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[ 1068.816239] worker_enter_idle: c 1 2           (null)
[ 1083.693558] PPP generic driver version 2.4.2
[ 1083.778933] PPP BSD Compression module registered
[ 1083.982495] PPP Deflate Compression module registered
[ 1101.426638] tun: Universal TUN/TAP device driver, 1.6
[ 1101.426645] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[ 1167.136160] worker_enter_idle: c 1 3           (null)
[ 1220.896745] worker_enter_idle: c 1 3           (null)
[ 1280.176207] worker_enter_idle: c 1 3           (null)
[ 1304.820106] worker_enter_idle: c 1 3           (null)
[ 2091.140542] worker_enter_idle: c 1 3           (null)
[ 2275.856762] worker_enter_idle: c 1 3           (null)
[ 2382.976445] worker_enter_idle: c 1 2           (null)
[ 2387.696067] worker_enter_idle: c 1 2           (null)
