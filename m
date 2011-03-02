Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab1CBDmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 22:42:38 -0500
Received: from mga14.intel.com ([143.182.124.37]:38575 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757767Ab1CBDmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 22:42:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,251,1297065600"; 
   d="txt'?scan'208";a="396121645"
Date: Tue, 1 Mar 2011 19:42:31 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ozan Caglayan <ozan@pardus.org.tr>
Subject: Re: 2.6.38 regression caused by commit 415e12b
Message-ID: <20110302034140.GA2205@xanatos>
References: <20110228014218.GA11083@xanatos>
 <201103020030.16494.rjw@sisk.pl>
 <20110302000445.GA2621@xanatos>
 <201103020117.04251.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="v9Ux+11Zm5mwPlX6"
Content-Disposition: inline
In-Reply-To: <201103020117.04251.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 02, 2011 at 01:17:04AM +0100, Rafael J. Wysocki wrote:
> On Wednesday, March 02, 2011, Sarah Sharp wrote:
> > On Wed, Mar 02, 2011 at 12:30:16AM +0100, Rafael J. Wysocki wrote:
> > > On Tuesday, March 01, 2011, Sarah Sharp wrote:
> > > > On Tue, Mar 01, 2011 at 09:55:33PM +0100, Rafael J. Wysocki wrote:
> > > > > Please check if the appended patch (on top of the Linus' current) helps.
> > > > 
> > > > Sorry, it doesn't help.  Same message as before.
> > > 
> > > Can you send dmesg with the patch applied, please?
> > 
> > Attached.
> 
> Something's fishy.  Evidently, _OSC is not executed on your system
> although it should be with the patch.
> 
> Please try the patch below instead and send dmesg (either way).

The host controller works with that patch.  dmesg is attached.

Sarah

> ---
>  drivers/acpi/pci_root.c |   11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6/drivers/acpi/pci_root.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/pci_root.c
> +++ linux-2.6/drivers/acpi/pci_root.c
> @@ -48,10 +48,7 @@ static int acpi_pci_root_add(struct acpi
>  static int acpi_pci_root_remove(struct acpi_device *device, int type);
>  static int acpi_pci_root_start(struct acpi_device *device);
>  
> -#define ACPI_PCIE_REQ_SUPPORT (OSC_EXT_PCI_CONFIG_SUPPORT \
> -				| OSC_ACTIVE_STATE_PWR_SUPPORT \
> -				| OSC_CLOCK_PWR_CAPABILITY_SUPPORT \
> -				| OSC_MSI_SUPPORT)
> +#define ACPI_PCIE_REQ_SUPPORT (OSC_EXT_PCI_CONFIG_SUPPORT | OSC_MSI_SUPPORT)
>  
>  static const struct acpi_device_id root_device_ids[] = {
>  	{"PNP0A03", 0},
> @@ -572,8 +569,10 @@ static int __devinit acpi_pci_root_add(s
>  	if (flags != base_flags)
>  		acpi_pci_osc_support(root, flags);
>  
> -	if (!pcie_ports_disabled
> -	    && (flags & ACPI_PCIE_REQ_SUPPORT) == ACPI_PCIE_REQ_SUPPORT) {
> +	if (!pcie_ports_disabled) {
> +		dev_info(root->bus->bridge,
> +			"ACPI _OSC support set (0x%02x)\n", flags);
> +
>  		flags = OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL
>  			| OSC_PCI_EXPRESS_NATIVE_HP_CONTROL
>  			| OSC_PCI_EXPRESS_PME_CONTROL;

--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-patch-2-applied.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.38-rc6+ (sarah@xanatos) (gcc version 4.4.1 (Ubuntu 4.4.1-4ubuntu9) ) #766 SMP PREEMPT Tue Mar 1 19:25:56 PST 2011
[    0.000000] Command line: root=UUID=17b05cc8-db3c-4770-8c5e-8702f049f6d1 ro  
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
[    0.000000] RAMDISK: 35dce000 - 37ff0000
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
[    0.000000] Kernel command line: root=UUID=17b05cc8-db3c-4770-8c5e-8702f049f6d1 ro  
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3905952k/5177344k available (4764k kernel code, 1089568k absent, 181824k reserved, 3941k data, 524k init)
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
[    0.000000] Detected 1861.940 MHz processor.
[    0.004004] Calibrating delay loop (skipped), value calculated using timer frequency.. 3723.88 BogoMIPS (lpj=7447760)
[    0.004102] pid_max: default: 32768 minimum: 301
[    0.004469] Mount-cache hash table entries: 256
[    0.005751] Initializing cgroup subsys ns
[    0.005799] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.005866] Initializing cgroup subsys cpuacct
[    0.005927] Initializing cgroup subsys memory
[    0.006079] Initializing cgroup subsys freezer
[    0.006297] CPU: Physical Processor ID: 0
[    0.006344] CPU: Processor Core ID: 0
[    0.006390] using mwait in idle threads.
[    0.006488] ACPI: Core revision 20110112
[    0.156284] Setting APIC routing to flat
[    0.156796] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.197825] CPU0: Intel(R) Core(TM)2 Duo CPU     L9400  @ 1.86GHz stepping 0a
[    0.200011] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.200011] ... version:                2
[    0.200011] ... bit width:              40
[    0.200011] ... generic registers:      2
[    0.200011] ... value mask:             000000ffffffffff
[    0.200011] ... max period:             000000007fffffff
[    0.200011] ... fixed-purpose events:   3
[    0.200011] ... event mask:             0000000700000003
[    0.208177] NMI watchdog enabled, takes one hw-pmu counter.
[    0.220029] lockdep: fixing up alternatives.
[    0.224109] Booting Node   0, Processors  #1 Ok.
[    0.316090] NMI watchdog enabled, takes one hw-pmu counter.
[    0.320029] Brought up 2 CPUs
[    0.320078] Total of 2 processors activated (7447.80 BogoMIPS).
[    0.324854] NET: Registered protocol family 16
[    0.327140] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.327210] ACPI: bus type pci registered
[    0.327892] PCI: Using configuration type 1 for base access
[    0.341191] bio: create slab <bio-0> at 0
[    0.350291] ACPI: EC: EC description table is found, configuring boot EC
[    0.495957] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.541106] ACPI: SSDT 00000000bd8d7c20 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.544061] ACPI: Dynamic OEM Table Load:
[    0.544175] ACPI: SSDT           (null) 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.548245] ACPI: SSDT 00000000bd8d5020 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.553273] ACPI: Dynamic OEM Table Load:
[    0.553385] ACPI: SSDT           (null) 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.585376] ACPI: SSDT 00000000bd8d6ca0 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.589453] ACPI: Dynamic OEM Table Load:
[    0.589566] ACPI: SSDT           (null) 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.607662] ACPI: SSDT 00000000bd8d6f20 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.610353] ACPI: Dynamic OEM Table Load:
[    0.610466] ACPI: SSDT           (null) 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.630426] ACPI: Interpreter enabled
[    0.630476] ACPI: (supports S0 S3 S4 S5)
[    0.631035] ACPI: Using IOAPIC for interrupt routing
[    0.708433] ACPI: Power Resource [PUBS] (on)
[    0.770672] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.809628] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.809681] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.816698] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.817538] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.817591] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.817643] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.817707] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    0.817769] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    0.817833] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfebfffff]
[    0.817978] pci 0000:00:00.0: [8086:2a40] type 0 class 0x000600
[    0.818070] pci 0000:00:02.0: [8086:2a42] type 0 class 0x000300
[    0.818091] pci 0000:00:02.0: reg 10: [mem 0xf2000000-0xf23fffff 64bit]
[    0.818104] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.818114] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.818180] pci 0000:00:02.1: [8086:2a43] type 0 class 0x000380
[    0.818198] pci 0000:00:02.1: reg 10: [mem 0xf2400000-0xf24fffff 64bit]
[    0.818292] pci 0000:00:03.0: [8086:2a44] type 0 class 0x000780
[    0.818316] pci 0000:00:03.0: reg 10: [mem 0xf2826800-0xf282680f 64bit]
[    0.818380] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.818385] pci 0000:00:03.0: PME# disabled
[    0.818428] pci 0000:00:03.2: [8086:2a46] type 0 class 0x000101
[    0.818448] pci 0000:00:03.2: reg 10: [io  0x1828-0x182f]
[    0.818459] pci 0000:00:03.2: reg 14: [io  0x180c-0x180f]
[    0.818470] pci 0000:00:03.2: reg 18: [io  0x1820-0x1827]
[    0.818480] pci 0000:00:03.2: reg 1c: [io  0x1808-0x180b]
[    0.818491] pci 0000:00:03.2: reg 20: [io  0x1810-0x181f]
[    0.818570] pci 0000:00:03.3: [8086:2a47] type 0 class 0x000700
[    0.818590] pci 0000:00:03.3: reg 10: [io  0x1830-0x1837]
[    0.818600] pci 0000:00:03.3: reg 14: [mem 0xf2624000-0xf2624fff]
[    0.818759] pci 0000:00:19.0: [8086:10f5] type 0 class 0x000200
[    0.818792] pci 0000:00:19.0: reg 10: [mem 0xf2600000-0xf261ffff]
[    0.818807] pci 0000:00:19.0: reg 14: [mem 0xf2625000-0xf2625fff]
[    0.818822] pci 0000:00:19.0: reg 18: [io  0x1840-0x185f]
[    0.818914] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.818920] pci 0000:00:19.0: PME# disabled
[    0.818968] pci 0000:00:1a.0: [8086:2937] type 0 class 0x000c03
[    0.819042] pci 0000:00:1a.0: reg 20: [io  0x1860-0x187f]
[    0.819135] pci 0000:00:1a.1: [8086:2938] type 0 class 0x000c03
[    0.819209] pci 0000:00:1a.1: reg 20: [io  0x1880-0x189f]
[    0.819300] pci 0000:00:1a.2: [8086:2939] type 0 class 0x000c03
[    0.819375] pci 0000:00:1a.2: reg 20: [io  0x18a0-0x18bf]
[    0.819483] pci 0000:00:1a.7: [8086:293c] type 0 class 0x000c03
[    0.819516] pci 0000:00:1a.7: reg 10: [mem 0xf2826c00-0xf2826fff]
[    0.819633] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.819640] pci 0000:00:1a.7: PME# disabled
[    0.819694] pci 0000:00:1b.0: [8086:293e] type 0 class 0x000403
[    0.819721] pci 0000:00:1b.0: reg 10: [mem 0xf2620000-0xf2623fff 64bit]
[    0.819832] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.819838] pci 0000:00:1b.0: PME# disabled
[    0.819889] pci 0000:00:1c.0: [8086:2940] type 1 class 0x000604
[    0.820002] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.820008] pci 0000:00:1c.0: PME# disabled
[    0.820200] pci 0000:00:1c.1: [8086:2942] type 1 class 0x000604
[    0.820313] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.820320] pci 0000:00:1c.1: PME# disabled
[    0.820374] pci 0000:00:1c.3: [8086:2946] type 1 class 0x000604
[    0.820488] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.820494] pci 0000:00:1c.3: PME# disabled
[    0.820555] pci 0000:00:1d.0: [8086:2934] type 0 class 0x000c03
[    0.820630] pci 0000:00:1d.0: reg 20: [io  0x18c0-0x18df]
[    0.820723] pci 0000:00:1d.1: [8086:2935] type 0 class 0x000c03
[    0.820797] pci 0000:00:1d.1: reg 20: [io  0x18e0-0x18ff]
[    0.820890] pci 0000:00:1d.2: [8086:2936] type 0 class 0x000c03
[    0.820964] pci 0000:00:1d.2: reg 20: [io  0x1c00-0x1c1f]
[    0.821073] pci 0000:00:1d.7: [8086:293a] type 0 class 0x000c03
[    0.821106] pci 0000:00:1d.7: reg 10: [mem 0xf2827000-0xf28273ff]
[    0.821223] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.821230] pci 0000:00:1d.7: PME# disabled
[    0.821279] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.821402] pci 0000:00:1f.0: [8086:2917] type 0 class 0x000601
[    0.821610] pci 0000:00:1f.2: [8086:2929] type 0 class 0x000106
[    0.821646] pci 0000:00:1f.2: reg 10: [io  0x1c48-0x1c4f]
[    0.821661] pci 0000:00:1f.2: reg 14: [io  0x183c-0x183f]
[    0.821676] pci 0000:00:1f.2: reg 18: [io  0x1c40-0x1c47]
[    0.821691] pci 0000:00:1f.2: reg 1c: [io  0x1838-0x183b]
[    0.821706] pci 0000:00:1f.2: reg 20: [io  0x1c20-0x1c3f]
[    0.821721] pci 0000:00:1f.2: reg 24: [mem 0xf2826000-0xf28267ff]
[    0.821787] pci 0000:00:1f.2: PME# supported from D3hot
[    0.821793] pci 0000:00:1f.2: PME# disabled
[    0.821840] pci 0000:00:1f.3: [8086:2930] type 0 class 0x000c05
[    0.821868] pci 0000:00:1f.3: reg 10: [mem 0xf2827400-0xf28274ff 64bit]
[    0.821907] pci 0000:00:1f.3: reg 20: [io  0x1c60-0x1c7f]
[    0.822045] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.822100] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.822106] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.822117] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.822262] pci 0000:03:00.0: [8086:4237] type 0 class 0x000280
[    0.822307] pci 0000:03:00.0: reg 10: [mem 0xf2500000-0xf2501fff 64bit]
[    0.822496] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.822505] pci 0000:03:00.0: PME# disabled
[    0.822578] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.822632] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
[    0.822639] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
[    0.822649] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.822742] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.822796] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.822802] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.822812] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[    0.822950] pci 0000:00:1e.0: PCI bridge to [bus 0d-0d] (subtractive decode)
[    0.823006] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.823013] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.823023] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.823036] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.823047] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.823059] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.823070] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.823082] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.823094] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
[    0.823128] pci_bus 0000:00: on NUMA node 0
[    0.823150] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.829836] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.831271] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.832777] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.841525]  pci0000:00: ACPI _OSC support set (0x18)
[    0.841576]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.854220]  pci0000:00: ACPI _OSC control (0x1d) granted
[    1.057374] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    1.059620] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    1.061991] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    1.064247] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    1.066479] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    1.068822] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    1.071057] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    1.073307] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    1.074568] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.074813] vgaarb: loaded
[    1.076401] SCSI subsystem initialized
[    1.076477] libata version 3.00 loaded.
[    1.076780] PCI: Using ACPI for IRQ routing
[    1.076780] PCI: pci_cache_line_size set to 64 bytes
[    1.076780] reserve RAM buffer: 000000000009ec00 - 000000000009ffff 
[    1.076780] reserve RAM buffer: 00000000bd6a1000 - 00000000bfffffff 
[    1.076927] reserve RAM buffer: 00000000bd7b7000 - 00000000bfffffff 
[    1.077058] reserve RAM buffer: 00000000bd8c7000 - 00000000bfffffff 
[    1.077166] reserve RAM buffer: 00000000bdc00000 - 00000000bfffffff 
[    1.078328] Bluetooth: Core ver 2.15
[    1.078476] NET: Registered protocol family 31
[    1.078525] Bluetooth: HCI device and connection manager initialized
[    1.078590] Bluetooth: HCI socket layer initialized
[    1.080230] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    1.084277] Switching to clocksource hpet
[    1.084401] pnp: PnP ACPI init
[    1.084596] ACPI: bus type pnp registered
[    1.087602] Switched to NOHz mode on CPU #0
[    1.087667] Switched to NOHz mode on CPU #1
[    1.118159] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    1.118170] pnp 00:00: [mem 0x000c0000-0x000c3fff]
[    1.118180] pnp 00:00: [mem 0x000c4000-0x000c7fff]
[    1.118190] pnp 00:00: [mem 0x000c8000-0x000cbfff]
[    1.118200] pnp 00:00: [mem 0x000cc000-0x000cffff]
[    1.118209] pnp 00:00: [mem 0x000d0000-0x000d3fff]
[    1.118219] pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
[    1.118229] pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
[    1.118239] pnp 00:00: [mem 0x000dc000-0x000dffff]
[    1.118248] pnp 00:00: [mem 0x000e0000-0x000e3fff]
[    1.118257] pnp 00:00: [mem 0x000e4000-0x000e7fff]
[    1.118267] pnp 00:00: [mem 0x000e8000-0x000ebfff]
[    1.118276] pnp 00:00: [mem 0x000ec000-0x000effff]
[    1.118285] pnp 00:00: [mem 0x000f0000-0x000fffff]
[    1.118295] pnp 00:00: [mem 0x00100000-0xbfffffff]
[    1.118305] pnp 00:00: [mem 0xfec00000-0xfed3ffff]
[    1.118314] pnp 00:00: [mem 0xfed4c000-0xffffffff]
[    1.119014] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    1.119087] system 00:00: [mem 0x000c0000-0x000c3fff] has been reserved
[    1.119158] system 00:00: [mem 0x000c4000-0x000c7fff] has been reserved
[    1.119228] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    1.119298] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    1.119368] system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
[    1.119444] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
[    1.119520] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    1.119597] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    1.119673] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    1.119749] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    1.119825] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    1.119902] system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
[    1.119979] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    1.120072] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    1.120128] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.120336] pnp 00:01: [bus 00-ff]
[    1.120346] pnp 00:01: [io  0x0cf8-0x0cff]
[    1.120356] pnp 00:01: [io  0x0000-0x0cf7 window]
[    1.120366] pnp 00:01: [io  0x0d00-0xffff window]
[    1.120376] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    1.120385] pnp 00:01: [mem 0x000c0000-0x000c3fff window]
[    1.120395] pnp 00:01: [mem 0x000c4000-0x000c7fff window]
[    1.120406] pnp 00:01: [mem 0x000c8000-0x000cbfff window]
[    1.120416] pnp 00:01: [mem 0x000cc000-0x000cffff window]
[    1.120425] pnp 00:01: [mem 0x000d0000-0x000d3fff window]
[    1.120435] pnp 00:01: [mem 0x000d4000-0x000d7fff window]
[    1.120444] pnp 00:01: [mem 0x000d8000-0x000dbfff window]
[    1.120454] pnp 00:01: [mem 0x000dc000-0x000dffff window]
[    1.120463] pnp 00:01: [mem 0x000e0000-0x000e3fff window]
[    1.120473] pnp 00:01: [mem 0x000e4000-0x000e7fff window]
[    1.120483] pnp 00:01: [mem 0x000e8000-0x000ebfff window]
[    1.120492] pnp 00:01: [mem 0x000ec000-0x000effff window]
[    1.120502] pnp 00:01: [mem 0xc0000000-0xfebfffff window]
[    1.120512] pnp 00:01: [mem 0xfed40000-0xfed4bfff window]
[    1.120876] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    1.143094] pnp 00:02: [io  0x0010-0x001f]
[    1.143104] pnp 00:02: [io  0x0090-0x009f]
[    1.143113] pnp 00:02: [io  0x0024-0x0025]
[    1.143123] pnp 00:02: [io  0x0028-0x0029]
[    1.143132] pnp 00:02: [io  0x002c-0x002d]
[    1.143141] pnp 00:02: [io  0x0030-0x0031]
[    1.143150] pnp 00:02: [io  0x0034-0x0035]
[    1.143159] pnp 00:02: [io  0x0038-0x0039]
[    1.143169] pnp 00:02: [io  0x003c-0x003d]
[    1.143178] pnp 00:02: [io  0x00a4-0x00a5]
[    1.143187] pnp 00:02: [io  0x00a8-0x00a9]
[    1.143197] pnp 00:02: [io  0x00ac-0x00ad]
[    1.143206] pnp 00:02: [io  0x00b0-0x00b5]
[    1.143215] pnp 00:02: [io  0x00b8-0x00b9]
[    1.143224] pnp 00:02: [io  0x00bc-0x00bd]
[    1.143233] pnp 00:02: [io  0x0050-0x0053]
[    1.143243] pnp 00:02: [io  0x0072-0x0077]
[    1.143252] pnp 00:02: [io  0x002e-0x002f]
[    1.143261] pnp 00:02: [io  0x1000-0x107f]
[    1.143270] pnp 00:02: [io  0x1180-0x11ff]
[    1.143280] pnp 00:02: [io  0x0800-0x080f]
[    1.143289] pnp 00:02: [io  0x15e0-0x15ef]
[    1.143298] pnp 00:02: [io  0x1600-0x167f]
[    1.143307] pnp 00:02: [io  0x1680-0x169f]
[    1.143317] pnp 00:02: [mem 0xe0000000-0xefffffff]
[    1.143326] pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
[    1.143335] pnp 00:02: [mem 0xfed10000-0xfed13fff]
[    1.143345] pnp 00:02: [mem 0xfed18000-0xfed18fff]
[    1.143354] pnp 00:02: [mem 0xfed19000-0xfed19fff]
[    1.143364] pnp 00:02: [mem 0xfed45000-0xfed4bfff]
[    1.144102] system 00:02: [io  0x1000-0x107f] has been reserved
[    1.144173] system 00:02: [io  0x1180-0x11ff] has been reserved
[    1.144243] system 00:02: [io  0x0800-0x080f] has been reserved
[    1.144312] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    1.144382] system 00:02: [io  0x1600-0x167f] has been reserved
[    1.144451] system 00:02: [io  0x1680-0x169f] has been reserved
[    1.144522] system 00:02: [mem 0xe0000000-0xefffffff] has been reserved
[    1.144592] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.144663] system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
[    1.144734] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    1.144805] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    1.144875] system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
[    1.144930] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.145559] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    1.145917] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.146050] pnp 00:04: [io  0x0000-0x000f]
[    1.146060] pnp 00:04: [io  0x0080-0x008f]
[    1.146069] pnp 00:04: [io  0x00c0-0x00df]
[    1.146079] pnp 00:04: [dma 4]
[    1.146436] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.146569] pnp 00:05: [io  0x0061]
[    1.146927] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.147061] pnp 00:06: [io  0x00f0]
[    1.147079] pnp 00:06: [irq 13]
[    1.147439] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.147572] pnp 00:07: [io  0x0070-0x0071]
[    1.147588] pnp 00:07: [irq 8]
[    1.147946] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.148100] pnp 00:08: [io  0x0060]
[    1.148109] pnp 00:08: [io  0x0064]
[    1.148124] pnp 00:08: [irq 1]
[    1.148490] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.148628] pnp 00:09: [irq 12]
[    1.149000] pnp 00:09: Plug and Play ACPI device, IDs IBM3780 PNP0f13 (active)
[    1.170864] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    1.171228] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c31 (active)
[    1.175295] pnp: PnP ACPI: found 11 devices
[    1.175345] ACPI: ACPI bus type pnp unregistered
[    1.202928] pci 0000:00:1c.0: BAR 8: assigned [mem 0xc0000000-0xc01fffff]
[    1.202987] pci 0000:00:1c.0: BAR 9: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
[    1.203055] pci 0000:00:1c.1: BAR 9: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
[    1.203123] pci 0000:00:1c.0: BAR 7: assigned [io  0x3000-0x3fff]
[    1.203179] pci 0000:00:1c.1: BAR 7: assigned [io  0x4000-0x4fff]
[    1.203233] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.203285] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    1.203341] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff]
[    1.203397] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
[    1.203467] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    1.203519] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
[    1.203575] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
[    1.203630] pci 0000:00:1c.1:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
[    1.203700] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    1.203752] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    1.203808] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    1.203864] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[    1.203934] pci 0000:00:1e.0: PCI bridge to [bus 0d-0d]
[    1.203984] pci 0000:00:1e.0:   bridge window [io  disabled]
[    1.204058] pci 0000:00:1e.0:   bridge window [mem disabled]
[    1.204112] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    1.204191] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.204247] pci 0000:00:1c.0: setting latency timer to 64
[    1.204268] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.204324] pci 0000:00:1c.1: setting latency timer to 64
[    1.204345] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    1.204400] pci 0000:00:1c.3: setting latency timer to 64
[    1.204410] pci 0000:00:1e.0: setting latency timer to 64
[    1.204416] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.204419] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.204422] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.204425] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    1.204428] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    1.204431] pci_bus 0000:00: resource 9 [mem 0xc0000000-0xfebfffff]
[    1.204434] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
[    1.204437] pci_bus 0000:02: resource 1 [mem 0xc0000000-0xc01fffff]
[    1.204440] pci_bus 0000:02: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
[    1.204443] pci_bus 0000:03: resource 0 [io  0x4000-0x4fff]
[    1.204446] pci_bus 0000:03: resource 1 [mem 0xf2500000-0xf25fffff]
[    1.204449] pci_bus 0000:03: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
[    1.204453] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    1.204456] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
[    1.204459] pci_bus 0000:05: resource 2 [mem 0xf2900000-0xf29fffff 64bit pref]
[    1.204462] pci_bus 0000:0d: resource 4 [io  0x0000-0x0cf7]
[    1.204465] pci_bus 0000:0d: resource 5 [io  0x0d00-0xffff]
[    1.204468] pci_bus 0000:0d: resource 6 [mem 0x000a0000-0x000bffff]
[    1.204471] pci_bus 0000:0d: resource 7 [mem 0x000d4000-0x000d7fff]
[    1.204474] pci_bus 0000:0d: resource 8 [mem 0x000d8000-0x000dbfff]
[    1.204477] pci_bus 0000:0d: resource 9 [mem 0xc0000000-0xfebfffff]
[    1.204612] NET: Registered protocol family 2
[    1.204913] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.206451] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    1.208269] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
[    1.211533] TCP: Hash tables configured (established 262144 bind 65536)
[    1.211620] TCP reno registered
[    1.211690] UDP hash table entries: 2048 (order: 6, 327680 bytes)
[    1.211985] UDP-Lite hash table entries: 2048 (order: 6, 327680 bytes)
[    1.212729] NET: Registered protocol family 1
[    1.212848] pci 0000:00:02.0: Boot video device
[    1.212918] pci 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.212921] pci 0000:00:1a.0: Performing full reset
[    1.212953] pci 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.212955] pci 0000:00:1a.1: Performing full reset
[    1.212986] pci 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.212989] pci 0000:00:1a.2: Performing full reset
[    1.213144] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.213146] pci 0000:00:1d.0: Performing full reset
[    1.213177] pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.213179] pci 0000:00:1d.1: Performing full reset
[    1.213211] pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.213213] pci 0000:00:1d.2: Performing full reset
[    1.213353] PCI: CLS 64 bytes, default 64
[    1.213730] Trying to unpack rootfs image as initramfs...
[    2.192396] Freeing initrd memory: 34952k freed
[    2.352357] DMA-API: preallocated 32768 debug entries
[    2.352413] DMA-API: debugging enabled by kernel config
[    2.352469] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.352522] Placing 64MB software IO TLB between ffff8800b8c9d000 - ffff8800bcc9d000
[    2.352585] software IO TLB at phys 0xb8c9d000 - 0xbcc9d000
[    2.352813] Simple Boot Flag at 0x35 set to 0x1
[    2.354278] Scanning for low memory corruption every 60 seconds
[    2.355144] audit: initializing netlink socket (disabled)
[    2.355272] type=2000 audit(1299036963.348:1): initialized
[    2.372462] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.397514] fuse init (API version 7.16)
[    2.398472] msgmni has been set to 7697
[    2.399748] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    2.399819] io scheduler noop registered
[    2.399867] io scheduler deadline registered
[    2.400332] io scheduler cfq registered (default)
[    2.401293] pcieport 0000:00:1c.0: setting latency timer to 64
[    2.401373] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    2.402091] pcieport 0000:00:1c.1: setting latency timer to 64
[    2.402166] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    2.402874] pcieport 0000:00:1c.3: setting latency timer to 64
[    2.402949] pcieport 0000:00:1c.3: irq 42 for MSI/MSI-X
[    2.403981] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    2.404063] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    2.404248] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
[    2.404302] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    2.404900] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
[    2.405084] pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
[    2.405141] pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
[    2.405316] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.406151] pciehp 0000:00:1c.0:pcie04: HPC vendor_id 8086 device_id 2940 ss_vid 17aa ss_did 20f3
[    2.406450] pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
[    2.406505] pciehp 0000:00:1c.1:pcie04: HPC vendor_id 8086 device_id 2942 ss_vid 17aa ss_did 20f3
[    2.406790] pciehp 0000:00:1c.1:pcie04: service driver pciehp loaded
[    2.406847] pciehp 0000:00:1c.3:pcie04: HPC vendor_id 8086 device_id 2946 ss_vid 17aa ss_did 20f3
[    2.407133] pciehp 0000:00:1c.3:pcie04: service driver pciehp loaded
[    2.407195] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.408022] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    2.409231] ACPI: AC Adapter [AC] (on-line)
[    2.410698] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    2.444027] ACPI: Lid Switch [LID]
[    2.444738] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    2.508021] ACPI: Sleep Button [SLPB]
[    2.508752] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    2.508828] ACPI: Power Button [PWRF]
[    2.509061] ACPI: acpi_idle registered with cpuidle
[    2.628413] Monitor-Mwait will be used to enter C-1 state
[    2.628494] Monitor-Mwait will be used to enter C-2 state
[    2.628570] Monitor-Mwait will be used to enter C-3 state
[    2.628583] Marking TSC unstable due to TSC halts in idle
[    2.725795] thermal LNXTHERM:00: registered as thermal_zone0
[    2.725847] ACPI: Thermal Zone [THM0] (56 C)
[    2.735633] thermal LNXTHERM:01: registered as thermal_zone1
[    2.735685] ACPI: Thermal Zone [THM1] (60 C)
[    2.736475] Linux agpgart interface v0.103
[    2.752714] brd: module loaded
[    2.760662] loop: module loaded
[    2.762233] ahci 0000:00:1f.2: version 3.0
[    2.762274] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    2.762492] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    2.762603] ahci: SSS flag set, parallel bus scan disabled
[    2.762680] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
[    2.762746] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc sxs 
[    2.762893] ahci 0000:00:1f.2: setting latency timer to 64
[    2.773832] scsi0 : ahci
[    2.777968] scsi1 : ahci
[    2.779147] scsi2 : ahci
[    2.780318] scsi3 : ahci
[    2.787236] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    2.787393] ACPI: Battery Slot [BAT0] (battery present)
[    2.791583] ata1: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826100 irq 43
[    2.791649] ata2: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826180 irq 43
[    2.791711] ata3: DUMMY
[    2.791757] ata4: DUMMY
[    2.792335] ata_generic 0000:00:03.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.792520] ata_generic 0000:00:03.2: setting latency timer to 64
[    2.798654] scsi4 : ata_generic
[    2.799673] scsi5 : ata_generic
[    2.800664] ata5: PATA max UDMA/100 cmd 0x1828 ctl 0x180c bmdma 0x1810 irq 18
[    2.800718] ata6: PATA max UDMA/100 cmd 0x1820 ctl 0x1808 bmdma 0x1818 irq 18
[    2.801004] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.20-k2
[    2.801056] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    2.801184] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.801260] e1000e 0000:00:19.0: setting latency timer to 64
[    2.801536] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    3.108032] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.112117] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    3.112122] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    3.112187] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    3.119404] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1f:16:1d:fb:eb
[    3.119470] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    3.119544] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1008FF-0FF
[    3.119752] PPP generic driver version 2.4.2
[    3.120623] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    3.132529] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.132965] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.133943] mousedev: PS/2 mouse device common for all mice
[    3.135413] rtc_cmos 00:07: RTC can wake from S4
[    3.140681] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    3.148620] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    3.148744] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    3.148858] Linux video capture interface: v2.00
[    3.149369] device-mapper: uevent: version 1.0.3
[    3.150034] device-mapper: ioctl: 4.19.1-ioctl (2011-01-07) initialised: dm-devel@redhat.com
[    3.150292] device-mapper: multipath: version 1.2.0 loaded
[    3.150359] device-mapper: multipath round-robin: version 1.0.0 loaded
[    3.151865] cpuidle: using governor ladder
[    3.153424] cpuidle: using governor menu
[    3.154385] TCP cubic registered
[    3.155396] ata1.00: ATA-8: ST9250410AS, 0002SDM1, max UDMA/133
[    3.155449] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    3.155738] NET: Registered protocol family 10
[    3.158305] NET: Registered protocol family 17
[    3.160108] Bluetooth: L2CAP ver 2.15
[    3.160156] Bluetooth: L2CAP socket layer initialized
[    3.160222] Bluetooth: SCO (Voice Link) ver 0.6
[    3.160271] Bluetooth: SCO socket layer initialized
[    3.160440] Bluetooth: RFCOMM TTY layer initialized
[    3.160511] Bluetooth: RFCOMM socket layer initialized
[    3.160565] Bluetooth: RFCOMM ver 1.11
[    3.160616] Registering the dns_resolver key type
[    3.160781] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    3.160785] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    3.160850] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    3.162829] ata1.00: configured for UDMA/133
[    3.163590] scsi 0:0:0:0: Direct-Access     ATA      ST9250410AS      0002 PQ: 0 ANSI: 5
[    3.165647] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    3.166345] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.166360] sd 0:0:0:0: [sda] Write Protect is off
[    3.166363] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.166633] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.200091]  sda: sda1 sda2 < sda5 >
[    3.203140] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.484077] ata2: SATA link down (SStatus 0 SControl 300)
[    3.665789] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    3.683619] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input4
[    3.689198] registered taskstats version 1
[    3.689405] kmemleak: Kernel memory leak detector initialized
[    3.689436] kmemleak: Automatic memory scanning thread started
[    3.690672] rtc_cmos 00:07: setting system clock to 2011-03-02 03:36:05 UTC (1299036965)
[    3.690738] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    3.690788] EDD information not available.
[    3.693331] Freeing unused kernel memory: 524k freed
[    3.693570] Write protecting the kernel read-only data: 8192k
[    3.698813] Freeing unused kernel memory: 1360k freed
[    3.699542] Freeing unused kernel memory: 8k freed
[    3.824542] udevd (119): /proc/119/oom_adj is deprecated, please use /proc/119/oom_score_adj instead.
[    4.001062] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[    4.001494] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    4.034921] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    4.035847] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    4.175625] usbcore: registered new interface driver usbfs
[    4.175958] usbcore: registered new interface driver hub
[    4.189952] usbcore: registered new device driver usb
[    4.200600] uhci_hcd: USB Universal Host Controller Interface driver
[    4.201299] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    4.201369] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    4.201429] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.201508] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.201513] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    4.201700] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.201755] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    4.201821] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    4.201842] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    4.214233] [drm] Initialized drm 1.1.0 20060810
[    4.220236] uhci_hcd 0000:00:1a.0: detected 2 ports
[    4.220294] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    4.220297] uhci_hcd 0000:00:1a.0: Performing full reset
[    4.220315] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    4.220485] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    4.221342] usb usb1: default language 0x0409
[    4.221508] usb usb1: udev 1, busnum 1, minor = 0
[    4.221511] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    4.221565] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.221627] usb usb1: Product: UHCI Host Controller
[    4.221676] usb usb1: Manufacturer: Linux 2.6.38-rc6+ uhci_hcd
[    4.221727] usb usb1: SerialNumber: 0000:00:1a.0
[    4.222620] usb usb1: usb_probe_device
[    4.222625] usb usb1: configuration #1 chosen from 1 choice
[    4.223346] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    4.229047] hub 1-0:1.0: usb_probe_interface
[    4.229051] hub 1-0:1.0: usb_probe_interface - got id
[    4.229056] hub 1-0:1.0: USB hub found
[    4.229205] hub 1-0:1.0: 2 ports detected
[    4.229270] hub 1-0:1.0: standalone hub
[    4.229272] hub 1-0:1.0: no power switching (usb 1.0)
[    4.229275] hub 1-0:1.0: individual port over-current protection
[    4.229278] hub 1-0:1.0: power on to power good time: 2ms
[    4.229399] hub 1-0:1.0: local power source is good
[    4.229418] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    4.231355] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    4.231442] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    4.231447] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    4.231555] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[    4.240390] uhci_hcd 0000:00:1a.1: detected 2 ports
[    4.240454] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    4.240457] uhci_hcd 0000:00:1a.1: Performing full reset
[    4.240653] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    4.241087] usb usb2: default language 0x0409
[    4.241256] usb usb2: udev 1, busnum 2, minor = 128
[    4.241259] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    4.241315] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.241382] usb usb2: Product: UHCI Host Controller
[    4.241434] usb usb2: Manufacturer: Linux 2.6.38-rc6+ uhci_hcd
[    4.241487] usb usb2: SerialNumber: 0000:00:1a.1
[    4.243599] usb usb2: usb_probe_device
[    4.243604] usb usb2: configuration #1 chosen from 1 choice
[    4.243689] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    4.244277] hub 2-0:1.0: usb_probe_interface
[    4.244281] hub 2-0:1.0: usb_probe_interface - got id
[    4.244286] hub 2-0:1.0: USB hub found
[    4.244433] hub 2-0:1.0: 2 ports detected
[    4.244498] hub 2-0:1.0: standalone hub
[    4.244501] hub 2-0:1.0: no power switching (usb 1.0)
[    4.244503] hub 2-0:1.0: individual port over-current protection
[    4.244506] hub 2-0:1.0: power on to power good time: 2ms
[    4.244604] hub 2-0:1.0: local power source is good
[    4.244623] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    4.246498] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    4.246566] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    4.246642] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    4.246720] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    4.246725] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    4.246830] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 3
[    4.256144] uhci_hcd 0000:00:1a.2: detected 2 ports
[    4.256199] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    4.256202] uhci_hcd 0000:00:1a.2: Performing full reset
[    4.256219] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    4.256389] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[    4.256783] usb usb3: default language 0x0409
[    4.256949] usb usb3: udev 1, busnum 3, minor = 256
[    4.256953] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    4.257006] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.257068] usb usb3: Product: UHCI Host Controller
[    4.257117] usb usb3: Manufacturer: Linux 2.6.38-rc6+ uhci_hcd
[    4.257168] usb usb3: SerialNumber: 0000:00:1a.2
[    4.258049] usb usb3: usb_probe_device
[    4.258053] usb usb3: configuration #1 chosen from 1 choice
[    4.258133] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    4.258686] hub 3-0:1.0: usb_probe_interface
[    4.258689] hub 3-0:1.0: usb_probe_interface - got id
[    4.258694] hub 3-0:1.0: USB hub found
[    4.258842] hub 3-0:1.0: 2 ports detected
[    4.258907] hub 3-0:1.0: standalone hub
[    4.258909] hub 3-0:1.0: no power switching (usb 1.0)
[    4.258911] hub 3-0:1.0: individual port over-current protection
[    4.258915] hub 3-0:1.0: power on to power good time: 2ms
[    4.259014] hub 3-0:1.0: local power source is good
[    4.259032] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    4.260989] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    4.261057] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    4.261114] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.261192] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.261197] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.261298] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    4.280165] uhci_hcd 0000:00:1d.0: detected 2 ports
[    4.280219] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    4.280221] uhci_hcd 0000:00:1d.0: Performing full reset
[    4.280238] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    4.280382] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[    4.280816] usb usb4: default language 0x0409
[    4.280986] usb usb4: udev 1, busnum 4, minor = 384
[    4.280989] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    4.281047] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.281109] usb usb4: Product: UHCI Host Controller
[    4.281157] usb usb4: Manufacturer: Linux 2.6.38-rc6+ uhci_hcd
[    4.281207] usb usb4: SerialNumber: 0000:00:1d.0
[    4.282105] usb usb4: usb_probe_device
[    4.282109] usb usb4: configuration #1 chosen from 1 choice
[    4.282188] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    4.282748] hub 4-0:1.0: usb_probe_interface
[    4.282752] hub 4-0:1.0: usb_probe_interface - got id
[    4.282756] hub 4-0:1.0: USB hub found
[    4.282905] hub 4-0:1.0: 2 ports detected
[    4.282969] hub 4-0:1.0: standalone hub
[    4.282972] hub 4-0:1.0: no power switching (usb 1.0)
[    4.282974] hub 4-0:1.0: individual port over-current protection
[    4.282978] hub 4-0:1.0: power on to power good time: 2ms
[    4.283078] hub 4-0:1.0: local power source is good
[    4.283098] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    4.285034] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    4.285111] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.285116] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.285217] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
[    4.301061] uhci_hcd 0000:00:1d.1: detected 2 ports
[    4.301116] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    4.301119] uhci_hcd 0000:00:1d.1: Performing full reset
[    4.301305] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[    4.301697] usb usb5: default language 0x0409
[    4.301871] usb usb5: udev 1, busnum 5, minor = 512
[    4.301874] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    4.301927] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.301990] usb usb5: Product: UHCI Host Controller
[    4.302040] usb usb5: Manufacturer: Linux 2.6.38-rc6+ uhci_hcd
[    4.302130] usb usb5: SerialNumber: 0000:00:1d.1
[    4.302984] usb usb5: usb_probe_device
[    4.302988] usb usb5: configuration #1 chosen from 1 choice
[    4.303079] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    4.303599] hub 5-0:1.0: usb_probe_interface
[    4.303602] hub 5-0:1.0: usb_probe_interface - got id
[    4.303606] hub 5-0:1.0: USB hub found
[    4.303801] hub 5-0:1.0: 2 ports detected
[    4.303877] hub 5-0:1.0: standalone hub
[    4.303880] hub 5-0:1.0: no power switching (usb 1.0)
[    4.303882] hub 5-0:1.0: individual port over-current protection
[    4.303885] hub 5-0:1.0: power on to power good time: 2ms
[    4.303988] hub 5-0:1.0: local power source is good
[    4.304027] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    4.305909] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    4.305987] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    4.305992] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.306093] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
[    4.316098] uhci_hcd 0000:00:1d.2: detected 2 ports
[    4.316153] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    4.316156] uhci_hcd 0000:00:1d.2: Performing full reset
[    4.316213] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[    4.316564] usb usb6: default language 0x0409
[    4.316710] usb usb6: udev 1, busnum 6, minor = 640
[    4.316713] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    4.316764] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.316826] usb usb6: Product: UHCI Host Controller
[    4.316874] usb usb6: Manufacturer: Linux 2.6.38-rc6+ uhci_hcd
[    4.316924] usb usb6: SerialNumber: 0000:00:1d.2
[    4.317832] usb usb6: usb_probe_device
[    4.317835] usb usb6: configuration #1 chosen from 1 choice
[    4.317915] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    4.318526] hub 6-0:1.0: usb_probe_interface
[    4.318530] hub 6-0:1.0: usb_probe_interface - got id
[    4.318534] hub 6-0:1.0: USB hub found
[    4.318680] hub 6-0:1.0: 2 ports detected
[    4.318745] hub 6-0:1.0: standalone hub
[    4.318748] hub 6-0:1.0: no power switching (usb 1.0)
[    4.318750] hub 6-0:1.0: individual port over-current protection
[    4.318753] hub 6-0:1.0: power on to power good time: 2ms
[    4.318851] hub 6-0:1.0: local power source is good
[    4.318870] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    4.320780] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    4.320851] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    4.320910] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    4.321043] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    4.321049] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    4.321149] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 7
[    4.328248] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.332258] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    4.332265] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    4.332446] ehci_hcd 0000:00:1a.7: debug port 1
[    4.332499] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.336381] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    4.336384] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    4.336527] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xf2826c00
[    4.336580] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.340466] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    4.344117] uhci_hcd 0000:00:1a.1: port 1 portsc 0082,00
[    4.352074] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    4.352449] usb usb7: default language 0x0409
[    4.352593] usb usb7: udev 1, busnum 7, minor = 768
[    4.352595] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
[    4.352647] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.352708] usb usb7: Product: EHCI Host Controller
[    4.352756] usb usb7: Manufacturer: Linux 2.6.38-rc6+ ehci_hcd
[    4.352806] usb usb7: SerialNumber: 0000:00:1a.7
[    4.353532] usb usb7: usb_probe_device
[    4.353535] usb usb7: configuration #1 chosen from 1 choice
[    4.353614] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    4.354194] hub 7-0:1.0: usb_probe_interface
[    4.354197] hub 7-0:1.0: usb_probe_interface - got id
[    4.354202] hub 7-0:1.0: USB hub found
[    4.354365] hub 7-0:1.0: 6 ports detected
[    4.354428] hub 7-0:1.0: standalone hub
[    4.354431] hub 7-0:1.0: no power switching (usb 1.0)
[    4.354433] hub 7-0:1.0: individual port over-current protection
[    4.354437] hub 7-0:1.0: power on to power good time: 20ms
[    4.354532] hub 7-0:1.0: local power source is good
[    4.354550] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    4.356106] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.356398] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    4.356414] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
[    4.356430] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.2
[    4.356844] i915 0000:00:02.0: power state changed by ACPI to D0
[    4.356911] i915 0000:00:02.0: power state changed by ACPI to D0
[    4.356966] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.357019] i915 0000:00:02.0: setting latency timer to 64
[    4.380080] uhci_hcd 0000:00:1d.0: port 1 portsc 01a3,00
[    4.380093] hub 4-0:1.0: port 1: status 0301 change 0001
[    4.380143] uhci_hcd 0000:00:1d.0: port 2 portsc 0093,00
[    4.380152] hub 4-0:1.0: port 2: status 0101 change 0001
[    4.404416] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.420122] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.444071] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.452126] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 001803 0  ACK POWER sig=j CSC CONNECT
[    4.452137] hub 7-0:1.0: port 3: status 0501 change 0001
[    4.480056] hub 4-0:1.0: state 7 ports 2 chg 0006 evt 0000
[    4.480090] hub 4-0:1.0: port 1, status 0301, change 0000, 1.5 Mb/s
[    4.512372] i915 0000:00:02.0: irq 45 for MSI/MSI-X
[    4.512456] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    4.512516] [drm] Driver supports precise vblank timestamp query.
[    4.592078] usb 4-1: new low speed USB device using uhci_hcd and address 2
[    4.661403] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    4.749620] usb 4-1: skipped 1 descriptor after interface
[    4.749633] usb 4-1: skipped 1 descriptor after interface
[    4.754605] usb 4-1: default language 0x0409
[    4.769613] usb 4-1: udev 2, busnum 4, minor = 385
[    4.769617] usb 4-1: New USB device found, idVendor=046d, idProduct=c521
[    4.769670] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.769727] usb 4-1: Product: USB Receiver
[    4.769775] usb 4-1: Manufacturer: Logitech
[    4.770423] usb 4-1: usb_probe_device
[    4.770428] usb 4-1: configuration #1 chosen from 1 choice
[    4.780617] usb 4-1: adding 4-1:1.0 (config #1, interface 0)
[    4.781524] usb 4-1: adding 4-1:1.1 (config #1, interface 1)
[    4.783086] hub 4-0:1.0: port 2, status 0101, change 0000, 12 Mb/s
[    4.797211] usbhid 4-1:1.0: usb_probe_interface
[    4.797215] usbhid 4-1:1.0: usb_probe_interface - got id
[    4.813698] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1:1.0/input/input5
[    4.816136] generic-usb 0003:046D:C521.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1d.0-1/input0
[    4.816250] usbhid 4-1:1.1: usb_probe_interface
[    4.816253] usbhid 4-1:1.1: usb_probe_interface - got id
[    4.847403] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1:1.1/input/input6
[    4.847530] uhci_hcd 0000:00:1d.0: reserve dev 2 ep82-INT, period 8, phase 4, 118 us
[    4.848199] usbhid 4-1:1.1: looking for a minor, starting at 96
[    4.849361] generic-usb 0003:046D:C521.0002: input,hiddev0,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1d.0-1/input1
[    4.849554] usbcore: registered new interface driver usbhid
[    4.849608] usbhid: USB HID core driver
[    4.892111] usb 4-2: new full speed USB device using uhci_hcd and address 3
[    5.010095] fb0: inteldrmfb frame buffer device
[    5.010152] drm: registered panic notifier
[    5.024058] usb 4-2: ep0 maxpacket = 8
[    5.045604] usb 4-2: default language 0x0409
[    5.068619] usb 4-2: udev 3, busnum 4, minor = 386
[    5.068623] usb 4-2: New USB device found, idVendor=04b3, idProduct=301a
[    5.068676] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.068729] usb 4-2: Product: USB 1.1 2port downstream low power hub
[    5.068780] usb 4-2: Manufacturer: Lite-On Technology
[    5.069591] usb 4-2: usb_probe_device
[    5.069595] usb 4-2: configuration #1 chosen from 1 choice
[    5.075602] usb 4-2: adding 4-2:1.0 (config #1, interface 0)
[    5.077761] hub 4-2:1.0: usb_probe_interface
[    5.077764] hub 4-2:1.0: usb_probe_interface - got id
[    5.077769] hub 4-2:1.0: USB hub found
[    5.078607] hub 4-2:1.0: 3 ports detected
[    5.078670] hub 4-2:1.0: compound device; port removable status: FRR
[    5.078673] hub 4-2:1.0: individual port power switching
[    5.078676] hub 4-2:1.0: individual port over-current protection
[    5.078679] hub 4-2:1.0: power on to power good time: 44ms
[    5.079602] hub 4-2:1.0: hub controller current requirement: 100mA
[    5.079605] hub 4-2:1.0: 100mA bus power budget for each child
[    5.080616] hub 4-2:1.0: enabling power on all ports
[    5.084965] hub 7-0:1.0: state 7 ports 6 chg 0008 evt 0000
[    5.085016] hub 7-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[    5.110963] acpi device:02: registered as cooling_device2
[    5.114331] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input7
[    5.115063] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    5.115951] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    5.116113] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    5.116186] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    5.116264] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    5.116392] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    5.116397] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    5.116504] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 8
[    5.128292] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    5.128299] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    5.128498] ehci_hcd 0000:00:1d.7: debug port 1
[    5.128553] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    5.132458] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    5.132461] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    5.132649] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xf2827000
[    5.132655] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    5.136536] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    5.140368] ehci_hcd 0000:00:1a.7: port 3 full speed --> companion
[    5.140373] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 003801 0  ACK POWER OWNER sig=j CONNECT
[    5.140384] hub 7-0:1.0: port 3 not reset yet, waiting 50ms
[    5.144024] Console: switching to colour frame buffer device 180x56
[    5.181634] hub 4-2:1.0: port 1: status 0101 change 0001
[    5.196079] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    5.196682] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    5.196710] uhci_hcd 0000:00:1d.0: port 1 portsc 008a,00
[    5.196781] hub 4-0:1.0: port 1, status 0100, change 0003, 12 Mb/s
[    5.196785] usb 4-1: USB disconnect, address 2
[    5.196816] usb 4-1: unregistering device
[    5.196819] usb 4-1: unregistering interface 4-1:1.0
[    5.208028] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    5.208448] usb usb8: default language 0x0409
[    5.208629] usb usb8: udev 1, busnum 8, minor = 896
[    5.208632] usb usb8: New USB device found, idVendor=1d6b, idProduct=0002
[    5.208672] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.208714] usb usb8: Product: EHCI Host Controller
[    5.208743] usb usb8: Manufacturer: Linux 2.6.38-rc6+ ehci_hcd
[    5.208777] usb usb8: SerialNumber: 0000:00:1d.7
[    5.209660] usb usb8: usb_probe_device
[    5.209663] usb usb8: configuration #1 chosen from 1 choice
[    5.209754] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    5.210312] hub 8-0:1.0: usb_probe_interface
[    5.210316] hub 8-0:1.0: usb_probe_interface - got id
[    5.210320] hub 8-0:1.0: USB hub found
[    5.210471] hub 8-0:1.0: 6 ports detected
[    5.210513] hub 8-0:1.0: standalone hub
[    5.210516] hub 8-0:1.0: no power switching (usb 1.0)
[    5.210518] hub 8-0:1.0: individual port over-current protection
[    5.210521] hub 8-0:1.0: power on to power good time: 20ms
[    5.210630] hub 8-0:1.0: local power source is good
[    5.210649] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    5.212803] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    5.212820] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    5.212835] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    5.213556] usb 4-1: uhci_result_common: failed with status 440000
[    5.213568] uhci_hcd 0000:00:1d.0: release dev 2 ep82-INT, period 8, phase 4, 118 us
[    5.220026] Monitor-Mwait will be used to enter C-3 state
[    5.225286] usb 4-1: unregistering interface 4-1:1.1
[    5.244359] drivers/usb/core/file.c: removing 96 minor
[    5.245033] usb 4-1: usb_disable_device nuking all URBs
[    5.284108] uhci_hcd 0000:00:1d.0: reserve dev 3 ep81-INT, period 128, phase 0, 12 us
[    5.312106] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 001403 0  ACK POWER sig=k CSC CONNECT
[    5.312120] hub 8-0:1.0: port 1: status 0501 change 0001
[    5.312177] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 001803 0  ACK POWER sig=j CSC CONNECT
[    5.312186] hub 8-0:1.0: port 2: status 0501 change 0001
[    5.360030] usb usb6: suspend_rh (auto-stop)
[    5.360053] usb usb1: suspend_rh (auto-stop)
[    5.360081] usb usb3: suspend_rh (auto-stop)
[    5.360109] usb usb5: suspend_rh (auto-stop)
[    5.384132] hub 4-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x100
[    5.384160] uhci_hcd 0000:00:1d.0: port 2 portsc 008a,00
[    5.384225] hub 4-0:1.0: port 2, status 0100, change 0003, 12 Mb/s
[    5.384229] usb 4-2: USB disconnect, address 3
[    5.384260] usb 4-2: unregistering device
[    5.384263] usb 4-2: unregistering interface 4-2:1.0
[    5.384533] uhci_hcd 0000:00:1d.0: shutdown urb ffff88012d5786c0 ep1in-intr
[    5.385568] uhci_hcd 0000:00:1d.0: release dev 3 ep81-INT, period 128, phase 0, 12 us
[    5.385698] usb 4-2: usb_disable_device nuking all URBs
[    5.516168] hub 4-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
[    5.516176] hub 7-0:1.0: state 7 ports 6 chg 0000 evt 0008
[    5.516219] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    5.516250] uhci_hcd 0000:00:1a.1: port 1 portsc 0093,00
[    5.516300] hub 2-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[    5.571706] PM: Starting manual resume from disk
[    5.620251] EXT3-fs: barriers not enabled
[    5.638682] kjournald starting.  Commit interval 5 seconds
[    5.638877] EXT3-fs (sda1): mounted filesystem with writeback data mode
[    5.644061] hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
[    5.760174] usb 2-1: new full speed USB device using uhci_hcd and address 2
[    5.892126] usb 2-1: ep0 maxpacket = 8
[    5.918905] usb 2-1: default language 0x0409
[    5.927922] usb 2-1: udev 2, busnum 2, minor = 129
[    5.927926] usb 2-1: New USB device found, idVendor=08ff, idProduct=2810
[    5.929245] usb 2-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    5.930506] usb 2-1: Product: Fingerprint Sensor
[    5.932504] usb 2-1: usb_probe_device
[    5.932508] usb 2-1: configuration #1 chosen from 1 choice
[    5.934909] usb 2-1: adding 2-1:1.0 (config #1, interface 0)
[    5.936874] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    5.936890] hub 8-0:1.0: state 7 ports 6 chg 0006 evt 0000
[    5.936920] hub 8-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    5.936959] ehci_hcd 0000:00:1d.7: port 1 low speed --> companion
[    5.992103] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    5.992234] hub 8-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[    6.048317] ehci_hcd 0000:00:1d.7: port 2 full speed --> companion
[    6.048728] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 003801 0  ACK POWER OWNER sig=j CONNECT
[    6.048740] hub 8-0:1.0: port 2 not reset yet, waiting 50ms
[    6.108073] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    6.108182] hub 8-0:1.0: state 7 ports 6 chg 0000 evt 0004
[    6.108224] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0006
[    6.108250] uhci_hcd 0000:00:1d.0: port 1 portsc 01a3,00
[    6.108286] hub 4-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
[    6.236101] hub 4-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
[    6.348103] usb 4-1: new low speed USB device using uhci_hcd and address 4
[    6.505623] usb 4-1: skipped 1 descriptor after interface
[    6.505636] usb 4-1: skipped 1 descriptor after interface
[    6.510603] usb 4-1: default language 0x0409
[    6.525621] usb 4-1: udev 4, busnum 4, minor = 387
[    6.525624] usb 4-1: New USB device found, idVendor=046d, idProduct=c521
[    6.526901] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.528227] usb 4-1: Product: USB Receiver
[    6.529540] usb 4-1: Manufacturer: Logitech
[    6.531397] usb 4-1: usb_probe_device
[    6.531401] usb 4-1: configuration #1 chosen from 1 choice
[    6.541619] usb 4-1: adding 4-1:1.0 (config #1, interface 0)
[    6.542058] usbhid 4-1:1.0: usb_probe_interface
[    6.542061] usbhid 4-1:1.0: usb_probe_interface - got id
[    6.559087] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1:1.0/input/input8
[    6.562636] generic-usb 0003:046D:C521.0003: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1d.0-1/input0
[    6.564389] usb 4-1: adding 4-1:1.1 (config #1, interface 1)
[    6.564799] usbhid 4-1:1.1: usb_probe_interface
[    6.564802] usbhid 4-1:1.1: usb_probe_interface - got id
[    6.595698] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1:1.1/input/input9
[    6.597141] uhci_hcd 0000:00:1d.0: reserve dev 4 ep82-INT, period 8, phase 4, 118 us
[    6.598002] usbhid 4-1:1.1: looking for a minor, starting at 96
[    6.599377] generic-usb 0003:046D:C521.0004: input,hiddev0,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1d.0-1/input1
[    6.601945] uhci_hcd 0000:00:1d.0: port 2 portsc 0093,00
[    6.601977] hub 4-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[    6.728135] hub 4-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
[    6.808125] hub 1-0:1.0: hub_suspend
[    6.808135] usb usb1: bus auto-suspend
[    6.808139] usb usb1: suspend_rh
[    6.808159] hub 3-0:1.0: hub_suspend
[    6.808165] usb usb3: bus auto-suspend
[    6.808168] usb usb3: suspend_rh
[    6.808188] hub 5-0:1.0: hub_suspend
[    6.808194] usb usb5: bus auto-suspend
[    6.808197] usb usb5: suspend_rh
[    6.824099] hub 6-0:1.0: hub_suspend
[    6.824107] usb usb6: bus auto-suspend
[    6.824110] usb usb6: suspend_rh
[    6.844124] usb 4-2: new full speed USB device using uhci_hcd and address 5
[    6.980066] usb 4-2: ep0 maxpacket = 8
[    7.000606] usb 4-2: default language 0x0409
[    7.021622] usb 4-2: udev 5, busnum 4, minor = 388
[    7.021625] usb 4-2: New USB device found, idVendor=04b3, idProduct=301a
[    7.023076] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.024537] usb 4-2: Product: USB 1.1 2port downstream low power hub
[    7.025994] usb 4-2: Manufacturer: Lite-On Technology
[    7.028190] usb 4-2: usb_probe_device
[    7.028194] usb 4-2: configuration #1 chosen from 1 choice
[    7.033632] usb 4-2: adding 4-2:1.0 (config #1, interface 0)
[    7.035775] hub 4-2:1.0: usb_probe_interface
[    7.035778] hub 4-2:1.0: usb_probe_interface - got id
[    7.035783] hub 4-2:1.0: USB hub found
[    7.037611] hub 4-2:1.0: 3 ports detected
[    7.039050] hub 4-2:1.0: compound device; port removable status: FRR
[    7.039053] hub 4-2:1.0: individual port power switching
[    7.039055] hub 4-2:1.0: individual port over-current protection
[    7.039058] hub 4-2:1.0: power on to power good time: 44ms
[    7.039610] hub 4-2:1.0: hub controller current requirement: 100mA
[    7.039613] hub 4-2:1.0: 100mA bus power budget for each child
[    7.040623] hub 4-2:1.0: enabling power on all ports
[    7.044804] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    7.141616] hub 4-2:1.0: port 1: status 0101 change 0001
[    7.244126] uhci_hcd 0000:00:1d.0: reserve dev 5 ep81-INT, period 128, phase 0, 12 us
[    7.244159] hub 4-2:1.0: state 7 ports 3 chg 0002 evt 0000
[    7.245611] hub 4-2:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    7.321613] usb 4-2.1: new full speed USB device using uhci_hcd and address 6
[    7.416062] usb 4-2.1: ep0 maxpacket = 8
[    7.437635] usb 4-2.1: skipped 1 descriptor after interface
[    7.437648] usb 4-2.1: skipped 1 descriptor after interface
[    7.440605] usb 4-2.1: default language 0x0409
[    7.467621] usb 4-2.1: udev 6, busnum 4, minor = 389
[    7.467625] usb 4-2.1: New USB device found, idVendor=04b3, idProduct=301b
[    7.469105] usb 4-2.1: New USB device strings: Mfr=1, Product=3, SerialNumber=0
[    7.470480] usb 4-2.1: Product: USB Productivity Option Keyboard( has the hub in # 1 )
[    7.471920] usb 4-2.1: Manufacturer: Lite-On Technology
[    7.473997] usb 4-2.1: usb_probe_device
[    7.474001] usb 4-2.1: configuration #1 chosen from 1 choice
[    7.479632] usb 4-2.1: adding 4-2.1:1.0 (config #1, interface 0)
[    7.481785] usbhid 4-2.1:1.0: usb_probe_interface
[    7.481789] usbhid 4-2.1:1.0: usb_probe_interface - got id
[    7.509146] input: Lite-On Technology USB Productivity Option Keyboard( has the hub in # 1 ) as /devices/pci0000:00/0000:00:1d.0/usb4/4-2/4-2.1/4-2.1:1.0/input/input10
[    7.510675] uhci_hcd 0000:00:1d.0: reserve dev 6 ep81-INT, period 8, phase 4, 17 us
[    7.512034] generic-usb 0003:04B3:301B.0005: input,hidraw2: USB HID v1.10 Keyboard [Lite-On Technology USB Productivity Option Keyboard( has the hub in # 1 )] on usb-0000:00:1d.0-2.1/input0
[    7.515451] usb 4-2.1: adding 4-2.1:1.1 (config #1, interface 1)
[    7.518777] usbhid 4-2.1:1.1: usb_probe_interface
[    7.518781] usbhid 4-2.1:1.1: usb_probe_interface - got id
[    7.523161] input: Lite-On Technology USB Productivity Option Keyboard( has the hub in # 1 ) as /devices/pci0000:00/0000:00:1d.0/usb4/4-2/4-2.1/4-2.1:1.1/input/input11
[    7.524967] uhci_hcd 0000:00:1d.0: reserve dev 6 ep82-INT, period 128, phase 0, 14 us
[    7.526258] generic-usb 0003:04B3:301B.0006: input,hidraw3: USB HID v1.10 Device [Lite-On Technology USB Productivity Option Keyboard( has the hub in # 1 )] on usb-0000:00:1d.0-2.1/input1
[    7.530906] hub 4-2:1.0: 356mA power budget left
[    7.530911] hub 4-2:1.0: state 7 ports 3 chg 0000 evt 0002
[    7.808097] hub 7-0:1.0: hub_suspend
[    7.808108] usb usb7: bus auto-suspend
[    7.808112] ehci_hcd 0000:00:1a.7: suspend root hub
[    7.900676] Adding 5791396k swap on /dev/sda5.  Priority:-1 extents:1 across:5791396k 
[    8.395789] udev: starting version 147
[    8.824131] hub 8-0:1.0: hub_suspend
[    8.824144] usb usb8: bus auto-suspend
[    8.824148] ehci_hcd 0000:00:1d.7: suspend root hub
[    8.825323] EXT3-fs (sda1): using internal journal
[   10.516896] cfg80211: Calling CRDA to update world regulatory domain
[   12.338530] ip_tables: (C) 2000-2006 Netfilter Core Team
[   12.558580] cfg80211: World regulatory domain updated:
[   12.558584] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   12.558587] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   12.558591] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   12.558593] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   12.558597] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   12.558599] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   14.789993] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   14.790138] HDA Intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[   14.790471] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   14.958230] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[   14.958234] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[   14.958431] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   14.958441] iwlagn 0000:03:00.0: setting latency timer to 64
[   14.958526] iwlagn 0000:03:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
[   14.978445] iwlagn 0000:03:00.0: device EEPROM VER=0x11f, CALIB=0x4
[   14.978448] iwlagn 0000:03:00.0: Device SKU: 0Xb
[   14.978485] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   14.978598] iwlagn 0000:03:00.0: irq 47 for MSI/MSI-X
[   16.774197] iwlagn 0000:03:00.0: loaded firmware version 8.24.2.12
[   17.361024] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   19.236331] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   19.292149] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   19.292847] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   22.276975] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   22.277464] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   26.052144] uhci_hcd 0000:00:1d.0: reserve dev 4 ep81-INT, period 8, phase 4, 118 us
[   30.461577] usb usb8: usb auto-resume
[   30.461584] ehci_hcd 0000:00:1d.7: resume root hub
[   30.516067] hub 8-0:1.0: hub_resume
[   30.516641] usb usb5: usb auto-resume
[   30.516646] usb usb5: wakeup_rh
[   30.516658] hub 8-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   30.564132] hub 5-0:1.0: hub_resume
[   30.564421] usb usb3: usb auto-resume
[   30.564426] usb usb3: wakeup_rh
[   30.564481] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   30.608173] hub 3-0:1.0: hub_resume
[   30.608470] usb usb7: usb auto-resume
[   30.608476] ehci_hcd 0000:00:1a.7: resume root hub
[   30.608562] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   30.660102] hub 7-0:1.0: hub_resume
[   30.660563] usb usb1: usb auto-resume
[   30.660567] usb usb1: wakeup_rh
[   30.660579] hub 7-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   30.700102] hub 1-0:1.0: hub_resume
[   30.700236] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   30.700367] usb usb6: usb auto-resume
[   30.700371] usb usb6: wakeup_rh
[   30.740052] hub 6-0:1.0: hub_resume
[   30.740161] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   31.648059] usb usb5: suspend_rh (auto-stop)
[   31.648089] usb usb3: suspend_rh (auto-stop)
[   31.896030] usb usb1: suspend_rh (auto-stop)
[   31.896061] usb usb6: suspend_rh (auto-stop)
[   33.276059] eth0: no IPv6 routers present
[   33.928096] hub 5-0:1.0: hub_suspend
[   33.928116] usb usb5: bus auto-suspend
[   33.928119] usb usb5: suspend_rh
[   33.928139] hub 3-0:1.0: hub_suspend
[   33.928145] usb usb3: bus auto-suspend
[   33.928147] usb usb3: suspend_rh
[   33.928166] hub 7-0:1.0: hub_suspend
[   33.928171] usb usb7: bus auto-suspend
[   33.928174] ehci_hcd 0000:00:1a.7: suspend root hub
[   33.928202] hub 1-0:1.0: hub_suspend
[   33.928207] usb usb1: bus auto-suspend
[   33.928210] usb usb1: suspend_rh
[   33.928228] hub 6-0:1.0: hub_suspend
[   33.928233] usb usb6: bus auto-suspend
[   33.928235] usb usb6: suspend_rh
[   33.928253] hub 8-0:1.0: hub_suspend
[   33.928258] usb usb8: bus auto-suspend
[   33.928260] ehci_hcd 0000:00:1d.7: suspend root hub
[   77.830554] kmemleak: 2 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
[  166.629363] pciehp 0000:00:1c.3:pcie04: Card present on Slot(3)
[  166.748195] pci 0000:05:00.0: [1033:0194] type 0 class 0x000c03
[  166.748238] pci 0000:05:00.0: reg 10: [mem 0x00000000-0x00001fff 64bit]
[  166.748424] pci 0000:05:00.0: PME# supported from D0 D3hot
[  166.748434] pci 0000:05:00.0: PME# disabled
[  166.748521] pci 0000:05:00.0: BAR 0: assigned [mem 0xf0000000-0xf0001fff 64bit]
[  166.748535] pci 0000:05:00.0: BAR 0: set to [mem 0xf0000000-0xf0001fff 64bit] (PCI address [0xf0000000-0xf0001fff])
[  166.748542] pcieport 0000:00:1c.3: PCI bridge to [bus 05-0c]
[  166.748546] pcieport 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[  166.748554] pcieport 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[  166.748560] pcieport 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[  166.748578] pcieport 0000:00:1c.3: setting latency timer to 64
[  166.748672] pci 0000:05:00.0: no hotplug settings from platform
[  166.848130] xhci_hcd 0000:05:00.0: enabling device (0000 -> 0002)
[  166.848142] xhci_hcd 0000:05:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[  166.848243] xhci_hcd 0000:05:00.0: setting latency timer to 64
[  166.848249] xhci_hcd 0000:05:00.0: xHCI Host Controller
[  166.848420] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus number 9
[  166.868167] xhci_hcd 0000:05:00.0: xHCI capability registers at ffffc90000b58000:
[  166.868173] xhci_hcd 0000:05:00.0: CAPLENGTH AND HCIVERSION 0x960020:
[  166.868176] xhci_hcd 0000:05:00.0: CAPLENGTH: 0x20
[  166.868178] xhci_hcd 0000:05:00.0: HCIVERSION: 0x96
[  166.868183] xhci_hcd 0000:05:00.0: HCSPARAMS 1: 0x4000820
[  166.868186] xhci_hcd 0000:05:00.0:   Max device slots: 32
[  166.868188] xhci_hcd 0000:05:00.0:   Max interrupters: 8
[  166.868191] xhci_hcd 0000:05:00.0:   Max ports: 4
[  166.868196] xhci_hcd 0000:05:00.0: HCSPARAMS 2: 0x11
[  166.868198] xhci_hcd 0000:05:00.0:   Isoc scheduling threshold: 1
[  166.868201] xhci_hcd 0000:05:00.0:   Maximum allowed segments in event ring: 1
[  166.868206] xhci_hcd 0000:05:00.0: HCSPARAMS 3 0x0:
[  166.868208] xhci_hcd 0000:05:00.0:   Worst case U1 device exit latency: 0
[  166.868211] xhci_hcd 0000:05:00.0:   Worst case U2 device exit latency: 0
[  166.868216] xhci_hcd 0000:05:00.0: HCC PARAMS 0x14042cb:
[  166.868219] xhci_hcd 0000:05:00.0:   HC generates 64 bit addresses
[  166.868221] xhci_hcd 0000:05:00.0:   FIXME: more HCCPARAMS debugging
[  166.868226] xhci_hcd 0000:05:00.0: RTSOFF 0x600:
[  166.868229] xhci_hcd 0000:05:00.0: xHCI operational registers at ffffc90000b58020:
[  166.868234] xhci_hcd 0000:05:00.0: USBCMD 0x0:
[  166.868236] xhci_hcd 0000:05:00.0:   HC is being stopped
[  166.868239] xhci_hcd 0000:05:00.0:   HC has finished hard reset
[  166.868242] xhci_hcd 0000:05:00.0:   Event Interrupts disabled
[  166.868244] xhci_hcd 0000:05:00.0:   Host System Error Interrupts disabled
[  166.868247] xhci_hcd 0000:05:00.0:   HC has finished light reset
[  166.868252] xhci_hcd 0000:05:00.0: USBSTS 0x1:
[  166.868254] xhci_hcd 0000:05:00.0:   Event ring is empty
[  166.868257] xhci_hcd 0000:05:00.0:   No Host System Error
[  166.868259] xhci_hcd 0000:05:00.0:   HC is halted
[  166.868265] xhci_hcd 0000:05:00.0: ffffc90000b58420 port status reg = 0x2a0
[  166.868270] xhci_hcd 0000:05:00.0: ffffc90000b58424 port power reg = 0x0
[  166.868275] xhci_hcd 0000:05:00.0: ffffc90000b58428 port link reg = 0x0
[  166.868280] xhci_hcd 0000:05:00.0: ffffc90000b5842c port reserved reg = 0x0
[  166.868286] xhci_hcd 0000:05:00.0: ffffc90000b58430 port status reg = 0x2a0
[  166.868296] xhci_hcd 0000:05:00.0: ffffc90000b58434 port power reg = 0x0
[  166.868301] xhci_hcd 0000:05:00.0: ffffc90000b58438 port link reg = 0x0
[  166.868306] xhci_hcd 0000:05:00.0: ffffc90000b5843c port reserved reg = 0x0
[  166.868311] xhci_hcd 0000:05:00.0: ffffc90000b58440 port status reg = 0x2a0
[  166.868316] xhci_hcd 0000:05:00.0: ffffc90000b58444 port power reg = 0x0
[  166.868320] xhci_hcd 0000:05:00.0: ffffc90000b58448 port link reg = 0x0
[  166.868325] xhci_hcd 0000:05:00.0: ffffc90000b5844c port reserved reg = 0x0
[  166.868330] xhci_hcd 0000:05:00.0: ffffc90000b58450 port status reg = 0x2a0
[  166.868335] xhci_hcd 0000:05:00.0: ffffc90000b58454 port power reg = 0x0
[  166.868339] xhci_hcd 0000:05:00.0: ffffc90000b58458 port link reg = 0x0
[  166.868344] xhci_hcd 0000:05:00.0: ffffc90000b5845c port reserved reg = 0x0
[  166.868347] xhci_hcd 0000:05:00.0: // Halt the HC
[  166.868353] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000b58020, 32'h0, 4'hf);
[  166.868358] xhci_hcd 0000:05:00.0: Resetting HCD
[  166.868362] xhci_hcd 0000:05:00.0: // Reset the HC
[  166.868367] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000b58020, 32'h2, 4'hf);
[  166.868412] xhci_hcd 0000:05:00.0: Wait for controller to be ready for doorbell rings
[  166.868417] xhci_hcd 0000:05:00.0: Reset complete
[  166.868421] xhci_hcd 0000:05:00.0: Enabling 64-bit DMA addresses.
[  166.868423] xhci_hcd 0000:05:00.0: Calling HCD init
[  166.868425] xhci_hcd 0000:05:00.0: xhci_init
[  166.868428] xhci_hcd 0000:05:00.0: xHCI doesn't need link TRB QUIRK
[  166.868432] xhci_hcd 0000:05:00.0: Supported page size register = 0x1
[  166.868435] xhci_hcd 0000:05:00.0: Supported page size of 4K
[  166.868437] xhci_hcd 0000:05:00.0: HCD page size set to 4K
[  166.868441] xhci_hcd 0000:05:00.0: // xHC can handle at most 32 device slots.
[  166.868446] xhci_hcd 0000:05:00.0: // Setting Max device slots reg = 0x20.
[  166.868449] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000b58058, 32'h20, 4'hf);
[  166.868463] xhci_hcd 0000:05:00.0: // Device context base array address = 0x37817000 (DMA), ffff880037817000 (virt)
[  166.868466] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc90000b58050, 64'h37817000, 4'hf);
[  166.868519] xhci_hcd 0000:05:00.0: Allocating ring at ffff8801315c7540
[  166.868531] xhci_hcd 0000:05:00.0: Allocating priv segment structure at ffff880130039920
[  166.868555] xhci_hcd 0000:05:00.0: // Allocating segment at ffff880037818000 (virtual) 0x37818000 (DMA)
[  166.868560] xhci_hcd 0000:05:00.0: Linking segment 0x37818000 to segment 0x37818000 (DMA)
[  166.868563] xhci_hcd 0000:05:00.0: Wrote link toggle flag to segment ffff880130039920 (virtual), 0x37818000 (DMA)
[  166.868566] xhci_hcd 0000:05:00.0: Allocated command ring at ffff8801315c7540
[  166.868569] xhci_hcd 0000:05:00.0: First segment DMA is 0x37818000
[  166.868575] xhci_hcd 0000:05:00.0: // Setting command ring address to 0x20
[  166.868578] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc90000b58038, 64'h37818001, 4'hf);
[  166.868585] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr low bits + flags = @00000000
[  166.868587] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr high bits = @00000000
[  166.868592] xhci_hcd 0000:05:00.0: // Doorbell array is located at offset 0x800 from cap regs base addr
[  166.868595] xhci_hcd 0000:05:00.0: // xHCI capability registers at ffffc90000b58000:
[  166.868599] xhci_hcd 0000:05:00.0: // @ffffc90000b58000 = 0x960020 (CAPLENGTH AND HCIVERSION)
[  166.868602] xhci_hcd 0000:05:00.0: //   CAPLENGTH: 0x20
[  166.868604] xhci_hcd 0000:05:00.0: // xHCI operational registers at ffffc90000b58020:
[  166.868609] xhci_hcd 0000:05:00.0: // @ffffc90000b58018 = 0x600 RTSOFF
[  166.868612] xhci_hcd 0000:05:00.0: // xHCI runtime registers at ffffc90000b58600:
[  166.868616] xhci_hcd 0000:05:00.0: // @ffffc90000b58014 = 0x800 DBOFF
[  166.868619] xhci_hcd 0000:05:00.0: // Doorbell array at ffffc90000b58800:
[  166.868621] xhci_hcd 0000:05:00.0: xHCI runtime registers at ffffc90000b58600:
[  166.868626] xhci_hcd 0000:05:00.0:   ffffc90000b58600: Microframe index = 0x0
[  166.868641] xhci_hcd 0000:05:00.0: // Allocating event ring
[  166.868652] xhci_hcd 0000:05:00.0: Allocating ring at ffff8801315c7a80
[  166.868664] xhci_hcd 0000:05:00.0: Allocating priv segment structure at ffff880130039900
[  166.868667] xhci_hcd 0000:05:00.0: // Allocating segment at ffff880037818400 (virtual) 0x37818400 (DMA)
[  166.868671] xhci_hcd 0000:05:00.0: Linking segment 0x37818400 to segment 0x37818400 (DMA)
[  166.868674] xhci_hcd 0000:05:00.0: TRB math tests passed.
[  166.868686] xhci_hcd 0000:05:00.0: // Allocated event ring segment table at 0x37819000
[  166.868689] xhci_hcd 0000:05:00.0: Set ERST to 0; private num segs = 1, virt addr = ffff880037819000, dma addr = 0x37819000
[  166.868694] xhci_hcd 0000:05:00.0: // Write ERST size = 1 to ir_set 0 (some bits preserved)
[  166.868697] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000b58628, 32'h1, 4'hf);
[  166.868700] xhci_hcd 0000:05:00.0: // Set ERST entries to point to event ring.
[  166.868702] xhci_hcd 0000:05:00.0: // Set ERST base address for ir_set 0 = 0x37819000
[  166.868709] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc90000b58630, 64'h37819000, 4'hf);
[  166.868716] xhci_hcd 0000:05:00.0: // Write event ring dequeue pointer, preserving EHB bit
[  166.868719] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc90000b58638, 64'h37818400, 4'hf);
[  166.868721] xhci_hcd 0000:05:00.0: Wrote ERST address to ir_set 0.
[  166.868727] xhci_hcd 0000:05:00.0: Allocating 0 scratchpad buffers
[  166.868746] xhci_hcd 0000:05:00.0: Ext Cap ffffc90000b58510, port offset = 1, count = 2, revision = 0x3
[  166.868753] xhci_hcd 0000:05:00.0: Ext Cap ffffc90000b58520, port offset = 3, count = 2, revision = 0x2
[  166.868756] xhci_hcd 0000:05:00.0: Found 2 USB 2.0 ports and 2 USB 3.0 ports.
[  166.868767] xhci_hcd 0000:05:00.0: USB 2.0 port at index 2, addr = ffffc90000b58440
[  166.868770] xhci_hcd 0000:05:00.0: USB 2.0 port at index 3, addr = ffffc90000b58450
[  166.868782] xhci_hcd 0000:05:00.0: USB 3.0 port at index 0, addr = ffffc90000b58420
[  166.868785] xhci_hcd 0000:05:00.0: USB 3.0 port at index 1, addr = ffffc90000b58430
[  166.868787] xhci_hcd 0000:05:00.0: Finished xhci_init
[  166.868789] xhci_hcd 0000:05:00.0: Called HCD init
[  166.868794] xhci_hcd 0000:05:00.0: Got SBRN 48
[  166.868810] xhci_hcd 0000:05:00.0: MWI active
[  166.868812] xhci_hcd 0000:05:00.0: Finished xhci_pci_reinit
[  166.868814] xhci_hcd 0000:05:00.0: supports USB remote wakeup
[  166.868855] xhci_hcd 0000:05:00.0: irq 19, io mem 0xf0000000
[  166.868858] xhci_hcd 0000:05:00.0: xhci_run
[  166.869008] xhci_hcd 0000:05:00.0: irq 48 for MSI/MSI-X
[  166.869013] xhci_hcd 0000:05:00.0: irq 49 for MSI/MSI-X
[  166.869018] xhci_hcd 0000:05:00.0: irq 50 for MSI/MSI-X
[  166.869488] xhci_hcd 0000:05:00.0: Setting event ring polling timer
[  166.869491] xhci_hcd 0000:05:00.0: Command ring memory map follows:
[  166.869494] xhci_hcd 0000:05:00.0: @37818000 00000000 00000000 00000000 00000000
[  166.869497] xhci_hcd 0000:05:00.0: @37818010 00000000 00000000 00000000 00000000
[  166.869500] xhci_hcd 0000:05:00.0: @37818020 00000000 00000000 00000000 00000000
[  166.869503] xhci_hcd 0000:05:00.0: @37818030 00000000 00000000 00000000 00000000
[  166.869506] xhci_hcd 0000:05:00.0: @37818040 00000000 00000000 00000000 00000000
[  166.869509] xhci_hcd 0000:05:00.0: @37818050 00000000 00000000 00000000 00000000
[  166.869512] xhci_hcd 0000:05:00.0: @37818060 00000000 00000000 00000000 00000000
[  166.869515] xhci_hcd 0000:05:00.0: @37818070 00000000 00000000 00000000 00000000
[  166.869518] xhci_hcd 0000:05:00.0: @37818080 00000000 00000000 00000000 00000000
[  166.869521] xhci_hcd 0000:05:00.0: @37818090 00000000 00000000 00000000 00000000
[  166.869523] xhci_hcd 0000:05:00.0: @378180a0 00000000 00000000 00000000 00000000
[  166.869526] xhci_hcd 0000:05:00.0: @378180b0 00000000 00000000 00000000 00000000
[  166.869529] xhci_hcd 0000:05:00.0: @378180c0 00000000 00000000 00000000 00000000
[  166.869532] xhci_hcd 0000:05:00.0: @378180d0 00000000 00000000 00000000 00000000
[  166.869535] xhci_hcd 0000:05:00.0: @378180e0 00000000 00000000 00000000 00000000
[  166.869538] xhci_hcd 0000:05:00.0: @378180f0 00000000 00000000 00000000 00000000
[  166.869541] xhci_hcd 0000:05:00.0: @37818100 00000000 00000000 00000000 00000000
[  166.869544] xhci_hcd 0000:05:00.0: @37818110 00000000 00000000 00000000 00000000
[  166.869546] xhci_hcd 0000:05:00.0: @37818120 00000000 00000000 00000000 00000000
[  166.869549] xhci_hcd 0000:05:00.0: @37818130 00000000 00000000 00000000 00000000
[  166.869552] xhci_hcd 0000:05:00.0: @37818140 00000000 00000000 00000000 00000000
[  166.869555] xhci_hcd 0000:05:00.0: @37818150 00000000 00000000 00000000 00000000
[  166.869558] xhci_hcd 0000:05:00.0: @37818160 00000000 00000000 00000000 00000000
[  166.869561] xhci_hcd 0000:05:00.0: @37818170 00000000 00000000 00000000 00000000
[  166.869564] xhci_hcd 0000:05:00.0: @37818180 00000000 00000000 00000000 00000000
[  166.869567] xhci_hcd 0000:05:00.0: @37818190 00000000 00000000 00000000 00000000
[  166.869570] xhci_hcd 0000:05:00.0: @378181a0 00000000 00000000 00000000 00000000
[  166.869572] xhci_hcd 0000:05:00.0: @378181b0 00000000 00000000 00000000 00000000
[  166.869575] xhci_hcd 0000:05:00.0: @378181c0 00000000 00000000 00000000 00000000
[  166.869578] xhci_hcd 0000:05:00.0: @378181d0 00000000 00000000 00000000 00000000
[  166.869581] xhci_hcd 0000:05:00.0: @378181e0 00000000 00000000 00000000 00000000
[  166.869584] xhci_hcd 0000:05:00.0: @378181f0 00000000 00000000 00000000 00000000
[  166.869587] xhci_hcd 0000:05:00.0: @37818200 00000000 00000000 00000000 00000000
[  166.869590] xhci_hcd 0000:05:00.0: @37818210 00000000 00000000 00000000 00000000
[  166.869592] xhci_hcd 0000:05:00.0: @37818220 00000000 00000000 00000000 00000000
[  166.869595] xhci_hcd 0000:05:00.0: @37818230 00000000 00000000 00000000 00000000
[  166.869598] xhci_hcd 0000:05:00.0: @37818240 00000000 00000000 00000000 00000000
[  166.869601] xhci_hcd 0000:05:00.0: @37818250 00000000 00000000 00000000 00000000
[  166.869604] xhci_hcd 0000:05:00.0: @37818260 00000000 00000000 00000000 00000000
[  166.869607] xhci_hcd 0000:05:00.0: @37818270 00000000 00000000 00000000 00000000
[  166.869610] xhci_hcd 0000:05:00.0: @37818280 00000000 00000000 00000000 00000000
[  166.869612] xhci_hcd 0000:05:00.0: @37818290 00000000 00000000 00000000 00000000
[  166.869615] xhci_hcd 0000:05:00.0: @378182a0 00000000 00000000 00000000 00000000
[  166.869618] xhci_hcd 0000:05:00.0: @378182b0 00000000 00000000 00000000 00000000
[  166.869621] xhci_hcd 0000:05:00.0: @378182c0 00000000 00000000 00000000 00000000
[  166.869624] xhci_hcd 0000:05:00.0: @378182d0 00000000 00000000 00000000 00000000
[  166.869627] xhci_hcd 0000:05:00.0: @378182e0 00000000 00000000 00000000 00000000
[  166.869630] xhci_hcd 0000:05:00.0: @378182f0 00000000 00000000 00000000 00000000
[  166.869633] xhci_hcd 0000:05:00.0: @37818300 00000000 00000000 00000000 00000000
[  166.869635] xhci_hcd 0000:05:00.0: @37818310 00000000 00000000 00000000 00000000
[  166.869638] xhci_hcd 0000:05:00.0: @37818320 00000000 00000000 00000000 00000000
[  166.869641] xhci_hcd 0000:05:00.0: @37818330 00000000 00000000 00000000 00000000
[  166.869644] xhci_hcd 0000:05:00.0: @37818340 00000000 00000000 00000000 00000000
[  166.869647] xhci_hcd 0000:05:00.0: @37818350 00000000 00000000 00000000 00000000
[  166.869650] xhci_hcd 0000:05:00.0: @37818360 00000000 00000000 00000000 00000000
[  166.869653] xhci_hcd 0000:05:00.0: @37818370 00000000 00000000 00000000 00000000
[  166.869656] xhci_hcd 0000:05:00.0: @37818380 00000000 00000000 00000000 00000000
[  166.869659] xhci_hcd 0000:05:00.0: @37818390 00000000 00000000 00000000 00000000
[  166.869661] xhci_hcd 0000:05:00.0: @378183a0 00000000 00000000 00000000 00000000
[  166.869664] xhci_hcd 0000:05:00.0: @378183b0 00000000 00000000 00000000 00000000
[  166.869667] xhci_hcd 0000:05:00.0: @378183c0 00000000 00000000 00000000 00000000
[  166.869670] xhci_hcd 0000:05:00.0: @378183d0 00000000 00000000 00000000 00000000
[  166.869673] xhci_hcd 0000:05:00.0: @378183e0 00000000 00000000 00000000 00000000
[  166.869676] xhci_hcd 0000:05:00.0: @378183f0 37818000 00000000 00000000 00001802
[  166.869678] xhci_hcd 0000:05:00.0:   Ring has not been updated
[  166.869681] xhci_hcd 0000:05:00.0: Ring deq = ffff880037818000 (virt), 0x37818000 (dma)
[  166.869684] xhci_hcd 0000:05:00.0: Ring deq updated 0 times
[  166.869686] xhci_hcd 0000:05:00.0: Ring enq = ffff880037818000 (virt), 0x37818000 (dma)
[  166.869689] xhci_hcd 0000:05:00.0: Ring enq updated 0 times
[  166.869695] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr low bits + flags = @00000000
[  166.869698] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr high bits = @00000000
[  166.869700] xhci_hcd 0000:05:00.0: ERST memory map follows:
[  166.869703] xhci_hcd 0000:05:00.0: @37819000 37818400 00000000 00000040 00000000
[  166.869706] xhci_hcd 0000:05:00.0: Event ring:
[  166.869708] xhci_hcd 0000:05:00.0: @37818400 00000000 00000000 00000000 00000000
[  166.869711] xhci_hcd 0000:05:00.0: @37818410 00000000 00000000 00000000 00000000
[  166.869714] xhci_hcd 0000:05:00.0: @37818420 00000000 00000000 00000000 00000000
[  166.869717] xhci_hcd 0000:05:00.0: @37818430 00000000 00000000 00000000 00000000
[  166.869720] xhci_hcd 0000:05:00.0: @37818440 00000000 00000000 00000000 00000000
[  166.869723] xhci_hcd 0000:05:00.0: @37818450 00000000 00000000 00000000 00000000
[  166.869726] xhci_hcd 0000:05:00.0: @37818460 00000000 00000000 00000000 00000000
[  166.869728] xhci_hcd 0000:05:00.0: @37818470 00000000 00000000 00000000 00000000
[  166.869731] xhci_hcd 0000:05:00.0: @37818480 00000000 00000000 00000000 00000000
[  166.869734] xhci_hcd 0000:05:00.0: @37818490 00000000 00000000 00000000 00000000
[  166.869737] xhci_hcd 0000:05:00.0: @378184a0 00000000 00000000 00000000 00000000
[  166.869740] xhci_hcd 0000:05:00.0: @378184b0 00000000 00000000 00000000 00000000
[  166.869743] xhci_hcd 0000:05:00.0: @378184c0 00000000 00000000 00000000 00000000
[  166.869746] xhci_hcd 0000:05:00.0: @378184d0 00000000 00000000 00000000 00000000
[  166.869748] xhci_hcd 0000:05:00.0: @378184e0 00000000 00000000 00000000 00000000
[  166.869751] xhci_hcd 0000:05:00.0: @378184f0 00000000 00000000 00000000 00000000
[  166.869754] xhci_hcd 0000:05:00.0: @37818500 00000000 00000000 00000000 00000000
[  166.869757] xhci_hcd 0000:05:00.0: @37818510 00000000 00000000 00000000 00000000
[  166.869760] xhci_hcd 0000:05:00.0: @37818520 00000000 00000000 00000000 00000000
[  166.869763] xhci_hcd 0000:05:00.0: @37818530 00000000 00000000 00000000 00000000
[  166.869766] xhci_hcd 0000:05:00.0: @37818540 00000000 00000000 00000000 00000000
[  166.869769] xhci_hcd 0000:05:00.0: @37818550 00000000 00000000 00000000 00000000
[  166.869771] xhci_hcd 0000:05:00.0: @37818560 00000000 00000000 00000000 00000000
[  166.869774] xhci_hcd 0000:05:00.0: @37818570 00000000 00000000 00000000 00000000
[  166.869777] xhci_hcd 0000:05:00.0: @37818580 00000000 00000000 00000000 00000000
[  166.869780] xhci_hcd 0000:05:00.0: @37818590 00000000 00000000 00000000 00000000
[  166.869783] xhci_hcd 0000:05:00.0: @378185a0 00000000 00000000 00000000 00000000
[  166.869786] xhci_hcd 0000:05:00.0: @378185b0 00000000 00000000 00000000 00000000
[  166.869789] xhci_hcd 0000:05:00.0: @378185c0 00000000 00000000 00000000 00000000
[  166.869792] xhci_hcd 0000:05:00.0: @378185d0 00000000 00000000 00000000 00000000
[  166.869794] xhci_hcd 0000:05:00.0: @378185e0 00000000 00000000 00000000 00000000
[  166.869797] xhci_hcd 0000:05:00.0: @378185f0 00000000 00000000 00000000 00000000
[  166.869800] xhci_hcd 0000:05:00.0: @37818600 00000000 00000000 00000000 00000000
[  166.869803] xhci_hcd 0000:05:00.0: @37818610 00000000 00000000 00000000 00000000
[  166.869806] xhci_hcd 0000:05:00.0: @37818620 00000000 00000000 00000000 00000000
[  166.869809] xhci_hcd 0000:05:00.0: @37818630 00000000 00000000 00000000 00000000
[  166.869812] xhci_hcd 0000:05:00.0: @37818640 00000000 00000000 00000000 00000000
[  166.869815] xhci_hcd 0000:05:00.0: @37818650 00000000 00000000 00000000 00000000
[  166.869817] xhci_hcd 0000:05:00.0: @37818660 00000000 00000000 00000000 00000000
[  166.869820] xhci_hcd 0000:05:00.0: @37818670 00000000 00000000 00000000 00000000
[  166.869823] xhci_hcd 0000:05:00.0: @37818680 00000000 00000000 00000000 00000000
[  166.869826] xhci_hcd 0000:05:00.0: @37818690 00000000 00000000 00000000 00000000
[  166.869829] xhci_hcd 0000:05:00.0: @378186a0 00000000 00000000 00000000 00000000
[  166.869832] xhci_hcd 0000:05:00.0: @378186b0 00000000 00000000 00000000 00000000
[  166.869835] xhci_hcd 0000:05:00.0: @378186c0 00000000 00000000 00000000 00000000
[  166.869837] xhci_hcd 0000:05:00.0: @378186d0 00000000 00000000 00000000 00000000
[  166.869840] xhci_hcd 0000:05:00.0: @378186e0 00000000 00000000 00000000 00000000
[  166.869843] xhci_hcd 0000:05:00.0: @378186f0 00000000 00000000 00000000 00000000
[  166.869846] xhci_hcd 0000:05:00.0: @37818700 00000000 00000000 00000000 00000000
[  166.869849] xhci_hcd 0000:05:00.0: @37818710 00000000 00000000 00000000 00000000
[  166.869852] xhci_hcd 0000:05:00.0: @37818720 00000000 00000000 00000000 00000000
[  166.869855] xhci_hcd 0000:05:00.0: @37818730 00000000 00000000 00000000 00000000
[  166.869858] xhci_hcd 0000:05:00.0: @37818740 00000000 00000000 00000000 00000000
[  166.869860] xhci_hcd 0000:05:00.0: @37818750 00000000 00000000 00000000 00000000
[  166.869863] xhci_hcd 0000:05:00.0: @37818760 00000000 00000000 00000000 00000000
[  166.869866] xhci_hcd 0000:05:00.0: @37818770 00000000 00000000 00000000 00000000
[  166.869869] xhci_hcd 0000:05:00.0: @37818780 00000000 00000000 00000000 00000000
[  166.869872] xhci_hcd 0000:05:00.0: @37818790 00000000 00000000 00000000 00000000
[  166.869875] xhci_hcd 0000:05:00.0: @378187a0 00000000 00000000 00000000 00000000
[  166.869878] xhci_hcd 0000:05:00.0: @378187b0 00000000 00000000 00000000 00000000
[  166.869881] xhci_hcd 0000:05:00.0: @378187c0 00000000 00000000 00000000 00000000
[  166.869883] xhci_hcd 0000:05:00.0: @378187d0 00000000 00000000 00000000 00000000
[  166.869886] xhci_hcd 0000:05:00.0: @378187e0 00000000 00000000 00000000 00000000
[  166.869889] xhci_hcd 0000:05:00.0: @378187f0 00000000 00000000 00000000 00000000
[  166.869892] xhci_hcd 0000:05:00.0:   Ring has not been updated
[  166.869894] xhci_hcd 0000:05:00.0: Ring deq = ffff880037818400 (virt), 0x37818400 (dma)
[  166.869897] xhci_hcd 0000:05:00.0: Ring deq updated 0 times
[  166.869900] xhci_hcd 0000:05:00.0: Ring enq = ffff880037818400 (virt), 0x37818400 (dma)
[  166.869902] xhci_hcd 0000:05:00.0: Ring enq updated 0 times
[  166.869908] xhci_hcd 0000:05:00.0: ERST deq = 64'h37818400
[  166.869911] xhci_hcd 0000:05:00.0: // Set the interrupt modulation register
[  166.869916] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000b58624, 32'ha0, 4'hf);
[  166.869921] xhci_hcd 0000:05:00.0: // Enable interrupts, cmd = 0x4.
[  166.869923] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000b58020, 32'h4, 4'hf);
[  166.869929] xhci_hcd 0000:05:00.0: // Enabling event ring interrupter ffffc90000b58620 by writing 0x2 to irq_pending
[  166.869932] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000b58620, 32'h2, 4'hf);
[  166.869937] xhci_hcd 0000:05:00.0:   ffffc90000b58620: ir_set[0]
[  166.869939] xhci_hcd 0000:05:00.0:   ffffc90000b58620: ir_set.pending = 0x2
[  166.869944] xhci_hcd 0000:05:00.0:   ffffc90000b58624: ir_set.control = 0xa0
[  166.869949] xhci_hcd 0000:05:00.0:   ffffc90000b58628: ir_set.erst_size = 0x1
[  166.869957] xhci_hcd 0000:05:00.0:   ffffc90000b58630: ir_set.erst_base = @37819000
[  166.869964] xhci_hcd 0000:05:00.0:   ffffc90000b58638: ir_set.erst_dequeue = @37818400
[  166.869966] xhci_hcd 0000:05:00.0: Endpoint state = 0x1
[  166.869969] xhci_hcd 0000:05:00.0: Command ring enq = 0x37818010 (DMA)
[  166.869974] xhci_hcd 0000:05:00.0: // Turn on HC, cmd = 0x5.
[  166.869976] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000b58020, 32'h5, 4'hf);
[  166.871812] xhci_hcd 0000:05:00.0: // Ding dong!
[  166.871814] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000b58800, 32'h0, 4'hf);
[  166.871819] xhci_hcd 0000:05:00.0: Finished xhci_run
[  166.871961] xhci_hcd 0000:05:00.0: op reg status = 00000008
[  166.871963] xhci_hcd 0000:05:00.0: Event ring dequeue ptr:
[  166.871966] xhci_hcd 0000:05:00.0: @37818400 37818000 00000000 01003021 0000c001
[  166.871969] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000b58024, 32'h8, 4'hf);
[  166.871972] xhci_hcd 0000:05:00.0: In xhci_handle_event
[  166.871974] xhci_hcd 0000:05:00.0: xhci_handle_event - OS owns TRB
[  166.871977] xhci_hcd 0000:05:00.0: Vendor specific event TRB type = 48
[  166.871979] xhci_hcd 0000:05:00.0: NEC firmware version 30.21
[  166.871982] xhci_hcd 0000:05:00.0: Command ring deq = 0x37818010 (DMA)
[  166.871985] xhci_hcd 0000:05:00.0: Event ring deq = 0x37818410 (DMA)
[  166.871987] xhci_hcd 0000:05:00.0: In xhci_handle_event
[  166.871996] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc90000b58638, 64'h37818418, 4'hf);
[  166.872172] usb usb9: No SuperSpeed endpoint companion for config 1  interface 0 altsetting 0 ep 129: using minimum values
[  166.872240] usb usb9: default language 0x0409
[  166.872443] usb usb9: udev 1, busnum 9, minor = 1024
[  166.872447] usb usb9: New USB device found, idVendor=1d6b, idProduct=0003
[  166.872450] usb usb9: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[  166.872453] usb usb9: Product: xHCI Host Controller
[  166.872456] usb usb9: Manufacturer: Linux 2.6.38-rc6+ xhci_hcd
[  166.872458] usb usb9: SerialNumber: 0000:05:00.0
[  166.873513] usb usb9: usb_probe_device
[  166.873517] usb usb9: configuration #1 chosen from 1 choice
[  166.873557] xHCI xhci_add_endpoint called for root hub
[  166.873559] xHCI xhci_check_bandwidth called for root hub
[  166.873628] usb usb9: adding 9-0:1.0 (config #1, interface 0)
[  166.874356] hub 9-0:1.0: usb_probe_interface
[  166.874360] hub 9-0:1.0: usb_probe_interface - got id
[  166.874365] hub 9-0:1.0: USB hub found
[  166.874511] hub 9-0:1.0: 4 ports detected
[  166.874537] hub 9-0:1.0: standalone hub
[  166.874540] hub 9-0:1.0: individual port power switching
[  166.874543] hub 9-0:1.0: individual port over-current protection
[  166.874547] hub 9-0:1.0: TT requires at most 8 FS bit times (666 ns)
[  166.874550] hub 9-0:1.0: power on to power good time: 20ms
[  166.874688] hub 9-0:1.0: local power source is good
[  166.874714] hub 9-0:1.0: enabling power on all ports
[  166.874773] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000b58420, 32'h2a0, 4'hf);
[  166.874781] xhci_hcd 0000:05:00.0: set port power, actual port 0 status  = 0x2a0
[  166.874850] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000b58430, 32'h2a0, 4'hf);
[  166.874858] xhci_hcd 0000:05:00.0: set port power, actual port 1 status  = 0x2a0
[  166.874926] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000b58440, 32'h2a0, 4'hf);
[  166.874933] xhci_hcd 0000:05:00.0: set port power, actual port 2 status  = 0x2a0
[  166.874999] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000b58450, 32'h2a0, 4'hf);
[  166.875007] xhci_hcd 0000:05:00.0: set port power, actual port 3 status  = 0x2a0
[  166.888212] usb usb8: usb auto-resume
[  166.888219] ehci_hcd 0000:00:1d.7: resume root hub
[  166.940026] hub 8-0:1.0: hub_resume
[  166.940303] hub 8-0:1.0: state 7 ports 6 chg 0000 evt 0000
[  166.940497] usb usb5: usb auto-resume
[  166.940502] usb usb5: wakeup_rh
[  166.972063] xhci_hcd 0000:05:00.0: get port status, actual port 0 status  = 0x2a0
[  166.972068] xhci_hcd 0000:05:00.0: Get port status returned 0x100
[  166.972108] xhci_hcd 0000:05:00.0: get port status, actual port 1 status  = 0x2a0
[  166.972111] xhci_hcd 0000:05:00.0: Get port status returned 0x100
[  166.972147] xhci_hcd 0000:05:00.0: get port status, actual port 2 status  = 0x2a0
[  166.972151] xhci_hcd 0000:05:00.0: Get port status returned 0x100
[  166.972187] xhci_hcd 0000:05:00.0: get port status, actual port 3 status  = 0x2a0
[  166.972190] xhci_hcd 0000:05:00.0: Get port status returned 0x100
[  166.972211] hub 9-0:1.0: state 7 ports 4 chg 0000 evt 0000
[  166.980024] hub 5-0:1.0: hub_resume
[  166.980291] usb usb3: usb auto-resume
[  166.980295] usb usb3: wakeup_rh
[  166.980305] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[  167.020040] hub 3-0:1.0: hub_resume
[  167.020149] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[  167.020301] usb usb7: usb auto-resume
[  167.020307] ehci_hcd 0000:00:1a.7: resume root hub
[  167.072059] hub 7-0:1.0: hub_resume
[  167.072347] hub 7-0:1.0: state 7 ports 6 chg 0000 evt 0000
[  167.072467] usb usb1: usb auto-resume
[  167.072471] usb usb1: wakeup_rh
[  167.112083] hub 1-0:1.0: hub_resume
[  167.112209] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
[  167.112325] usb usb6: usb auto-resume
[  167.112329] usb usb6: wakeup_rh
[  167.152080] hub 6-0:1.0: hub_resume
[  167.152205] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[  168.048089] usb usb5: suspend_rh (auto-stop)
[  168.048119] usb usb3: suspend_rh (auto-stop)
[  168.296143] usb usb1: suspend_rh (auto-stop)
[  168.296170] usb usb6: suspend_rh (auto-stop)
[  169.804072] hub 8-0:1.0: hub_suspend
[  169.804086] usb usb8: bus auto-suspend
[  169.804090] ehci_hcd 0000:00:1d.7: suspend root hub
[  169.804121] hub 3-0:1.0: hub_suspend
[  169.804127] usb usb3: bus auto-suspend
[  169.804131] usb usb3: suspend_rh
[  169.808140] hub 7-0:1.0: hub_suspend
[  169.808148] usb usb7: bus auto-suspend
[  169.808150] ehci_hcd 0000:00:1a.7: suspend root hub
[  169.808181] hub 1-0:1.0: hub_suspend
[  169.808187] usb usb1: bus auto-suspend
[  169.808190] usb usb1: suspend_rh
[  169.808211] hub 6-0:1.0: hub_suspend
[  169.808217] usb usb6: bus auto-suspend
[  169.808220] usb usb6: suspend_rh
[  169.816161] hub 9-0:1.0: hub_suspend
[  169.816170] usb usb9: bus auto-suspend
[  169.816173] xhci_hcd 0000:05:00.0: suspend root hub
[  169.816181] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000b58450, 32'ha0002a0, 4'hf);
[  169.816188] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000b58440, 32'ha0002a0, 4'hf);
[  169.816196] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000b58430, 32'ha0002a0, 4'hf);
[  169.816204] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000b58420, 32'ha0002a0, 4'hf);
[  169.816212] hub 5-0:1.0: hub_suspend
[  169.816218] usb usb5: bus auto-suspend
[  169.816221] usb usb5: suspend_rh

--v9Ux+11Zm5mwPlX6--
