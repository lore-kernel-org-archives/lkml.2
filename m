Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab1INXgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 19:36:36 -0400
Received: from solo.fdn.fr ([80.67.169.19]:34059 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488Ab1INXgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 19:36:33 -0400
X-Greylist: delayed 549 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Sep 2011 19:36:32 EDT
Date: Thu, 15 Sep 2011 01:27:17 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: keithp@keithp.com, dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Subject: [REGRESSION] i915 KMS dual head broken on DELL latitude E6420 in
 3.1-rc*
Message-ID: <20110914232717.GA5410@type.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	keithp@keithp.com, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

I'm trying to upgrade from 3.0 to 3.1-rcsomething on a DELL latitude
E6420, but dual head is broken. Here is the scenario:

- Turn computer on with VGA1 connected. Both LVDS1 and VGA1 show the
  text console fine.
- Start X. VGA1 shows X fine, but LVDS1 (1600x900 resolution) shows an
  odd screen: completely black on the left part (about 1060x900), sort
  of gray on the right part (about 540x900). Playing with xrandr doesn't
  help, I can at best make it completely black with --off, and not get
  it back again with --auto or anything else.

I have attached the corresponding dmesgs and Xorg.0.logs: as you can
see, the Xorg log doesn't change, while the dmesg changes a bit, I'm
getting a few 

[drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH

the rest is the same.

Samuel

--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.good"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.0.4 (samy@type) (gcc version 4.6.1 (Debian 4.6.1-4) ) #2 SMP Tue Aug 30 11:04:23 CEST 2011
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.0.4 root=UUID=38e6e493-2f5f-4a98-b1d6-a9434f0683cc ro
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000091400 (usable)
[    0.000000]  BIOS-e820: 0000000000091400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000020000000 (usable)
[    0.000000]  BIOS-e820: 0000000020000000 - 0000000020200000 (reserved)
[    0.000000]  BIOS-e820: 0000000020200000 - 0000000040000000 (usable)
[    0.000000]  BIOS-e820: 0000000040000000 - 0000000040200000 (reserved)
[    0.000000]  BIOS-e820: 0000000040200000 - 00000000baa2a000 (usable)
[    0.000000]  BIOS-e820: 00000000baa2a000 - 00000000baa6e000 (reserved)
[    0.000000]  BIOS-e820: 00000000baa6e000 - 00000000badb7000 (usable)
[    0.000000]  BIOS-e820: 00000000badb7000 - 00000000bade7000 (reserved)
[    0.000000]  BIOS-e820: 00000000bade7000 - 00000000bafe7000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bafe7000 - 00000000bafff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bafff000 - 00000000bb000000 (usable)
[    0.000000]  BIOS-e820: 00000000bb800000 - 00000000bfa00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 00000000ffc20000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013e000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: Dell Inc. Latitude E6420/032T9K, BIOS A05 05/24/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x13e000 max_arch_pfn = 0x400000000
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
[    0.000000]   4 base 100000000 mask FC0000000 write-back
[    0.000000]   5 base 13E000000 mask FFE000000 uncachable
[    0.000000]   6 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xbb000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f1b60] f1b60
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000008c000] 8c000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000bb000000
[    0.000000]  0000000000 - 00bb000000 page 2M
[    0.000000] kernel direct mapping tables up to bb000000 @ badb3000-badb7000
[    0.000000] init_memory_mapping: 0000000100000000-000000013e000000
[    0.000000]  0100000000 - 013e000000 page 2M
[    0.000000] kernel direct mapping tables up to 13e000000 @ 13dffa000-13e000000
[    0.000000] RAMDISK: 2db08000 - 32d7c000
[    0.000000] ACPI: RSDP 00000000000fe300 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000baffde18 0007C (v01 DELL    CBX3    06222004 MSFT 00010013)
[    0.000000] ACPI: FACP 00000000baf87d98 000F4 (v04 DELL    CBX3    06222004 MSFT 00010013)
[    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables! (20110413/tbfadt-369)
[    0.000000] ACPI Warning: 32/64X FACS address mismatch in FADT - 0xBAFE4E40/0x00000000BAFE4D40, using 32 (20110413/tbfadt-489)
[    0.000000] ACPI: DSDT 00000000baf6d018 08A3D (v02 INT430 SYSFexxx 00001001 INTL 20090903)
[    0.000000] ACPI: FACS 00000000bafe4e40 00040
[    0.000000] ACPI: APIC 00000000baffcf18 000CC (v02 DELL    CBX3    06222004 MSFT 00010013)
[    0.000000] ACPI: TCPA 00000000bafe5d18 00032 (v02                 00000000      00000000)
[    0.000000] ACPI: MCFG 00000000bafe5c98 0003C (v01 DELL   SNDYBRDG 06222004 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000bafe5c18 00038 (v01 A M I   PCHHPET 06222004 AMI. 00000003)
[    0.000000] ACPI: BOOT 00000000bafe5b98 00028 (v01 DELL   CBX3     06222004 AMI  00010013)
[    0.000000] ACPI: SSDT 00000000baf6c018 0094E (v01  PmRef  Cpu0Ist 00003000 INTL 20090903)
[    0.000000] ACPI: SSDT 00000000baf6b018 00996 (v01  PmRef    CpuPm 00003000 INTL 20090903)
[    0.000000] ACPI: DMAR 00000000baf87c18 000E8 (v01 INTEL      SNB  00000001 INTL 00000001)
[    0.000000] ACPI: SLIC 00000000baf88a18 00176 (v03 DELL    CBX3    06222004 MSFT 00010013)
[    0.000000] ACPI: SSDT 00000000baf65018 014A0 (v01 NvdRef  NvdTabl 00001000 INTL 20090903)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000013e000000
[    0.000000] Initmem setup node 0 0000000000000000-000000013e000000
[    0.000000]   NODE_DATA [000000013dffb000 - 000000013dffffff]
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880139600000-ffff88013cdfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0013e000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[7] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000091
[    0.000000]     0: 0x00000100 -> 0x00020000
[    0.000000]     0: 0x00020200 -> 0x00040000
[    0.000000]     0: 0x00040200 -> 0x000baa2a
[    0.000000]     0: 0x000baa6e -> 0x000badb7
[    0.000000]     0: 0x000bafff -> 0x000bb000
[    0.000000]     0: 0x00100000 -> 0x0013e000
[    0.000000] On node 0 totalpages: 1018101
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3908 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 745900 pages, LIFO batch:31
[    0.000000]   Normal zone: 3472 pages used for memmap
[    0.000000]   Normal zone: 250480 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x08] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x09] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x0f] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] SMP: Allowing 16 CPUs, 8 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 0000000000091000 - 0000000000092000
[    0.000000] PM: Registered nosave memory: 0000000000092000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
[    0.000000] PM: Registered nosave memory: 0000000040000000 - 0000000040200000
[    0.000000] PM: Registered nosave memory: 00000000baa2a000 - 00000000baa6e000
[    0.000000] PM: Registered nosave memory: 00000000badb7000 - 00000000bade7000
[    0.000000] PM: Registered nosave memory: 00000000bade7000 - 00000000bafe7000
[    0.000000] PM: Registered nosave memory: 00000000bafe7000 - 00000000bafff000
[    0.000000] PM: Registered nosave memory: 00000000bb000000 - 00000000bb800000
[    0.000000] PM: Registered nosave memory: 00000000bb800000 - 00000000bfa00000
[    0.000000] PM: Registered nosave memory: 00000000bfa00000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000ffc00000
[    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 00000000ffc20000
[    0.000000] PM: Registered nosave memory: 00000000ffc20000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at bfa00000 (gap: bfa00000:3f31c000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:16 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88013dc00000 s78976 r8192 d23424 u131072
[    0.000000] pcpu-alloc: s78976 r8192 d23424 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1000288
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.0.4 root=UUID=38e6e493-2f5f-4a98-b1d6-a9434f0683cc ro
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.000000] Memory: 3854332k/5210112k available (3753k kernel code, 1137708k absent, 218072k reserved, 2969k data, 572k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:33024 nr_irqs:808 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 33554432 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 2195.245 MHz processor.
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 4390.49 BogoMIPS (lpj=8780980)
[    0.000122] pid_max: default: 32768 minimum: 301
[    0.000234] Security Framework initialized
[    0.000291] SELinux:  Disabled at boot.
[    0.000721] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.001723] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.002182] Mount-cache hash table entries: 256
[    0.002362] Initializing cgroup subsys cpuacct
[    0.002426] Initializing cgroup subsys memory
[    0.002492] Initializing cgroup subsys devices
[    0.002551] Initializing cgroup subsys freezer
[    0.002608] Initializing cgroup subsys net_cls
[    0.002667] Initializing cgroup subsys blkio
[    0.002757] CPU: Physical Processor ID: 0
[    0.002814] CPU: Processor Core ID: 0
[    0.002874] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.002875] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.002998] mce: CPU supports 9 MCE banks
[    0.003066] CPU0: Thermal monitoring enabled (TM1)
[    0.003128] using mwait in idle threads.
[    0.003649] ACPI: Core revision 20110413
[    0.011562] DMAR: Host address width 36
[    0.011622] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.011687] IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
[    0.011762] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.011837] IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
[    0.011912] DMAR: RMRR base: 0x000000badc6000 end: 0x000000badd5fff
[    0.011974] DMAR: RMRR base: 0x000000bb800000 end: 0x000000bf9fffff
[    0.012035] DMAR: No ATSR found
[    0.012161] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.012221] HPET id 0 under DRHD base 0xfed91000
[    0.012280] HPET id 0 under DRHD base 0xfed91000
[    0.012339] HPET id 0 under DRHD base 0xfed91000
[    0.012396] HPET id 0 under DRHD base 0xfed91000
[    0.012455] HPET id 0 under DRHD base 0xfed91000
[    0.012513] HPET id 0 under DRHD base 0xfed91000
[    0.012571] HPET id 0 under DRHD base 0xfed91000
[    0.012629] HPET id 0 under DRHD base 0xfed91000
[    0.012885] Enabled Interrupt-remapping
[    0.012942] Enabling x2apic
[    0.012997] Enabled x2apic
[    0.014427] Switched APIC routing to cluster x2apic.
[    0.014870] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.054575] CPU0: Intel(R) Core(TM) i7-2720QM CPU @ 2.20GHz stepping 07
[    0.159668] Performance Events: PEBS fmt1+, SandyBridge events, Intel PMU driver.
[    0.159862] ... version:                3
[    0.159920] ... bit width:              48
[    0.159977] ... generic registers:      4
[    0.160034] ... value mask:             0000ffffffffffff
[    0.160094] ... max period:             000000007fffffff
[    0.160154] ... fixed-purpose events:   3
[    0.160212] ... event mask:             000000070000000f
[    0.160473] NMI watchdog enabled, takes one hw-pmu counter.
[    0.160632] Booting Node   0, Processors  #1
[    0.160717] smpboot cpu 1: start_ip = 8c000
[    0.271614] NMI watchdog enabled, takes one hw-pmu counter.
[    0.271776]  #2
[    0.271818] smpboot cpu 2: start_ip = 8c000
[    0.379533] NMI watchdog enabled, takes one hw-pmu counter.
[    0.379696]  #3
[    0.379738] smpboot cpu 3: start_ip = 8c000
[    0.487453] NMI watchdog enabled, takes one hw-pmu counter.
[    0.487612]  #4
[    0.487655] smpboot cpu 4: start_ip = 8c000
[    0.595269] NMI watchdog enabled, takes one hw-pmu counter.
[    0.595437]  #5
[    0.595479] smpboot cpu 5: start_ip = 8c000
[    0.703196] NMI watchdog enabled, takes one hw-pmu counter.
[    0.703359]  #6
[    0.703401] smpboot cpu 6: start_ip = 8c000
[    0.811017] NMI watchdog enabled, takes one hw-pmu counter.
[    0.811178]  #7
[    0.811220] smpboot cpu 7: start_ip = 8c000
[    0.918935] NMI watchdog enabled, takes one hw-pmu counter.
[    0.919024] Brought up 8 CPUs
[    0.919080] Total of 8 processors activated (35119.34 BogoMIPS).
[    0.924514] devtmpfs: initialized
[    0.928037] PM: Registering ACPI NVS region at bade7000 (2097152 bytes)
[    0.928200] Dell Latitude E6420 series board detected. Selecting PCI-method for reboots.
[    0.928404] print_constraints: dummy: 
[    0.928521] NET: Registered protocol family 16
[    0.928665] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.928741] ACPI: bus type pci registered
[    0.928878] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.928958] PCI: not using MMCONFIG
[    0.929015] PCI: Using configuration type 1 for base access
[    0.929081] dmi type 0xB1 record - unknown flag
[    0.929841] bio: create slab <bio-0> at 0
[    0.931449] ACPI: EC: Look up EC in DSDT
[    0.958841] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.994969] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    1.099107] ACPI: SSDT 00000000badd7718 0067C (v01  PmRef  Cpu0Cst 00003001 INTL 20090903)
[    1.099678] ACPI: Dynamic OEM Table Load:
[    1.099813] ACPI: SSDT           (null) 0067C (v01  PmRef  Cpu0Cst 00003001 INTL 20090903)
[    1.110968] ACPI: SSDT 00000000badd8a98 00303 (v01  PmRef    ApIst 00003000 INTL 20090903)
[    1.111589] ACPI: Dynamic OEM Table Load:
[    1.111724] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20090903)
[    1.122756] ACPI: SSDT 00000000badd6d98 00119 (v01  PmRef    ApCst 00003000 INTL 20090903)
[    1.123310] ACPI: Dynamic OEM Table Load:
[    1.123443] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20090903)
[    1.206585] ACPI: Interpreter enabled
[    1.206644] ACPI: (supports S0 S3 S4 S5)
[    1.206879] ACPI: Using IOAPIC for interrupt routing
[    1.206957] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    1.207580] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in ACPI motherboard resources
[    1.922514] ACPI: EC: GPE = 0x10, I/O: command/status = 0x934, data = 0x930
[    1.969730] ACPI: No dock devices found.
[    1.969789] HEST: Table not found.
[    1.969847] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.970380] \_SB_.PCI0:_OSC invalid UUID
[    1.970381] _OSC request data:1 8 1f 
[    1.970385] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    1.971262] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.971325] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.971388] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.971465] pci_root PNP0A08:00: host bridge window [mem 0xbfa00000-0xfeafffff]
[    1.971540] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff]
[    1.971626] pci 0000:00:00.0: [8086:0104] type 0 class 0x000600
[    1.971660] pci 0000:00:01.0: [8086:0101] type 1 class 0x000604
[    1.971685] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.971688] pci 0000:00:01.0: PME# disabled
[    1.971707] pci 0000:00:02.0: [8086:0126] type 0 class 0x000300
[    1.971718] pci 0000:00:02.0: reg 10: [mem 0xe5400000-0xe57fffff 64bit]
[    1.971724] pci 0000:00:02.0: reg 18: [mem 0xc0000000-0xcfffffff 64bit pref]
[    1.971729] pci 0000:00:02.0: reg 20: [io  0x5000-0x503f]
[    1.971781] pci 0000:00:16.0: [8086:1c3a] type 0 class 0x000780
[    1.971805] pci 0000:00:16.0: reg 10: [mem 0xe6eb0000-0xe6eb000f 64bit]
[    1.971868] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    1.971873] pci 0000:00:16.0: PME# disabled
[    1.971904] pci 0000:00:19.0: [8086:1502] type 0 class 0x000200
[    1.971924] pci 0000:00:19.0: reg 10: [mem 0xe6e00000-0xe6e1ffff]
[    1.971933] pci 0000:00:19.0: reg 14: [mem 0xe6e80000-0xe6e80fff]
[    1.971942] pci 0000:00:19.0: reg 18: [io  0x5080-0x509f]
[    1.971993] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    1.971997] pci 0000:00:19.0: PME# disabled
[    1.972024] pci 0000:00:1a.0: [8086:1c2d] type 0 class 0x000c03
[    1.972045] pci 0000:00:1a.0: reg 10: [mem 0xe6e70000-0xe6e703ff]
[    1.972120] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    1.972124] pci 0000:00:1a.0: PME# disabled
[    1.972150] pci 0000:00:1b.0: [8086:1c20] type 0 class 0x000403
[    1.972165] pci 0000:00:1b.0: reg 10: [mem 0xe6e60000-0xe6e63fff 64bit]
[    1.972223] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.972227] pci 0000:00:1b.0: PME# disabled
[    1.972252] pci 0000:00:1c.0: [8086:1c10] type 1 class 0x000604
[    1.972352] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.972357] pci 0000:00:1c.0: PME# disabled
[    1.972392] pci 0000:00:1c.1: [8086:1c12] type 1 class 0x000604
[    1.972493] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    1.972498] pci 0000:00:1c.1: PME# disabled
[    1.972534] pci 0000:00:1c.2: [8086:1c14] type 1 class 0x000604
[    1.972635] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    1.972640] pci 0000:00:1c.2: PME# disabled
[    1.972675] pci 0000:00:1c.3: [8086:1c16] type 1 class 0x000604
[    1.972775] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    1.972780] pci 0000:00:1c.3: PME# disabled
[    1.972817] pci 0000:00:1c.5: [8086:1c1a] type 1 class 0x000604
[    1.972919] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    1.972924] pci 0000:00:1c.5: PME# disabled
[    1.972965] pci 0000:00:1d.0: [8086:1c26] type 0 class 0x000c03
[    1.972987] pci 0000:00:1d.0: reg 10: [mem 0xe6e50000-0xe6e503ff]
[    1.973061] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    1.973066] pci 0000:00:1d.0: PME# disabled
[    1.973091] pci 0000:00:1f.0: [8086:1c4f] type 0 class 0x000601
[    1.973209] pci 0000:00:1f.2: [8086:282a] type 0 class 0x000104
[    1.973229] pci 0000:00:1f.2: reg 10: [io  0x50d0-0x50d7]
[    1.973237] pci 0000:00:1f.2: reg 14: [io  0x50c0-0x50c3]
[    1.973245] pci 0000:00:1f.2: reg 18: [io  0x50b0-0x50b7]
[    1.973254] pci 0000:00:1f.2: reg 1c: [io  0x50a0-0x50a3]
[    1.973262] pci 0000:00:1f.2: reg 20: [io  0x5060-0x507f]
[    1.973271] pci 0000:00:1f.2: reg 24: [mem 0xe6e40000-0xe6e407ff]
[    1.973305] pci 0000:00:1f.2: PME# supported from D3hot
[    1.973309] pci 0000:00:1f.2: PME# disabled
[    1.973328] pci 0000:00:1f.3: [8086:1c22] type 0 class 0x000c05
[    1.973344] pci 0000:00:1f.3: reg 10: [mem 0xe6e30000-0xe6e300ff 64bit]
[    1.973366] pci 0000:00:1f.3: reg 20: [io  0x5040-0x505f]
[    1.973429] pci 0000:01:00.0: [10de:1056] type 0 class 0x000300
[    1.973441] pci 0000:01:00.0: reg 10: [mem 0xe4000000-0xe4ffffff]
[    1.973454] pci 0000:01:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.973467] pci 0000:01:00.0: reg 1c: [mem 0xe0000000-0xe1ffffff 64bit pref]
[    1.973476] pci 0000:01:00.0: reg 24: [io  0x4000-0x407f]
[    1.973485] pci 0000:01:00.0: reg 30: [mem 0xe5000000-0xe507ffff pref]
[    1.973538] pci 0000:01:00.1: [10de:0e08] type 0 class 0x000403
[    1.973550] pci 0000:01:00.1: reg 10: [mem 0xe5080000-0xe5083fff]
[    1.973647] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.973709] pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
[    1.973712] pci 0000:00:01.0:   bridge window [mem 0xe4000000-0xe50fffff]
[    1.973715] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xe1ffffff 64bit pref]
[    1.973788] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.973851] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.973857] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.973866] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.973995] pci 0000:03:00.0: [14e4:4727] type 0 class 0x000280
[    1.974027] pci 0000:03:00.0: reg 10: [mem 0xe6d00000-0xe6d03fff 64bit]
[    1.974155] pci 0000:03:00.0: supports D1 D2
[    1.974157] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    1.974163] pci 0000:03:00.0: PME# disabled
[    1.974213] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    1.974275] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
[    1.974279] pci 0000:00:1c.1:   bridge window [mem 0xe6d00000-0xe6dfffff]
[    1.974286] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.974332] pci 0000:00:1c.2: PCI bridge to [bus 04-09]
[    1.974394] pci 0000:00:1c.2:   bridge window [io  0x3000-0x3fff]
[    1.974398] pci 0000:00:1c.2:   bridge window [mem 0xe6200000-0xe6bfffff]
[    1.974405] pci 0000:00:1c.2:   bridge window [mem 0xe2b00000-0xe34fffff 64bit pref]
[    1.974451] pci 0000:00:1c.3: PCI bridge to [bus 0a-0a]
[    1.974513] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    1.974518] pci 0000:00:1c.3:   bridge window [mem 0xe5800000-0xe61fffff]
[    1.974524] pci 0000:00:1c.3:   bridge window [mem 0xe2100000-0xe2afffff 64bit pref]
[    1.976339] pci 0000:0b:00.0: [1217:8221] type 0 class 0x000805
[    1.976382] pci 0000:0b:00.0: reg 10: [mem 0xe6c20000-0xe6c201ff]
[    1.976645] pci 0000:0b:00.0: supports D1 D2
[    1.976647] pci 0000:0b:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.976657] pci 0000:0b:00.0: PME# disabled
[    1.976750] pci 0000:0b:00.1: [1217:8231] type 0 class 0x000180
[    1.976793] pci 0000:0b:00.1: reg 10: [mem 0xe6c10000-0xe6c10fff]
[    1.976853] pci 0000:0b:00.1: reg 18: [mem 0xe6c00000-0xe6c007ff]
[    1.977056] pci 0000:0b:00.1: supports D1 D2
[    1.977057] pci 0000:0b:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.977068] pci 0000:0b:00.1: PME# disabled
[    1.977163] pci 0000:00:1c.5: PCI bridge to [bus 0b-0b]
[    1.977225] pci 0000:00:1c.5:   bridge window [io  0xf000-0x0000] (disabled)
[    1.977230] pci 0000:00:1c.5:   bridge window [mem 0xe6c00000-0xe6cfffff]
[    1.977236] pci 0000:00:1c.5:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.977265] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.977543] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    1.977598] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    1.977648] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    1.977702] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    1.977756] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG0._PRT]
[    1.977819] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    1.977932] \_SB_.PCI0:_OSC invalid UUID
[    1.977933] _OSC request data:1 1f 1f 
[    1.977937]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    1.978041] \_SB_.PCI0:_OSC invalid UUID
[    1.978042] _OSC request data:1 0 1d 
[    1.978045]  pci0000:00: ACPI _OSC request failed (AE_ERROR), returned control mask: 0x1d
[    1.978122] ACPI _OSC control for PCIe not granted, disabling ASPM
[    1.983598] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    1.984223] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    1.984844] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    1.985465] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    1.986095] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 *5 6 7 10 12 14 15)
[    1.986664] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    1.987321] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 *3 4 5 6 7 10 12 14 15)
[    1.987893] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    1.988591] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.988676] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=none,locks=none
[    1.988754] vgaarb: loaded
[    1.988809] vgaarb: bridge control possible 0000:01:00.0
[    1.988868] vgaarb: bridge control possible 0000:00:02.0
[    1.989053] SCSI subsystem initialized
[    1.989148] libata version 3.00 loaded.
[    1.989183] PCI: Using ACPI for IRQ routing
[    1.990751] PCI: pci_cache_line_size set to 64 bytes
[    1.990845] reserve RAM buffer: 0000000000091400 - 000000000009ffff 
[    1.990848] reserve RAM buffer: 00000000baa2a000 - 00000000bbffffff 
[    1.990852] reserve RAM buffer: 00000000badb7000 - 00000000bbffffff 
[    1.990855] reserve RAM buffer: 00000000bb000000 - 00000000bbffffff 
[    1.990858] reserve RAM buffer: 000000013e000000 - 000000013fffffff 
[    1.990960] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    1.991368] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.993442] Switching to clocksource hpet
[    1.993563] Switched to NOHz mode on CPU #0
[    1.993628] Switched to NOHz mode on CPU #1
[    1.993653] Switched to NOHz mode on CPU #6
[    1.993658] Switched to NOHz mode on CPU #4
[    1.993673] Switched to NOHz mode on CPU #2
[    1.993698] Switched to NOHz mode on CPU #7
[    1.993710] Switched to NOHz mode on CPU #5
[    1.993718] Switched to NOHz mode on CPU #3
[    1.995647] pnp: PnP ACPI init
[    1.995714] ACPI: bus type pnp registered
[    1.996188] pnp 00:00: [bus 00-3e]
[    1.996190] pnp 00:00: [io  0x0000-0x0cf7 window]
[    1.996192] pnp 00:00: [io  0x0cf8-0x0cff]
[    1.996194] pnp 00:00: [io  0x0d00-0xffff window]
[    1.996196] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    1.996198] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    1.996200] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    1.996202] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    1.996204] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    1.996206] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    1.996208] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    1.996209] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    1.996211] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    1.996213] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    1.996215] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    1.996217] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    1.996219] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    1.996220] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    1.996222] pnp 00:00: [mem 0xbfa00000-0xfeafffff window]
[    1.996224] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    1.996270] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    1.996285] pnp 00:01: [io  0x0000-0x001f]
[    1.996287] pnp 00:01: [io  0x0081-0x0091]
[    1.996288] pnp 00:01: [io  0x0093-0x009f]
[    1.996290] pnp 00:01: [io  0x00c0-0x00df]
[    1.996292] pnp 00:01: [dma 4]
[    1.996315] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.996323] pnp 00:02: [mem 0xff000000-0xffffffff]
[    1.996344] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    1.996428] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    1.996467] system 00:03: [mem 0xfed00000-0xfed003ff] has been reserved
[    1.996530] system 00:03: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    1.996542] pnp 00:04: [io  0x00f0]
[    1.996551] pnp 00:04: [irq 13]
[    1.996574] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.996585] pnp 00:05: [io  0x002e-0x002f]
[    1.996587] pnp 00:05: [io  0x004e-0x004f]
[    1.996589] pnp 00:05: [io  0x0061]
[    1.996590] pnp 00:05: [io  0x0063]
[    1.996592] pnp 00:05: [io  0x0065]
[    1.996593] pnp 00:05: [io  0x0067]
[    1.996595] pnp 00:05: [io  0x0070]
[    1.996596] pnp 00:05: [io  0x0080]
[    1.996598] pnp 00:05: [io  0x0092]
[    1.996599] pnp 00:05: [io  0x00b2-0x00b3]
[    1.996602] pnp 00:05: [io  0x0680-0x069f]
[    1.996603] pnp 00:05: [io  0x1000-0x100f]
[    1.996605] pnp 00:05: [io  0xffff]
[    1.996607] pnp 00:05: [io  0xffff]
[    1.996608] pnp 00:05: [io  0x0400-0x047f]
[    1.996610] pnp 00:05: [io  0x0500-0x057f]
[    1.996611] pnp 00:05: [io  0x164e-0x164f]
[    1.996655] system 00:05: [io  0x0680-0x069f] has been reserved
[    1.996717] system 00:05: [io  0x1000-0x100f] has been reserved
[    1.996778] system 00:05: [io  0xffff] has been reserved
[    1.996840] system 00:05: [io  0xffff] has been reserved
[    1.996901] system 00:05: [io  0x0400-0x047f] has been reserved
[    1.996962] system 00:05: [io  0x0500-0x057f] has been reserved
[    1.997022] system 00:05: [io  0x164e-0x164f] has been reserved
[    1.997084] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.997093] pnp 00:06: [io  0x0070-0x0077]
[    1.997099] pnp 00:06: [irq 8]
[    1.997126] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.997137] pnp 00:07: [io  0x0060]
[    1.997138] pnp 00:07: [io  0x0064]
[    1.997144] pnp 00:07: [irq 1]
[    1.997167] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.001927] pnp 00:08: Plug and Play ACPI device, IDs PNP0401 (disabled)
[    2.001943] pnp 00:09: [irq 12]
[    2.001968] pnp 00:09: Plug and Play ACPI device, IDs DLL0493 PNP0f13 (active)
[    2.002151] pnp 00:0a: [mem 0xfed1c000-0xfed1ffff]
[    2.002153] pnp 00:0a: [mem 0xfed10000-0xfed17fff]
[    2.002155] pnp 00:0a: [mem 0xfed18000-0xfed18fff]
[    2.002157] pnp 00:0a: [mem 0xfed19000-0xfed19fff]
[    2.002159] pnp 00:0a: [mem 0xf8000000-0xfbffffff]
[    2.002161] pnp 00:0a: [mem 0xfed20000-0xfed3ffff]
[    2.002163] pnp 00:0a: [mem 0xfed90000-0xfed93fff]
[    2.002165] pnp 00:0a: [mem 0xfed45000-0xfed8ffff]
[    2.002166] pnp 00:0a: [mem 0xff000000-0xffffffff]
[    2.002168] pnp 00:0a: [mem 0xfee00000-0xfeefffff]
[    2.002170] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
[    2.002172] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
[    2.002227] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    2.002290] system 00:0a: [mem 0xfed10000-0xfed17fff] has been reserved
[    2.002352] system 00:0a: [mem 0xfed18000-0xfed18fff] has been reserved
[    2.002414] system 00:0a: [mem 0xfed19000-0xfed19fff] has been reserved
[    2.002477] system 00:0a: [mem 0xf8000000-0xfbffffff] has been reserved
[    2.002540] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
[    2.002603] system 00:0a: [mem 0xfed90000-0xfed93fff] has been reserved
[    2.002668] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
[    2.002731] system 00:0a: [mem 0xff000000-0xffffffff] could not be reserved
[    2.002795] system 00:0a: [mem 0xfee00000-0xfeefffff] has been reserved
[    2.002858] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.005560] pnp 00:0b: [irq 23]
[    2.005599] pnp 00:0b: Plug and Play ACPI device, IDs SMO8800 (active)
[    2.018211] pnp 00:0c: [mem 0x20000000-0x201fffff]
[    2.018214] pnp 00:0c: [mem 0x40000000-0x401fffff]
[    2.018278] system 00:0c: [mem 0x20000000-0x201fffff] has been reserved
[    2.018341] system 00:0c: [mem 0x40000000-0x401fffff] has been reserved
[    2.018404] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    2.018413] pnp: PnP ACPI: found 13 devices
[    2.018472] ACPI: ACPI bus type pnp unregistered
[    2.024489] PCI: max bus depth: 1 pci_try_num: 2
[    2.024534] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    2.024596] pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
[    2.024659] pci 0000:00:01.0:   bridge window [mem 0xe4000000-0xe50fffff]
[    2.024723] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xe1ffffff 64bit pref]
[    2.024801] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    2.024861] pci 0000:00:1c.0:   bridge window [io  disabled]
[    2.024925] pci 0000:00:1c.0:   bridge window [mem disabled]
[    2.024988] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    2.025054] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    2.025113] pci 0000:00:1c.1:   bridge window [io  disabled]
[    2.025177] pci 0000:00:1c.1:   bridge window [mem 0xe6d00000-0xe6dfffff]
[    2.025241] pci 0000:00:1c.1:   bridge window [mem pref disabled]
[    2.025307] pci 0000:00:1c.2: PCI bridge to [bus 04-09]
[    2.025375] pci 0000:00:1c.2:   bridge window [io  0x3000-0x3fff]
[    2.025440] pci 0000:00:1c.2:   bridge window [mem 0xe6200000-0xe6bfffff]
[    2.025505] pci 0000:00:1c.2:   bridge window [mem 0xe2b00000-0xe34fffff 64bit pref]
[    2.025586] pci 0000:00:1c.3: PCI bridge to [bus 0a-0a]
[    2.025647] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    2.025712] pci 0000:00:1c.3:   bridge window [mem 0xe5800000-0xe61fffff]
[    2.025776] pci 0000:00:1c.3:   bridge window [mem 0xe2100000-0xe2afffff 64bit pref]
[    2.025858] pci 0000:00:1c.5: PCI bridge to [bus 0b-0b]
[    2.025917] pci 0000:00:1c.5:   bridge window [io  disabled]
[    2.025980] pci 0000:00:1c.5:   bridge window [mem 0xe6c00000-0xe6cfffff]
[    2.026045] pci 0000:00:1c.5:   bridge window [mem pref disabled]
[    2.026122] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.026186] pci 0000:00:01.0: setting latency timer to 64
[    2.026193] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.026257] pci 0000:00:1c.0: setting latency timer to 64
[    2.026269] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.027711] pci 0000:00:1c.1: setting latency timer to 64
[    2.027722] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.027787] pci 0000:00:1c.2: setting latency timer to 64
[    2.027800] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    2.027867] pci 0000:00:1c.3: setting latency timer to 64
[    2.027874] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.027938] pci 0000:00:1c.5: setting latency timer to 64
[    2.027942] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.027944] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.027946] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.027948] pci_bus 0000:00: resource 7 [mem 0xbfa00000-0xfeafffff]
[    2.027950] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
[    2.027952] pci_bus 0000:01: resource 0 [io  0x4000-0x4fff]
[    2.027954] pci_bus 0000:01: resource 1 [mem 0xe4000000-0xe50fffff]
[    2.027955] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xe1ffffff 64bit pref]
[    2.027958] pci_bus 0000:03: resource 1 [mem 0xe6d00000-0xe6dfffff]
[    2.027959] pci_bus 0000:04: resource 0 [io  0x3000-0x3fff]
[    2.027961] pci_bus 0000:04: resource 1 [mem 0xe6200000-0xe6bfffff]
[    2.027963] pci_bus 0000:04: resource 2 [mem 0xe2b00000-0xe34fffff 64bit pref]
[    2.027965] pci_bus 0000:0a: resource 0 [io  0x2000-0x2fff]
[    2.027967] pci_bus 0000:0a: resource 1 [mem 0xe5800000-0xe61fffff]
[    2.027969] pci_bus 0000:0a: resource 2 [mem 0xe2100000-0xe2afffff 64bit pref]
[    2.027971] pci_bus 0000:0b: resource 1 [mem 0xe6c00000-0xe6cfffff]
[    2.028073] NET: Registered protocol family 2
[    2.028293] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    2.029375] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    2.030796] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    2.030996] TCP: Hash tables configured (established 524288 bind 65536)
[    2.031058] TCP reno registered
[    2.031123] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    2.031202] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    2.031443] NET: Registered protocol family 1
[    2.031515] pci 0000:00:02.0: Boot video device
[    2.031637] PCI: CLS 64 bytes, default 64
[    2.031676] Unpacking initramfs...
[    3.796849] Freeing initrd memory: 84432k freed
[    3.806963] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    3.807030] Placing 64MB software IO TLB between ffff8800b6a2a000 - ffff8800baa2a000
[    3.807107] software IO TLB at phys 0xb6a2a000 - 0xbaa2a000
[    3.807191] Simple Boot Flag at 0xf3 set to 0x1
[    3.807997] audit: initializing netlink socket (disabled)
[    3.808066] type=2000 audit(1316030254.588:1): initialized
[    3.827462] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.835955] VFS: Disk quotas dquot_6.5.2
[    3.836057] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.836512] msgmni has been set to 7692
[    3.836743] alg: No test for stdrng (krng)
[    3.836841] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    3.836917] io scheduler noop registered
[    3.836974] io scheduler deadline registered
[    3.837063] io scheduler cfq registered (default)
[    3.837209] pcieport 0000:00:01.0: setting latency timer to 64
[    3.837241] pcieport 0000:00:01.0: irq 42 for MSI/MSI-X
[    3.837581] ERST: Table is not found!
[    3.837694] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.019640] Linux agpgart interface v0.103
[    4.019779] agpgart-intel 0000:00:00.0: Intel Sandybridge Chipset
[    4.019925] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    4.021211] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
[    4.021385] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    4.021582] ahci 0000:00:1f.2: version 3.0
[    4.021593] ahci 0000:00:1f.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    4.021703] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    4.021729] ahci: SSS flag set, parallel bus scan disabled
[    4.035227] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3b impl RAID mode
[    4.035319] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ems sxs apst 
[    4.035397] ahci 0000:00:1f.2: setting latency timer to 64
[    4.067684] scsi0 : ahci
[    4.067849] scsi1 : ahci
[    4.067967] scsi2 : ahci
[    4.068083] scsi3 : ahci
[    4.068200] scsi4 : ahci
[    4.068317] scsi5 : ahci
[    4.079844] ata1: SATA max UDMA/133 abar m2048@0xe6e40000 port 0xe6e40100 irq 43
[    4.079921] ata2: SATA max UDMA/133 abar m2048@0xe6e40000 port 0xe6e40180 irq 43
[    4.079996] ata3: DUMMY
[    4.080051] ata4: SATA max UDMA/133 abar m2048@0xe6e40000 port 0xe6e40280 irq 43
[    4.080127] ata5: SATA max UDMA/133 abar m2048@0xe6e40000 port 0xe6e40300 irq 43
[    4.080203] ata6: SATA max UDMA/133 abar m2048@0xe6e40000 port 0xe6e40380 irq 43
[    4.080357] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    4.080668] i8042: Warning: Keylock active
[    4.082111] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.082174] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.082333] mousedev: PS/2 mouse device common for all mice
[    4.082431] rtc_cmos 00:06: RTC can wake from S4
[    4.082616] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    4.082715] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    4.082785] cpuidle: using governor ladder
[    4.082843] cpuidle: using governor menu
[    4.083084] TCP cubic registered
[    4.083263] NET: Registered protocol family 10
[    4.083380] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    4.083988] Mobile IPv6
[    4.084044] NET: Registered protocol family 17
[    4.084105] Registering the dns_resolver key type
[    4.084253] PM: Hibernation image not present or could not be loaded.
[    4.084261] registered taskstats version 1
[    4.089225] rtc_cmos 00:06: setting system clock to 2011-09-14 19:57:35 UTC (1316030255)
[    4.089363] Initializing network drop monitor service
[    4.398792] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.406935] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    4.408087] ata1.00: ATA-8: SAMSUNG SSD PM810 2.5" 256GB, AXM08D1Q, max UDMA/133
[    4.408196] ata1.00: 500118192 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    4.415034] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    4.417658] ata1.00: configured for UDMA/133
[    4.422918] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG SSD PM81 AXM0 PQ: 0 ANSI: 5
[    4.423167] sd 0:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
[    4.423291] sd 0:0:0:0: [sda] Write Protect is off
[    4.423351] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.423366] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.425218]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
[    4.425699] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.742410] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.746052] ata2.00: ATAPI: HL-DT-ST DVD+/-RW GU40N, A103, max UDMA/133
[    4.750010] ata2.00: configured for UDMA/133
[    4.753165] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GU40N    A103 PQ: 0 ANSI: 5
[    4.802347] Refined TSC clocksource calibration: 2195.013 MHz.
[    4.802437] Switching to clocksource tsc
[    5.070043] ata4: SATA link down (SStatus 0 SControl 300)
[    5.389690] ata5: SATA link down (SStatus 0 SControl 300)
[    5.709340] ata6: SATA link down (SStatus 0 SControl 300)
[    5.710387] Freeing unused kernel memory: 572k freed
[    5.710506] Write protecting the kernel read-only data: 6144k
[    5.711695] Freeing unused kernel memory: 324k freed
[    5.713533] Freeing unused kernel memory: 528k freed
[    5.779050] udevd[95]: starting version 172
[    5.794123] e1000e: Intel(R) PRO/1000 Network Driver - 1.3.10-k2
[    5.794191] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    5.803664] sdhci: Secure Digital Host Controller Interface driver
[    5.803729] sdhci: Copyright(c) Pierre Ossman
[    5.804133] sdhci-pci 0000:0b:00.0: SDHCI controller found [1217:8221] (rev 5)
[    5.811138] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    5.811218] cdrom: Uniform CD-ROM driver Revision: 3.20
[    5.811403] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    5.813031] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.813121] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    5.833279] sdhci-pci 0000:0b:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    5.833291] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    5.833305] e1000e 0000:00:19.0: setting latency timer to 64
[    5.833592] sdhci-pci 0000:0b:00.0: Invalid iomem size. You may experience problems.
[    5.833641] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    5.833717] sdhci-pci 0000:0b:00.0: setting latency timer to 64
[    5.833739] mmc0: no vmmc regulator found
[    5.833829] Registered led device: mmc0::
[    5.833867] mmc0: SDHCI controller on PCI [0000:0b:00.0] using DMA
[    5.893170] thermal LNXTHERM:00: registered as thermal_zone0
[    5.893234] ACPI: Thermal Zone [THM] (25 C)
[    6.140093] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 5c:26:0a:6b:0b:75
[    6.140172] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    6.140271] e1000e 0000:00:19.0: eth0: MAC: 10, PHY: 11, PBA No: 3041FF-0FF
[    6.824801] PM: Marking nosave pages: 0000000000091000 - 0000000000100000
[    6.824806] PM: Marking nosave pages: 0000000020000000 - 0000000020200000
[    6.824816] PM: Marking nosave pages: 0000000040000000 - 0000000040200000
[    6.824825] PM: Marking nosave pages: 00000000baa2a000 - 00000000baa6e000
[    6.824828] PM: Marking nosave pages: 00000000badb7000 - 00000000bafff000
[    6.824839] PM: Marking nosave pages: 00000000bb000000 - 0000000100000000
[    6.826343] PM: Basic memory bitmaps created
[    6.845427] PM: Basic memory bitmaps freed
[    6.854184] EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: (null)
[    7.358350] udevd[335]: starting version 172
[    7.449941] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    7.450653] ACPI: Lid Switch [LID]
[    7.450776] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[    7.450856] ACPI: Power Button [PBTN]
[    7.450947] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
[    7.451022] ACPI: Sleep Button [SBTN]
[    7.451155] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[    7.451261] ACPI: Power Button [PWRF]
[    7.459335] wmi: Mapper loaded
[    7.473244] parport_pc 00:08: [io  0x0378-0x037b]
[    7.473303] parport_pc 00:08: [irq 5]
[    7.476328] ACPI: acpi_idle registered with cpuidle
[    7.485764] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    7.493313] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    7.543442] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    7.544913] Monitor-Mwait will be used to enter C-1 state
[    7.544938] Monitor-Mwait will be used to enter C-2 state
[    7.544957] Monitor-Mwait will be used to enter C-3 state
[    7.563225] cfg80211: Calling CRDA to update world regulatory domain
[    7.595494] input: Dell WMI hotkeys as /devices/virtual/input/input6
[    7.704885] parport_pc 00:08: activated
[    7.705064] parport_pc 00:08: reported by Plug and Play ACPI
[    7.709298] parport_pc 00:08: disabled
[    7.713048] ACPI: Battery Slot [BAT0] (battery present)
[    7.919491] ACPI: Battery Slot [BAT1] (battery absent)
[    7.920836] ACPI: Battery Slot [BAT2] (battery absent)
[    7.922219] ACPI: AC Adapter [AC] (on-line)
[    8.067426] brcmutil: module is from the staging directory, the quality is unknown, you have been warned.
[    8.085425] [drm] Initialized drm 1.1.0 20060810
[    8.150324] brcmsmac: module is from the staging directory, the quality is unknown, you have been warned.
[    8.152385] brcmsmac 0000:03:00.0: bus 3 slot 0 func 0 irq 10
[    8.152452] brcmsmac 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    8.152513] brcmsmac 0000:03:00.0: setting latency timer to 64
[    8.752097] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    8.752219] HDA Intel 0000:00:1b.0: irq 45 for MSI/MSI-X
[    8.752238] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    8.752361] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[    9.253437] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input7
[    9.253746] hda_codec: connection list not available for 0xf
[    9.262216] input: HDA Intel PCH Mic at Sep Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    9.262374] input: HDA Intel PCH Mic at Ext Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    9.262506] input: HDA Intel PCH Line Out at Sep Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    9.262639] input: HDA Intel PCH HP Out at Ext Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    9.263223] HDA Intel 0000:01:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    9.263227] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    9.263233] i915 0000:00:02.0: setting latency timer to 64
[    9.263368] hda_intel: Disabling MSI
[    9.263500] HDA Intel 0000:01:00.1: setting latency timer to 64
[    9.303504] i915 0000:00:02.0: irq 46 for MSI/MSI-X
[    9.303509] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    9.303574] [drm] Driver supports precise vblank timestamp query.
[    9.303846] [drm:intel_dsm_platform_mux_info] *ERROR* MUX INFO call failed
[    9.303926] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
[    9.304005] vgaarb: transferring owner from PCI:0000:00:02.0 to PCI:0000:01:00.0
[    9.521602] fbcon: inteldrmfb (fb0) is primary device
[    9.880768] Console: switching to colour frame buffer device 160x56
[    9.886161] fb0: inteldrmfb frame buffer device
[    9.886162] drm: registered panic notifier
[   10.388188] ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20110413/evregion-478)
[   10.388275] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.ECDV.ECR1] (Node ffff880136f04fd8), AE_TIME (20110413/psparse-536)
[   10.388390] ACPI Error: Method parse/execution failed [\ECRB] (Node ffff880136f04e70), AE_TIME (20110413/psparse-536)
[   10.388494] ACPI Error: Method parse/execution failed [\ECGB] (Node ffff880136f04ba0), AE_TIME (20110413/psparse-536)
[   10.388595] ACPI Error: Method parse/execution failed [\_SB_.PCI0.VID_.LCD_._ADR] (Node ffff880136f09da8), AE_TIME (20110413/psparse-536)
[   10.815766] HDMI status: Pin=5 Presence_Detect=0 ELD_Valid=0
[   10.891677] HDMI status: Pin=6 Presence_Detect=0 ELD_Valid=0
[   10.963603] HDMI status: Pin=7 Presence_Detect=0 ELD_Valid=0
[   11.043643] input: HDA NVidia HDMI/DP as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input12
[   11.043772] input: HDA NVidia HDMI/DP as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input13
[   11.043885] input: HDA NVidia HDMI/DP as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input14
[   11.219327] ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20110413/evregion-478)
[   11.219456] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.ECDV.ECR1] (Node ffff880136f04fd8), AE_TIME (20110413/psparse-536)
[   11.219551] ACPI Error: Method parse/execution failed [\ECRB] (Node ffff880136f04e70), AE_TIME (20110413/psparse-536)
[   11.219630] ACPI Error: Method parse/execution failed [\ECGB] (Node ffff880136f04ba0), AE_TIME (20110413/psparse-536)
[   11.219710] ACPI Error: Method parse/execution failed [\_SB_.PCI0.PEG0.VID_.LCD_._ADR] (Node ffff880136f222b8), AE_TIME (20110413/psparse-536)
[   11.219806] ACPI: Can't attach device
[   11.343304] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:13/LNXVIDEO:00/input/input15
[   11.343447] ACPI: Video Device [VID] (multi-head: yes  rom: yes  post: no)
[   12.262742] input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input16
[   12.530579] acpi device:3f: registered as cooling_device8
[   12.603040] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input17
[   12.603171] ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
[   12.603282] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   13.120228] Adding 7811068k swap on /dev/sda5.  Priority:-1 extents:1 across:7811068k SS
[   13.133574] EXT4-fs (sda6): re-mounted. Opts: (null)
[   13.230655] EXT4-fs (sda6): re-mounted. Opts: errors=remount-ro,discard
[   13.256935] loop: module loaded
[   13.342983] usbcore: registered new interface driver usbfs
[   13.344926] usbcore: registered new interface driver hub
[   13.346924] usbcore: registered new device driver usb
[   13.356649] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   13.358599] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   13.360538] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[   13.360543] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[   13.362425] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[   13.364338] ehci_hcd 0000:00:1a.0: debug port 2
[   13.370061] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[   13.370086] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xe6e70000
[   13.388913] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[   13.391400] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   13.393213] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.395014] usb usb1: Product: EHCI Host Controller
[   13.396754] usb usb1: Manufacturer: Linux 3.0.4 ehci_hcd
[   13.398514] usb usb1: SerialNumber: 0000:00:1a.0
[   13.400399] hub 1-0:1.0: USB hub found
[   13.402286] hub 1-0:1.0: 2 ports detected
[   13.464865] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   13.466972] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[   13.466977] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[   13.468954] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[   13.470937] ehci_hcd 0000:00:1d.0: debug port 2
[   13.477005] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[   13.477018] ehci_hcd 0000:00:1d.0: irq 17, io mem 0xe6e50000
[   13.496775] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[   13.496801] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   13.496804] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.496806] usb usb2: Product: EHCI Host Controller
[   13.496808] usb usb2: Manufacturer: Linux 3.0.4 ehci_hcd
[   13.496810] usb usb2: SerialNumber: 0000:00:1d.0
[   13.496967] hub 2-0:1.0: USB hub found
[   13.496973] hub 2-0:1.0: 2 ports detected
[   13.512951] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   13.525145] coretemp coretemp.0: TjMax is 100 C.
[   13.526535] coretemp coretemp.0: TjMax is 100 C.
[   13.527929] coretemp coretemp.0: TjMax is 100 C.
[   13.529628] coretemp coretemp.0: TjMax is 100 C.
[   13.732562] usb 1-1: new high speed USB device number 2 using ehci_hcd
[   13.781071] EXT4-fs (sda9): mounted filesystem with ordered data mode. Opts: discard
[   13.800098] FAT-fs (sda1): utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
[   13.800101] 
[   13.847241] fuse init (API version 7.16)
[   13.864816] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[   13.866197] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   13.867824] hub 1-1:1.0: USB hub found
[   13.869409] hub 1-1:1.0: 6 ports detected
[   13.980258] usb 2-1: new high speed USB device number 2 using ehci_hcd
[   14.112515] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[   14.115213] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   14.115412] hub 2-1:1.0: USB hub found
[   14.115514] hub 2-1:1.0: 8 ports detected
[   14.188153] usb 1-1.4: new full speed USB device number 3 using ehci_hcd
[   14.296184] usb 1-1.4: New USB device found, idVendor=413c, idProduct=8187
[   14.299145] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   14.299147] usb 1-1.4: Product: DW375 Bluetooth Module
[   14.299148] usb 1-1.4: Manufacturer: Dell Computer Corp
[   14.299150] usb 1-1.4: SerialNumber: D0DF9A3D158D
[   14.387938] usb 2-1.1: new full speed USB device number 3 using ehci_hcd
[   14.484982] usb 2-1.1: New USB device found, idVendor=04b4, idProduct=2050
[   14.486573] usb 2-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   14.488489] hub 2-1.1:1.0: USB hub found
[   14.490316] hub 2-1.1:1.0: 3 ports detected
[   14.567737] usb 2-1.2: new high speed USB device number 4 using ehci_hcd
[   14.661253] usb 2-1.2: New USB device found, idVendor=07ff, idProduct=00ff
[   14.664393] usb 2-1.2: New USB device strings: Mfr=10, Product=11, SerialNumber=5
[   14.665901] usb 2-1.2: Product: USB20
[   14.667454] usb 2-1.2: Manufacturer: USBID
[   14.669016] usb 2-1.2: SerialNumber: 34A1677A2150
[   14.747540] usb 2-1.6: new high speed USB device number 5 using ehci_hcd
[   14.853072] usb 2-1.6: New USB device found, idVendor=413c, idProduct=818d
[   14.854591] usb 2-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   14.854593] usb 2-1.6: Product: DW5550
[   14.854595] usb 2-1.6: Manufacturer: Dell
[   14.854596] usb 2-1.6: SerialNumber: 5B698558903EF940
[   14.967320] usb 2-1.8: new full speed USB device number 6 using ehci_hcd
[   15.093839] usb 2-1.8: New USB device found, idVendor=0a5c, idProduct=5800
[   15.098189] usb 2-1.8: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   15.100403] usb 2-1.8: Product: 5880
[   15.102542] usb 2-1.8: Manufacturer: Broadcom Corp
[   15.104705] usb 2-1.8: SerialNumber: 0123456789ABCD
[   15.106881] usb 2-1.8: config 0 descriptor??
[   15.187083] usb 2-1.1.1: new full speed USB device number 7 using ehci_hcd
[   15.256024] speakup: module is from the staging directory, the quality is unknown, you have been warned.
[   15.261221] vboxdrv: Found 8 processor cores.
[   15.261544] vboxdrv: fAsync=0 offMin=0x3b4 offMax=0x1a74
[   15.264133] input: Speakup as /devices/virtual/input/input18
[   15.264179] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
[   15.264181] vboxdrv: Successfully loaded version 4.1.0_Debian (interface 0x00190000).
[   15.269979] initialized device: /dev/synth, node (MAJOR 10, MINOR 25)
[   15.273036] speakup 3.1.6: initialized
[   15.273038] synth name on entry is: (null)
[   15.280081] usb 2-1.1.1: New USB device found, idVendor=058f, idProduct=9254
[   15.280084] usb 2-1.1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   15.280087] usb 2-1.1.1: Product: Generic USB Hub
[   15.280089] usb 2-1.1.1: Manufacturer: ALCOR
[   15.280368] hub 2-1.1.1:1.0: USB hub found
[   15.280449] speakup_soft: module is from the staging directory, the quality is unknown, you have been warned.
[   15.280568] hub 2-1.1.1:1.0: 4 ports detected
[   15.280656] synth probe
[   15.280691] initialized device: /dev/softsynth, node (MAJOR 10, MINOR 26)
[   15.316002] vboxpci: IOMMU not found (not registered)
[   15.354866] usb 2-1.1.3: new full speed USB device number 8 using ehci_hcd
[   15.394943] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   15.450705] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   15.451082] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   15.456628] usb 2-1.1.3: New USB device found, idVendor=0458, idProduct=004c
[   15.460880] usb 2-1.1.3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[   15.464185] usb 2-1.1.3: Product: ABBHOME
[   15.486159] cdc_acm 2-1.6:1.1: ttyACM0: USB ACM device
[   15.489464] cdc_acm 2-1.6:1.3: ttyACM1: USB ACM device
[   15.495724] cdc_acm 2-1.6:1.9: ttyACM2: USB ACM device
[   15.499900] usbcore: registered new interface driver uas
[   15.503540] usbcore: registered new interface driver cdc_acm
[   15.503746] cdc_wdm 2-1.6:1.5: cdc-wdm-176: USB WDM device
[   15.503797] cdc_wdm 2-1.6:1.8: cdc-wdm-175: USB WDM device
[   15.503816] usbcore: registered new interface driver cdc_wdm
[   15.514446] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[   15.518079] Initializing USB Mass Storage driver...
[   15.520790] scsi6 : usb-storage 2-1.2:1.0
[   15.523297] cdc_ncm: 01-June-2011
[   15.523417] usbcore: registered new interface driver usb-storage
[   15.523418] USB Mass Storage support registered.
[   15.536944] input: ABBHOME as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1.3/2-1.1.3:1.0/input/input19
[   15.542718] generic-usb 0003:0458:004C.0001: input,hidraw0: USB HID v1.10 Mouse [ABBHOME] on usb-0000:00:1d.0-1.1.3/input0
[   15.547893] usb 2-1.6: MAC-Address: 0x02:0x80:0x37:0xec:0x02:0x00
[   15.548290] cdc_ncm 2-1.6:1.6: usb0: register 'cdc_ncm' at usb-0000:00:1d.0-1.6, CDC NCM, 02:80:37:ec:02:00
[   15.548311] usbcore: registered new interface driver cdc_ncm
[   15.558635] usb 2-1.1.1.1: new full speed USB device number 9 using ehci_hcd
[   15.562467] usbcore: registered new interface driver usbhid
[   15.565152] usbhid: USB HID core driver
[   15.582177]  updated 224 of 224 character descriptions
[   15.584949]  updated 96 of 180 character class entries
[   15.652594] usb 2-1.1.1.1: New USB device found, idVendor=04fc, idProduct=0561
[   15.655329] usb 2-1.1.1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   15.658034] usb 2-1.1.1.1: Product: Generic Digital camera
[   15.658037] usb 2-1.1.1.1: Manufacturer: Sunplus Technology Co., Ltd.
[   15.730514] usb 2-1.1.1.2: new low speed USB device number 10 using ehci_hcd
[   15.828898] usb 2-1.1.1.2: New USB device found, idVendor=046d, idProduct=c050
[   15.834093] usb 2-1.1.1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   15.836788] usb 2-1.1.1.2: Product: USB-PS/2 Optical Mouse
[   15.836791] usb 2-1.1.1.2: Manufacturer: Logitech
[   15.840890] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1.1/2-1.1.1.2/2-1.1.1.2:1.0/input/input20
[   15.841091] generic-usb 0003:046D:C050.0002: input,hidraw1: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1.1.1.2/input0
[   15.863063] Linux media interface: v0.10
[   15.874554] Linux video capture interface: v2.00
[   15.880909] gspca: v2.13.0 registered
[   16.234255] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input21
[   16.397973] input: spca561 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1.1/2-1.1.1.1/input/input22
[   16.398144] usbcore: registered new interface driver spca561
[   16.522736] scsi 6:0:0:0: Direct-Access     Hitachi  HDT721016SLA380  A3AA PQ: 0 ANSI: 2 CCS
[   16.841372] sd 6:0:0:0: Attached scsi generic sg2 type 0
[   16.841876] sd 6:0:0:0: [sdb] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[   16.842617] sd 6:0:0:0: [sdb] Write Protect is off
[   16.842621] sd 6:0:0:0: [sdb] Mode Sense: 00 38 00 00
[   16.843363] sd 6:0:0:0: [sdb] Asking for cache data failed
[   16.843365] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[   16.845591] sd 6:0:0:0: [sdb] Asking for cache data failed
[   16.845593] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[   16.847218]  sdb: unknown partition table
[   16.859522] sd 6:0:0:0: [sdb] Asking for cache data failed
[   16.862515] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[   16.862516] sd 6:0:0:0: [sdb] Attached SCSI disk
[   17.001828] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
[   17.003259] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   17.004900] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   27.714244] ip_tables: (C) 2000-2006 Netfilter Core Team
[   27.758673] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   46.542635] sd_espeak[2589]: segfault at 7f0788037000 ip 00007f07974f6565 sp 00007f0791027b28 error 4 in libc-2.13.so[7f07973dc000+17a000]
[   58.613522] [drm] Changing LVDS panel from (+hsync, -vsync) to (-hsync, -vsync)
[   59.984072] [drm] Changing LVDS panel from (-hsync, -vsync) to (+hsync, -vsync)

