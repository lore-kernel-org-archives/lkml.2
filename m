Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab2AYNuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 08:50:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824Ab2AYNuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 08:50:00 -0500
Date: Wed, 25 Jan 2012 08:49:48 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org, midgoon@gmail.com
Subject: Re: 3.2.1 Unable to reset IRR messages on boot
Message-ID: <20120125134947.GF13655@zod.bos.redhat.com>
References: <20120125000434.GC13655@zod.bos.redhat.com>
 <1327454651.27983.7.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <1327454651.27983.7.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 24, 2012 at 05:24:11PM -0800, Suresh Siddha wrote:
> On Tue, 2012-01-24 at 19:04 -0500, Josh Boyer wrote:
> > We've had a report [1] from users booting the 3.2.1 kernel and getting a
> > large number of KERN_ERR messages that look like:
> > 
> > [    0.020902] Unable to reset IRR for apic: 2, pin :0
> > [    0.020970] Unable to reset IRR for apic: 2, pin :1
> > [    0.021012] Unable to reset IRR for apic: 2, pin :2
> > [    0.021077] Unable to reset IRR for apic: 2, pin :3
> > [    0.021138] Unable to reset IRR for apic: 2, pin :4
> > [    0.021199] Unable to reset IRR for apic: 2, pin :5
> > [    0.021261] Unable to reset IRR for apic: 2, pin :6
> > [    0.021323] Unable to reset IRR for apic: 2, pin :7
> > 
> > Digging through git, it seems that error message was added to 3.2 with
> > commit 1e75b31d63.  The commit log mentions kdump, but I don't believe the
> > user is doing kexec/kdump of any kind.  It seems a normal yum update/reboot
> > and they hit this.
> > 
> > Are there any details the user can gather to help debug this, or has
> > anyone seen this before?
> > 
> 
> complete dmesg (which will have the platform, io-apic version info etc)
> will be useful.

Attached.  If you prefer it inline, let me know.

> If we are seeing this during a regular boot and for the all the RTE
> entries for a specific io-apic, most likely something is wrong with that
> io-apic (probably a bogus one listed by the bios?). We should be able to
> make the kernel code bit more smart to workaround this.

