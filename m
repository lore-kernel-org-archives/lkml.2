Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab1CNS0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 14:26:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:7642 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab1CNS0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 14:26:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,317,1297065600"; 
   d="txt'?scan'208";a="612826753"
Date: Mon, 14 Mar 2011 11:26:36 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFT][PATCH] PCI / ACPI: Do not require MSI support for PCIe
 native features
Message-ID: <20110314182636.GA4069@xanatos>
References: <201103052254.48515.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <201103052254.48515.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Rafael,

I applied this patch, on top of this patch:
PCI/ACPI: Report ASPM support to BIOS if not disabled from command line

Unfortunately, the Express Card still doesn't show up.  The trace looks
slightly different, but the irq still gets disabled.  dmesg is attached.

Sarah Sharp

On Sat, Mar 05, 2011 at 10:54:48PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> After commit 415e12b2379239973feab91850b0dce985c6058a
> (PCI/ACPI: Request _OSC control once for each root bridge (v3)) we
> require MSI to be supported so that we use _OSC to request control
> of PCIe native features (hotplug, AER, PME), but that appears to
> be overkill and causes problems to happen on some systems.  For
> this reason, request control of PCIe native features via _OSC
> even if MSI support is not enabled.
> 
> Reported-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
> 
> Hi,
> 
> Sarah, please test this patch on your machine causing PCIe hotplug
> problems on top of the patch from https://patchwork.kernel.org/patch/612171/
> and on top of 2.6.38-rc6 or later.
> 
> Thanks,
> Rafael
> 
> ---
>  drivers/acpi/pci_root.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> Index: linux-2.6/drivers/acpi/pci_root.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/pci_root.c
> +++ linux-2.6/drivers/acpi/pci_root.c
> @@ -50,8 +50,7 @@ static int acpi_pci_root_start(struct ac
>  
>  #define ACPI_PCIE_REQ_SUPPORT (OSC_EXT_PCI_CONFIG_SUPPORT \
>  				| OSC_ACTIVE_STATE_PWR_SUPPORT \
> -				| OSC_CLOCK_PWR_CAPABILITY_SUPPORT \
> -				| OSC_MSI_SUPPORT)
> +				| OSC_CLOCK_PWR_CAPABILITY_SUPPORT)
>  
>  static const struct acpi_device_id root_device_ids[] = {
>  	{"PNP0A03", 0},
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.38-rc8+ (sarah@xanatos) (gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5) ) #773 SMP PREEMPT Mon Mar 14 11:15:00 PDT 2011
[    0.000000] Command line: root=UUID=7b14f772-a799-415f-a4c9-931ef81f6f0d ro  
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bd6a1000 (usable)
[    0.000000]  BIOS-e820: 00000000bd6a1000 - 00000000bd6a7000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd6a7000 - 00000000bd7b7000 (usable)
[    0.000000]  BIOS-e820: 00000000bd7b7000 - 00000000bd80f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd80f000 - 00000000bd8c7000 (usable)
[    0.000000]  BIOS-e820: 00000000bd8c7000 - 00000000bd8d2000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd8d2000 - 00000000bd8d5000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd8d5000 - 00000000bd8d9000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd8d9000 - 00000000bd8dd000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd8dd000 - 00000000bd8e0000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd8e0000 - 00000000bd907000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd907000 - 00000000bd908000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd908000 - 00000000bdb0f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bdb0f000 - 00000000bdb9f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bdb9f000 - 00000000bdbff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bdbff000 - 00000000bdc00000 (usable)
[    0.000000]  BIOS-e820: 00000000bdc00000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: LENOVO 74663HU/74663HU, BIOS 6DET44WW (2.08 ) 04/22/2009
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x13c000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-DBFFF uncachable
[    0.000000]   DC000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 13C000000 mask FFC000000 uncachable
[    0.000000]   1 base 0BE000000 mask FFE000000 uncachable
[    0.000000]   2 base 000000000 mask F80000000 write-back
[    0.000000]   3 base 080000000 mask FC0000000 write-back
[    0.000000]   4 base 100000000 mask FC0000000 write-back
[    0.000000]   5 base 0BDE00000 mask FFFE00000 uncachable
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000bde00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbdc00 max_arch_pfn = 0x400000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bdc00000
[    0.000000]  0000000000 - 00bdc00000 page 2M
[    0.000000] kernel direct mapping tables up to bdc00000 @ 1fffc000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-000000013c000000
[    0.000000]  0100000000 - 013c000000 page 2M
[    0.000000] kernel direct mapping tables up to 13c000000 @ bd8c1000-bd8c7000
[    0.000000] RAMDISK: 36323000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f7380 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000bdb7bdd4 00094 (v01 LENOVO TP-6D    00002080  LTP 00000000)
[    0.000000] ACPI: FACP 00000000bdb7bf00 000F4 (v03 LENOVO TP-6D    00002080 LNVO 00000001)
[    0.000000] ACPI: DSDT 00000000bdb7c2f4 0D881 (v01 LENOVO TP-6D    00002080 MSFT 03000000)
[    0.000000] ACPI: FACS 00000000bdb8e000 00040
[    0.000000] ACPI: SSDT 00000000bdb7c0b4 00240 (v01 LENOVO TP-6D    00002080 MSFT 03000000)
[    0.000000] ACPI: ECDT 00000000bdb89b75 00052 (v01 LENOVO TP-6D    00002080 LNVO 00000001)
[    0.000000] ACPI: APIC 00000000bdb89bc7 00078 (v01 LENOVO TP-6D    00002080 LNVO 00000001)
[    0.000000] ACPI: MCFG 00000000bdb89c3f 0003C (v01 LENOVO TP-6D    00002080 LNVO 00000001)
[    0.000000] ACPI: HPET 00000000bdb89c7b 00038 (v01 LENOVO TP-6D    00002080 LNVO 00000001)
[    0.000000] ACPI: SLIC 00000000bdb89dc2 00176 (v01 LENOVO TP-6D    00002080  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000bdb89f38 00028 (v01 LENOVO TP-6D    00002080  LTP 00000001)
[    0.000000] ACPI: ASF! 00000000bdb89f60 000A0 (v16 LENOVO TP-6D    00002080 PTL  00000001)
[    0.000000] ACPI: SSDT 00000000bdb8d203 0055F (v01 LENOVO TP-6D    00002080 INTL 20050513)
[    0.000000] ACPI: TCPA 00000000bd907000 00032 (v00                 00000000      00000000)
[    0.000000] ACPI: SSDT 00000000bd8d4000 00655 (v01  PmRef    CpuPm 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd8d3000 00274 (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd8d2000 00242 (v01  PmRef    ApTst 00003000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff8800b0000000-ffff8800b37fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0013c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[6] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bd6a1
[    0.000000]     0: 0x000bd6a7 -> 0x000bd7b7
[    0.000000]     0: 0x000bd80f -> 0x000bd8c7
[    0.000000]     0: 0x000bdbff -> 0x000bdc00
[    0.000000]     0: 0x00100000 -> 0x0013c000
[    0.000000] On node 0 totalpages: 1021944
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3920 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 757922 pages, LIFO batch:31
[    0.000000]   Normal zone: 3360 pages used for memmap
[    0.000000]   Normal zone: 242400 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] 4 Processors exceeds NR_CPUS limit of 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bd6a1000 - 00000000bd6a7000
[    0.000000] PM: Registered nosave memory: 00000000bd7b7000 - 00000000bd80f000
[    0.000000] PM: Registered nosave memory: 00000000bd8c7000 - 00000000bd8d2000
[    0.000000] PM: Registered nosave memory: 00000000bd8d2000 - 00000000bd8d5000
[    0.000000] PM: Registered nosave memory: 00000000bd8d5000 - 00000000bd8d9000
[    0.000000] PM: Registered nosave memory: 00000000bd8d9000 - 00000000bd8dd000
[    0.000000] PM: Registered nosave memory: 00000000bd8dd000 - 00000000bd8e0000
[    0.000000] PM: Registered nosave memory: 00000000bd8e0000 - 00000000bd907000
[    0.000000] PM: Registered nosave memory: 00000000bd907000 - 00000000bd908000
[    0.000000] PM: Registered nosave memory: 00000000bd908000 - 00000000bdb0f000
[    0.000000] PM: Registered nosave memory: 00000000bdb0f000 - 00000000bdb9f000
[    0.000000] PM: Registered nosave memory: 00000000bdb9f000 - 00000000bdbff000
[    0.000000] PM: Registered nosave memory: 00000000bdc00000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff800000
[    0.000000] PM: Registered nosave memory: 00000000ff800000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff8800bd400000 s75840 r8192 d22464 u1048576
[    0.000000] pcpu-alloc: s75840 r8192 d22464 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1004242
[    0.000000] Kernel command line: root=UUID=7b14f772-a799-415f-a4c9-931ef81f6f0d ro  
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3911412k/5177344k available (4769k kernel code, 1089568k absent, 176364k reserved, 3936k data, 524k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:320
[    0.000000] Extended CMOS year: 2000
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
[    0.000000]  memory used by lock dependency info: 5823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] allocated 41943040 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1862.079 MHz processor.
[    0.004004] Calibrating delay loop (skipped), value calculated using timer frequency.. 3724.15 BogoMIPS (lpj=7448316)
[    0.004098] pid_max: default: 32768 minimum: 301
[    0.004465] Mount-cache hash table entries: 256
[    0.005743] Initializing cgroup subsys ns
[    0.005791] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.005860] Initializing cgroup subsys cpuacct
[    0.005920] Initializing cgroup subsys memory
[    0.006069] Initializing cgroup subsys freezer
[    0.006285] CPU: Physical Processor ID: 0
[    0.006330] CPU: Processor Core ID: 0
[    0.006376] using mwait in idle threads.
[    0.006474] ACPI: Core revision 20110112
[    0.156286] Setting APIC routing to flat
[    0.156799] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.197302] CPU0: Intel(R) Core(TM)2 Duo CPU     L9400  @ 1.86GHz stepping 0a
[    0.200011] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.200011] ... version:                2
[    0.200011] ... bit width:              40
[    0.200011] ... generic registers:      2
[    0.200011] ... value mask:             000000ffffffffff
[    0.200011] ... max period:             000000007fffffff
[    0.200011] ... fixed-purpose events:   3
[    0.200011] ... event mask:             0000000700000003
[    0.212174] NMI watchdog enabled, takes one hw-pmu counter.
[    0.224029] lockdep: fixing up alternatives.
[    0.228109] Booting Node   0, Processors  #1 Ok.
[    0.320091] NMI watchdog enabled, takes one hw-pmu counter.
[    0.324030] Brought up 2 CPUs
[    0.324079] Total of 2 processors activated (7448.07 BogoMIPS).
[    0.328847] NET: Registered protocol family 16
[    0.331128] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.331197] ACPI: bus type pci registered
[    0.331881] PCI: Using configuration type 1 for base access
[    0.345139] bio: create slab <bio-0> at 0
[    0.354271] ACPI: EC: EC description table is found, configuring boot EC
[    0.483653] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.537100] ACPI: SSDT 00000000bd8d7c20 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.540419] ACPI: Dynamic OEM Table Load:
[    0.540532] ACPI: SSDT           (null) 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.544565] ACPI: SSDT 00000000bd8d5020 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.549565] ACPI: Dynamic OEM Table Load:
[    0.549678] ACPI: SSDT           (null) 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.581317] ACPI: SSDT 00000000bd8d6ca0 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.585384] ACPI: Dynamic OEM Table Load:
[    0.585497] ACPI: SSDT           (null) 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.603648] ACPI: SSDT 00000000bd8d6f20 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.606286] ACPI: Dynamic OEM Table Load:
[    0.606399] ACPI: SSDT           (null) 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.626744] ACPI: Interpreter enabled
[    0.626793] ACPI: (supports S0 S3 S4 S5)
[    0.627350] ACPI: Using IOAPIC for interrupt routing
[    0.701276] ACPI: Power Resource [PUBS] (on)
[    0.763362] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.801453] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.801506] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.808427] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.809255] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.809308] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.809360] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.809424] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    0.809486] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    0.809550] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfebfffff]
[    0.809696] pci 0000:00:00.0: [8086:2a40] type 0 class 0x000600
[    0.809787] pci 0000:00:02.0: [8086:2a42] type 0 class 0x000300
[    0.809808] pci 0000:00:02.0: reg 10: [mem 0xf2000000-0xf23fffff 64bit]
[    0.809821] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.809830] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.809897] pci 0000:00:02.1: [8086:2a43] type 0 class 0x000380
[    0.809914] pci 0000:00:02.1: reg 10: [mem 0xf2400000-0xf24fffff 64bit]
[    0.810007] pci 0000:00:03.0: [8086:2a44] type 0 class 0x000780
[    0.810031] pci 0000:00:03.0: reg 10: [mem 0xf2826800-0xf282680f 64bit]
[    0.810096] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.810101] pci 0000:00:03.0: PME# disabled
[    0.810145] pci 0000:00:03.2: [8086:2a46] type 0 class 0x000101
[    0.810165] pci 0000:00:03.2: reg 10: [io  0x1828-0x182f]
[    0.810176] pci 0000:00:03.2: reg 14: [io  0x180c-0x180f]
[    0.810186] pci 0000:00:03.2: reg 18: [io  0x1820-0x1827]
[    0.810197] pci 0000:00:03.2: reg 1c: [io  0x1808-0x180b]
[    0.810208] pci 0000:00:03.2: reg 20: [io  0x1810-0x181f]
[    0.810287] pci 0000:00:03.3: [8086:2a47] type 0 class 0x000700
[    0.810308] pci 0000:00:03.3: reg 10: [io  0x1830-0x1837]
[    0.810319] pci 0000:00:03.3: reg 14: [mem 0xf2624000-0xf2624fff]
[    0.810479] pci 0000:00:19.0: [8086:10f5] type 0 class 0x000200
[    0.810512] pci 0000:00:19.0: reg 10: [mem 0xf2600000-0xf261ffff]
[    0.810528] pci 0000:00:19.0: reg 14: [mem 0xf2625000-0xf2625fff]
[    0.810543] pci 0000:00:19.0: reg 18: [io  0x1840-0x185f]
[    0.810635] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.810641] pci 0000:00:19.0: PME# disabled
[    0.810689] pci 0000:00:1a.0: [8086:2937] type 0 class 0x000c03
[    0.810763] pci 0000:00:1a.0: reg 20: [io  0x1860-0x187f]
[    0.810856] pci 0000:00:1a.1: [8086:2938] type 0 class 0x000c03
[    0.810930] pci 0000:00:1a.1: reg 20: [io  0x1880-0x189f]
[    0.811021] pci 0000:00:1a.2: [8086:2939] type 0 class 0x000c03
[    0.811096] pci 0000:00:1a.2: reg 20: [io  0x18a0-0x18bf]
[    0.811202] pci 0000:00:1a.7: [8086:293c] type 0 class 0x000c03
[    0.811236] pci 0000:00:1a.7: reg 10: [mem 0xf2826c00-0xf2826fff]
[    0.811352] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.811359] pci 0000:00:1a.7: PME# disabled
[    0.811414] pci 0000:00:1b.0: [8086:293e] type 0 class 0x000403
[    0.811440] pci 0000:00:1b.0: reg 10: [mem 0xf2620000-0xf2623fff 64bit]
[    0.811550] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.811557] pci 0000:00:1b.0: PME# disabled
[    0.811606] pci 0000:00:1c.0: [8086:2940] type 1 class 0x000604
[    0.811719] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.811726] pci 0000:00:1c.0: PME# disabled
[    0.811778] pci 0000:00:1c.1: [8086:2942] type 1 class 0x000604
[    0.811891] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.811897] pci 0000:00:1c.1: PME# disabled
[    0.811951] pci 0000:00:1c.3: [8086:2946] type 1 class 0x000604
[    0.812197] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.812204] pci 0000:00:1c.3: PME# disabled
[    0.812265] pci 0000:00:1d.0: [8086:2934] type 0 class 0x000c03
[    0.812340] pci 0000:00:1d.0: reg 20: [io  0x18c0-0x18df]
[    0.812432] pci 0000:00:1d.1: [8086:2935] type 0 class 0x000c03
[    0.812506] pci 0000:00:1d.1: reg 20: [io  0x18e0-0x18ff]
[    0.812599] pci 0000:00:1d.2: [8086:2936] type 0 class 0x000c03
[    0.812673] pci 0000:00:1d.2: reg 20: [io  0x1c00-0x1c1f]
[    0.812781] pci 0000:00:1d.7: [8086:293a] type 0 class 0x000c03
[    0.812814] pci 0000:00:1d.7: reg 10: [mem 0xf2827000-0xf28273ff]
[    0.812931] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.812938] pci 0000:00:1d.7: PME# disabled
[    0.812987] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.813110] pci 0000:00:1f.0: [8086:2917] type 0 class 0x000601
[    0.813317] pci 0000:00:1f.2: [8086:2929] type 0 class 0x000106
[    0.813354] pci 0000:00:1f.2: reg 10: [io  0x1c48-0x1c4f]
[    0.813369] pci 0000:00:1f.2: reg 14: [io  0x183c-0x183f]
[    0.813384] pci 0000:00:1f.2: reg 18: [io  0x1c40-0x1c47]
[    0.813399] pci 0000:00:1f.2: reg 1c: [io  0x1838-0x183b]
[    0.813414] pci 0000:00:1f.2: reg 20: [io  0x1c20-0x1c3f]
[    0.813429] pci 0000:00:1f.2: reg 24: [mem 0xf2826000-0xf28267ff]
[    0.813495] pci 0000:00:1f.2: PME# supported from D3hot
[    0.813501] pci 0000:00:1f.2: PME# disabled
[    0.813547] pci 0000:00:1f.3: [8086:2930] type 0 class 0x000c05
[    0.813575] pci 0000:00:1f.3: reg 10: [mem 0xf2827400-0xf28274ff 64bit]
[    0.813614] pci 0000:00:1f.3: reg 20: [io  0x1c60-0x1c7f]
[    0.813752] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.813807] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.813813] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.813824] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.814037] pci 0000:03:00.0: [8086:4237] type 0 class 0x000280
[    0.814100] pci 0000:03:00.0: reg 10: [mem 0xf2500000-0xf2501fff 64bit]
[    0.814339] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.814368] pci 0000:03:00.0: PME# disabled
[    0.814486] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.814541] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
[    0.814547] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
[    0.814558] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.814650] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.814704] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.814711] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.814721] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[    0.814856] pci 0000:00:1e.0: PCI bridge to [bus 0d-0d] (subtractive decode)
[    0.814913] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.814920] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.814930] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.814942] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.814954] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.814965] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.814977] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.814989] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.815000] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
[    0.815034] pci_bus 0000:00: on NUMA node 0
[    0.815057] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.821698] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.823121] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.824608] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    1.034117] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    1.036474] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    1.038685] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    1.040919] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    1.043129] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    1.045454] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    1.047668] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    1.049891] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    1.051150] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.051401] vgaarb: loaded
[    1.052988] SCSI subsystem initialized
[    1.053064] libata version 3.00 loaded.
[    1.053064] PCI: Using ACPI for IRQ routing
[    1.053064] PCI: pci_cache_line_size set to 64 bytes
[    1.053064] reserve RAM buffer: 000000000009ec00 - 000000000009ffff 
[    1.053064] reserve RAM buffer: 00000000bd6a1000 - 00000000bfffffff 
[    1.053064] reserve RAM buffer: 00000000bd7b7000 - 00000000bfffffff 
[    1.053068] reserve RAM buffer: 00000000bd8c7000 - 00000000bfffffff 
[    1.053172] reserve RAM buffer: 00000000bdc00000 - 00000000bfffffff 
[    1.056163] Bluetooth: Core ver 2.15
[    1.056309] NET: Registered protocol family 31
[    1.056358] Bluetooth: HCI device and connection manager initialized
[    1.056424] Bluetooth: HCI socket layer initialized
[    1.056812] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    1.060276] Switching to clocksource hpet
[    1.060394] pnp: PnP ACPI init
[    1.060592] ACPI: bus type pnp registered
[    1.063589] Switched to NOHz mode on CPU #0
[    1.063657] Switched to NOHz mode on CPU #1
[    1.093994] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    1.094004] pnp 00:00: [mem 0x000c0000-0x000c3fff]
[    1.094014] pnp 00:00: [mem 0x000c4000-0x000c7fff]
[    1.094023] pnp 00:00: [mem 0x000c8000-0x000cbfff]
[    1.094033] pnp 00:00: [mem 0x000cc000-0x000cffff]
[    1.094042] pnp 00:00: [mem 0x000d0000-0x000d3fff]
[    1.094052] pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
[    1.094061] pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
[    1.094071] pnp 00:00: [mem 0x000dc000-0x000dffff]
[    1.094080] pnp 00:00: [mem 0x000e0000-0x000e3fff]
[    1.094090] pnp 00:00: [mem 0x000e4000-0x000e7fff]
[    1.094099] pnp 00:00: [mem 0x000e8000-0x000ebfff]
[    1.094109] pnp 00:00: [mem 0x000ec000-0x000effff]
[    1.094118] pnp 00:00: [mem 0x000f0000-0x000fffff]
[    1.094128] pnp 00:00: [mem 0x00100000-0xbfffffff]
[    1.094137] pnp 00:00: [mem 0xfec00000-0xfed3ffff]
[    1.094146] pnp 00:00: [mem 0xfed4c000-0xffffffff]
[    1.094852] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    1.094925] system 00:00: [mem 0x000c0000-0x000c3fff] has been reserved
[    1.094995] system 00:00: [mem 0x000c4000-0x000c7fff] has been reserved
[    1.095066] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    1.095137] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    1.095207] system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
[    1.095282] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
[    1.095358] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    1.095433] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    1.095509] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    1.095585] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    1.095660] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    1.095736] system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
[    1.095812] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    1.095888] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    1.095944] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.096165] pnp 00:01: [bus 00-ff]
[    1.096175] pnp 00:01: [io  0x0cf8-0x0cff]
[    1.096184] pnp 00:01: [io  0x0000-0x0cf7 window]
[    1.096194] pnp 00:01: [io  0x0d00-0xffff window]
[    1.096203] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    1.096214] pnp 00:01: [mem 0x000c0000-0x000c3fff window]
[    1.096223] pnp 00:01: [mem 0x000c4000-0x000c7fff window]
[    1.096235] pnp 00:01: [mem 0x000c8000-0x000cbfff window]
[    1.096245] pnp 00:01: [mem 0x000cc000-0x000cffff window]
[    1.096255] pnp 00:01: [mem 0x000d0000-0x000d3fff window]
[    1.096265] pnp 00:01: [mem 0x000d4000-0x000d7fff window]
[    1.096274] pnp 00:01: [mem 0x000d8000-0x000dbfff window]
[    1.096285] pnp 00:01: [mem 0x000dc000-0x000dffff window]
[    1.096294] pnp 00:01: [mem 0x000e0000-0x000e3fff window]
[    1.096304] pnp 00:01: [mem 0x000e4000-0x000e7fff window]
[    1.096313] pnp 00:01: [mem 0x000e8000-0x000ebfff window]
[    1.096323] pnp 00:01: [mem 0x000ec000-0x000effff window]
[    1.096333] pnp 00:01: [mem 0xc0000000-0xfebfffff window]
[    1.096342] pnp 00:01: [mem 0xfed40000-0xfed4bfff window]
[    1.096711] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    1.118932] pnp 00:02: [io  0x0010-0x001f]
[    1.118942] pnp 00:02: [io  0x0090-0x009f]
[    1.118951] pnp 00:02: [io  0x0024-0x0025]
[    1.118961] pnp 00:02: [io  0x0028-0x0029]
[    1.118970] pnp 00:02: [io  0x002c-0x002d]
[    1.118979] pnp 00:02: [io  0x0030-0x0031]
[    1.118989] pnp 00:02: [io  0x0034-0x0035]
[    1.118998] pnp 00:02: [io  0x0038-0x0039]
[    1.119008] pnp 00:02: [io  0x003c-0x003d]
[    1.119017] pnp 00:02: [io  0x00a4-0x00a5]
[    1.119027] pnp 00:02: [io  0x00a8-0x00a9]
[    1.119036] pnp 00:02: [io  0x00ac-0x00ad]
[    1.119045] pnp 00:02: [io  0x00b0-0x00b5]
[    1.119055] pnp 00:02: [io  0x00b8-0x00b9]
[    1.119064] pnp 00:02: [io  0x00bc-0x00bd]
[    1.119074] pnp 00:02: [io  0x0050-0x0053]
[    1.119083] pnp 00:02: [io  0x0072-0x0077]
[    1.119092] pnp 00:02: [io  0x002e-0x002f]
[    1.119102] pnp 00:02: [io  0x1000-0x107f]
[    1.119111] pnp 00:02: [io  0x1180-0x11ff]
[    1.119120] pnp 00:02: [io  0x0800-0x080f]
[    1.119129] pnp 00:02: [io  0x15e0-0x15ef]
[    1.119139] pnp 00:02: [io  0x1600-0x167f]
[    1.119148] pnp 00:02: [io  0x1680-0x169f]
[    1.119157] pnp 00:02: [mem 0xe0000000-0xefffffff]
[    1.119168] pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
[    1.119177] pnp 00:02: [mem 0xfed10000-0xfed13fff]
[    1.119187] pnp 00:02: [mem 0xfed18000-0xfed18fff]
[    1.119196] pnp 00:02: [mem 0xfed19000-0xfed19fff]
[    1.119206] pnp 00:02: [mem 0xfed45000-0xfed4bfff]
[    1.119940] system 00:02: [io  0x1000-0x107f] has been reserved
[    1.120026] system 00:02: [io  0x1180-0x11ff] has been reserved
[    1.120097] system 00:02: [io  0x0800-0x080f] has been reserved
[    1.120166] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    1.120236] system 00:02: [io  0x1600-0x167f] has been reserved
[    1.120305] system 00:02: [io  0x1680-0x169f] has been reserved
[    1.120375] system 00:02: [mem 0xe0000000-0xefffffff] has been reserved
[    1.120445] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.120516] system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
[    1.120586] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    1.120657] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    1.120728] system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
[    1.120783] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.121402] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    1.121761] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.121892] pnp 00:04: [io  0x0000-0x000f]
[    1.121902] pnp 00:04: [io  0x0080-0x008f]
[    1.121911] pnp 00:04: [io  0x00c0-0x00df]
[    1.121921] pnp 00:04: [dma 4]
[    1.122280] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.122409] pnp 00:05: [io  0x0061]
[    1.122767] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.122899] pnp 00:06: [io  0x00f0]
[    1.122917] pnp 00:06: [irq 13]
[    1.123279] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.123410] pnp 00:07: [io  0x0070-0x0071]
[    1.123425] pnp 00:07: [irq 8]
[    1.123788] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.123918] pnp 00:08: [io  0x0060]
[    1.123928] pnp 00:08: [io  0x0064]
[    1.123943] pnp 00:08: [irq 1]
[    1.124331] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.124468] pnp 00:09: [irq 12]
[    1.124838] pnp 00:09: Plug and Play ACPI device, IDs IBM3780 PNP0f13 (active)
[    1.146768] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    1.147129] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c31 (active)
[    1.151134] pnp: PnP ACPI: found 11 devices
[    1.151184] ACPI: ACPI bus type pnp unregistered
[    1.178951] pci 0000:00:1c.0: BAR 8: assigned [mem 0xc0000000-0xc01fffff]
[    1.179010] pci 0000:00:1c.0: BAR 9: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
[    1.179079] pci 0000:00:1c.1: BAR 9: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
[    1.179147] pci 0000:00:1c.0: BAR 7: assigned [io  0x3000-0x3fff]
[    1.179202] pci 0000:00:1c.1: BAR 7: assigned [io  0x4000-0x4fff]
[    1.179256] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.179308] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    1.179365] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff]
[    1.179421] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
[    1.179491] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    1.179543] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
[    1.179600] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
[    1.179655] pci 0000:00:1c.1:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
[    1.179725] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    1.179777] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    1.179834] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    1.179890] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[    1.179960] pci 0000:00:1e.0: PCI bridge to [bus 0d-0d]
[    1.180028] pci 0000:00:1e.0:   bridge window [io  disabled]
[    1.180084] pci 0000:00:1e.0:   bridge window [mem disabled]
[    1.180138] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    1.180216] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.180273] pci 0000:00:1c.0: setting latency timer to 64
[    1.180294] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.180350] pci 0000:00:1c.1: setting latency timer to 64
[    1.180370] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    1.180426] pci 0000:00:1c.3: setting latency timer to 64
[    1.180436] pci 0000:00:1e.0: setting latency timer to 64
[    1.180442] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.180445] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.180448] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.180451] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    1.180454] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    1.180457] pci_bus 0000:00: resource 9 [mem 0xc0000000-0xfebfffff]
[    1.180460] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
[    1.180463] pci_bus 0000:02: resource 1 [mem 0xc0000000-0xc01fffff]
[    1.180466] pci_bus 0000:02: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
[    1.180470] pci_bus 0000:03: resource 0 [io  0x4000-0x4fff]
[    1.180473] pci_bus 0000:03: resource 1 [mem 0xf2500000-0xf25fffff]
[    1.180476] pci_bus 0000:03: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
[    1.180479] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    1.180482] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
[    1.180485] pci_bus 0000:05: resource 2 [mem 0xf2900000-0xf29fffff 64bit pref]
[    1.180488] pci_bus 0000:0d: resource 4 [io  0x0000-0x0cf7]
[    1.180491] pci_bus 0000:0d: resource 5 [io  0x0d00-0xffff]
[    1.180494] pci_bus 0000:0d: resource 6 [mem 0x000a0000-0x000bffff]
[    1.180497] pci_bus 0000:0d: resource 7 [mem 0x000d4000-0x000d7fff]
[    1.180500] pci_bus 0000:0d: resource 8 [mem 0x000d8000-0x000dbfff]
[    1.180503] pci_bus 0000:0d: resource 9 [mem 0xc0000000-0xfebfffff]
[    1.180638] NET: Registered protocol family 2
[    1.180938] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.182465] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    1.184225] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
[    1.187555] TCP: Hash tables configured (established 262144 bind 65536)
[    1.187642] TCP reno registered
[    1.187709] UDP hash table entries: 2048 (order: 6, 327680 bytes)
[    1.188028] UDP-Lite hash table entries: 2048 (order: 6, 327680 bytes)
[    1.188746] NET: Registered protocol family 1
[    1.188864] pci 0000:00:02.0: Boot video device
[    1.188936] pci 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.188939] pci 0000:00:1a.0: Performing full reset
[    1.188971] pci 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.188974] pci 0000:00:1a.1: Performing full reset
[    1.189003] pci 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.189005] pci 0000:00:1a.2: Performing full reset
[    1.189161] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.189164] pci 0000:00:1d.0: Performing full reset
[    1.189194] pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.189197] pci 0000:00:1d.1: Performing full reset
[    1.189227] pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.189229] pci 0000:00:1d.2: Performing full reset
[    1.189369] PCI: CLS 64 bytes, default 64
[    1.189740] Trying to unpack rootfs image as initramfs...
[    2.018101] Freeing initrd memory: 29492k freed
[    2.172327] DMA-API: preallocated 32768 debug entries
[    2.172383] DMA-API: debugging enabled by kernel config
[    2.172441] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.172494] Placing 64MB software IO TLB between ffff8800b8c9d000 - ffff8800bcc9d000
[    2.172557] software IO TLB at phys 0xb8c9d000 - 0xbcc9d000
[    2.172790] Simple Boot Flag at 0x35 set to 0x1
[    2.174259] Scanning for low memory corruption every 60 seconds
[    2.175127] audit: initializing netlink socket (disabled)
[    2.175253] type=2000 audit(1300126930.168:1): initialized
[    2.192287] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.217289] fuse init (API version 7.16)
[    2.218249] msgmni has been set to 7697
[    2.219519] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    2.219591] io scheduler noop registered
[    2.219639] io scheduler deadline registered
[    2.220100] io scheduler cfq registered (default)
[    2.221645] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.222055] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.222884] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    2.224146] ACPI: AC Adapter [AC] (on-line)
[    2.225607] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    2.260040] ACPI: Lid Switch [LID]
[    2.260745] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    2.324021] ACPI: Sleep Button [SLPB]
[    2.324748] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    2.324824] ACPI: Power Button [PWRF]
[    2.325056] ACPI: acpi_idle registered with cpuidle
[    2.441970] Monitor-Mwait will be used to enter C-1 state
[    2.442049] Monitor-Mwait will be used to enter C-2 state
[    2.442123] Monitor-Mwait will be used to enter C-3 state
[    2.442135] Marking TSC unstable due to TSC halts in idle
[    2.539110] thermal LNXTHERM:00: registered as thermal_zone0
[    2.539162] ACPI: Thermal Zone [THM0] (62 C)
[    2.548842] thermal LNXTHERM:01: registered as thermal_zone1
[    2.548894] ACPI: Thermal Zone [THM1] (63 C)
[    2.549485] Linux agpgart interface v0.103
[    2.566171] brd: module loaded
[    2.574388] loop: module loaded
[    2.576128] ahci 0000:00:1f.2: version 3.0
[    2.576182] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    2.576398] ahci 0000:00:1f.2: irq 40 for MSI/MSI-X
[    2.576511] ahci: SSS flag set, parallel bus scan disabled
[    2.576589] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
[    2.576655] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc sxs 
[    2.576723] ahci 0000:00:1f.2: setting latency timer to 64
[    2.586727] scsi0 : ahci
[    2.588064] scsi1 : ahci
[    2.589150] scsi2 : ahci
[    2.590236] scsi3 : ahci
[    2.599627] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    2.599782] ACPI: Battery Slot [BAT0] (battery present)
[    2.602420] ata1: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826100 irq 40
[    2.602485] ata2: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826180 irq 40
[    2.602548] ata3: DUMMY
[    2.602593] ata4: DUMMY
[    2.603171] ata_generic 0000:00:03.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.603365] ata_generic 0000:00:03.2: setting latency timer to 64
[    2.609475] scsi4 : ata_generic
[    2.610491] scsi5 : ata_generic
[    2.611401] ata5: PATA max UDMA/100 cmd 0x1828 ctl 0x180c bmdma 0x1810 irq 18
[    2.611454] ata6: PATA max UDMA/100 cmd 0x1820 ctl 0x1808 bmdma 0x1818 irq 18
[    2.611737] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.20-k2
[    2.611789] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    2.611917] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.611994] e1000e 0000:00:19.0: setting latency timer to 64
[    2.612324] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[    2.920032] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.923435] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.923440] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.923505] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.923807] ata1.00: ATA-7: INTEL SSDSA2M160G2GC, 2CV102M3, max UDMA/133
[    2.923860] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.927356] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.927361] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.927426] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.927728] ata1.00: configured for UDMA/133
[    2.928653] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2M160 2CV1 PQ: 0 ANSI: 5
[    2.931419] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1f:16:1d:fb:eb
[    2.931484] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    2.931560] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1008FF-0FF
[    2.931579] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.931822] PPP generic driver version 2.4.2
[    2.932528] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    2.932734] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    2.933494] sd 0:0:0:0: [sda] Write Protect is off
[    2.933553] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.933816] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.938059]  sda: sda1 sda2
[    2.942294] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.944290] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.944732] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.945715] mousedev: PS/2 mouse device common for all mice
[    2.947181] rtc_cmos 00:07: RTC can wake from S4
[    2.952749] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    2.960667] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    2.960784] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    2.960898] Linux video capture interface: v2.00
[    2.964462] device-mapper: uevent: version 1.0.3
[    2.965139] device-mapper: ioctl: 4.19.1-ioctl (2011-01-07) initialised: dm-devel@redhat.com
[    2.965393] device-mapper: multipath: version 1.2.0 loaded
[    2.965458] device-mapper: multipath round-robin: version 1.0.0 loaded
[    2.967099] cpuidle: using governor ladder
[    2.968653] cpuidle: using governor menu
[    2.969898] TCP cubic registered
[    2.971126] NET: Registered protocol family 10
[    2.974033] NET: Registered protocol family 17
[    2.974270] Bluetooth: L2CAP ver 2.15
[    2.974320] Bluetooth: L2CAP socket layer initialized
[    2.974386] Bluetooth: SCO (Voice Link) ver 0.6
[    2.974434] Bluetooth: SCO socket layer initialized
[    2.974667] Bluetooth: RFCOMM TTY layer initialized
[    2.974737] Bluetooth: RFCOMM socket layer initialized
[    2.974786] Bluetooth: RFCOMM ver 1.11
[    2.974834] Registering the dns_resolver key type
[    2.975787] registered taskstats version 1
[    2.975965] kmemleak: Kernel memory leak detector initialized
[    2.975972] kmemleak: Automatic memory scanning thread started
[    2.977327] rtc_cmos 00:07: setting system clock to 2011-03-14 18:22:11 UTC (1300126931)
[    2.977392] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.977442] EDD information not available.
[    3.252078] ata2: SATA link down (SStatus 0 SControl 300)
[    3.419863] Freeing unused kernel memory: 524k freed
[    3.420126] Write protecting the kernel read-only data: 8192k
[    3.425530] Freeing unused kernel memory: 1356k freed
[    3.426285] Freeing unused kernel memory: 16k freed
[    3.459360] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    3.477726] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input4
[    3.483694] udevd (86): /proc/86/oom_adj is deprecated, please use /proc/86/oom_score_adj instead.
[    3.849684] usbcore: registered new interface driver usbfs
[    3.850058] usbcore: registered new interface driver hub
[    3.850327] usbcore: registered new device driver usb
[    3.855993] uhci_hcd: USB Universal Host Controller Interface driver
[    3.856812] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    3.856883] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    3.856946] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    3.857027] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    3.857032] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    3.857172] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    3.869727] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.869783] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    3.869848] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    3.876082] uhci_hcd 0000:00:1a.0: detected 2 ports
[    3.876142] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    3.876145] uhci_hcd 0000:00:1a.0: Performing full reset
[    3.876163] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    3.876329] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    3.876829] usb usb1: default language 0x0409
[    3.876966] usb usb1: udev 1, busnum 1, minor = 0
[    3.876969] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    3.877021] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.877083] usb usb1: Product: UHCI Host Controller
[    3.877131] usb usb1: Manufacturer: Linux 2.6.38-rc8+ uhci_hcd
[    3.877181] usb usb1: SerialNumber: 0000:00:1a.0
[    3.877916] usb usb1: usb_probe_device
[    3.877920] usb usb1: configuration #1 chosen from 1 choice
[    3.878036] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    3.878528] hub 1-0:1.0: usb_probe_interface
[    3.878531] hub 1-0:1.0: usb_probe_interface - got id
[    3.878535] hub 1-0:1.0: USB hub found
[    3.878676] hub 1-0:1.0: 2 ports detected
[    3.878743] hub 1-0:1.0: standalone hub
[    3.878745] hub 1-0:1.0: no power switching (usb 1.0)
[    3.878748] hub 1-0:1.0: individual port over-current protection
[    3.878750] hub 1-0:1.0: power on to power good time: 2ms
[    3.878853] hub 1-0:1.0: local power source is good
[    3.878869] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    3.880528] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    3.880605] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    3.880610] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    3.880708] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[    3.892108] uhci_hcd 0000:00:1a.1: detected 2 ports
[    3.892169] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    3.892172] uhci_hcd 0000:00:1a.1: Performing full reset
[    3.892324] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    3.892652] usb usb2: default language 0x0409
[    3.892787] usb usb2: udev 1, busnum 2, minor = 128
[    3.892790] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    3.892842] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.892904] usb usb2: Product: UHCI Host Controller
[    3.892952] usb usb2: Manufacturer: Linux 2.6.38-rc8+ uhci_hcd
[    3.893002] usb usb2: SerialNumber: 0000:00:1a.1
[    3.893718] usb usb2: usb_probe_device
[    3.893722] usb usb2: configuration #1 chosen from 1 choice
[    3.893797] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    3.894347] hub 2-0:1.0: usb_probe_interface
[    3.894350] hub 2-0:1.0: usb_probe_interface - got id
[    3.894355] hub 2-0:1.0: USB hub found
[    3.894498] hub 2-0:1.0: 2 ports detected
[    3.894562] hub 2-0:1.0: standalone hub
[    3.894564] hub 2-0:1.0: no power switching (usb 1.0)
[    3.894567] hub 2-0:1.0: individual port over-current protection
[    3.894570] hub 2-0:1.0: power on to power good time: 2ms
[    3.894664] hub 2-0:1.0: local power source is good
[    3.894682] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    3.896694] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    3.896763] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    3.896835] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    3.896911] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    3.896916] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    3.897015] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 3
[    3.908149] uhci_hcd 0000:00:1a.2: detected 2 ports
[    3.908203] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    3.908206] uhci_hcd 0000:00:1a.2: Performing full reset
[    3.908223] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    3.908383] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[    3.908713] usb usb3: default language 0x0409
[    3.908850] usb usb3: udev 1, busnum 3, minor = 256
[    3.908853] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    3.908904] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.908966] usb usb3: Product: UHCI Host Controller
[    3.909015] usb usb3: Manufacturer: Linux 2.6.38-rc8+ uhci_hcd
[    3.909065] usb usb3: SerialNumber: 0000:00:1a.2
[    3.909781] usb usb3: usb_probe_device
[    3.909785] usb usb3: configuration #1 chosen from 1 choice
[    3.909861] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    3.910426] hub 3-0:1.0: usb_probe_interface
[    3.910429] hub 3-0:1.0: usb_probe_interface - got id
[    3.910433] hub 3-0:1.0: USB hub found
[    3.910574] hub 3-0:1.0: 2 ports detected
[    3.911186] hub 3-0:1.0: standalone hub
[    3.911189] hub 3-0:1.0: no power switching (usb 1.0)
[    3.911191] hub 3-0:1.0: individual port over-current protection
[    3.911194] hub 3-0:1.0: power on to power good time: 2ms
[    3.911290] hub 3-0:1.0: local power source is good
[    3.911308] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    3.913187] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    3.913257] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    3.913320] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    3.913468] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    3.913473] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    3.913571] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 4
[    3.924334] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    3.924340] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    3.924506] ehci_hcd 0000:00:1a.7: debug port 1
[    3.924559] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    3.928437] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    3.928440] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    3.928574] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xf2826c00
[    3.928627] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    3.932521] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    3.944091] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    3.944440] usb usb4: default language 0x0409
[    3.944574] usb usb4: udev 1, busnum 4, minor = 384
[    3.944577] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[    3.944628] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.944690] usb usb4: Product: EHCI Host Controller
[    3.944738] usb usb4: Manufacturer: Linux 2.6.38-rc8+ ehci_hcd
[    3.944788] usb usb4: SerialNumber: 0000:00:1a.7
[    3.945488] usb usb4: usb_probe_device
[    3.945492] usb usb4: configuration #1 chosen from 1 choice
[    3.945567] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    3.946130] hub 4-0:1.0: usb_probe_interface
[    3.946133] hub 4-0:1.0: usb_probe_interface - got id
[    3.946138] hub 4-0:1.0: USB hub found
[    3.946294] hub 4-0:1.0: 6 ports detected
[    3.946356] hub 4-0:1.0: standalone hub
[    3.946359] hub 4-0:1.0: no power switching (usb 1.0)
[    3.946361] hub 4-0:1.0: individual port over-current protection
[    3.946364] hub 4-0:1.0: power on to power good time: 20ms
[    3.946458] hub 4-0:1.0: local power source is good
[    3.946474] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    3.948171] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    3.948187] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
[    3.948202] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.2
[    3.948445] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    3.948515] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    3.948571] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.948646] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.948651] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.948748] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    3.960173] uhci_hcd 0000:00:1d.0: detected 2 ports
[    3.960232] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    3.960235] uhci_hcd 0000:00:1d.0: Performing full reset
[    3.960252] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    3.960390] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[    3.960719] usb usb5: default language 0x0409
[    3.960857] usb usb5: udev 1, busnum 5, minor = 512
[    3.960860] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    3.960911] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.960973] usb usb5: Product: UHCI Host Controller
[    3.961021] usb usb5: Manufacturer: Linux 2.6.38-rc8+ uhci_hcd
[    3.961071] usb usb5: SerialNumber: 0000:00:1d.0
[    3.961789] usb usb5: usb_probe_device
[    3.961793] usb usb5: configuration #1 chosen from 1 choice
[    3.961869] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    3.962476] hub 5-0:1.0: usb_probe_interface
[    3.962479] hub 5-0:1.0: usb_probe_interface - got id
[    3.962484] hub 5-0:1.0: USB hub found
[    3.962626] hub 5-0:1.0: 2 ports detected
[    3.962689] hub 5-0:1.0: standalone hub
[    3.962692] hub 5-0:1.0: no power switching (usb 1.0)
[    3.962694] hub 5-0:1.0: individual port over-current protection
[    3.962697] hub 5-0:1.0: power on to power good time: 2ms
[    3.962792] hub 5-0:1.0: local power source is good
[    3.962809] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    3.964636] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.964712] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    3.964717] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.964815] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    3.980174] uhci_hcd 0000:00:1a.0: port 1 portsc 0082,00
[    3.980263] uhci_hcd 0000:00:1d.1: detected 2 ports
[    3.980323] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    3.980325] uhci_hcd 0000:00:1d.1: Performing full reset
[    3.980475] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[    3.980802] usb usb6: default language 0x0409
[    3.980941] usb usb6: udev 1, busnum 6, minor = 640
[    3.980944] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    3.980995] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.981057] usb usb6: Product: UHCI Host Controller
[    3.981105] usb usb6: Manufacturer: Linux 2.6.38-rc8+ uhci_hcd
[    3.981155] usb usb6: SerialNumber: 0000:00:1d.1
[    3.981868] usb usb6: usb_probe_device
[    3.981871] usb usb6: configuration #1 chosen from 1 choice
[    3.981948] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    3.982411] hub 6-0:1.0: usb_probe_interface
[    3.982414] hub 6-0:1.0: usb_probe_interface - got id
[    3.982418] hub 6-0:1.0: USB hub found
[    3.982558] hub 6-0:1.0: 2 ports detected
[    3.982627] hub 6-0:1.0: standalone hub
[    3.982629] hub 6-0:1.0: no power switching (usb 1.0)
[    3.982631] hub 6-0:1.0: individual port over-current protection
[    3.982634] hub 6-0:1.0: power on to power good time: 2ms
[    3.982715] hub 6-0:1.0: local power source is good
[    3.982729] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    3.984367] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.984443] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    3.984447] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.984548] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    3.992118] uhci_hcd 0000:00:1a.1: port 1 portsc 0082,00
[    3.992172] uhci_hcd 0000:00:1a.1: port 2 portsc 0082,00
[    4.000110] uhci_hcd 0000:00:1d.2: detected 2 ports
[    4.000163] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    4.000166] uhci_hcd 0000:00:1d.2: Performing full reset
[    4.000223] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[    4.000549] usb usb7: default language 0x0409
[    4.000687] usb usb7: udev 1, busnum 7, minor = 768
[    4.000689] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    4.000741] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.000803] usb usb7: Product: UHCI Host Controller
[    4.000851] usb usb7: Manufacturer: Linux 2.6.38-rc8+ uhci_hcd
[    4.000901] usb usb7: SerialNumber: 0000:00:1d.2
[    4.001626] usb usb7: usb_probe_device
[    4.001630] usb usb7: configuration #1 chosen from 1 choice
[    4.001705] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    4.002310] hub 7-0:1.0: usb_probe_interface
[    4.002313] hub 7-0:1.0: usb_probe_interface - got id
[    4.002318] hub 7-0:1.0: USB hub found
[    4.002461] hub 7-0:1.0: 2 ports detected
[    4.002525] hub 7-0:1.0: standalone hub
[    4.002528] hub 7-0:1.0: no power switching (usb 1.0)
[    4.002530] hub 7-0:1.0: individual port over-current protection
[    4.002533] hub 7-0:1.0: power on to power good time: 2ms
[    4.002629] hub 7-0:1.0: local power source is good
[    4.002647] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    4.004484] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    4.004555] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    4.004628] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    4.004741] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.004746] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.004847] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 8
[    4.012195] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.016178] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    4.016185] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    4.016352] ehci_hcd 0000:00:1d.7: debug port 1
[    4.016410] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.020299] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    4.020302] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    4.020436] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xf2827000
[    4.020489] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.024378] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    4.036024] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.036405] usb usb8: default language 0x0409
[    4.036562] usb usb8: udev 1, busnum 8, minor = 896
[    4.036565] usb usb8: New USB device found, idVendor=1d6b, idProduct=0002
[    4.036618] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.036681] usb usb8: Product: EHCI Host Controller
[    4.036730] usb usb8: Manufacturer: Linux 2.6.38-rc8+ ehci_hcd
[    4.036780] usb usb8: SerialNumber: 0000:00:1d.7
[    4.037567] usb usb8: usb_probe_device
[    4.037570] usb usb8: configuration #1 chosen from 1 choice
[    4.037645] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    4.038127] hub 8-0:1.0: usb_probe_interface
[    4.038130] hub 8-0:1.0: usb_probe_interface - got id
[    4.038135] hub 8-0:1.0: USB hub found
[    4.038291] hub 8-0:1.0: 6 ports detected
[    4.038353] hub 8-0:1.0: standalone hub
[    4.038356] hub 8-0:1.0: no power switching (usb 1.0)
[    4.038358] hub 8-0:1.0: individual port over-current protection
[    4.038361] hub 8-0:1.0: power on to power good time: 20ms
[    4.038453] hub 8-0:1.0: local power source is good
[    4.038469] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    4.040195] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    4.040210] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    4.040225] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    4.044021] Monitor-Mwait will be used to enter C-3 state
[    4.044074] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001403 0  ACK POWER sig=k CSC CONNECT
[    4.044086] hub 4-0:1.0: port 1: status 0501 change 0001
[    4.044157] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 001803 0  ACK POWER sig=j CSC CONNECT
[    4.044168] hub 4-0:1.0: port 3: status 0501 change 0001
[    4.044215] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 001803 0  ACK POWER sig=j CSC CONNECT
[    4.044226] hub 4-0:1.0: port 4: status 0501 change 0001
[    4.060096] uhci_hcd 0000:00:1d.0: port 1 portsc 0082,00
[    4.084156] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.084185] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.096140] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.104202] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.136154] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 001403 0  ACK POWER sig=k CSC CONNECT
[    4.136167] hub 8-0:1.0: port 1: status 0501 change 0001
[    4.144161] hub 4-0:1.0: state 7 ports 6 chg 001a evt 0000
[    4.144198] hub 4-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    4.144267] ehci_hcd 0000:00:1a.7: port 1 low speed --> companion
[    4.200115] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    4.200241] hub 4-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[    4.256299] ehci_hcd 0000:00:1a.7: port 3 full speed --> companion
[    4.256304] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 003801 0  ACK POWER OWNER sig=j CONNECT
[    4.256313] hub 4-0:1.0: port 3 not reset yet, waiting 50ms
[    4.312122] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    4.312241] hub 4-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
[    4.368299] ehci_hcd 0000:00:1a.7: port 4 full speed --> companion
[    4.368304] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 003801 0  ACK POWER OWNER sig=j CONNECT
[    4.368320] hub 4-0:1.0: port 4 not reset yet, waiting 50ms
[    4.424121] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    4.424218] hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
[    4.424251] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.424258] hub 8-0:1.0: state 7 ports 6 chg 0002 evt 0000
[    4.424286] hub 8-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    4.424329] ehci_hcd 0000:00:1d.7: port 1 low speed --> companion
[    4.480122] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    4.480220] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    4.480246] uhci_hcd 0000:00:1a.0: port 1 portsc 01a3,00
[    4.480279] hub 1-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
[    4.608104] hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
[    4.720124] usb 1-1: new low speed USB device using uhci_hcd and address 2
[    4.874613] usb 1-1: skipped 1 descriptor after interface
[    4.879618] usb 1-1: default language 0x0409
[    4.895626] usb 1-1: udev 2, busnum 1, minor = 1
[    4.895629] usb 1-1: New USB device found, idVendor=046d, idProduct=c018
[    4.895682] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.895735] usb 1-1: Product: USB Optical Mouse
[    4.895784] usb 1-1: Manufacturer: Logitech
[    4.896599] usb 1-1: usb_probe_device
[    4.896603] usb 1-1: configuration #1 chosen from 1 choice
[    4.899626] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[    4.901147] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0006
[    4.901174] uhci_hcd 0000:00:1a.1: port 1 portsc 0093,00
[    4.901208] hub 2-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[    4.911248] usbhid 1-1:1.0: usb_probe_interface
[    4.911252] usbhid 1-1:1.0: usb_probe_interface - got id
[    4.925647] input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1:1.0/input/input5
[    4.927253] generic-usb 0003:046D:C018.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:1a.0-1/input0
[    4.927444] usbcore: registered new interface driver usbhid
[    4.927500] usbhid: USB HID core driver
[    5.028123] hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
[    5.112069] usb usb3: suspend_rh (auto-stop)
[    5.112097] usb usb6: suspend_rh (auto-stop)
[    5.112123] usb usb7: suspend_rh (auto-stop)
[    5.140090] usb 2-1: new full speed USB device using uhci_hcd and address 2
[    5.272076] usb 2-1: ep0 maxpacket = 8
[    5.298526] usb 2-1: default language 0x0409
[    5.307538] usb 2-1: udev 2, busnum 2, minor = 129
[    5.307541] usb 2-1: New USB device found, idVendor=08ff, idProduct=2810
[    5.307599] usb 2-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    5.307651] usb 2-1: Product: Fingerprint Sensor
[    5.308315] usb 2-1: usb_probe_device
[    5.308319] usb 2-1: configuration #1 chosen from 1 choice
[    5.309553] usb 2-1: adding 2-1:1.0 (config #1, interface 0)
[    5.311522] uhci_hcd 0000:00:1a.1: port 2 portsc 0093,00
[    5.311560] hub 2-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[    5.440119] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
[    5.552119] usb 2-2: new full speed USB device using uhci_hcd and address 3
[    5.704632] usb 2-2: skipped 1 descriptor after interface
[    5.707536] usb 2-2: default language 0x0409
[    5.718543] usb 2-2: udev 3, busnum 2, minor = 130
[    5.718547] usb 2-2: New USB device found, idVendor=0a5c, idProduct=2145
[    5.718600] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.718653] usb 2-2: Product: ThinkPad Bluetooth with Enhanced Data Rate II
[    5.718710] usb 2-2: Manufacturer: Lenovo Computer Corp
[    5.719323] usb 2-2: usb_probe_device
[    5.719327] usb 2-2: configuration #1 chosen from 1 choice
[    5.720587] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
[    5.722211] usb 2-2: adding 2-2:1.1 (config #1, interface 1)
[    5.723364] usb 2-2: adding 2-2:1.2 (config #1, interface 2)
[    5.724464] usb 2-2: adding 2-2:1.3 (config #1, interface 3)
[    5.725570] hub 8-0:1.0: state 7 ports 6 chg 0000 evt 0002
[    5.725615] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    5.725641] uhci_hcd 0000:00:1d.0: port 1 portsc 01a3,00
[    5.725677] hub 5-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
[    5.856092] hub 5-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
[    5.968118] usb 5-1: new low speed USB device using uhci_hcd and address 2
[    6.012087] hub 3-0:1.0: hub_suspend
[    6.012125] usb usb3: bus auto-suspend
[    6.012128] usb usb3: suspend_rh
[    6.125627] usb 5-1: skipped 1 descriptor after interface
[    6.125639] usb 5-1: skipped 1 descriptor after interface
[    6.130592] usb 5-1: default language 0x0409
[    6.147604] usb 5-1: udev 2, busnum 5, minor = 513
[    6.147608] usb 5-1: New USB device found, idVendor=046d, idProduct=c30a
[    6.147661] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.147719] usb 5-1: Product: Logitech USB Keyboard
[    6.147767] usb 5-1: Manufacturer: Logitech
[    6.148445] usb 5-1: usb_probe_device
[    6.148448] usb 5-1: configuration #1 chosen from 1 choice
[    6.150622] usb 5-1: adding 5-1:1.0 (config #1, interface 0)
[    6.151060] usbhid 5-1:1.0: usb_probe_interface
[    6.151064] usbhid 5-1:1.0: usb_probe_interface - got id
[    6.152105] usb 5-1: adding 5-1:1.1 (config #1, interface 1)
[    6.152521] usbhid 5-1:1.1: usb_probe_interface
[    6.152524] usbhid 5-1:1.1: usb_probe_interface - got id
[    6.154442] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    6.196765] input: Logitech Logitech USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1:1.0/input/input6
[    6.196890] uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[    6.197888] logitech 0003:046D:C30A.0002: input,hidraw1: USB HID v1.10 Keyboard [Logitech Logitech USB Keyboard] on usb-0000:00:1d.0-1/input0
[    6.236344] input: Logitech Logitech USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1:1.1/input/input7
[    6.236447] uhci_hcd 0000:00:1d.0: reserve dev 2 ep82-INT, period 32, phase 16, 118 us
[    6.237927] logitech 0003:046D:C30A.0003: input,hidraw2: USB HID v1.10 Mouse [Logitech Logitech USB Keyboard] on usb-0000:00:1d.0-1/input1
[    6.824093] hub 6-0:1.0: hub_suspend
[    6.824103] usb usb6: bus auto-suspend
[    6.824106] usb usb6: suspend_rh
[    6.824126] hub 7-0:1.0: hub_suspend
[    6.824132] usb usb7: bus auto-suspend
[    6.824135] usb usb7: suspend_rh
[    6.824153] hub 4-0:1.0: hub_suspend
[    6.824160] usb usb4: bus auto-suspend
[    6.824163] ehci_hcd 0000:00:1a.7: suspend root hub
[    7.824110] hub 8-0:1.0: hub_suspend
[    7.824117] usb usb8: bus auto-suspend
[    7.824120] ehci_hcd 0000:00:1d.7: suspend root hub
[    8.688065] EXT3-fs: barriers not enabled
[    8.688594] kjournald starting.  Commit interval 5 seconds
[    8.688755] EXT3-fs (sda1): mounted filesystem with writeback data mode
[   13.686639] Adding 1871568k swap on /dev/sda2.  Priority:-1 extents:1 across:1871568k SS
[   13.702104] EXT3-fs (sda1): using internal journal
[   13.761324] udev: starting version 151
[   14.048577] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[   14.048951] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[   14.061397] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[   14.094827] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[   14.408811] cfg80211: Calling CRDA to update world regulatory domain
[   14.583673] [drm] Initialized drm 1.1.0 20060810
[   14.645756] cfg80211: World regulatory domain updated:
[   14.645760] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   14.645763] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   14.645766] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   14.645769] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   14.645772] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   14.645775] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   14.856391] i915 0000:00:02.0: power state changed by ACPI to D0
[   14.856413] i915 0000:00:02.0: power state changed by ACPI to D0
[   14.856422] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   14.856428] i915 0000:00:02.0: setting latency timer to 64
[   15.019713] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[   15.019717] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[   15.019962] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   15.019973] iwlagn 0000:03:00.0: setting latency timer to 64
[   15.020649] iwlagn 0000:03:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
[   15.058123] iwlagn 0000:03:00.0: device EEPROM VER=0x11f, CALIB=0x4
[   15.058128] iwlagn 0000:03:00.0: Device SKU: 0Xb
[   15.058172] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   15.058313] iwlagn 0000:03:00.0: irq 42 for MSI/MSI-X
[   15.100989] iwlagn 0000:03:00.0: request for firmware file 'iwlwifi-5000-5.ucode' failed.
[   15.130924] iwlagn 0000:03:00.0: request for firmware file 'iwlwifi-5000-4.ucode' failed.
[   15.168093] iwlagn 0000:03:00.0: request for firmware file 'iwlwifi-5000-3.ucode' failed.
[   15.190076] iwlagn 0000:03:00.0: Firmware has old API version. Expected v5, got v2. New firmware can be obtained from http://www.intellinuxwireless.org.
[   15.190153] iwlagn 0000:03:00.0: loaded firmware version 8.24.2.12
[   15.269416] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[   15.284735] i915 0000:00:02.0: irq 43 for MSI/MSI-X
[   15.284851] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   15.284853] [drm] Driver supports precise vblank timestamp query.
[   15.324171] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[   15.325265] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   15.326537] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   15.479294] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   15.677494] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   15.842953] fb0: inteldrmfb frame buffer device
[   15.842957] drm: registered panic notifier
[   15.990741] acpi device:02: registered as cooling_device2
[   15.997471] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input8
[   15.998387] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   15.999853] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   16.000103] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   16.000247] HDA Intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[   16.000432] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   16.060957] Console: switching to colour frame buffer device 180x56
[   16.880928] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: None
[   16.880934] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   16.881514] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   17.096300] uhci_hcd 0000:00:1a.0: reserve dev 2 ep81-INT, period 8, phase 4, 99 us
[   18.555317] usb usb8: usb auto-resume
[   18.555326] ehci_hcd 0000:00:1d.7: resume root hub
[   18.604146] hub 8-0:1.0: hub_resume
[   18.604577] usb usb6: usb auto-resume
[   18.604581] usb usb6: wakeup_rh
[   18.604592] hub 8-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   18.644028] hub 6-0:1.0: hub_resume
[   18.644310] usb usb7: usb auto-resume
[   18.644314] usb usb7: wakeup_rh
[   18.644325] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   18.688151] hub 7-0:1.0: hub_resume
[   18.688291] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   18.688659] usb usb4: usb auto-resume
[   18.688664] ehci_hcd 0000:00:1a.7: resume root hub
[   18.744077] hub 4-0:1.0: hub_resume
[   18.744344] hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   18.744473] usb usb3: usb auto-resume
[   18.744477] usb usb3: wakeup_rh
[   18.788050] hub 3-0:1.0: hub_resume
[   18.792024] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   19.744031] usb usb6: suspend_rh (auto-stop)
[   19.744061] usb usb7: suspend_rh (auto-stop)
[   19.992079] usb usb3: suspend_rh (auto-stop)
[   20.836065] hub 7-0:1.0: hub_suspend
[   20.836079] usb usb7: bus auto-suspend
[   20.836083] usb usb7: suspend_rh
[   20.836103] hub 4-0:1.0: hub_suspend
[   20.836109] usb usb4: bus auto-suspend
[   20.836113] ehci_hcd 0000:00:1a.7: suspend root hub
[   20.836142] hub 3-0:1.0: hub_suspend
[   20.836148] usb usb3: bus auto-suspend
[   20.836151] usb usb3: suspend_rh
[   20.836171] hub 8-0:1.0: hub_suspend
[   20.836177] usb usb8: bus auto-suspend
[   20.836180] ehci_hcd 0000:00:1d.7: suspend root hub
[   20.836207] hub 6-0:1.0: hub_suspend
[   20.836213] usb usb6: bus auto-suspend
[   20.836216] usb usb6: suspend_rh
[   26.904056] eth0: no IPv6 routers present
[   39.546537] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   39.546938] wlan0: Selected IBSS BSSID 2e:25:b3:96:d5:f9 based on configured SSID
[   39.563927] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[   39.565530] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[   39.565733] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
[   50.240086] wlan0: no IPv6 routers present
[   81.001427] kmemleak: 2 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
[   84.713838] wlan0: Trigger new scan to find an IBSS to join
[   84.716242] iwlagn 0000:03:00.0: failed to remove IBSS station 00:00:00:00:00:00
[   90.126347] wlan0: deauthenticating from 1c:17:d3:cb:d5:8e by local choice (reason=3)
[   90.126634] wlan0: authenticate with 1c:17:d3:cb:d3:11 (try 1)
[   90.182562] wlan0: authenticated
[   90.182674] wlan0: waiting for beacon from 1c:17:d3:cb:d3:11
[  102.551232] wlan0: authenticate with 1c:17:d3:cb:d3:11 (try 1)
[  102.748087] wlan0: authenticate with 1c:17:d3:cb:d3:11 (try 2)
[  102.750152] wlan0: authenticated
[  102.750264] wlan0: waiting for beacon from 1c:17:d3:cb:d3:11
[  115.245039] wlan0: deauthenticating from 1c:17:d3:cb:d3:11 by local choice (reason=3)
[  115.252368] wlan0: authenticate with 1c:17:d3:cb:d3:1e (try 1)
[  115.452056] wlan0: authenticate with 1c:17:d3:cb:d3:1e (try 2)
[  115.452736] wlan0: authenticated
[  115.462266] wlan0: associate with 1c:17:d3:cb:d3:1e (try 1)
[  115.660094] wlan0: associate with 1c:17:d3:cb:d3:1e (try 2)
[  115.661798] wlan0: RX AssocResp from 1c:17:d3:cb:d3:1e (capab=0x11 status=0 aid=59)
[  115.661802] wlan0: associated
[  115.667474] cfg80211: Calling CRDA for country: US
[  115.672857] cfg80211: Regulatory domain changed to country: US
[  115.672860] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  115.672863] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[  115.672867] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[  115.672870] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  115.672873] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  115.672876] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  115.672878] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[  116.837062] Intel AES-NI instructions are not detected.
[  119.910898] irq 23: nobody cared (try booting with the "irqpoll" option)
[  119.910903] Pid: 0, comm: swapper Not tainted 2.6.38-rc8+ #773
[  119.910906] Call Trace:
[  119.910908]  <IRQ>  [<ffffffff81099d36>] ? __report_bad_irq+0x26/0xa0
[  119.910918]  [<ffffffff81099f3c>] ? note_interrupt+0x18c/0x1d0
[  119.910922]  [<ffffffff8109a8bd>] ? handle_fasteoi_irq+0xcd/0x100
[  119.910926]  [<ffffffff8100543d>] ? handle_irq+0x1d/0x30
[  119.910929]  [<ffffffff81004bb8>] ? do_IRQ+0x58/0xd0
[  119.910934]  [<ffffffff814a0e93>] ? ret_from_intr+0x0/0xe
[  119.910936]  <EOI>  [<ffffffff8126fd08>] ? acpi_idle_enter_c1+0x7e/0x99
[  119.910944]  [<ffffffff8126fcea>] ? acpi_idle_enter_c1+0x60/0x99
[  119.910949]  [<ffffffff8138bc82>] ? cpuidle_idle_call+0x82/0xf0
[  119.910953]  [<ffffffff810018d6>] ? cpu_idle+0x56/0xb0
[  119.910957]  [<ffffffff8148bd0b>] ? rest_init+0xcb/0xe0
[  119.910960]  [<ffffffff8148bc40>] ? rest_init+0x0/0xe0
[  119.910964]  [<ffffffff81895d6f>] ? start_kernel+0x38a/0x395
[  119.910969]  [<ffffffff81895321>] ? x86_64_start_reservations+0x131/0x135
[  119.910973]  [<ffffffff81895417>] ? x86_64_start_kernel+0xf2/0xf9
[  119.910975] handlers:
[  119.910977] [<ffffffffa0006dc0>] (usb_hcd_irq+0x0/0x70 [usbcore])
[  119.910992] Disabling IRQ #23

--uAKRQypu60I7Lcqm--