--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.bad"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.1.0-rc6 (samy@type) (gcc version 4.6.1 (Debian 4.6.1-4) ) #1 SMP Wed Sep 14 19:23:48 CEST 2011
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.1.0-rc6 root=UUID=38e6e493-2f5f-4a98-b1d6-a9434f0683cc ro
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000091400 (usable)
[    0.000000]  BIOS-e820: 0000000000091400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000020000000 (usable)
[    0.000000]  BIOS-e820: 0000000020000000 - 0000000020200000 (reserved)
[    0.000000]  BIOS-e820: 0000000020200000 - 0000000040000000 (usable)
[    0.000000]  BIOS-e820: 0000000040000000 - 0000000040200000 (reserved)
[    0.000000]  BIOS-e820: 0000000040200000 - 00000000baa2a000 (usable)
[    0.000000]  BIOS-e820: 00000000baa2a000 - 00000000baa6e000 (reserved)
[    0.000000]  BIOS-e820: 00000000baa6e000 - 00000000badb7000 (usable)
[    0.000000]  BIOS-e820: 00000000badb7000 - 00000000bade7000 (reserved)
[    0.000000]  BIOS-e820: 00000000bade7000 - 00000000bafe7000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bafe7000 - 00000000bafff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bafff000 - 00000000bb000000 (usable)
[    0.000000]  BIOS-e820: 00000000bb800000 - 00000000bfa00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 00000000ffc20000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013e000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: Dell Inc. Latitude E6420/032T9K, BIOS A05 05/24/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x13e000 max_arch_pfn = 0x400000000
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
[    0.000000]   4 base 100000000 mask FC0000000 write-back
[    0.000000]   5 base 13E000000 mask FFE000000 uncachable
[    0.000000]   6 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xbb000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f1b60] f1b60
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000008c000] 8c000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000bb000000
[    0.000000]  0000000000 - 00bb000000 page 2M
[    0.000000] kernel direct mapping tables up to bb000000 @ badb3000-badb7000
[    0.000000] init_memory_mapping: 0000000100000000-000000013e000000
[    0.000000]  0100000000 - 013e000000 page 2M
[    0.000000] kernel direct mapping tables up to 13e000000 @ 13dffa000-13e000000
[    0.000000] RAMDISK: 3428c000 - 3613e000
[    0.000000] ACPI: RSDP 00000000000fe300 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000baffde18 0007C (v01 DELL    CBX3    06222004 MSFT 00010013)
[    0.000000] ACPI: FACP 00000000baf87d98 000F4 (v04 DELL    CBX3    06222004 MSFT 00010013)
[    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables! (20110623/tbfadt-369)
[    0.000000] ACPI Warning: 32/64X FACS address mismatch in FADT - 0xBAFE4E40/0x00000000BAFE4D40, using 32 (20110623/tbfadt-489)
[    0.000000] ACPI: DSDT 00000000baf6d018 08A3D (v02 INT430 SYSFexxx 00001001 INTL 20090903)
[    0.000000] ACPI: FACS 00000000bafe4e40 00040
[    0.000000] ACPI: APIC 00000000baffcf18 000CC (v02 DELL    CBX3    06222004 MSFT 00010013)
[    0.000000] ACPI: TCPA 00000000bafe5d18 00032 (v02                 00000000      00000000)
[    0.000000] ACPI: MCFG 00000000bafe5c98 0003C (v01 DELL   SNDYBRDG 06222004 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000bafe5c18 00038 (v01 A M I   PCHHPET 06222004 AMI. 00000003)
[    0.000000] ACPI: BOOT 00000000bafe5b98 00028 (v01 DELL   CBX3     06222004 AMI  00010013)
[    0.000000] ACPI: SSDT 00000000baf6c018 0094E (v01  PmRef  Cpu0Ist 00003000 INTL 20090903)
[    0.000000] ACPI: SSDT 00000000baf6b018 00996 (v01  PmRef    CpuPm 00003000 INTL 20090903)
[    0.000000] ACPI: DMAR 00000000baf87c18 000E8 (v01 INTEL      SNB  00000001 INTL 00000001)
[    0.000000] ACPI: SLIC 00000000baf88a18 00176 (v03 DELL    CBX3    06222004 MSFT 00010013)
[    0.000000] ACPI: SSDT 00000000baf65018 014A0 (v01 NvdRef  NvdTabl 00001000 INTL 20090903)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000013e000000
[    0.000000] Initmem setup node 0 0000000000000000-000000013e000000
[    0.000000]   NODE_DATA [000000013dffb000 - 000000013dffffff]
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880139600000-ffff88013cdfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0013e000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[7] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000091
[    0.000000]     0: 0x00000100 -> 0x00020000
[    0.000000]     0: 0x00020200 -> 0x00040000
[    0.000000]     0: 0x00040200 -> 0x000baa2a
[    0.000000]     0: 0x000baa6e -> 0x000badb7
[    0.000000]     0: 0x000bafff -> 0x000bb000
[    0.000000]     0: 0x00100000 -> 0x0013e000
[    0.000000] On node 0 totalpages: 1018101
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3908 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 745900 pages, LIFO batch:31
[    0.000000]   Normal zone: 3472 pages used for memmap
[    0.000000]   Normal zone: 250480 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x08] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x09] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x0f] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] SMP: Allowing 16 CPUs, 8 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 0000000000091000 - 0000000000092000
[    0.000000] PM: Registered nosave memory: 0000000000092000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
[    0.000000] PM: Registered nosave memory: 0000000040000000 - 0000000040200000
[    0.000000] PM: Registered nosave memory: 00000000baa2a000 - 00000000baa6e000
[    0.000000] PM: Registered nosave memory: 00000000badb7000 - 00000000bade7000
[    0.000000] PM: Registered nosave memory: 00000000bade7000 - 00000000bafe7000
[    0.000000] PM: Registered nosave memory: 00000000bafe7000 - 00000000bafff000
[    0.000000] PM: Registered nosave memory: 00000000bb000000 - 00000000bb800000
[    0.000000] PM: Registered nosave memory: 00000000bb800000 - 00000000bfa00000
[    0.000000] PM: Registered nosave memory: 00000000bfa00000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000ffc00000
[    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 00000000ffc20000
[    0.000000] PM: Registered nosave memory: 00000000ffc20000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at bfa00000 (gap: bfa00000:3f31c000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:16 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88013dc00000 s80768 r8192 d21632 u131072
[    0.000000] pcpu-alloc: s80768 r8192 d21632 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1000288
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.1.0-rc6 root=UUID=38e6e493-2f5f-4a98-b1d6-a9434f0683cc ro
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.000000] Memory: 3907288k/5210112k available (3984k kernel code, 1137708k absent, 165116k reserved, 2772k data, 576k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:33024 nr_irqs:808 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 33554432 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 2194.943 MHz processor.
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 4389.88 BogoMIPS (lpj=8779772)
[    0.000125] pid_max: default: 32768 minimum: 301
[    0.000229] Security Framework initialized
[    0.000289] SELinux:  Disabled at boot.
[    0.000747] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.001764] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.002220] Mount-cache hash table entries: 256
[    0.002408] Initializing cgroup subsys cpuacct
[    0.002473] Initializing cgroup subsys memory
[    0.002542] Initializing cgroup subsys devices
[    0.002600] Initializing cgroup subsys freezer
[    0.002659] Initializing cgroup subsys net_cls
[    0.002717] Initializing cgroup subsys blkio
[    0.002805] CPU: Physical Processor ID: 0
[    0.002861] CPU: Processor Core ID: 0
[    0.002920] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.002921] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.003042] mce: CPU supports 9 MCE banks
[    0.003111] CPU0: Thermal monitoring enabled (TM1)
[    0.003175] using mwait in idle threads.
[    0.003723] ACPI: Core revision 20110623
[    0.012135] DMAR: Host address width 36
[    0.012195] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.012260] IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
[    0.012335] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.012399] IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
[    0.012476] DMAR: RMRR base: 0x000000badc6000 end: 0x000000badd5fff
[    0.012538] DMAR: RMRR base: 0x000000bb800000 end: 0x000000bf9fffff
[    0.012600] DMAR: No ATSR found
[    0.012726] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.012786] HPET id 0 under DRHD base 0xfed91000
[    0.012844] HPET id 0 under DRHD base 0xfed91000
[    0.012903] HPET id 0 under DRHD base 0xfed91000
[    0.012961] HPET id 0 under DRHD base 0xfed91000
[    0.013020] HPET id 0 under DRHD base 0xfed91000
[    0.013079] HPET id 0 under DRHD base 0xfed91000
[    0.013138] HPET id 0 under DRHD base 0xfed91000
[    0.013196] HPET id 0 under DRHD base 0xfed91000
[    0.013450] Enabled Interrupt-remapping
[    0.013508] Enabling x2apic
[    0.013563] Enabled x2apic
[    0.014998] Switched APIC routing to cluster x2apic.
[    0.015446] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.055145] CPU0: Intel(R) Core(TM) i7-2720QM CPU @ 2.20GHz stepping 07
[    0.159664] Performance Events: PEBS fmt1+, SandyBridge events, Intel PMU driver.
[    0.159858] ... version:                3
[    0.159916] ... bit width:              48
[    0.159973] ... generic registers:      4
[    0.160030] ... value mask:             0000ffffffffffff
[    0.160089] ... max period:             000000007fffffff
[    0.160149] ... fixed-purpose events:   3
[    0.160207] ... event mask:             000000070000000f
[    0.160477] NMI watchdog enabled, takes one hw-pmu counter.
[    0.160643] Booting Node   0, Processors  #1
[    0.160729] smpboot cpu 1: start_ip = 8c000
[    0.271636] NMI watchdog enabled, takes one hw-pmu counter.
[    0.271803]  #2
[    0.271846] smpboot cpu 2: start_ip = 8c000
[    0.379573] NMI watchdog enabled, takes one hw-pmu counter.
[    0.379741]  #3
[    0.379784] smpboot cpu 3: start_ip = 8c000
[    0.487414] NMI watchdog enabled, takes one hw-pmu counter.
[    0.487578]  #4
[    0.487620] smpboot cpu 4: start_ip = 8c000
[    0.595267] NMI watchdog enabled, takes one hw-pmu counter.
[    0.595439]  #5
[    0.595482] smpboot cpu 5: start_ip = 8c000
[    0.703114] NMI watchdog enabled, takes one hw-pmu counter.
[    0.703282]  #6
[    0.703324] smpboot cpu 6: start_ip = 8c000
[    0.811048] NMI watchdog enabled, takes one hw-pmu counter.
[    0.811214]  #7
[    0.811256] smpboot cpu 7: start_ip = 8c000
[    0.918883] NMI watchdog enabled, takes one hw-pmu counter.
[    0.918972] Brought up 8 CPUs
[    0.919029] Total of 8 processors activated (35118.75 BogoMIPS).
[    0.924946] devtmpfs: initialized
[    0.928259] PM: Registering ACPI NVS region at bade7000 (2097152 bytes)
[    0.928440] Dell Latitude E6420 series board detected. Selecting PCI-method for reboots.
[    0.928660] print_constraints: dummy: 
[    0.928781] NET: Registered protocol family 16
[    0.928934] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.929011] ACPI: bus type pci registered
[    0.929154] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.929234] PCI: not using MMCONFIG
[    0.929291] PCI: Using configuration type 1 for base access
[    0.929358] dmi type 0xB1 record - unknown flag
[    0.930162] bio: create slab <bio-0> at 0
[    0.930332] ACPI: Added _OSI(Module Device)
[    0.930390] ACPI: Added _OSI(Processor Device)
[    0.930449] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.930509] ACPI: Added _OSI(Processor Aggregator Device)
[    0.932129] ACPI: EC: Look up EC in DSDT
[    0.958841] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    1.103127] ACPI: SSDT 00000000badd7718 0067C (v01  PmRef  Cpu0Cst 00003001 INTL 20090903)
[    1.103705] ACPI: Dynamic OEM Table Load:
[    1.103839] ACPI: SSDT           (null) 0067C (v01  PmRef  Cpu0Cst 00003001 INTL 20090903)
[    1.114983] ACPI: SSDT 00000000badd8a98 00303 (v01  PmRef    ApIst 00003000 INTL 20090903)
[    1.115613] ACPI: Dynamic OEM Table Load:
[    1.115749] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20090903)
[    1.126759] ACPI: SSDT 00000000badd6d98 00119 (v01  PmRef    ApCst 00003000 INTL 20090903)
[    1.127314] ACPI: Dynamic OEM Table Load:
[    1.127448] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20090903)
[    1.210583] ACPI: Interpreter enabled
[    1.210643] ACPI: (supports S0 S3 S4 S5)
[    1.210880] ACPI: Using IOAPIC for interrupt routing
[    1.210961] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    1.211612] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in ACPI motherboard resources
[    1.926554] ACPI: EC: GPE = 0x10, I/O: command/status = 0x934, data = 0x930
[    1.973727] ACPI: No dock devices found.
[    1.973786] HEST: Table not found.
[    1.973844] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.974410] \_SB_.PCI0:_OSC invalid UUID
[    1.974412] _OSC request data:1 8 1f 
[    1.974416] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    1.975362] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.975425] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.975488] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.975565] pci_root PNP0A08:00: host bridge window [mem 0xbfa00000-0xfeafffff]
[    1.975640] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff]
[    1.975726] pci 0000:00:00.0: [8086:0104] type 0 class 0x000600
[    1.975762] pci 0000:00:01.0: [8086:0101] type 1 class 0x000604
[    1.975788] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.975791] pci 0000:00:01.0: PME# disabled
[    1.975810] pci 0000:00:02.0: [8086:0126] type 0 class 0x000300
[    1.975821] pci 0000:00:02.0: reg 10: [mem 0xe5400000-0xe57fffff 64bit]
[    1.975828] pci 0000:00:02.0: reg 18: [mem 0xc0000000-0xcfffffff 64bit pref]
[    1.975833] pci 0000:00:02.0: reg 20: [io  0x5000-0x503f]
[    1.975885] pci 0000:00:16.0: [8086:1c3a] type 0 class 0x000780
[    1.975910] pci 0000:00:16.0: reg 10: [mem 0xe6eb0000-0xe6eb000f 64bit]
[    1.975975] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    1.975979] pci 0000:00:16.0: PME# disabled
[    1.976012] pci 0000:00:19.0: [8086:1502] type 0 class 0x000200
[    1.976031] pci 0000:00:19.0: reg 10: [mem 0xe6e00000-0xe6e1ffff]
[    1.976041] pci 0000:00:19.0: reg 14: [mem 0xe6e80000-0xe6e80fff]
[    1.976050] pci 0000:00:19.0: reg 18: [io  0x5080-0x509f]
[    1.976102] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    1.976106] pci 0000:00:19.0: PME# disabled
[    1.976133] pci 0000:00:1a.0: [8086:1c2d] type 0 class 0x000c03
[    1.976155] pci 0000:00:1a.0: reg 10: [mem 0xe6e70000-0xe6e703ff]
[    1.976231] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    1.976236] pci 0000:00:1a.0: PME# disabled
[    1.976262] pci 0000:00:1b.0: [8086:1c20] type 0 class 0x000403
[    1.976278] pci 0000:00:1b.0: reg 10: [mem 0xe6e60000-0xe6e63fff 64bit]
[    1.976337] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.976341] pci 0000:00:1b.0: PME# disabled
[    1.976368] pci 0000:00:1c.0: [8086:1c10] type 1 class 0x000604
[    1.976470] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.976475] pci 0000:00:1c.0: PME# disabled
[    1.976512] pci 0000:00:1c.1: [8086:1c12] type 1 class 0x000604
[    1.976613] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    1.976618] pci 0000:00:1c.1: PME# disabled
[    1.976655] pci 0000:00:1c.2: [8086:1c14] type 1 class 0x000604
[    1.976756] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    1.976762] pci 0000:00:1c.2: PME# disabled
[    1.976799] pci 0000:00:1c.3: [8086:1c16] type 1 class 0x000604
[    1.976899] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    1.976904] pci 0000:00:1c.3: PME# disabled
[    1.976943] pci 0000:00:1c.5: [8086:1c1a] type 1 class 0x000604
[    1.977044] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    1.977049] pci 0000:00:1c.5: PME# disabled
[    1.977090] pci 0000:00:1d.0: [8086:1c26] type 0 class 0x000c03
[    1.977112] pci 0000:00:1d.0: reg 10: [mem 0xe6e50000-0xe6e503ff]
[    1.977188] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    1.977193] pci 0000:00:1d.0: PME# disabled
[    1.977219] pci 0000:00:1f.0: [8086:1c4f] type 0 class 0x000601
[    1.977340] pci 0000:00:1f.2: [8086:282a] type 0 class 0x000104
[    1.977360] pci 0000:00:1f.2: reg 10: [io  0x50d0-0x50d7]
[    1.977369] pci 0000:00:1f.2: reg 14: [io  0x50c0-0x50c3]
[    1.977378] pci 0000:00:1f.2: reg 18: [io  0x50b0-0x50b7]
[    1.977387] pci 0000:00:1f.2: reg 1c: [io  0x50a0-0x50a3]
[    1.977395] pci 0000:00:1f.2: reg 20: [io  0x5060-0x507f]
[    1.977404] pci 0000:00:1f.2: reg 24: [mem 0xe6e40000-0xe6e407ff]
[    1.977439] pci 0000:00:1f.2: PME# supported from D3hot
[    1.977443] pci 0000:00:1f.2: PME# disabled
[    1.977462] pci 0000:00:1f.3: [8086:1c22] type 0 class 0x000c05
[    1.977478] pci 0000:00:1f.3: reg 10: [mem 0xe6e30000-0xe6e300ff 64bit]
[    1.977501] pci 0000:00:1f.3: reg 20: [io  0x5040-0x505f]
[    1.977565] pci 0000:01:00.0: [10de:1056] type 0 class 0x000300
[    1.977582] pci 0000:01:00.0: reg 10: [mem 0xe4000000-0xe4ffffff]
[    1.977596] pci 0000:01:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.977608] pci 0000:01:00.0: reg 1c: [mem 0xe0000000-0xe1ffffff 64bit pref]
[    1.977617] pci 0000:01:00.0: reg 24: [io  0x4000-0x407f]
[    1.977626] pci 0000:01:00.0: reg 30: [mem 0xe5000000-0xe507ffff pref]
[    1.977683] pci 0000:01:00.1: [10de:0e08] type 0 class 0x000403
[    1.977694] pci 0000:01:00.1: reg 10: [mem 0xe5080000-0xe5083fff]
[    1.977787] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.977849] pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
[    1.977852] pci 0000:00:01.0:   bridge window [mem 0xe4000000-0xe50fffff]
[    1.977856] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xe1ffffff 64bit pref]
[    1.977925] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.978129] pci 0000:03:00.0: [14e4:4727] type 0 class 0x000280
[    1.978158] pci 0000:03:00.0: reg 10: [mem 0xe6d00000-0xe6d03fff 64bit]
[    1.978277] pci 0000:03:00.0: supports D1 D2
[    1.978279] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    1.978285] pci 0000:03:00.0: PME# disabled
[    1.978335] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    1.978400] pci 0000:00:1c.1:   bridge window [mem 0xe6d00000-0xe6dfffff]
[    1.978453] pci 0000:00:1c.2: PCI bridge to [bus 04-09]
[    1.978515] pci 0000:00:1c.2:   bridge window [io  0x3000-0x3fff]
[    1.978520] pci 0000:00:1c.2:   bridge window [mem 0xe6200000-0xe6bfffff]
[    1.978527] pci 0000:00:1c.2:   bridge window [mem 0xe2b00000-0xe34fffff 64bit pref]
[    1.978574] pci 0000:00:1c.3: PCI bridge to [bus 0a-0a]
[    1.978637] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    1.978642] pci 0000:00:1c.3:   bridge window [mem 0xe5800000-0xe61fffff]
[    1.978649] pci 0000:00:1c.3:   bridge window [mem 0xe2100000-0xe2afffff 64bit pref]
[    1.980470] pci 0000:0b:00.0: [1217:8221] type 0 class 0x000805
[    1.980513] pci 0000:0b:00.0: reg 10: [mem 0xe6c20000-0xe6c201ff]
[    1.980776] pci 0000:0b:00.0: supports D1 D2
[    1.980778] pci 0000:0b:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.980788] pci 0000:0b:00.0: PME# disabled
[    1.980887] pci 0000:0b:00.1: [1217:8231] type 0 class 0x000180
[    1.980932] pci 0000:0b:00.1: reg 10: [mem 0xe6c10000-0xe6c10fff]
[    1.980992] pci 0000:0b:00.1: reg 18: [mem 0xe6c00000-0xe6c007ff]
[    1.981197] pci 0000:0b:00.1: supports D1 D2
[    1.981199] pci 0000:0b:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.981209] pci 0000:0b:00.1: PME# disabled
[    1.981319] pci 0000:00:1c.5: PCI bridge to [bus 0b-0b]
[    1.981384] pci 0000:00:1c.5:   bridge window [mem 0xe6c00000-0xe6cfffff]
[    1.981435] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.981749] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    1.981805] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    1.981859] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    1.981914] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    1.981972] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG0._PRT]
[    1.982040] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    1.982158] \_SB_.PCI0:_OSC invalid UUID
[    1.982160] _OSC request data:1 1f 1f 
[    1.982164]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    1.982270] \_SB_.PCI0:_OSC invalid UUID
[    1.982272] _OSC request data:1 0 1d 
[    1.982275]  pci0000:00: ACPI _OSC request failed (AE_ERROR), returned control mask: 0x1d
[    1.982352] ACPI _OSC control for PCIe not granted, disabling ASPM
[    1.988252] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    1.988879] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    1.989498] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    1.990127] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    1.990750] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 *5 6 7 10 12 14 15)
[    1.991323] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    1.991987] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 *3 4 5 6 7 10 12 14 15)
[    1.992559] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    1.993264] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.993350] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=none,locks=none
[    1.993428] vgaarb: loaded
[    1.993483] vgaarb: bridge control possible 0000:01:00.0
[    1.993543] vgaarb: bridge control possible 0000:00:02.0
[    1.993741] SCSI subsystem initialized
[    1.993834] libata version 3.00 loaded.
[    1.993872] PCI: Using ACPI for IRQ routing
[    1.995500] PCI: pci_cache_line_size set to 64 bytes
[    1.995597] reserve RAM buffer: 0000000000091400 - 000000000009ffff 
[    1.995600] reserve RAM buffer: 00000000baa2a000 - 00000000bbffffff 
[    1.995604] reserve RAM buffer: 00000000badb7000 - 00000000bbffffff 
[    1.995607] reserve RAM buffer: 00000000bb000000 - 00000000bbffffff 
[    1.995610] reserve RAM buffer: 000000013e000000 - 000000013fffffff 
[    1.995716] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    1.996122] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.998200] Switching to clocksource hpet
[    2.001265] pnp: PnP ACPI init
[    2.001334] ACPI: bus type pnp registered
[    2.001553] Switched to NOHz mode on CPU #0
[    2.001615] Switched to NOHz mode on CPU #5
[    2.001635] Switched to NOHz mode on CPU #7
[    2.001643] Switched to NOHz mode on CPU #1
[    2.001647] Switched to NOHz mode on CPU #4
[    2.001668] Switched to NOHz mode on CPU #3
[    2.001674] Switched to NOHz mode on CPU #6
[    2.001705] Switched to NOHz mode on CPU #2
[    2.001927] pnp 00:00: [bus 00-3e]
[    2.001930] pnp 00:00: [io  0x0000-0x0cf7 window]
[    2.001932] pnp 00:00: [io  0x0cf8-0x0cff]
[    2.001933] pnp 00:00: [io  0x0d00-0xffff window]
[    2.001936] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    2.001938] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    2.001940] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    2.001942] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    2.001943] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    2.001945] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    2.001947] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    2.001948] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    2.001950] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    2.001952] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    2.001954] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    2.001955] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    2.001957] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    2.001959] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    2.001960] pnp 00:00: [mem 0xbfa00000-0xfeafffff window]
[    2.001962] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    2.002012] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    2.002028] pnp 00:01: [io  0x0000-0x001f]
[    2.002030] pnp 00:01: [io  0x0081-0x0091]
[    2.002031] pnp 00:01: [io  0x0093-0x009f]
[    2.002032] pnp 00:01: [io  0x00c0-0x00df]
[    2.002034] pnp 00:01: [dma 4]
[    2.002058] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    2.002067] pnp 00:02: [mem 0xff000000-0xffffffff]
[    2.002090] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    2.002204] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    2.002247] system 00:03: [mem 0xfed00000-0xfed003ff] has been reserved
[    2.002311] system 00:03: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    2.002323] pnp 00:04: [io  0x00f0]
[    2.002333] pnp 00:04: [irq 13]
[    2.002364] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    2.002376] pnp 00:05: [io  0x002e-0x002f]
[    2.002377] pnp 00:05: [io  0x004e-0x004f]
[    2.002379] pnp 00:05: [io  0x0061]
[    2.002380] pnp 00:05: [io  0x0063]
[    2.002383] pnp 00:05: [io  0x0065]
[    2.002385] pnp 00:05: [io  0x0067]
[    2.002386] pnp 00:05: [io  0x0070]
[    2.002388] pnp 00:05: [io  0x0080]
[    2.002389] pnp 00:05: [io  0x0092]
[    2.002391] pnp 00:05: [io  0x00b2-0x00b3]
[    2.002393] pnp 00:05: [io  0x0680-0x069f]
[    2.002394] pnp 00:05: [io  0x1000-0x100f]
[    2.002396] pnp 00:05: [io  0xffff]
[    2.002398] pnp 00:05: [io  0xffff]
[    2.002399] pnp 00:05: [io  0x0400-0x047f]
[    2.002401] pnp 00:05: [io  0x0500-0x057f]
[    2.002403] pnp 00:05: [io  0x164e-0x164f]
[    2.002448] system 00:05: [io  0x0680-0x069f] has been reserved
[    2.002511] system 00:05: [io  0x1000-0x100f] has been reserved
[    2.002572] system 00:05: [io  0xffff] has been reserved
[    2.002634] system 00:05: [io  0xffff] has been reserved
[    2.002695] system 00:05: [io  0x0400-0x047f] has been reserved
[    2.002757] system 00:05: [io  0x0500-0x057f] has been reserved
[    2.002820] system 00:05: [io  0x164e-0x164f] has been reserved
[    2.002882] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.002892] pnp 00:06: [io  0x0070-0x0077]
[    2.002899] pnp 00:06: [irq 8]
[    2.002923] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.002935] pnp 00:07: [io  0x0060]
[    2.002937] pnp 00:07: [io  0x0064]
[    2.002943] pnp 00:07: [irq 1]
[    2.002967] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.006596] pnp 00:08: Plug and Play ACPI device, IDs PNP0401 (disabled)
[    2.006615] pnp 00:09: [irq 12]
[    2.006642] pnp 00:09: Plug and Play ACPI device, IDs DLL0493 PNP0f13 (active)
[    2.006836] pnp 00:0a: [mem 0xfed1c000-0xfed1ffff]
[    2.006838] pnp 00:0a: [mem 0xfed10000-0xfed17fff]
[    2.006840] pnp 00:0a: [mem 0xfed18000-0xfed18fff]
[    2.006842] pnp 00:0a: [mem 0xfed19000-0xfed19fff]
[    2.006844] pnp 00:0a: [mem 0xf8000000-0xfbffffff]
[    2.006846] pnp 00:0a: [mem 0xfed20000-0xfed3ffff]
[    2.006848] pnp 00:0a: [mem 0xfed90000-0xfed93fff]
[    2.006849] pnp 00:0a: [mem 0xfed45000-0xfed8ffff]
[    2.006851] pnp 00:0a: [mem 0xff000000-0xffffffff]
[    2.006853] pnp 00:0a: [mem 0xfee00000-0xfeefffff]
[    2.006855] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
[    2.006857] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
[    2.006915] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    2.006978] system 00:0a: [mem 0xfed10000-0xfed17fff] has been reserved
[    2.007041] system 00:0a: [mem 0xfed18000-0xfed18fff] has been reserved
[    2.007104] system 00:0a: [mem 0xfed19000-0xfed19fff] has been reserved
[    2.007168] system 00:0a: [mem 0xf8000000-0xfbffffff] has been reserved
[    2.007231] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
[    2.007295] system 00:0a: [mem 0xfed90000-0xfed93fff] has been reserved
[    2.007358] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
[    2.007422] system 00:0a: [mem 0xff000000-0xffffffff] could not be reserved
[    2.007485] system 00:0a: [mem 0xfee00000-0xfeefffff] has been reserved
[    2.007548] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.008142] pnp 00:0b: [irq 23]
[    2.008181] pnp 00:0b: Plug and Play ACPI device, IDs SMO8800 (active)
[    2.019076] pnp 00:0c: [mem 0x20000000-0x201fffff]
[    2.019078] pnp 00:0c: [mem 0x40000000-0x401fffff]
[    2.019148] system 00:0c: [mem 0x20000000-0x201fffff] has been reserved
[    2.019212] system 00:0c: [mem 0x40000000-0x401fffff] has been reserved
[    2.019275] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    2.019284] pnp: PnP ACPI: found 13 devices
[    2.019343] ACPI: ACPI bus type pnp unregistered
[    2.026223] PCI: max bus depth: 1 pci_try_num: 2
[    2.026269] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    2.026330] pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
[    2.026393] pci 0000:00:01.0:   bridge window [mem 0xe4000000-0xe50fffff]
[    2.026458] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xe1ffffff 64bit pref]
[    2.026536] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    2.026607] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    2.026671] pci 0000:00:1c.1:   bridge window [mem 0xe6d00000-0xe6dfffff]
[    2.026740] pci 0000:00:1c.2: PCI bridge to [bus 04-09]
[    2.026802] pci 0000:00:1c.2:   bridge window [io  0x3000-0x3fff]
[    2.026867] pci 0000:00:1c.2:   bridge window [mem 0xe6200000-0xe6bfffff]
[    2.026933] pci 0000:00:1c.2:   bridge window [mem 0xe2b00000-0xe34fffff 64bit pref]
[    2.027013] pci 0000:00:1c.3: PCI bridge to [bus 0a-0a]
[    2.027075] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    2.027140] pci 0000:00:1c.3:   bridge window [mem 0xe5800000-0xe61fffff]
[    2.027205] pci 0000:00:1c.3:   bridge window [mem 0xe2100000-0xe2afffff 64bit pref]
[    2.027287] pci 0000:00:1c.5: PCI bridge to [bus 0b-0b]
[    2.027350] pci 0000:00:1c.5:   bridge window [mem 0xe6c00000-0xe6cfffff]
[    2.027431] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.027495] pci 0000:00:01.0: setting latency timer to 64
[    2.027502] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.027568] pci 0000:00:1c.0: setting latency timer to 64
[    2.027580] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.027646] pci 0000:00:1c.1: setting latency timer to 64
[    2.027657] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.027722] pci 0000:00:1c.2: setting latency timer to 64
[    2.027734] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    2.027800] pci 0000:00:1c.3: setting latency timer to 64
[    2.027807] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.027872] pci 0000:00:1c.5: setting latency timer to 64
[    2.027876] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.027878] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.027880] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.027882] pci_bus 0000:00: resource 7 [mem 0xbfa00000-0xfeafffff]
[    2.027884] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
[    2.027886] pci_bus 0000:01: resource 0 [io  0x4000-0x4fff]
[    2.027888] pci_bus 0000:01: resource 1 [mem 0xe4000000-0xe50fffff]
[    2.027890] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xe1ffffff 64bit pref]
[    2.027892] pci_bus 0000:03: resource 1 [mem 0xe6d00000-0xe6dfffff]
[    2.027894] pci_bus 0000:04: resource 0 [io  0x3000-0x3fff]
[    2.027896] pci_bus 0000:04: resource 1 [mem 0xe6200000-0xe6bfffff]
[    2.027898] pci_bus 0000:04: resource 2 [mem 0xe2b00000-0xe34fffff 64bit pref]
[    2.027900] pci_bus 0000:0a: resource 0 [io  0x2000-0x2fff]
[    2.027902] pci_bus 0000:0a: resource 1 [mem 0xe5800000-0xe61fffff]
[    2.027904] pci_bus 0000:0a: resource 2 [mem 0xe2100000-0xe2afffff 64bit pref]
[    2.027906] pci_bus 0000:0b: resource 1 [mem 0xe6c00000-0xe6cfffff]
[    2.028003] NET: Registered protocol family 2
[    2.029605] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    2.030743] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    2.032167] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    2.032370] TCP: Hash tables configured (established 524288 bind 65536)
[    2.032434] TCP reno registered
[    2.032498] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    2.032580] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    2.032800] NET: Registered protocol family 1
[    2.032872] pci 0000:00:02.0: Boot video device
[    2.032996] PCI: CLS 64 bytes, default 64
[    2.033037] Unpacking initramfs...
[    2.689762] Freeing initrd memory: 31432k freed
[    2.693707] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.693774] Placing 64MB software IO TLB between ffff8800b6a2a000 - ffff8800baa2a000
[    2.693850] software IO TLB at phys 0xb6a2a000 - 0xbaa2a000
[    2.693928] Simple Boot Flag at 0xf3 set to 0x1
[    2.694790] audit: initializing netlink socket (disabled)
[    2.694859] type=2000 audit(1316030005.476:1): initialized
[    2.715136] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.723711] VFS: Disk quotas dquot_6.5.2
[    2.723812] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.724258] msgmni has been set to 7692
[    2.724495] alg: No test for stdrng (krng)
[    2.724590] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    2.724667] io scheduler noop registered
[    2.724724] io scheduler deadline registered
[    2.724810] io scheduler cfq registered (default)
[    2.724960] pcieport 0000:00:01.0: setting latency timer to 64
[    2.724991] pcieport 0000:00:01.0: irq 42 for MSI/MSI-X
[    2.725343] ERST: Table is not found!
[    2.725478] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.857712] Linux agpgart interface v0.103
[    2.857859] agpgart-intel 0000:00:00.0: Intel Sandybridge Chipset
[    2.858012] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    2.859315] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
[    2.859502] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    2.859704] ahci 0000:00:1f.2: version 3.0
[    2.859716] ahci 0000:00:1f.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.859827] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    2.859856] ahci: SSS flag set, parallel bus scan disabled
[    2.873273] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3b impl RAID mode
[    2.873364] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ems sxs apst 
[    2.873446] ahci 0000:00:1f.2: setting latency timer to 64
[    2.905755] scsi0 : ahci
[    2.905922] scsi1 : ahci
[    2.906049] scsi2 : ahci
[    2.906176] scsi3 : ahci
[    2.906301] scsi4 : ahci
[    2.906426] scsi5 : ahci
[    2.917329] ata1: SATA max UDMA/133 abar m2048@0xe6e40000 port 0xe6e40100 irq 43
[    2.917407] ata2: SATA max UDMA/133 abar m2048@0xe6e40000 port 0xe6e40180 irq 43
[    2.917482] ata3: DUMMY
[    2.917538] ata4: SATA max UDMA/133 abar m2048@0xe6e40000 port 0xe6e40280 irq 43
[    2.917614] ata5: SATA max UDMA/133 abar m2048@0xe6e40000 port 0xe6e40300 irq 43
[    2.917692] ata6: SATA max UDMA/133 abar m2048@0xe6e40000 port 0xe6e40380 irq 43
[    2.917863] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    2.918189] i8042: Warning: Keylock active
[    2.919477] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.919541] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.919725] mousedev: PS/2 mouse device common for all mice
[    2.919825] rtc_cmos 00:06: RTC can wake from S4
[    2.920022] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    2.920122] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    2.920192] cpuidle: using governor ladder
[    2.920251] cpuidle: using governor menu
[    2.920486] TCP cubic registered
[    2.920655] NET: Registered protocol family 10
[    2.920774] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    2.921373] Mobile IPv6
[    2.921430] NET: Registered protocol family 17
[    2.921490] Registering the dns_resolver key type
[    2.921662] PM: Hibernation image not present or could not be loaded.
[    2.921672] registered taskstats version 1
[    2.926477] rtc_cmos 00:06: setting system clock to 2011-09-14 19:53:26 UTC (1316030006)
[    2.926614] Initializing network drop monitor service
[    3.236834] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.241327] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    3.242490] ata1.00: ATA-8: SAMSUNG SSD PM810 2.5" 256GB, AXM08D1Q, max UDMA/133
[    3.242598] ata1.00: 500118192 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    3.249072] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    3.251642] ata1.00: configured for UDMA/133
[    3.256968] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG SSD PM81 AXM0 PQ: 0 ANSI: 5
[    3.257235] sd 0:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
[    3.257431] sd 0:0:0:0: [sda] Write Protect is off
[    3.257492] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.257526] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.259500]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
[    3.260182] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.576459] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.580131] ata2.00: ATAPI: HL-DT-ST DVD+/-RW GU40N, A103, max UDMA/133
[    3.584052] ata2.00: configured for UDMA/133
[    3.587214] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GU40N    A103 PQ: 0 ANSI: 5
[    3.692330] Refined TSC clocksource calibration: 2195.013 MHz.
[    3.692415] Switching to clocksource tsc
[    3.904090] ata4: SATA link down (SStatus 0 SControl 300)
[    4.223738] ata5: SATA link down (SStatus 0 SControl 300)
[    4.543386] ata6: SATA link down (SStatus 0 SControl 300)
[    4.544623] Freeing unused kernel memory: 576k freed
[    4.544760] Write protecting the kernel read-only data: 6144k
[    4.545262] Freeing unused kernel memory: 96k freed
[    4.547116] Freeing unused kernel memory: 492k freed
[    4.612742] udevd[97]: starting version 172
[    4.626400] e1000e: Intel(R) PRO/1000 Network Driver - 1.4.4-k
[    4.626470] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    4.626585] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.626663] e1000e 0000:00:19.0: setting latency timer to 64
[    4.626801] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    4.627813] sdhci: Secure Digital Host Controller Interface driver
[    4.627880] sdhci: Copyright(c) Pierre Ossman
[    4.628326] sdhci-pci 0000:0b:00.0: SDHCI controller found [1217:8221] (rev 5)
[    4.643197] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    4.643296] cdrom: Uniform CD-ROM driver Revision: 3.20
[    4.643491] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    4.645992] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.646121] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    4.663338] sdhci-pci 0000:0b:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    4.663600] sdhci-pci 0000:0b:00.0: Invalid iomem size. You may experience problems.
[    4.663714] sdhci-pci 0000:0b:00.0: setting latency timer to 64
[    4.663738] mmc0: no vmmc regulator found
[    4.663830] Registered led device: mmc0::
[    4.663903] mmc0: SDHCI controller on PCI [0000:0b:00.0] using DMA
[    4.763243] thermal LNXTHERM:00: registered as thermal_zone0
[    4.763307] ACPI: Thermal Zone [THM] (25 C)
[    4.917881] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 5c:26:0a:6b:0b:75
[    4.917959] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    4.918057] e1000e 0000:00:19.0: eth0: MAC: 10, PHY: 11, PBA No: 3041FF-0FF
[    5.605080] PM: Marking nosave pages: 0000000000091000 - 0000000000100000
[    5.605085] PM: Marking nosave pages: 0000000020000000 - 0000000020200000
[    5.605095] PM: Marking nosave pages: 0000000040000000 - 0000000040200000
[    5.605105] PM: Marking nosave pages: 00000000baa2a000 - 00000000baa6e000
[    5.605108] PM: Marking nosave pages: 00000000badb7000 - 00000000bafff000
[    5.605119] PM: Marking nosave pages: 00000000bb000000 - 0000000100000000
[    5.606772] PM: Basic memory bitmaps created
[    5.629062] PM: Basic memory bitmaps freed
[    5.638384] EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: (null)
[    6.156111] udevd[337]: starting version 172
[    6.242907] ACPI: acpi_idle registered with cpuidle
[    6.243618] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    6.244447] ACPI: Lid Switch [LID]
[    6.244583] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[    6.244667] ACPI: Power Button [PBTN]
[    6.244791] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
[    6.244868] ACPI: Sleep Button [SBTN]
[    6.246272] Monitor-Mwait will be used to enter C-1 state
[    6.246315] Monitor-Mwait will be used to enter C-2 state
[    6.246349] Monitor-Mwait will be used to enter C-3 state
[    6.262656] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[    6.262733] ACPI: Power Button [PWRF]
[    6.267394] ACPI: Battery Slot [BAT0] (battery present)
[    6.269004] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    6.272620] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    6.385931] ACPI: Battery Slot [BAT1] (battery absent)
[    6.521949] ACPI: Battery Slot [BAT2] (battery absent)
[    6.522292] wmi: Mapper loaded
[    6.523810] ACPI: AC Adapter [AC] (on-line)
[    6.529524] parport_pc 00:08: [io  0x0378-0x037b]
[    6.530312] parport_pc 00:08: [irq 5]
[    6.531317] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.546497] cfg80211: Calling CRDA to update world regulatory domain
[    6.553685] [drm] Initialized drm 1.1.0 20060810
[    6.555288] brcmutil: module is from the staging directory, the quality is unknown, you have been warned.
[    6.574214] input: Dell WMI hotkeys as /devices/virtual/input/input6
[    6.605195] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.605456] i915 0000:00:02.0: setting latency timer to 64
[    6.615393] brcmsmac: module is from the staging directory, the quality is unknown, you have been warned.
[    6.617692] brcmsmac 0000:03:00.0: bus 3 slot 0 func 0 irq 10
[    6.650592] i915 0000:00:02.0: irq 45 for MSI/MSI-X
[    6.650599] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    6.650664] [drm] Driver supports precise vblank timestamp query.
[    6.669303] brcmsmac 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    6.669381] brcmsmac 0000:03:00.0: setting latency timer to 64
[    6.693683] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[    6.717249] [drm:intel_dsm_platform_mux_info] *ERROR* MUX INFO call failed
[    6.717342] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
[    6.717423] vgaarb: transferring owner from PCI:0000:00:02.0 to PCI:0000:01:00.0
[    7.400134] fbcon: inteldrmfb (fb0) is primary device
[    7.401630] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[    7.716347] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[    7.934809] Console: switching to colour frame buffer device 160x56
[    7.939349] fb0: inteldrmfb frame buffer device
[    7.939351] drm: registered panic notifier
[    8.471083] ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20110623/evregion-478)
[    8.471157] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.ECDV.ECR1] (Node ffff880136e7afd8), AE_TIME (20110623/psparse-536)
[    8.471251] ACPI Error: Method parse/execution failed [\ECRB] (Node ffff880136e7ae70), AE_TIME (20110623/psparse-536)
[    8.471330] ACPI Error: Method parse/execution failed [\ECGB] (Node ffff880136e7aba0), AE_TIME (20110623/psparse-536)
[    8.471409] ACPI Error: Method parse/execution failed [\_SB_.PCI0.VID_.LCD_._ADR] (Node ffff880136e7fda8), AE_TIME (20110623/psparse-536)
[    9.354537] parport_pc 00:08: activated
[    9.354569] parport_pc 00:08: reported by Plug and Play ACPI
[    9.853591] ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20110623/evregion-478)
[    9.853683] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.ECDV.ECR1] (Node ffff880136e7afd8), AE_TIME (20110623/psparse-536)
[    9.853776] ACPI Error: Method parse/execution failed [\ECRB] (Node ffff880136e7ae70), AE_TIME (20110623/psparse-536)
[    9.853855] ACPI Error: Method parse/execution failed [\ECGB] (Node ffff880136e7aba0), AE_TIME (20110623/psparse-536)
[    9.853934] ACPI Error: Method parse/execution failed [\_SB_.PCI0.PEG0.VID_._DOD] (Node ffff880136e983d0), AE_TIME (20110623/psparse-536)
[    9.854132] ACPI Exception: AE_TIME, Evaluating _DOD (20110623/video-1147)
[    9.854278] parport_pc 00:08: disabled
[   10.353006] ACPI: EC: input buffer is not empty, aborting transaction
[   10.353053] ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20110623/evregion-478)
[   10.353122] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.ECDV.ECR1] (Node ffff880136e7afd8), AE_TIME (20110623/psparse-536)
[   10.353216] ACPI Error: Method parse/execution failed [\ECRB] (Node ffff880136e7ae70), AE_TIME (20110623/psparse-536)
[   10.353296] ACPI Error: Method parse/execution failed [\ECGB] (Node ffff880136e7aba0), AE_TIME (20110623/psparse-536)
[   10.353374] ACPI Error: Method parse/execution failed [\_SB_.PCI0.PEG0.VID_.LCD_._ADR] (Node ffff880136e982b8), AE_TIME (20110623/psparse-536)
[   10.353470] ACPI: Can't attach device
[   10.895371] input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input7
[   10.920537] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:13/LNXVIDEO:00/input/input8
[   10.920709] ACPI: Video Device [VID] (multi-head: yes  rom: yes  post: no)
[   11.152854] acpi device:3f: registered as cooling_device8
[   11.229342] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input9
[   11.229547] ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
[   11.231682] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   11.233895] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   11.236315] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[   11.236340] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[   11.283286] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input10
[   11.292874] input: HDA Intel PCH Mic at Sep Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   11.295164] input: HDA Intel PCH Mic at Ext Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   11.297436] input: HDA Intel PCH Line Out at Sep Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[   11.299669] input: HDA Intel PCH HP Out at Ext Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[   11.302717] snd_hda_intel 0000:01:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   11.304871] hda_intel: Disabling MSI
[   11.307060] snd_hda_intel 0000:01:00.1: setting latency timer to 64
[   11.615640] HDMI status: Codec=0 Pin=5 Presence_Detect=0 ELD_Valid=0
[   11.679574] HDMI status: Codec=0 Pin=6 Presence_Detect=0 ELD_Valid=0
[   11.747515] HDMI status: Codec=0 Pin=7 Presence_Detect=0 ELD_Valid=0
[   11.835775] input: HDA NVidia HDMI/DP as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input15
[   11.838034] input: HDA NVidia HDMI/DP as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input16
[   11.840301] input: HDA NVidia HDMI/DP as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input17
[   12.383436] Adding 7811068k swap on /dev/sda5.  Priority:-1 extents:1 across:7811068k SS
[   12.397341] EXT4-fs (sda6): re-mounted. Opts: (null)
[   12.497299] EXT4-fs (sda6): re-mounted. Opts: errors=remount-ro,discard
[   12.528015] loop: module loaded
[   12.599402] usbcore: registered new interface driver usbfs
[   12.601688] usbcore: registered new interface driver hub
[   12.603779] usbcore: registered new device driver usb
[   12.609790] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   12.611680] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   12.613521] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[   12.613525] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[   12.615318] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[   12.617123] ehci_hcd 0000:00:1a.0: debug port 2
[   12.622771] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[   12.622799] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xe6e70000
[   12.638513] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[   12.640279] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   12.641981] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   12.643666] usb usb1: Product: EHCI Host Controller
[   12.645313] usb usb1: Manufacturer: Linux 3.1.0-rc6 ehci_hcd
[   12.646968] usb usb1: SerialNumber: 0000:00:1a.0
[   12.648711] hub 1-0:1.0: USB hub found
[   12.650300] hub 1-0:1.0: 2 ports detected
[   12.651945] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   12.653574] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[   12.653578] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[   12.655158] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[   12.656741] ehci_hcd 0000:00:1d.0: debug port 2
[   12.662163] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[   12.662174] ehci_hcd 0000:00:1d.0: irq 17, io mem 0xe6e50000
[   12.678451] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[   12.679992] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   12.681474] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   12.682948] usb usb2: Product: EHCI Host Controller
[   12.684401] usb usb2: Manufacturer: Linux 3.1.0-rc6 ehci_hcd
[   12.685876] usb usb2: SerialNumber: 0000:00:1d.0
[   12.687497] hub 2-0:1.0: USB hub found
[   12.688972] hub 2-0:1.0: 2 ports detected
[   12.692961] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   12.705223] coretemp coretemp.0: TjMax is 100 C.
[   12.706802] coretemp coretemp.0: TjMax is 100 C.
[   12.708322] coretemp coretemp.0: TjMax is 100 C.
[   12.709786] coretemp coretemp.0: TjMax is 100 C.
[   12.962171] usb 1-1: new high speed USB device number 2 using ehci_hcd
[   13.004500] EXT4-fs (sda9): mounted filesystem with ordered data mode. Opts: discard
[   13.019691] FAT-fs (sda1): utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
[   13.062164] fuse init (API version 7.17)
[   13.094525] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[   13.095882] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   13.097380] hub 1-1:1.0: USB hub found
[   13.098861] hub 1-1:1.0: 6 ports detected
[   13.209860] usb 2-1: new high speed USB device number 2 using ehci_hcd
[   13.342071] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[   13.343795] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   13.344120] hub 2-1:1.0: USB hub found
[   13.344189] hub 2-1:1.0: 8 ports detected
[   13.413742] usb 1-1.4: new full speed USB device number 3 using ehci_hcd
[   13.509633] usb 1-1.4: New USB device found, idVendor=413c, idProduct=8187
[   13.512951] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   13.514422] usb 1-1.4: Product: DW375 Bluetooth Module
[   13.514424] usb 1-1.4: Manufacturer: Dell Computer Corp
[   13.514425] usb 1-1.4: SerialNumber: D0DF9A3D158D
[   13.613578] usb 2-1.1: new full speed USB device number 3 using ehci_hcd
[   13.706422] usb 2-1.1: New USB device found, idVendor=04b4, idProduct=2050
[   13.708089] usb 2-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   13.709975] hub 2-1.1:1.0: USB hub found
[   13.712034] hub 2-1.1:1.0: 3 ports detected
[   13.785362] usb 2-1.2: new high speed USB device number 4 using ehci_hcd
[   13.878866] usb 2-1.2: New USB device found, idVendor=07ff, idProduct=00ff
[   13.882227] usb 2-1.2: New USB device strings: Mfr=10, Product=11, SerialNumber=5
[   13.883907] usb 2-1.2: Product: USB20
[   13.885604] usb 2-1.2: Manufacturer: USBID
[   13.887240] usb 2-1.2: SerialNumber: 34A1677A2150
[   13.961158] usb 2-1.6: new high speed USB device number 5 using ehci_hcd
[   14.062289] usb 2-1.6: New USB device found, idVendor=413c, idProduct=818d
[   14.063882] usb 2-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   14.065491] usb 2-1.6: Product: DW5550
[   14.067077] usb 2-1.6: Manufacturer: Dell
[   14.068737] usb 2-1.6: SerialNumber: 5B698558903EF940
[   14.176932] usb 2-1.8: new full speed USB device number 6 using ehci_hcd
[   14.300042] usb 2-1.8: New USB device found, idVendor=0a5c, idProduct=5800
[   14.300046] usb 2-1.8: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   14.300048] usb 2-1.8: Product: 5880
[   14.300049] usb 2-1.8: Manufacturer: Broadcom Corp
[   14.300051] usb 2-1.8: SerialNumber: 0123456789ABCD
[   14.300160] usb 2-1.8: config 0 descriptor??
[   14.380861] usb 2-1.1.1: new full speed USB device number 7 using ehci_hcd
[   14.478249] usb 2-1.1.1: New USB device found, idVendor=058f, idProduct=9254
[   14.480662] usb 2-1.1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   14.483051] usb 2-1.1.1: Product: Generic USB Hub
[   14.485399] usb 2-1.1.1: Manufacturer: ALCOR
[   14.487971] hub 2-1.1.1:1.0: USB hub found
[   14.490434] hub 2-1.1.1:1.0: 4 ports detected
[   14.564598] usb 2-1.1.3: new full speed USB device number 8 using ehci_hcd
[   14.588358] speakup: module is from the staging directory, the quality is unknown, you have been warned.
[   14.594079] input: Speakup as /devices/virtual/input/input18
[   14.596740] initialized device: /dev/synth, node (MAJOR 10, MINOR 25)
[   14.599317] speakup 3.1.6: initialized
[   14.601849] synth name on entry is: (null)
[   14.605135] speakup_soft: module is from the staging directory, the quality is unknown, you have been warned.
[   14.610298] synth probe
[   14.612798] initialized device: /dev/softsynth, node (MAJOR 10, MINOR 26)
[   14.658364] usb 2-1.1.3: New USB device found, idVendor=0458, idProduct=004c
[   14.658369] usb 2-1.1.3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[   14.658372] usb 2-1.1.3: Product: ABBHOME
[   14.676565] usbcore: registered new interface driver uas
[   14.682939] Initializing USB Mass Storage driver...
[   14.685746] cdc_wdm 2-1.6:1.5: cdc-wdm-176: USB WDM device
[   14.685859] scsi6 : usb-storage 2-1.2:1.0
[   14.686057] usbcore: registered new interface driver usb-storage
[   14.686059] USB Mass Storage support registered.
[   14.693326] cdc_wdm 2-1.6:1.8: cdc-wdm-175: USB WDM device
[   14.693350] usbcore: registered new interface driver cdc_wdm
[   14.704746] cdc_acm 2-1.6:1.1: ttyACM0: USB ACM device
[   14.705392] cdc_acm 2-1.6:1.3: ttyACM1: USB ACM device
[   14.712870] cdc_acm 2-1.6:1.9: ttyACM2: USB ACM device
[   14.715756] cdc_ncm: 04-Aug-2011
[   14.720802] usbcore: registered new interface driver cdc_acm
[   14.720806] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[   14.722149] input: ABBHOME as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1.3/2-1.1.3:1.0/input/input19
[   14.722722] generic-usb 0003:0458:004C.0001: input,hidraw0: USB HID v1.10 Mouse [ABBHOME] on usb-0000:00:1d.0-1.1.3/input0
[   14.722742] usbcore: registered new interface driver usbhid
[   14.722744] usbhid: USB HID core driver
[   14.740431] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   14.745643] usb 2-1.6: MAC-Address: 0x02:0x80:0x37:0xec:0x02:0x00
[   14.768369] usb 2-1.1.1.1: new full speed USB device number 9 using ehci_hcd
[   14.796237] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   14.796609] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   14.799769] cdc_ncm 2-1.6:1.6: usb0: register 'cdc_ncm' at usb-0000:00:1d.0-1.6, CDC NCM, 02:80:37:ec:02:00
[   14.805384] usbcore: registered new interface driver cdc_ncm
[   14.861709] usb 2-1.1.1.1: New USB device found, idVendor=04fc, idProduct=0561
[   14.864506] usb 2-1.1.1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   14.867240] usb 2-1.1.1.1: Product: Generic Digital camera
[   14.867242] usb 2-1.1.1.1: Manufacturer: Sunplus Technology Co., Ltd.
[   14.900355]  updated 224 of 224 character descriptions
[   14.903100]  updated 96 of 180 character class entries
[   14.936255] usb 2-1.1.1.2: new low speed USB device number 10 using ehci_hcd
[   15.038383] usb 2-1.1.1.2: New USB device found, idVendor=046d, idProduct=c050
[   15.041148] usb 2-1.1.1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   15.043907] usb 2-1.1.1.2: Product: USB-PS/2 Optical Mouse
[   15.043910] usb 2-1.1.1.2: Manufacturer: Logitech
[   15.048125] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1.1/2-1.1.1.2/2-1.1.1.2:1.0/input/input20
[   15.048357] generic-usb 0003:046D:C050.0002: input,hidraw1: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1.1.1.2/input0
[   15.068162] Linux media interface: v0.10
[   15.075659] Linux video capture interface: v2.00
[   15.080852] gspca: v2.13.0 registered
[   15.577290] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input21
[   15.599671] input: spca561 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1.1/2-1.1.1.1/input/input22
[   15.607224] usbcore: registered new interface driver spca561
[   15.687506] scsi 6:0:0:0: Direct-Access     Hitachi  HDT721016SLA380  A3AA PQ: 0 ANSI: 2 CCS
[   15.688298] sd 6:0:0:0: Attached scsi generic sg2 type 0
[   15.688863] sd 6:0:0:0: [sdb] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[   15.689610] sd 6:0:0:0: [sdb] Write Protect is off
[   15.689615] sd 6:0:0:0: [sdb] Mode Sense: 00 38 00 00
[   15.690362] sd 6:0:0:0: [sdb] Asking for cache data failed
[   15.690365] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[   15.692609] sd 6:0:0:0: [sdb] Asking for cache data failed
[   15.692613] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[   15.694106]  sdb: unknown partition table
[   15.698353] sd 6:0:0:0: [sdb] Asking for cache data failed
[   15.698357] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[   15.698361] sd 6:0:0:0: [sdb] Attached SCSI disk
[   16.369249] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
[   16.371061] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   16.373403] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   26.946714] ip_tables: (C) 2000-2006 Netfilter Core Team
[   26.972188] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   68.347827] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[   68.348346] [drm] Changing LVDS panel from (+hsync, -vsync) to (-hsync, -vsync)
[   68.659501] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[   69.698380] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[   69.698899] [drm] Changing LVDS panel from (-hsync, -vsync) to (+hsync, -vsync)
[   70.010069] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH

