Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab1KOTF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 14:05:26 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32922 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757138Ab1KOTFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 14:05:22 -0500
From: "Sergey V." <sftp.mtuci@gmail.com>
To: David Airlie <airlied@linux.ie>
Subject: radeon/kms: black screen when loading radeon with modeset=1
Date: Tue, 15 Nov 2011 23:05:08 +0400
User-Agent: KMail/1.13.6 (Linux/3.0.6-sftp+; KDE/4.5.5; x86_64; ; )
Cc: Alex Deucher <alexander.deucher@amd.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_lfrwOeV5mPCyOq/"
Message-Id: <201111152305.09451.sftp.mtuci@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_lfrwOeV5mPCyOq/
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

Kernel from Linus tree, HEAD at 7f80850d3f9fd8fda23a317044aef3a6bafab06b

Loading radeon module with modeset=1 causes black screen.

Usually it happens at boot time, but if run kernel with radeon.modeset=0 then 
`rmmod radeon; modprobe radeon modeset=1` I can get dmesg over ssh (thanks to 
glisse from #radeon for help).

Backtrace below:

[   89.905890] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000008
[   89.906016] IP: [<ffffffffa05998ed>] 
radeon_atombios_parse_power_table_1_3+0x13d/0x810 [radeon]
[   89.906016] PGD 6a0e1067 PUD 6a09d067 PMD 0 
[   89.906016] Oops: 0002 [#1] SMP 
[   89.906016] CPU 0 
[   89.906016] Modules linked in: radeon(+) snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss ipv6 btrfs 
cpufreq_ondemand powernow_k8 freq_table mperf lp ppdev parport_pc parport fuse 
snd_hda_codec_hdmi snd_hda_codec_realtek processor ttm drm_kms_helper drm 
thermal i2c_piix4 joydev agpgart video snd_hda_intel r8169 thermal_sys 
i2c_algo_bit i2c_core k8temp battery sdhci_pci snd_hda_codec evdev hwmon mii 
button ac shpchp sdhci snd_hwdep snd_pcm psmouse serio_raw mmc_core snd_timer 
sg snd soundcore snd_page_alloc [last unloaded: radeon]
[   89.906016] 
[   89.906016] Pid: 2189, comm: modprobe Tainted: G        W    3.2.0-rc1+ #4 
Micro-Star International PR210/MS-1222
[   89.906016] RIP: 0010:[<ffffffffa05998ed>]  [<ffffffffa05998ed>] 
radeon_atombios_parse_power_table_1_3+0x13d/0x810 [radeon]
[   89.906016] RSP: 0018:ffff880075959948  EFLAGS: 00010246
[   89.906016] RAX: 0000000000000000 RBX: ffff880075b72000 RCX: 
0000000000000000
[   89.906016] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 
ffff880076c73c00
[   89.906016] RBP: ffff880075959a98 R08: 0000000000000000 R09: 
ffff880076c73a00
[   89.906016] R10: ffff8800758a0000 R11: 0000000000000006 R12: 
ffff8800758aadde
[   89.906016] R13: ffff8800758aadde R14: 0000000000000000 R15: 
0000000000000000
[   89.906016] FS:  00007f57d0b27720(0000) GS:ffff88007bc00000(0000) 
knlGS:00000000f702a6d0
[   89.906016] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   89.906016] CR2: 0000000000000008 CR3: 000000006a0a6000 CR4: 
00000000000006f0
[   89.906016] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[   89.906016] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[   89.906016] Process modprobe (pid: 2189, threadinfo ffff880075958000, task 
ffff880075abc6d0)
[   89.906016] Stack:
[   89.906016]  ffff88000000ffff ffff8800768f400a ffff880000000000 
00ffffff00000000
[   89.906016]  ffff880037653663 ffff880075b73158 ffff880075b73174 
0000000675959acf
[   89.906016]  ffffffff81b6112c ffff880075959a38 ffffffff81b6112e 
ffff880075959ad5
[   89.906016] Call Trace:
[   89.906016]  [<ffffffff81289dce>] ? vsnprintf+0x31e/0x5d0
[   89.906016]  [<ffffffff81289dce>] ? vsnprintf+0x31e/0x5d0
[   89.906016]  [<ffffffff81076511>] ? up+0x31/0x50
[   89.906016]  [<ffffffff81050494>] ? console_unlock+0x1c4/0x230
[   89.906016]  [<ffffffffa059cb98>] 
radeon_atombios_get_power_modes+0x228/0x8e0 [radeon]
[   89.906016]  [<ffffffffa05e7e01>] radeon_pm_init+0x3b1/0x590 [radeon]
[   89.906016]  [<ffffffffa05d0039>] ? rs600_irq_set+0x109/0x180 [radeon]
[   89.906016]  [<ffffffffa05b7ca9>] radeon_modeset_init+0x4c9/0x8a0 [radeon]
[   89.906016]  [<ffffffffa05fb3dc>] ? radeon_acpi_init+0x8c/0xbc [radeon]
[   89.906016]  [<ffffffffa0598760>] radeon_driver_load_kms+0x120/0x170 
[radeon]
[   89.906016]  [<ffffffffa024d82e>] drm_get_pci_dev+0x18e/0x2c0 [drm]
[   89.906016]  [<ffffffffa05fb4b9>] radeon_pci_probe+0xad/0xb5 [radeon]
[   89.906016]  [<ffffffff812a8edf>] local_pci_probe+0x5f/0xd0
[   89.906016]  [<ffffffff812a97b8>] pci_device_probe+0x88/0xb0
[   89.906016]  [<ffffffff81331bca>] ? driver_sysfs_add+0x7a/0xb0
[   89.906016]  [<ffffffff81331ed6>] driver_probe_device+0x96/0x1b0
[   89.906016]  [<ffffffff81332093>] __driver_attach+0xa3/0xb0
[   89.906016]  [<ffffffff81331ff0>] ? driver_probe_device+0x1b0/0x1b0
[   89.906016]  [<ffffffff81330e9e>] bus_for_each_dev+0x5e/0x90
[   89.906016]  [<ffffffff81331b4e>] driver_attach+0x1e/0x20
[   89.906016]  [<ffffffff81331745>] bus_add_driver+0x155/0x280
[   89.906016]  [<ffffffff81332676>] driver_register+0x76/0x140
[   89.906016]  [<ffffffff812a9a45>] __pci_register_driver+0x55/0xd0
[   89.906016]  [<ffffffffa024da71>] drm_pci_init+0x111/0x120 [drm]
[   89.906016]  [<ffffffffa0639000>] ? 0xffffffffa0638fff
[   89.906016]  [<ffffffffa0639000>] ? 0xffffffffa0638fff
[   89.906016]  [<ffffffffa06390ec>] radeon_init+0xec/0xee [radeon]
[   89.906016]  [<ffffffff810002d4>] do_one_initcall+0x44/0x170
[   89.906016]  [<ffffffff8108c332>] sys_init_module+0x92/0x1e0
[   89.906016]  [<ffffffff817fba6b>] system_call_fastpath+0x16/0x1b
[   89.906016] Code: 16 44 3b b5 ec fe ff ff 0f 8d 40 01 00 00 48 8b 83 58 11 
00 00 49 63 cf 48 89 ca 48 c1 e1 06 48 c1 e2 04 48 29 d1 48 8b 44 08 08 <c7> 
40 08 00 00 00 00 0f b6 45 8f 3c 02 75 ac 4c 8b 83 58 11 00 
[   89.906016] RIP  [<ffffffffa05998ed>] 
radeon_atombios_parse_power_table_1_3+0x13d/0x810 [radeon]
[   89.906016]  RSP <ffff880075959948>
[   89.906016] CR2: 0000000000000008
[   89.918682] ---[ end trace 758728fd12807b58 ]---

Whole dmesg output attached.

--Boundary-00=_lfrwOeV5mPCyOq/
Content-Type: text/plain;
  charset="UTF-8";
  name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.2.0-rc1+ (root@electron) (gcc version 4.5.2 (GCC) ) #4 SMP Tue Nov 15 21:43:35 GST 2011
[    0.000000] Command line: BOOT_IMAGE=3.2.0-rc1 ro root=802 vt.default_utf8=1 radeon.modeset=0
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007bfc0000 (usable)
[    0.000000]  BIOS-e820: 000000007bfc0000 - 000000007bfce000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007bfce000 - 000000007bff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007bff0000 - 000000007c000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: Micro-Star International PR210/MS-1222, BIOS A1222AG6 V3.08 07/26/2007
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x7bfc0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-000000007bfc0000
[    0.000000]  0000000000 - 007be00000 page 2M
[    0.000000]  007be00000 - 007bfc0000 page 4k
[    0.000000] kernel direct mapping tables up to 7bfc0000 @ 1fffc000-20000000
[    0.000000] ACPI: RSDP 00000000000f9260 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 000000007bfc0000 00040 (v01 RoverC RovPr200 07000726 MSFT 00000097)
[    0.000000] ACPI: FACP 000000007bfc0200 00084 (v02 RoverC RovPr200 07000726 MSFT 00000097)
[    0.000000] ACPI: DSDT 000000007bfc05b0 04655 (v01    MSI     1222 00000B18 INTL 20051117)
[    0.000000] ACPI: FACS 000000007bfce000 00040
[    0.000000] ACPI: APIC 000000007bfc0390 0005C (v01 RoverC RovPr200 07000726 MSFT 00000097)
[    0.000000] ACPI: MCFG 000000007bfc03f0 0003C (v01 RoverC RovPr200 07000726 MSFT 00000097)
[    0.000000] ACPI: SLIC 000000007bfc0430 00176 (v01 RoverC RovPr200 07000726 MSFT 00000097)
[    0.000000] ACPI: OEMB 000000007bfce040 00071 (v01 RoverC RovPr200 07000726 MSFT 00000097)
[    0.000000] ACPI: HPET 000000007bfc4c10 00038 (v01 RoverC OEMHPET  07000726 MSFT 00000097)
[    0.000000] ACPI: SSDT 000000007bfc4c50 0016B (v01 A M I  POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0001ffffff] PMD -> [ffff880079600000-ffff88007b5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007bfc0
[    0.000000] On node 0 totalpages: 507727
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3914 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7871 pages used for memmap
[    0.000000]   DMA32 zone: 495873 pages, LIFO batch:31
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x81] disabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 1 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 7c000000 (gap: 7c000000:84000000)
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88007bc00000 s75648 r8192 d22656 u1048576
[    0.000000] pcpu-alloc: s75648 r8192 d22656 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 499787
[    0.000000] Kernel command line: BOOT_IMAGE=3.2.0-rc1 ro root=802 vt.default_utf8=1 radeon.modeset=0
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 6430000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Memory: 1977056k/2031360k available (8190k kernel code, 452k absent, 53852k reserved, 6830k data, 736k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  CONFIG_RCU_FANOUT set to non-default value of 32
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 16777216 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration failed
[    0.000000] TSC: Unable to calibrate against PIT
[    0.000000] TSC: using HPET reference calibration
[    0.000000] Detected 2199.815 MHz processor.
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[    0.004059] Calibrating delay loop (skipped), value calculated using timer frequency.. 4399.63 BogoMIPS (lpj=2199815)
[    0.004171] pid_max: default: 32768 minimum: 301
[    0.004256] Security Framework initialized
[    0.004328] Mount-cache hash table entries: 256
[    0.005070] Initializing cgroup subsys cpuacct
[    0.005128] Initializing cgroup subsys memory
[    0.005192] Initializing cgroup subsys devices
[    0.005248] Initializing cgroup subsys freezer
[    0.005303] Initializing cgroup subsys net_cls
[    0.005358] Initializing cgroup subsys blkio
[    0.005435] tseg: 0000000000
[    0.005447] mce: CPU supports 5 MCE banks
[    0.005511] using AMD E400 aware idle routine
[    0.005597] SMP alternatives: switching to UP code
[    0.012549] ACPI: Core revision 20110623
[    0.016010] ftrace: allocating 26169 entries in 103 pages
[    0.017445] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.027993] CPU0: AMD Turion(tm) 64 Mobile Technology MK-38 stepping 02
[    0.028998] Performance Events: AMD PMU driver.
[    0.028998] ... version:                0
[    0.028998] ... bit width:              48
[    0.028998] ... generic registers:      4
[    0.028998] ... value mask:             0000ffffffffffff
[    0.028998] ... max period:             00007fffffffffff
[    0.028998] ... fixed-purpose events:   0
[    0.028998] ... event mask:             000000000000000f
[    0.028998] MCE: In-kernel MCE decoding enabled.
[    0.028998] Brought up 1 CPUs
[    0.028998] Total of 1 processors activated (4399.63 BogoMIPS).
[    0.029189] devtmpfs: initialized
[    0.030667] PM: Registering ACPI NVS region at 7bfce000 (139264 bytes)
[    0.030754] xor: automatically using best checksumming function: generic_sse
[    0.035000]    generic_sse:  6776.000 MB/sec
[    0.035054] xor: using function: generic_sse (6776.000 MB/sec)
[    0.035113] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.035199] NET: Registered protocol family 16
[    0.035526] node 0 link 0: io port [1000, ffffff]
[    0.035530] TOM: 0000000080000000 aka 2048M
[    0.035586] node 0 link 0: mmio [f0000000, f7feffff]
[    0.035589] node 0 link 0: mmio [e0000000, efffffff]
[    0.035592] node 0 link 0: mmio [80000000, dfffffff]
[    0.035595] node 0 link 0: mmio [a0000, bffff]
[    0.035597] node 0 link 0: mmio [f7ff0000, ffffffff]
[    0.035600] bus: [00, ff] on node 0 link 0
[    0.035603] bus: 00 index 0 [io  0x0000-0xffff]
[    0.035605] bus: 00 index 1 [mem 0x80000000-0xfcffffffff]
[    0.035607] bus: 00 index 2 [mem 0x000a0000-0x000bffff]
[    0.035617] ACPI: bus type pci registered
[    0.035792] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.035865] PCI: not using MMCONFIG
[    0.035919] PCI: Using configuration type 1 for base access
[    0.047808] bio: create slab <bio-0> at 0
[    0.064002] raid6: int64x1   1835 MB/s
[    0.081017] raid6: int64x2   2542 MB/s
[    0.098015] raid6: int64x4   1625 MB/s
[    0.115005] raid6: int64x8   1648 MB/s
[    0.131997] raid6: sse2x1    3156 MB/s
[    0.148990] raid6: sse2x2    4132 MB/s
[    0.165985] raid6: sse2x4    4261 MB/s
[    0.166040] raid6: using algorithm sse2x4 (4261 MB/s)
[    0.166145] ACPI: Added _OSI(Module Device)
[    0.166200] ACPI: Added _OSI(Processor Device)
[    0.166254] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.166310] ACPI: Added _OSI(Processor Aggregator Device)
[    0.167086] ACPI: EC: Detected MSI hardware, enabling workarounds.
[    0.167090] ACPI: EC: Look up EC in DSDT
[    0.167818] ACPI: Executed 3 blocks of module-level executable AML code
[    0.169719] ACPI: Interpreter enabled
[    0.169777] ACPI: (supports S0 S3 S4 S5)
[    0.169987] ACPI: Using IOAPIC for interrupt routing
[    0.170105] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.170798] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.201276] ACPI: EC: GPE = 0x6, I/O: command/status = 0x66, data = 0x62
[    0.201493] ACPI: No dock devices found.
[    0.201548] HEST: Table not found.
[    0.201605] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.201782] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.202102] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.202105] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.202108] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.202111] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff] (ignored)
[    0.202114] pci_root PNP0A03:00: host bridge window [mem 0x7c000000-0xdfffffff] (ignored)
[    0.202117] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfebfffff] (ignored)
[    0.202128] pci 0000:00:00.0: [1002:7910] type 0 class 0x000600
[    0.202162] pci 0000:00:01.0: [1002:7912] type 1 class 0x000604
[    0.202203] pci 0000:00:06.0: [1002:7916] type 1 class 0x000604
[    0.202233] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.202236] pci 0000:00:06.0: PME# disabled
[    0.202251] pci 0000:00:07.0: [1002:7917] type 1 class 0x000604
[    0.202280] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.202283] pci 0000:00:07.0: PME# disabled
[    0.202315] pci 0000:00:12.0: [1002:4380] type 0 class 0x000101
[    0.202335] pci 0000:00:12.0: reg 10: [io  0xb000-0xb007]
[    0.202347] pci 0000:00:12.0: reg 14: [io  0xa000-0xa003]
[    0.202358] pci 0000:00:12.0: reg 18: [io  0x9000-0x9007]
[    0.202369] pci 0000:00:12.0: reg 1c: [io  0x8000-0x8003]
[    0.202380] pci 0000:00:12.0: reg 20: [io  0x7000-0x700f]
[    0.202392] pci 0000:00:12.0: reg 24: [mem 0xfddff800-0xfddffbff]
[    0.202415] pci 0000:00:12.0: set SATA to AHCI mode
[    0.202500] pci 0000:00:13.0: [1002:4387] type 0 class 0x000c03
[    0.202516] pci 0000:00:13.0: reg 10: [mem 0xfddfe000-0xfddfefff]
[    0.202589] pci 0000:00:13.1: [1002:4388] type 0 class 0x000c03
[    0.202605] pci 0000:00:13.1: reg 10: [mem 0xfddfd000-0xfddfdfff]
[    0.202677] pci 0000:00:13.2: [1002:4389] type 0 class 0x000c03
[    0.202693] pci 0000:00:13.2: reg 10: [mem 0xfddfc000-0xfddfcfff]
[    0.202765] pci 0000:00:13.3: [1002:438a] type 0 class 0x000c03
[    0.202781] pci 0000:00:13.3: reg 10: [mem 0xfddfb000-0xfddfbfff]
[    0.202853] pci 0000:00:13.4: [1002:438b] type 0 class 0x000c03
[    0.202869] pci 0000:00:13.4: reg 10: [mem 0xfddfa000-0xfddfafff]
[    0.202948] pci 0000:00:13.5: [1002:4386] type 0 class 0x000c03
[    0.202970] pci 0000:00:13.5: reg 10: [mem 0xfddff000-0xfddff0ff]
[    0.203055] pci 0000:00:13.5: supports D1 D2
[    0.203057] pci 0000:00:13.5: PME# supported from D0 D1 D2 D3hot
[    0.203062] pci 0000:00:13.5: PME# disabled
[    0.203327] pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
[    0.204219] pci 0000:00:14.0: reg 10: [io  0x0b00-0x0b0f]
[    0.210471] pci 0000:00:14.1: [1002:438c] type 0 class 0x000101
[    0.210487] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
[    0.210498] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
[    0.210509] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
[    0.210520] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
[    0.210531] pci 0000:00:14.1: reg 20: [io  0xff00-0xff0f]
[    0.210574] pci 0000:00:14.2: [1002:4383] type 0 class 0x000403
[    0.210599] pci 0000:00:14.2: reg 10: [mem 0xfddf4000-0xfddf7fff 64bit]
[    0.210666] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.210670] pci 0000:00:14.2: PME# disabled
[    0.210685] pci 0000:00:14.3: [1002:438d] type 0 class 0x000601
[    0.210769] pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
[    0.210821] pci 0000:00:18.0: [1022:1100] type 0 class 0x000600
[    0.211011] pci 0000:00:18.1: [1022:1101] type 0 class 0x000600
[    0.211029] pci 0000:00:18.2: [1022:1102] type 0 class 0x000600
[    0.211048] pci 0000:00:18.3: [1022:1103] type 0 class 0x000600
[    0.211077] PCI: peer root bus 00 res updated from pci conf
[    0.211103] pci 0000:01:05.0: [1002:791f] type 0 class 0x000300
[    0.211116] pci 0000:01:05.0: reg 10: [mem 0xf0000000-0xf7ffffff 64bit pref]
[    0.211124] pci 0000:01:05.0: reg 18: [mem 0xfdff0000-0xfdffffff 64bit]
[    0.211129] pci 0000:01:05.0: reg 20: [io  0xc000-0xc0ff]
[    0.211135] pci 0000:01:05.0: reg 24: [mem 0xfde00000-0xfdefffff]
[    0.211150] pci 0000:01:05.0: supports D1 D2
[    0.211161] pci 0000:01:05.2: [1002:7919] type 0 class 0x000403
[    0.211173] pci 0000:01:05.2: reg 10: [mem 0xfdfe8000-0xfdfebfff 64bit]
[    0.211218] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.211276] pci 0000:00:01.0:   bridge window [io  0xc000-0xcfff]
[    0.211279] pci 0000:00:01.0:   bridge window [mem 0xfde00000-0xfdffffff]
[    0.211283] pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
[    0.211310] pci 0000:00:06.0: PCI bridge to [bus 02-03]
[    0.211367] pci 0000:00:06.0:   bridge window [io  0xd000-0xdfff]
[    0.211370] pci 0000:00:06.0:   bridge window [mem 0xfe000000-0xfe9fffff]
[    0.211375] pci 0000:00:06.0:   bridge window [mem 0xfa000000-0xfcffffff 64bit pref]
[    0.211421] pci 0000:04:00.0: [10ec:8168] type 0 class 0x000200
[    0.211437] pci 0000:04:00.0: reg 10: [io  0xe800-0xe8ff]
[    0.211465] pci 0000:04:00.0: reg 18: [mem 0xfeaff000-0xfeafffff 64bit]
[    0.211497] pci 0000:04:00.0: reg 30: [mem 0xfeac0000-0xfeadffff pref]
[    0.211536] pci 0000:04:00.0: supports D1 D2
[    0.211538] pci 0000:04:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.211543] pci 0000:04:00.0: PME# disabled
[    0.211558] pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.211637] pci 0000:00:07.0: PCI bridge to [bus 04-04]
[    0.211693] pci 0000:00:07.0:   bridge window [io  0xe000-0xefff]
[    0.211697] pci 0000:00:07.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.211733] pci 0000:05:04.0: [1524:0730] type 0 class 0x000501
[    0.211758] pci 0000:05:04.0: reg 10: [mem 0xfebffc00-0xfebffc7f]
[    0.211855] pci 0000:05:04.0: supports D1 D2
[    0.211857] pci 0000:05:04.0: PME# supported from D0 D1 D2 D3hot
[    0.211862] pci 0000:05:04.0: PME# disabled
[    0.211885] pci 0000:05:04.1: [1524:0750] type 0 class 0x000805
[    0.211910] pci 0000:05:04.1: reg 10: [mem 0xfebff800-0xfebff8ff]
[    0.212009] pci 0000:05:04.1: supports D1 D2
[    0.212011] pci 0000:05:04.1: PME# supported from D0 D1 D2 D3hot
[    0.212016] pci 0000:05:04.1: PME# disabled
[    0.212040] pci 0000:05:04.2: [1524:0720] type 0 class 0x000501
[    0.212064] pci 0000:05:04.2: reg 10: [mem 0xfebff400-0xfebff47f]
[    0.212161] pci 0000:05:04.2: supports D1 D2
[    0.212163] pci 0000:05:04.2: PME# supported from D0 D1 D2 D3hot
[    0.212168] pci 0000:05:04.2: PME# disabled
[    0.212191] pci 0000:05:04.3: [1524:0751] type 0 class 0x000501
[    0.212216] pci 0000:05:04.3: reg 10: [mem 0xfebff000-0xfebff0ff]
[    0.212313] pci 0000:05:04.3: supports D1 D2
[    0.212315] pci 0000:05:04.3: PME# supported from D0 D1 D2 D3hot
[    0.212320] pci 0000:05:04.3: PME# disabled
[    0.212382] pci 0000:00:14.4: PCI bridge to [bus 05-05] (subtractive decode)
[    0.212443] pci 0000:00:14.4:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.212448] pci 0000:00:14.4:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    0.212451] pci 0000:00:14.4:   bridge window [mem 0x80000000-0xfcffffffff] (subtractive decode)
[    0.212453] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.212469] pci_bus 0000:00: on NUMA node 0
[    0.212472] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.212602] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.212642] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE6._PRT]
[    0.212673] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
[    0.212709] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.212752]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.212808]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    0.212884] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.217883] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[    0.218484] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[    0.219065] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[    0.219662] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[    0.220305] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[    0.220902] ACPI: PCI Interrupt Link [LNKF] (IRQs 9) *0, disabled.
[    0.221183] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[    0.221799] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[    0.222613] vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    0.222705] vgaarb: loaded
[    0.222982] vgaarb: bridge control possible 0000:01:05.0
[    0.223181] SCSI subsystem initialized
[    0.223344] libata version 3.00 loaded.
[    0.223429] usbcore: registered new interface driver usbfs
[    0.223546] usbcore: registered new interface driver hub
[    0.224024] usbcore: registered new device driver usb
[    0.224203] PCI: Using ACPI for IRQ routing
[    0.234489] PCI: pci_cache_line_size set to 64 bytes
[    0.234997] reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
[    0.234999] reserve RAM buffer: 000000007bfc0000 - 000000007bffffff 
[    0.235190] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.235436] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.237006] Switching to clocksource hpet
[    0.239510] pnp: PnP ACPI init
[    0.239586] ACPI: bus type pnp registered
[    0.239793] pnp 00:00: [bus 00-ff]
[    0.239796] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.239798] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.239800] pnp 00:00: [io  0x0d00-0xffff window]
[    0.239803] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.239805] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[    0.239807] pnp 00:00: [mem 0x7c000000-0xdfffffff window]
[    0.239812] pnp 00:00: [mem 0xf0000000-0xfebfffff window]
[    0.239815] pnp 00:00: [mem 0x00000000 window]
[    0.239904] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.239957] pnp 00:01: [mem 0x7c000000-0x7fffffff]
[    0.240054] system 00:01: [mem 0x7c000000-0x7fffffff] has been reserved
[    0.240112] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.240151] pnp 00:02: [dma 4]
[    0.240153] pnp 00:02: [io  0x0000-0x000f]
[    0.240155] pnp 00:02: [io  0x0081-0x0083]
[    0.240157] pnp 00:02: [io  0x0087]
[    0.240158] pnp 00:02: [io  0x0089-0x008b]
[    0.240160] pnp 00:02: [io  0x008f]
[    0.240162] pnp 00:02: [io  0x00c0-0x00df]
[    0.240210] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.240221] pnp 00:03: [io  0x0070-0x0071]
[    0.240233] pnp 00:03: [irq 8]
[    0.240278] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.240309] pnp 00:04: [io  0x0060]
[    0.240311] pnp 00:04: [io  0x0064]
[    0.240316] pnp 00:04: [irq 1]
[    0.240366] pnp 00:04: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.240397] pnp 00:05: [irq 12]
[    0.240448] pnp 00:05: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
[    0.240458] pnp 00:06: [io  0x0061]
[    0.240510] pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.240520] pnp 00:07: [io  0x00f0-0x00ff]
[    0.240525] pnp 00:07: [irq 13]
[    0.240571] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.240607] pnp 00:08: [mem 0xfed00000-0xfed003ff]
[    0.240657] pnp 00:08: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.240703] pnp 00:09: [mem 0xfec00000-0xfec00fff]
[    0.240706] pnp 00:09: [mem 0xfee00000-0xfee00fff]
[    0.240779] system 00:09: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.240838] system 00:09: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.240897] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.241026] pnp 00:0a: [io  0x0010-0x001f]
[    0.241028] pnp 00:0a: [io  0x0022-0x003f]
[    0.241030] pnp 00:0a: [io  0x0062-0x0063]
[    0.241032] pnp 00:0a: [io  0x0065-0x006f]
[    0.241034] pnp 00:0a: [io  0x0072-0x007f]
[    0.241036] pnp 00:0a: [io  0x0080]
[    0.241038] pnp 00:0a: [io  0x0084-0x0086]
[    0.241040] pnp 00:0a: [io  0x0088]
[    0.241041] pnp 00:0a: [io  0x008c-0x008e]
[    0.241043] pnp 00:0a: [io  0x0090-0x009f]
[    0.241045] pnp 00:0a: [io  0x00a2-0x00bf]
[    0.241047] pnp 00:0a: [io  0x00b1]
[    0.241049] pnp 00:0a: [io  0x00e0-0x00ef]
[    0.241051] pnp 00:0a: [io  0x004c]
[    0.241052] pnp 00:0a: [io  0x004e]
[    0.241054] pnp 00:0a: [io  0x004f]
[    0.241056] pnp 00:0a: [io  0x04d0-0x04d1]
[    0.241058] pnp 00:0a: [io  0x040b]
[    0.241060] pnp 00:0a: [io  0x04d6]
[    0.241062] pnp 00:0a: [io  0x0c00-0x0c01]
[    0.241066] pnp 00:0a: [io  0x0c14]
[    0.241068] pnp 00:0a: [io  0x0c50-0x0c51]
[    0.241070] pnp 00:0a: [io  0x0c52]
[    0.241071] pnp 00:0a: [io  0x0c6c]
[    0.241073] pnp 00:0a: [io  0x0c6f]
[    0.241075] pnp 00:0a: [io  0x0cd0-0x0cd1]
[    0.241077] pnp 00:0a: [io  0x0cd2-0x0cd3]
[    0.241079] pnp 00:0a: [io  0x0cd4-0x0cd5]
[    0.241080] pnp 00:0a: [io  0x0cd6-0x0cd7]
[    0.241082] pnp 00:0a: [io  0x0cd8-0x0cdf]
[    0.241084] pnp 00:0a: [io  0x0800-0x089f]
[    0.241086] pnp 00:0a: [io  0x0b10-0x0b1f]
[    0.241088] pnp 00:0a: [io  0x0000-0xffffffffffffffff disabled]
[    0.241091] pnp 00:0a: [io  0x0900-0x090f]
[    0.241092] pnp 00:0a: [io  0x0910-0x091f]
[    0.241094] pnp 00:0a: [io  0xfe00-0xfefe]
[    0.241096] pnp 00:0a: [mem 0xffb80000-0xffbfffff]
[    0.241098] pnp 00:0a: [mem 0xfff80000-0xffffffff]
[    0.241214] system 00:0a: [io  0x04d0-0x04d1] has been reserved
[    0.241270] system 00:0a: [io  0x040b] has been reserved
[    0.241328] system 00:0a: [io  0x04d6] has been reserved
[    0.241384] system 00:0a: [io  0x0c00-0x0c01] has been reserved
[    0.241439] system 00:0a: [io  0x0c14] has been reserved
[    0.241496] system 00:0a: [io  0x0c50-0x0c51] has been reserved
[    0.241553] system 00:0a: [io  0x0c52] has been reserved
[    0.241608] system 00:0a: [io  0x0c6c] has been reserved
[    0.241664] system 00:0a: [io  0x0c6f] has been reserved
[    0.241722] system 00:0a: [io  0x0cd0-0x0cd1] has been reserved
[    0.241777] system 00:0a: [io  0x0cd2-0x0cd3] has been reserved
[    0.241833] system 00:0a: [io  0x0cd4-0x0cd5] has been reserved
[    0.241893] system 00:0a: [io  0x0cd6-0x0cd7] has been reserved
[    0.241948] system 00:0a: [io  0x0cd8-0x0cdf] has been reserved
[    0.242032] system 00:0a: [io  0x0800-0x089f] has been reserved
[    0.242088] system 00:0a: [io  0x0b10-0x0b1f] has been reserved
[    0.242147] system 00:0a: [io  0x0900-0x090f] has been reserved
[    0.242202] system 00:0a: [io  0x0910-0x091f] has been reserved
[    0.242258] system 00:0a: [io  0xfe00-0xfefe] has been reserved
[    0.242316] system 00:0a: [mem 0xffb80000-0xffbfffff] has been reserved
[    0.242373] system 00:0a: [mem 0xfff80000-0xffffffff] has been reserved
[    0.242430] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.245832] pnp 00:0b: [mem 0xe0000000-0xefffffff]
[    0.245900] system 00:0b: [mem 0xe0000000-0xefffffff] has been reserved
[    0.245958] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.246157] pnp 00:0c: [mem 0x00000000-0x0009ffff]
[    0.246159] pnp 00:0c: [mem 0x000c0000-0x000cffff]
[    0.246161] pnp 00:0c: [mem 0x000e0000-0x000fffff]
[    0.246164] pnp 00:0c: [mem 0x00100000-0x7bffffff]
[    0.246166] pnp 00:0c: [mem 0xfec00000-0xffffffff]
[    0.246240] system 00:0c: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.246297] system 00:0c: [mem 0x000c0000-0x000cffff] could not be reserved
[    0.246353] system 00:0c: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.246409] system 00:0c: [mem 0x00100000-0x7bffffff] could not be reserved
[    0.246466] system 00:0c: [mem 0xfec00000-0xffffffff] could not be reserved
[    0.246522] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.246621] pnp: PnP ACPI: found 13 devices
[    0.246675] ACPI: ACPI bus type pnp unregistered
[    0.254824] PCI: max bus depth: 1 pci_try_num: 2
[    0.254858] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.254929] pci 0000:00:01.0:   bridge window [io  0xc000-0xcfff]
[    0.254993] pci 0000:00:01.0:   bridge window [mem 0xfde00000-0xfdffffff]
[    0.255079] pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
[    0.255172] pci 0000:00:06.0: PCI bridge to [bus 02-03]
[    0.255238] pci 0000:00:06.0:   bridge window [io  0xd000-0xdfff]
[    0.255305] pci 0000:00:06.0:   bridge window [mem 0xfe000000-0xfe9fffff]
[    0.255370] pci 0000:00:06.0:   bridge window [mem 0xfa000000-0xfcffffff 64bit pref]
[    0.255461] pci 0000:00:07.0: PCI bridge to [bus 04-04]
[    0.255526] pci 0000:00:07.0:   bridge window [io  0xe000-0xefff]
[    0.255591] pci 0000:00:07.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.255659] pci 0000:00:14.4: PCI bridge to [bus 05-05]
[    0.255728] pci 0000:00:14.4:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.255813] pci 0000:00:06.0: setting latency timer to 64
[    0.255818] pci 0000:00:07.0: setting latency timer to 64
[    0.255827] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.255829] pci_bus 0000:00: resource 5 [mem 0x80000000-0xfcffffffff]
[    0.255832] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.255834] pci_bus 0000:01: resource 0 [io  0xc000-0xcfff]
[    0.255837] pci_bus 0000:01: resource 1 [mem 0xfde00000-0xfdffffff]
[    0.255839] pci_bus 0000:01: resource 2 [mem 0xf0000000-0xf7ffffff 64bit pref]
[    0.255842] pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
[    0.255844] pci_bus 0000:02: resource 1 [mem 0xfe000000-0xfe9fffff]
[    0.255846] pci_bus 0000:02: resource 2 [mem 0xfa000000-0xfcffffff 64bit pref]
[    0.255849] pci_bus 0000:04: resource 0 [io  0xe000-0xefff]
[    0.255851] pci_bus 0000:04: resource 1 [mem 0xfea00000-0xfeafffff]
[    0.255854] pci_bus 0000:05: resource 1 [mem 0xfeb00000-0xfebfffff]
[    0.255856] pci_bus 0000:05: resource 4 [io  0x0000-0xffff]
[    0.255859] pci_bus 0000:05: resource 5 [mem 0x80000000-0xfcffffffff]
[    0.255861] pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff]
[    0.255900] NET: Registered protocol family 2
[    0.256023] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.256624] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.258580] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.259197] TCP: Hash tables configured (established 262144 bind 65536)
[    0.259255] TCP reno registered
[    0.259312] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.259388] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.259538] NET: Registered protocol family 1
[    0.259710] pci 0000:01:05.0: Boot video device
[    0.259729] PCI: CLS 64 bytes, default 64
[    0.260245] Intel AES-NI instructions are not detected.
[    0.260507] audit: initializing netlink socket (disabled)
[    0.260573] type=2000 audit(1321381668.259:1): initialized
[    0.270981] VFS: Disk quotas dquot_6.5.2
[    0.271132] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.271922] NTFS driver 2.1.30 [Flags: R/O].
[    0.272233] msgmni has been set to 3861
[    0.273021] async_tx: api initialized (async)
[    0.273185] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    0.273279] io scheduler noop registered
[    0.273335] io scheduler deadline registered
[    0.273441] io scheduler cfq registered (default)
[    0.273613] pcieport 0000:00:06.0: setting latency timer to 64
[    0.273647] pcieport 0000:00:06.0: irq 40 for MSI/MSI-X
[    0.273720] pcieport 0000:00:07.0: setting latency timer to 64
[    0.273747] pcieport 0000:00:07.0: irq 41 for MSI/MSI-X
[    0.273941] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.274282] ERST: Table is not found!
[    0.277249] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.296377] floppy0: no floppy controllers found
[    3.296476] ------------[ cut here ]------------
[    3.296537] WARNING: at drivers/block/floppy.c:2929 do_fd_request+0xbf/0xd0()
[    3.296594] Hardware name: PR210
[    3.296647] VFS: do_fd_request called on non-open device
[    3.296702] Modules linked in:
[    3.296794] Pid: 1, comm: swapper Not tainted 3.2.0-rc1+ #4
[    3.296849] Call Trace:
[    3.296908]  [<ffffffff8104fc3f>] warn_slowpath_common+0x7f/0xc0
[    3.296964]  [<ffffffff8104fd36>] warn_slowpath_fmt+0x46/0x50
[    3.297021]  [<ffffffff81276839>] ? blk_throtl_drain+0x119/0x160
[    3.297079]  [<ffffffff8126e9e3>] ? unregister_blkdev+0x93/0xd0
[    3.297135]  [<ffffffff813472ef>] do_fd_request+0xbf/0xd0
[    3.297193]  [<ffffffff8126769d>] blk_drain_queue+0x6d/0xa0
[    3.297249]  [<ffffffff812677b5>] blk_cleanup_queue+0xe5/0x1a0
[    3.297307]  [<ffffffff81eedd41>] floppy_init+0xdeb/0xe28
[    3.297334]  [<ffffffff81eecf56>] ? daring+0x6b/0x6b
[    3.297334]  [<ffffffff810002d4>] do_one_initcall+0x44/0x170
[    3.297334]  [<ffffffff81ec0c60>] kernel_init+0xc0/0x141
[    3.297334]  [<ffffffff817fcc74>] kernel_thread_helper+0x4/0x10
[    3.297334]  [<ffffffff81ec0ba0>] ? start_kernel+0x391/0x391
[    3.297334]  [<ffffffff817fcc70>] ? gs_change+0xb/0xb
[    3.297334] ---[ end trace 758728fd12807b4f ]---
[    3.297780] ------------[ cut here ]------------
[    3.297837] WARNING: at drivers/block/floppy.c:2929 do_fd_request+0xbf/0xd0()
[    3.297893] Hardware name: PR210
[    3.297946] VFS: do_fd_request called on non-open device
[    3.298000] Modules linked in:
[    3.298093] Pid: 1, comm: swapper Tainted: G        W    3.2.0-rc1+ #4
[    3.298148] Call Trace:
[    3.298202]  [<ffffffff8104fc3f>] warn_slowpath_common+0x7f/0xc0
[    3.298259]  [<ffffffff8104fd36>] warn_slowpath_fmt+0x46/0x50
[    3.298316]  [<ffffffff81276839>] ? blk_throtl_drain+0x119/0x160
[    3.298372]  [<ffffffff8126e712>] ? disk_release+0x92/0xc0
[    3.298429]  [<ffffffff813472ef>] do_fd_request+0xbf/0xd0
[    3.298485]  [<ffffffff8126769d>] blk_drain_queue+0x6d/0xa0
[    3.298542]  [<ffffffff812677b5>] blk_cleanup_queue+0xe5/0x1a0
[    3.298598]  [<ffffffff81eedd41>] floppy_init+0xdeb/0xe28
[    3.298654]  [<ffffffff81eecf56>] ? daring+0x6b/0x6b
[    3.298710]  [<ffffffff810002d4>] do_one_initcall+0x44/0x170
[    3.298763]  [<ffffffff81ec0c60>] kernel_init+0xc0/0x141
[    3.298763]  [<ffffffff817fcc74>] kernel_thread_helper+0x4/0x10
[    3.298763]  [<ffffffff81ec0ba0>] ? start_kernel+0x391/0x391
[    3.298763]  [<ffffffff817fcc70>] ? gs_change+0xb/0xb
[    3.298763] ---[ end trace 758728fd12807b50 ]---
[    3.299061] ------------[ cut here ]------------
[    3.299117] WARNING: at drivers/block/floppy.c:2929 do_fd_request+0xbf/0xd0()
[    3.299172] Hardware name: PR210
[    3.299226] VFS: do_fd_request called on non-open device
[    3.299280] Modules linked in:
[    3.299373] Pid: 1, comm: swapper Tainted: G        W    3.2.0-rc1+ #4
[    3.299427] Call Trace:
[    3.299482]  [<ffffffff8104fc3f>] warn_slowpath_common+0x7f/0xc0
[    3.299539]  [<ffffffff8104fd36>] warn_slowpath_fmt+0x46/0x50
[    3.299595]  [<ffffffff81276839>] ? blk_throtl_drain+0x119/0x160
[    3.299651]  [<ffffffff8126e712>] ? disk_release+0x92/0xc0
[    3.299708]  [<ffffffff813472ef>] do_fd_request+0xbf/0xd0
[    3.299764]  [<ffffffff8126769d>] blk_drain_queue+0x6d/0xa0
[    3.299821]  [<ffffffff812677b5>] blk_cleanup_queue+0xe5/0x1a0
[    3.299878]  [<ffffffff81eedd41>] floppy_init+0xdeb/0xe28
[    3.299933]  [<ffffffff81eecf56>] ? daring+0x6b/0x6b
[    3.299989]  [<ffffffff810002d4>] do_one_initcall+0x44/0x170
[    3.300045]  [<ffffffff81ec0c60>] kernel_init+0xc0/0x141
[    3.300050]  [<ffffffff817fcc74>] kernel_thread_helper+0x4/0x10
[    3.300050]  [<ffffffff81ec0ba0>] ? start_kernel+0x391/0x391
[    3.300050]  [<ffffffff817fcc70>] ? gs_change+0xb/0xb
[    3.300050] ---[ end trace 758728fd12807b51 ]---
[    3.300343] ------------[ cut here ]------------
[    3.300399] WARNING: at drivers/block/floppy.c:2929 do_fd_request+0xbf/0xd0()
[    3.300455] Hardware name: PR210
[    3.300509] VFS: do_fd_request called on non-open device
[    3.300563] Modules linked in:
[    3.300654] Pid: 1, comm: swapper Tainted: G        W    3.2.0-rc1+ #4
[    3.300709] Call Trace:
[    3.300764]  [<ffffffff8104fc3f>] warn_slowpath_common+0x7f/0xc0
[    3.300820]  [<ffffffff8104fd36>] warn_slowpath_fmt+0x46/0x50
[    3.300876]  [<ffffffff81276839>] ? blk_throtl_drain+0x119/0x160
[    3.300933]  [<ffffffff8126e712>] ? disk_release+0x92/0xc0
[    3.300989]  [<ffffffff813472ef>] do_fd_request+0xbf/0xd0
[    3.301045]  [<ffffffff8126769d>] blk_drain_queue+0x6d/0xa0
[    3.301102]  [<ffffffff812677b5>] blk_cleanup_queue+0xe5/0x1a0
[    3.301158]  [<ffffffff81eedd41>] floppy_init+0xdeb/0xe28
[    3.301214]  [<ffffffff81eecf56>] ? daring+0x6b/0x6b
[    3.301270]  [<ffffffff810002d4>] do_one_initcall+0x44/0x170
[    3.301326]  [<ffffffff81ec0c60>] kernel_init+0xc0/0x141
[    3.301328]  [<ffffffff817fcc74>] kernel_thread_helper+0x4/0x10
[    3.301328]  [<ffffffff81ec0ba0>] ? start_kernel+0x391/0x391
[    3.301328]  [<ffffffff817fcc70>] ? gs_change+0xb/0xb
[    3.301328] ---[ end trace 758728fd12807b52 ]---
[    3.301621] ------------[ cut here ]------------
[    3.301678] WARNING: at drivers/block/floppy.c:2929 do_fd_request+0xbf/0xd0()
[    3.301733] Hardware name: PR210
[    3.301786] VFS: do_fd_request called on non-open device
[    3.301841] Modules linked in:
[    3.301932] Pid: 1, comm: swapper Tainted: G        W    3.2.0-rc1+ #4
[    3.301988] Call Trace:
[    3.302538]  [<ffffffff8104fc3f>] warn_slowpath_common+0x7f/0xc0
[    3.302595]  [<ffffffff8104fd36>] warn_slowpath_fmt+0x46/0x50
[    3.302609]  [<ffffffff81276839>] ? blk_throtl_drain+0x119/0x160
[    3.302609]  [<ffffffff8126e712>] ? disk_release+0x92/0xc0
[    3.302609]  [<ffffffff813472ef>] do_fd_request+0xbf/0xd0
[    3.302609]  [<ffffffff8126769d>] blk_drain_queue+0x6d/0xa0
[    3.302609]  [<ffffffff812677b5>] blk_cleanup_queue+0xe5/0x1a0
[    3.302609]  [<ffffffff81eedd41>] floppy_init+0xdeb/0xe28
[    3.302609]  [<ffffffff81eecf56>] ? daring+0x6b/0x6b
[    3.302609]  [<ffffffff810002d4>] do_one_initcall+0x44/0x170
[    3.302609]  [<ffffffff81ec0c60>] kernel_init+0xc0/0x141
[    3.302609]  [<ffffffff817fcc74>] kernel_thread_helper+0x4/0x10
[    3.302609]  [<ffffffff81ec0ba0>] ? start_kernel+0x391/0x391
[    3.302609]  [<ffffffff817fcc70>] ? gs_change+0xb/0xb
[    3.302609] ---[ end trace 758728fd12807b53 ]---
[    3.303394] ------------[ cut here ]------------
[    3.303450] WARNING: at drivers/block/floppy.c:2929 do_fd_request+0xbf/0xd0()
[    3.303506] Hardware name: PR210
[    3.303559] VFS: do_fd_request called on non-open device
[    3.303614] Modules linked in:
[    3.303706] Pid: 1, comm: swapper Tainted: G        W    3.2.0-rc1+ #4
[    3.303761] Call Trace:
[    3.303815]  [<ffffffff8104fc3f>] warn_slowpath_common+0x7f/0xc0
[    3.303871]  [<ffffffff8104fd36>] warn_slowpath_fmt+0x46/0x50
[    3.303928]  [<ffffffff81276839>] ? blk_throtl_drain+0x119/0x160
[    3.303984]  [<ffffffff8126e712>] ? disk_release+0x92/0xc0
[    3.304040]  [<ffffffff813472ef>] do_fd_request+0xbf/0xd0
[    3.304097]  [<ffffffff8126769d>] blk_drain_queue+0x6d/0xa0
[    3.304153]  [<ffffffff812677b5>] blk_cleanup_queue+0xe5/0x1a0
[    3.304210]  [<ffffffff81eedd41>] floppy_init+0xdeb/0xe28
[    3.304265]  [<ffffffff81eecf56>] ? daring+0x6b/0x6b
[    3.304321]  [<ffffffff810002d4>] do_one_initcall+0x44/0x170
[    3.304377]  [<ffffffff81ec0c60>] kernel_init+0xc0/0x141
[    3.304384]  [<ffffffff817fcc74>] kernel_thread_helper+0x4/0x10
[    3.304384]  [<ffffffff81ec0ba0>] ? start_kernel+0x391/0x391
[    3.304384]  [<ffffffff817fcc70>] ? gs_change+0xb/0xb
[    3.304384] ---[ end trace 758728fd12807b54 ]---
[    3.304670] ------------[ cut here ]------------
[    3.304727] WARNING: at drivers/block/floppy.c:2929 do_fd_request+0xbf/0xd0()
[    3.304783] Hardware name: PR210
[    3.304836] VFS: do_fd_request called on non-open device
[    3.304890] Modules linked in:
[    3.304982] Pid: 1, comm: swapper Tainted: G        W    3.2.0-rc1+ #4
[    3.305037] Call Trace:
[    3.305092]  [<ffffffff8104fc3f>] warn_slowpath_common+0x7f/0xc0
[    3.305148]  [<ffffffff8104fd36>] warn_slowpath_fmt+0x46/0x50
[    3.305204]  [<ffffffff81276839>] ? blk_throtl_drain+0x119/0x160
[    3.305261]  [<ffffffff8126e712>] ? disk_release+0x92/0xc0
[    3.305317]  [<ffffffff813472ef>] do_fd_request+0xbf/0xd0
[    3.305373]  [<ffffffff8126769d>] blk_drain_queue+0x6d/0xa0
[    3.305430]  [<ffffffff812677b5>] blk_cleanup_queue+0xe5/0x1a0
[    3.305486]  [<ffffffff81eedd41>] floppy_init+0xdeb/0xe28
[    3.305542]  [<ffffffff81eecf56>] ? daring+0x6b/0x6b
[    3.305598]  [<ffffffff810002d4>] do_one_initcall+0x44/0x170
[    3.305654]  [<ffffffff81ec0c60>] kernel_init+0xc0/0x141
[    3.305659]  [<ffffffff817fcc74>] kernel_thread_helper+0x4/0x10
[    3.305659]  [<ffffffff81ec0ba0>] ? start_kernel+0x391/0x391
[    3.305659]  [<ffffffff817fcc70>] ? gs_change+0xb/0xb
[    3.305659] ---[ end trace 758728fd12807b55 ]---
[    3.305952] ------------[ cut here ]------------
[    3.306008] WARNING: at drivers/block/floppy.c:2929 do_fd_request+0xbf/0xd0()
[    3.306064] Hardware name: PR210
[    3.306117] VFS: do_fd_request called on non-open device
[    3.306172] Modules linked in:
[    3.306264] Pid: 1, comm: swapper Tainted: G        W    3.2.0-rc1+ #4
[    3.306319] Call Trace:
[    3.306374]  [<ffffffff8104fc3f>] warn_slowpath_common+0x7f/0xc0
[    3.306430]  [<ffffffff8104fd36>] warn_slowpath_fmt+0x46/0x50
[    3.306487]  [<ffffffff81276839>] ? blk_throtl_drain+0x119/0x160
[    3.306543]  [<ffffffff8126e712>] ? disk_release+0x92/0xc0
[    3.306599]  [<ffffffff813472ef>] do_fd_request+0xbf/0xd0
[    3.306656]  [<ffffffff8126769d>] blk_drain_queue+0x6d/0xa0
[    3.306712]  [<ffffffff812677b5>] blk_cleanup_queue+0xe5/0x1a0
[    3.306768]  [<ffffffff81eedd41>] floppy_init+0xdeb/0xe28
[    3.306825]  [<ffffffff81eecf56>] ? daring+0x6b/0x6b
[    3.306880]  [<ffffffff810002d4>] do_one_initcall+0x44/0x170
[    3.306936]  [<ffffffff81ec0c60>] kernel_init+0xc0/0x141
[    3.306937]  [<ffffffff817fcc74>] kernel_thread_helper+0x4/0x10
[    3.306937]  [<ffffffff81ec0ba0>] ? start_kernel+0x391/0x391
[    3.306937]  [<ffffffff817fcc70>] ? gs_change+0xb/0xb
[    3.306937] ---[ end trace 758728fd12807b56 ]---
[    3.309238] brd: module loaded
[    3.309854] loop: module loaded
[    3.309909] Compaq SMART2 Driver (v 2.6.0)
[    3.310150] HP CISS Driver (v 3.6.26)
[    3.310728] Loading iSCSI transport class v2.0-870.
[    3.311228] fnic: Cisco FCoE HBA Driver, ver 1.5.0.2
[    3.311702] Adaptec aacraid driver 1.1-7[28000]-ms
[    3.311857] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    3.312284] scsi: <fdomain> Detection failed (no card)
[    3.312389] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.03.07.07-k.
[    3.312550] iscsi: registered transport (qla4xxx)
[    3.312640] QLogic iSCSI HBA Driver
[    3.312696] Emulex LightPulse Fibre Channel SCSI driver 8.3.27
[    3.312751] Copyright(c) 2004-2009 Emulex.  All rights reserved.
[    3.312849] Brocade BFA FC/FCOE SCSI driver - version: 3.0.2.2
[    3.313109] DC390: clustering now enabled by default. If you get problems load
[    3.313179]        with "disable_clustering=1" and report to maintainers
[    3.313312] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    3.313441] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    3.313532] megasas: 00.00.06.12-rc1 Wed. Oct. 5 17:00:00 PDT 2011
[    3.313633] mpt2sas version 10.100.00.00 loaded
[    3.313804] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    3.313961] 3ware Storage Controller device driver for Linux v1.26.02.003.
[    3.314093] 3ware 9000 Storage Controller device driver for Linux v2.26.02.014.
[    3.314197] LSI 3ware SAS/SATA-RAID Controller device driver for Linux v3.26.02.000.
[    3.314301] ipr: IBM Power RAID SCSI Device Driver version: 2.5.2 (April 27, 2011)
[    3.314411] RocketRAID 3xxx/4xxx Controller driver v1.6 (090910)
[    3.314500] stex: Promise SuperTrak EX Driver version: 4.6.0000.4
[    3.314709] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    3.314929] ahci 0000:00:12.0: version 3.0
[    3.314960] ahci 0000:00:12.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    3.315091] ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32bit
[    3.315237] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[    3.315309] ahci 0000:00:12.0: flags: ncq sntf ilck pm led clo pmp pio slum part ccc 
[    3.316523] scsi0 : ahci
[    3.316714] scsi1 : ahci
[    3.316869] scsi2 : ahci
[    3.317124] scsi3 : ahci
[    3.317329] ata1: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddff900 irq 22
[    3.317401] ata2: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddff980 irq 22
[    3.317473] ata3: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffa00 irq 22
[    3.317545] ata4: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffa80 irq 22
[    3.318668] pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.318776] pata_atiixp 0000:00:14.1: setting latency timer to 64
[    3.319301] scsi4 : pata_atiixp
[    3.319456] scsi5 : pata_atiixp
[    3.320212] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
[    3.320269] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
[    3.322195] I2O subsystem v1.325
[    3.322254] i2o: max drivers = 8
[    3.322428] I2O Configuration OSM v1.323
[    3.322508] I2O Bus Adapter OSM v1.317
[    3.322589] I2O Block Device OSM v1.325
[    3.322787] I2O SCSI Peripheral OSM v1.316
[    3.322870] I2O ProcFS OSM v1.316
[    3.322959] Fusion MPT base driver 3.04.20
[    3.323065] Copyright (c) 1999-2008 LSI Corporation
[    3.323124] Fusion MPT SPI Host driver 3.04.20
[    3.323309] Fusion MPT FC Host driver 3.04.20
[    3.323416] Fusion MPT SAS Host driver 3.04.20
[    3.323513] Fusion MPT misc device (ioctl) driver 3.04.20
[    3.323641] mptctl: Registered with Fusion MPT base driver
[    3.323697] mptctl: /dev/mptctl @ (major,minor=10,220)
[    3.323842] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.323936] ehci_hcd 0000:00:13.5: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    3.324029] ehci_hcd 0000:00:13.5: EHCI Host Controller
[    3.324161] ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 1
[    3.324256] ehci_hcd 0000:00:13.5: applying AMD SB600/SB700 USB freeze workaround
[    3.324340] ehci_hcd 0000:00:13.5: debug port 1
[    3.324417] ehci_hcd 0000:00:13.5: irq 19, io mem 0xfddff000
[    3.330016] ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00
[    3.330122] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.330178] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.330253] usb usb1: Product: EHCI Host Controller
[    3.330308] usb usb1: Manufacturer: Linux 3.2.0-rc1+ ehci_hcd
[    3.330363] usb usb1: SerialNumber: 0000:00:13.5
[    3.330566] hub 1-0:1.0: USB hub found
[    3.330623] hub 1-0:1.0: 10 ports detected
[    3.330873] 116x: driver isp116x-hcd, 03 Nov 2005
[    3.330955] driver isp1362-hcd, 2005-04-04
[    3.331049] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.331125] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.331197] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    3.331308] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
[    3.331920] ohci_hcd 0000:00:13.0: irq 16, io mem 0xfddfe000
[    3.386071] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    3.386128] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.386198] usb usb2: Product: OHCI Host Controller
[    3.386253] usb usb2: Manufacturer: Linux 3.2.0-rc1+ ohci_hcd
[    3.386309] usb usb2: SerialNumber: 0000:00:13.0
[    3.386491] hub 2-0:1.0: USB hub found
[    3.386551] hub 2-0:1.0: 2 ports detected
[    3.386718] ohci_hcd 0000:00:13.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.386789] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    3.386898] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
[    3.386989] ohci_hcd 0000:00:13.1: irq 17, io mem 0xfddfd000
[    3.442056] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    3.442112] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.442183] usb usb3: Product: OHCI Host Controller
[    3.442237] usb usb3: Manufacturer: Linux 3.2.0-rc1+ ohci_hcd
[    3.442293] usb usb3: SerialNumber: 0000:00:13.1
[    3.442465] hub 3-0:1.0: USB hub found
[    3.442525] hub 3-0:1.0: 2 ports detected
[    3.442677] ohci_hcd 0000:00:13.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.442744] ohci_hcd 0000:00:13.2: OHCI Host Controller
[    3.442865] ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
[    3.442958] ohci_hcd 0000:00:13.2: irq 18, io mem 0xfddfc000
[    3.474499] ata5.00: ATAPI: MATSHITADVD-RAM UJ-850S, 1.20, max MWDMA2
[    3.480430] ata5.00: configured for MWDMA2
[    3.498055] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    3.498112] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.498182] usb usb4: Product: OHCI Host Controller
[    3.498238] usb usb4: Manufacturer: Linux 3.2.0-rc1+ ohci_hcd
[    3.498295] usb usb4: SerialNumber: 0000:00:13.2
[    3.498474] hub 4-0:1.0: USB hub found
[    3.498534] hub 4-0:1.0: 2 ports detected
[    3.498692] ohci_hcd 0000:00:13.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.498762] ohci_hcd 0000:00:13.3: OHCI Host Controller
[    3.498875] ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 5
[    3.498960] ohci_hcd 0000:00:13.3: irq 17, io mem 0xfddfb000
[    3.554064] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    3.554121] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.554192] usb usb5: Product: OHCI Host Controller
[    3.554246] usb usb5: Manufacturer: Linux 3.2.0-rc1+ ohci_hcd
[    3.554302] usb usb5: SerialNumber: 0000:00:13.3
[    3.554478] hub 5-0:1.0: USB hub found
[    3.554538] hub 5-0:1.0: 2 ports detected
[    3.554691] ohci_hcd 0000:00:13.4: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.554759] ohci_hcd 0000:00:13.4: OHCI Host Controller
[    3.554868] ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 6
[    3.554952] ohci_hcd 0000:00:13.4: irq 18, io mem 0xfddfa000
[    3.610062] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    3.610118] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.610188] usb usb6: Product: OHCI Host Controller
[    3.610243] usb usb6: Manufacturer: Linux 3.2.0-rc1+ ohci_hcd
[    3.610298] usb usb6: SerialNumber: 0000:00:13.4
[    3.610471] hub 6-0:1.0: USB hub found
[    3.610531] hub 6-0:1.0: 2 ports detected
[    3.610726] uhci_hcd: USB Universal Host Controller Interface driver
[    3.610886] sl811: driver sl811-hcd, 19 May 2005
[    3.610981] r8a66597_hcd: driver r8a66597_hcd, 2009-05-26
[    3.611293] Initializing USB Mass Storage driver...
[    3.611421] usbcore: registered new interface driver usb-storage
[    3.611485] USB Mass Storage support registered.
[    3.611582] usbcore: registered new interface driver ums-alauda
[    3.611678] usbcore: registered new interface driver ums-cypress
[    3.611775] usbcore: registered new interface driver ums-datafab
[    3.611876] usbcore: registered new interface driver ums-freecom
[    3.611974] usbcore: registered new interface driver ums-isd200
[    3.612098] usbcore: registered new interface driver ums-jumpshot
[    3.612190] usbcore: registered new interface driver ums-karma
[    3.612285] usbcore: registered new interface driver ums-onetouch
[    3.612383] usbcore: registered new interface driver ums-sddr09
[    3.612478] usbcore: registered new interface driver ums-sddr55
[    3.612571] usbcore: registered new interface driver ums-usbat
[    3.612723] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    3.613148] i8042: Detected active multiplexing controller, rev 1.1
[    3.613280] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.613339] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    3.613394] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    3.613450] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    3.613505] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    3.613806] mousedev: PS/2 mouse device common for all mice
[    3.613939] md: linear personality registered for level -1
[    3.613994] md: raid0 personality registered for level 0
[    3.614082] md: raid1 personality registered for level 1
[    3.614138] md: raid10 personality registered for level 10
[    3.614193] md: raid6 personality registered for level 6
[    3.614248] md: raid5 personality registered for level 5
[    3.614302] md: raid4 personality registered for level 4
[    3.614357] md: multipath personality registered for level -4
[    3.614657] device-mapper: uevent: version 1.0.3
[    3.614823] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[    3.615088] cpuidle: using governor ladder
[    3.615143] cpuidle: using governor menu
[    3.615249] TCP cubic registered
[    3.615302] Initializing XFRM netlink socket
[    3.615366] NET: Registered protocol family 17
[    3.615428] Registering the dns_resolver key type
[    3.620772] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    3.622035] ata2: SATA link down (SStatus 0 SControl 300)
[    3.622129] ata4: SATA link down (SStatus 0 SControl 300)
[    3.622220] ata3: SATA link down (SStatus 0 SControl 300)
[    3.859023] usb 3-2: new full-speed USB device number 2 using ohci_hcd
[    3.930022] ata1: softreset failed (device not ready)
[    3.930079] ata1: applying PMP SRST workaround and retrying
[    4.008052] usb 3-2: New USB device found, idVendor=147e, idProduct=2016
[    4.008109] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.008165] usb 3-2: Product: Fingerprint Sensor   
[    4.008220] usb 3-2: Manufacturer: TouchStrip        
[    4.085037] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.407975] ata1.00: ATA-7: TOSHIBA MK1237GSX, DL130G, max UDMA/100
[    4.408041] ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    4.408099] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[    4.409070] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[    4.409126] ata1.00: configured for UDMA/100
[    4.409298] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK1237GS DL13 PQ: 0 ANSI: 5
[    4.409577] sd 0:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)
[    4.409686] sd 0:0:0:0: [sda] Write Protect is off
[    4.409742] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.409760] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.412083] scsi 4:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-850S  1.20 PQ: 0 ANSI: 5
[    4.414436] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    4.414509] cdrom: Uniform CD-ROM driver Revision: 3.20
[    4.414702] sr 4:0:0:0: Attached scsi CD-ROM sr0
[    4.502512]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 >
[    4.503076] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.503756] md: Waiting for all devices to be available before autodetect
[    4.503812] md: If you don't use raid, use raid=noautodetect
[    4.504128] md: Autodetecting RAID arrays.
[    4.504184] md: Scanned 0 and added 0 devices.
[    4.504238] md: autorun ...
[    4.504291] md: ... autorun DONE.
[    4.530642] EXT4-fs (sda2): couldn't mount as ext3 due to feature incompatibilities
[    4.532241] EXT4-fs (sda2): couldn't mount as ext2 due to feature incompatibilities
[    4.555664] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    4.555750] VFS: Mounted root (ext4 filesystem) readonly on device 8:2.
[    4.570286] devtmpfs: mounted
[    4.571832] Freeing unused kernel memory: 736k freed
[    4.572244] Write protecting the kernel read-only data: 14336k
[    4.580093] Freeing unused kernel memory: 2032k freed
[    4.587508] Freeing unused kernel memory: 1656k freed
[    6.366647] udev[1254]: starting version 165
[    6.792413] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.792523] sr 4:0:0:0: Attached scsi generic sg1 type 5
[    7.191796] sdhci: Secure Digital Host Controller Interface driver
[    7.191856] sdhci: Copyright(c) Pierre Ossman
[    7.192626] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    7.204035] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    7.209675] ACPI: AC Adapter [ADP1] (on-line)
[    7.216876] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:15/PNP0C09:00/PNP0C0D:00/input/input1
[    7.221495] ACPI: Lid Switch [LID0]
[    7.221682] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[    7.221756] ACPI: Power Button [PWRB]
[    7.234082] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    7.234166] ACPI: Power Button [PWRF]
[    7.411138] sdhci-pci 0000:05:04.1: SDHCI controller found [1524:0750] (rev 0)
[    7.411735] sdhci-pci 0000:05:04.1: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    7.411886] Registered led device: mmc0::
[    7.413044] mmc0: SDHCI controller on PCI [0000:05:04.1] using PIO
[    7.413123] sdhci-pci 0000:05:04.3: SDHCI controller found [1524:0751] (rev 0)
[    7.413209] sdhci-pci 0000:05:04.3: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    7.413595] Registered led device: mmc1::
[    7.415023] mmc1: SDHCI controller on PCI [0000:05:04.3] using PIO
[    7.476135] k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
[    7.584098] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    7.584179] ACPI: Battery Slot [BAT1] (battery present)
[    7.587557] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    7.587641] r8169 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    7.587730] r8169 0000:04:00.0: setting latency timer to 64
[    7.587792] r8169 0000:04:00.0: irq 42 for MSI/MSI-X
[    7.587997] r8169 0000:04:00.0: eth0: RTL8168b/8111b at 0xffffc9000002a000, 00:19:db:3b:99:23, XID 18000000 IRQ 42
[    7.588096] r8169 0000:04:00.0: eth0: jumbo features [frames: 4080 bytes, tx checksumming: ko]
[    7.597229] snd_hda_intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.624472] acpi device:05: registered as cooling_device0
[    7.624626] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:02/LNXVIDEO:00/input/input4
[    7.624770] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[    7.631743] Linux agpgart interface v0.103
[    7.651144] psmouse serio4: synaptics: Touchpad model: 1, fw: 6.2, id: 0xa5a0b1, caps: 0xa04713/0x0/0x0
[    7.680427] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input5
[    7.729866] thermal LNXTHERM:00: registered as thermal_zone0
[    7.729925] ACPI: Thermal Zone [THRM] (78 C)
[    7.770547] [drm] Initialized drm 1.1.0 20060810
[    7.890938] ACPI: duty_cycle spans bit 4
[    7.977963] pci 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    7.978235] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    7.978291] [drm] No driver support for vblank timestamp query.
[    7.978348] [drm] Initialized radeon 1.33.0 20080528 for 0000:01:05.0 on minor 0
[    8.061934] hda_codec: ALC888: BIOS auto-probing.
[    8.062019] hda_codec: ALC888: SKU not ready 0x598301f0
[    8.071413] input: HDA ATI SB Mic as /devices/pci0000:00/0000:00:14.2/sound/card0/input6
[    8.071604] input: HDA ATI SB Headphone as /devices/pci0000:00/0000:00:14.2/sound/card0/input7
[    8.071929] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[    8.072833] snd_hda_intel 0000:01:05.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    8.072959] snd_hda_intel 0000:01:05.2: irq 43 for MSI/MSI-X
[    9.539133] fuse init (API version 7.17)
[    9.682535] EXT4-fs (sda2): re-mounted. Opts: (null)
[    9.736904] EXT4-fs (sda2): re-mounted. Opts: (null)
[   10.318987] ppdev: user-space parallel port driver
[   10.343429] lp: driver loaded but no devices found
[   10.608306] powernow-k8: Found 1 AMD Turion(tm) 64 Mobile Technology MK-38 (1 cpu cores) (version 2.20.00)
[   10.611809] powernow-k8: fid 0xe (2200 MHz), vid 0xb
[   10.611864] powernow-k8: fid 0xc (2000 MHz), vid 0xd
[   10.611919] powernow-k8: fid 0xa (1800 MHz), vid 0xf
[   10.611973] powernow-k8: fid 0x8 (1600 MHz), vid 0x11
[   10.612037] powernow-k8: fid 0x0 (800 MHz), vid 0x18
[   14.355249] EXT4-fs (sda1): mounting ext3 file system using the ext4 subsystem
[   14.376480] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[   14.437499] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
[   14.517721] Btrfs loaded
[   14.537465] device label btrfs devid 1 transid 1022 /dev/sda6
[   14.538122] btrfs: use lzo compression
[   14.538196] btrfs: enabling auto defrag
[   14.538248] btrfs: disk space caching is enabled
[   14.694769] device label tests devid 1 transid 192 /dev/sda7
[   14.696164] btrfs: use lzo compression
[   14.696244] btrfs: enabling auto defrag
[   14.696295] btrfs: disk space caching is enabled
[   17.794065] r8169 0000:04:00.0: eth0: link down
[   17.794081] r8169 0000:04:00.0: eth0: link down
[   19.903836] NET: Registered protocol family 10
[   19.906130] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   20.138447] r8169 0000:04:00.0: eth0: link up
[   20.139290] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   30.898019] eth0: no IPv6 routers present
[   66.242690] [drm] Module unloaded
[   89.524535] [drm] radeon kernel modesetting enabled.
[   89.533940] [drm] initializing kernel modesetting (RS690 0x1002:0x791F 0x1462:0x2FBD).
[   89.534034] [drm] register mmio base: 0xFDFF0000
[   89.534039] [drm] register mmio size: 65536
[   89.535838] ATOM BIOS: ATI
[   89.535892] radeon 0000:01:05.0: VRAM: 96M 0x000000007A000000 - 0x000000007FFFFFFF (96M used)
[   89.535902] radeon 0000:01:05.0: GTT: 512M 0x0000000080000000 - 0x000000009FFFFFFF
[   89.535978] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   89.535983] [drm] Driver supports precise vblank timestamp query.
[   89.536447] [drm] radeon: irq initialized.
[   89.536693] [drm] Detected VRAM RAM=96M, BAR=128M
[   89.536703] [drm] RAM width 128bits DDR
[   89.539578] [TTM] Zone  kernel: Available graphics memory: 990740 kiB.
[   89.539587] [TTM] Initializing pool allocator.
[   89.539657] [drm] radeon: 96M of VRAM memory ready
[   89.539664] [drm] radeon: 512M of GTT memory ready.
[   89.539717] [drm] GART: num cpu pages 131072, num gpu pages 131072
[   89.547452] [drm] radeon: 1 quad pipes, 1 z pipes initialized.
[   89.559337] [drm] PCIE GART of 512M enabled (table at 0x000000006A280000).
[   89.559706] radeon 0000:01:05.0: WB enabled
[   89.564050] [drm] Loading RS690/RS740 Microcode
[   89.904222] [drm] radeon: ring at 0x0000000080001000
[   89.904251] [drm] ring test succeeded in 1 usecs
[   89.904518] [drm] radeon: ib pool ready.
[   89.904715] [drm] ib test succeeded in 0 usecs
[   89.905772] [drm] Radeon Display Connectors
[   89.905777] [drm] Connector 0:
[   89.905782] [drm]   VGA
[   89.905788] [drm]   DDC: 0x7e50 0x7e40 0x7e54 0x7e44 0x7e58 0x7e48 0x7e5c 0x7e4c
[   89.905793] [drm]   Encoders:
[   89.905797] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[   89.905801] [drm] Connector 1:
[   89.905805] [drm]   LVDS
[   89.905810] [drm]   DDC: 0x7e40 0x7e50 0x7e44 0x7e54 0x7e48 0x7e58 0x7e4c 0x7e5c
[   89.905815] [drm]   Encoders:
[   89.905819] [drm]     LCD1: INTERNAL_LVTM1
[   89.905823] [drm] Connector 2:
[   89.905826] [drm]   HDMI-A
[   89.905830] [drm]   HPD2
[   89.905835] [drm]   DDC: 0x7e40 0x7e60 0x7e44 0x7e64 0x7e48 0x7e68 0x7e4c 0x7e6c
[   89.905840] [drm]   Encoders:
[   89.905844] [drm]     DFP2: INTERNAL_DDI
[   89.905890] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[   89.906016] IP: [<ffffffffa05998ed>] radeon_atombios_parse_power_table_1_3+0x13d/0x810 [radeon]
[   89.906016] PGD 6a0e1067 PUD 6a09d067 PMD 0 
[   89.906016] Oops: 0002 [#1] SMP 
[   89.906016] CPU 0 
[   89.906016] Modules linked in: radeon(+) snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss ipv6 btrfs cpufreq_ondemand powernow_k8 freq_table mperf lp ppdev parport_pc parport fuse snd_hda_codec_hdmi snd_hda_codec_realtek processor ttm drm_kms_helper drm thermal i2c_piix4 joydev agpgart video snd_hda_intel r8169 thermal_sys i2c_algo_bit i2c_core k8temp battery sdhci_pci snd_hda_codec evdev hwmon mii button ac shpchp sdhci snd_hwdep snd_pcm psmouse serio_raw mmc_core snd_timer sg snd soundcore snd_page_alloc [last unloaded: radeon]
[   89.906016] 
[   89.906016] Pid: 2189, comm: modprobe Tainted: G        W    3.2.0-rc1+ #4 Micro-Star International PR210/MS-1222
[   89.906016] RIP: 0010:[<ffffffffa05998ed>]  [<ffffffffa05998ed>] radeon_atombios_parse_power_table_1_3+0x13d/0x810 [radeon]
[   89.906016] RSP: 0018:ffff880075959948  EFLAGS: 00010246
[   89.906016] RAX: 0000000000000000 RBX: ffff880075b72000 RCX: 0000000000000000
[   89.906016] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff880076c73c00
[   89.906016] RBP: ffff880075959a98 R08: 0000000000000000 R09: ffff880076c73a00
[   89.906016] R10: ffff8800758a0000 R11: 0000000000000006 R12: ffff8800758aadde
[   89.906016] R13: ffff8800758aadde R14: 0000000000000000 R15: 0000000000000000
[   89.906016] FS:  00007f57d0b27720(0000) GS:ffff88007bc00000(0000) knlGS:00000000f702a6d0
[   89.906016] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   89.906016] CR2: 0000000000000008 CR3: 000000006a0a6000 CR4: 00000000000006f0
[   89.906016] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   89.906016] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   89.906016] Process modprobe (pid: 2189, threadinfo ffff880075958000, task ffff880075abc6d0)
[   89.906016] Stack:
[   89.906016]  ffff88000000ffff ffff8800768f400a ffff880000000000 00ffffff00000000
[   89.906016]  ffff880037653663 ffff880075b73158 ffff880075b73174 0000000675959acf
[   89.906016]  ffffffff81b6112c ffff880075959a38 ffffffff81b6112e ffff880075959ad5
[   89.906016] Call Trace:
[   89.906016]  [<ffffffff81289dce>] ? vsnprintf+0x31e/0x5d0
[   89.906016]  [<ffffffff81289dce>] ? vsnprintf+0x31e/0x5d0
[   89.906016]  [<ffffffff81076511>] ? up+0x31/0x50
[   89.906016]  [<ffffffff81050494>] ? console_unlock+0x1c4/0x230
[   89.906016]  [<ffffffffa059cb98>] radeon_atombios_get_power_modes+0x228/0x8e0 [radeon]
[   89.906016]  [<ffffffffa05e7e01>] radeon_pm_init+0x3b1/0x590 [radeon]
[   89.906016]  [<ffffffffa05d0039>] ? rs600_irq_set+0x109/0x180 [radeon]
[   89.906016]  [<ffffffffa05b7ca9>] radeon_modeset_init+0x4c9/0x8a0 [radeon]
[   89.906016]  [<ffffffffa05fb3dc>] ? radeon_acpi_init+0x8c/0xbc [radeon]
[   89.906016]  [<ffffffffa0598760>] radeon_driver_load_kms+0x120/0x170 [radeon]
[   89.906016]  [<ffffffffa024d82e>] drm_get_pci_dev+0x18e/0x2c0 [drm]
[   89.906016]  [<ffffffffa05fb4b9>] radeon_pci_probe+0xad/0xb5 [radeon]
[   89.906016]  [<ffffffff812a8edf>] local_pci_probe+0x5f/0xd0
[   89.906016]  [<ffffffff812a97b8>] pci_device_probe+0x88/0xb0
[   89.906016]  [<ffffffff81331bca>] ? driver_sysfs_add+0x7a/0xb0
[   89.906016]  [<ffffffff81331ed6>] driver_probe_device+0x96/0x1b0
[   89.906016]  [<ffffffff81332093>] __driver_attach+0xa3/0xb0
[   89.906016]  [<ffffffff81331ff0>] ? driver_probe_device+0x1b0/0x1b0
[   89.906016]  [<ffffffff81330e9e>] bus_for_each_dev+0x5e/0x90
[   89.906016]  [<ffffffff81331b4e>] driver_attach+0x1e/0x20
[   89.906016]  [<ffffffff81331745>] bus_add_driver+0x155/0x280
[   89.906016]  [<ffffffff81332676>] driver_register+0x76/0x140
[   89.906016]  [<ffffffff812a9a45>] __pci_register_driver+0x55/0xd0
[   89.906016]  [<ffffffffa024da71>] drm_pci_init+0x111/0x120 [drm]
[   89.906016]  [<ffffffffa0639000>] ? 0xffffffffa0638fff
[   89.906016]  [<ffffffffa0639000>] ? 0xffffffffa0638fff
[   89.906016]  [<ffffffffa06390ec>] radeon_init+0xec/0xee [radeon]
[   89.906016]  [<ffffffff810002d4>] do_one_initcall+0x44/0x170
[   89.906016]  [<ffffffff8108c332>] sys_init_module+0x92/0x1e0
[   89.906016]  [<ffffffff817fba6b>] system_call_fastpath+0x16/0x1b
[   89.906016] Code: 16 44 3b b5 ec fe ff ff 0f 8d 40 01 00 00 48 8b 83 58 11 00 00 49 63 cf 48 89 ca 48 c1 e1 06 48 c1 e2 04 48 29 d1 48 8b 44 08 08 <c7> 40 08 00 00 00 00 0f b6 45 8f 3c 02 75 ac 4c 8b 83 58 11 00 
[   89.906016] RIP  [<ffffffffa05998ed>] radeon_atombios_parse_power_table_1_3+0x13d/0x810 [radeon]
[   89.906016]  RSP <ffff880075959948>
[   89.906016] CR2: 0000000000000008
[   89.918682] ---[ end trace 758728fd12807b58 ]---

--Boundary-00=_lfrwOeV5mPCyOq/--