The reporter (now CC'd) confirmed it was a normal boot.

josh

--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg-ioapic

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.2.1-3.fc16.i686 (mockbuild@x86-16.phx2.fedoraproject.org) (gcc version 4.6.2 20111027 (Red Hat 4.6.2-1) (GCC) ) #1 SMP Mon Jan 23 15:44:05 UTC 2012
[    0.000000] Disabled fast string operations
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fe90000 (usable)
[    0.000000]  BIOS-e820: 000000003fe90000 - 000000003ff00000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003ff00000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] DMI present.
[    0.000000] DMI: Acer Aspire 9410/Myall2                    \x09     , BIOS V1.13      08/15/2006
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x3fe90 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 base 03FF00000 mask FFFF00000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 1GB, type WB
[    0.000000] reg 1, base: 1023MB, range: 1MB, type UC
[    0.000000] total RAM covered: 1023M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 2M 	num_reg: 2  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 1GB, type WB
[    0.000000] reg 1, base: 1023MB, range: 1MB, type UC
[    0.000000] found SMP MP-table at [c00f5c80] f5c80
[    0.000000] initial memory mapped : 0 - 01000000
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: 0000000000000000-00000000373fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037000000 page 2M
[    0.000000]  0037000000 - 00373fe000 page 4k
[    0.000000] kernel direct mapping tables up to 373fe000 @ ffa000-1000000
[    0.000000] RAMDISK: 35fd2000 - 36fe1000
[    0.000000] ACPI: RSDP 000f5ae0 00014 (v00 PTLTD )
[    0.000000] ACPI: RSDT 3fe95118 00054 (v01 PTLTD    RSDT   06040000  LTP 00000000)
[    0.000000] ACPI: FACP 3fe9ddee 00074 (v01 INTEL  CALISTGA 06040000 LOHR 0000005A)
[    0.000000] ACPI: DSDT 3fe96eb1 06F3D (v01 INTEL  CALISTGA 06040000 MSFT 0100000E)
[    0.000000] ACPI: FACS 3fe9efc0 00040
[    0.000000] ACPI: APIC 3fe9de62 00068 (v01 INTEL  CALISTGA 06040000 LOHR 0000005A)
[    0.000000] ACPI: HPET 3fe9deca 00038 (v01 INTEL  CALISTGA 06040000 LOHR 0000005A)
[    0.000000] ACPI: MCFG 3fe9df02 0003C (v01 INTEL  CALISTGA 06040000 LOHR 0000005A)
[    0.000000] ACPI: TCPA 3fe9df3e 00032 (v01 PTLTD  CALISTGA 06040000  PTL 00000001)
[    0.000000] ACPI: APIC 3fe9df70 00068 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT 3fe9dfd8 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: SSDT 3fe96862 0064F (v01 SataRe  SataPri 00001000 INTL 20050624)
[    0.000000] ACPI: SSDT 3fe961d0 00692 (v01 SataRe  SataSec 00001000 INTL 20050624)
[    0.000000] ACPI: SSDT 3fe956f8 0025F (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 3fe95652 000A6 (v01  PmRef  Cpu1Tst 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 3fe9516c 004E6 (v01  PmRef    CpuPm 00003000 INTL 20050624)
[    0.000000] ACPI: BIOS bug: multiple APIC/MADT found, using 0
[    0.000000] ACPI: If "acpi_apic_instance=2" works better, notify linux-acpi@vger.kernel.org
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 138MB HIGHMEM available.
[    0.000000] 883MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 373fe000
[    0.000000]   low ram: 0 - 373fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000373fe
[    0.000000]   HighMem  0x000373fe -> 0x0003fe90
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003fe90
[    0.000000] On node 0 totalpages: 261663
[    0.000000] free_area_init_node: node 0, pgdat c0b8b940, node_mem_map f57d2200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1736 pages used for memmap
[    0.000000]   Normal zone: 220470 pages, LIFO batch:31
[    0.000000]   HighMem zone: 278 pages used for memmap
[    0.000000]   HighMem zone: 35196 pages, LIFO batch:7
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec28000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 2, version 255, address 0xfec28000, GSI 24-279
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 296
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:a0000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 13 pages/cpu @f5000000 s31616 r0 d21632 u2097152
[    0.000000] pcpu-alloc: s31616 r0 d21632 u2097152 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 259617
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.2.1-3.fc16.i686 root=UUID=e686d580-5b12-4573-ac32-c59cb952abde ro rd.md=0 rd.lvm=0 rd.dm=0 quiet SYSFONT=latarcyrheb-sun16 rhgb rd.luks=0 KEYTABLE=es LANG=es_ES.UTF-8
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 4188160 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Initializing HighMem for node 0 (000373fe:0003fe90)
[    0.000000] Memory: 1007636k/1047104k available (5282k kernel code, 39016k reserved, 2529k data, 624k init, 141896k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffa95000 - 0xfffff000   (5544 kB)
[    0.000000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.000000]     vmalloc : 0xf7bfe000 - 0xff3fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf73fe000   ( 883 MB)
[    0.000000]       .init : 0xc0ba2000 - 0xc0c3e000   ( 624 kB)
[    0.000000]       .data : 0xc09289d3 - 0xc0ba1100   (2529 kB)
[    0.000000]       .text : 0xc0400000 - 0xc09289d3   (5282 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=f4c10000 soft=f4c12000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1596.317 MHz processor.
[    0.001003] Calibrating delay loop (skipped), value calculated using timer frequency.. 3192.63 BogoMIPS (lpj=1596317)
[    0.001016] pid_max: default: 32768 minimum: 301
[    0.001072] Security Framework initialized
[    0.001089] SELinux:  Initializing.
[    0.001108] SELinux:  Starting in permissive mode
[    0.001240] Mount-cache hash table entries: 512
[    0.001562] Initializing cgroup subsys cpuacct
[    0.001578] Initializing cgroup subsys memory
[    0.001598] Initializing cgroup subsys devices
[    0.001605] Initializing cgroup subsys freezer
[    0.001610] Initializing cgroup subsys net_cls
[    0.001616] Initializing cgroup subsys blkio
[    0.001633] Initializing cgroup subsys perf_event
[    0.001686] Disabled fast string operations
[    0.001698] CPU: Physical Processor ID: 0
[    0.001702] CPU: Processor Core ID: 0
[    0.001709] mce: CPU supports 6 MCE banks
[    0.001731] CPU0: Thermal monitoring enabled (TM2)
[    0.001738] using mwait in idle threads.
[    0.004817] ACPI: Core revision 20110623
[    0.017022] ftrace: allocating 22124 entries in 44 pages
[    0.020062] Enabling APIC mode:  Flat.  Using 2 I/O APICs
[    0.020902] Unable to reset IRR for apic: 2, pin :0
[    0.020970] Unable to reset IRR for apic: 2, pin :1
[    0.021012] Unable to reset IRR for apic: 2, pin :2
[    0.021077] Unable to reset IRR for apic: 2, pin :3
[    0.021138] Unable to reset IRR for apic: 2, pin :4
[    0.021199] Unable to reset IRR for apic: 2, pin :5
[    0.021261] Unable to reset IRR for apic: 2, pin :6
[    0.021323] Unable to reset IRR for apic: 2, pin :7
[    0.021384] Unable to reset IRR for apic: 2, pin :8
[    0.021445] Unable to reset IRR for apic: 2, pin :9
[    0.021506] Unable to reset IRR for apic: 2, pin :10
[    0.021568] Unable to reset IRR for apic: 2, pin :11
[    0.021629] Unable to reset IRR for apic: 2, pin :12
[    0.021692] Unable to reset IRR for apic: 2, pin :13
[    0.021754] Unable to reset IRR for apic: 2, pin :14
[    0.021815] Unable to reset IRR for apic: 2, pin :15
[    0.021876] Unable to reset IRR for apic: 2, pin :16
[    0.021939] Unable to reset IRR for apic: 2, pin :17
[    0.022011] Unable to reset IRR for apic: 2, pin :18
[    0.022075] Unable to reset IRR for apic: 2, pin :19
[    0.022136] Unable to reset IRR for apic: 2, pin :20
[    0.022198] Unable to reset IRR for apic: 2, pin :21
[    0.022259] Unable to reset IRR for apic: 2, pin :22
[    0.022389] Unable to reset IRR for apic: 2, pin :23
[    0.022517] Unable to reset IRR for apic: 2, pin :24
[    0.022646] Unable to reset IRR for apic: 2, pin :25
[    0.022777] Unable to reset IRR for apic: 2, pin :26
[    0.022906] Unable to reset IRR for apic: 2, pin :27
[    0.023011] Unable to reset IRR for apic: 2, pin :28
[    0.023142] Unable to reset IRR for apic: 2, pin :29
[    0.023271] Unable to reset IRR for apic: 2, pin :30
[    0.023401] Unable to reset IRR for apic: 2, pin :31
[    0.023530] Unable to reset IRR for apic: 2, pin :32
[    0.023659] Unable to reset IRR for apic: 2, pin :33
[    0.023789] Unable to reset IRR for apic: 2, pin :34
[    0.024011] Unable to reset IRR for apic: 2, pin :35
[    0.024143] Unable to reset IRR for apic: 2, pin :36
[    0.024272] Unable to reset IRR for apic: 2, pin :37
[    0.024401] Unable to reset IRR for apic: 2, pin :38
[    0.024530] Unable to reset IRR for apic: 2, pin :39
[    0.024659] Unable to reset IRR for apic: 2, pin :40
[    0.024788] Unable to reset IRR for apic: 2, pin :41
[    0.024917] Unable to reset IRR for apic: 2, pin :42
[    0.025011] Unable to reset IRR for apic: 2, pin :43
[    0.025142] Unable to reset IRR for apic: 2, pin :44
[    0.025271] Unable to reset IRR for apic: 2, pin :45
[    0.025402] Unable to reset IRR for apic: 2, pin :46
[    0.025531] Unable to reset IRR for apic: 2, pin :47
[    0.025660] Unable to reset IRR for apic: 2, pin :48
[    0.025789] Unable to reset IRR for apic: 2, pin :49
[    0.025917] Unable to reset IRR for apic: 2, pin :50
[    0.026011] Unable to reset IRR for apic: 2, pin :51
[    0.026142] Unable to reset IRR for apic: 2, pin :52
[    0.026272] Unable to reset IRR for apic: 2, pin :53
[    0.026401] Unable to reset IRR for apic: 2, pin :54
[    0.026531] Unable to reset IRR for apic: 2, pin :55
[    0.026660] Unable to reset IRR for apic: 2, pin :56
[    0.026789] Unable to reset IRR for apic: 2, pin :57
[    0.027010] Unable to reset IRR for apic: 2, pin :58
[    0.027142] Unable to reset IRR for apic: 2, pin :59
[    0.027271] Unable to reset IRR for apic: 2, pin :60
[    0.027400] Unable to reset IRR for apic: 2, pin :61
[    0.027530] Unable to reset IRR for apic: 2, pin :62
[    0.027658] Unable to reset IRR for apic: 2, pin :63
[    0.027788] Unable to reset IRR for apic: 2, pin :64
[    0.027916] Unable to reset IRR for apic: 2, pin :65
[    0.028010] Unable to reset IRR for apic: 2, pin :66
[    0.028142] Unable to reset IRR for apic: 2, pin :67
[    0.028271] Unable to reset IRR for apic: 2, pin :68
[    0.028400] Unable to reset IRR for apic: 2, pin :69
[    0.028529] Unable to reset IRR for apic: 2, pin :70
[    0.028657] Unable to reset IRR for apic: 2, pin :71
[    0.028786] Unable to reset IRR for apic: 2, pin :72
[    0.029010] Unable to reset IRR for apic: 2, pin :73
[    0.029142] Unable to reset IRR for apic: 2, pin :74
[    0.029271] Unable to reset IRR for apic: 2, pin :75
[    0.029400] Unable to reset IRR for apic: 2, pin :76
[    0.029529] Unable to reset IRR for apic: 2, pin :77
[    0.029657] Unable to reset IRR for apic: 2, pin :78
[    0.029787] Unable to reset IRR for apic: 2, pin :79
[    0.029916] Unable to reset IRR for apic: 2, pin :80
[    0.030010] Unable to reset IRR for apic: 2, pin :81
[    0.030142] Unable to reset IRR for apic: 2, pin :82
[    0.030270] Unable to reset IRR for apic: 2, pin :83
[    0.030399] Unable to reset IRR for apic: 2, pin :84
[    0.030528] Unable to reset IRR for apic: 2, pin :85
[    0.030657] Unable to reset IRR for apic: 2, pin :86
[    0.030786] Unable to reset IRR for apic: 2, pin :87
[    0.030916] Unable to reset IRR for apic: 2, pin :88
[    0.031010] Unable to reset IRR for apic: 2, pin :89
[    0.031142] Unable to reset IRR for apic: 2, pin :90
[    0.031271] Unable to reset IRR for apic: 2, pin :91
[    0.031400] Unable to reset IRR for apic: 2, pin :92
[    0.031530] Unable to reset IRR for apic: 2, pin :93
[    0.031659] Unable to reset IRR for apic: 2, pin :94
[    0.031788] Unable to reset IRR for apic: 2, pin :95
[    0.032010] Unable to reset IRR for apic: 2, pin :96
[    0.032141] Unable to reset IRR for apic: 2, pin :97
[    0.032272] Unable to reset IRR for apic: 2, pin :98
[    0.032400] Unable to reset IRR for apic: 2, pin :99
[    0.032529] Unable to reset IRR for apic: 2, pin :100
[    0.032659] Unable to reset IRR for apic: 2, pin :101
[    0.032789] Unable to reset IRR for apic: 2, pin :102
[    0.032919] Unable to reset IRR for apic: 2, pin :103
[    0.033010] Unable to reset IRR for apic: 2, pin :104
[    0.033142] Unable to reset IRR for apic: 2, pin :105
[    0.033270] Unable to reset IRR for apic: 2, pin :106
[    0.033399] Unable to reset IRR for apic: 2, pin :107
[    0.033530] Unable to reset IRR for apic: 2, pin :108
[    0.033659] Unable to reset IRR for apic: 2, pin :109
[    0.033789] Unable to reset IRR for apic: 2, pin :110
[    0.034010] Unable to reset IRR for apic: 2, pin :111
[    0.034141] Unable to reset IRR for apic: 2, pin :112
[    0.034271] Unable to reset IRR for apic: 2, pin :113
[    0.034400] Unable to reset IRR for apic: 2, pin :114
[    0.034529] Unable to reset IRR for apic: 2, pin :115
[    0.034658] Unable to reset IRR for apic: 2, pin :116
[    0.034788] Unable to reset IRR for apic: 2, pin :117
[    0.034918] Unable to reset IRR for apic: 2, pin :118
[    0.035010] Unable to reset IRR for apic: 2, pin :119
[    0.035141] Unable to reset IRR for apic: 2, pin :120
[    0.035270] Unable to reset IRR for apic: 2, pin :121
[    0.035399] Unable to reset IRR for apic: 2, pin :122
[    0.035530] Unable to reset IRR for apic: 2, pin :123
[    0.035659] Unable to reset IRR for apic: 2, pin :124
[    0.035789] Unable to reset IRR for apic: 2, pin :125
[    0.035918] Unable to reset IRR for apic: 2, pin :126
[    0.036009] Unable to reset IRR for apic: 2, pin :127
[    0.036142] Unable to reset IRR for apic: 2, pin :128
[    0.036271] Unable to reset IRR for apic: 2, pin :129
[    0.036400] Unable to reset IRR for apic: 2, pin :130
[    0.036529] Unable to reset IRR for apic: 2, pin :131
[    0.036658] Unable to reset IRR for apic: 2, pin :132
[    0.036789] Unable to reset IRR for apic: 2, pin :133
[    0.037010] Unable to reset IRR for apic: 2, pin :134
[    0.037142] Unable to reset IRR for apic: 2, pin :135
[    0.037271] Unable to reset IRR for apic: 2, pin :136
[    0.037400] Unable to reset IRR for apic: 2, pin :137
[    0.037530] Unable to reset IRR for apic: 2, pin :138
[    0.037660] Unable to reset IRR for apic: 2, pin :139
[    0.037789] Unable to reset IRR for apic: 2, pin :140
[    0.037919] Unable to reset IRR for apic: 2, pin :141
[    0.038009] Unable to reset IRR for apic: 2, pin :142
[    0.038142] Unable to reset IRR for apic: 2, pin :143
[    0.038271] Unable to reset IRR for apic: 2, pin :144
[    0.038399] Unable to reset IRR for apic: 2, pin :145
[    0.038528] Unable to reset IRR for apic: 2, pin :146
[    0.038657] Unable to reset IRR for apic: 2, pin :147
[    0.038786] Unable to reset IRR for apic: 2, pin :148
[    0.039009] Unable to reset IRR for apic: 2, pin :149
[    0.039141] Unable to reset IRR for apic: 2, pin :150
[    0.039270] Unable to reset IRR for apic: 2, pin :151
[    0.039400] Unable to reset IRR for apic: 2, pin :152
[    0.039530] Unable to reset IRR for apic: 2, pin :153
[    0.039659] Unable to reset IRR for apic: 2, pin :154
[    0.039788] Unable to reset IRR for apic: 2, pin :155
[    0.039917] Unable to reset IRR for apic: 2, pin :156
[    0.040009] Unable to reset IRR for apic: 2, pin :157
[    0.040140] Unable to reset IRR for apic: 2, pin :158
[    0.040270] Unable to reset IRR for apic: 2, pin :159
[    0.040399] Unable to reset IRR for apic: 2, pin :160
[    0.040528] Unable to reset IRR for apic: 2, pin :161
[    0.040658] Unable to reset IRR for apic: 2, pin :162
[    0.040787] Unable to reset IRR for apic: 2, pin :163
[    0.040916] Unable to reset IRR for apic: 2, pin :164
[    0.041009] Unable to reset IRR for apic: 2, pin :165
[    0.041140] Unable to reset IRR for apic: 2, pin :166
[    0.041269] Unable to reset IRR for apic: 2, pin :167
[    0.041398] Unable to reset IRR for apic: 2, pin :168
[    0.041527] Unable to reset IRR for apic: 2, pin :169
[    0.041657] Unable to reset IRR for apic: 2, pin :170
[    0.041786] Unable to reset IRR for apic: 2, pin :171
[    0.042009] Unable to reset IRR for apic: 2, pin :172
[    0.042141] Unable to reset IRR for apic: 2, pin :173
[    0.042269] Unable to reset IRR for apic: 2, pin :174
[    0.042399] Unable to reset IRR for apic: 2, pin :175
[    0.042527] Unable to reset IRR for apic: 2, pin :176
[    0.042657] Unable to reset IRR for apic: 2, pin :177
[    0.042786] Unable to reset IRR for apic: 2, pin :178
[    0.042915] Unable to reset IRR for apic: 2, pin :179
[    0.043009] Unable to reset IRR for apic: 2, pin :180
[    0.043140] Unable to reset IRR for apic: 2, pin :181
[    0.043269] Unable to reset IRR for apic: 2, pin :182
[    0.043398] Unable to reset IRR for apic: 2, pin :183
[    0.043528] Unable to reset IRR for apic: 2, pin :184
[    0.043658] Unable to reset IRR for apic: 2, pin :185
[    0.043787] Unable to reset IRR for apic: 2, pin :186
[    0.044009] Unable to reset IRR for apic: 2, pin :187
[    0.044140] Unable to reset IRR for apic: 2, pin :188
[    0.044269] Unable to reset IRR for apic: 2, pin :189
[    0.044400] Unable to reset IRR for apic: 2, pin :190
[    0.044529] Unable to reset IRR for apic: 2, pin :191
[    0.044658] Unable to reset IRR for apic: 2, pin :192
[    0.044787] Unable to reset IRR for apic: 2, pin :193
[    0.044915] Unable to reset IRR for apic: 2, pin :194
[    0.045009] Unable to reset IRR for apic: 2, pin :195
[    0.045140] Unable to reset IRR for apic: 2, pin :196
[    0.045270] Unable to reset IRR for apic: 2, pin :197
[    0.045398] Unable to reset IRR for apic: 2, pin :198
[    0.045528] Unable to reset IRR for apic: 2, pin :199
[    0.045658] Unable to reset IRR for apic: 2, pin :200
[    0.045787] Unable to reset IRR for apic: 2, pin :201
[    0.046009] Unable to reset IRR for apic: 2, pin :202
[    0.046141] Unable to reset IRR for apic: 2, pin :203
[    0.046270] Unable to reset IRR for apic: 2, pin :204
[    0.047008] Unable to reset IRR for apic: 2, pin :205
[    0.047140] Unable to reset IRR for apic: 2, pin :206
[    0.047269] Unable to reset IRR for apic: 2, pin :207
[    0.047400] Unable to reset IRR for apic: 2, pin :208
[    0.047529] Unable to reset IRR for apic: 2, pin :209
[    0.047658] Unable to reset IRR for apic: 2, pin :210
[    0.047788] Unable to reset IRR for apic: 2, pin :211
[    0.047916] Unable to reset IRR for apic: 2, pin :212
[    0.048008] Unable to reset IRR for apic: 2, pin :213
[    0.048139] Unable to reset IRR for apic: 2, pin :214
[    0.048269] Unable to reset IRR for apic: 2, pin :215
[    0.048398] Unable to reset IRR for apic: 2, pin :216
[    0.048528] Unable to reset IRR for apic: 2, pin :217
[    0.048659] Unable to reset IRR for apic: 2, pin :218
[    0.048788] Unable to reset IRR for apic: 2, pin :219
[    0.049008] Unable to reset IRR for apic: 2, pin :220
[    0.049139] Unable to reset IRR for apic: 2, pin :221
[    0.049269] Unable to reset IRR for apic: 2, pin :222
[    0.049400] Unable to reset IRR for apic: 2, pin :223
[    0.049530] Unable to reset IRR for apic: 2, pin :224
[    0.049658] Unable to reset IRR for apic: 2, pin :225
[    0.049788] Unable to reset IRR for apic: 2, pin :226
[    0.049917] Unable to reset IRR for apic: 2, pin :227
[    0.050008] Unable to reset IRR for apic: 2, pin :228
[    0.050139] Unable to reset IRR for apic: 2, pin :229
[    0.050268] Unable to reset IRR for apic: 2, pin :230
[    0.050397] Unable to reset IRR for apic: 2, pin :231
[    0.050527] Unable to reset IRR for apic: 2, pin :232
[    0.050657] Unable to reset IRR for apic: 2, pin :233
[    0.050786] Unable to reset IRR for apic: 2, pin :234
[    0.051008] Unable to reset IRR for apic: 2, pin :235
[    0.051139] Unable to reset IRR for apic: 2, pin :236
[    0.051268] Unable to reset IRR for apic: 2, pin :237
[    0.051399] Unable to reset IRR for apic: 2, pin :238
[    0.051528] Unable to reset IRR for apic: 2, pin :239
[    0.051657] Unable to reset IRR for apic: 2, pin :240
[    0.051786] Unable to reset IRR for apic: 2, pin :241
[    0.051915] Unable to reset IRR for apic: 2, pin :242
[    0.052008] Unable to reset IRR for apic: 2, pin :243
[    0.052139] Unable to reset IRR for apic: 2, pin :244
[    0.052268] Unable to reset IRR for apic: 2, pin :245
[    0.052398] Unable to reset IRR for apic: 2, pin :246
[    0.052527] Unable to reset IRR for apic: 2, pin :247
[    0.052658] Unable to reset IRR for apic: 2, pin :248
[    0.052788] Unable to reset IRR for apic: 2, pin :249
[    0.052918] Unable to reset IRR for apic: 2, pin :250
[    0.053008] Unable to reset IRR for apic: 2, pin :251
[    0.053140] Unable to reset IRR for apic: 2, pin :252
[    0.053271] Unable to reset IRR for apic: 2, pin :253
[    0.053401] Unable to reset IRR for apic: 2, pin :254
[    0.053530] Unable to reset IRR for apic: 2, pin :255
[    0.053898] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.064035] CPU0: Genuine Intel(R) CPU           T2050  @ 1.60GHz stepping 08
[    0.064994] Performance Events: Core events, core PMU driver.
[    0.064994] ... version:                1
[    0.064994] ... bit width:              40
[    0.064994] ... generic registers:      2
[    0.064994] ... value mask:             000000ffffffffff
[    0.064994] ... max period:             000000007fffffff
[    0.064994] ... fixed-purpose events:   0
[    0.064994] ... event mask:             0000000000000003
[    0.064994] NMI watchdog enabled, takes one hw-pmu counter.
[    0.064994] CPU 1 irqstacks, hard=f4cc4000 soft=f4cc6000
[    0.064994] Booting Node   0, Processors  #1 Ok.
[    0.064994] smpboot cpu 1: start_ip = 9b000
[    0.001999] Initializing CPU#1
[    0.001999] Disabled fast string operations
[    0.136046] NMI watchdog enabled, takes one hw-pmu counter.
[    0.136135] Brought up 2 CPUs
[    0.136142] Total of 2 processors activated (6384.94 BogoMIPS).
[    0.137138] devtmpfs: initialized
[    0.138035] PM: Registering ACPI NVS region at 3fe90000 (458752 bytes)
[    0.140715] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.140776] RTC time: 23:16:12, date: 01/24/12
[    0.140868] NET: Registered protocol family 16
[    0.141402] ACPI: bus type pci registered
[    0.141576] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.141586] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.141592] PCI: Using MMCONFIG for extended config space
[    0.141597] PCI: Using configuration type 1 for base access
[    0.145733] bio: create slab <bio-0> at 0
[    0.146113] ACPI: Added _OSI(Module Device)
[    0.146113] ACPI: Added _OSI(Processor Device)
[    0.146113] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.146113] ACPI: Added _OSI(Processor Aggregator Device)
[    0.149400] ACPI: EC: Look up EC in DSDT
[    0.155331] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.156547] ACPI: SSDT 3fe95ed6 0023D (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.157345] ACPI: Dynamic OEM Table Load:
[    0.157355] ACPI: SSDT   (null) 0023D (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.157742] ACPI: SSDT 3fe95957 004FA (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.158504] ACPI: Dynamic OEM Table Load:
[    0.158513] ACPI: SSDT   (null) 004FA (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.159161] ACPI: SSDT 3fe96113 000BD (v01  PmRef  Cpu1Ist 00003000 INTL 20050624)
[    0.159926] ACPI: Dynamic OEM Table Load:
[    0.159934] ACPI: SSDT   (null) 000BD (v01  PmRef  Cpu1Ist 00003000 INTL 20050624)
[    0.160201] ACPI: SSDT 3fe95e51 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20050624)
[    0.160942] ACPI: Dynamic OEM Table Load:
[    0.160951] ACPI: SSDT   (null) 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20050624)
[    0.163223] ACPI: Interpreter enabled
[    0.163239] ACPI: (supports S0 S3 S4 S5)
[    0.163286] ACPI: Using IOAPIC for interrupt routing
[    0.181404] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.181812] ACPI: No dock devices found.
[    0.181818] HEST: Table not found.
[    0.181828] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.182646] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.184170] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.184179] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.184188] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.184197] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff] (ignored)
[    0.184205] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff] (ignored)
[    0.184213] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff] (ignored)
[    0.184223] pci_root PNP0A08:00: host bridge window [mem 0x40000000-0xfebfffff] (ignored)
[    0.184249] pci 0000:00:00.0: [8086:27a0] type 0 class 0x000600
[    0.184339] pci 0000:00:01.0: [8086:27a1] type 1 class 0x000604
[    0.184410] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.184420] pci 0000:00:01.0: PME# disabled
[    0.184518] pci 0000:00:1b.0: [8086:27d8] type 0 class 0x000403
[    0.184553] pci 0000:00:1b.0: reg 10: [mem 0xd2300000-0xd2303fff 64bit]
[    0.184668] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.184678] pci 0000:00:1b.0: PME# disabled
[    0.184723] pci 0000:00:1c.0: [8086:27d0] type 1 class 0x000604
[    0.184842] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.184852] pci 0000:00:1c.0: PME# disabled
[    0.184902] pci 0000:00:1c.1: [8086:27d2] type 1 class 0x000604
[    0.185033] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.185043] pci 0000:00:1c.1: PME# disabled
[    0.185093] pci 0000:00:1c.2: [8086:27d4] type 1 class 0x000604
[    0.185212] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.185223] pci 0000:00:1c.2: PME# disabled
[    0.185271] pci 0000:00:1c.3: [8086:27d6] type 1 class 0x000604
[    0.185390] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.185400] pci 0000:00:1c.3: PME# disabled
[    0.185450] pci 0000:00:1d.0: [8086:27c8] type 0 class 0x000c03
[    0.185529] pci 0000:00:1d.0: reg 20: [io  0x1800-0x181f]
[    0.185588] pci 0000:00:1d.1: [8086:27c9] type 0 class 0x000c03
[    0.185666] pci 0000:00:1d.1: reg 20: [io  0x1820-0x183f]
[    0.185727] pci 0000:00:1d.2: [8086:27ca] type 0 class 0x000c03
[    0.185805] pci 0000:00:1d.2: reg 20: [io  0x1840-0x185f]
[    0.185865] pci 0000:00:1d.3: [8086:27cb] type 0 class 0x000c03
[    0.185943] pci 0000:00:1d.3: reg 20: [io  0x1860-0x187f]
[    0.186031] pci 0000:00:1d.7: [8086:27cc] type 0 class 0x000c03
[    0.186068] pci 0000:00:1d.7: reg 10: [mem 0xd2304000-0xd23043ff]
[    0.186190] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.186201] pci 0000:00:1d.7: PME# disabled
[    0.186238] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.186362] pci 0000:00:1f.0: [8086:27b9] type 0 class 0x000601
[    0.186509] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
[    0.186522] pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
[    0.186535] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 1200 (mask 0007)
[    0.186608] pci 0000:00:1f.2: [8086:27c4] type 0 class 0x000101
[    0.186640] pci 0000:00:1f.2: reg 10: [io  0x0000-0x0007]
[    0.186660] pci 0000:00:1f.2: reg 14: [io  0x0000-0x0003]
[    0.186680] pci 0000:00:1f.2: reg 18: [io  0x0000-0x0007]
[    0.186700] pci 0000:00:1f.2: reg 1c: [io  0x0000-0x0003]
[    0.186719] pci 0000:00:1f.2: reg 20: [io  0x18b0-0x18bf]
[    0.186783] pci 0000:00:1f.2: PME# supported from D3hot
[    0.186793] pci 0000:00:1f.2: PME# disabled
[    0.186822] pci 0000:00:1f.3: [8086:27da] type 0 class 0x000c05
[    0.186918] pci 0000:00:1f.3: reg 20: [io  0x18c0-0x18df]
[    0.187070] pci 0000:01:00.0: [10de:01d7] type 0 class 0x000300
[    0.187092] pci 0000:01:00.0: reg 10: [mem 0xd1000000-0xd1ffffff]
[    0.187114] pci 0000:01:00.0: reg 14: [mem 0xb0000000-0xbfffffff 64bit pref]
[    0.187137] pci 0000:01:00.0: reg 1c: [mem 0xd0000000-0xd0ffffff 64bit]
[    0.187163] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.187215] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.187228] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.187240] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xd1ffffff]
[    0.187252] pci 0000:00:01.0:   bridge window [mem 0xb0000000-0xbfffffff 64bit pref]
[    0.187382] pci 0000:02:00.0: [10ec:8168] type 0 class 0x000200
[    0.187417] pci 0000:02:00.0: reg 10: [io  0x2000-0x20ff]
[    0.187473] pci 0000:02:00.0: reg 18: [mem 0xc8000000-0xc8000fff 64bit]
[    0.187537] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.187619] pci 0000:02:00.0: supports D1 D2
[    0.187626] pci 0000:02:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.187638] pci 0000:02:00.0: PME# disabled
[    0.187679] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.187691] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.187702] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.187713] pci 0000:00:1c.0:   bridge window [mem 0xc8000000-0xc9ffffff]
[    0.187729] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc1ffffff 64bit pref]
[    0.187817] pci 0000:00:1c.1: PCI bridge to [bus 03-04]
[    0.187827] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.187838] pci 0000:00:1c.1:   bridge window [mem 0xca000000-0xcbffffff]
[    0.187854] pci 0000:00:1c.1:   bridge window [mem 0xc2000000-0xc3ffffff 64bit pref]
[    0.188058] pci 0000:05:00.0: [8086:4222] type 0 class 0x000280
[    0.188125] pci 0000:05:00.0: reg 10: [mem 0xcc000000-0xcc000fff]
[    0.188499] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    0.188518] pci 0000:05:00.0: PME# disabled
[    0.188597] pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.188619] pci 0000:00:1c.2: PCI bridge to [bus 05-06]
[    0.188630] pci 0000:00:1c.2:   bridge window [io  0x4000-0x4fff]
[    0.188641] pci 0000:00:1c.2:   bridge window [mem 0xcc000000-0xcdffffff]
[    0.188656] pci 0000:00:1c.2:   bridge window [mem 0xc4000000-0xc5ffffff 64bit pref]
[    0.188745] pci 0000:00:1c.3: PCI bridge to [bus 07-08]
[    0.188755] pci 0000:00:1c.3:   bridge window [io  0x5000-0x5fff]
[    0.188766] pci 0000:00:1c.3:   bridge window [mem 0xce000000-0xcfffffff]
[    0.188782] pci 0000:00:1c.3:   bridge window [mem 0xc6000000-0xc7ffffff 64bit pref]
[    0.188865] pci 0000:0a:06.0: [104c:8039] type 2 class 0x000607
[    0.188903] pci 0000:0a:06.0: reg 10: [mem 0x00000000-0x00000fff]
[    0.188944] pci 0000:0a:06.0: supports D1 D2
[    0.188950] pci 0000:0a:06.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.188961] pci 0000:0a:06.0: PME# disabled
[    0.189017] pci 0000:0a:06.2: [104c:803b] type 0 class 0x000180
[    0.189053] pci 0000:0a:06.2: reg 10: [mem 0xd2004000-0xd2004fff]
[    0.189183] pci 0000:0a:06.2: supports D1 D2
[    0.189189] pci 0000:0a:06.2: PME# supported from D0 D1 D2 D3hot
[    0.189200] pci 0000:0a:06.2: PME# disabled
[    0.189237] pci 0000:0a:06.3: [104c:803c] type 0 class 0x000805
[    0.189272] pci 0000:0a:06.3: reg 10: [mem 0xd2005800-0xd20058ff]
[    0.189402] pci 0000:0a:06.3: supports D1 D2
[    0.189409] pci 0000:0a:06.3: PME# supported from D0 D1 D2 D3hot
[    0.189419] pci 0000:0a:06.3: PME# disabled
[    0.189506] pci 0000:00:1e.0: PCI bridge to [bus 0a-0a] (subtractive decode)
[    0.189522] pci 0000:00:1e.0:   bridge window [mem 0xd2000000-0xd20fffff]
[    0.189537] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    0.189545] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffff] (subtractive decode)
[    0.189622] pci_bus 0000:0b: [bus 0b-0e] partially hidden behind transparent bridge 0000:0a [bus 0a-0a]
[    0.189677] pci_bus 0000:00: on NUMA node 0
[    0.189686] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.190076] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    0.190223] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.190351] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.190474] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.190599] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    0.190772] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.191020]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.191030]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    0.191036] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.202903] ACPI: PCI Interrupt Link [LNKA] (IRQs 10 *11)
[    0.203039] ACPI: PCI Interrupt Link [LNKB] (IRQs 10 *11)
[    0.203156] ACPI: PCI Interrupt Link [LNKC] (IRQs *10 11)
[    0.203271] ACPI: PCI Interrupt Link [LNKD] (IRQs *10 11)
[    0.203385] ACPI: PCI Interrupt Link [LNKE] (IRQs 10 11) *0, disabled.
[    0.203502] ACPI: PCI Interrupt Link [LNKF] (IRQs 10 11) *0, disabled.
[    0.203620] ACPI: PCI Interrupt Link [LNKG] (IRQs *10 11)
[    0.203735] ACPI: PCI Interrupt Link [LNKH] (IRQs 10 *11)
[    0.203901] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.203993] vgaarb: loaded
[    0.203997] vgaarb: bridge control possible 0000:01:00.0
[    0.204238] SCSI subsystem initialized
[    0.204258] libata version 3.00 loaded.
[    0.204258] usbcore: registered new interface driver usbfs
[    0.204258] usbcore: registered new interface driver hub
[    0.204258] usbcore: registered new device driver usb
[    0.204258] PCI: Using ACPI for IRQ routing
[    0.218754] PCI: pci_cache_line_size set to 64 bytes
[    0.218999] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
[    0.219007] reserve RAM buffer: 000000003fe90000 - 000000003fffffff 
[    0.219276] NetLabel: Initializing
[    0.219282] NetLabel:  domain hash size = 128
[    0.219286] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.219314] NetLabel:  unlabeled traffic allowed by default
[    0.219324] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.219336] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.219349] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.222168] Switching to clocksource hpet
[    0.245034] pnp: PnP ACPI init
[    0.245078] ACPI: bus type pnp registered
[    0.245846] pnp 00:00: [bus 00-ff]
[    0.245855] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.245862] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.245869] pnp 00:00: [io  0x0d00-0xffff window]
[    0.245876] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.245884] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.245891] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.245898] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.245905] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.245913] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.245920] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.245927] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.245934] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.245941] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.245949] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.245956] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.245963] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.245970] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.245978] pnp 00:00: [mem 0x40000000-0xfebfffff window]
[    0.245985] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.246167] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.246232] pnp 00:01: [mem 0xe0000000-0xefffffff]
[    0.246240] pnp 00:01: [mem 0xfed14000-0xfed17fff]
[    0.246247] pnp 00:01: [mem 0xfed18000-0xfed18fff]
[    0.246253] pnp 00:01: [mem 0xfed19000-0xfed19fff]
[    0.246260] pnp 00:01: [mem 0xfed1c000-0xfed1ffff]
[    0.246267] pnp 00:01: [mem 0xfed20000-0xfed3ffff]
[    0.246273] pnp 00:01: [mem 0xfed40000-0xfed44fff]
[    0.246280] pnp 00:01: [mem 0xfed45000-0xfed8ffff]
[    0.246428] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.246438] system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
[    0.246446] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.246455] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.246464] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.246472] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.246481] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.246490] system 00:01: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.246500] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.248505] pnp 00:02: [io  0x0000-0x001f]
[    0.248513] pnp 00:02: [io  0x0081-0x0091]
[    0.248519] pnp 00:02: [io  0x0093-0x009f]
[    0.248526] pnp 00:02: [io  0x00c0-0x00df]
[    0.248533] pnp 00:02: [dma 4]
[    0.248652] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.248678] pnp 00:03: [mem 0xff000000-0xffffffff]
[    0.248796] pnp 00:03: Plug and Play ACPI device, IDs INT0800 (active)
[    0.248961] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.249148] system 00:04: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.249159] system 00:04: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    0.249191] pnp 00:05: [io  0x00f0]
[    0.249211] pnp 00:05: [irq 13]
[    0.249335] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.249368] pnp 00:06: [io  0x002e-0x002f]
[    0.249374] pnp 00:06: [io  0x004e-0x004f]
[    0.249380] pnp 00:06: [io  0x0061]
[    0.249386] pnp 00:06: [io  0x0063]
[    0.249392] pnp 00:06: [io  0x0065]
[    0.249398] pnp 00:06: [io  0x0067]
[    0.249404] pnp 00:06: [io  0x0070]
[    0.249409] pnp 00:06: [io  0x0080]
[    0.249415] pnp 00:06: [io  0x0092]
[    0.249421] pnp 00:06: [io  0x00b2-0x00b3]
[    0.249428] pnp 00:06: [io  0x0680-0x068f]
[    0.249434] pnp 00:06: [io  0x0800-0x080f]
[    0.249440] pnp 00:06: [io  0x1000-0x107f]
[    0.249447] pnp 00:06: [io  0x1180-0x11bf]
[    0.249453] pnp 00:06: [io  0x1200-0x120f]
[    0.249644] system 00:06: [io  0x0680-0x068f] has been reserved
[    0.249653] system 00:06: [io  0x0800-0x080f] has been reserved
[    0.249661] system 00:06: [io  0x1000-0x107f] has been reserved
[    0.249669] system 00:06: [io  0x1180-0x11bf] has been reserved
[    0.249678] system 00:06: [io  0x1200-0x120f] has been reserved
[    0.249687] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.249761] pnp 00:07: [io  0x06a0-0x06af]
[    0.249767] pnp 00:07: [io  0x06b0-0x06ff]
[    0.249933] system 00:07: [io  0x06a0-0x06af] has been reserved
[    0.249941] system 00:07: [io  0x06b0-0x06ff] has been reserved
[    0.249950] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.249977] pnp 00:08: [io  0x0070-0x0077]
[    0.249990] pnp 00:08: [irq 8]
[    0.250136] pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.250201] pnp 00:09: [io  0x0060]
[    0.250208] pnp 00:09: [io  0x0064]
[    0.250220] pnp 00:09: [irq 1]
[    0.250343] pnp 00:09: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.250374] pnp 00:0a: [irq 12]
[    0.250500] pnp 00:0a: Plug and Play ACPI device, IDs SYN0302 SYN0300 SYN0002 PNP0f13 (active)
[    0.250554] pnp: PnP ACPI: found 11 devices
[    0.250559] ACPI: ACPI bus type pnp unregistered
[    0.292744] PCI: max bus depth: 2 pci_try_num: 3
[    0.292841] pci 0000:00:1e.0: BAR 15: assigned [mem 0x40000000-0x43ffffff pref]
[    0.292853] pci 0000:00:1e.0: BAR 13: assigned [io  0x6000-0x6fff]
[    0.292864] pci 0000:01:00.0: BAR 6: can't assign mem pref (size 0x20000)
[    0.292872] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.292883] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xd1ffffff]
[    0.292893] pci 0000:00:01.0:   bridge window [mem 0xb0000000-0xbfffffff 64bit pref]
[    0.292907] pci 0000:02:00.0: BAR 6: assigned [mem 0xc0000000-0xc001ffff pref]
[    0.292916] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.292924] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.292937] pci 0000:00:1c.0:   bridge window [mem 0xc8000000-0xc9ffffff]
[    0.292949] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc1ffffff 64bit pref]
[    0.292964] pci 0000:00:1c.1: PCI bridge to [bus 03-04]
[    0.292972] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.292985] pci 0000:00:1c.1:   bridge window [mem 0xca000000-0xcbffffff]
[    0.292996] pci 0000:00:1c.1:   bridge window [mem 0xc2000000-0xc3ffffff 64bit pref]
[    0.293028] pci 0000:00:1c.2: PCI bridge to [bus 05-06]
[    0.293037] pci 0000:00:1c.2:   bridge window [io  0x4000-0x4fff]
[    0.293050] pci 0000:00:1c.2:   bridge window [mem 0xcc000000-0xcdffffff]
[    0.293061] pci 0000:00:1c.2:   bridge window [mem 0xc4000000-0xc5ffffff 64bit pref]
[    0.293076] pci 0000:00:1c.3: PCI bridge to [bus 07-08]
[    0.293084] pci 0000:00:1c.3:   bridge window [io  0x5000-0x5fff]
[    0.293097] pci 0000:00:1c.3:   bridge window [mem 0xce000000-0xcfffffff]
[    0.293108] pci 0000:00:1c.3:   bridge window [mem 0xc6000000-0xc7ffffff 64bit pref]
[    0.293129] pci 0000:0a:06.0: BAR 0: assigned [mem 0x44000000-0x44000fff]
[    0.293143] pci 0000:0a:06.0: BAR 0: set to [mem 0x44000000-0x44000fff] (PCI address [0x44000000-0x44000fff])
[    0.293154] pci 0000:0a:06.0: BAR 16: assigned [mem 0x48000000-0x4bffffff]
[    0.293163] pci 0000:0a:06.0: BAR 15: assigned [mem 0x40000000-0x43ffffff pref]
[    0.293172] pci 0000:0a:06.0: BAR 14: assigned [io  0x6000-0x60ff]
[    0.293180] pci 0000:0a:06.0: BAR 13: assigned [io  0x6400-0x64ff]
[    0.293188] pci 0000:0a:06.0: CardBus bridge to [bus 0b-0e]
[    0.293194] pci 0000:0a:06.0:   bridge window [io  0x6400-0x64ff]
[    0.293206] pci 0000:0a:06.0:   bridge window [io  0x6000-0x60ff]
[    0.293217] pci 0000:0a:06.0:   bridge window [mem 0x40000000-0x43ffffff pref]
[    0.293229] pci 0000:0a:06.0:   bridge window [mem 0x48000000-0x4bffffff]
[    0.293240] pci 0000:00:1e.0: PCI bridge to [bus 0a-0a]
[    0.293249] pci 0000:00:1e.0:   bridge window [io  0x6000-0x6fff]
[    0.293262] pci 0000:00:1e.0:   bridge window [mem 0xd2000000-0xd20fffff]
[    0.293273] pci 0000:00:1e.0:   bridge window [mem 0x40000000-0x43ffffff pref]
[    0.293312] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.293322] pci 0000:00:01.0: setting latency timer to 64
[    0.293346] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.293357] pci 0000:00:1c.0: setting latency timer to 64
[    0.293372] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.293383] pci 0000:00:1c.1: setting latency timer to 64
[    0.293405] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.293416] pci 0000:00:1c.2: setting latency timer to 64
[    0.293438] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.293449] pci 0000:00:1c.3: setting latency timer to 64
[    0.293461] pci 0000:00:1e.0: enabling device (0104 -> 0107)
[    0.293473] pci 0000:00:1e.0: setting latency timer to 64
[    0.293496] pci 0000:0a:06.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.293510] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.293518] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
[    0.293526] pci_bus 0000:01: resource 1 [mem 0xd0000000-0xd1ffffff]
[    0.293534] pci_bus 0000:01: resource 2 [mem 0xb0000000-0xbfffffff 64bit pref]
[    0.293543] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.293550] pci_bus 0000:02: resource 1 [mem 0xc8000000-0xc9ffffff]
[    0.293558] pci_bus 0000:02: resource 2 [mem 0xc0000000-0xc1ffffff 64bit pref]
[    0.293566] pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
[    0.293573] pci_bus 0000:03: resource 1 [mem 0xca000000-0xcbffffff]
[    0.293581] pci_bus 0000:03: resource 2 [mem 0xc2000000-0xc3ffffff 64bit pref]
[    0.293589] pci_bus 0000:05: resource 0 [io  0x4000-0x4fff]
[    0.293597] pci_bus 0000:05: resource 1 [mem 0xcc000000-0xcdffffff]
[    0.293605] pci_bus 0000:05: resource 2 [mem 0xc4000000-0xc5ffffff 64bit pref]
[    0.293613] pci_bus 0000:07: resource 0 [io  0x5000-0x5fff]
[    0.293620] pci_bus 0000:07: resource 1 [mem 0xce000000-0xcfffffff]
[    0.293628] pci_bus 0000:07: resource 2 [mem 0xc6000000-0xc7ffffff 64bit pref]
[    0.293636] pci_bus 0000:0a: resource 0 [io  0x6000-0x6fff]
[    0.293644] pci_bus 0000:0a: resource 1 [mem 0xd2000000-0xd20fffff]
[    0.293651] pci_bus 0000:0a: resource 2 [mem 0x40000000-0x43ffffff pref]
[    0.293659] pci_bus 0000:0a: resource 4 [io  0x0000-0xffff]
[    0.293666] pci_bus 0000:0a: resource 5 [mem 0x00000000-0xffffffff]
[    0.293674] pci_bus 0000:0b: resource 0 [io  0x6400-0x64ff]
[    0.293681] pci_bus 0000:0b: resource 1 [io  0x6000-0x60ff]
[    0.293689] pci_bus 0000:0b: resource 2 [mem 0x40000000-0x43ffffff pref]
[    0.293697] pci_bus 0000:0b: resource 3 [mem 0x48000000-0x4bffffff]
[    0.293760] NET: Registered protocol family 2
[    0.293852] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.294104] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.295659] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.296433] TCP: Hash tables configured (established 131072 bind 65536)
[    0.296440] TCP reno registered
[    0.296448] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.296473] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.296635] NET: Registered protocol family 1
[    0.296847] pci 0000:01:00.0: Boot video device
[    0.296926] PCI: CLS 64 bytes, default 64
[    0.297105] Unpacking initramfs...
[    1.426670] Freeing initrd memory: 16444k freed
[    1.440258] Simple Boot Flag at 0x36 set to 0x1
[    1.441711] apm: BIOS not found.
[    1.441969] Intel AES-NI instructions are not detected.
[    1.442471] audit: initializing netlink socket (disabled)
[    1.442496] type=2000 audit(1327446972.441:1): initialized
[    1.497687] highmem bounce pool size: 64 pages
[    1.497701] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.509215] VFS: Disk quotas dquot_6.5.2
[    1.509372] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.510976] msgmni has been set to 1723
[    1.511152] SELinux:  Registering netfilter hooks
[    1.512032] alg: No test for stdrng (krng)
[    1.512055] NET: Registered protocol family 38
[    1.512189] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.512269] io scheduler noop registered
[    1.512275] io scheduler deadline registered
[    1.512296] io scheduler cfq registered (default)
[    1.512928] pcieport 0000:00:01.0: setting latency timer to 64
[    1.513028] pcieport 0000:00:01.0: irq 296 for MSI/MSI-X
[    1.513156] pcieport 0000:00:1c.0: setting latency timer to 64
[    1.513239] pcieport 0000:00:1c.0: irq 297 for MSI/MSI-X
[    1.513386] pcieport 0000:00:1c.1: setting latency timer to 64
[    1.513468] pcieport 0000:00:1c.1: irq 298 for MSI/MSI-X
[    1.513634] pcieport 0000:00:1c.2: setting latency timer to 64
[    1.513715] pcieport 0000:00:1c.2: irq 299 for MSI/MSI-X
[    1.513865] pcieport 0000:00:1c.3: setting latency timer to 64
[    1.513945] pcieport 0000:00:1c.3: irq 300 for MSI/MSI-X
[    1.514195] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.514272] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.514278] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.515317] intel_idle: MWAIT substates: 0x22220
[    1.515324] intel_idle: does not run on family 6 model 14
[    1.517183] ACPI: AC Adapter [ADP1] (on-line)
[    1.517517] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    1.518601] ACPI: Lid Switch [LID0]
[    1.518738] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    1.518751] ACPI: Sleep Button [SLPB]
[    1.518913] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    1.518922] ACPI: Power Button [PWRF]
[    1.526814] Marking TSC unstable due to TSC halts in idle
[    1.526834] ACPI: acpi_idle registered with cpuidle
[    1.540408] thermal LNXTHERM:00: registered as thermal_zone0
[    1.540416] ACPI: Thermal Zone [TZS0] (49 C)
[    1.545066] thermal LNXTHERM:01: registered as thermal_zone1
[    1.545073] ACPI: Thermal Zone [TZS1] (61 C)
[    1.545152] ERST: Table is not found!
[    1.545157] GHES: HEST is not enabled!
[    1.545196] isapnp: Scanning for PnP cards...
[    1.903233] isapnp: No Plug & Play device found
[    1.903426] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.905474] Non-volatile memory driver v1.3
[    1.905481] Linux agpgart interface v0.103
[    1.908695] loop: module loaded
[    1.908909] ata_piix 0000:00:1f.2: version 2.13
[    1.908935] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.908947] ata_piix 0000:00:1f.2: MAP [ IDE IDE P1 P3 ]
[    1.909037] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.909883] scsi0 : ata_piix
[    1.910140] scsi1 : ata_piix
[    1.911760] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x18b0 irq 14
[    1.911768] ata2: SATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x18b8 irq 15
[    1.911993] Fixed MDIO Bus: probed
[    1.912254] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.912308] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.912331] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.912340] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.912518] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    1.912558] ehci_hcd 0000:00:1d.7: using broken periodic workaround
[    1.912578] ehci_hcd 0000:00:1d.7: debug port 1
[    1.916486] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    1.916522] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xd2304000
[    1.926035] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.926115] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.926123] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.926131] usb usb1: Product: EHCI Host Controller
[    1.926137] usb usb1: Manufacturer: Linux 3.2.1-3.fc16.i686 ehci_hcd
[    1.926144] usb usb1: SerialNumber: 0000:00:1d.7
[    1.926480] hub 1-0:1.0: USB hub found
[    1.926492] hub 1-0:1.0: 8 ports detected
[    1.926724] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.926762] uhci_hcd: USB Universal Host Controller Interface driver
[    1.926801] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.926816] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.926824] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.926970] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.927036] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001800
[    1.927114] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    1.927122] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.927129] usb usb2: Product: UHCI Host Controller
[    1.927136] usb usb2: Manufacturer: Linux 3.2.1-3.fc16.i686 uhci_hcd
[    1.927143] usb usb2: SerialNumber: 0000:00:1d.0
[    1.927455] hub 2-0:1.0: USB hub found
[    1.927466] hub 2-0:1.0: 2 ports detected
[    1.927644] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.927661] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.927669] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.927804] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    1.927865] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001820
[    1.927937] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.927945] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.927952] usb usb3: Product: UHCI Host Controller
[    1.927958] usb usb3: Manufacturer: Linux 3.2.1-3.fc16.i686 uhci_hcd
[    1.927965] usb usb3: SerialNumber: 0000:00:1d.1
[    1.928273] hub 3-0:1.0: USB hub found
[    1.928283] hub 3-0:1.0: 2 ports detected
[    1.928462] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.928476] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.928485] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.928622] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    1.928683] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001840
[    1.928755] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.928763] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.928770] usb usb4: Product: UHCI Host Controller
[    1.928776] usb usb4: Manufacturer: Linux 3.2.1-3.fc16.i686 uhci_hcd
[    1.928783] usb usb4: SerialNumber: 0000:00:1d.2
[    1.929093] hub 4-0:1.0: USB hub found
[    1.929104] hub 4-0:1.0: 2 ports detected
[    1.929281] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    1.929295] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    1.929304] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    1.929435] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    1.929496] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00001860
[    1.929575] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.929583] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.929590] usb usb5: Product: UHCI Host Controller
[    1.929597] usb usb5: Manufacturer: Linux 3.2.1-3.fc16.i686 uhci_hcd
[    1.929603] usb usb5: SerialNumber: 0000:00:1d.3
[    1.929890] hub 5-0:1.0: USB hub found
[    1.929901] hub 5-0:1.0: 2 ports detected
[    1.930224] usbcore: registered new interface driver usbserial
[    1.930251] USB Serial support registered for generic
[    1.930301] usbcore: registered new interface driver usbserial_generic
[    1.930307] usbserial: USB Serial Driver core
[    1.930451] i8042: PNP: PS/2 Controller [PNP0303:KBD0,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.930869] i8042: Detected active multiplexing controller, rev 1.1
[    1.930975] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.930990] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.931101] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.931191] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.931269] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.931540] mousedev: PS/2 mouse device common for all mice
[    1.932126] rtc_cmos 00:08: RTC can wake from S4
[    1.932375] rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
[    1.932422] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    1.932611] device-mapper: uevent: version 1.0.3
[    1.932835] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[    1.933173] cpuidle: using governor ladder
[    1.933479] cpuidle: using governor menu
[    1.934000] EFI Variables Facility v0.08 2004-May-17
[    1.934462] usbcore: registered new interface driver usbhid
[    1.934468] usbhid: USB HID core driver
[    1.934587] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    1.934600] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.934633] TCP cubic registered
[    1.934637] Initializing XFRM netlink socket
[    1.935041] NET: Registered protocol family 10
[    1.935464] Mobile IPv6
[    1.935471] NET: Registered protocol family 17
[    1.935508] Registering the dns_resolver key type
[    1.935544] Using IPI No-Shortcut mode
[    1.935944] PM: Hibernation image not present or could not be loaded.
[    1.935972] registered taskstats version 1
[    1.939971]   Magic number: 12:931:302
[    1.940046] tty tty31: hash matches
[    1.940167] rtc_cmos 00:08: setting system clock to 2012-01-24 23:16:14 UTC (1327446974)
[    1.941254] Initializing network drop monitor service
[    2.130779] ata1.00: ATA-7: WDC WD1200UE-22KVT0, 01.03K01, max UDMA/100
[    2.130790] ata1.00: 234441648 sectors, multi 16: LBA48 
[    2.130807] ata1.01: ATAPI: TSSTcorpCD/DVDW TS-L632D, ac00, max UDMA/33
[    2.134663] ata1.00: configured for UDMA/100
[    2.175502] ata1.01: configured for UDMA/33
[    2.228217] usb 1-7: new high-speed USB device number 2 using ehci_hcd
[    2.384576] usb 1-7: New USB device found, idVendor=046d, idProduct=0896
[    2.384585] usb 1-7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.384593] usb 1-7: Product: Camera
[    2.384599] usb 1-7: Manufacturer: OEM
[    2.502379] psmouse serio4: synaptics: Touchpad model: 1, fw: 6.2, id: 0x12a0b1, caps: 0xa04713/0x204000/0x0
[    2.533313] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input4
[   11.571216] ACPI: Battery Slot [BAT0] (battery present)
[   11.571657] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1200UE-22K 01.0 PQ: 0 ANSI: 5
[   11.572046] sd 0:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)
[   11.572166] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   11.572184] sd 0:0:0:0: [sda] Write Protect is off
[   11.572194] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   11.572254] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   11.579726] scsi 0:0:1:0: CD-ROM            TSSTcorp CD/DVDW TS-L632D ac00 PQ: 0 ANSI: 5
[   11.953568] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[   11.953578] cdrom: Uniform CD-ROM driver Revision: 3.20
[   11.953991] sr 0:0:1:0: Attached scsi CD-ROM sr0
[   11.954256] sr 0:0:1:0: Attached scsi generic sg1 type 5
[   11.962056]  sda: sda1 sda2 sda3
[   11.966796] sd 0:0:0:0: [sda] Attached SCSI disk
[   11.966943] Freeing unused kernel memory: 624k freed
[   11.967423] Write protecting the kernel text: 5284k
[   11.967546] Write protecting the kernel read-only data: 2064k
[   12.207607] dracut: dracut-013-20.fc16
[   12.218664] dracut: rd.luks=0: removing cryptoluks activation
[   12.222500] dracut: rd.lvm=0: removing LVM activation
[   12.232319] udevd[101]: starting version 173
[   12.271969] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/LNXVIDEO:00/input/input5
[   12.280272] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[   12.281348] wmi: Mapper loaded
[   12.297484] [drm] Initialized drm 1.1.0 20060810
[   12.325492] nouveau 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   12.325504] nouveau 0000:01:00.0: setting latency timer to 64
[   12.326811] [drm] nouveau 0000:01:00.0: Detected an NV40 generation card (0x046700a3)
[   12.328417] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
[   12.413323] [drm] nouveau 0000:01:00.0: ... appears to be valid
[   12.413329] [drm] nouveau 0000:01:00.0: BIT BIOS found
[   12.413333] [drm] nouveau 0000:01:00.0: Bios version 05.72.22.43
[   12.413338] [drm] nouveau 0000:01:00.0: TMDS table version 1.1
[   12.413341] [drm] nouveau 0000:01:00.0: TMDS table script pointers not stubbed
[   12.413345] [drm] nouveau 0000:01:00.0: Found Display Configuration Block version 3.0
[   12.413350] [drm] nouveau 0000:01:00.0: Raw DCB entry 0: 03005323 00000004
[   12.413355] [drm] nouveau 0000:01:00.0: Raw DCB entry 1: 01010300 00000028
[   12.413359] [drm] nouveau 0000:01:00.0: Raw DCB entry 2: 020223f1 0040c070
[   12.413363] [drm] nouveau 0000:01:00.0: DCB connector table: VHER 0x30 5 10 2
[   12.413368] [drm] nouveau 0000:01:00.0:   0: 0x00000000: type 0x00 idx 0 tag 0xff
[   12.413373] [drm] nouveau 0000:01:00.0:   1: 0x00001130: type 0x30 idx 1 tag 0x07
[   12.413377] [drm] nouveau 0000:01:00.0:   2: 0x00000210: type 0x10 idx 2 tag 0xff
[   12.413381] [drm] nouveau 0000:01:00.0:   3: 0x00000211: type 0x11 idx 3 tag 0xff
[   12.413385] [drm] nouveau 0000:01:00.0:   4: 0x00000213: type 0x13 idx 4 tag 0xff
[   12.413389] [drm] nouveau 0000:01:00.0:   5: 0x00000340: type 0x40 idx 5 tag 0xff
[   12.413394] [drm] nouveau 0000:01:00.0:   6: 0x00002431: type 0x31 idx 6 tag 0x08
[   12.413405] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xE047
[   12.413464] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xE376
[   12.428724] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xE914
[   12.428748] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xEA8F
[   12.429886] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xECE8
[   12.450735] [drm] nouveau 0000:01:00.0: 3 available performance level(s)
[   12.450743] [drm] nouveau 0000:01:00.0: 0: core 100MHz shader 100MHz memory 270MHz voltage 1000mV fanspeed 100%
[   12.450749] [drm] nouveau 0000:01:00.0: 1: core 200MHz shader 200MHz memory 400MHz voltage 1000mV fanspeed 100%
[   12.450756] [drm] nouveau 0000:01:00.0: 2: core 350MHz shader 350MHz memory 600MHz voltage 1000mV fanspeed 100%
[   12.450767] [drm] nouveau 0000:01:00.0: c: core 199MHz memory 391MHz
[   12.451119] [TTM] Zone  kernel: Available graphics memory: 441404 kiB.
[   12.451122] [TTM] Zone highmem: Available graphics memory: 512352 kiB.
[   12.451125] [TTM] Initializing pool allocator.
[   12.451140] [drm] nouveau 0000:01:00.0: Detected 128MiB VRAM
[   12.462524] [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
[   12.462670] [drm] nouveau 0000:01:00.0: Saving VGA fonts
[   12.525802] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   12.525805] [drm] No driver support for vblank timestamp query.
[   12.525812] [drm] nouveau 0000:01:00.0: Setting dpms mode 3 on lvds encoder (output 0)
[   12.525820] [drm] nouveau 0000:01:00.0: Calling LVDS script 6:
[   12.525825] [drm] nouveau 0000:01:00.0: 0xD179: Parsing digital output script table
[   12.805919] [drm] nouveau 0000:01:00.0: Setting dpms mode 3 on vga encoder (output 1)
[   12.805924] [drm] nouveau 0000:01:00.0: Setting dpms mode 3 on TV encoder (output 2)
[   12.972273] [drm] nouveau 0000:01:00.0: allocated 1440x900 fb: 0x49000, bo f4796c00
[   12.972512] fbcon: nouveaufb (fb0) is primary device
[   12.984229] [drm] nouveau 0000:01:00.0: Calling LVDS script 2:
[   12.984238] [drm] nouveau 0000:01:00.0: 0xD1EF: Parsing digital output script table
[   13.132355] [drm] nouveau 0000:01:00.0: Setting dpms mode 0 on lvds encoder (output 0)
[   13.132361] [drm] nouveau 0000:01:00.0: Calling LVDS script 5:
[   13.132367] [drm] nouveau 0000:01:00.0: 0xD16A: Parsing digital output script table
[   13.132382] [drm] nouveau 0000:01:00.0: Output LVDS-1 is running on CRTC 0 using output A
[   13.135665] Console: switching to colour frame buffer device 180x56
[   13.138643] fb0: nouveaufb frame buffer device
[   13.138646] drm: registered panic notifier
[   13.138663] [drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on minor 0
[   13.152149] dracut: Starting plymouth daemon
[   13.489804] dracut: rd.dm=0: removing DM RAID activation
[   13.497176] dracut: rd.md=0: removing MD RAID activation
[   13.635741] yenta_cardbus 0000:0a:06.0: CardBus bridge found [1025:0107]
[   13.635767] yenta_cardbus 0000:0a:06.0: Using CSCINT to route CSC interrupts to PCI
[   13.635771] yenta_cardbus 0000:0a:06.0: Routing CardBus interrupts to PCI
[   13.635779] yenta_cardbus 0000:0a:06.0: TI: mfunc 0x01aa1b22, devctl 0x64
[   13.648548] sdhci: Secure Digital Host Controller Interface driver
[   13.648553] sdhci: Copyright(c) Pierre Ossman
[   13.858918] yenta_cardbus 0000:0a:06.0: ISA IRQ mask 0x0cf8, PCI irq 22
[   13.858929] yenta_cardbus 0000:0a:06.0: Socket status: 30000006
[   13.858939] pci_bus 0000:0a: Raising subordinate bus# of parent bus (#0a) from #0a to #0e
[   13.858959] yenta_cardbus 0000:0a:06.0: pcmcia: parent PCI bridge window: [io  0x6000-0x6fff]
[   13.858969] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x6000-0x6fff: excluding 0x6000-0x60ff 0x6400-0x64ff
[   13.866685] yenta_cardbus 0000:0a:06.0: pcmcia: parent PCI bridge window: [mem 0xd2000000-0xd20fffff]
[   13.866695] pcmcia_socket pcmcia_socket0: cs: memory probe 0xd2000000-0xd20fffff: excluding 0xd2000000-0xd200ffff
[   13.866731] yenta_cardbus 0000:0a:06.0: pcmcia: parent PCI bridge window: [mem 0x40000000-0x43ffffff pref]
[   13.866740] pcmcia_socket pcmcia_socket0: cs: memory probe 0x40000000-0x43ffffff: excluding 0x40000000-0x43ffffff
[   13.867609] sdhci-pci 0000:0a:06.3: SDHCI controller found [104c:803c] (rev 0)
[   13.867639] sdhci-pci 0000:0a:06.3: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   13.867788] Registered led device: mmc0::
[   13.869065] mmc0: SDHCI controller on PCI [0000:0a:06.3] using PIO
[   14.329903] EXT4-fs (sda3): INFO: recovery required on readonly filesystem
[   14.329914] EXT4-fs (sda3): write access will be enabled during recovery
[   16.433796] EXT4-fs (sda3): orphan cleanup on readonly fs
[   16.433809] EXT4-fs (sda3): ext4_orphan_cleanup: deleting unreferenced inode 267164
[   16.433846] EXT4-fs (sda3): ext4_orphan_cleanup: deleting unreferenced inode 262324
[   16.447389] EXT4-fs (sda3): ext4_orphan_cleanup: deleting unreferenced inode 157912
[   16.447482] EXT4-fs (sda3): ext4_orphan_cleanup: deleting unreferenced inode 136330
[   16.447535] EXT4-fs (sda3): ext4_orphan_cleanup: deleting unreferenced inode 267169
[   16.447710] EXT4-fs (sda3): 5 orphan inodes deleted
[   16.447713] EXT4-fs (sda3): recovery complete
[   16.706575] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
[   16.797565] dracut: Checking ext4: /dev/disk/by-uuid/e686d580-5b12-4573-ac32-c59cb952abde
[   16.797719] dracut: issuing e2fsck -a  /dev/disk/by-uuid/e686d580-5b12-4573-ac32-c59cb952abde
[   16.917953] dracut: _Fedora-16-i686-: clean, 140829/7069696 files, 1665640/28256256 blocks
[   16.918728] dracut: Remounting /dev/disk/by-uuid/e686d580-5b12-4573-ac32-c59cb952abde with -o ro
[   17.088380] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
[   17.100747] dracut: Mounted root filesystem /dev/sda3
[   17.309503] dracut: Switching root
[   17.989146] type=1404 audit(1327446990.548:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[   18.180348] SELinux: 2048 avtab hash slots, 97339 rules.
[   18.211842] SELinux: 2048 avtab hash slots, 97339 rules.
[   18.310789] SELinux:  9 users, 13 roles, 3912 types, 209 bools, 1 sens, 1024 cats
[   18.310796] SELinux:  82 classes, 97339 rules
[   18.317976] SELinux:  Completing initialization.
[   18.317981] SELinux:  Setting up existing superblocks.
[   18.317993] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[   18.318017] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[   18.318953] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[   18.318963] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[   18.318976] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   18.319019] SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
[   18.319802] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[   18.319809] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[   18.322419] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[   18.322430] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[   18.322436] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[   18.322458] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[   18.322468] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[   18.322477] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[   18.322515] SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
[   18.322528] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[   18.323781] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   18.323791] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   18.327490] SELinux: initialized (dev sda3, type ext4), uses xattr
[   18.331301] type=1403 audit(1327446990.890:3): policy loaded auid=4294967295 ses=4294967295
[   18.368606] systemd[1]: Successfully loaded SELinux policy in 423ms 352us.
[   18.417796] systemd[1]: Successfully loaded SELinux database in 48ms 972us, size on heap is 364K.
[   18.445674] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   18.447197] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   18.521384] systemd[1]: Relabelled /dev and /run in 73ms 949us.
[   18.543258] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   18.548270] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   18.549852] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   18.553245] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   18.554777] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   18.559237] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   18.560743] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   18.564245] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   18.564549] systemd[1]: systemd 37 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +SYSVINIT +LIBCRYPTSETUP; fedora)
[   18.630692] systemd[1]: Set hostname to <laptop>.
[   20.409121] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[   22.328878] udevd[434]: starting version 173
[   28.584774] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[   28.584808] r8169 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   28.584848] r8169 0000:02:00.0: setting latency timer to 64
[   28.584956] r8169 0000:02:00.0: irq 301 for MSI/MSI-X
[   28.585233] r8169 0000:02:00.0: eth0: RTL8168b/8111b at 0xf7c4e000, 00:16:d3:4b:e2:2f, XID 18000000 IRQ 301
[   28.585238] r8169 0000:02:00.0: eth0: jumbo features [frames: 4080 bytes, tx checksumming: ko]
[   28.663860] intel_rng: FWH not detected
[   28.672243] iTCO_vendor_support: vendor-support=0
[   28.678646] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
[   28.678771] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
[   28.682970] cfg80211: Calling CRDA to update world regulatory domain
[   28.684178] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   28.720192] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:ds
[   28.720197] iwl3945: Copyright(c) 2003-2011 Intel Corporation
[   28.720328] iwl3945 0000:05:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   28.720345] iwl3945 0000:05:00.0: setting latency timer to 64
[   28.729927] microcode: CPU0 sig=0x6e8, pf=0x20, revision=0x39
[   28.730983] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3af: excluding 0x170-0x177 0x1f0-0x1f7
[   28.771713] iwl3945 0000:05:00.0: Tunable channels: 13 802.11bg, 23 802.11a channels
[   28.771719] iwl3945 0000:05:00.0: Detected Intel Wireless WiFi Link 3945ABG
[   28.772042] iwl3945 0000:05:00.0: irq 302 for MSI/MSI-X
[   28.782433] Registered led device: phy0-led
[   28.784351]  0x370-0x377
[   28.784553] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3e0-0x4ff: excluding 0x3f0-0x3f7 0x4d0-0x4d7
[   28.785547] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x820-0x8ff: clean.
[   28.797559] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc00-0xcf7: clean.
[   28.798437] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0c0000-0x0fffff: excluding 0xc0000-0xcffff 0xdc000-0xfffff
[   28.798514] pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0xa0ffffff: clean.
[   28.798588] pcmcia_socket pcmcia_socket0: cs: memory probe 0x60000000-0x60ffffff: clean.
[   28.798669] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa00-0xaff:
[   28.811728] ieee80211 phy0: Selected rate control algorithm 'iwl-3945-rs'
[   28.812529] snd_hda_intel 0000:00:1b.0: power state changed by ACPI to D0
[   28.812537] snd_hda_intel 0000:00:1b.0: power state changed by ACPI to D0
[   28.812549] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   28.812781] snd_hda_intel 0000:00:1b.0: irq 303 for MSI/MSI-X
[   28.812829] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[   28.819473]  clean.
[   28.849457] hda_codec: ALC883: BIOS auto-probing.
[   28.849465] ALSA sound/pci/hda/patch_realtek.c:1261 SKU: Nid=0x0 sku_cfg=0x00001235
[   28.849469] ALSA sound/pci/hda/patch_realtek.c:1263 SKU: port_connectivity=0x0
[   28.849472] ALSA sound/pci/hda/patch_realtek.c:1264 SKU: enable_pcbeep=0x1
[   28.849476] ALSA sound/pci/hda/patch_realtek.c:1265 SKU: check_sum=0x00000000
[   28.849480] ALSA sound/pci/hda/patch_realtek.c:1266 SKU: customization=0x00000000
[   28.849483] ALSA sound/pci/hda/patch_realtek.c:1267 SKU: external_amp=0x6
[   28.849491] ALSA sound/pci/hda/patch_realtek.c:1268 SKU: platform_type=0x1
[   28.849495] ALSA sound/pci/hda/patch_realtek.c:1269 SKU: swap=0x0
[   28.849498] ALSA sound/pci/hda/patch_realtek.c:1270 SKU: override=0x1
[   28.849511] ALSA sound/pci/hda/hda_codec.c:4951 autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:line
[   28.849517] ALSA sound/pci/hda/hda_codec.c:4955    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   28.849521] ALSA sound/pci/hda/hda_codec.c:4959    hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   28.849525] ALSA sound/pci/hda/hda_codec.c:4960    mono: mono_out=0x0
[   28.849528] ALSA sound/pci/hda/hda_codec.c:4963    dig-out=0x1e/0x0
[   28.849532] ALSA sound/pci/hda/hda_codec.c:4964    inputs:
[   28.849535] ALSA sound/pci/hda/hda_codec.c:4968  Mic=0x18
[   28.849539] ALSA sound/pci/hda/hda_codec.c:4968  Line=0x1a
[   28.849542] ALSA sound/pci/hda/hda_codec.c:4970 
[   28.851306] ALSA sound/pci/hda/patch_realtek.c:1340 realtek: Enabling init ASM_ID=0x1235 CODEC_ID=10ec0883
[   28.942124] cfg80211: World regulatory domain updated:
[   28.942129] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   28.942134] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   28.942138] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   28.942142] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   28.942146] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   28.942150] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   28.951997] leds_ss4200: no LED devices found
[   29.007090] mtp-probe[570]: checking bus 1, device 2: "/sys/devices/pci0000:00/0000:00:1d.7/usb1/1-7"
[   29.141450] acer_wmi: Acer Laptop ACPI-WMI Extras
[   29.144811] acer_wmi: Function bitmap for Communication Device: 0x27
[   29.413091] udevd[452]: renamed network interface eth0 to p2p1
[   29.425274] tifm_7xx1 0000:0a:06.2: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   29.672496] microcode: CPU1 sig=0x6e8, pf=0x20, revision=0x39
[   29.677733] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   29.852048] SELinux: initialized (dev configfs, type configfs), uses genfs_contexts
[   29.859082] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[   29.865849] SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
[   29.870054] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   29.876877] RPC: Registered named UNIX socket transport module.
[   29.876882] RPC: Registered udp transport module.
[   29.876884] RPC: Registered tcp transport module.
[   29.876887] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   29.877495] SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
[   30.021829] SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
[   30.142974] mtp-probe[570]: bus: 1, device: 2 was not an MTP device
[   30.522068] cfg80211: Calling CRDA for country: ES
[   30.529480] cfg80211: Regulatory domain changed to country: ES
[   30.529484] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   30.529488] cfg80211:     (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   30.529492] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   30.529496] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   30.529500] cfg80211:     (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[   31.532234] EXT4-fs (sda3): re-mounted. Opts: (null)
[   31.579429] Linux media interface: v0.10
[   31.586232] Linux video capture interface: v2.00
[   31.587447] gspca_main: v2.14.0 registered
[   31.588171] gspca_main: vc032x-2.14.0 probing 046d:0896
[   31.593580] usbcore: registered new interface driver vc032x
[   32.058771] Adding 2097148k swap on /dev/sda2.  Priority:0 extents:1 across:2097148k 
[   32.091375] rmmod[735]: ERROR: Module scsi_wait_scan does not exist in /proc/modules
[   32.217820] systemd-fsck[729]: /dev/sda1: recuperando el fichero de transacciones
[   32.515458] systemd-fsck[729]: /dev/sda1 ha sido montado 23 veces sin ser revisado, se fuerza la revisi\xffffffc3\xffffffb3\xffffffb3n.
[   32.822580] systemd-fsck[729]: /dev/sda1: 270/131072 ficheros (0.7% no contiguos), 38292/524288 bloques
[   32.952861] fedora-storage-init[741]: Configurando gestor de vol\xffffffc3\xffffffba\xffffffbamenes l\xffffffc3\xffffffb3\xffffffb3gicos:   No volume groups found
[   32.963594] fedora-storage-init[741]: [  OK  ]
[   33.080906] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[   33.080923] SELinux: initialized (dev sda1, type ext4), uses xattr
[   33.174238] fedora-storage-init[754]: Configurando gestor de vol\xffffffc3\xffffffba\xffffffbamenes l\xffffffc3\xffffffb3\xffffffb3gicos:   No volume groups found
[   33.187883] fedora-storage-init[754]: [  OK  ]
[   33.315523] lvm[764]: No volume groups found
[   33.413248] systemd-tmpfiles[768]: Successfully loaded SELinux database in 31ms 271us, size on heap is 366K.
[   33.725370] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   33.737494] nf_conntrack version 0.5.0 (16011 buckets, 64044 max)
[   33.748747] ip6tables.init[778]: ip6tables: Aplicando las reglas del cortafuegos: [  OK  ]
[   33.774468] NetworkManager[809]: NetworkManager[809]: <info> NetworkManager (version 0.9.2-1.fc16) is starting...
[   33.775465] NetworkManager[809]: <info> NetworkManager (version 0.9.2-1.fc16) is starting...
[   33.775575] NetworkManager[809]: NetworkManager[809]: <info> Read config file /etc/NetworkManager/NetworkManager.conf
[   33.775599] NetworkManager[809]: <info> Read config file /etc/NetworkManager/NetworkManager.conf
[   33.803179] acpid[826]: starting up with netlink and the input layer
[   33.803399] acpid[826]: skipping incomplete file /etc/acpi/events/videoconf
[   33.803512] acpid[826]: 1 rule loaded
[   33.803625] acpid[826]: waiting for events: event logging is off
[   33.811622] abrtd[820]: Init complete, entering main loop
[   33.849925] iptables.init[777]: iptables: Aplicando reglas del cortafuegos:[  OK  ]
[   33.852388] mcelog[819]: mcelog read: No such device
[   33.885081] avahi-daemon[827]: Found user 'avahi' (UID 70) and group 'avahi' (GID 70).
[   33.887056] avahi-daemon[827]: Successfully dropped root privileges.
[   33.887544] avahi-daemon[827]: avahi-daemon 0.6.30 starting up.
[   33.923158] auditctl[781]: No rules
[   33.923169] auditctl[781]: AUDIT_STATUS: enabled=0 flag=1 pid=0 rate_limit=0 backlog_limit=320 lost=0 backlog=0
[   33.928162] auditd[780]: Started dispatcher: /sbin/audispd pid: 852
[   33.932054] audispd[852]: priority_boost_parser called with: 4
[   33.932066] audispd[852]: max_restarts_parser called with: 10
[   33.932075] audispd[852]: audispd initialized with q_depth=120 and 1 active plugins
[   34.048666] NetworkManager[809]: NetworkManager[809]: <info> VPN: loaded org.freedesktop.NetworkManager.pptp
[   34.048679] auditd[780]: Init complete, auditd 2.1.3 listening for events (startup state enable)
[   34.048868] NetworkManager[809]: <info> VPN: loaded org.freedesktop.NetworkManager.pptp
[   34.049121] NetworkManager[809]: NetworkManager[809]: <info> VPN: loaded org.freedesktop.NetworkManager.vpnc
[   34.049182] NetworkManager[809]: <info> VPN: loaded org.freedesktop.NetworkManager.vpnc
[   34.049352] NetworkManager[809]: NetworkManager[809]: <info> VPN: loaded org.freedesktop.NetworkManager.openvpn
[   34.049411] NetworkManager[809]: <info> VPN: loaded org.freedesktop.NetworkManager.openvpn
[   34.064788] systemd-logind[833]: New seat seat0.
[   34.067060] avahi-daemon[827]: Successfully called chroot().
[   34.067072] avahi-daemon[827]: Successfully dropped remaining capabilities.
[   34.067080] avahi-daemon[827]: Loading service file /services/ssh.service.
[   34.067088] avahi-daemon[827]: Loading service file /services/udisks.service.
[   34.067096] avahi-daemon[827]: Network interface enumeration completed.
[   34.067104] avahi-daemon[827]: Registering HINFO record with values 'I686'/'LINUX'.
[   34.067112] avahi-daemon[827]: Server startup complete. Host name is laptop.local. Local service cookie is 243030463.
[   34.067120] avahi-daemon[827]: Service "laptop" (/services/udisks.service) successfully established.
[   34.067128] avahi-daemon[827]: Service "laptop" (/services/ssh.service) successfully established.
[   34.071208] sandbox[859]: Starting sandbox[  OK  ]
[   34.087325] dbus-daemon[860]: dbus[860]: [system] Activating service name='org.freedesktop.PolicyKit1' (using servicehelper)
[   34.088262] dbus[860]: [system] Activating service name='org.freedesktop.PolicyKit1' (using servicehelper)
[   34.302205] r8169 0000:02:00.0: p2p1: link down
[   34.323378] ADDRCONF(NETDEV_UP): p2p1: link is not ready
[   34.347212] 8021q: 802.1Q VLAN Support v1.8
[   34.351250] iwl3945 0000:05:00.0: loaded firmware version 15.32.2.9
[   34.451140] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   70.877628] wlan0: authenticate with 00:1d:68:f0:e7:b7 (try 1)
[   70.879835] wlan0: authenticated
[   70.882486] wlan0: associate with 00:1d:68:f0:e7:b7 (try 1)
[   70.885108] wlan0: RX AssocResp from 00:1d:68:f0:e7:b7 (capab=0x411 status=0 aid=1)
[   70.885117] wlan0: associated
[   70.887540] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   80.994041] wlan0: no IPv6 routers present
[   83.596426] hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
[  139.284850] CE: hpet increased min_delta_ns to 20113 nsec
[  468.822684] TCP lp registered
[  720.836099] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[ 2635.939038] usb 1-7: USB disconnect, device number 2
[ 2636.250211] usb 1-7: new high-speed USB device number 3 using ehci_hcd
[ 2636.406530] usb 1-7: New USB device found, idVendor=046d, idProduct=0896
[ 2636.406541] usb 1-7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 2636.406549] usb 1-7: Product: Camera
[ 2636.406555] usb 1-7: Manufacturer: OEM
[ 2636.410499] gspca_main: vc032x-2.14.0 probing 046d:0896
[ 3446.552730] usb 1-7: USB disconnect, device number 3
[ 3446.579108] gspca_vc032x: reg_w err -19
[ 3448.332179] usb 1-7: new high-speed USB device number 4 using ehci_hcd
[ 3448.488479] usb 1-7: New USB device found, idVendor=046d, idProduct=0896
[ 3448.488490] usb 1-7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 3448.488498] usb 1-7: Product: Camera
[ 3448.488504] usb 1-7: Manufacturer: OEM
[ 3448.492437] gspca_main: vc032x-2.14.0 probing 046d:0896
[ 3470.871953] usb 1-7: USB disconnect, device number 4
[ 3471.104177] usb 1-7: new high-speed USB device number 5 using ehci_hcd
[ 3471.260353] usb 1-7: New USB device found, idVendor=046d, idProduct=0896
[ 3471.260364] usb 1-7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 3471.260372] usb 1-7: Product: Camera
[ 3471.260378] usb 1-7: Manufacturer: OEM
[ 3471.263446] gspca_main: vc032x-2.14.0 probing 046d:0896
[ 3480.643329] usb 1-7: USB disconnect, device number 5
[ 3480.670107] gspca_vc032x: reg_w err -19
[ 3482.422211] usb 1-7: new high-speed USB device number 6 using ehci_hcd
[ 3482.578606] usb 1-7: New USB device found, idVendor=046d, idProduct=0896
[ 3482.578617] usb 1-7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 3482.578625] usb 1-7: Product: Camera
[ 3482.578631] usb 1-7: Manufacturer: OEM
[ 3482.581700] gspca_main: vc032x-2.14.0 probing 046d:0896
[ 3801.562564] usb 1-7: USB disconnect, device number 6
[ 3801.589089] gspca_vc032x: reg_w err -19
[ 3803.341058] usb 1-7: new high-speed USB device number 7 using ehci_hcd
[ 3803.496982] usb 1-7: New USB device found, idVendor=046d, idProduct=0896
[ 3803.496993] usb 1-7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 3803.497001] usb 1-7: Product: Camera
[ 3803.497030] usb 1-7: Manufacturer: OEM
[ 3803.500145] gspca_main: vc032x-2.14.0 probing 046d:0896
[ 3997.346304] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[ 3998.508236] libfcoe_device_notification: NETDEV_UNREGISTER lo
[ 4751.364788] [drm] nouveau 0000:01:00.0: Setting dpms mode 3 on lvds encoder (output 0)
[ 4751.364798] [drm] nouveau 0000:01:00.0: Calling LVDS script 6:
[ 4751.364810] [drm] nouveau 0000:01:00.0: 0xD179: Parsing digital output script table
[ 4754.836803] [drm] nouveau 0000:01:00.0: Setting dpms mode 0 on lvds encoder (output 0)
[ 4754.836810] [drm] nouveau 0000:01:00.0: Calling LVDS script 2:
[ 4754.836819] [drm] nouveau 0000:01:00.0: 0xD1EF: Parsing digital output script table
[ 4754.984922] [drm] nouveau 0000:01:00.0: Calling LVDS script 5:
[ 4754.984927] [drm] nouveau 0000:01:00.0: 0xD16A: Parsing digital output script table
[ 4773.997440] [drm] nouveau 0000:01:00.0: Setting dpms mode 3 on lvds encoder (output 0)
[ 4773.997450] [drm] nouveau 0000:01:00.0: Calling LVDS script 6:
[ 4773.997463] [drm] nouveau 0000:01:00.0: 0xD179: Parsing digital output script table
[ 5615.970881] usb 1-7: USB disconnect, device number 7
[ 5616.205176] usb 1-7: new high-speed USB device number 8 using ehci_hcd
[ 5616.361653] usb 1-7: New USB device found, idVendor=046d, idProduct=0896
[ 5616.361664] usb 1-7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 5616.361672] usb 1-7: Product: Camera
[ 5616.361677] usb 1-7: Manufacturer: OEM
[ 5616.366000] gspca_main: vc032x-2.14.0 probing 046d:0896
[ 5651.546113] usb 1-7: USB disconnect, device number 8
[ 5651.754505] hub 1-0:1.0: unable to enumerate USB device on port 7
[ 5652.084232] usb 1-7: new high-speed USB device number 10 using ehci_hcd
[ 5652.230745] usb 1-7: device descriptor read/all, error -71
[ 5652.333184] usb 1-7: new high-speed USB device number 11 using ehci_hcd
[ 5652.489505] usb 1-7: New USB device found, idVendor=046d, idProduct=0896
[ 5652.489515] usb 1-7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 5652.489523] usb 1-7: Product: Camera
[ 5652.489529] usb 1-7: Manufacturer: OEM
[ 5652.492745] gspca_main: vc032x-2.14.0 probing 046d:0896
[ 5654.205634] usb 1-7: USB disconnect, device number 11
[ 5654.797379] hub 1-0:1.0: unable to enumerate USB device on port 7
[ 5658.572196] usb 1-7: new high-speed USB device number 13 using ehci_hcd
[ 5658.728698] usb 1-7: New USB device found, idVendor=046d, idProduct=0896
[ 5658.728709] usb 1-7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 5658.728717] usb 1-7: Product: Camera
[ 5658.728723] usb 1-7: Manufacturer: OEM
[ 5658.731791] gspca_main: vc032x-2.14.0 probing 046d:0896
[ 5762.472691] usb 1-7: USB disconnect, device number 13
[ 5771.600457] hub 1-0:1.0: unable to enumerate USB device on port 7
[ 5847.015181] usb 1-7: new high-speed USB device number 15 using ehci_hcd
[ 5847.171391] usb 1-7: New USB device found, idVendor=046d, idProduct=0896
[ 5847.171402] usb 1-7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 5847.171410] usb 1-7: Product: Camera
[ 5847.171416] usb 1-7: Manufacturer: OEM
[ 5847.174487] gspca_main: vc032x-2.14.0 probing 046d:0896
[ 5848.816837] usb 1-7: USB disconnect, device number 15
[ 6020.476480] hub 1-0:1.0: unable to enumerate USB device on port 7
[11984.772165] usb 1-7: new high-speed USB device number 17 using ehci_hcd
[11984.901170] usb 1-7: device descriptor read/64, error -71
[11985.131207] usb 1-7: device descriptor read/64, error -71
[11985.334190] usb 1-7: new high-speed USB device number 18 using ehci_hcd
[11985.463096] usb 1-7: device descriptor read/64, error -71
[11985.693209] usb 1-7: device descriptor read/64, error -71
[11985.896224] usb 1-7: new high-speed USB device number 19 using ehci_hcd
[11985.934622] usb 1-7: device descriptor read/8, error -71
[11986.072771] usb 1-7: device descriptor read/8, error -71
[11986.275212] usb 1-7: new high-speed USB device number 20 using ehci_hcd
[11986.313626] usb 1-7: device descriptor read/8, error -71
[11986.451747] usb 1-7: device descriptor read/8, error -71
[11986.552171] hub 1-0:1.0: unable to enumerate USB device on port 7
[11986.844192] usb 5-1: new full-speed USB device number 2 using uhci_hcd
[11986.979187] usb 5-1: device descriptor read/64, error -71
[11987.213221] usb 5-1: device descriptor read/64, error -71
[11987.416145] usb 5-1: new full-speed USB device number 3 using uhci_hcd
[11987.559279] usb 5-1: not running at top speed; connect to a high speed hub
[11987.610283] usb 5-1: New USB device found, idVendor=046d, idProduct=0896
[11987.610293] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[11987.610301] usb 5-1: Product: Camera
[11987.610307] usb 5-1: Manufacturer: OEM
[11987.615390] gspca_main: vc032x-2.14.0 probing 046d:0896
[17179.000251] usb 5-1: USB disconnect, device number 3
[17188.592205] usb 1-7: new high-speed USB device number 21 using ehci_hcd
[17188.721176] usb 1-7: device descriptor read/64, error -71
[17188.900466] hub 1-0:1.0: unable to enumerate USB device on port 7
[24394.342793] [drm] nouveau 0000:01:00.0: Setting dpms mode 0 on lvds encoder (output 0)
[24394.342804] [drm] nouveau 0000:01:00.0: Calling LVDS script 2:
[24394.342816] [drm] nouveau 0000:01:00.0: 0xD1EF: Parsing digital output script table
[24394.490944] [drm] nouveau 0000:01:00.0: Calling LVDS script 5:
[24394.490952] [drm] nouveau 0000:01:00.0: 0xD16A: Parsing digital output script table
[24456.746211] usb 1-7: new high-speed USB device number 22 using ehci_hcd
[24456.902568] usb 1-7: New USB device found, idVendor=046d, idProduct=0896
[24456.902578] usb 1-7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[24456.902586] usb 1-7: Product: Camera
[24456.902592] usb 1-7: Manufacturer: OEM
[24456.906910] gspca_main: vc032x-2.14.0 probing 046d:0896
[24457.587451] usb 1-7: USB disconnect, device number 22
[24976.566194] libfcoe_device_notification: NETDEV_UNREGISTER lo
[24995.340868] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[25592.109537] [drm] nouveau 0000:01:00.0: Setting dpms mode 1 on lvds encoder (output 0)
[25592.109547] [drm] nouveau 0000:01:00.0: Calling LVDS script 6:
[25592.109559] [drm] nouveau 0000:01:00.0: 0xD179: Parsing digital output script table
[25892.399348] [drm] nouveau 0000:01:00.0: Setting dpms mode 2 on lvds encoder (output 0)
[26192.059219] [drm] nouveau 0000:01:00.0: Setting dpms mode 3 on lvds encoder (output 0)
[27004.339118] [drm] nouveau 0000:01:00.0: Setting dpms mode 0 on lvds encoder (output 0)
[27004.339129] [drm] nouveau 0000:01:00.0: Calling LVDS script 2:
[27004.339141] [drm] nouveau 0000:01:00.0: 0xD1EF: Parsing digital output script table
[27004.487275] [drm] nouveau 0000:01:00.0: Calling LVDS script 5:
[27004.487283] [drm] nouveau 0000:01:00.0: 0xD16A: Parsing digital output script table
[27320.553192] libfcoe_device_notification: NETDEV_UNREGISTER lo
[27561.887494] SELinux: initialized (dev proc, type proc), uses genfs_contexts

--mP3DRpeJDSE+ciuQ--