--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="Xorg.0.log.good"
Content-Transfer-Encoding: 8bit

[    58.009] 
X.Org X Server 1.10.4
Release Date: 2011-08-19
[    58.009] X Protocol Version 11, Revision 0
[    58.009] Build Operating System: Linux 3.0.0-1-amd64 x86_64 Debian
[    58.009] Current Operating System: Linux type 3.0.4 #2 SMP Tue Aug 30 11:04:23 CEST 2011 x86_64
[    58.009] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.0.4 root=UUID=38e6e493-2f5f-4a98-b1d6-a9434f0683cc ro
[    58.009] Build Date: 24 August 2011  08:53:55AM
[    58.009] xorg-server 2:1.10.4-1 (Cyril Brulebois <kibi@debian.org>) 
[    58.009] Current version of pixman: 0.22.2
[    58.009] 	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
[    58.009] Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[    58.009] (==) Log file: "/var/log/Xorg.0.log", Time: Wed Sep 14 19:58:29 2011
[    58.029] (==) Using config file: "/etc/X11/xorg.conf"
[    58.029] (==) Using system config directory "/usr/share/X11/xorg.conf.d"
[    58.035] (==) No Layout section.  Using the first Screen section.
[    58.035] (==) No screen section available. Using defaults.
[    58.035] (**) |-->Screen "Default Screen Section" (0)
[    58.035] (**) |   |-->Monitor "<default monitor>"
[    58.035] (==) No device specified for screen "Default Screen Section".
	Using the first device section listed.
[    58.035] (**) |   |-->Device "Configured Video Device"
[    58.035] (==) No monitor specified for screen "Default Screen Section".
	Using a default monitor configuration.
[    58.035] (==) Automatically adding devices
[    58.035] (==) Automatically enabling devices
[    58.041] (==) FontPath set to:
	/usr/share/fonts/X11/misc,
	/usr/share/fonts/X11/cyrillic,
	/usr/share/fonts/X11/100dpi/:unscaled,
	/usr/share/fonts/X11/75dpi/:unscaled,
	/usr/share/fonts/X11/Type1,
	/usr/share/fonts/X11/100dpi,
	/usr/share/fonts/X11/75dpi,
	/var/lib/defoma/x-ttcidfont-conf.d/dirs/TrueType,
	built-ins
[    58.041] (==) ModulePath set to "/usr/lib/xorg/modules"
[    58.041] (==) |-->Input Device "Configured Mouse"
[    58.041] (==) No Layout section. Using the first core pointer device.
[    58.041] (II) The server relies on udev to provide the list of input devices.
	If no devices become available, reconfigure udev or disable AutoAddDevices.
[    58.041] (WW) Hotplugging is on, devices using drivers 'kbd', 'mouse' or 'vmmouse' will be disabled.
[    58.041] (WW) Disabling Configured Mouse
[    58.041] (II) Loader magic: 0x7d8500
[    58.041] (II) Module ABI versions:
[    58.041] 	X.Org ANSI C Emulation: 0.4
[    58.041] 	X.Org Video Driver: 10.0
[    58.041] 	X.Org XInput driver : 12.2
[    58.041] 	X.Org Server Extension : 5.0
[    58.042] (--) PCI:*(0:0:2:0) 8086:0126:1028:0493 rev 9, Mem @ 0xe5400000/4194304, 0xc0000000/268435456, I/O @ 0x00005000/64
[    58.042] (--) PCI: (0:1:0:0) 10de:1056:1028:1493 rev 161, Mem @ 0xe4000000/16777216, 0xd0000000/268435456, 0xe0000000/33554432, I/O @ 0x00004000/128, BIOS @ 0x????????/524288
[    58.042] (II) Open ACPI successful (/var/run/acpid.socket)
[    58.042] (II) LoadModule: "extmod"
[    58.052] (II) Loading /usr/lib/xorg/modules/extensions/libextmod.so
[    58.057] (II) Module extmod: vendor="X.Org Foundation"
[    58.057] 	compiled for 1.10.4, module version = 1.0.0
[    58.057] 	Module class: X.Org Server Extension
[    58.057] 	ABI class: X.Org Server Extension, version 5.0
[    58.057] (II) Loading extension SELinux
[    58.057] (II) Loading extension MIT-SCREEN-SAVER
[    58.057] (II) Loading extension XFree86-VidModeExtension
[    58.057] (II) Loading extension XFree86-DGA
[    58.057] (II) Loading extension DPMS
[    58.057] (II) Loading extension XVideo
[    58.057] (II) Loading extension XVideo-MotionCompensation
[    58.057] (II) Loading extension X-Resource
[    58.057] (II) LoadModule: "dbe"
[    58.057] (II) Loading /usr/lib/xorg/modules/extensions/libdbe.so
[    58.060] (II) Module dbe: vendor="X.Org Foundation"
[    58.060] 	compiled for 1.10.4, module version = 1.0.0
[    58.060] 	Module class: X.Org Server Extension
[    58.060] 	ABI class: X.Org Server Extension, version 5.0
[    58.060] (II) Loading extension DOUBLE-BUFFER
[    58.060] (II) LoadModule: "glx"
[    58.060] (II) Loading /usr/lib/xorg/modules/extensions/libglx.so
[    58.066] (II) Module glx: vendor="X.Org Foundation"
[    58.066] 	compiled for 1.10.4, module version = 1.0.0
[    58.066] 	ABI class: X.Org Server Extension, version 5.0
[    58.066] (==) AIGLX enabled
[    58.066] (II) Loading extension GLX
[    58.068] (II) LoadModule: "record"
[    58.068] (II) Loading /usr/lib/xorg/modules/extensions/librecord.so
[    58.071] (II) Module record: vendor="X.Org Foundation"
[    58.071] 	compiled for 1.10.4, module version = 1.13.0
[    58.071] 	Module class: X.Org Server Extension
[    58.071] 	ABI class: X.Org Server Extension, version 5.0
[    58.071] (II) Loading extension RECORD
[    58.071] (II) LoadModule: "dri"
[    58.071] (II) Loading /usr/lib/xorg/modules/extensions/libdri.so
[    58.077] (II) Module dri: vendor="X.Org Foundation"
[    58.077] 	compiled for 1.10.4, module version = 1.0.0
[    58.077] 	ABI class: X.Org Server Extension, version 5.0
[    58.077] (II) Loading extension XFree86-DRI
[    58.077] (II) LoadModule: "dri2"
[    58.078] (II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
[    58.081] (II) Module dri2: vendor="X.Org Foundation"
[    58.081] 	compiled for 1.10.4, module version = 1.2.0
[    58.081] 	ABI class: X.Org Server Extension, version 5.0
[    58.081] (II) Loading extension DRI2
[    58.081] (==) Matched intel as autoconfigured driver 0
[    58.081] (==) Matched vesa as autoconfigured driver 1
[    58.081] (==) Matched fbdev as autoconfigured driver 2
[    58.081] (==) Assigned the driver to the xf86ConfigLayout
[    58.081] (II) LoadModule: "intel"
[    58.082] (II) Loading /usr/lib/xorg/modules/drivers/intel_drv.so
[    58.093] (II) Module intel: vendor="X.Org Foundation"
[    58.093] 	compiled for 1.10.1, module version = 2.15.0
[    58.093] 	Module class: X.Org Video Driver
[    58.093] 	ABI class: X.Org Video Driver, version 10.0
[    58.093] (II) LoadModule: "vesa"
[    58.093] (II) Loading /usr/lib/xorg/modules/drivers/vesa_drv.so
[    58.096] (II) Module vesa: vendor="X.Org Foundation"
[    58.096] 	compiled for 1.10.2, module version = 2.3.0
[    58.096] 	Module class: X.Org Video Driver
[    58.096] 	ABI class: X.Org Video Driver, version 10.0
[    58.096] (II) LoadModule: "fbdev"
[    58.096] (II) Loading /usr/lib/xorg/modules/drivers/fbdev_drv.so
[    58.099] (II) Module fbdev: vendor="X.Org Foundation"
[    58.099] 	compiled for 1.10.1, module version = 0.4.2
[    58.099] 	ABI class: X.Org Video Driver, version 10.0
[    58.099] (II) intel: Driver for Intel Integrated Graphics Chipsets: i810,
	i810-dc100, i810e, i815, i830M, 845G, 854, 852GM/855GM, 865G, 915G,
	E7221 (i915), 915GM, 945G, 945GM, 945GME, Pineview GM, Pineview G,
	965G, G35, 965Q, 946GZ, 965GM, 965GME/GLE, G33, Q35, Q33, GM45,
	4 Series, G45/G43, Q45/Q43, G41, B43, B43, Clarkdale, Arrandale,
	Sandybridge, Sandybridge, Sandybridge, Sandybridge, Sandybridge,
	Sandybridge, Sandybridge
[    58.100] (II) VESA: driver for VESA chipsets: vesa
[    58.100] (II) FBDEV: driver for framebuffer: fbdev
[    58.100] (--) using VT number 7

[    58.118] (II) Loading /usr/lib/xorg/modules/drivers/intel_drv.so
[    58.118] (WW) Falling back to old probe method for vesa
[    58.118] (WW) Falling back to old probe method for fbdev
[    58.118] (II) Loading sub module "fbdevhw"
[    58.118] (II) LoadModule: "fbdevhw"
[    58.118] (II) Loading /usr/lib/xorg/modules/libfbdevhw.so
[    58.120] (II) Module fbdevhw: vendor="X.Org Foundation"
[    58.120] 	compiled for 1.10.4, module version = 0.0.2
[    58.120] 	ABI class: X.Org Video Driver, version 10.0
[    58.120] drmOpenDevice: node name is /dev/dri/card0
[    58.120] drmOpenDevice: open result is 9, (OK)
[    58.120] drmOpenByBusid: Searching for BusID pci:0000:00:02.0
[    58.120] drmOpenDevice: node name is /dev/dri/card0
[    58.120] drmOpenDevice: open result is 9, (OK)
[    58.120] drmOpenByBusid: drmOpenMinor returns 9
[    58.120] drmOpenByBusid: drmGetBusid reports pci:0000:00:02.0
[    58.120] (II) intel(0): Creating default Display subsection in Screen section
	"Default Screen Section" for depth/fbbpp 24/32
[    58.120] (==) intel(0): Depth 24, (--) framebuffer bpp 32
[    58.120] (==) intel(0): RGB weight 888
[    58.120] (==) intel(0): Default visual is TrueColor
[    58.120] (II) intel(0): Integrated Graphics Chipset: Intel(R) Sandybridge
[    58.120] (--) intel(0): Chipset: "Sandybridge"
[    58.120] (**) intel(0): Relaxed fencing enabled
[    58.120] (**) intel(0): Framebuffer tiled
[    58.120] (**) intel(0): Pixmaps tiled
[    58.120] (**) intel(0): 3D buffers tiled
[    58.120] (**) intel(0): SwapBuffers wait disabled
[    58.120] (==) intel(0): video overlay key set to 0x101fe
[    58.122] (II) intel(0): Output LVDS1 has no monitor section
[    58.228] (II) intel(0): found backlight control interface /sys/class/backlight/acpi_video0
[    58.291] (II) intel(0): Output VGA1 has no monitor section
[    58.291] (II) intel(0): EDID for output LVDS1
[    58.291] (II) intel(0): Manufacturer: SEC  Model: 544b  Serial#: 0
[    58.292] (II) intel(0): Year: 2010  Week: 0
[    58.292] (II) intel(0): EDID Version: 1.4
[    58.292] (II) intel(0): Digital Display Input
[    58.292] (II) intel(0): 6 bits per channel
[    58.292] (II) intel(0): Digital interface is undefined
[    58.292] (II) intel(0): Max Image Size [cm]: horiz.: 31  vert.: 17
[    58.292] (II) intel(0): Gamma: 2.20
[    58.292] (II) intel(0): No DPMS capabilities specified
[    58.292] (II) intel(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
[    58.292] (II) intel(0): First detailed timing is preferred mode
[    58.292] (II) intel(0): Preferred mode is native pixel format and refresh rate
[    58.292] (II) intel(0): redX: 0.610 redY: 0.340   greenX: 0.330 greenY: 0.550
[    58.292] (II) intel(0): blueX: 0.155 blueY: 0.090   whiteX: 0.313 whiteY: 0.329
[    58.292] (II) intel(0): Manufacturer's mask: 0
[    58.292] (II) intel(0): Supported detailed timing:
[    58.292] (II) intel(0): clock: 114.1 MHz   Image Size:  310 x 174 mm
[    58.292] (II) intel(0): h_active: 1600  h_sync: 1648  h_sync_end 1680 h_blank_end 2044 h_border: 0
[    58.292] (II) intel(0): v_active: 900  v_sync: 902  v_sync_end 907 v_blanking: 930 v_border: 0
[    58.292] (II) intel(0): Supported detailed timing:
[    58.292] (II) intel(0): clock: 74.1 MHz   Image Size:  310 x 174 mm
[    58.292] (II) intel(0): h_active: 1600  h_sync: 1648  h_sync_end 1680 h_blank_end 1992 h_border: 0
[    58.292] (II) intel(0): v_active: 900  v_sync: 902  v_sync_end 907 v_blanking: 930 v_border: 0
[    58.292] (II) intel(0):  MJ154€140KT
[    58.292] (II) intel(0): Unknown vendor-specific block 0
[    58.292] (II) intel(0): EDID (in hex):
[    58.292] (II) intel(0): 	00ffffffffffff004ca34b5400000000
[    58.292] (II) intel(0): 	00140104901f11780a4bc59c57548c27
[    58.292] (II) intel(0): 	17505400000001010101010101010101
[    58.292] (II) intel(0): 	0101010101018e2c40bc61841e303020
[    58.292] (II) intel(0): 	250036ae1000001af11c408861841e30
[    58.292] (II) intel(0): 	3020250036ae1000001a000000fe004d
[    58.292] (II) intel(0): 	4a313534803134304b540a2000000000
[    58.292] (II) intel(0): 	00004101980000000002010a2020001d
[    58.292] (II) intel(0): EDID vendor "SEC", prod id 21579
[    58.292] (II) intel(0): Printing DDC gathered Modelines:
[    58.292] (II) intel(0): Modeline "1600x900"x0.0  114.06  1600 1648 1680 2044  900 902 907 930 +hsync -vsync (55.8 kHz)
[    58.292] (II) intel(0): Modeline "1600x900"x0.0   74.09  1600 1648 1680 1992  900 902 907 930 +hsync -vsync (37.2 kHz)
[    58.293] (II) intel(0): Not using default mode "320x240" (doublescan mode not supported)
[    58.293] (II) intel(0): Not using default mode "400x300" (doublescan mode not supported)
[    58.293] (II) intel(0): Not using default mode "400x300" (doublescan mode not supported)
[    58.293] (II) intel(0): Not using default mode "512x384" (doublescan mode not supported)
[    58.293] (II) intel(0): Not using default mode "640x480" (doublescan mode not supported)
[    58.293] (II) intel(0): Not using default mode "640x512" (doublescan mode not supported)
[    58.293] (II) intel(0): Not using default mode "800x600" (doublescan mode not supported)
[    58.293] (II) intel(0): Not using default mode "896x672" (doublescan mode not supported)
[    58.293] (II) intel(0): Not using default mode "928x696" (doublescan mode not supported)
[    58.293] (II) intel(0): Not using default mode "960x720" (doublescan mode not supported)
[    58.293] (II) intel(0): Not using default mode "576x432" (doublescan mode not supported)
[    58.293] (II) intel(0): Not using default mode "680x384" (doublescan mode not supported)
[    58.293] (II) intel(0): Not using default mode "680x384" (doublescan mode not supported)
[    58.293] (II) intel(0): Not using default mode "700x525" (doublescan mode not supported)
[    58.293] (II) intel(0): Not using default mode "720x450" (doublescan mode not supported)
[    58.293] (II) intel(0): Not using default mode "800x512" (doublescan mode not supported)
[    58.293] (II) intel(0): Not using default mode "840x525" (doublescan mode not supported)
[    58.293] (II) intel(0): Not using default mode "840x525" (doublescan mode not supported)
[    58.293] (II) intel(0): Not using default mode "960x540" (doublescan mode not supported)
[    58.293] (II) intel(0): Not using default mode "960x600" (doublescan mode not supported)
[    58.293] (II) intel(0): Not using default mode "1024x768" (doublescan mode not supported)
[    58.293] (II) intel(0): Printing probed modes for output LVDS1
[    58.293] (II) intel(0): Modeline "1600x900"x60.0  114.06  1600 1648 1680 2044  900 902 907 930 +hsync -vsync (55.8 kHz)
[    58.293] (II) intel(0): Modeline "1600x900"x40.0   74.09  1600 1648 1680 1992  900 902 907 930 +hsync -vsync (37.2 kHz)
[    58.293] (II) intel(0): Modeline "1440x900"x59.9  106.50  1440 1520 1672 1904  900 903 909 934 -hsync +vsync (55.9 kHz)
[    58.293] (II) intel(0): Modeline "1360x768"x59.8   84.75  1360 1432 1568 1776  768 771 781 798 -hsync +vsync (47.7 kHz)
[    58.293] (II) intel(0): Modeline "1360x768"x60.0   72.00  1360 1408 1440 1520  768 771 781 790 +hsync -vsync (47.4 kHz)
[    58.293] (II) intel(0): Modeline "1152x864"x60.0   81.62  1152 1216 1336 1520  864 865 868 895 -hsync +vsync (53.7 kHz)
[    58.293] (II) intel(0): Modeline "1024x768"x60.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    58.293] (II) intel(0): Modeline "800x600"x60.3   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    58.293] (II) intel(0): Modeline "800x600"x56.2   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    58.293] (II) intel(0): Modeline "640x480"x59.9   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    58.357] (II) intel(0): EDID for output VGA1
[    58.357] (II) intel(0): Manufacturer: IQT  Model: 703  Serial#: 3866
[    58.357] (II) intel(0): Year: 2004  Week: 5
[    58.357] (II) intel(0): EDID Version: 1.3
[    58.357] (II) intel(0): Analog Display Input,  Input Voltage Level: 0.700/0.300 V
[    58.357] (II) intel(0): Sync:  Separate
[    58.357] (II) intel(0): Max Image Size [cm]: horiz.: 33  vert.: 27
[    58.357] (II) intel(0): Gamma: 2.20
[    58.357] (II) intel(0): DPMS capabilities: StandBy Suspend Off; RGB/Color Display
[    58.357] (II) intel(0): First detailed timing not preferred mode in violation of standard!
[    58.357] (II) intel(0): redX: 0.640 redY: 0.340   greenX: 0.290 greenY: 0.610
[    58.357] (II) intel(0): blueX: 0.140 blueY: 0.070   whiteX: 0.310 whiteY: 0.330
[    58.357] (II) intel(0): Supported established timings:
[    58.357] (II) intel(0): 720x400@70Hz
[    58.357] (II) intel(0): 640x480@60Hz
[    58.357] (II) intel(0): 640x480@75Hz
[    58.357] (II) intel(0): 800x600@60Hz
[    58.357] (II) intel(0): 800x600@75Hz
[    58.357] (II) intel(0): 1024x768@60Hz
[    58.357] (II) intel(0): 1024x768@70Hz
[    58.357] (II) intel(0): 1024x768@75Hz
[    58.357] (II) intel(0): 1280x1024@75Hz
[    58.357] (II) intel(0): Manufacturer's mask: 0
[    58.357] (II) intel(0): Supported standard timings:
[    58.357] (II) intel(0): #0: hsize: 1280  vsize 1024  refresh: 60  vid: 32897
[    58.357] (II) intel(0): Supported detailed timing:
[    58.357] (II) intel(0): clock: 108.0 MHz   Image Size:  330 x 270 mm
[    58.357] (II) intel(0): h_active: 1280  h_sync: 1328  h_sync_end 1440 h_blank_end 1688 h_border: 0
[    58.357] (II) intel(0): v_active: 1024  v_sync: 1025  v_sync_end 1028 v_blanking: 1066 v_border: 0
[    58.357] (II) intel(0): Supported detailed timing:
[    58.357] (II) intel(0): clock: 28.3 MHz   Image Size:  330 x 270 mm
[    58.357] (II) intel(0): h_active: 720  h_sync: 738  h_sync_end 846 h_blank_end 900 h_border: 0
[    58.358] (II) intel(0): v_active: 400  v_sync: 413  v_sync_end 415 v_blanking: 449 v_border: 0
[    58.358] (II) intel(0): Supported detailed timing:
[    58.358] (II) intel(0): clock: 25.2 MHz   Image Size:  330 x 270 mm
[    58.358] (II) intel(0): h_active: 640  h_sync: 656  h_sync_end 752 h_blank_end 800 h_border: 0
[    58.358] (II) intel(0): v_active: 480  v_sync: 490  v_sync_end 492 v_blanking: 525 v_border: 0
[    58.358] (II) intel(0): Monitor name: L70S
[    58.358] (II) intel(0): EDID (in hex):
[    58.358] (II) intel(0): 	00ffffffffffff00263403071a0f0000
[    58.358] (II) intel(0): 	050e010308211b78e8c5c6a3574a9c23
[    58.358] (II) intel(0): 	124f54a54f0081800101010101010101
[    58.358] (II) intel(0): 	010101010101302a009851002a403070
[    58.358] (II) intel(0): 	13004a0e1100001e100bd0b420903110
[    58.358] (II) intel(0): 	126cd2004a0e1100001cd50980a020e0
[    58.358] (II) intel(0): 	2d101060a2004a0e11000018000000fc
[    58.358] (II) intel(0): 	004c3730530a20202020202020200052
[    58.358] (II) intel(0): Printing probed modes for output VGA1
[    58.358] (II) intel(0): Modeline "1280x1024"x75.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    58.358] (II) intel(0): Modeline "1280x1024"x60.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    58.358] (II) intel(0): Modeline "1024x768"x75.1   78.80  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.1 kHz)
[    58.358] (II) intel(0): Modeline "1024x768"x70.1   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    58.358] (II) intel(0): Modeline "1024x768"x60.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    58.358] (II) intel(0): Modeline "800x600"x75.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    58.358] (II) intel(0): Modeline "800x600"x60.3   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    58.358] (II) intel(0): Modeline "640x480"x75.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    58.358] (II) intel(0): Modeline "640x480"x60.0   25.20  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    58.358] (II) intel(0): Modeline "640x480"x59.9   25.17  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    58.358] (II) intel(0): Modeline "720x400"x70.1   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    58.358] (II) intel(0): Modeline "720x400"x70.1   28.32  720 738 846 900  400 413 415 449 -hsync +vsync (31.5 kHz)
[    58.358] (II) intel(0): Output LVDS1 connected
[    58.358] (II) intel(0): Output VGA1 connected
[    58.358] (II) intel(0): Using fuzzy aspect match for initial modes
[    58.358] (II) intel(0): Output LVDS1 using initial mode 1024x768
[    58.358] (II) intel(0): Output VGA1 using initial mode 1024x768
[    58.358] (II) intel(0): Using default gamma of (1.0, 1.0, 1.0) unless otherwise stated.
[    58.358] (II) intel(0): Kernel page flipping support detected, enabling
[    58.358] (**) intel(0): Display dimensions: (310, 170) mm
[    58.358] (**) intel(0): DPI set to (83, 114)
[    58.358] (II) Loading sub module "fb"
[    58.358] (II) LoadModule: "fb"
[    58.359] (II) Loading /usr/lib/xorg/modules/libfb.so
[    58.365] (II) Module fb: vendor="X.Org Foundation"
[    58.365] 	compiled for 1.10.4, module version = 1.0.0
[    58.365] 	ABI class: X.Org ANSI C Emulation, version 0.4
[    58.365] (II) Loading sub module "dri2"
[    58.365] (II) LoadModule: "dri2"
[    58.366] (II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
[    58.366] (II) Module dri2: vendor="X.Org Foundation"
[    58.366] 	compiled for 1.10.4, module version = 1.2.0
[    58.366] 	ABI class: X.Org Server Extension, version 5.0
[    58.366] (II) UnloadModule: "vesa"
[    58.366] (II) Unloading vesa
[    58.366] (II) UnloadModule: "fbdev"
[    58.366] (II) Unloading fbdev
[    58.366] (II) UnloadModule: "fbdevhw"
[    58.366] (II) Unloading fbdevhw
[    58.366] (==) Depth 24 pixmap format is 32 bpp
[    58.366] (II) intel(0): [DRI2] Setup complete
[    58.366] (II) intel(0): [DRI2]   DRI driver: i965
[    58.366] (II) intel(0): Allocated new frame buffer 1024x768 stride 4096, tiled
[    58.374] (II) UXA(0): Driver registered support for the following operations:
[    58.374] (II)         solid
[    58.374] (II)         copy
[    58.374] (II)         composite (RENDER acceleration)
[    58.374] (II)         put_image
[    58.374] (II)         get_image
[    58.374] (==) intel(0): Backing store disabled
[    58.374] (==) intel(0): Silken mouse enabled
[    58.375] (II) intel(0): Initializing HW Cursor
[    59.002] (II) intel(0): RandR 1.2 enabled, ignore the following RandR disabled message.
[    59.072] (==) intel(0): DPMS enabled
[    59.072] (II) intel(0): Set up textured video
[    59.072] (II) intel(0): direct rendering: DRI2 Enabled
[    59.072] (WW) intel(0): Option "XvMC" is not used
[    59.072] (==) intel(0): hotplug detection: "enabled"
[    59.072] (--) RandR disabled
[    59.072] (II) Initializing built-in extension Generic Event Extension
[    59.072] (II) Initializing built-in extension SHAPE
[    59.072] (II) Initializing built-in extension MIT-SHM
[    59.072] (II) Initializing built-in extension XInputExtension
[    59.072] (II) Initializing built-in extension XTEST
[    59.072] (II) Initializing built-in extension BIG-REQUESTS
[    59.072] (II) Initializing built-in extension SYNC
[    59.072] (II) Initializing built-in extension XKEYBOARD
[    59.072] (II) Initializing built-in extension XC-MISC
[    59.072] (II) Initializing built-in extension SECURITY
[    59.072] (II) Initializing built-in extension XINERAMA
[    59.072] (II) Initializing built-in extension XFIXES
[    59.072] (II) Initializing built-in extension RENDER
[    59.072] (II) Initializing built-in extension RANDR
[    59.072] (II) Initializing built-in extension COMPOSITE
[    59.072] (II) Initializing built-in extension DAMAGE
[    59.072] (II) SELinux: Disabled on system
[    59.122] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[    59.122] (II) AIGLX: enabled GLX_INTEL_swap_event
[    59.122] (II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_control
[    59.122] (II) AIGLX: enabled GLX_SGI_make_current_read
[    59.122] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects
[    59.122] (II) AIGLX: Loaded and initialized /usr/lib/x86_64-linux-gnu/dri/i965_dri.so
[    59.122] (II) GLX: Initialized DRI2 GL provider for screen 0
[    59.122] (II) intel(0): Setting screen physical size to 270 x 203
[    59.327] (II) config/udev: Adding input device Power Button (/dev/input/event4)
[    59.327] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    59.327] (II) LoadModule: "evdev"
[    59.327] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    59.330] (II) Module evdev: vendor="X.Org Foundation"
[    59.330] 	compiled for 1.10.1, module version = 2.6.0
[    59.330] 	Module class: X.Org XInput Driver
[    59.330] 	ABI class: X.Org XInput driver, version 12.2
[    59.330] (II) Using input driver 'evdev' for 'Power Button'
[    59.330] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    59.330] (**) Power Button: always reports core events
[    59.330] (**) Power Button: Device: "/dev/input/event4"
[    59.331] (--) Power Button: Found keys
[    59.331] (II) Power Button: Configuring as keyboard
[    59.331] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input4/event4"
[    59.331] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
[    59.331] (**) Option "xkb_rules" "evdev"
[    59.331] (**) Option "xkb_model" "geniuskb19e"
[    59.331] (**) Option "xkb_layout" "fr,brai"
[    59.331] (**) Option "xkb_variant" "oss,"
[    59.331] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    59.384] (II) config/udev: Adding input device Video Bus (/dev/input/event17)
[    59.384] (**) Video Bus: Applying InputClass "evdev keyboard catchall"
[    59.384] (II) Using input driver 'evdev' for 'Video Bus'
[    59.384] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    59.384] (**) Video Bus: always reports core events
[    59.384] (**) Video Bus: Device: "/dev/input/event17"
[    59.384] (--) Video Bus: Found keys
[    59.384] (II) Video Bus: Configuring as keyboard
[    59.384] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input17/event17"
[    59.384] (II) XINPUT: Adding extended input device "Video Bus" (type: KEYBOARD)
[    59.384] (**) Option "xkb_rules" "evdev"
[    59.384] (**) Option "xkb_model" "geniuskb19e"
[    59.384] (**) Option "xkb_layout" "fr,brai"
[    59.384] (**) Option "xkb_variant" "oss,"
[    59.384] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    59.385] (II) config/udev: Adding input device Video Bus (/dev/input/event15)
[    59.385] (**) Video Bus: Applying InputClass "evdev keyboard catchall"
[    59.385] (II) Using input driver 'evdev' for 'Video Bus'
[    59.385] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    59.385] (**) Video Bus: always reports core events
[    59.385] (**) Video Bus: Device: "/dev/input/event15"
[    59.385] (--) Video Bus: Found keys
[    59.385] (II) Video Bus: Configuring as keyboard
[    59.385] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:13/LNXVIDEO:00/input/input15/event15"
[    59.385] (II) XINPUT: Adding extended input device "Video Bus" (type: KEYBOARD)
[    59.385] (**) Option "xkb_rules" "evdev"
[    59.385] (**) Option "xkb_model" "geniuskb19e"
[    59.385] (**) Option "xkb_layout" "fr,brai"
[    59.385] (**) Option "xkb_variant" "oss,"
[    59.385] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    59.389] (II) config/udev: Adding input device Power Button (/dev/input/event2)
[    59.389] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    59.389] (II) Using input driver 'evdev' for 'Power Button'
[    59.389] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    59.389] (**) Power Button: always reports core events
[    59.389] (**) Power Button: Device: "/dev/input/event2"
[    59.389] (--) Power Button: Found keys
[    59.389] (II) Power Button: Configuring as keyboard
[    59.389] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2/event2"
[    59.389] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
[    59.389] (**) Option "xkb_rules" "evdev"
[    59.389] (**) Option "xkb_model" "geniuskb19e"
[    59.389] (**) Option "xkb_layout" "fr,brai"
[    59.389] (**) Option "xkb_variant" "oss,"
[    59.389] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    59.389] (II) config/udev: Adding input device Lid Switch (/dev/input/event1)
[    59.389] (II) No input driver/identifier specified (ignoring)
[    59.389] (II) config/udev: Adding input device Sleep Button (/dev/input/event3)
[    59.389] (**) Sleep Button: Applying InputClass "evdev keyboard catchall"
[    59.389] (II) Using input driver 'evdev' for 'Sleep Button'
[    59.389] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    59.389] (**) Sleep Button: always reports core events
[    59.389] (**) Sleep Button: Device: "/dev/input/event3"
[    59.389] (--) Sleep Button: Found keys
[    59.389] (II) Sleep Button: Configuring as keyboard
[    59.389] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3/event3"
[    59.389] (II) XINPUT: Adding extended input device "Sleep Button" (type: KEYBOARD)
[    59.389] (**) Option "xkb_rules" "evdev"
[    59.389] (**) Option "xkb_model" "geniuskb19e"
[    59.389] (**) Option "xkb_layout" "fr,brai"
[    59.389] (**) Option "xkb_variant" "oss,"
[    59.389] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    59.390] (II) config/udev: Adding input device HDA NVidia HDMI/DP (/dev/input/event12)
[    59.390] (II) No input driver/identifier specified (ignoring)
[    59.390] (II) config/udev: Adding input device HDA NVidia HDMI/DP (/dev/input/event13)
[    59.390] (II) No input driver/identifier specified (ignoring)
[    59.390] (II) config/udev: Adding input device HDA NVidia HDMI/DP (/dev/input/event14)
[    59.390] (II) No input driver/identifier specified (ignoring)
[    59.391] (II) config/udev: Adding input device HDA Digital PCBeep (/dev/input/event7)
[    59.391] (II) No input driver/identifier specified (ignoring)
[    59.392] (II) config/udev: Adding input device HDA Intel PCH Line Out at Sep Left Jack (/dev/input/event10)
[    59.392] (II) No input driver/identifier specified (ignoring)
[    59.392] (II) config/udev: Adding input device HDA Intel PCH HP Out at Ext Left Jack (/dev/input/event11)
[    59.392] (II) No input driver/identifier specified (ignoring)
[    59.392] (II) config/udev: Adding input device HDA Intel PCH Mic at Sep Left Jack (/dev/input/event8)
[    59.392] (II) No input driver/identifier specified (ignoring)
[    59.392] (II) config/udev: Adding input device HDA Intel PCH Mic at Ext Left Jack (/dev/input/event9)
[    59.392] (II) No input driver/identifier specified (ignoring)
[    59.393] (II) config/udev: Adding input device spca561 (/dev/input/event22)
[    59.393] (**) spca561: Applying InputClass "evdev keyboard catchall"
[    59.393] (II) Using input driver 'evdev' for 'spca561'
[    59.393] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    59.393] (**) spca561: always reports core events
[    59.393] (**) spca561: Device: "/dev/input/event22"
[    59.393] (--) spca561: Found keys
[    59.393] (II) spca561: Configuring as keyboard
[    59.393] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1.1/2-1.1.1.1/input/input22/event22"
[    59.393] (II) XINPUT: Adding extended input device "spca561" (type: KEYBOARD)
[    59.393] (**) Option "xkb_rules" "evdev"
[    59.393] (**) Option "xkb_model" "geniuskb19e"
[    59.393] (**) Option "xkb_layout" "fr,brai"
[    59.393] (**) Option "xkb_variant" "oss,"
[    59.393] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    59.394] (II) config/udev: Adding input device Logitech USB-PS/2 Optical Mouse (/dev/input/event20)
[    59.394] (**) Logitech USB-PS/2 Optical Mouse: Applying InputClass "evdev pointer catchall"
[    59.394] (II) Using input driver 'evdev' for 'Logitech USB-PS/2 Optical Mouse'
[    59.394] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    59.394] (**) Logitech USB-PS/2 Optical Mouse: always reports core events
[    59.394] (**) Logitech USB-PS/2 Optical Mouse: Device: "/dev/input/event20"
[    59.394] (--) Logitech USB-PS/2 Optical Mouse: Found 12 mouse buttons
[    59.394] (--) Logitech USB-PS/2 Optical Mouse: Found scroll wheel(s)
[    59.394] (--) Logitech USB-PS/2 Optical Mouse: Found relative axes
[    59.394] (--) Logitech USB-PS/2 Optical Mouse: Found x and y relative axes
[    59.394] (II) Logitech USB-PS/2 Optical Mouse: Configuring as mouse
[    59.394] (II) Logitech USB-PS/2 Optical Mouse: Adding scrollwheel support
[    59.394] (**) Logitech USB-PS/2 Optical Mouse: YAxisMapping: buttons 4 and 5
[    59.394] (**) Logitech USB-PS/2 Optical Mouse: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[    59.394] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1.1/2-1.1.1.2/2-1.1.1.2:1.0/input/input20/event20"
[    59.394] (II) XINPUT: Adding extended input device "Logitech USB-PS/2 Optical Mouse" (type: MOUSE)
[    59.394] (II) Logitech USB-PS/2 Optical Mouse: initialized for relative axes.
[    59.394] (**) Logitech USB-PS/2 Optical Mouse: (accel) keeping acceleration scheme 1
[    59.394] (**) Logitech USB-PS/2 Optical Mouse: (accel) acceleration profile 0
[    59.394] (**) Logitech USB-PS/2 Optical Mouse: (accel) acceleration factor: 2.000
[    59.394] (**) Logitech USB-PS/2 Optical Mouse: (accel) acceleration threshold: 4
[    59.394] (II) config/udev: Adding input device Logitech USB-PS/2 Optical Mouse (/dev/input/mouse2)
[    59.394] (II) No input driver/identifier specified (ignoring)
[    59.394] (II) config/udev: Adding input device ABBHOME (/dev/input/event19)
[    59.394] (**) ABBHOME: Applying InputClass "evdev pointer catchall"
[    59.394] (**) ABBHOME: Applying InputClass "evdev keyboard catchall"
[    59.394] (II) Using input driver 'evdev' for 'ABBHOME'
[    59.394] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    59.394] (**) ABBHOME: always reports core events
[    59.394] (**) ABBHOME: Device: "/dev/input/event19"
[    59.394] (--) ABBHOME: Found 3 mouse buttons
[    59.394] (--) ABBHOME: Found scroll wheel(s)
[    59.394] (--) ABBHOME: Found relative axes
[    59.394] (--) ABBHOME: Found x and y relative axes
[    59.394] (--) ABBHOME: Found absolute axes
[    59.394] (--) ABBHOME: Found keys
[    59.394] (II) ABBHOME: Configuring as mouse
[    59.394] (II) ABBHOME: Configuring as keyboard
[    59.394] (II) ABBHOME: Adding scrollwheel support
[    59.394] (**) ABBHOME: YAxisMapping: buttons 4 and 5
[    59.394] (**) ABBHOME: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[    59.394] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1.3/2-1.1.3:1.0/input/input19/event19"
[    59.394] (II) XINPUT: Adding extended input device "ABBHOME" (type: KEYBOARD)
[    59.394] (**) Option "xkb_rules" "evdev"
[    59.394] (**) Option "xkb_model" "geniuskb19e"
[    59.394] (**) Option "xkb_layout" "fr,brai"
[    59.394] (**) Option "xkb_variant" "oss,"
[    59.395] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    59.395] (II) ABBHOME: initialized for relative axes.
[    59.395] (WW) ABBHOME: ignoring absolute axes.
[    59.395] (**) ABBHOME: (accel) keeping acceleration scheme 1
[    59.395] (**) ABBHOME: (accel) acceleration profile 0
[    59.395] (**) ABBHOME: (accel) acceleration factor: 2.000
[    59.395] (**) ABBHOME: (accel) acceleration threshold: 4
[    59.395] (II) config/udev: Adding input device ABBHOME (/dev/input/mouse1)
[    59.395] (II) No input driver/identifier specified (ignoring)
[    59.398] (II) config/udev: Adding input device AT Translated Set 2 keyboard (/dev/input/event0)
[    59.398] (**) AT Translated Set 2 keyboard: Applying InputClass "evdev keyboard catchall"
[    59.398] (II) Using input driver 'evdev' for 'AT Translated Set 2 keyboard'
[    59.398] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    59.398] (**) AT Translated Set 2 keyboard: always reports core events
[    59.398] (**) AT Translated Set 2 keyboard: Device: "/dev/input/event0"
[    59.398] (--) AT Translated Set 2 keyboard: Found keys
[    59.398] (II) AT Translated Set 2 keyboard: Configuring as keyboard
[    59.398] (**) Option "config_info" "udev:/sys/devices/platform/i8042/serio0/input/input0/event0"
[    59.398] (II) XINPUT: Adding extended input device "AT Translated Set 2 keyboard" (type: KEYBOARD)
[    59.398] (**) Option "xkb_rules" "evdev"
[    59.398] (**) Option "xkb_model" "geniuskb19e"
[    59.398] (**) Option "xkb_layout" "fr,brai"
[    59.398] (**) Option "xkb_variant" "oss,"
[    59.398] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    59.398] (II) config/udev: Adding input device PS/2 Generic Mouse (/dev/input/event16)
[    59.398] (**) PS/2 Generic Mouse: Applying InputClass "evdev pointer catchall"
[    59.398] (II) Using input driver 'evdev' for 'PS/2 Generic Mouse'
[    59.398] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    59.398] (**) PS/2 Generic Mouse: always reports core events
[    59.398] (**) PS/2 Generic Mouse: Device: "/dev/input/event16"
[    59.398] (--) PS/2 Generic Mouse: Found 3 mouse buttons
[    59.398] (--) PS/2 Generic Mouse: Found relative axes
[    59.398] (--) PS/2 Generic Mouse: Found x and y relative axes
[    59.398] (II) PS/2 Generic Mouse: Configuring as mouse
[    59.398] (**) PS/2 Generic Mouse: YAxisMapping: buttons 4 and 5
[    59.398] (**) PS/2 Generic Mouse: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[    59.398] (**) Option "config_info" "udev:/sys/devices/platform/i8042/serio1/input/input16/event16"
[    59.398] (II) XINPUT: Adding extended input device "PS/2 Generic Mouse" (type: MOUSE)
[    59.398] (II) PS/2 Generic Mouse: initialized for relative axes.
[    59.398] (**) PS/2 Generic Mouse: (accel) keeping acceleration scheme 1
[    59.398] (**) PS/2 Generic Mouse: (accel) acceleration profile 0
[    59.398] (**) PS/2 Generic Mouse: (accel) acceleration factor: 2.000
[    59.398] (**) PS/2 Generic Mouse: (accel) acceleration threshold: 4
[    59.399] (II) config/udev: Adding input device PS/2 Generic Mouse (/dev/input/mouse0)
[    59.399] (II) No input driver/identifier specified (ignoring)
[    59.399] (II) config/udev: Adding input device PC Speaker (/dev/input/event5)
[    59.399] (II) No input driver/identifier specified (ignoring)
[    59.400] (II) config/udev: Adding input device Speakup (/dev/input/event18)
[    59.400] (**) Speakup: Applying InputClass "evdev keyboard catchall"
[    59.400] (II) Using input driver 'evdev' for 'Speakup'
[    59.400] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    59.400] (**) Speakup: always reports core events
[    59.400] (**) Speakup: Device: "/dev/input/event18"
[    59.400] (--) Speakup: Found keys
[    59.400] (II) Speakup: Configuring as keyboard
[    59.400] (**) Option "config_info" "udev:/sys/devices/virtual/input/input18/event18"
[    59.400] (II) XINPUT: Adding extended input device "Speakup" (type: KEYBOARD)
[    59.400] (**) Option "xkb_rules" "evdev"
[    59.400] (**) Option "xkb_model" "geniuskb19e"
[    59.400] (**) Option "xkb_layout" "fr,brai"
[    59.400] (**) Option "xkb_variant" "oss,"
[    59.400] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    59.400] (II) config/udev: Adding input device ACPI Virtual Keyboard Device (/dev/input/event21)
[    59.400] (**) ACPI Virtual Keyboard Device: Applying InputClass "evdev keyboard catchall"
[    59.400] (II) Using input driver 'evdev' for 'ACPI Virtual Keyboard Device'
[    59.400] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    59.400] (**) ACPI Virtual Keyboard Device: always reports core events
[    59.400] (**) ACPI Virtual Keyboard Device: Device: "/dev/input/event21"
[    59.400] (--) ACPI Virtual Keyboard Device: Found keys
[    59.400] (II) ACPI Virtual Keyboard Device: Configuring as keyboard
[    59.400] (**) Option "config_info" "udev:/sys/devices/virtual/input/input21/event21"
[    59.400] (II) XINPUT: Adding extended input device "ACPI Virtual Keyboard Device" (type: KEYBOARD)
[    59.400] (**) Option "xkb_rules" "evdev"
[    59.400] (**) Option "xkb_model" "geniuskb19e"
[    59.400] (**) Option "xkb_layout" "fr,brai"
[    59.400] (**) Option "xkb_variant" "oss,"
[    59.400] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    59.401] (II) config/udev: Adding input device Dell WMI hotkeys (/dev/input/event6)
[    59.401] (**) Dell WMI hotkeys: Applying InputClass "evdev keyboard catchall"
[    59.401] (II) Using input driver 'evdev' for 'Dell WMI hotkeys'
[    59.401] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    59.401] (**) Dell WMI hotkeys: always reports core events
[    59.401] (**) Dell WMI hotkeys: Device: "/dev/input/event6"
[    59.401] (--) Dell WMI hotkeys: Found keys
[    59.401] (II) Dell WMI hotkeys: Configuring as keyboard
[    59.401] (**) Option "config_info" "udev:/sys/devices/virtual/input/input6/event6"
[    59.401] (II) XINPUT: Adding extended input device "Dell WMI hotkeys" (type: KEYBOARD)
[    59.401] (**) Option "xkb_rules" "evdev"
[    59.401] (**) Option "xkb_model" "geniuskb19e"
[    59.401] (**) Option "xkb_layout" "fr,brai"
[    59.401] (**) Option "xkb_variant" "oss,"
[    59.401] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    59.615] (II) intel(0): EDID vendor "IQT", prod id 1795
[    59.615] (II) intel(0): Printing DDC gathered Modelines:
[    59.615] (II) intel(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    59.615] (II) intel(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 413 415 449 -hsync +vsync (31.5 kHz)
[    59.615] (II) intel(0): Modeline "640x480"x0.0   25.17  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    59.615] (II) intel(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    59.615] (II) intel(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    59.615] (II) intel(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    59.615] (II) intel(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    59.615] (II) intel(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    59.615] (II) intel(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    59.615] (II) intel(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    59.615] (II) intel(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    59.615] (II) intel(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    59.617] (II) intel(0): Allocated new frame buffer 1600x1024 stride 6656, tiled
[    60.436] (II) intel(0): EDID vendor "IQT", prod id 1795
[    60.436] (II) intel(0): Printing DDC gathered Modelines:
[    60.436] (II) intel(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    60.436] (II) intel(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 413 415 449 -hsync +vsync (31.5 kHz)
[    60.436] (II) intel(0): Modeline "640x480"x0.0   25.17  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    60.436] (II) intel(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    60.436] (II) intel(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    60.436] (II) intel(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    60.436] (II) intel(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    60.436] (II) intel(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    60.436] (II) intel(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    60.436] (II) intel(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    60.436] (II) intel(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    60.436] (II) intel(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    60.438] (II) intel(0): Allocated new frame buffer 1600x1924 stride 6656, tiled
[    65.260] (II) Power Button: Close
[    65.260] (II) UnloadModule: "evdev"
[    65.260] (II) Unloading evdev
[    65.280] (II) Video Bus: Close
[    65.280] (II) UnloadModule: "evdev"
[    65.280] (II) Unloading evdev
[    65.316] (II) Video Bus: Close
[    65.316] (II) UnloadModule: "evdev"
[    65.316] (II) Unloading evdev
[    65.348] (II) Power Button: Close
[    65.348] (II) UnloadModule: "evdev"
[    65.348] (II) Unloading evdev
[    65.408] (II) Sleep Button: Close
[    65.408] (II) UnloadModule: "evdev"
[    65.408] (II) Unloading evdev
[    65.536] (II) spca561: Close
[    65.536] (II) UnloadModule: "evdev"
[    65.536] (II) Unloading evdev
[    65.664] (II) Logitech USB-PS/2 Optical Mouse: Close
[    65.664] (II) UnloadModule: "evdev"
[    65.664] (II) Unloading evdev
[    65.764] (II) ABBHOME: Close
[    65.764] (II) UnloadModule: "evdev"
[    65.764] (II) Unloading evdev
[    65.828] (II) AT Translated Set 2 keyboard: Close
[    65.828] (II) UnloadModule: "evdev"
[    65.828] (II) Unloading evdev
[    65.956] (II) PS/2 Generic Mouse: Close
[    65.956] (II) UnloadModule: "evdev"
[    65.956] (II) Unloading evdev
[    66.092] (II) Speakup: Close
[    66.092] (II) UnloadModule: "evdev"
[    66.092] (II) Unloading evdev
[    66.152] (II) ACPI Virtual Keyboard Device: Close
[    66.152] (II) UnloadModule: "evdev"
[    66.152] (II) Unloading evdev
[    66.216] (II) Dell WMI hotkeys: Close
[    66.216] (II) UnloadModule: "evdev"
[    66.216] (II) Unloading evdev

--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="Xorg.0.log.bad"
Content-Transfer-Encoding: 8bit

[    67.726] 
X.Org X Server 1.10.4
Release Date: 2011-08-19
[    67.726] X Protocol Version 11, Revision 0
[    67.726] Build Operating System: Linux 3.0.0-1-amd64 x86_64 Debian
[    67.726] Current Operating System: Linux type 3.1.0-rc6 #1 SMP Wed Sep 14 19:23:48 CEST 2011 x86_64
[    67.726] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.1.0-rc6 root=UUID=38e6e493-2f5f-4a98-b1d6-a9434f0683cc ro
[    67.726] Build Date: 24 August 2011  08:53:55AM
[    67.726] xorg-server 2:1.10.4-1 (Cyril Brulebois <kibi@debian.org>) 
[    67.726] Current version of pixman: 0.22.2
[    67.726] 	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
[    67.726] Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[    67.726] (==) Log file: "/var/log/Xorg.0.log", Time: Wed Sep 14 19:54:31 2011
[    67.745] (==) Using config file: "/etc/X11/xorg.conf"
[    67.745] (==) Using system config directory "/usr/share/X11/xorg.conf.d"
[    67.751] (==) No Layout section.  Using the first Screen section.
[    67.751] (==) No screen section available. Using defaults.
[    67.751] (**) |-->Screen "Default Screen Section" (0)
[    67.751] (**) |   |-->Monitor "<default monitor>"
[    67.752] (==) No device specified for screen "Default Screen Section".
	Using the first device section listed.
[    67.752] (**) |   |-->Device "Configured Video Device"
[    67.752] (==) No monitor specified for screen "Default Screen Section".
	Using a default monitor configuration.
[    67.752] (==) Automatically adding devices
[    67.752] (==) Automatically enabling devices
[    67.758] (==) FontPath set to:
	/usr/share/fonts/X11/misc,
	/usr/share/fonts/X11/cyrillic,
	/usr/share/fonts/X11/100dpi/:unscaled,
	/usr/share/fonts/X11/75dpi/:unscaled,
	/usr/share/fonts/X11/Type1,
	/usr/share/fonts/X11/100dpi,
	/usr/share/fonts/X11/75dpi,
	/var/lib/defoma/x-ttcidfont-conf.d/dirs/TrueType,
	built-ins
[    67.758] (==) ModulePath set to "/usr/lib/xorg/modules"
[    67.758] (==) |-->Input Device "Configured Mouse"
[    67.758] (==) No Layout section. Using the first core pointer device.
[    67.758] (II) The server relies on udev to provide the list of input devices.
	If no devices become available, reconfigure udev or disable AutoAddDevices.
[    67.758] (WW) Hotplugging is on, devices using drivers 'kbd', 'mouse' or 'vmmouse' will be disabled.
[    67.758] (WW) Disabling Configured Mouse
[    67.758] (II) Loader magic: 0x7d8500
[    67.758] (II) Module ABI versions:
[    67.758] 	X.Org ANSI C Emulation: 0.4
[    67.758] 	X.Org Video Driver: 10.0
[    67.758] 	X.Org XInput driver : 12.2
[    67.758] 	X.Org Server Extension : 5.0
[    67.759] (--) PCI:*(0:0:2:0) 8086:0126:1028:0493 rev 9, Mem @ 0xe5400000/4194304, 0xc0000000/268435456, I/O @ 0x00005000/64
[    67.759] (--) PCI: (0:1:0:0) 10de:1056:1028:1493 rev 161, Mem @ 0xe4000000/16777216, 0xd0000000/268435456, 0xe0000000/33554432, I/O @ 0x00004000/128, BIOS @ 0x????????/524288
[    67.759] (II) Open ACPI successful (/var/run/acpid.socket)
[    67.759] (II) LoadModule: "extmod"
[    67.769] (II) Loading /usr/lib/xorg/modules/extensions/libextmod.so
[    67.774] (II) Module extmod: vendor="X.Org Foundation"
[    67.774] 	compiled for 1.10.4, module version = 1.0.0
[    67.774] 	Module class: X.Org Server Extension
[    67.774] 	ABI class: X.Org Server Extension, version 5.0
[    67.774] (II) Loading extension SELinux
[    67.774] (II) Loading extension MIT-SCREEN-SAVER
[    67.774] (II) Loading extension XFree86-VidModeExtension
[    67.774] (II) Loading extension XFree86-DGA
[    67.774] (II) Loading extension DPMS
[    67.775] (II) Loading extension XVideo
[    67.775] (II) Loading extension XVideo-MotionCompensation
[    67.775] (II) Loading extension X-Resource
[    67.775] (II) LoadModule: "dbe"
[    67.775] (II) Loading /usr/lib/xorg/modules/extensions/libdbe.so
[    67.777] (II) Module dbe: vendor="X.Org Foundation"
[    67.777] 	compiled for 1.10.4, module version = 1.0.0
[    67.777] 	Module class: X.Org Server Extension
[    67.777] 	ABI class: X.Org Server Extension, version 5.0
[    67.777] (II) Loading extension DOUBLE-BUFFER
[    67.777] (II) LoadModule: "glx"
[    67.778] (II) Loading /usr/lib/xorg/modules/extensions/libglx.so
[    67.784] (II) Module glx: vendor="X.Org Foundation"
[    67.784] 	compiled for 1.10.4, module version = 1.0.0
[    67.784] 	ABI class: X.Org Server Extension, version 5.0
[    67.784] (==) AIGLX enabled
[    67.784] (II) Loading extension GLX
[    67.785] (II) LoadModule: "record"
[    67.785] (II) Loading /usr/lib/xorg/modules/extensions/librecord.so
[    67.788] (II) Module record: vendor="X.Org Foundation"
[    67.788] 	compiled for 1.10.4, module version = 1.13.0
[    67.788] 	Module class: X.Org Server Extension
[    67.788] 	ABI class: X.Org Server Extension, version 5.0
[    67.788] (II) Loading extension RECORD
[    67.788] (II) LoadModule: "dri"
[    67.788] (II) Loading /usr/lib/xorg/modules/extensions/libdri.so
[    67.794] (II) Module dri: vendor="X.Org Foundation"
[    67.794] 	compiled for 1.10.4, module version = 1.0.0
[    67.795] 	ABI class: X.Org Server Extension, version 5.0
[    67.795] (II) Loading extension XFree86-DRI
[    67.795] (II) LoadModule: "dri2"
[    67.795] (II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
[    67.798] (II) Module dri2: vendor="X.Org Foundation"
[    67.798] 	compiled for 1.10.4, module version = 1.2.0
[    67.798] 	ABI class: X.Org Server Extension, version 5.0
[    67.798] (II) Loading extension DRI2
[    67.798] (==) Matched intel as autoconfigured driver 0
[    67.798] (==) Matched vesa as autoconfigured driver 1
[    67.798] (==) Matched fbdev as autoconfigured driver 2
[    67.798] (==) Assigned the driver to the xf86ConfigLayout
[    67.798] (II) LoadModule: "intel"
[    67.800] (II) Loading /usr/lib/xorg/modules/drivers/intel_drv.so
[    67.817] (II) Module intel: vendor="X.Org Foundation"
[    67.817] 	compiled for 1.10.1, module version = 2.15.0
[    67.817] 	Module class: X.Org Video Driver
[    67.817] 	ABI class: X.Org Video Driver, version 10.0
[    67.817] (II) LoadModule: "vesa"
[    67.817] (II) Loading /usr/lib/xorg/modules/drivers/vesa_drv.so
[    67.820] (II) Module vesa: vendor="X.Org Foundation"
[    67.820] 	compiled for 1.10.2, module version = 2.3.0
[    67.820] 	Module class: X.Org Video Driver
[    67.820] 	ABI class: X.Org Video Driver, version 10.0
[    67.820] (II) LoadModule: "fbdev"
[    67.821] (II) Loading /usr/lib/xorg/modules/drivers/fbdev_drv.so
[    67.824] (II) Module fbdev: vendor="X.Org Foundation"
[    67.824] 	compiled for 1.10.1, module version = 0.4.2
[    67.824] 	ABI class: X.Org Video Driver, version 10.0
[    67.824] (II) intel: Driver for Intel Integrated Graphics Chipsets: i810,
	i810-dc100, i810e, i815, i830M, 845G, 854, 852GM/855GM, 865G, 915G,
	E7221 (i915), 915GM, 945G, 945GM, 945GME, Pineview GM, Pineview G,
	965G, G35, 965Q, 946GZ, 965GM, 965GME/GLE, G33, Q35, Q33, GM45,
	4 Series, G45/G43, Q45/Q43, G41, B43, B43, Clarkdale, Arrandale,
	Sandybridge, Sandybridge, Sandybridge, Sandybridge, Sandybridge,
	Sandybridge, Sandybridge
[    67.824] (II) VESA: driver for VESA chipsets: vesa
[    67.824] (II) FBDEV: driver for framebuffer: fbdev
[    67.824] (--) using VT number 7

[    67.835] (II) Loading /usr/lib/xorg/modules/drivers/intel_drv.so
[    67.835] (WW) Falling back to old probe method for vesa
[    67.835] (WW) Falling back to old probe method for fbdev
[    67.835] (II) Loading sub module "fbdevhw"
[    67.835] (II) LoadModule: "fbdevhw"
[    67.835] (II) Loading /usr/lib/xorg/modules/libfbdevhw.so
[    67.837] (II) Module fbdevhw: vendor="X.Org Foundation"
[    67.837] 	compiled for 1.10.4, module version = 0.0.2
[    67.837] 	ABI class: X.Org Video Driver, version 10.0
[    67.837] drmOpenDevice: node name is /dev/dri/card0
[    67.837] drmOpenDevice: open result is 9, (OK)
[    67.837] drmOpenByBusid: Searching for BusID pci:0000:00:02.0
[    67.837] drmOpenDevice: node name is /dev/dri/card0
[    67.837] drmOpenDevice: open result is 9, (OK)
[    67.837] drmOpenByBusid: drmOpenMinor returns 9
[    67.837] drmOpenByBusid: drmGetBusid reports pci:0000:00:02.0
[    67.837] (II) intel(0): Creating default Display subsection in Screen section
	"Default Screen Section" for depth/fbbpp 24/32
[    67.837] (==) intel(0): Depth 24, (--) framebuffer bpp 32
[    67.837] (==) intel(0): RGB weight 888
[    67.837] (==) intel(0): Default visual is TrueColor
[    67.837] (II) intel(0): Integrated Graphics Chipset: Intel(R) Sandybridge
[    67.837] (--) intel(0): Chipset: "Sandybridge"
[    67.837] (**) intel(0): Relaxed fencing enabled
[    67.837] (**) intel(0): Framebuffer tiled
[    67.837] (**) intel(0): Pixmaps tiled
[    67.837] (**) intel(0): 3D buffers tiled
[    67.837] (**) intel(0): SwapBuffers wait disabled
[    67.837] (==) intel(0): video overlay key set to 0x101fe
[    67.839] (II) intel(0): Output LVDS1 has no monitor section
[    67.968] (II) intel(0): found backlight control interface /sys/class/backlight/acpi_video0
[    68.031] (II) intel(0): Output VGA1 has no monitor section
[    68.032] (II) intel(0): EDID for output LVDS1
[    68.032] (II) intel(0): Manufacturer: SEC  Model: 544b  Serial#: 0
[    68.032] (II) intel(0): Year: 2010  Week: 0
[    68.032] (II) intel(0): EDID Version: 1.4
[    68.032] (II) intel(0): Digital Display Input
[    68.032] (II) intel(0): 6 bits per channel
[    68.032] (II) intel(0): Digital interface is undefined
[    68.032] (II) intel(0): Max Image Size [cm]: horiz.: 31  vert.: 17
[    68.032] (II) intel(0): Gamma: 2.20
[    68.032] (II) intel(0): No DPMS capabilities specified
[    68.032] (II) intel(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
[    68.032] (II) intel(0): First detailed timing is preferred mode
[    68.032] (II) intel(0): Preferred mode is native pixel format and refresh rate
[    68.032] (II) intel(0): redX: 0.610 redY: 0.340   greenX: 0.330 greenY: 0.550
[    68.032] (II) intel(0): blueX: 0.155 blueY: 0.090   whiteX: 0.313 whiteY: 0.329
[    68.032] (II) intel(0): Manufacturer's mask: 0
[    68.032] (II) intel(0): Supported detailed timing:
[    68.032] (II) intel(0): clock: 114.1 MHz   Image Size:  310 x 174 mm
[    68.032] (II) intel(0): h_active: 1600  h_sync: 1648  h_sync_end 1680 h_blank_end 2044 h_border: 0
[    68.032] (II) intel(0): v_active: 900  v_sync: 902  v_sync_end 907 v_blanking: 930 v_border: 0
[    68.032] (II) intel(0): Supported detailed timing:
[    68.032] (II) intel(0): clock: 74.1 MHz   Image Size:  310 x 174 mm
[    68.032] (II) intel(0): h_active: 1600  h_sync: 1648  h_sync_end 1680 h_blank_end 1992 h_border: 0
[    68.032] (II) intel(0): v_active: 900  v_sync: 902  v_sync_end 907 v_blanking: 930 v_border: 0
[    68.032] (II) intel(0):  MJ154€140KT
[    68.032] (II) intel(0): Unknown vendor-specific block 0
[    68.032] (II) intel(0): EDID (in hex):
[    68.032] (II) intel(0): 	00ffffffffffff004ca34b5400000000
[    68.032] (II) intel(0): 	00140104901f11780a4bc59c57548c27
[    68.032] (II) intel(0): 	17505400000001010101010101010101
[    68.032] (II) intel(0): 	0101010101018e2c40bc61841e303020
[    68.032] (II) intel(0): 	250036ae1000001af11c408861841e30
[    68.032] (II) intel(0): 	3020250036ae1000001a000000fe004d
[    68.032] (II) intel(0): 	4a313534803134304b540a2000000000
[    68.032] (II) intel(0): 	00004101980000000002010a2020001d
[    68.032] (II) intel(0): EDID vendor "SEC", prod id 21579
[    68.032] (II) intel(0): Printing DDC gathered Modelines:
[    68.032] (II) intel(0): Modeline "1600x900"x0.0  114.06  1600 1648 1680 2044  900 902 907 930 +hsync -vsync (55.8 kHz)
[    68.032] (II) intel(0): Modeline "1600x900"x0.0   74.09  1600 1648 1680 1992  900 902 907 930 +hsync -vsync (37.2 kHz)
[    68.033] (II) intel(0): Not using default mode "320x240" (doublescan mode not supported)
[    68.033] (II) intel(0): Not using default mode "400x300" (doublescan mode not supported)
[    68.033] (II) intel(0): Not using default mode "400x300" (doublescan mode not supported)
[    68.033] (II) intel(0): Not using default mode "512x384" (doublescan mode not supported)
[    68.033] (II) intel(0): Not using default mode "640x480" (doublescan mode not supported)
[    68.033] (II) intel(0): Not using default mode "640x512" (doublescan mode not supported)
[    68.033] (II) intel(0): Not using default mode "800x600" (doublescan mode not supported)
[    68.033] (II) intel(0): Not using default mode "896x672" (doublescan mode not supported)
[    68.033] (II) intel(0): Not using default mode "928x696" (doublescan mode not supported)
[    68.033] (II) intel(0): Not using default mode "960x720" (doublescan mode not supported)
[    68.033] (II) intel(0): Not using default mode "576x432" (doublescan mode not supported)
[    68.033] (II) intel(0): Not using default mode "680x384" (doublescan mode not supported)
[    68.033] (II) intel(0): Not using default mode "680x384" (doublescan mode not supported)
[    68.033] (II) intel(0): Not using default mode "700x525" (doublescan mode not supported)
[    68.033] (II) intel(0): Not using default mode "720x450" (doublescan mode not supported)
[    68.033] (II) intel(0): Not using default mode "800x512" (doublescan mode not supported)
[    68.033] (II) intel(0): Not using default mode "840x525" (doublescan mode not supported)
[    68.033] (II) intel(0): Not using default mode "840x525" (doublescan mode not supported)
[    68.033] (II) intel(0): Not using default mode "960x540" (doublescan mode not supported)
[    68.033] (II) intel(0): Not using default mode "960x600" (doublescan mode not supported)
[    68.033] (II) intel(0): Not using default mode "1024x768" (doublescan mode not supported)
[    68.033] (II) intel(0): Printing probed modes for output LVDS1
[    68.033] (II) intel(0): Modeline "1600x900"x60.0  114.06  1600 1648 1680 2044  900 902 907 930 +hsync -vsync (55.8 kHz)
[    68.033] (II) intel(0): Modeline "1600x900"x40.0   74.09  1600 1648 1680 1992  900 902 907 930 +hsync -vsync (37.2 kHz)
[    68.033] (II) intel(0): Modeline "1440x900"x59.9  106.50  1440 1520 1672 1904  900 903 909 934 -hsync +vsync (55.9 kHz)
[    68.033] (II) intel(0): Modeline "1360x768"x59.8   84.75  1360 1432 1568 1776  768 771 781 798 -hsync +vsync (47.7 kHz)
[    68.033] (II) intel(0): Modeline "1360x768"x60.0   72.00  1360 1408 1440 1520  768 771 781 790 +hsync -vsync (47.4 kHz)
[    68.033] (II) intel(0): Modeline "1152x864"x60.0   81.62  1152 1216 1336 1520  864 865 868 895 -hsync +vsync (53.7 kHz)
[    68.033] (II) intel(0): Modeline "1024x768"x60.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    68.033] (II) intel(0): Modeline "800x600"x60.3   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    68.033] (II) intel(0): Modeline "800x600"x56.2   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    68.033] (II) intel(0): Modeline "640x480"x59.9   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    68.097] (II) intel(0): EDID for output VGA1
[    68.097] (II) intel(0): Manufacturer: IQT  Model: 703  Serial#: 3866
[    68.097] (II) intel(0): Year: 2004  Week: 5
[    68.097] (II) intel(0): EDID Version: 1.3
[    68.097] (II) intel(0): Analog Display Input,  Input Voltage Level: 0.700/0.300 V
[    68.097] (II) intel(0): Sync:  Separate
[    68.097] (II) intel(0): Max Image Size [cm]: horiz.: 33  vert.: 27
[    68.097] (II) intel(0): Gamma: 2.20
[    68.097] (II) intel(0): DPMS capabilities: StandBy Suspend Off; RGB/Color Display
[    68.097] (II) intel(0): First detailed timing not preferred mode in violation of standard!
[    68.097] (II) intel(0): redX: 0.640 redY: 0.340   greenX: 0.290 greenY: 0.610
[    68.098] (II) intel(0): blueX: 0.140 blueY: 0.070   whiteX: 0.310 whiteY: 0.330
[    68.098] (II) intel(0): Supported established timings:
[    68.098] (II) intel(0): 720x400@70Hz
[    68.098] (II) intel(0): 640x480@60Hz
[    68.098] (II) intel(0): 640x480@75Hz
[    68.098] (II) intel(0): 800x600@60Hz
[    68.098] (II) intel(0): 800x600@75Hz
[    68.098] (II) intel(0): 1024x768@60Hz
[    68.098] (II) intel(0): 1024x768@70Hz
[    68.098] (II) intel(0): 1024x768@75Hz
[    68.098] (II) intel(0): 1280x1024@75Hz
[    68.098] (II) intel(0): Manufacturer's mask: 0
[    68.098] (II) intel(0): Supported standard timings:
[    68.098] (II) intel(0): #0: hsize: 1280  vsize 1024  refresh: 60  vid: 32897
[    68.098] (II) intel(0): Supported detailed timing:
[    68.098] (II) intel(0): clock: 108.0 MHz   Image Size:  330 x 270 mm
[    68.098] (II) intel(0): h_active: 1280  h_sync: 1328  h_sync_end 1440 h_blank_end 1688 h_border: 0
[    68.098] (II) intel(0): v_active: 1024  v_sync: 1025  v_sync_end 1028 v_blanking: 1066 v_border: 0
[    68.098] (II) intel(0): Supported detailed timing:
[    68.098] (II) intel(0): clock: 28.3 MHz   Image Size:  330 x 270 mm
[    68.098] (II) intel(0): h_active: 720  h_sync: 738  h_sync_end 846 h_blank_end 900 h_border: 0
[    68.098] (II) intel(0): v_active: 400  v_sync: 413  v_sync_end 415 v_blanking: 449 v_border: 0
[    68.098] (II) intel(0): Supported detailed timing:
[    68.098] (II) intel(0): clock: 25.2 MHz   Image Size:  330 x 270 mm
[    68.098] (II) intel(0): h_active: 640  h_sync: 656  h_sync_end 752 h_blank_end 800 h_border: 0
[    68.098] (II) intel(0): v_active: 480  v_sync: 490  v_sync_end 492 v_blanking: 525 v_border: 0
[    68.098] (II) intel(0): Monitor name: L70S
[    68.098] (II) intel(0): EDID (in hex):
[    68.098] (II) intel(0): 	00ffffffffffff00263403071a0f0000
[    68.098] (II) intel(0): 	050e010308211b78e8c5c6a3574a9c23
[    68.098] (II) intel(0): 	124f54a54f0081800101010101010101
[    68.098] (II) intel(0): 	010101010101302a009851002a403070
[    68.098] (II) intel(0): 	13004a0e1100001e100bd0b420903110
[    68.098] (II) intel(0): 	126cd2004a0e1100001cd50980a020e0
[    68.098] (II) intel(0): 	2d101060a2004a0e11000018000000fc
[    68.098] (II) intel(0): 	004c3730530a20202020202020200052
[    68.098] (II) intel(0): Printing probed modes for output VGA1
[    68.098] (II) intel(0): Modeline "1280x1024"x75.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    68.098] (II) intel(0): Modeline "1280x1024"x60.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    68.098] (II) intel(0): Modeline "1024x768"x75.1   78.80  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.1 kHz)
[    68.098] (II) intel(0): Modeline "1024x768"x70.1   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    68.098] (II) intel(0): Modeline "1024x768"x60.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    68.098] (II) intel(0): Modeline "800x600"x75.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    68.098] (II) intel(0): Modeline "800x600"x60.3   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    68.099] (II) intel(0): Modeline "640x480"x75.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    68.099] (II) intel(0): Modeline "640x480"x60.0   25.20  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    68.099] (II) intel(0): Modeline "640x480"x59.9   25.17  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    68.099] (II) intel(0): Modeline "720x400"x70.1   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    68.099] (II) intel(0): Modeline "720x400"x70.1   28.32  720 738 846 900  400 413 415 449 -hsync +vsync (31.5 kHz)
[    68.099] (II) intel(0): Output LVDS1 connected
[    68.099] (II) intel(0): Output VGA1 connected
[    68.099] (II) intel(0): Using fuzzy aspect match for initial modes
[    68.099] (II) intel(0): Output LVDS1 using initial mode 1024x768
[    68.099] (II) intel(0): Output VGA1 using initial mode 1024x768
[    68.099] (II) intel(0): Using default gamma of (1.0, 1.0, 1.0) unless otherwise stated.
[    68.099] (II) intel(0): Kernel page flipping support detected, enabling
[    68.099] (**) intel(0): Display dimensions: (310, 170) mm
[    68.099] (**) intel(0): DPI set to (83, 114)
[    68.099] (II) Loading sub module "fb"
[    68.099] (II) LoadModule: "fb"
[    68.099] (II) Loading /usr/lib/xorg/modules/libfb.so
[    68.106] (II) Module fb: vendor="X.Org Foundation"
[    68.106] 	compiled for 1.10.4, module version = 1.0.0
[    68.106] 	ABI class: X.Org ANSI C Emulation, version 0.4
[    68.106] (II) Loading sub module "dri2"
[    68.106] (II) LoadModule: "dri2"
[    68.106] (II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
[    68.106] (II) Module dri2: vendor="X.Org Foundation"
[    68.106] 	compiled for 1.10.4, module version = 1.2.0
[    68.106] 	ABI class: X.Org Server Extension, version 5.0
[    68.106] (II) UnloadModule: "vesa"
[    68.106] (II) Unloading vesa
[    68.106] (II) UnloadModule: "fbdev"
[    68.106] (II) Unloading fbdev
[    68.106] (II) UnloadModule: "fbdevhw"
[    68.106] (II) Unloading fbdevhw
[    68.106] (==) Depth 24 pixmap format is 32 bpp
[    68.106] (II) intel(0): [DRI2] Setup complete
[    68.107] (II) intel(0): [DRI2]   DRI driver: i965
[    68.107] (II) intel(0): Allocated new frame buffer 1024x768 stride 4096, tiled
[    68.115] (II) UXA(0): Driver registered support for the following operations:
[    68.115] (II)         solid
[    68.115] (II)         copy
[    68.115] (II)         composite (RENDER acceleration)
[    68.115] (II)         put_image
[    68.115] (II)         get_image
[    68.115] (==) intel(0): Backing store disabled
[    68.115] (==) intel(0): Silken mouse enabled
[    68.116] (II) intel(0): Initializing HW Cursor
[    68.742] (II) intel(0): RandR 1.2 enabled, ignore the following RandR disabled message.
[    68.812] (==) intel(0): DPMS enabled
[    68.812] (II) intel(0): Set up textured video
[    68.812] (II) intel(0): direct rendering: DRI2 Enabled
[    68.812] (WW) intel(0): Option "XvMC" is not used
[    68.812] (==) intel(0): hotplug detection: "enabled"
[    68.812] (--) RandR disabled
[    68.812] (II) Initializing built-in extension Generic Event Extension
[    68.812] (II) Initializing built-in extension SHAPE
[    68.812] (II) Initializing built-in extension MIT-SHM
[    68.812] (II) Initializing built-in extension XInputExtension
[    68.812] (II) Initializing built-in extension XTEST
[    68.812] (II) Initializing built-in extension BIG-REQUESTS
[    68.812] (II) Initializing built-in extension SYNC
[    68.812] (II) Initializing built-in extension XKEYBOARD
[    68.812] (II) Initializing built-in extension XC-MISC
[    68.812] (II) Initializing built-in extension SECURITY
[    68.812] (II) Initializing built-in extension XINERAMA
[    68.812] (II) Initializing built-in extension XFIXES
[    68.812] (II) Initializing built-in extension RENDER
[    68.812] (II) Initializing built-in extension RANDR
[    68.812] (II) Initializing built-in extension COMPOSITE
[    68.812] (II) Initializing built-in extension DAMAGE
[    68.813] (II) SELinux: Disabled on system
[    68.861] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[    68.861] (II) AIGLX: enabled GLX_INTEL_swap_event
[    68.861] (II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_control
[    68.861] (II) AIGLX: enabled GLX_SGI_make_current_read
[    68.861] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects
[    68.861] (II) AIGLX: Loaded and initialized /usr/lib/x86_64-linux-gnu/dri/i965_dri.so
[    68.861] (II) GLX: Initialized DRI2 GL provider for screen 0
[    68.862] (II) intel(0): Setting screen physical size to 270 x 203
[    69.058] (II) config/udev: Adding input device Power Button (/dev/input/event4)
[    69.059] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    69.059] (II) LoadModule: "evdev"
[    69.059] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    69.062] (II) Module evdev: vendor="X.Org Foundation"
[    69.062] 	compiled for 1.10.1, module version = 2.6.0
[    69.062] 	Module class: X.Org XInput Driver
[    69.062] 	ABI class: X.Org XInput driver, version 12.2
[    69.062] (II) Using input driver 'evdev' for 'Power Button'
[    69.062] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    69.062] (**) Power Button: always reports core events
[    69.062] (**) Power Button: Device: "/dev/input/event4"
[    69.062] (--) Power Button: Found keys
[    69.062] (II) Power Button: Configuring as keyboard
[    69.062] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input4/event4"
[    69.062] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
[    69.062] (**) Option "xkb_rules" "evdev"
[    69.062] (**) Option "xkb_model" "geniuskb19e"
[    69.062] (**) Option "xkb_layout" "fr,brai"
[    69.062] (**) Option "xkb_variant" "oss,"
[    69.062] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    69.116] (II) config/udev: Adding input device Video Bus (/dev/input/event9)
[    69.116] (**) Video Bus: Applying InputClass "evdev keyboard catchall"
[    69.116] (II) Using input driver 'evdev' for 'Video Bus'
[    69.116] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    69.116] (**) Video Bus: always reports core events
[    69.116] (**) Video Bus: Device: "/dev/input/event9"
[    69.116] (--) Video Bus: Found keys
[    69.116] (II) Video Bus: Configuring as keyboard
[    69.116] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input9/event9"
[    69.116] (II) XINPUT: Adding extended input device "Video Bus" (type: KEYBOARD)
[    69.116] (**) Option "xkb_rules" "evdev"
[    69.116] (**) Option "xkb_model" "geniuskb19e"
[    69.116] (**) Option "xkb_layout" "fr,brai"
[    69.116] (**) Option "xkb_variant" "oss,"
[    69.116] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    69.117] (II) config/udev: Adding input device Video Bus (/dev/input/event8)
[    69.117] (**) Video Bus: Applying InputClass "evdev keyboard catchall"
[    69.117] (II) Using input driver 'evdev' for 'Video Bus'
[    69.117] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    69.117] (**) Video Bus: always reports core events
[    69.117] (**) Video Bus: Device: "/dev/input/event8"
[    69.117] (--) Video Bus: Found keys
[    69.117] (II) Video Bus: Configuring as keyboard
[    69.117] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:13/LNXVIDEO:00/input/input8/event8"
[    69.117] (II) XINPUT: Adding extended input device "Video Bus" (type: KEYBOARD)
[    69.117] (**) Option "xkb_rules" "evdev"
[    69.117] (**) Option "xkb_model" "geniuskb19e"
[    69.117] (**) Option "xkb_layout" "fr,brai"
[    69.117] (**) Option "xkb_variant" "oss,"
[    69.117] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    69.121] (II) config/udev: Adding input device Power Button (/dev/input/event2)
[    69.121] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    69.121] (II) Using input driver 'evdev' for 'Power Button'
[    69.121] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    69.121] (**) Power Button: always reports core events
[    69.121] (**) Power Button: Device: "/dev/input/event2"
[    69.121] (--) Power Button: Found keys
[    69.121] (II) Power Button: Configuring as keyboard
[    69.121] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2/event2"
[    69.121] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
[    69.121] (**) Option "xkb_rules" "evdev"
[    69.121] (**) Option "xkb_model" "geniuskb19e"
[    69.121] (**) Option "xkb_layout" "fr,brai"
[    69.121] (**) Option "xkb_variant" "oss,"
[    69.121] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    69.121] (II) config/udev: Adding input device Lid Switch (/dev/input/event1)
[    69.121] (II) No input driver/identifier specified (ignoring)
[    69.122] (II) config/udev: Adding input device Sleep Button (/dev/input/event3)
[    69.122] (**) Sleep Button: Applying InputClass "evdev keyboard catchall"
[    69.122] (II) Using input driver 'evdev' for 'Sleep Button'
[    69.122] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    69.122] (**) Sleep Button: always reports core events
[    69.122] (**) Sleep Button: Device: "/dev/input/event3"
[    69.122] (--) Sleep Button: Found keys
[    69.122] (II) Sleep Button: Configuring as keyboard
[    69.122] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3/event3"
[    69.122] (II) XINPUT: Adding extended input device "Sleep Button" (type: KEYBOARD)
[    69.122] (**) Option "xkb_rules" "evdev"
[    69.122] (**) Option "xkb_model" "geniuskb19e"
[    69.122] (**) Option "xkb_layout" "fr,brai"
[    69.122] (**) Option "xkb_variant" "oss,"
[    69.122] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    69.122] (II) config/udev: Adding input device HDA NVidia HDMI/DP (/dev/input/event15)
[    69.122] (II) No input driver/identifier specified (ignoring)
[    69.123] (II) config/udev: Adding input device HDA NVidia HDMI/DP (/dev/input/event16)
[    69.123] (II) No input driver/identifier specified (ignoring)
[    69.123] (II) config/udev: Adding input device HDA NVidia HDMI/DP (/dev/input/event17)
[    69.123] (II) No input driver/identifier specified (ignoring)
[    69.124] (II) config/udev: Adding input device HDA Digital PCBeep (/dev/input/event10)
[    69.124] (II) No input driver/identifier specified (ignoring)
[    69.124] (II) config/udev: Adding input device HDA Intel PCH Mic at Sep Left Jack (/dev/input/event11)
[    69.124] (II) No input driver/identifier specified (ignoring)
[    69.124] (II) config/udev: Adding input device HDA Intel PCH Mic at Ext Left Jack (/dev/input/event12)
[    69.124] (II) No input driver/identifier specified (ignoring)
[    69.125] (II) config/udev: Adding input device HDA Intel PCH Line Out at Sep Left Jack (/dev/input/event13)
[    69.125] (II) No input driver/identifier specified (ignoring)
[    69.125] (II) config/udev: Adding input device HDA Intel PCH HP Out at Ext Left Jack (/dev/input/event14)
[    69.125] (II) No input driver/identifier specified (ignoring)
[    69.126] (II) config/udev: Adding input device spca561 (/dev/input/event22)
[    69.126] (**) spca561: Applying InputClass "evdev keyboard catchall"
[    69.126] (II) Using input driver 'evdev' for 'spca561'
[    69.126] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    69.126] (**) spca561: always reports core events
[    69.126] (**) spca561: Device: "/dev/input/event22"
[    69.126] (--) spca561: Found keys
[    69.126] (II) spca561: Configuring as keyboard
[    69.126] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1.1/2-1.1.1.1/input/input22/event22"
[    69.126] (II) XINPUT: Adding extended input device "spca561" (type: KEYBOARD)
[    69.126] (**) Option "xkb_rules" "evdev"
[    69.126] (**) Option "xkb_model" "geniuskb19e"
[    69.126] (**) Option "xkb_layout" "fr,brai"
[    69.126] (**) Option "xkb_variant" "oss,"
[    69.126] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    69.126] (II) config/udev: Adding input device Logitech USB-PS/2 Optical Mouse (/dev/input/event20)
[    69.126] (**) Logitech USB-PS/2 Optical Mouse: Applying InputClass "evdev pointer catchall"
[    69.126] (II) Using input driver 'evdev' for 'Logitech USB-PS/2 Optical Mouse'
[    69.126] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    69.126] (**) Logitech USB-PS/2 Optical Mouse: always reports core events
[    69.126] (**) Logitech USB-PS/2 Optical Mouse: Device: "/dev/input/event20"
[    69.126] (--) Logitech USB-PS/2 Optical Mouse: Found 12 mouse buttons
[    69.126] (--) Logitech USB-PS/2 Optical Mouse: Found scroll wheel(s)
[    69.126] (--) Logitech USB-PS/2 Optical Mouse: Found relative axes
[    69.126] (--) Logitech USB-PS/2 Optical Mouse: Found x and y relative axes
[    69.126] (II) Logitech USB-PS/2 Optical Mouse: Configuring as mouse
[    69.126] (II) Logitech USB-PS/2 Optical Mouse: Adding scrollwheel support
[    69.126] (**) Logitech USB-PS/2 Optical Mouse: YAxisMapping: buttons 4 and 5
[    69.126] (**) Logitech USB-PS/2 Optical Mouse: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[    69.127] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1.1/2-1.1.1.2/2-1.1.1.2:1.0/input/input20/event20"
[    69.127] (II) XINPUT: Adding extended input device "Logitech USB-PS/2 Optical Mouse" (type: MOUSE)
[    69.127] (II) Logitech USB-PS/2 Optical Mouse: initialized for relative axes.
[    69.127] (**) Logitech USB-PS/2 Optical Mouse: (accel) keeping acceleration scheme 1
[    69.127] (**) Logitech USB-PS/2 Optical Mouse: (accel) acceleration profile 0
[    69.127] (**) Logitech USB-PS/2 Optical Mouse: (accel) acceleration factor: 2.000
[    69.127] (**) Logitech USB-PS/2 Optical Mouse: (accel) acceleration threshold: 4
[    69.127] (II) config/udev: Adding input device Logitech USB-PS/2 Optical Mouse (/dev/input/mouse2)
[    69.127] (II) No input driver/identifier specified (ignoring)
[    69.127] (II) config/udev: Adding input device ABBHOME (/dev/input/event19)
[    69.127] (**) ABBHOME: Applying InputClass "evdev pointer catchall"
[    69.127] (**) ABBHOME: Applying InputClass "evdev keyboard catchall"
[    69.127] (II) Using input driver 'evdev' for 'ABBHOME'
[    69.127] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    69.127] (**) ABBHOME: always reports core events
[    69.127] (**) ABBHOME: Device: "/dev/input/event19"
[    69.127] (--) ABBHOME: Found 3 mouse buttons
[    69.127] (--) ABBHOME: Found scroll wheel(s)
[    69.127] (--) ABBHOME: Found relative axes
[    69.127] (--) ABBHOME: Found x and y relative axes
[    69.127] (--) ABBHOME: Found absolute axes
[    69.127] (--) ABBHOME: Found keys
[    69.127] (II) ABBHOME: Configuring as mouse
[    69.127] (II) ABBHOME: Configuring as keyboard
[    69.127] (II) ABBHOME: Adding scrollwheel support
[    69.127] (**) ABBHOME: YAxisMapping: buttons 4 and 5
[    69.127] (**) ABBHOME: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[    69.127] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1.3/2-1.1.3:1.0/input/input19/event19"
[    69.127] (II) XINPUT: Adding extended input device "ABBHOME" (type: KEYBOARD)
[    69.127] (**) Option "xkb_rules" "evdev"
[    69.127] (**) Option "xkb_model" "geniuskb19e"
[    69.127] (**) Option "xkb_layout" "fr,brai"
[    69.127] (**) Option "xkb_variant" "oss,"
[    69.127] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    69.127] (II) ABBHOME: initialized for relative axes.
[    69.127] (WW) ABBHOME: ignoring absolute axes.
[    69.128] (**) ABBHOME: (accel) keeping acceleration scheme 1
[    69.128] (**) ABBHOME: (accel) acceleration profile 0
[    69.128] (**) ABBHOME: (accel) acceleration factor: 2.000
[    69.128] (**) ABBHOME: (accel) acceleration threshold: 4
[    69.128] (II) config/udev: Adding input device ABBHOME (/dev/input/mouse1)
[    69.128] (II) No input driver/identifier specified (ignoring)
[    69.131] (II) config/udev: Adding input device AT Translated Set 2 keyboard (/dev/input/event0)
[    69.131] (**) AT Translated Set 2 keyboard: Applying InputClass "evdev keyboard catchall"
[    69.131] (II) Using input driver 'evdev' for 'AT Translated Set 2 keyboard'
[    69.131] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    69.131] (**) AT Translated Set 2 keyboard: always reports core events
[    69.131] (**) AT Translated Set 2 keyboard: Device: "/dev/input/event0"
[    69.131] (--) AT Translated Set 2 keyboard: Found keys
[    69.131] (II) AT Translated Set 2 keyboard: Configuring as keyboard
[    69.131] (**) Option "config_info" "udev:/sys/devices/platform/i8042/serio0/input/input0/event0"
[    69.131] (II) XINPUT: Adding extended input device "AT Translated Set 2 keyboard" (type: KEYBOARD)
[    69.131] (**) Option "xkb_rules" "evdev"
[    69.131] (**) Option "xkb_model" "geniuskb19e"
[    69.131] (**) Option "xkb_layout" "fr,brai"
[    69.131] (**) Option "xkb_variant" "oss,"
[    69.131] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    69.131] (II) config/udev: Adding input device PS/2 Generic Mouse (/dev/input/event7)
[    69.131] (**) PS/2 Generic Mouse: Applying InputClass "evdev pointer catchall"
[    69.131] (II) Using input driver 'evdev' for 'PS/2 Generic Mouse'
[    69.131] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    69.131] (**) PS/2 Generic Mouse: always reports core events
[    69.131] (**) PS/2 Generic Mouse: Device: "/dev/input/event7"
[    69.131] (--) PS/2 Generic Mouse: Found 3 mouse buttons
[    69.131] (--) PS/2 Generic Mouse: Found relative axes
[    69.131] (--) PS/2 Generic Mouse: Found x and y relative axes
[    69.132] (II) PS/2 Generic Mouse: Configuring as mouse
[    69.132] (**) PS/2 Generic Mouse: YAxisMapping: buttons 4 and 5
[    69.132] (**) PS/2 Generic Mouse: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[    69.132] (**) Option "config_info" "udev:/sys/devices/platform/i8042/serio1/input/input7/event7"
[    69.132] (II) XINPUT: Adding extended input device "PS/2 Generic Mouse" (type: MOUSE)
[    69.132] (II) PS/2 Generic Mouse: initialized for relative axes.
[    69.132] (**) PS/2 Generic Mouse: (accel) keeping acceleration scheme 1
[    69.132] (**) PS/2 Generic Mouse: (accel) acceleration profile 0
[    69.132] (**) PS/2 Generic Mouse: (accel) acceleration factor: 2.000
[    69.132] (**) PS/2 Generic Mouse: (accel) acceleration threshold: 4
[    69.132] (II) config/udev: Adding input device PS/2 Generic Mouse (/dev/input/mouse0)
[    69.132] (II) No input driver/identifier specified (ignoring)
[    69.132] (II) config/udev: Adding input device PC Speaker (/dev/input/event5)
[    69.132] (II) No input driver/identifier specified (ignoring)
[    69.133] (II) config/udev: Adding input device Speakup (/dev/input/event18)
[    69.133] (**) Speakup: Applying InputClass "evdev keyboard catchall"
[    69.133] (II) Using input driver 'evdev' for 'Speakup'
[    69.133] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    69.133] (**) Speakup: always reports core events
[    69.133] (**) Speakup: Device: "/dev/input/event18"
[    69.133] (--) Speakup: Found keys
[    69.133] (II) Speakup: Configuring as keyboard
[    69.133] (**) Option "config_info" "udev:/sys/devices/virtual/input/input18/event18"
[    69.133] (II) XINPUT: Adding extended input device "Speakup" (type: KEYBOARD)
[    69.133] (**) Option "xkb_rules" "evdev"
[    69.133] (**) Option "xkb_model" "geniuskb19e"
[    69.133] (**) Option "xkb_layout" "fr,brai"
[    69.133] (**) Option "xkb_variant" "oss,"
[    69.133] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    69.134] (II) config/udev: Adding input device ACPI Virtual Keyboard Device (/dev/input/event21)
[    69.134] (**) ACPI Virtual Keyboard Device: Applying InputClass "evdev keyboard catchall"
[    69.134] (II) Using input driver 'evdev' for 'ACPI Virtual Keyboard Device'
[    69.134] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    69.134] (**) ACPI Virtual Keyboard Device: always reports core events
[    69.134] (**) ACPI Virtual Keyboard Device: Device: "/dev/input/event21"
[    69.134] (--) ACPI Virtual Keyboard Device: Found keys
[    69.134] (II) ACPI Virtual Keyboard Device: Configuring as keyboard
[    69.134] (**) Option "config_info" "udev:/sys/devices/virtual/input/input21/event21"
[    69.134] (II) XINPUT: Adding extended input device "ACPI Virtual Keyboard Device" (type: KEYBOARD)
[    69.134] (**) Option "xkb_rules" "evdev"
[    69.134] (**) Option "xkb_model" "geniuskb19e"
[    69.134] (**) Option "xkb_layout" "fr,brai"
[    69.134] (**) Option "xkb_variant" "oss,"
[    69.134] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    69.134] (II) config/udev: Adding input device Dell WMI hotkeys (/dev/input/event6)
[    69.134] (**) Dell WMI hotkeys: Applying InputClass "evdev keyboard catchall"
[    69.134] (II) Using input driver 'evdev' for 'Dell WMI hotkeys'
[    69.134] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    69.134] (**) Dell WMI hotkeys: always reports core events
[    69.134] (**) Dell WMI hotkeys: Device: "/dev/input/event6"
[    69.134] (--) Dell WMI hotkeys: Found keys
[    69.134] (II) Dell WMI hotkeys: Configuring as keyboard
[    69.134] (**) Option "config_info" "udev:/sys/devices/virtual/input/input6/event6"
[    69.134] (II) XINPUT: Adding extended input device "Dell WMI hotkeys" (type: KEYBOARD)
[    69.134] (**) Option "xkb_rules" "evdev"
[    69.134] (**) Option "xkb_model" "geniuskb19e"
[    69.134] (**) Option "xkb_layout" "fr,brai"
[    69.134] (**) Option "xkb_variant" "oss,"
[    69.134] (**) Option "xkb_options" "compose:lwin,compose:rwin,nbsp:level3n,grp:shift_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp"
[    69.349] (II) intel(0): EDID vendor "IQT", prod id 1795
[    69.349] (II) intel(0): Printing DDC gathered Modelines:
[    69.349] (II) intel(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    69.349] (II) intel(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 413 415 449 -hsync +vsync (31.5 kHz)
[    69.349] (II) intel(0): Modeline "640x480"x0.0   25.17  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    69.349] (II) intel(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    69.349] (II) intel(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    69.349] (II) intel(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    69.349] (II) intel(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    69.349] (II) intel(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    69.349] (II) intel(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    69.349] (II) intel(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    69.349] (II) intel(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    69.349] (II) intel(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    69.350] (II) intel(0): Allocated new frame buffer 1600x1024 stride 6656, tiled
[    70.164] (II) intel(0): EDID vendor "IQT", prod id 1795
[    70.165] (II) intel(0): Printing DDC gathered Modelines:
[    70.165] (II) intel(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    70.165] (II) intel(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 413 415 449 -hsync +vsync (31.5 kHz)
[    70.165] (II) intel(0): Modeline "640x480"x0.0   25.17  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    70.165] (II) intel(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    70.165] (II) intel(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    70.165] (II) intel(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    70.165] (II) intel(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    70.165] (II) intel(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    70.165] (II) intel(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    70.165] (II) intel(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    70.165] (II) intel(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    70.165] (II) intel(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    70.167] (II) intel(0): Allocated new frame buffer 1600x1924 stride 6656, tiled
[    78.496] (II) Power Button: Close
[    78.496] (II) UnloadModule: "evdev"
[    78.496] (II) Unloading evdev
[    78.524] (II) Video Bus: Close
[    78.524] (II) UnloadModule: "evdev"
[    78.524] (II) Unloading evdev
[    78.564] (II) Video Bus: Close
[    78.564] (II) UnloadModule: "evdev"
[    78.564] (II) Unloading evdev
[    78.624] (II) Power Button: Close
[    78.624] (II) UnloadModule: "evdev"
[    78.624] (II) Unloading evdev
[    78.688] (II) Sleep Button: Close
[    78.688] (II) UnloadModule: "evdev"
[    78.688] (II) Unloading evdev
[    78.816] (II) spca561: Close
[    78.816] (II) UnloadModule: "evdev"
[    78.816] (II) Unloading evdev
[    78.860] (II) Logitech USB-PS/2 Optical Mouse: Close
[    78.860] (II) UnloadModule: "evdev"
[    78.860] (II) Unloading evdev
[    78.860] (II) ABBHOME: Close
[    78.860] (II) UnloadModule: "evdev"
[    78.860] (II) Unloading evdev
[    78.860] (II) AT Translated Set 2 keyboard: Close
[    78.860] (II) UnloadModule: "evdev"
[    78.860] (II) Unloading evdev
[    78.860] (II) PS/2 Generic Mouse: Close
[    78.860] (II) UnloadModule: "evdev"
[    78.861] (II) Unloading evdev
[    78.861] (II) Speakup: Close
[    78.861] (II) UnloadModule: "evdev"
[    78.861] (II) Unloading evdev
[    78.861] (II) ACPI Virtual Keyboard Device: Close
[    78.861] (II) UnloadModule: "evdev"
[    78.861] (II) Unloading evdev
[    78.861] (II) Dell WMI hotkeys: Close
[    78.861] (II) UnloadModule: "evdev"
[    78.861] (II) Unloading evdev

--+QahgC5+KEYLbs62--
