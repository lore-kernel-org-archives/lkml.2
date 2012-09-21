Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069Ab2IUTsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:48:05 -0400
Received: from tee.schottelius.org ([77.109.138.222]:34691 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757842Ab2IUTry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:47:54 -0400
Date: Fri, 21 Sep 2012 21:49:31 +0200
From: Nico Schottelius <nico-kernel20120920@schottelius.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: Nico Schottelius <nico-kernel20120920@schottelius.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Out of memory on 3.5 kernels
Message-ID: <20120921194931.GA732@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-kernel20120920@schottelius.org>,
	Arend van Spriel <arend@broadcom.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <505B1FA0.6030100@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <505B1FA0.6030100@broadcom.com>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.5.4-1-ARCH x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Latest results:

- it seems I can trigger the problem by doing the backup to my external
  usb disk

- the usb disk uses jfs

- jfs seems to take the major part in cache memory consumption

I've attached dmesg and slabtop outputs of various stages:

- before and during the backup

I've had to abort the backup, because memory pressure made the system
almost completly unusable.

Hope this helps & someone has a clue on what went wrong were...

Cheers,

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0

--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg1

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.5.4-1-ARCH (tobias@T-POWA-LX) (gcc version 4.7.1 20120721 (prerelease) (GCC) ) #1 SMP PREEMPT Sat Sep 15 08:12:04 CEST 2012
[    0.000000] Command line: root=/dev/mapper/root cryptdevice=/dev/sda5:root ro i915.i915_enable_rc6=1 init=/bin/systemd initrd=../initramfs-linux.img BOOT_IMAGE=../vmlinuz-linux 
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000008efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000008f000-0x000000000008ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000090000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x000000003fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040000000-0x00000000401fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040200000-0x000000008ad33fff] usable
[    0.000000] BIOS-e820: [mem 0x000000008ad34000-0x000000008ad5efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000008ad5f000-0x000000008afa1fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000008afa2000-0x000000008affefff] reserved
[    0.000000] BIOS-e820: [mem 0x000000008afff000-0x000000008affffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000008b000000-0x000000008f9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed13fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed18000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000016fdfffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Apple Inc. MacBookAir4,2/Mac-742912EFDBEE19B3, BIOS MBA41.88Z.0077.B0E.1110141154 10/14/2011
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x16fe00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   1 base 0A0000000 mask FE0000000 uncachable
[    0.000000]   2 base 090000000 mask FF0000000 uncachable
[    0.000000]   3 base 08C000000 mask FFC000000 uncachable
[    0.000000]   4 base 08B800000 mask FFF800000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0x8ad34 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x8ad33fff]
[    0.000000]  [mem 0x00000000-0x8abfffff] page 2M
[    0.000000]  [mem 0x8ac00000-0x8ad33fff] page 4k
[    0.000000] kernel direct mapping tables up to 0x8ad33fff @ [mem 0x1f830000-0x1fc8afff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x16fdfffff]
[    0.000000]  [mem 0x100000000-0x16fdfffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x16fdfffff @ [mem 0x8ad2d000-0x8ad33fff]
[    0.000000] RAMDISK: [mem 0x1fc8b000-0x1fffefff]
[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 APPLE )
[    0.000000] ACPI: XSDT 000000008ad8e1c0 000AC (v01 APPLE   Apple00 00000060      01000013)
[    0.000000] ACPI: FACP 000000008ad8c000 000F4 (v04 APPLE   Apple00 00000060 Loki 0000005F)
[    0.000000] ACPI: DSDT 000000008ad81000 05050 (v01 APPLE  MacBookA 00040001 INTL 20100915)
[    0.000000] ACPI: FACS 000000008ad3e000 00040
[    0.000000] ACPI: HPET 000000008ad8b000 00038 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: APIC 000000008ad8a000 000BC (v02 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SBST 000000008ad88000 00030 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: ECDT 000000008ad87000 00053 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SSDT 000000008ad7d000 00024 (v01 APPLE   SmcDppt 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad7b000 006CA (v01 APPLE     UsbSD 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad77000 00159 (v02 APPLE     IGHda 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad73000 015EB (v02 APPLE  SsdtIGPU 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad72000 00569 (v01  PmRef  Cpu0Ist 00003000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad71000 009B1 (v01  PmRef    CpuPm 00003000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad70000 00315 (v01  PmRef  Cpu0Tst 00003000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad6f000 0037A (v01  PmRef    ApTst 00003000 INTL 20100915)
[    0.000000] ACPI: MCFG 000000008ad89000 0003C (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SSDT 000000008ad80000 000FA (v01 SataRe  SataPri 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad7f000 000D0 (v01 SataRe  SataSec 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad7e000 00032 (v01  Apple   SsdtS3 00001000 INTL 20100915)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000016fdfffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x16fdfffff]
[    0.000000]   NODE_DATA [mem 0x16fdfc000-0x16fdfffff]
[    0.000000]  [ffffea0000000000-ffffea0005bfffff] PMD -> [ffff88016b400000-ffff88016f3fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x16fdfffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0008efff]
[    0.000000]   node   0: [mem 0x00090000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x3fffffff]
[    0.000000]   node   0: [mem 0x40200000-0x8ad33fff]
[    0.000000]   node   0: [mem 0x100000000-0x16fdfffff]
[    0.000000] On node 0 totalpages: 1025730
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3912 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 547188 pages, LIFO batch:31
[    0.000000]   Normal zone: 7160 pages used for memmap
[    0.000000]   Normal zone: 451080 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000008f000 - 0000000000090000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
[    0.000000] PM: Registered nosave memory: 0000000040000000 - 0000000040200000
[    0.000000] PM: Registered nosave memory: 000000008ad34000 - 000000008ad5f000
[    0.000000] PM: Registered nosave memory: 000000008ad5f000 - 000000008afa2000
[    0.000000] PM: Registered nosave memory: 000000008afa2000 - 000000008afff000
[    0.000000] PM: Registered nosave memory: 000000008afff000 - 000000008b000000
[    0.000000] PM: Registered nosave memory: 000000008b000000 - 000000008fa00000
[    0.000000] PM: Registered nosave memory: 000000008fa00000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed04000
[    0.000000] PM: Registered nosave memory: 00000000fed04000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff800000
[    0.000000] PM: Registered nosave memory: 00000000ff800000 - 0000000100000000
[    0.000000] e820: [mem 0x8fa00000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88016fa00000 s83392 r8192 d23104 u262144
[    0.000000] pcpu-alloc: s83392 r8192 d23104 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1002180
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/mapper/root cryptdevice=/dev/sda5:root ro i915.i915_enable_rc6=1 init=/bin/systemd initrd=../initramfs-linux.img BOOT_IMAGE=../vmlinuz-linux 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 3955664k/6027264k available (4645k kernel code, 1924344k absent, 147256k reserved, 4207k data, 760k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 16777216 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.003333] Detected 1799.998 MHz processor.
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 3601.99 BogoMIPS (lpj=5999993)
[    0.000006] pid_max: default: 32768 minimum: 301
[    0.000034] Security Framework initialized
[    0.000038] AppArmor: AppArmor disabled by boot time parameter
[    0.000365] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.001450] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.001906] Mount-cache hash table entries: 256
[    0.002108] Initializing cgroup subsys cpuacct
[    0.002110] Initializing cgroup subsys memory
[    0.002119] Initializing cgroup subsys devices
[    0.002120] Initializing cgroup subsys freezer
[    0.002121] Initializing cgroup subsys net_cls
[    0.002123] Initializing cgroup subsys blkio
[    0.002151] CPU: Physical Processor ID: 0
[    0.002152] CPU: Processor Core ID: 0
[    0.002157] mce: CPU supports 7 MCE banks
[    0.002171] CPU0: Thermal monitoring enabled (TM1)
[    0.002179] using mwait in idle threads.
[    0.003767] ACPI: Core revision 20120320
[    0.011732] ftrace: allocating 17970 entries in 71 pages
[    0.023587] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.056541] CPU0: Intel(R) Core(TM) i7-2677M CPU @ 1.80GHz stepping 07
[    0.162563] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
[    0.162569] PEBS disabled due to CPU errata.
[    0.162571] ... version:                3
[    0.162572] ... bit width:              48
[    0.162573] ... generic registers:      4
[    0.162575] ... value mask:             0000ffffffffffff
[    0.162576] ... max period:             000000007fffffff
[    0.162577] ... fixed-purpose events:   3
[    0.162579] ... event mask:             000000070000000f
[    0.182660] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.195862] Booting Node   0, Processors  #1 #2 #3
[    0.259038] Brought up 4 CPUs
[    0.259042] Total of 4 processors activated (14405.98 BogoMIPS).
[    0.263975] devtmpfs: initialized
[    0.265154] PM: Registering ACPI NVS region [mem 0x8ad34000-0x8ad5efff] (176128 bytes)
[    0.266136] NET: Registered protocol family 16
[    0.266287] ACPI: bus type pci registered
[    0.266362] PCI: MMCONFIG for domain 0000 [bus 00-97] at [mem 0xe0000000-0xe97fffff] (base 0xe0000000)
[    0.266364] PCI: MMCONFIG at [mem 0xe0000000-0xe97fffff] reserved in E820
[    0.287329] PCI: Using configuration type 1 for base access
[    0.287955] bio: create slab <bio-0> at 0
[    0.288016] ACPI: Added _OSI(Module Device)
[    0.288018] ACPI: Added _OSI(Processor Device)
[    0.288020] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.288021] ACPI: Added _OSI(Processor Aggregator Device)
[    0.289516] ACPI: EC: EC description table is found, configuring boot EC
[    0.302054] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.302579] ACPI: SSDT 000000008ad39190 00781 (v01  PmRef  Cpu0Cst 00003001 INTL 20100915)
[    0.302968] ACPI: Dynamic OEM Table Load:
[    0.302971] ACPI: SSDT           (null) 00781 (v01  PmRef  Cpu0Cst 00003001 INTL 20100915)
[    0.303303] ACPI: SSDT 000000008ad3a710 003A4 (v01  PmRef    ApIst 00003000 INTL 20100915)
[    0.303741] ACPI: Dynamic OEM Table Load:
[    0.303744] ACPI: SSDT           (null) 003A4 (v01  PmRef    ApIst 00003000 INTL 20100915)
[    0.303875] ACPI: SSDT 000000008ad38d90 00119 (v01  PmRef    ApCst 00003000 INTL 20100915)
[    0.304255] ACPI: Dynamic OEM Table Load:
[    0.304257] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20100915)
[    0.304819] ACPI: Interpreter enabled
[    0.304823] ACPI: (supports S0 S3 S4 S5)
[    0.304847] ACPI: Using IOAPIC for interrupt routing
[    0.316426] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.316605] ACPI: No dock devices found.
[    0.316608] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.316963] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.317472] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.317475] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.317477] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.317481] pci_root PNP0A08:00: host bridge window [mem 0x8fa00000-0xfeafffff]
[    0.317483] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff]
[    0.317520] PCI host bridge to bus 0000:00
[    0.317523] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.317525] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.317527] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.317529] pci_bus 0000:00: root bus resource [mem 0x8fa00000-0xfeafffff]
[    0.317531] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
[    0.317541] pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
[    0.317585] pci 0000:00:01.0: [8086:0101] type 01 class 0x060400
[    0.317625] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.317652] pci 0000:00:02.0: [8086:0116] type 00 class 0x030000
[    0.317664] pci 0000:00:02.0: reg 10: [mem 0xa0000000-0xa03fffff 64bit]
[    0.317672] pci 0000:00:02.0: reg 18: [mem 0x90000000-0x9fffffff 64bit pref]
[    0.317677] pci 0000:00:02.0: reg 20: [io  0x2000-0x203f]
[    0.317757] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.317783] pci 0000:00:16.0: reg 10: [mem 0xa0607100-0xa060710f 64bit]
[    0.317867] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.317912] pci 0000:00:1a.0: [8086:1c2c] type 00 class 0x0c0300
[    0.317960] pci 0000:00:1a.0: reg 20: [io  0x2140-0x215f]
[    0.318036] pci 0000:00:1a.7: [8086:1c2d] type 00 class 0x0c0320
[    0.318060] pci 0000:00:1a.7: reg 10: [mem 0xa0606c00-0xa0606fff]
[    0.318161] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.318191] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.318209] pci 0000:00:1b.0: reg 10: [mem 0xa0600000-0xa0603fff 64bit]
[    0.318286] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.318318] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.318450] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.318491] pci 0000:00:1c.1: [8086:1c12] type 01 class 0x060400
[    0.318623] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.318671] pci 0000:00:1d.0: [8086:1c27] type 00 class 0x0c0300
[    0.318719] pci 0000:00:1d.0: reg 20: [io  0x20e0-0x20ff]
[    0.318793] pci 0000:00:1d.7: [8086:1c26] type 00 class 0x0c0320
[    0.318817] pci 0000:00:1d.7: reg 10: [mem 0xa0606800-0xa0606bff]
[    0.318918] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.318947] pci 0000:00:1f.0: [8086:1c4d] type 00 class 0x060100
[    0.319090] pci 0000:00:1f.2: [8086:1c01] type 00 class 0x01018f
[    0.319109] pci 0000:00:1f.2: reg 10: [io  0x2168-0x216f]
[    0.319118] pci 0000:00:1f.2: reg 14: [io  0x217c-0x217f]
[    0.319127] pci 0000:00:1f.2: reg 18: [io  0x2160-0x2167]
[    0.319137] pci 0000:00:1f.2: reg 1c: [io  0x2178-0x217b]
[    0.319146] pci 0000:00:1f.2: reg 20: [io  0x2060-0x206f]
[    0.319156] pci 0000:00:1f.2: reg 24: [io  0xffe0-0xffef]
[    0.319211] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    0.319229] pci 0000:00:1f.3: reg 10: [mem 0xa0607000-0xa06070ff 64bit]
[    0.319253] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
[    0.319329] pci 0000:03:00.0: [8086:151a] type 01 class 0x060400
[    0.319393] pci 0000:03:00.0: supports D1 D2
[    0.319395] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.325662] pci 0000:00:01.0: PCI bridge to [bus 03-97]
[    0.325673] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    0.325681] pci 0000:00:01.0:   bridge window [mem 0xa0700000-0xa49fffff]
[    0.325698] pci 0000:00:01.0:   bridge window [mem 0xa4a00000-0xa89fffff 64bit pref]
[    0.325747] pci 0000:04:00.0: [8086:151a] type 01 class 0x060400
[    0.325814] pci 0000:04:00.0: supports D1 D2
[    0.325816] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.325852] pci 0000:04:03.0: [8086:151a] type 01 class 0x060400
[    0.325919] pci 0000:04:03.0: supports D1 D2
[    0.325921] pci 0000:04:03.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.325951] pci 0000:04:04.0: [8086:151a] type 01 class 0x060400
[    0.326018] pci 0000:04:04.0: supports D1 D2
[    0.326020] pci 0000:04:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.326065] pci 0000:03:00.0: PCI bridge to [bus 04-67]
[    0.326072] pci 0000:03:00.0:   bridge window [mem 0xa0700000-0xa09fffff]
[    0.326130] pci 0000:05:00.0: [8086:151a] type 00 class 0x088000
[    0.326146] pci 0000:05:00.0: reg 10: [mem 0xa0700000-0xa073ffff]
[    0.326157] pci 0000:05:00.0: reg 14: [mem 0xa0740000-0xa0740fff]
[    0.326259] pci 0000:05:00.0: supports D1 D2
[    0.326261] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.332319] pci 0000:04:00.0: PCI bridge to [bus 05-05]
[    0.332336] pci 0000:04:00.0:   bridge window [mem 0xa0700000-0xa07fffff]
[    0.332393] pci 0000:04:03.0: PCI bridge to [bus 06-36]
[    0.332401] pci 0000:04:03.0:   bridge window [mem 0xa0800000-0xa08fffff]
[    0.332444] pci 0000:04:04.0: PCI bridge to [bus 37-67]
[    0.332452] pci 0000:04:04.0:   bridge window [mem 0xa0900000-0xa09fffff]
[    0.332546] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.332555] pci 0000:00:1c.0:   bridge window [mem 0xa0500000-0xa05fffff]
[    0.332710] pci 0000:02:00.0: [14e4:4353] type 00 class 0x028000
[    0.332762] pci 0000:02:00.0: reg 10: [mem 0xa0400000-0xa0403fff 64bit]
[    0.333025] pci 0000:02:00.0: supports D1 D2
[    0.333027] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.339025] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.339032] pci 0000:00:1c.1:   bridge window [mem 0xa0400000-0xa04fffff]
[    0.339055] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.339158] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    0.339251] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.339356]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.339489]  pci0000:00: ACPI _OSC control (0x19) granted
[    0.342726] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.342778] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.342828] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.342875] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.342921] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.342970] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.343016] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.343063] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.343156] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.343164] vgaarb: loaded
[    0.343165] vgaarb: bridge control possible 0000:00:02.0
[    0.343199] PCI: Using ACPI for IRQ routing
[    0.347275] PCI: pci_cache_line_size set to 64 bytes
[    0.347392] e820: reserve RAM buffer [mem 0x0008f000-0x0008ffff]
[    0.347394] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.347396] e820: reserve RAM buffer [mem 0x8ad34000-0x8bffffff]
[    0.347398] e820: reserve RAM buffer [mem 0x16fe00000-0x16fffffff]
[    0.347501] NetLabel: Initializing
[    0.347502] NetLabel:  domain hash size = 128
[    0.347503] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.347517] NetLabel:  unlabeled traffic allowed by default
[    0.347540] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.347547] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.349563] Switching to clocksource hpet
[    0.355544] pnp: PnP ACPI init
[    0.355563] ACPI: bus type pnp registered
[    0.355868] pnp 00:00: [bus 00-ff]
[    0.355871] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.355874] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.355876] pnp 00:00: [io  0x0d00-0xffff window]
[    0.355878] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.355880] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.355883] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.355885] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.355887] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.355889] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.355891] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.355893] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.355895] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.355897] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.355899] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.355901] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.355903] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.355905] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.355907] pnp 00:00: [mem 0x8fa00000-0xfeafffff window]
[    0.355909] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.355971] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.356055] pnp 00:01: [io  0x0000-0x001f]
[    0.356057] pnp 00:01: [io  0x0081-0x0091]
[    0.356059] pnp 00:01: [io  0x0093-0x009f]
[    0.356061] pnp 00:01: [io  0x00c0-0x00df]
[    0.356063] pnp 00:01: [dma 4]
[    0.356094] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.356103] pnp 00:02: [mem 0xff000000-0xffffffff]
[    0.356130] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.356207] pnp 00:03: [irq 0 disabled]
[    0.356217] pnp 00:03: [irq 8]
[    0.356219] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.356282] system 00:03: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.356286] system 00:03: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    0.356297] pnp 00:04: [io  0x00f0]
[    0.356303] pnp 00:04: [irq 13]
[    0.356331] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.356341] pnp 00:05: [io  0x002e-0x002f]
[    0.356343] pnp 00:05: [io  0x004e-0x004f]
[    0.356345] pnp 00:05: [io  0x0061]
[    0.356347] pnp 00:05: [io  0x0063]
[    0.356349] pnp 00:05: [io  0x0065]
[    0.356350] pnp 00:05: [io  0x0067]
[    0.356354] pnp 00:05: [io  0x0080]
[    0.356356] pnp 00:05: [io  0x0092]
[    0.356358] pnp 00:05: [io  0x00b2-0x00b3]
[    0.356360] pnp 00:05: [io  0x1000-0x100f]
[    0.356362] pnp 00:05: [io  0x0400-0x047f]
[    0.356363] pnp 00:05: [io  0x0500-0x057f]
[    0.356409] system 00:05: [io  0x1000-0x100f] has been reserved
[    0.356412] system 00:05: [io  0x0400-0x047f] has been reserved
[    0.356414] system 00:05: [io  0x0500-0x057f] has been reserved
[    0.356418] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.356426] pnp 00:06: [io  0x0070-0x0077]
[    0.356454] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.356465] pnp 00:07: [io  0x0300-0x031f]
[    0.356471] pnp 00:07: [irq 6]
[    0.356501] pnp 00:07: Plug and Play ACPI device, IDs APP0001 (active)
[    0.356663] pnp 00:08: [mem 0xfed1c000-0xfed1ffff]
[    0.356665] pnp 00:08: [mem 0xfed10000-0xfed17fff]
[    0.356667] pnp 00:08: [mem 0xfed18000-0xfed18fff]
[    0.356669] pnp 00:08: [mem 0xfed19000-0xfed19fff]
[    0.356671] pnp 00:08: [mem 0xe0000000-0xefffffff]
[    0.356673] pnp 00:08: [mem 0xfed20000-0xfed3ffff]
[    0.356675] pnp 00:08: [mem 0xfed90000-0xfed93fff]
[    0.356676] pnp 00:08: [mem 0xfed45000-0xfed8ffff]
[    0.356678] pnp 00:08: [mem 0xff000000-0xffffffff]
[    0.356680] pnp 00:08: [mem 0xfee00000-0xfeefffff]
[    0.356683] pnp 00:08: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.356734] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.356737] system 00:08: [mem 0xfed10000-0xfed17fff] could not be reserved
[    0.356739] system 00:08: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.356742] system 00:08: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.356744] system 00:08: [mem 0xe0000000-0xefffffff] has been reserved
[    0.356746] system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.356749] system 00:08: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.356751] system 00:08: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.356753] system 00:08: [mem 0xff000000-0xffffffff] could not be reserved
[    0.356756] system 00:08: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.356759] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.362458] pnp 00:09: [mem 0x20000000-0x201fffff]
[    0.362461] pnp 00:09: [mem 0x40000000-0x401fffff]
[    0.362517] system 00:09: [mem 0x20000000-0x201fffff] has been reserved
[    0.362519] system 00:09: [mem 0x40000000-0x401fffff] has been reserved
[    0.362523] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.362532] pnp: PnP ACPI: found 10 devices
[    0.362534] ACPI: ACPI bus type pnp unregistered
[    0.369439] pci 0000:04:00.0: PCI bridge to [bus 05-05]
[    0.369445] pci 0000:04:00.0:   bridge window [mem 0xa0700000-0xa07fffff]
[    0.369453] pci 0000:04:03.0: PCI bridge to [bus 06-36]
[    0.369458] pci 0000:04:03.0:   bridge window [mem 0xa0800000-0xa08fffff]
[    0.369466] pci 0000:04:04.0: PCI bridge to [bus 37-67]
[    0.369471] pci 0000:04:04.0:   bridge window [mem 0xa0900000-0xa09fffff]
[    0.369479] pci 0000:03:00.0: PCI bridge to [bus 04-67]
[    0.369484] pci 0000:03:00.0:   bridge window [mem 0xa0700000-0xa09fffff]
[    0.369491] pci 0000:00:01.0: PCI bridge to [bus 03-97]
[    0.369494] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    0.369497] pci 0000:00:01.0:   bridge window [mem 0xa0700000-0xa49fffff]
[    0.369501] pci 0000:00:01.0:   bridge window [mem 0xa4a00000-0xa89fffff 64bit pref]
[    0.369505] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.369513] pci 0000:00:1c.0:   bridge window [mem 0xa0500000-0xa05fffff]
[    0.369525] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.369532] pci 0000:00:1c.1:   bridge window [mem 0xa0400000-0xa04fffff]
[    0.369577] pci 0000:04:03.0: enabling device (0000 -> 0002)
[    0.369590] pci 0000:04:04.0: enabling device (0000 -> 0002)
[    0.369599] pci 0000:00:1c.0: enabling device (0000 -> 0002)
[    0.369659] pci 0000:00:1c.1: power state changed by ACPI to D0
[    0.369664] pci 0000:00:1c.1: power state changed by ACPI to D0
[    0.369678] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.369680] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.369683] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.369685] pci_bus 0000:00: resource 7 [mem 0x8fa00000-0xfeafffff]
[    0.369687] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
[    0.369689] pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
[    0.369691] pci_bus 0000:03: resource 1 [mem 0xa0700000-0xa49fffff]
[    0.369694] pci_bus 0000:03: resource 2 [mem 0xa4a00000-0xa89fffff 64bit pref]
[    0.369696] pci_bus 0000:04: resource 1 [mem 0xa0700000-0xa09fffff]
[    0.369698] pci_bus 0000:05: resource 1 [mem 0xa0700000-0xa07fffff]
[    0.369700] pci_bus 0000:06: resource 1 [mem 0xa0800000-0xa08fffff]
[    0.369703] pci_bus 0000:37: resource 1 [mem 0xa0900000-0xa09fffff]
[    0.369705] pci_bus 0000:01: resource 1 [mem 0xa0500000-0xa05fffff]
[    0.369707] pci_bus 0000:02: resource 1 [mem 0xa0400000-0xa04fffff]
[    0.369740] NET: Registered protocol family 2
[    0.369867] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.370594] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.372096] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.372250] TCP: Hash tables configured (established 524288 bind 65536)
[    0.372251] TCP: reno registered
[    0.372262] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.372281] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.372365] NET: Registered protocol family 1
[    0.372382] pci 0000:00:02.0: Boot video device
[    0.372801] PCI: CLS 256 bytes, default 64
[    0.372849] Unpacking initramfs...
[    0.452713] Freeing initrd memory: 3536k freed
[    0.453258] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.453263] software IO TLB [mem 0x86d2d000-0x8ad2cfff] (64MB) mapped at [ffff880086d2d000-ffff88008ad2cfff]
[    0.453802] audit: initializing netlink socket (disabled)
[    0.453818] type=2000 audit(1348122629.346:1): initialized
[    0.468351] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.470149] VFS: Disk quotas dquot_6.5.2
[    0.470204] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.470302] msgmni has been set to 7732
[    0.470498] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.470530] io scheduler noop registered
[    0.470532] io scheduler deadline registered
[    0.470583] io scheduler cfq registered (default)
[    0.470697] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.470927] pcieport 0000:03:00.0: irq 41 for MSI/MSI-X
[    0.471037] pcieport 0000:04:00.0: irq 42 for MSI/MSI-X
[    0.471148] pcieport 0000:04:03.0: irq 43 for MSI/MSI-X
[    0.471256] pcieport 0000:04:04.0: irq 44 for MSI/MSI-X
[    0.471420] intel_idle: MWAIT substates: 0x21120
[    0.471421] intel_idle: v0.4 model 0x2A
[    0.471423] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.471459] GHES: HEST is not enabled!
[    0.471507] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.471944] Linux agpgart interface v0.103
[    0.472017] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.472909] i8042: No controller found
[    0.473038] mousedev: PS/2 mouse device common for all mice
[    0.473100] rtc_cmos 00:06: RTC can wake from S4
[    0.473232] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    0.473263] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.473359] cpuidle: using governor ladder
[    0.473483] cpuidle: using governor menu
[    0.473601] drop_monitor: Initializing network drop monitor service
[    0.473677] TCP: cubic registered
[    0.473781] NET: Registered protocol family 10
[    0.473959] NET: Registered protocol family 17
[    0.473968] Key type dns_resolver registered
[    0.474094] PM: Hibernation image not present or could not be loaded.
[    0.474103] registered taskstats version 1
[    0.474851] rtc_cmos 00:06: setting system clock to 2012-09-20 06:30:30 UTC (1348122630)
[    0.476360] Freeing unused kernel memory: 760k freed
[    0.476461] Write protecting the kernel read-only data: 8192k
[    0.481348] Freeing unused kernel memory: 1488k freed
[    0.483580] Freeing unused kernel memory: 612k freed
[    0.492423] systemd-udevd[48]: starting version 189
[    0.524309] ACPI: bus type usb registered
[    0.524369] usbcore: registered new interface driver usbfs
[    0.524418] usbcore: registered new interface driver hub
[    0.524479] usbcore: registered new device driver usb
[    0.525508] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.525570] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    0.525574] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    0.525581] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    0.525614] ehci_hcd 0000:00:1a.7: debug port 2
[    0.526729] SCSI subsystem initialized
[    0.527967] libata version 3.00 loaded.
[    0.529502] ehci_hcd 0000:00:1a.7: cache line size of 256 is not supported
[    0.529522] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xa0606c00
[    0.533206] uhci_hcd: USB Universal Host Controller Interface driver
[    0.539358] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    0.539707] hub 1-0:1.0: USB hub found
[    0.539716] hub 1-0:1.0: 6 ports detected
[    0.539922] ata_piix 0000:00:1f.2: version 2.13
[    0.539943] ata_piix 0000:00:1f.2: MAP [
[    0.539946]  P0 P2 P1 P3 ]
[    0.692530] ata_piix 0000:00:1f.2: setting latency timer to 64
[    0.692883] scsi0 : ata_piix
[    0.692994] scsi1 : ata_piix
[    0.693200] ata1: SATA max UDMA/133 cmd 0x2168 ctl 0x217c bmdma 0x2060 irq 19
[    0.693206] ata2: SATA max UDMA/133 cmd 0x2160 ctl 0x2178 bmdma 0x2068 irq 19
[    0.693284] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.693292] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    0.693304] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 2
[    0.693347] uhci_hcd 0000:00:1a.0: irq 21, io base 0x00002140
[    0.693561] hub 2-0:1.0: USB hub found
[    0.693566] hub 2-0:1.0: 2 ports detected
[    0.693648] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.693652] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.693658] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
[    0.693683] uhci_hcd 0000:00:1d.0: irq 19, io base 0x000020e0
[    0.693822] hub 3-0:1.0: USB hub found
[    0.693825] hub 3-0:1.0: 2 ports detected
[    0.693951] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.693956] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.693962] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
[    0.693993] ehci_hcd 0000:00:1d.7: debug port 2
[    0.697877] ehci_hcd 0000:00:1d.7: cache line size of 256 is not supported
[    0.697892] ehci_hcd 0000:00:1d.7: irq 22, io mem 0xa0606800
[    0.705797] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.706094] hub 4-0:1.0: USB hub found
[    0.706100] hub 4-0:1.0: 8 ports detected
[    0.848929] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    0.972835] hub 1-1:1.0: USB hub found
[    0.973032] hub 1-1:1.0: 3 ports detected
[    1.078566] usb 1-2: new high-speed USB device number 3 using ehci_hcd
[    1.321520] usb 4-1: new high-speed USB device number 2 using ehci_hcd
[    1.445594] hub 4-1:1.0: USB hub found
[    1.445640] hub 4-1:1.0: 2 ports detected
[    1.454630] Refined TSC clocksource calibration: 1800.012 MHz.
[    1.454637] Switching to clocksource tsc
[    1.524736] usb 1-1.1: new full-speed USB device number 4 using ehci_hcd
[    1.623836] hub 1-1.1:1.0: USB hub found
[    1.623987] hub 1-1.1:1.0: 3 ports detected
[    1.704454] usb 1-1.2: new full-speed USB device number 5 using ehci_hcd
[    1.714236] ata2.00: failed to resume link (SControl 0)
[    1.819211] usbcore: registered new interface driver usbhid
[    1.819214] usbhid: USB HID core driver
[    1.820163] input: Apple Inc. Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.0/input/input0
[    1.820234] apple 0003:05AC:024D.0001: input,hidraw0: USB HID v1.11 Keyboard [Apple Inc. Apple Internal Keyboard / Trackpad] on usb-0000:00:1a.7-1.2/input0
[    1.890771] usb 4-1.1: new high-speed USB device number 3 using ehci_hcd
[    1.933176] apple 0003:05AC:024D.0002: hidraw1: USB HID v1.11 Device [Apple Inc. Apple Internal Keyboard / Trackpad] on usb-0000:00:1a.7-1.2/input1
[    1.994191] Initializing USB Mass Storage driver...
[    1.994349] scsi2 : usb-storage 4-1.1:1.0
[    1.994464] usbcore: registered new interface driver usb-storage
[    1.994467] USB Mass Storage support registered.
[    2.033730] ata1.01: failed to resume link (SControl 0)
[    2.057293] usb 1-1.1.1: new full-speed USB device number 6 using ehci_hcd
[    2.145743] input: HID 05ac:820a as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.0/input/input1
[    2.145861] hid-generic 0003:05AC:820A.0003: input,hidraw2: USB HID v1.11 Keyboard [HID 05ac:820a] on usb-0000:00:1a.7-1.1.1/input0
[    2.186894] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.186909] ata1.01: SATA link down (SStatus 0 SControl 0)
[    2.193876] ata1.00: ATA-8: APPLE SSD SM256C, AXM09A1Q, max UDMA/133
[    2.193881] ata1.00: 490234752 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.200486] ata1.00: configured for UDMA/133
[    2.200744] scsi 0:0:0:0: Direct-Access     ATA      APPLE SSD SM256C AXM0 PQ: 0 ANSI: 5
[    2.210429] usb 1-1.1.2: new full-speed USB device number 7 using ehci_hcd
[    2.298120] input: HID 05ac:820b as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.1/1-1.1.2/1-1.1.2:1.0/input/input2
[    2.298300] hid-generic 0003:05AC:820B.0004: input,hidraw3: USB HID v1.11 Mouse [HID 05ac:820b] on usb-0000:00:1a.7-1.1.2/input0
[    2.363433] usb 1-1.1.3: new full-speed USB device number 8 using ehci_hcd
[    2.735939] ata2.01: failed to resume link (SControl 0)
[    2.747529] ata2.00: SATA link down (SStatus 0 SControl 0)
[    2.747545] ata2.01: SATA link down (SStatus 0 SControl 0)
[    2.752474] sd 0:0:0:0: [sda] 490234752 512-byte logical blocks: (251 GB/233 GiB)
[    2.752594] sd 0:0:0:0: [sda] Write Protect is off
[    2.752600] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.752642] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.757174]  sda: sda1 sda2 sda3 sda4 sda5
[    2.757785] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.761191] device-mapper: uevent: version 1.0.3
[    2.761299] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[    3.017890] scsi 2:0:0:0: Direct-Access     APPLE    SD Card Reader   2.00 PQ: 0 ANSI: 0
[    3.020051] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[   15.921360] JFS: nTxBlock = 8192, nTxLock = 65536
[   16.026152] systemd[1]: systemd 189 running in system mode. (+PAM -LIBWRAP -AUDIT -SELINUX -IMA -SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ; arch)
[   16.045154] systemd[1]: Inserted module 'autofs4'
[   16.046367] systemd[1]: Set hostname to <brief>.
[   16.056083] systemd-fstab-generator[165]: Failed to create unit file: File exists
[   16.056181] systemd-fstab-generator[165]: Failed to create unit file: File exists
[   16.056394] systemd[1]: /usr/lib/systemd/system-generators/systemd-fstab-generator exited with exit status 1.
[   16.117792] systemd[1]: Cannot add dependency job for unit display-manager.service, ignoring: Unit display-manager.service failed to load: No such file or directory. See system logs and 'systemctl status display-manager.service' for details.
[   16.192383] FS-Cache: Loaded
[   16.199685] RPC: Registered named UNIX socket transport module.
[   16.199688] RPC: Registered udp transport module.
[   16.199689] RPC: Registered tcp transport module.
[   16.199691] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   16.231737] systemd-udevd[182]: starting version 189
[   16.245420] NFS: Registering the id_resolver key type
[   16.245429] Key type id_resolver registered
[   16.245431] Key type id_legacy registered
[   16.245438] FS-Cache: Netfs 'nfs' registered for caching
[   16.299607] systemd-journald[188]: Successfully opened /dev/kmsg for logging.
[   16.308995] systemd-journald[188]: Fixed max_use=193.4M max_size=24.1M min_size=64.0K keep_free=96.7M
[   16.309039] systemd-journald[188]: Reserving 44024 entries in hash table.
[   16.309627] systemd-journald[188]: Vacuuming...
[   16.309658] systemd-journald[188]: Flushing /dev/kmsg...
[   16.341159] systemd-journald[188]: systemd-journald running as pid 188
[   16.439631] mei 0000:00:16.0: setting latency timer to 64
[   16.439752] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[   16.442688] ACPI: AC Adapter [ADP1] (on-line)
[   16.446874] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input3
[   16.446916] ACPI: Lid Switch [LID0]
[   16.446994] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input4
[   16.447000] ACPI: Power Button [PWRB]
[   16.448444] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input5
[   16.448450] ACPI: Sleep Button [SLPB]
[   16.448534] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input6
[   16.448539] ACPI: Power Button [PWRF]
[   16.449162] mei 0000:00:16.0: wd: failed to find the client
[   16.456453] bcma: Found chip with id 0xA8D8, rev 0x01 and package 0x08
[   16.456489] bcma: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x22, class 0x0)
[   16.456517] bcma: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x17, class 0x0)
[   16.456607] bcma: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x0F, class 0x0)
[   16.464628] ACPI: Requesting acpi_cpufreq
[   16.521864] bcma: Bus registered
[   16.539871] input: PC Speaker as /devices/platform/pcspkr/input/input7
[   16.568271] [drm] Initialized drm 1.1.0 20060810
[   16.568316] microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x1a
[   16.599825] ACPI: Battery Slot [BAT0] (battery present)
[   16.609490] ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \PMIO 1 (20120320/utaddress-251)
[   16.609500] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   16.609504] ACPI Warning: 0x0000000000000500-0x000000000000057f SystemIO conflicts with Region \GPIO 1 (20120320/utaddress-251)
[   16.609509] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   16.609511] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   16.610348] ACPI Warning: 0x000000000000efa0-0x000000000000efbf SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20120320/utaddress-251)
[   16.610355] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   16.610647] agpgart-intel 0000:00:00.0: Intel Sandybridge Chipset
[   16.610771] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[   16.612385] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
[   16.612519] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x90000000
[   16.633174] iTCO_vendor_support: vendor-support=0
[   16.635151] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
[   16.635195] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
[   16.646032] microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x1a
[   16.647600] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input8
[   16.647721] usbcore: registered new interface driver bcm5974
[   16.648263] microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x1a
[   16.652059] microcode: CPU3 sig=0x206a7, pf=0x10, revision=0x1a
[   16.654396] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   16.671950] cfg80211: Calling CRDA to update world regulatory domain
[   16.674693] Linux media interface: v0.10
[   16.675642] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[   16.689089] Linux video capture interface: v2.00
[   16.700023] applesmc: : read arg fail
[   16.702836] Bluetooth: Core ver 2.16
[   16.702852] NET: Registered protocol family 31
[   16.702854] Bluetooth: HCI device and connection manager initialized
[   16.702856] Bluetooth: HCI socket layer initialized
[   16.702858] Bluetooth: L2CAP socket layer initialized
[   16.702862] Bluetooth: SCO socket layer initialized
[   16.724775] usbcore: registered new interface driver btusb
[   16.756113] brcmsmac bcma0:0: mfg 4bf core 812 rev 23 class 0 irq 17
[   16.758347] uvcvideo: Found UVC 1.00 device FaceTime Camera (Built-in) (05ac:850a)
[   16.763657] usb 1-1.1.1: USB disconnect, device number 6
[   16.765126] input: FaceTime Camera (Built-in) as /devices/pci0000:00/0000:00:1a.7/usb1/1-2/1-2:1.0/input/input9
[   16.771097] applesmc: key=349 fan=1 temp=25 acc=0 lux=2 kbd=1
[   16.771100] applesmc: init_smcreg() took 50 ms
[   16.771202] Registered led device: smc::kbd_backlight
[   16.777481] usbcore: registered new interface driver uvcvideo
[   16.777484] USB Video Class driver (1.1.1)
[   16.876129] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[   16.904188] usb 1-1.1.2: USB disconnect, device number 7
[   16.964343] EXT4-fs (sda4): mounted filesystem with ordered data mode. Opts: (null)
[   16.991091] systemd-journald[188]: Received SIGUSR1
[   17.251617] input: HDA Intel PCH HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   17.251723] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   17.251803] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   17.251869] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[   17.253191] i915 0000:00:02.0: setting latency timer to 64
[   17.285031] i915 0000:00:02.0: irq 47 for MSI/MSI-X
[   17.285041] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   17.285042] [drm] Driver supports precise vblank timestamp query.
[   17.285104] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   18.490259] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[   19.323492] fbcon: inteldrmfb (fb0) is primary device
[   20.172440] Console: switching to colour frame buffer device 180x56
[   20.175279] fb0: inteldrmfb frame buffer device
[   20.175280] drm: registered panic notifier
[   20.197799] acpi device:0d: registered as cooling_device4
[   20.198199] ACPI: Video Device [IGPU] (multi-head: yes  rom: no  post: no)
[   20.198541] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input14
[   20.199173] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[  138.927171] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[  138.927183] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[  138.928415] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  141.132750] wlan0: authenticate with d4:a0:2a:98:a6:a0
[  141.132798] wlan0: direct probe to d4:a0:2a:98:a6:a0 (try 1/3)
[  141.333294] wlan0: direct probe to d4:a0:2a:98:a6:a0 (try 2/3)
[  141.536261] wlan0: direct probe to d4:a0:2a:98:a6:a0 (try 3/3)
[  141.739321] wlan0: authentication with d4:a0:2a:98:a6:a0 timed out
[  154.097609] wlan0: authenticate with d4:a0:2a:98:a6:a0
[  154.097650] wlan0: send auth to d4:a0:2a:98:a6:a0 (try 1/3)
[  154.099206] wlan0: authenticated
[  154.100031] wlan0: associate with d4:a0:2a:98:a6:a0 (try 1/3)
[  154.104005] wlan0: RX AssocResp from d4:a0:2a:98:a6:a0 (capab=0x431 status=0 aid=1)
[  154.104514] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[  154.104525] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[  154.104529] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[  154.105270] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  154.105403] wlan0: associated
[  160.924326] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[  174.043984] wlan0: deauthenticated from d4:a0:2a:98:a6:a0 (Reason: 2)
[  174.065744] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[  174.065764] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[  174.065769] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[  174.068994] cfg80211: Calling CRDA for country: CH
[  176.086459] wlan0: authenticate with d4:a0:2a:9a:f6:ef
[  176.086486] wlan0: send auth to d4:a0:2a:9a:f6:ef (try 1/3)
[  176.288817] wlan0: send auth to d4:a0:2a:9a:f6:ef (try 2/3)
[  176.289534] wlan0: authenticated
[  176.292173] wlan0: associate with d4:a0:2a:9a:f6:ef (try 1/3)
[  176.294102] wlan0: RX AssocResp from d4:a0:2a:9a:f6:ef (capab=0x11 status=0 aid=38)
[  176.294612] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[  176.294622] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[  176.294627] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[  176.295486] wlan0: associated
[  181.740040] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[  463.528605] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[  484.550031] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[  484.551729] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[  484.555248] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[  950.376686] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[  950.383424] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[  950.384098] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[ 1437.233440] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[ 2735.539673] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[ 3956.820759] usb 4-1.2: new high-speed USB device number 4 using ehci_hcd
[ 3956.990648] scsi3 : usb-storage 4-1.2:1.0
[ 3964.565530] scsi 3:0:0:0: Direct-Access     Samsung  STORY Station 3  1AJ1 PQ: 0 ANSI: 0
[ 3964.566485] sd 3:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[ 3964.567218] sd 3:0:0:0: [sdc] Write Protect is off
[ 3964.567231] sd 3:0:0:0: [sdc] Mode Sense: 23 00 00 00
[ 3964.567965] sd 3:0:0:0: [sdc] No Caching mode page present
[ 3964.567975] sd 3:0:0:0: [sdc] Assuming drive cache: write through
[ 3964.570467] sd 3:0:0:0: [sdc] No Caching mode page present
[ 3964.570479] sd 3:0:0:0: [sdc] Assuming drive cache: write through
[ 3964.606730]  sdc: sdc1 sdc2 sdc3 sdc4
[ 3964.609774] sd 3:0:0:0: [sdc] No Caching mode page present
[ 3964.609785] sd 3:0:0:0: [sdc] Assuming drive cache: write through
[ 3964.609791] sd 3:0:0:0: [sdc] Attached SCSI disk
[ 4196.117163] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[ 4196.129688] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[ 4892.354095] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[ 5054.643739] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[ 5866.094944] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[ 5981.289754] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[ 5981.290989] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[ 5981.291085] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[ 8441.631408] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[ 8509.747746] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[ 8509.759728] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[ 8509.759792] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[ 8509.762529] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[ 8509.764337] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[ 8603.911583] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[ 8719.114206] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[ 8719.120270] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[ 9090.786140] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[ 9253.062233] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[ 9253.064584] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[ 9253.064764] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[ 9253.068891] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[ 9253.070820] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[ 9253.099880] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[ 9577.642941] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[ 9739.932997] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[ 9996.423365] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[ 9996.424658] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[10064.497432] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[11849.694115] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[13472.529648] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[14608.537694] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[16765.348616] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[16765.357496] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[17327.476757] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[17327.476773] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[17327.476779] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[17327.483402] cfg80211: Calling CRDA to update world regulatory domain
[17329.493885] wlan0: authenticate with d4:a0:2a:9a:f6:ef
[17329.495350] wlan0: send auth to d4:a0:2a:9a:f6:ef (try 1/3)
[17329.501599] wlan0: authenticated
[17329.503477] wlan0: associate with d4:a0:2a:9a:f6:ef (try 1/3)
[17329.505123] wlan0: RX AssocResp from d4:a0:2a:9a:f6:ef (capab=0x11 status=0 aid=38)
[17329.505598] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[17329.505602] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[17329.505604] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[17329.505610] wlan0: associated
[17335.035704] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[17336.572526] ------------[ cut here ]------------
[17336.572558] WARNING: at drivers/net/wireless/brcm80211/brcmsmac/main.c:7968 brcms_c_wait_for_tx_completion+0x99/0xb0 [brcmsmac]()
[17336.572562] Hardware name: MacBookAir4,2
[17336.572565] Modules linked in: sha256_generic snd_hda_codec_hdmi snd_hda_codec_cirrus ext4 jbd2 mbcache arc4 uvcvideo brcmsmac videobuf2_vmalloc videobuf2_memops cordic brcmutil btusb bluetooth i915 videobuf2_core mac80211 videodev crc16 acpi_cpufreq snd_hda_intel media i2c_algo_bit cfg80211 mperf drm_kms_helper snd_hda_codec rfkill joydev bcm5974 iTCO_wdt iTCO_vendor_support i2c_i801 intel_agp lpc_ich applesmc evdev microcode drm coretemp input_polldev pcspkr intel_gtt mfd_core i2c_core processor bcma snd_hwdep video button battery apple_bl mei ac snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_timer snd soundcore kvm_intel kvm nfs nfs_acl lockd auth_rpcgss sunrpc fscache autofs4 jfs xts gf128mul dm_crypt dm_mod sd_mod pata_acpi ata_generic hid_generic usb_storage hid_apple usbhid hid uhci_hcd aesni_intel aes_x86_64 aes_generic ghash_clmulni_intel cryptd crc32c_intel ata_piix libata scsi_mod ehci_hcd usbcore usb_common
[17336.572716] Pid: 27714, comm: kworker/u:1 Not tainted 3.5.4-1-ARCH #1
[17336.572719] Call Trace:
[17336.572734]  [<ffffffff81051a3f>] warn_slowpath_common+0x7f/0xc0
[17336.572743]  [<ffffffff81051a9a>] warn_slowpath_null+0x1a/0x20
[17336.572759]  [<ffffffffa063bd29>] brcms_c_wait_for_tx_completion+0x99/0xb0 [brcmsmac]
[17336.572769]  [<ffffffffa062e1bb>] brcms_ops_flush+0x3b/0x60 [brcmsmac]
[17336.572792]  [<ffffffffa04a2f69>] ieee80211_mgd_probe_ap_send+0xc9/0x230 [mac80211]
[17336.572809]  [<ffffffffa04a374f>] ieee80211_mgd_probe_ap.part.22+0x10f/0x130 [mac80211]
[17336.572823]  [<ffffffffa04a381d>] ieee80211_beacon_connection_loss_work+0xad/0x160 [mac80211]
[17336.572833]  [<ffffffff8106effa>] process_one_work+0x12a/0x440
[17336.572848]  [<ffffffffa04a3770>] ? ieee80211_mgd_probe_ap.part.22+0x130/0x130 [mac80211]
[17336.572857]  [<ffffffff8106f85e>] worker_thread+0x12e/0x2d0
[17336.572865]  [<ffffffff8106f730>] ? manage_workers.isra.26+0x1f0/0x1f0
[17336.572872]  [<ffffffff81074f73>] kthread+0x93/0xa0
[17336.572880]  [<ffffffff81486864>] kernel_thread_helper+0x4/0x10
[17336.572888]  [<ffffffff81074ee0>] ? kthread_freezable_should_stop+0x70/0x70
[17336.572894]  [<ffffffff81486860>] ? gs_change+0x13/0x13
[17336.572898] ---[ end trace 87315886d62eca54 ]---
[17336.599011] systemd-journald[188]: Compressed data object 934 -> 636
[17644.911257] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[17644.945232] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[17714.546558] usb 4-1.2: USB disconnect, device number 4
[19152.588854] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[19267.786857] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[19267.789203] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[19267.789401] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36

--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg2

[20613.179842] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[22398.337844] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[23559.757889] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[23559.757908] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[23559.757913] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23559.760894] cfg80211: Calling CRDA to update world regulatory domain
[23561.705197] wlan0: authenticate with d4:a0:2a:9a:fa:4f
[23561.706460] wlan0: send auth to d4:a0:2a:9a:fa:4f (try 1/3)
[23561.707138] wlan0: authenticated
[23561.707754] wlan0: associate with d4:a0:2a:9a:fa:4f (try 1/3)
[23561.709593] wlan0: RX AssocResp from d4:a0:2a:9a:fa:4f (capab=0x11 status=0 aid=3)
[23561.710096] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[23561.710105] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[23561.710110] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[23561.710881] wlan0: associated
[23566.740292] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[23577.979353] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[23577.979373] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[23577.979378] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23577.982489] cfg80211: Calling CRDA for country: CH
[23579.928161] wlan0: authenticate with d4:a0:2a:9a:c1:ef
[23579.928202] wlan0: send auth to d4:a0:2a:9a:c1:ef (try 1/3)
[23579.930025] wlan0: authenticated
[23579.932725] wlan0: associate with d4:a0:2a:9a:c1:ef (try 1/3)
[23579.935503] wlan0: RX AssocResp from d4:a0:2a:9a:c1:ef (capab=0x11 status=0 aid=18)
[23579.936076] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[23579.936086] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[23579.936095] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[23579.936884] wlan0: associated
[23584.941146] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[23738.482423] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[23738.482444] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[23738.482450] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23738.485604] cfg80211: Calling CRDA to update world regulatory domain
[23740.433015] wlan0: authenticate with d4:a0:2a:98:ab:7f
[23740.433084] wlan0: send auth to d4:a0:2a:98:ab:7f (try 1/3)
[23740.433740] wlan0: authenticated
[23740.435876] wlan0: associate with d4:a0:2a:98:ab:7f (try 1/3)
[23740.437730] wlan0: RX AssocResp from d4:a0:2a:98:ab:7f (capab=0x11 status=0 aid=11)
[23740.438234] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[23740.438244] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[23740.438248] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[23740.439029] wlan0: associated
[23744.986858] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[24200.728742] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[24200.728762] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[24200.728767] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[24200.731965] cfg80211: Calling CRDA for country: CH
[24202.679740] wlan0: authenticate with d4:a0:2a:9a:f6:ef
[24202.679775] wlan0: send auth to d4:a0:2a:9a:f6:ef (try 1/3)
[24202.680434] wlan0: authenticated
[24202.682165] wlan0: associate with d4:a0:2a:9a:f6:ef (try 1/3)
[24202.683982] wlan0: RX AssocResp from d4:a0:2a:9a:f6:ef (capab=0x11 status=0 aid=70)
[24202.684490] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[24202.684499] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[24202.684504] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[24202.685286] wlan0: associated
[24206.935003] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[26109.891711] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[26109.895289] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[26109.895487] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[26109.895523] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[26947.473770] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[26947.473829] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[26947.473975] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[26947.474040] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[29877.691131] CPU1: Core temperature above threshold, cpu clock throttled (total events = 1)
[29877.691132] CPU3: Core temperature above threshold, cpu clock throttled (total events = 1)
[29877.691135] CPU2: Package temperature above threshold, cpu clock throttled (total events = 1)
[29877.691136] CPU0: Package temperature above threshold, cpu clock throttled (total events = 1)
[29877.691137] CPU3: Package temperature above threshold, cpu clock throttled (total events = 1)
[29877.691145] CPU1: Package temperature above threshold, cpu clock throttled (total events = 1)
[29877.692103] CPU3: Core temperature/speed normal
[29877.692105] CPU1: Core temperature/speed normal
[29877.692106] CPU2: Package temperature/speed normal
[29877.692107] CPU1: Package temperature/speed normal
[29877.692110] CPU0: Package temperature/speed normal
[29877.692114] CPU3: Package temperature/speed normal
[29953.742873] [Hardware Error]: Machine check events logged
[30423.529052] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 36
[30810.697517] EXT4-fs (sda4): re-mounted. Opts: commit=0
[30811.513141] PM: Syncing filesystems ... done.
[30811.552715] PM: Preparing system for mem sleep
[30814.397565] Freezing user space processes ... (elapsed 0.01 seconds) done.
[30814.411693] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[30814.425049] PM: Entering mem sleep
[30814.425070] Suspending console(s) (use no_console_suspend to debug)
[30814.433559] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[30814.433694] sd 0:0:0:0: [sda] Stopping disk
[30815.879404] PM: suspend of devices complete after 1456.427 msecs
[30815.879571] PM: late suspend of devices complete after 0.164 msecs
[30815.892827] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[30815.906054] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[30815.932682] PM: noirq suspend of devices complete after 53.177 msecs
[30815.932925] ACPI: Preparing to enter system sleep state S3
[30815.959320] PM: Saving platform NVS memory
[30815.959603] Disabling non-boot CPUs ...
[30816.062419] CPU 1 is now offline
[30816.165584] CPU 2 is now offline
[30816.268745] CPU 3 is now offline
[30816.269122] Extended CMOS year: 2000
[30816.270573] ACPI: Low-level resume complete
[30816.270614] PM: Restoring platform NVS memory
[30816.270929] Extended CMOS year: 2000
[30816.270969] Enabling non-boot CPUs ...
[30816.277792] Booting Node 0 Processor 1 APIC 0x2
[30816.292741] CPU1 is up
[30816.300082] Booting Node 0 Processor 2 APIC 0x1
[30816.314179] CPU2 is up
[30816.314542] Booting Node 0 Processor 3 APIC 0x3
[30816.329361] CPU3 is up
[30816.334317] ACPI: Waking up from system sleep state S3
[30816.819981] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[30816.820265] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[30816.820905] PM: noirq resume of devices complete after 1.140 msecs
[30816.821017] PM: early resume of devices complete after 0.089 msecs
[30816.821090] i915 0000:00:02.0: setting latency timer to 64
[30816.821100] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[30816.821108] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[30816.821138] usb usb2: root hub lost power or was reset
[30816.821153] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[30816.821163] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[30816.821199] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[30816.821202] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[30816.821203] usb usb3: root hub lost power or was reset
[30816.821238] ata_piix 0000:00:1f.2: setting latency timer to 64
[30816.821963] mei 0000:00:16.0: wd: failed to find the client
[30816.862074] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[30816.942205] Extended CMOS year: 2000
[30817.841469] ata2.00: failed to resume link (SControl 0)
[30818.160966] ata1.01: failed to resume link (SControl 0)
[30818.314136] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[30818.314147] ata1.01: SATA link down (SStatus 0 SControl 0)
[30818.320969] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[30818.327774] ata1.00: configured for UDMA/133
[30818.362254] sd 0:0:0:0: [sda] Starting disk
[30818.863221] ata2.01: failed to resume link (SControl 0)
[30818.874742] ata2.00: SATA link down (SStatus 4 SControl 0)
[30818.874763] ata2.01: SATA link down (SStatus 0 SControl 0)
[30818.891119] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[30818.892112] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[30818.892114] ieee80211 phy0: changing basic rates failed: -22
[30818.892116] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: threshold 0, hys 0  (implement)
[30818.892117] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[30818.892117] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[30818.892291] PM: resume of devices complete after 2074.501 msecs
[30818.892667] PM: Finishing wakeup.
[30818.892668] Restarting tasks ... done.
[30818.927907] video LNXVIDEO:00: Restoring backlight state
[30821.472476] EXT4-fs (sda4): re-mounted. Opts: commit=0
[30833.182266] EXT4-fs (sda4): re-mounted. Opts: commit=0
[30833.634002] PM: Syncing filesystems ... done.
[30833.653412] PM: Preparing system for mem sleep
[30834.504706] Freezing user space processes ... (elapsed 0.01 seconds) done.
[30834.515487] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[30834.528882] PM: Entering mem sleep
[30834.528904] Suspending console(s) (use no_console_suspend to debug)
[30834.531151] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[30834.532417] sd 0:0:0:0: [sda] Stopping disk
[30836.179572] PM: suspend of devices complete after 1653.067 msecs
[30836.179738] PM: late suspend of devices complete after 0.164 msecs
[30836.193136] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[30836.206347] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[30836.232861] PM: noirq suspend of devices complete after 53.187 msecs
[30836.233105] ACPI: Preparing to enter system sleep state S3
[30836.259497] PM: Saving platform NVS memory
[30836.259772] Disabling non-boot CPUs ...
[30836.362600] CPU 1 is now offline
[30836.469074] CPU 2 is now offline
[30836.575580] CPU 3 is now offline
[30836.575905] Extended CMOS year: 2000
[30836.577360] ACPI: Low-level resume complete
[30836.577401] PM: Restoring platform NVS memory
[30836.577717] Extended CMOS year: 2000
[30836.577758] Enabling non-boot CPUs ...
[30836.584617] Booting Node 0 Processor 1 APIC 0x2
[30836.599595] CPU1 is up
[30836.607024] Booting Node 0 Processor 2 APIC 0x1
[30836.621194] CPU2 is up
[30836.621634] Booting Node 0 Processor 3 APIC 0x3
[30836.636601] CPU3 is up
[30836.641586] ACPI: Waking up from system sleep state S3
[30837.143462] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[30837.143746] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[30837.144386] PM: noirq resume of devices complete after 1.141 msecs
[30837.144500] PM: early resume of devices complete after 0.087 msecs
[30837.144528] i915 0000:00:02.0: setting latency timer to 64
[30837.144590] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[30837.144636] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[30837.144641] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[30837.144667] usb usb2: root hub lost power or was reset
[30837.144692] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[30837.144705] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[30837.144719] usb usb3: root hub lost power or was reset
[30837.144740] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[30837.144772] ata_piix 0000:00:1f.2: setting latency timer to 64
[30837.145364] mei 0000:00:16.0: wd: failed to find the client
[30837.186321] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[30838.164874] ata2.00: failed to resume link (SControl 0)
[30838.484454] ata1.01: failed to resume link (SControl 0)
[30838.637627] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[30838.637638] ata1.01: SATA link down (SStatus 0 SControl 0)
[30838.644459] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[30838.651223] ata1.00: configured for UDMA/133
[30838.684931] sd 0:0:0:0: [sda] Starting disk
[30839.186707] ata2.01: failed to resume link (SControl 0)
[30839.198210] ata2.00: SATA link down (SStatus 4 SControl 0)
[30839.198224] ata2.01: SATA link down (SStatus 0 SControl 0)
[30839.214634] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[30839.215629] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[30839.215631] ieee80211 phy0: changing basic rates failed: -22
[30839.215632] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: threshold 0, hys 0  (implement)
[30839.215633] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[30839.215634] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[30839.215914] PM: resume of devices complete after 2074.641 msecs
[30839.216280] PM: Finishing wakeup.
[30839.216281] Restarting tasks ... done.
[30839.251553] video LNXVIDEO:00: Restoring backlight state
[30839.273157] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[30839.273166] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[30839.273169] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[30839.304083] cfg80211: Calling CRDA to update world regulatory domain
[30841.010180] EXT4-fs (sda4): re-mounted. Opts: commit=600
[30842.291830] wlan0: authenticate with 00:0c:42:0c:93:6f
[30842.291843] ieee80211 phy0: changing basic rates failed: -52
[30842.291851] wlan0: direct probe to 00:0c:42:0c:93:6f (try 1/3)
[30842.494804] wlan0: direct probe to 00:0c:42:0c:93:6f (try 2/3)
[30842.697815] wlan0: direct probe to 00:0c:42:0c:93:6f (try 3/3)
[30842.900842] wlan0: authentication with 00:0c:42:0c:93:6f timed out
[30855.124547] wlan0: authenticate with 00:0c:42:1f:2d:14
[30855.124632] ieee80211 phy0: changing basic rates failed: -52
[30855.124649] wlan0: direct probe to 00:0c:42:1f:2d:14 (try 1/3)
[30855.324851] wlan0: direct probe to 00:0c:42:1f:2d:14 (try 2/3)
[30855.527867] wlan0: direct probe to 00:0c:42:1f:2d:14 (try 3/3)
[30855.730887] wlan0: authentication with 00:0c:42:1f:2d:14 timed out
[30867.960827] wlan0: authenticate with 00:0c:42:0c:93:6f
[30867.960858] ieee80211 phy0: changing basic rates failed: -52
[30867.960874] wlan0: direct probe to 00:0c:42:0c:93:6f (try 1/3)
[30868.161513] wlan0: direct probe to 00:0c:42:0c:93:6f (try 2/3)
[30868.364528] wlan0: direct probe to 00:0c:42:0c:93:6f (try 3/3)
[30868.567506] wlan0: authentication with 00:0c:42:0c:93:6f timed out
[30880.800747] wlan0: authenticate with 00:0c:42:1f:2d:14
[30880.800785] ieee80211 phy0: changing basic rates failed: -52
[30880.800809] wlan0: direct probe to 00:0c:42:1f:2d:14 (try 1/3)
[30881.001507] wlan0: direct probe to 00:0c:42:1f:2d:14 (try 2/3)
[30881.204519] wlan0: direct probe to 00:0c:42:1f:2d:14 (try 3/3)
[30881.407534] wlan0: authentication with 00:0c:42:1f:2d:14 timed out

--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg3-start-backup

[30893.633964] wlan0: authenticate with 00:19:cb:23:ab:33
[30893.633993] ieee80211 phy0: changing basic rates failed: -52
[30893.634010] wlan0: send auth to 00:19:cb:23:ab:33 (try 1/3)
[30893.635488] wlan0: authenticated
[30893.638531] wlan0: associate with 00:19:cb:23:ab:33 (try 1/3)
[30893.642467] wlan0: RX AssocResp from 00:19:cb:23:ab:33 (capab=0x421 status=0 aid=1)
[30893.643357] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[30893.643366] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[30893.643371] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[30893.643384] wlan0: associated
[30901.459631] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[31331.730169] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[31331.730189] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[31331.730197] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[31331.730768] cfg80211: Calling CRDA to update world regulatory domain
[31333.678442] wlan0: authenticate with 00:02:2d:5f:89:94
[31333.678469] ieee80211 phy0: changing basic rates failed: -52
[31333.678477] wlan0: send auth to 00:02:2d:5f:89:94 (try 1/3)
[31333.680459] wlan0: authenticated
[31333.682741] wlan0: associate with 00:02:2d:5f:89:94 (try 1/3)
[31333.684445] wlan0: RX AssocResp from 00:02:2d:5f:89:94 (capab=0x1 status=0 aid=1)
[31333.684942] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[31333.684945] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[31333.684947] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[31333.685183] wlan0: associated
[32239.387034] wlan0: deauthenticating from 00:02:2d:5f:89:94 by local choice (reason=3)
[32239.407866] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[32239.407887] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[32239.407896] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[32239.408577] cfg80211: Calling CRDA for country: CH
[32239.411416] wlan0: authenticate with 00:19:cb:23:ab:33
[32239.411443] ieee80211 phy0: changing basic rates failed: -52
[32239.411459] wlan0: send auth to 00:19:cb:23:ab:33 (try 1/3)
[32239.412992] wlan0: authenticated
[32239.414516] wlan0: associate with 00:19:cb:23:ab:33 (try 1/3)
[32239.417958] wlan0: RX AssocResp from 00:19:cb:23:ab:33 (capab=0x421 status=0 aid=1)
[32239.418846] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[32239.418854] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[32239.418859] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[32239.419638] wlan0: associated
[32248.143189] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[32399.073384] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[32399.073405] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[32399.073413] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[32399.073981] cfg80211: Calling CRDA to update world regulatory domain
[32401.021508] wlan0: authenticate with 00:02:2d:5f:89:94
[32401.021544] ieee80211 phy0: changing basic rates failed: -52
[32401.021567] wlan0: send auth to 00:02:2d:5f:89:94 (try 1/3)
[32401.023048] wlan0: authenticated
[32401.026054] wlan0: associate with 00:02:2d:5f:89:94 (try 1/3)
[32401.031098] wlan0: RX AssocResp from 00:02:2d:5f:89:94 (capab=0x1 status=0 aid=1)
[32401.031719] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[32401.031727] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[32401.031732] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[32401.031745] wlan0: associated
[32421.454035] wlan0: deauthenticating from 00:02:2d:5f:89:94 by local choice (reason=3)
[32421.473134] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[32421.473141] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[32421.473142] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[32421.473796] cfg80211: Calling CRDA to update world regulatory domain
[32421.476247] wlan0: authenticate with 00:19:cb:23:ab:33
[32421.476259] ieee80211 phy0: changing basic rates failed: -52
[32421.476266] wlan0: send auth to 00:19:cb:23:ab:33 (try 1/3)
[32421.477801] wlan0: authenticated
[32421.480815] wlan0: associate with 00:19:cb:23:ab:33 (try 1/3)
[32421.482697] wlan0: RX AssocResp from 00:19:cb:23:ab:33 (capab=0x421 status=0 aid=4)
[32421.483799] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[32421.483811] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[32421.483816] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[32421.485078] wlan0: associated
[32426.266316] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[32889.773230] EXT4-fs (sda4): re-mounted. Opts: commit=0
[32890.085873] PM: Syncing filesystems ... done.
[32890.097273] PM: Preparing system for mem sleep
[32890.692226] Freezing user space processes ... (elapsed 0.01 seconds) done.
[32890.706235] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[32890.719642] PM: Entering mem sleep
[32890.719663] Suspending console(s) (use no_console_suspend to debug)
[32890.721864] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[32890.723109] sd 0:0:0:0: [sda] Stopping disk
[32892.373721] PM: suspend of devices complete after 1656.416 msecs
[32892.373886] PM: late suspend of devices complete after 0.163 msecs
[32892.387247] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[32892.400463] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[32892.426957] PM: noirq suspend of devices complete after 53.161 msecs
[32892.427201] ACPI: Preparing to enter system sleep state S3
[32892.453577] PM: Saving platform NVS memory
[32892.453867] Disabling non-boot CPUs ...
[32892.556688] CPU 1 is now offline
[32892.659834] CPU 2 is now offline
[32892.766321] CPU 3 is now offline
[32892.766647] Extended CMOS year: 2000
[32892.768105] ACPI: Low-level resume complete
[32892.768146] PM: Restoring platform NVS memory
[32892.768461] Extended CMOS year: 2000
[32892.768502] Enabling non-boot CPUs ...
[32892.775381] Booting Node 0 Processor 1 APIC 0x2
[32892.790424] CPU1 is up
[32892.797842] Booting Node 0 Processor 2 APIC 0x1
[32892.812538] CPU2 is up
[32892.812719] Booting Node 0 Processor 3 APIC 0x3
[32892.827514] CPU3 is up
[32892.832443] ACPI: Waking up from system sleep state S3
[32893.334202] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[32893.334486] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[32893.335132] PM: noirq resume of devices complete after 1.147 msecs
[32893.335245] PM: early resume of devices complete after 0.088 msecs
[32893.335274] i915 0000:00:02.0: setting latency timer to 64
[32893.335337] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[32893.335385] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[32893.335409] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[32893.335418] usb usb2: root hub lost power or was reset
[32893.335448] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[32893.335449] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[32893.335475] usb usb3: root hub lost power or was reset
[32893.335481] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[32893.335482] ata_piix 0000:00:1f.2: setting latency timer to 64
[32893.336304] mei 0000:00:16.0: wd: failed to find the client
[32893.378968] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[32893.942429] Extended CMOS year: 2000
[32894.355727] ata2.00: failed to resume link (SControl 0)
[32894.675202] ata1.01: failed to resume link (SControl 0)
[32894.828367] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[32894.828378] ata1.01: SATA link down (SStatus 0 SControl 0)
[32894.835199] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[32894.841961] ata1.00: configured for UDMA/133
[32894.876247] sd 0:0:0:0: [sda] Starting disk
[32895.377453] ata2.01: failed to resume link (SControl 0)
[32895.388936] ata2.00: SATA link down (SStatus 4 SControl 0)
[32895.388957] ata2.01: SATA link down (SStatus 0 SControl 0)
[32895.405510] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[32895.406500] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[32895.406502] ieee80211 phy0: changing basic rates failed: -22
[32895.406503] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: threshold 0, hys 0  (implement)
[32895.406504] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[32895.406505] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[32895.406607] PM: resume of devices complete after 2074.588 msecs
[32895.406972] PM: Finishing wakeup.
[32895.406973] Restarting tasks ... done.
[32895.429724] video LNXVIDEO:00: Restoring backlight state
[32895.477211] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[32895.477219] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[32895.477221] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[32895.477968] cfg80211: Calling CRDA to update world regulatory domain
[32896.706562] EXT4-fs (sda4): re-mounted. Opts: commit=600
[32897.411728] wlan0: authenticate with c8:6c:87:a9:df:a9
[32897.421524] wlan0: send auth to c8:6c:87:a9:df:a9 (try 1/3)
[32897.422607] wlan0: authenticated
[32897.424224] wlan0: associate with c8:6c:87:a9:df:a9 (try 1/3)
[32897.427207] wlan0: RX AssocResp from c8:6c:87:a9:df:a9 (capab=0x431 status=0 aid=3)
[32897.428098] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[32897.428108] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[32897.428113] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[32897.428951] wlan0: associated
[32906.640689] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[32924.465572] usb 4-1.2: new high-speed USB device number 5 using ehci_hcd
[32924.564430] usb-storage 4-1.2:1.0: Quirks match for vid 1058 pid 0704: 8000
[32924.565235] scsi4 : usb-storage 4-1.2:1.0
[32925.568154] scsi 4:0:0:0: Direct-Access     WD       5000BMV External 1.75 PQ: 0 ANSI: 4
[32925.569231] sd 4:0:0:0: [sdc] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[32925.569845] sd 4:0:0:0: [sdc] Write Protect is off
[32925.569859] sd 4:0:0:0: [sdc] Mode Sense: 23 00 00 00
[32925.570401] sd 4:0:0:0: [sdc] No Caching mode page present
[32925.570408] sd 4:0:0:0: [sdc] Assuming drive cache: write through
[32925.572275] sd 4:0:0:0: [sdc] No Caching mode page present
[32925.572284] sd 4:0:0:0: [sdc] Assuming drive cache: write through
[32925.598266]  sdc: unknown partition table
[32925.600345] sd 4:0:0:0: [sdc] No Caching mode page present
[32925.600348] sd 4:0:0:0: [sdc] Assuming drive cache: write through
[32925.600350] sd 4:0:0:0: [sdc] Attached SCSI disk
[32954.717802] tun: Universal TUN/TAP device driver, 1.6
[32954.717805] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[32991.675077] CPU3: Core temperature above threshold, cpu clock throttled (total events = 6002)
[32991.675079] CPU1: Core temperature above threshold, cpu clock throttled (total events = 6002)
[32991.675081] CPU2: Package temperature above threshold, cpu clock throttled (total events = 6075)
[32991.675083] CPU0: Package temperature above threshold, cpu clock throttled (total events = 6075)
[32991.675084] CPU1: Package temperature above threshold, cpu clock throttled (total events = 6075)
[32991.675092] CPU3: Package temperature above threshold, cpu clock throttled (total events = 6075)
[32991.676080] CPU3: Core temperature/speed normal
[32991.676081] CPU1: Core temperature/speed normal
[32991.676083] CPU2: Package temperature/speed normal
[32991.676084] CPU1: Package temperature/speed normal
[32991.676087] CPU0: Package temperature/speed normal
[32991.676091] CPU3: Package temperature/speed normal

--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg4-during-backup-1.3g-slab"

[33192.700652] [Hardware Error]: Machine check events logged
[33292.043986] CPU3: Core temperature above threshold, cpu clock throttled (total events = 15877)
[33292.043988] CPU1: Core temperature above threshold, cpu clock throttled (total events = 15877)
[33292.043990] CPU2: Package temperature above threshold, cpu clock throttled (total events = 16107)
[33292.043992] CPU0: Package temperature above threshold, cpu clock throttled (total events = 16107)
[33292.043993] CPU1: Package temperature above threshold, cpu clock throttled (total events = 16107)
[33292.044001] CPU3: Package temperature above threshold, cpu clock throttled (total events = 16107)
[33292.045019] CPU1: Core temperature/speed normal
[33292.045021] CPU3: Core temperature/speed normal
[33292.045022] CPU2: Package temperature/speed normal
[33292.045025] CPU0: Package temperature/speed normal
[33292.045025] CPU3: Package temperature/speed normal
[33292.045030] CPU1: Package temperature/speed normal
[33342.467259] [Hardware Error]: Machine check events logged
[33591.760948] CPU1: Core temperature above threshold, cpu clock throttled (total events = 18681)
[33591.760950] CPU3: Core temperature above threshold, cpu clock throttled (total events = 18681)
[33591.760953] CPU2: Package temperature above threshold, cpu clock throttled (total events = 18934)
[33591.760954] CPU0: Package temperature above threshold, cpu clock throttled (total events = 18934)
[33591.760955] CPU3: Package temperature above threshold, cpu clock throttled (total events = 18934)
[33591.760964] CPU1: Package temperature above threshold, cpu clock throttled (total events = 18934)
[33591.761969] CPU1: Core temperature/speed normal
[33591.761970] CPU3: Core temperature/speed normal
[33591.761972] CPU2: Package temperature/speed normal
[33591.761973] CPU3: Package temperature/speed normal
[33591.761974] CPU0: Package temperature/speed normal
[33591.761980] CPU1: Package temperature/speed normal
[33791.777048] [Hardware Error]: Machine check events logged
[33892.168853] CPU1: Core temperature above threshold, cpu clock throttled (total events = 22098)
[33892.168855] CPU3: Core temperature above threshold, cpu clock throttled (total events = 22098)
[33892.168857] CPU2: Package temperature above threshold, cpu clock throttled (total events = 22372)
[33892.168859] CPU0: Package temperature above threshold, cpu clock throttled (total events = 22372)
[33892.168860] CPU3: Package temperature above threshold, cpu clock throttled (total events = 22372)
[33892.168868] CPU1: Package temperature above threshold, cpu clock throttled (total events = 22372)
[33892.169825] CPU3: Core temperature/speed normal
[33892.169827] CPU1: Core temperature/speed normal
[33892.169829] CPU2: Package temperature/speed normal
[33892.169830] CPU0: Package temperature/speed normal
[33892.169831] CPU1: Package temperature/speed normal
[33892.169837] CPU3: Package temperature/speed normal
[33941.543648] [Hardware Error]: Machine check events logged
[34228.108113] CPU1: Core temperature above threshold, cpu clock throttled (total events = 25701)
[34228.108115] CPU3: Core temperature above threshold, cpu clock throttled (total events = 25701)
[34228.108117] CPU2: Package temperature above threshold, cpu clock throttled (total events = 25990)
[34228.108119] CPU0: Package temperature above threshold, cpu clock throttled (total events = 25990)
[34228.108120] CPU3: Package temperature above threshold, cpu clock throttled (total events = 25990)
[34228.108128] CPU1: Package temperature above threshold, cpu clock throttled (total events = 25990)
[34228.109121] CPU1: Core temperature/speed normal
[34228.109122] CPU3: Core temperature/speed normal
[34228.109124] CPU2: Package temperature/speed normal
[34228.109125] CPU0: Package temperature/speed normal
[34228.109126] CPU3: Package temperature/speed normal
[34228.109132] CPU1: Package temperature/speed normal
[34390.853422] [Hardware Error]: Machine check events logged

--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg5-system-unusable

[33192.700652] [Hardware Error]: Machine check events logged
[33292.043986] CPU3: Core temperature above threshold, cpu clock throttled (total events = 15877)
[33292.043988] CPU1: Core temperature above threshold, cpu clock throttled (total events = 15877)
[33292.043990] CPU2: Package temperature above threshold, cpu clock throttled (total events = 16107)
[33292.043992] CPU0: Package temperature above threshold, cpu clock throttled (total events = 16107)
[33292.043993] CPU1: Package temperature above threshold, cpu clock throttled (total events = 16107)
[33292.044001] CPU3: Package temperature above threshold, cpu clock throttled (total events = 16107)
[33292.045019] CPU1: Core temperature/speed normal
[33292.045021] CPU3: Core temperature/speed normal
[33292.045022] CPU2: Package temperature/speed normal
[33292.045025] CPU0: Package temperature/speed normal
[33292.045025] CPU3: Package temperature/speed normal
[33292.045030] CPU1: Package temperature/speed normal
[33342.467259] [Hardware Error]: Machine check events logged
[33591.760948] CPU1: Core temperature above threshold, cpu clock throttled (total events = 18681)
[33591.760950] CPU3: Core temperature above threshold, cpu clock throttled (total events = 18681)
[33591.760953] CPU2: Package temperature above threshold, cpu clock throttled (total events = 18934)
[33591.760954] CPU0: Package temperature above threshold, cpu clock throttled (total events = 18934)
[33591.760955] CPU3: Package temperature above threshold, cpu clock throttled (total events = 18934)
[33591.760964] CPU1: Package temperature above threshold, cpu clock throttled (total events = 18934)
[33591.761969] CPU1: Core temperature/speed normal
[33591.761970] CPU3: Core temperature/speed normal
[33591.761972] CPU2: Package temperature/speed normal
[33591.761973] CPU3: Package temperature/speed normal
[33591.761974] CPU0: Package temperature/speed normal
[33591.761980] CPU1: Package temperature/speed normal
[33791.777048] [Hardware Error]: Machine check events logged
[33892.168853] CPU1: Core temperature above threshold, cpu clock throttled (total events = 22098)
[33892.168855] CPU3: Core temperature above threshold, cpu clock throttled (total events = 22098)
[33892.168857] CPU2: Package temperature above threshold, cpu clock throttled (total events = 22372)
[33892.168859] CPU0: Package temperature above threshold, cpu clock throttled (total events = 22372)
[33892.168860] CPU3: Package temperature above threshold, cpu clock throttled (total events = 22372)
[33892.168868] CPU1: Package temperature above threshold, cpu clock throttled (total events = 22372)
[33892.169825] CPU3: Core temperature/speed normal
[33892.169827] CPU1: Core temperature/speed normal
[33892.169829] CPU2: Package temperature/speed normal
[33892.169830] CPU0: Package temperature/speed normal
[33892.169831] CPU1: Package temperature/speed normal
[33892.169837] CPU3: Package temperature/speed normal
[33941.543648] [Hardware Error]: Machine check events logged
[34228.108113] CPU1: Core temperature above threshold, cpu clock throttled (total events = 25701)
[34228.108115] CPU3: Core temperature above threshold, cpu clock throttled (total events = 25701)
[34228.108117] CPU2: Package temperature above threshold, cpu clock throttled (total events = 25990)
[34228.108119] CPU0: Package temperature above threshold, cpu clock throttled (total events = 25990)
[34228.108120] CPU3: Package temperature above threshold, cpu clock throttled (total events = 25990)
[34228.108128] CPU1: Package temperature above threshold, cpu clock throttled (total events = 25990)
[34228.109121] CPU1: Core temperature/speed normal
[34228.109122] CPU3: Core temperature/speed normal
[34228.109124] CPU2: Package temperature/speed normal
[34228.109125] CPU0: Package temperature/speed normal
[34228.109126] CPU3: Package temperature/speed normal
[34228.109132] CPU1: Package temperature/speed normal
[34390.853422] [Hardware Error]: Machine check events logged
[35287.476223] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[35287.476242] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[35287.476247] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[35287.479475] cfg80211: Calling CRDA to update world regulatory domain
[35330.664210] wlan0: authenticate with c8:6c:87:a9:df:a9
[35330.664227] wlan0: send auth to c8:6c:87:a9:df:a9 (try 1/3)
[35330.665291] wlan0: authenticated
[35330.665640] wlan0: associate with c8:6c:87:a9:df:a9 (try 1/3)
[35330.667101] wlan0: RX AssocResp from c8:6c:87:a9:df:a9 (capab=0x431 status=0 aid=1)
[35330.667851] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[35330.667856] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[35330.667858] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[35330.668148] wlan0: associated
[35344.673912] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[35379.150325] wlan0: deauthenticating from c8:6c:87:a9:df:a9 by local choice (reason=3)
[35379.161186] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[35379.161194] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[35379.161196] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[35379.161779] cfg80211: Calling CRDA to update world regulatory domain
[35379.162226] wlan0: authenticate with c8:6c:87:a9:df:a9
[35379.162239] wlan0: send auth to c8:6c:87:a9:df:a9 (try 1/3)
[35379.165402] wlan0: authenticated
[35379.166593] wlan0: associate with c8:6c:87:a9:df:a9 (try 1/3)
[35379.168016] wlan0: RX AssocResp from c8:6c:87:a9:df:a9 (capab=0x431 status=0 aid=1)
[35379.168897] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[35379.168903] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[35379.168905] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[35379.168910] wlan0: associated
[35389.114525] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[35434.190991] wlan0: deauthenticating from c8:6c:87:a9:df:a9 by local choice (reason=3)
[35434.200827] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[35434.200837] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[35434.200839] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[35434.201382] wlan0: authenticate with c8:6c:87:a9:df:a9
[35434.201396] wlan0: send auth to c8:6c:87:a9:df:a9 (try 1/3)
[35434.202561] wlan0: authenticated
[35434.204116] wlan0: associate with c8:6c:87:a9:df:a9 (try 1/3)
[35434.205616] wlan0: RX AssocResp from c8:6c:87:a9:df:a9 (capab=0x431 status=0 aid=1)
[35434.206518] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[35434.206523] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[35434.206526] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[35434.206533] wlan0: associated
[35443.239129] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[35525.628979] urxvtd invoked oom-killer: gfp_mask=0x44d0, order=2, oom_adj=0, oom_score_adj=0
[35525.628983] urxvtd cpuset=/ mems_allowed=0
[35525.628985] Pid: 468, comm: urxvtd Tainted: G        W    3.5.4-1-ARCH #1
[35525.628987] Call Trace:
[35525.628992]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[35525.628996]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[35525.629000]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[35525.629004]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[35525.629009]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[35525.629011]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[35525.629015]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[35525.629017]  [<ffffffff81476834>] kmalloc_large_node+0x61/0x8e
[35525.629021]  [<ffffffff81166b0f>] __kmalloc_node_track_caller+0x19f/0x230
[35525.629024]  [<ffffffff8136fc51>] ? sock_alloc_send_pskb+0x1d1/0x320
[35525.629027]  [<ffffffff81374ec9>] __alloc_skb+0x79/0x230
[35525.629029]  [<ffffffff8136fc51>] sock_alloc_send_pskb+0x1d1/0x320
[35525.629033]  [<ffffffff8118cd16>] ? do_sys_poll+0x3e6/0x4c0
[35525.629035]  [<ffffffff8136fdb5>] sock_alloc_send_skb+0x15/0x20
[35525.629038]  [<ffffffff81411e8b>] unix_stream_sendmsg+0x27b/0x450
[35525.629041]  [<ffffffff8136c4a7>] sock_aio_write+0x147/0x180
[35525.629043]  [<ffffffff8136c360>] ? sock_aio_read+0x40/0x40
[35525.629045]  [<ffffffff8117952a>] do_sync_readv_writev+0xda/0x120
[35525.629050]  [<ffffffff8120567c>] ? security_file_permission+0x2c/0xb0
[35525.629052]  [<ffffffff81178c41>] ? rw_verify_area+0x61/0xf0
[35525.629054]  [<ffffffff81179814>] do_readv_writev+0xd4/0x1e0
[35525.629056]  [<ffffffff81179955>] vfs_writev+0x35/0x60
[35525.629058]  [<ffffffff81179aea>] sys_writev+0x4a/0xc0
[35525.629060]  [<ffffffff8118cecb>] ? sys_poll+0x6b/0x100
[35525.629063]  [<ffffffff814853ed>] system_call_fastpath+0x1a/0x1f
[35525.629065] Mem-Info:
[35525.629066] Node 0 DMA per-cpu:
[35525.629068] CPU    0: hi:    0, btch:   1 usd:   0
[35525.629069] CPU    1: hi:    0, btch:   1 usd:   0
[35525.629070] CPU    2: hi:    0, btch:   1 usd:   0
[35525.629072] CPU    3: hi:    0, btch:   1 usd:   0
[35525.629072] Node 0 DMA32 per-cpu:
[35525.629075] CPU    0: hi:  186, btch:  31 usd:   0
[35525.629076] CPU    1: hi:  186, btch:  31 usd:   0
[35525.629077] CPU    2: hi:  186, btch:  31 usd:   0
[35525.629078] CPU    3: hi:  186, btch:  31 usd:   0
[35525.629079] Node 0 Normal per-cpu:
[35525.629080] CPU    0: hi:  186, btch:  31 usd:   1
[35525.629081] CPU    1: hi:  186, btch:  31 usd:   0
[35525.629082] CPU    2: hi:  186, btch:  31 usd:   0
[35525.629083] CPU    3: hi:  186, btch:  31 usd:   0
[35525.629087] active_anon:575284 inactive_anon:16417 isolated_anon:27
[35525.629087]  active_file:206 inactive_file:546 isolated_file:32
[35525.629087]  unevictable:2423 dirty:1 writeback:0 unstable:0
[35525.629087]  free:34644 slab_reclaimable:322763 slab_unreclaimable:6863
[35525.629087]  mapped:4294 shmem:58035 pagetables:9128 bounce:0
[35525.629089] Node 0 DMA free:15864kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:32kB slab_unreclaimable:0kB kernel_stack:8kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[35525.629092] lowmem_reserve[]: 0 2137 3899 3899
[35525.629095] Node 0 DMA32 free:83492kB min:36900kB low:46124kB high:55348kB active_anon:1073224kB inactive_anon:13176kB active_file:488kB inactive_file:1356kB unevictable:2620kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:2620kB dirty:0kB writeback:0kB mapped:5888kB shmem:79004kB slab_reclaimable:984528kB slab_unreclaimable:6000kB kernel_stack:888kB pagetables:8772kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:3803 all_unreclaimable? yes
[35525.629099] lowmem_reserve[]: 0 0 1762 1762
[35525.629102] Node 0 Normal free:39220kB min:30416kB low:38020kB high:45624kB active_anon:1227912kB inactive_anon:52492kB active_file:336kB inactive_file:828kB unevictable:7072kB isolated(anon):108kB isolated(file):128kB present:1804320kB mlocked:7072kB dirty:4kB writeback:0kB mapped:11288kB shmem:153136kB slab_reclaimable:306492kB slab_unreclaimable:21452kB kernel_stack:1984kB pagetables:27740kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:1824 all_unreclaimable? yes
[35525.629106] lowmem_reserve[]: 0 0 0 0
[35525.629108] Node 0 DMA: 2*4kB 0*8kB 1*16kB 3*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15864kB
[35525.629114] Node 0 DMA32: 11823*4kB 3817*8kB 241*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 83732kB
[35525.629120] Node 0 Normal: 7394*4kB 1247*8kB 3*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 39600kB
[35525.629126] 59798 total pagecache pages
[35525.629127] 0 pages in swap cache
[35525.629128] Swap cache stats: add 0, delete 0, find 0/0
[35525.629129] Free swap  = 0kB
[35525.629130] Total swap = 0kB
[35525.638367] 1048048 pages RAM
[35525.638370] 57533 pages reserved
[35525.638370] 95356 pages shared
[35525.638371] 925311 pages non-shared
[35525.638372] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[35525.638378] [  182]     0   182     6518      390   1     -17         -1000 systemd-udevd
[35525.638380] [  188]     0   188    71437     5283   2       0             0 systemd-journal
[35525.638383] [  318]     0   318     3303      289   2       0             0 crond
[35525.638385] [  319]     0   319    17693      641   1       0             0 cupsd
[35525.638387] [  321]     0   321    10502      304   3     -17         -1000 sshd
[35525.638389] [  322]    81   322     4351      228   3     -13          -900 dbus-daemon
[35525.638391] [  324]     0   324     6512      225   2       0             0 systemd-logind
[35525.638393] [  329]     0   329    15747      284   2       0             0 login
[35525.638395] [  332]     0   332     2031      161   3       0             0 agetty
[35525.638396] [  334]     0   334     2031      161   3       0             0 agetty
[35525.638398] [  335]     0   335     2031      160   3       0             0 agetty
[35525.638400] [  336]     0   336     2031      162   3       0             0 agetty
[35525.638402] [  337]     0   337     2031      159   3       0             0 agetty
[35525.638404] [  348]     0   348    51901     1028   2       0             0 colord
[35525.638405] [  368]     0   368   123541      992   0       0             0 colord-sane
[35525.638407] [  411]     0   411     3092      172   3       0             0 master
[35525.638409] [  414]    73   414    16374      363   2       0             0 qmgr
[35525.638411] [  423]  1000   423     3423      244   2       0             0 restart-x
[35525.638413] [  434]  1000   434     3423      259   1       0             0 startx
[35525.638415] [  451]  1000   451     3966      128   1       0             0 xinit
[35525.638417] [  452]  1000   452    57695     3506   0       0             0 X
[35525.638419] [  457]  1000   457    23894      645   3       0             0 i3
[35525.638421] [  464]  1000   464     6062      190   2       0             0 unclutter
[35525.638423] [  467]  1000   467     6004      128   2       0             0 dispad
[35525.638424] [  468]  1000   468    31324     7111   1       0             0 urxvtd
[35525.638426] [  471]  1000   471     8038      470   3       0             0 xbindkeys
[35525.638428] [  493]  1000   493     8156      609   0       0             0 zsh
[35525.638429] [  506]     0   506     8481      247   0       0             0 sudo
[35525.638431] [  510]     0   510     6933      419   3       0             0 zsh
[35525.638433] [  593]     0   593     7404      210   2       0             0 wpa_supplicant
[35525.638435] [  637]     0   637     2136      133   2       0             0 dhcpcd
[35525.638436] [  919]  1000   919     8775      719   0       0             0 zsh
[35525.638438] [  926]  1000   926     3424      230   0       0             0 lh
[35525.638440] [  928]  1000   928     8322      620   2       0             0 vim
[35525.638441] [  971]  1000   971     5163      226   2       0             0 zsh
[35525.638443] [  981]  1000   981   148137    31459   2       0             0 chromium
[35525.638445] [  987]  1000   987    64813     1227   0       0             0 chromium
[35525.638447] [  988]  1000   988     1588      119   3       0             0 chromium-sandbo
[35525.638448] [  989]  1000   989    69787     1266   0       0             0 chromium
[35525.638450] [  994]  1000   994    34743      417   0       0             0 nacl_helper_boo
[35525.638452] [  995]  1000   995    73885     1172   1       0             0 chromium
[35525.638454] [ 1032]  1000  1032     4494       94   0       0             0 dbus-launch
[35525.638455] [ 1033]  1000  1033     4320      155   3       0             0 dbus-daemon
[35525.638457] [ 1034]  1000  1034   217797     4191   0       4           300 chromium
[35525.638459] [ 1042]  1000  1042   224988    12600   2       4           300 chromium
[35525.638461] [ 1055]  1000  1055   216772     3149   1       4           300 chromium
[35525.638462] [ 1104]  1000  1104   243853    28361   1       4           300 chromium
[35525.638464] [ 1304]  1000  1304     8156      608   0       0             0 zsh
[35525.638466] [ 1320]  1000  1320     8156      624   2       0             0 zsh
[35525.638468] [ 1363]  1000  1363     9742     1661   1       0             0 zsh
[35525.638469] [ 1553]  1000  1553     9667     1583   1       0             0 zsh
[35525.638471] [ 1971]  1000  1971   241871    24412   0       4           300 chromium
[35525.638473] [ 3271]  1000  3271     9119     1067   0       0             0 zsh
[35525.638474] [ 4495]  1000  4495     9974     1947   2       0             0 zsh
[35525.638476] [ 6222]  1000  6222     8156      608   1       0             0 zsh
[35525.638478] [ 6231]     0  6231     8481      239   0       0             0 sudo
[35525.638479] [ 6232]     0  6232     6933      426   1       0             0 zsh
[35525.638481] [ 8636]  1000  8636     9742     1679   2       0             0 zsh
[35525.638483] [10677]  1000 10677     8774      698   1       0             0 zsh
[35525.638485] [11030]  1000 11030    14705      739   1       0             0 mutt
[35525.638486] [11407]  1000 11407     9042     1008   2       0             0 zsh
[35525.638488] [12800]  1000 12800   227387    10437   1       4           300 chromium
[35525.638490] [12864]  1000 12864   221397     6071   2       4           300 chromium
[35525.638492] [14270]  1000 14270     9742     1738   2       0             0 zsh
[35525.638494] [15083]  1000 15083   227316    13099   2       4           300 chromium
[35525.638496] [15161]  1000 15161     8156      665   3       0             0 zsh
[35525.638498] [15212]  1000 15212     3423      288   0       0             0 ressh.sh
[35525.638500] [16063]  1000 16063   223107     8575   1       4           300 chromium
[35525.638501] [16086]  1000 16086   223595    11217   2       4           300 chromium
[35525.638503] [16332]  1000 16332     8827      839   0       0             0 zsh
[35525.638505] [16510]  1000 16510   224510     8840   3       4           300 chromium
[35525.638506] [18144]  1000 18144     8156      671   3       0             0 zsh
[35525.638508] [31725]  1000 31725     8877      879   2       0             0 zsh
[35525.638510] [31786]  1000 31786    15089     1160   1       0             0 mutt
[35525.638512] [ 1347]  1000  1347     8156      665   1       0             0 zsh
[35525.638514] [ 1355]  1000  1355     4979     2424   3       0             0 atop
[35525.638515] [ 1910]  1000  1910     8774      774   1       0             0 zsh
[35525.638517] [ 1924]  1000  1924    14644      727   3       0             0 mutt
[35525.638519] [ 7985]  1000  7985     8290      642   2       0             0 vim
[35525.638520] [ 9011]  1000  9011   229069    12852   2       4           300 chromium
[35525.638522] [10434]  1000 10434   235759    18531   3       4           300 chromium
[35525.638524] [10979]  1000 10979   247543    29759   2       4           300 chromium
[35525.638526] [11521]  1000 11521   226701    12735   0       4           300 chromium
[35525.638527] [11530]  1000 11530   227129    12037   2       4           300 chromium
[35525.638529] [11750]  1000 11750   245983    29006   2       4           300 chromium
[35525.638531] [11939]  1000 11939     8774      778   2       0             0 zsh
[35525.638532] [11946]  1000 11946     8730     1456   1       0             0 python3
[35525.638534] [11954]  1000 11954   223107     8253   3       4           300 chromium
[35525.638537] [12000]  1000 12000   236940    22987   2       4           300 chromium
[35525.638538] [12034]  1000 12034   230495    15149   1       4           300 chromium
[35525.638540] [12158]  1000 12158   239315    31208   3       4           300 chromium
[35525.638542] [12168]  1000 12168   244008    28591   3       4           300 chromium
[35525.638544] [12331]  1000 12331   227906    12017   2       4           300 chromium
[35525.638545] [12950]  1000 12950     8156      689   1       0             0 zsh
[35525.638547] [14370]  1000 14370     8156      683   0       0             0 zsh
[35525.638549] [15093]  1000 15093     9059     1056   1       0             0 zsh
[35525.638550] [15512]  1000 15512   224951    10247   2       4           300 chromium
[35525.638552] [15991]  1000 15991     8302      631   1       0             0 vim
[35525.638554] [30476]  1000 30476     8787      804   0       0             0 zsh
[35525.638555] [30652]  1000 30652     8290      692   0       0             0 vim
[35525.638557] [31863]  1000 31863     8749      760   2       0             0 zsh
[35525.638559] [  511]  1000   511    19148      532   3       0             0 i3bar
[35525.638561] [  512]  1000   512     7746      285   2       0             0 i3status
[35525.638562] [  879]  1000   879   217113     2685   2       4           300 chromium
[35525.638565] [ 1345]    73  1345    16331      371   1       0             0 pickup
[35525.638567] [ 1531]  1000  1531     8156      671   0       0             0 zsh
[35525.638569] [ 3095]  1000  3095     8798      804   1       0             0 zsh
[35525.638570] [ 7615]  1000  7615     9005      363   0       0             0 ssh
[35525.638572] [ 7808]  1000  7808     9005      338   1       0             0 ssh
[35525.638574] [ 7855]  1000  7855     8970      211   3       0             0 ssh
[35525.638576] [ 7866]  1000  7866     8970      306   2       0             0 ssh
[35525.638577] [ 8307]     0  8307     8481      281   2       0             0 sudo
[35525.638579] [ 8407]     0  8407     3457      298   1       0             0 ccollect
[35525.638581] [ 8412]     0  8412     3457      204   2       0             0 ccollect
[35525.638582] [ 8413]     0  8413     3457      147   0       0             0 ccollect
[35525.638584] [ 8414]     0  8414     2919      224   0       0             0 awk
[35525.638586] [ 8863]  1000  8863     8156      666   3       0             0 zsh
[35525.638588] [ 8918]     0  8918     8482      276   2       0             0 sudo
[35525.638590] [ 8919]     0  8919     6933      443   1       0             0 zsh
[35525.638592] [ 9295]     0  9295    30145    13061   2       0             0 rsync
[35525.638594] [ 9296]     0  9296    14062     6072   0       0             0 rsync
[35525.638595] [ 9297]     0  9297    18268     7405   2       0             0 rsync
[35525.638597] [10198]     0 10198     2755      374   2       0             0 slabtop
[35525.638599] [10199]     0 10199     1504      133   3       0             0 tee
[35525.638601] [11107]  1000 11107     8775      775   1       0             0 zsh
[35525.638603] [11369]  1000 11369     3424      268   3       0             0 nz.sh
[35525.638604] [11371]  1000 11371     8388      761   2       0             0 vim
[35525.638606] [13875]  1000 13875   233159    27916   3       4           300 chromium
[35525.638608] [17237]  1000 17237     8717      704   1       0             0 zsh
[35525.638610] [17802]  1000 17802     8156      650   2       0             0 zsh
[35525.638612] [19458]  1000 19458   220482     5036   3       4           300 chromium
[35525.638614] [ 3405]  1000  3405     2749      209   2       0             0 less
[35525.638616] [11482]  1000 11482   234080    25563   3       4           300 chromium
[35525.638617] [12262]  1000 12262     8156      643   3       0             0 zsh
[35525.638619] [12269]  1000 12269    14618      633   1       0             0 mutt
[35525.638621] [12275]     0 12275     9170      396   3       0             0 crond
[35525.638623] [12277]  1000 12277     2937      212   2       0             0 sh
[35525.638625] [12280]  1000 12280    59752     2571   2       0             0 offlineimap
[35525.638627] [12327]  1000 12327   219954     4428   3       4           300 chromium
[35525.638629] [12338]  1000 12338   215748     1983   3       4           300 chromium
[35525.638631] [12436]     0 12436     2776      287   3       0             0 wpa_cli
[35525.638633] [12475]  1000 12475   232267    22770   2       4           300 chromium
[35525.638635] [12488]     0 12488     9170      396   2       0             0 crond
[35525.638636] [12489]  1000 12489     2937      151   2       0             0 sh
[35525.638638] Out of memory: Kill process 12158 (chromium) score 331 or sacrifice child
[35525.638640] Killed process 12158 (chromium) total-vm:957260kB, anon-rss:123612kB, file-rss:1220kB
[35525.641777] urxvtd invoked oom-killer: gfp_mask=0x44d0, order=2, oom_adj=0, oom_score_adj=0
[35525.641780] urxvtd cpuset=/ mems_allowed=0
[35525.641783] Pid: 468, comm: urxvtd Tainted: G        W    3.5.4-1-ARCH #1
[35525.641784] Call Trace:
[35525.641790]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[35525.641794]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[35525.641797]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[35525.641802]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[35525.641806]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[35525.641809]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[35525.641812]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[35525.641814]  [<ffffffff81476834>] kmalloc_large_node+0x61/0x8e
[35525.641819]  [<ffffffff81166b0f>] __kmalloc_node_track_caller+0x19f/0x230
[35525.641822]  [<ffffffff8136fc51>] ? sock_alloc_send_pskb+0x1d1/0x320
[35525.641825]  [<ffffffff81374ec9>] __alloc_skb+0x79/0x230
[35525.641827]  [<ffffffff8136fc51>] sock_alloc_send_pskb+0x1d1/0x320
[35525.641830]  [<ffffffff8118cd16>] ? do_sys_poll+0x3e6/0x4c0
[35525.641833]  [<ffffffff8136fdb5>] sock_alloc_send_skb+0x15/0x20
[35525.641836]  [<ffffffff81411e8b>] unix_stream_sendmsg+0x27b/0x450
[35525.641840]  [<ffffffff8136c4a7>] sock_aio_write+0x147/0x180
[35525.641844]  [<ffffffff8136c360>] ? sock_aio_read+0x40/0x40
[35525.641847]  [<ffffffff8117952a>] do_sync_readv_writev+0xda/0x120
[35525.641852]  [<ffffffff8120567c>] ? security_file_permission+0x2c/0xb0
[35525.641857]  [<ffffffff81178c41>] ? rw_verify_area+0x61/0xf0
[35525.641859]  [<ffffffff81179814>] do_readv_writev+0xd4/0x1e0
[35525.641862]  [<ffffffff81179955>] vfs_writev+0x35/0x60
[35525.641864]  [<ffffffff81179aea>] sys_writev+0x4a/0xc0
[35525.641867]  [<ffffffff8118cecb>] ? sys_poll+0x6b/0x100
[35525.641872]  [<ffffffff814853ed>] system_call_fastpath+0x1a/0x1f
[35525.641878] Mem-Info:
[35525.641880] Node 0 DMA per-cpu:
[35525.641883] CPU    0: hi:    0, btch:   1 usd:   0
[35525.641885] CPU    1: hi:    0, btch:   1 usd:   0
[35525.641886] CPU    2: hi:    0, btch:   1 usd:   0
[35525.641888] CPU    3: hi:    0, btch:   1 usd:   0
[35525.641890] Node 0 DMA32 per-cpu:
[35525.641892] CPU    0: hi:  186, btch:  31 usd:   0
[35525.641893] CPU    1: hi:  186, btch:  31 usd:   0
[35525.641894] CPU    2: hi:  186, btch:  31 usd:   0
[35525.641895] CPU    3: hi:  186, btch:  31 usd:   0
[35525.641896] Node 0 Normal per-cpu:
[35525.641898] CPU    0: hi:  186, btch:  31 usd:   1
[35525.641899] CPU    1: hi:  186, btch:  31 usd:  28
[35525.641900] CPU    2: hi:  186, btch:  31 usd:  26
[35525.641901] CPU    3: hi:  186, btch:  31 usd:  28
[35525.641904] active_anon:575284 inactive_anon:16417 isolated_anon:27
[35525.641904]  active_file:206 inactive_file:825 isolated_file:32
[35525.641904]  unevictable:2423 dirty:1 writeback:0 unstable:0
[35525.641904]  free:34355 slab_reclaimable:322763 slab_unreclaimable:6863
[35525.641904]  mapped:4294 shmem:58035 pagetables:9128 bounce:0
[35525.641906] Node 0 DMA free:15864kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:32kB slab_unreclaimable:0kB kernel_stack:8kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[35525.641910] lowmem_reserve[]: 0 2137 3899 3899
[35525.641913] Node 0 DMA32 free:83492kB min:36900kB low:46124kB high:55348kB active_anon:1073224kB inactive_anon:13176kB active_file:488kB inactive_file:1356kB unevictable:2620kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:2620kB dirty:0kB writeback:0kB mapped:5888kB shmem:79004kB slab_reclaimable:984528kB slab_unreclaimable:6000kB kernel_stack:888kB pagetables:8772kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:3803 all_unreclaimable? yes
[35525.641917] lowmem_reserve[]: 0 0 1762 1762
[35525.641920] Node 0 Normal free:38064kB min:30416kB low:38020kB high:45624kB active_anon:1227912kB inactive_anon:52492kB active_file:336kB inactive_file:1944kB unevictable:7072kB isolated(anon):108kB isolated(file):128kB present:1804320kB mlocked:7072kB dirty:4kB writeback:0kB mapped:11288kB shmem:153136kB slab_reclaimable:306492kB slab_unreclaimable:21452kB kernel_stack:1984kB pagetables:27740kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:1824 all_unreclaimable? yes
[35525.641924] lowmem_reserve[]: 0 0 0 0
[35525.641926] Node 0 DMA: 2*4kB 0*8kB 1*16kB 3*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15864kB
[35525.641932] Node 0 DMA32: 11823*4kB 3817*8kB 241*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 83732kB
[35525.641938] Node 0 Normal: 7216*4kB 1156*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 38112kB
[35525.641944] 60074 total pagecache pages
[35525.641945] 0 pages in swap cache
[35525.641946] Swap cache stats: add 0, delete 0, find 0/0
[35525.641947] Free swap  = 0kB
[35525.641947] Total swap = 0kB
[35525.653360] 1048048 pages RAM
[35525.653363] 57533 pages reserved
[35525.653364] 95459 pages shared
[35525.653365] 922266 pages non-shared
[35525.653367] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[35525.653375] [  182]     0   182     6518      390   1     -17         -1000 systemd-udevd
[35525.653378] [  188]     0   188    71437     5283   1       0             0 systemd-journal
[35525.653382] [  318]     0   318     3303      289   2       0             0 crond
[35525.653384] [  319]     0   319    17693      641   1       0             0 cupsd
[35525.653387] [  321]     0   321    10502      304   3     -17         -1000 sshd
[35525.653390] [  322]    81   322     4351      228   3     -13          -900 dbus-daemon
[35525.653393] [  324]     0   324     6512      225   2       0             0 systemd-logind
[35525.653396] [  329]     0   329    15747      284   2       0             0 login
[35525.653398] [  332]     0   332     2031      161   3       0             0 agetty
[35525.653401] [  334]     0   334     2031      161   3       0             0 agetty
[35525.653404] [  335]     0   335     2031      160   3       0             0 agetty
[35525.653406] [  336]     0   336     2031      162   3       0             0 agetty
[35525.653409] [  337]     0   337     2031      159   3       0             0 agetty
[35525.653412] [  348]     0   348    51901     1028   2       0             0 colord
[35525.653415] [  368]     0   368   123541      992   0       0             0 colord-sane
[35525.653418] [  411]     0   411     3092      172   3       0             0 master
[35525.653421] [  414]    73   414    16374      363   2       0             0 qmgr
[35525.653424] [  423]  1000   423     3423      244   2       0             0 restart-x
[35525.653426] [  434]  1000   434     3423      259   1       0             0 startx
[35525.653429] [  451]  1000   451     3966      128   1       0             0 xinit
[35525.653432] [  452]  1000   452    57695     3506   0       0             0 X
[35525.653434] [  457]  1000   457    23894      645   3       0             0 i3
[35525.653437] [  464]  1000   464     6062      190   2       0             0 unclutter
[35525.653440] [  467]  1000   467     6004      128   2       0             0 dispad
[35525.653443] [  468]  1000   468    31324     7111   3       0             0 urxvtd
[35525.653446] [  471]  1000   471     8038      470   3       0             0 xbindkeys
[35525.653448] [  493]  1000   493     8156      609   0       0             0 zsh
[35525.653451] [  506]     0   506     8481      247   0       0             0 sudo
[35525.653453] [  510]     0   510     6933      419   3       0             0 zsh
[35525.653456] [  593]     0   593     7404      210   2       0             0 wpa_supplicant
[35525.653458] [  637]     0   637     2136      133   2       0             0 dhcpcd
[35525.653461] [  919]  1000   919     8775      719   0       0             0 zsh
[35525.653464] [  926]  1000   926     3424      230   0       0             0 lh
[35525.653467] [  928]  1000   928     8322      620   2       0             0 vim
[35525.653469] [  971]  1000   971     5163      226   2       0             0 zsh
[35525.653472] [  981]  1000   981   148137    31459   0       0             0 chromium
[35525.653475] [  987]  1000   987    64813     1227   0       0             0 chromium
[35525.653477] [  988]  1000   988     1588      119   3       0             0 chromium-sandbo
[35525.653480] [  989]  1000   989    69787     1266   0       0             0 chromium
[35525.653483] [  994]  1000   994    34743      417   0       0             0 nacl_helper_boo
[35525.653486] [  995]  1000   995    73885     1172   1       0             0 chromium
[35525.653489] [ 1032]  1000  1032     4494       94   0       0             0 dbus-launch
[35525.653491] [ 1033]  1000  1033     4320      155   3       0             0 dbus-daemon
[35525.653495] [ 1034]  1000  1034   217797     4191   0       4           300 chromium
[35525.653497] [ 1042]  1000  1042   224988    12600   2       4           300 chromium
[35525.653500] [ 1055]  1000  1055   216772     3149   1       4           300 chromium
[35525.653503] [ 1104]  1000  1104   243853    28361   1       4           300 chromium
[35525.653505] [ 1304]  1000  1304     8156      608   0       0             0 zsh
[35525.653508] [ 1320]  1000  1320     8156      624   2       0             0 zsh
[35525.653510] [ 1363]  1000  1363     9742     1661   1       0             0 zsh
[35525.653513] [ 1553]  1000  1553     9667     1583   1       0             0 zsh
[35525.653516] [ 1971]  1000  1971   241871    24412   0       4           300 chromium
[35525.653519] [ 3271]  1000  3271     9119     1067   0       0             0 zsh
[35525.653522] [ 4495]  1000  4495     9974     1947   2       0             0 zsh
[35525.653524] [ 6222]  1000  6222     8156      608   1       0             0 zsh
[35525.653527] [ 6231]     0  6231     8481      239   0       0             0 sudo
[35525.653530] [ 6232]     0  6232     6933      426   1       0             0 zsh
[35525.653532] [ 8636]  1000  8636     9742     1679   2       0             0 zsh
[35525.653535] [10677]  1000 10677     8774      698   1       0             0 zsh
[35525.653537] [11030]  1000 11030    14705      739   1       0             0 mutt
[35525.653540] [11407]  1000 11407     9042     1008   2       0             0 zsh
[35525.653543] [12800]  1000 12800   227387    10437   1       4           300 chromium
[35525.653546] [12864]  1000 12864   221397     6071   2       4           300 chromium
[35525.653548] [14270]  1000 14270     9742     1738   2       0             0 zsh
[35525.653551] [15083]  1000 15083   227316    13099   2       4           300 chromium
[35525.653553] [15161]  1000 15161     8156      665   3       0             0 zsh
[35525.653556] [15212]  1000 15212     3423      288   0       0             0 ressh.sh
[35525.653558] [16063]  1000 16063   223107     8575   1       4           300 chromium
[35525.653561] [16086]  1000 16086   223595    11217   2       4           300 chromium
[35525.653564] [16332]  1000 16332     8827      839   0       0             0 zsh
[35525.653567] [16510]  1000 16510   224510     8840   3       4           300 chromium
[35525.653569] [18144]  1000 18144     8156      671   3       0             0 zsh
[35525.653572] [31725]  1000 31725     8877      879   2       0             0 zsh
[35525.653575] [31786]  1000 31786    15089     1160   1       0             0 mutt
[35525.653578] [ 1347]  1000  1347     8156      665   1       0             0 zsh
[35525.653581] [ 1355]  1000  1355     4979     2424   3       0             0 atop
[35525.653583] [ 1910]  1000  1910     8774      774   1       0             0 zsh
[35525.653586] [ 1924]  1000  1924    14644      727   3       0             0 mutt
[35525.653588] [ 7985]  1000  7985     8290      642   2       0             0 vim
[35525.653591] [ 9011]  1000  9011   229069    12852   2       4           300 chromium
[35525.653593] [10434]  1000 10434   235759    18531   3       4           300 chromium
[35525.653596] [10979]  1000 10979   247543    29759   2       4           300 chromium
[35525.653599] [11521]  1000 11521   226701    12735   0       4           300 chromium
[35525.653601] [11530]  1000 11530   227129    12037   2       4           300 chromium
[35525.653604] [11750]  1000 11750   245983    29006   2       4           300 chromium
[35525.653606] [11939]  1000 11939     8774      778   2       0             0 zsh
[35525.653609] [11946]  1000 11946     8730     1456   1       0             0 python3
[35525.653612] [11954]  1000 11954   223107     8253   3       4           300 chromium
[35525.653615] [12000]  1000 12000   236940    22987   2       4           300 chromium
[35525.653618] [12034]  1000 12034   230495    15149   1       4           300 chromium
[35525.653621] [12168]  1000 12168   244008    28591   3       4           300 chromium
[35525.653624] [12331]  1000 12331   227906    12017   2       4           300 chromium
[35525.653626] [12950]  1000 12950     8156      689   1       0             0 zsh
[35525.653629] [14370]  1000 14370     8156      683   0       0             0 zsh
[35525.653632] [15093]  1000 15093     9059     1056   1       0             0 zsh
[35525.653635] [15512]  1000 15512   224951    10247   2       4           300 chromium
[35525.653638] [15991]  1000 15991     8302      631   1       0             0 vim
[35525.653640] [30476]  1000 30476     8787      804   0       0             0 zsh
[35525.653643] [30652]  1000 30652     8290      692   0       0             0 vim
[35525.653646] [31863]  1000 31863     8749      760   2       0             0 zsh
[35525.653649] [  511]  1000   511    19148      532   3       0             0 i3bar
[35525.653651] [  512]  1000   512     7746      285   2       0             0 i3status
[35525.653654] [  879]  1000   879   217113     2685   2       4           300 chromium
[35525.653658] [ 1345]    73  1345    16331      371   1       0             0 pickup
[35525.653660] [ 1531]  1000  1531     8156      671   0       0             0 zsh
[35525.653663] [ 3095]  1000  3095     8798      804   1       0             0 zsh
[35525.653665] [ 7615]  1000  7615     9005      363   0       0             0 ssh
[35525.653667] [ 7808]  1000  7808     9005      338   1       0             0 ssh
[35525.653670] [ 7855]  1000  7855     8970      211   3       0             0 ssh
[35525.653672] [ 7866]  1000  7866     8970      306   2       0             0 ssh
[35525.653675] [ 8307]     0  8307     8481      281   2       0             0 sudo
[35525.653678] [ 8407]     0  8407     3457      298   1       0             0 ccollect
[35525.653680] [ 8412]     0  8412     3457      204   2       0             0 ccollect
[35525.653683] [ 8413]     0  8413     3457      147   0       0             0 ccollect
[35525.653685] [ 8414]     0  8414     2919      224   0       0             0 awk
[35525.653689] [ 8863]  1000  8863     8156      666   3       0             0 zsh
[35525.653692] [ 8918]     0  8918     8482      276   2       0             0 sudo
[35525.653694] [ 8919]     0  8919     6933      443   1       0             0 zsh
[35525.653697] [ 9295]     0  9295    30145    13061   2       0             0 rsync
[35525.653699] [ 9296]     0  9296    14062     6072   0       0             0 rsync
[35525.653702] [ 9297]     0  9297    18268     7405   2       0             0 rsync
[35525.653705] [10198]     0 10198     2755      374   2       0             0 slabtop
[35525.653708] [10199]     0 10199     1504      133   3       0             0 tee
[35525.653711] [11107]  1000 11107     8775      775   1       0             0 zsh
[35525.653714] [11369]  1000 11369     3424      268   3       0             0 nz.sh
[35525.653717] [11371]  1000 11371     8388      761   2       0             0 vim
[35525.653720] [13875]  1000 13875   233159    27916   3       4           300 chromium
[35525.653722] [17237]  1000 17237     8717      704   1       0             0 zsh
[35525.653725] [17802]  1000 17802     8156      650   2       0             0 zsh
[35525.653728] [19458]  1000 19458   220482     5036   3       4           300 chromium
[35525.653731] [ 3405]  1000  3405     2749      209   2       0             0 less
[35525.653733] [11482]  1000 11482   234080    25563   3       4           300 chromium
[35525.653737] [12262]  1000 12262     8156      643   3       0             0 zsh
[35525.653739] [12269]  1000 12269    14618      633   1       0             0 mutt
[35525.653742] [12275]     0 12275     9170      396   3       0             0 crond
[35525.653745] [12277]  1000 12277     2937      212   2       0             0 sh
[35525.653748] [12280]  1000 12280    59752     2571   2       0             0 offlineimap
[35525.653751] [12327]  1000 12327   219954     4428   3       4           300 chromium
[35525.653754] [12338]  1000 12338   215748     1983   3       4           300 chromium
[35525.653757] [12436]     0 12436     2776      287   3       0             0 wpa_cli
[35525.653760] [12475]  1000 12475   232267    22770   2       4           300 chromium
[35525.653763] [12488]     0 12488     9170      396   2       0             0 crond
[35525.653765] [12489]  1000 12489     2937      298   0       0             0 sh
[35525.653768] Out of memory: Kill process 10979 (chromium) score 330 or sacrifice child
[35525.653771] Killed process 10979 (chromium) total-vm:990172kB, anon-rss:117576kB, file-rss:1460kB

--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg6-system-partly-usable-still-backup-1.5g-slab"

[33192.700652] [Hardware Error]: Machine check events logged
[33292.043986] CPU3: Core temperature above threshold, cpu clock throttled (total events = 15877)
[33292.043988] CPU1: Core temperature above threshold, cpu clock throttled (total events = 15877)
[33292.043990] CPU2: Package temperature above threshold, cpu clock throttled (total events = 16107)
[33292.043992] CPU0: Package temperature above threshold, cpu clock throttled (total events = 16107)
[33292.043993] CPU1: Package temperature above threshold, cpu clock throttled (total events = 16107)
[33292.044001] CPU3: Package temperature above threshold, cpu clock throttled (total events = 16107)
[33292.045019] CPU1: Core temperature/speed normal
[33292.045021] CPU3: Core temperature/speed normal
[33292.045022] CPU2: Package temperature/speed normal
[33292.045025] CPU0: Package temperature/speed normal
[33292.045025] CPU3: Package temperature/speed normal
[33292.045030] CPU1: Package temperature/speed normal
[33342.467259] [Hardware Error]: Machine check events logged
[33591.760948] CPU1: Core temperature above threshold, cpu clock throttled (total events = 18681)
[33591.760950] CPU3: Core temperature above threshold, cpu clock throttled (total events = 18681)
[33591.760953] CPU2: Package temperature above threshold, cpu clock throttled (total events = 18934)
[33591.760954] CPU0: Package temperature above threshold, cpu clock throttled (total events = 18934)
[33591.760955] CPU3: Package temperature above threshold, cpu clock throttled (total events = 18934)
[33591.760964] CPU1: Package temperature above threshold, cpu clock throttled (total events = 18934)
[33591.761969] CPU1: Core temperature/speed normal
[33591.761970] CPU3: Core temperature/speed normal
[33591.761972] CPU2: Package temperature/speed normal
[33591.761973] CPU3: Package temperature/speed normal
[33591.761974] CPU0: Package temperature/speed normal
[33591.761980] CPU1: Package temperature/speed normal
[33791.777048] [Hardware Error]: Machine check events logged
[33892.168853] CPU1: Core temperature above threshold, cpu clock throttled (total events = 22098)
[33892.168855] CPU3: Core temperature above threshold, cpu clock throttled (total events = 22098)
[33892.168857] CPU2: Package temperature above threshold, cpu clock throttled (total events = 22372)
[33892.168859] CPU0: Package temperature above threshold, cpu clock throttled (total events = 22372)
[33892.168860] CPU3: Package temperature above threshold, cpu clock throttled (total events = 22372)
[33892.168868] CPU1: Package temperature above threshold, cpu clock throttled (total events = 22372)
[33892.169825] CPU3: Core temperature/speed normal
[33892.169827] CPU1: Core temperature/speed normal
[33892.169829] CPU2: Package temperature/speed normal
[33892.169830] CPU0: Package temperature/speed normal
[33892.169831] CPU1: Package temperature/speed normal
[33892.169837] CPU3: Package temperature/speed normal
[33941.543648] [Hardware Error]: Machine check events logged
[34228.108113] CPU1: Core temperature above threshold, cpu clock throttled (total events = 25701)
[34228.108115] CPU3: Core temperature above threshold, cpu clock throttled (total events = 25701)
[34228.108117] CPU2: Package temperature above threshold, cpu clock throttled (total events = 25990)
[34228.108119] CPU0: Package temperature above threshold, cpu clock throttled (total events = 25990)
[34228.108120] CPU3: Package temperature above threshold, cpu clock throttled (total events = 25990)
[34228.108128] CPU1: Package temperature above threshold, cpu clock throttled (total events = 25990)
[34228.109121] CPU1: Core temperature/speed normal
[34228.109122] CPU3: Core temperature/speed normal
[34228.109124] CPU2: Package temperature/speed normal
[34228.109125] CPU0: Package temperature/speed normal
[34228.109126] CPU3: Package temperature/speed normal
[34228.109132] CPU1: Package temperature/speed normal
[34390.853422] [Hardware Error]: Machine check events logged
[35287.476223] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[35287.476242] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[35287.476247] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[35287.479475] cfg80211: Calling CRDA to update world regulatory domain
[35330.664210] wlan0: authenticate with c8:6c:87:a9:df:a9
[35330.664227] wlan0: send auth to c8:6c:87:a9:df:a9 (try 1/3)
[35330.665291] wlan0: authenticated
[35330.665640] wlan0: associate with c8:6c:87:a9:df:a9 (try 1/3)
[35330.667101] wlan0: RX AssocResp from c8:6c:87:a9:df:a9 (capab=0x431 status=0 aid=1)
[35330.667851] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[35330.667856] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[35330.667858] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[35330.668148] wlan0: associated
[35344.673912] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[35379.150325] wlan0: deauthenticating from c8:6c:87:a9:df:a9 by local choice (reason=3)
[35379.161186] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[35379.161194] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[35379.161196] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[35379.161779] cfg80211: Calling CRDA to update world regulatory domain
[35379.162226] wlan0: authenticate with c8:6c:87:a9:df:a9
[35379.162239] wlan0: send auth to c8:6c:87:a9:df:a9 (try 1/3)
[35379.165402] wlan0: authenticated
[35379.166593] wlan0: associate with c8:6c:87:a9:df:a9 (try 1/3)
[35379.168016] wlan0: RX AssocResp from c8:6c:87:a9:df:a9 (capab=0x431 status=0 aid=1)
[35379.168897] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[35379.168903] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[35379.168905] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[35379.168910] wlan0: associated
[35389.114525] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[35434.190991] wlan0: deauthenticating from c8:6c:87:a9:df:a9 by local choice (reason=3)
[35434.200827] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[35434.200837] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[35434.200839] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[35434.201382] wlan0: authenticate with c8:6c:87:a9:df:a9
[35434.201396] wlan0: send auth to c8:6c:87:a9:df:a9 (try 1/3)
[35434.202561] wlan0: authenticated
[35434.204116] wlan0: associate with c8:6c:87:a9:df:a9 (try 1/3)
[35434.205616] wlan0: RX AssocResp from c8:6c:87:a9:df:a9 (capab=0x431 status=0 aid=1)
[35434.206518] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[35434.206523] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[35434.206526] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[35434.206533] wlan0: associated
[35443.239129] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[35525.628979] urxvtd invoked oom-killer: gfp_mask=0x44d0, order=2, oom_adj=0, oom_score_adj=0
[35525.628983] urxvtd cpuset=/ mems_allowed=0
[35525.628985] Pid: 468, comm: urxvtd Tainted: G        W    3.5.4-1-ARCH #1
[35525.628987] Call Trace:
[35525.628992]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[35525.628996]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[35525.629000]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[35525.629004]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[35525.629009]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[35525.629011]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[35525.629015]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[35525.629017]  [<ffffffff81476834>] kmalloc_large_node+0x61/0x8e
[35525.629021]  [<ffffffff81166b0f>] __kmalloc_node_track_caller+0x19f/0x230
[35525.629024]  [<ffffffff8136fc51>] ? sock_alloc_send_pskb+0x1d1/0x320
[35525.629027]  [<ffffffff81374ec9>] __alloc_skb+0x79/0x230
[35525.629029]  [<ffffffff8136fc51>] sock_alloc_send_pskb+0x1d1/0x320
[35525.629033]  [<ffffffff8118cd16>] ? do_sys_poll+0x3e6/0x4c0
[35525.629035]  [<ffffffff8136fdb5>] sock_alloc_send_skb+0x15/0x20
[35525.629038]  [<ffffffff81411e8b>] unix_stream_sendmsg+0x27b/0x450
[35525.629041]  [<ffffffff8136c4a7>] sock_aio_write+0x147/0x180
[35525.629043]  [<ffffffff8136c360>] ? sock_aio_read+0x40/0x40
[35525.629045]  [<ffffffff8117952a>] do_sync_readv_writev+0xda/0x120
[35525.629050]  [<ffffffff8120567c>] ? security_file_permission+0x2c/0xb0
[35525.629052]  [<ffffffff81178c41>] ? rw_verify_area+0x61/0xf0
[35525.629054]  [<ffffffff81179814>] do_readv_writev+0xd4/0x1e0
[35525.629056]  [<ffffffff81179955>] vfs_writev+0x35/0x60
[35525.629058]  [<ffffffff81179aea>] sys_writev+0x4a/0xc0
[35525.629060]  [<ffffffff8118cecb>] ? sys_poll+0x6b/0x100
[35525.629063]  [<ffffffff814853ed>] system_call_fastpath+0x1a/0x1f
[35525.629065] Mem-Info:
[35525.629066] Node 0 DMA per-cpu:
[35525.629068] CPU    0: hi:    0, btch:   1 usd:   0
[35525.629069] CPU    1: hi:    0, btch:   1 usd:   0
[35525.629070] CPU    2: hi:    0, btch:   1 usd:   0
[35525.629072] CPU    3: hi:    0, btch:   1 usd:   0
[35525.629072] Node 0 DMA32 per-cpu:
[35525.629075] CPU    0: hi:  186, btch:  31 usd:   0
[35525.629076] CPU    1: hi:  186, btch:  31 usd:   0
[35525.629077] CPU    2: hi:  186, btch:  31 usd:   0
[35525.629078] CPU    3: hi:  186, btch:  31 usd:   0
[35525.629079] Node 0 Normal per-cpu:
[35525.629080] CPU    0: hi:  186, btch:  31 usd:   1
[35525.629081] CPU    1: hi:  186, btch:  31 usd:   0
[35525.629082] CPU    2: hi:  186, btch:  31 usd:   0
[35525.629083] CPU    3: hi:  186, btch:  31 usd:   0
[35525.629087] active_anon:575284 inactive_anon:16417 isolated_anon:27
[35525.629087]  active_file:206 inactive_file:546 isolated_file:32
[35525.629087]  unevictable:2423 dirty:1 writeback:0 unstable:0
[35525.629087]  free:34644 slab_reclaimable:322763 slab_unreclaimable:6863
[35525.629087]  mapped:4294 shmem:58035 pagetables:9128 bounce:0
[35525.629089] Node 0 DMA free:15864kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:32kB slab_unreclaimable:0kB kernel_stack:8kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[35525.629092] lowmem_reserve[]: 0 2137 3899 3899
[35525.629095] Node 0 DMA32 free:83492kB min:36900kB low:46124kB high:55348kB active_anon:1073224kB inactive_anon:13176kB active_file:488kB inactive_file:1356kB unevictable:2620kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:2620kB dirty:0kB writeback:0kB mapped:5888kB shmem:79004kB slab_reclaimable:984528kB slab_unreclaimable:6000kB kernel_stack:888kB pagetables:8772kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:3803 all_unreclaimable? yes
[35525.629099] lowmem_reserve[]: 0 0 1762 1762
[35525.629102] Node 0 Normal free:39220kB min:30416kB low:38020kB high:45624kB active_anon:1227912kB inactive_anon:52492kB active_file:336kB inactive_file:828kB unevictable:7072kB isolated(anon):108kB isolated(file):128kB present:1804320kB mlocked:7072kB dirty:4kB writeback:0kB mapped:11288kB shmem:153136kB slab_reclaimable:306492kB slab_unreclaimable:21452kB kernel_stack:1984kB pagetables:27740kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:1824 all_unreclaimable? yes
[35525.629106] lowmem_reserve[]: 0 0 0 0
[35525.629108] Node 0 DMA: 2*4kB 0*8kB 1*16kB 3*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15864kB
[35525.629114] Node 0 DMA32: 11823*4kB 3817*8kB 241*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 83732kB
[35525.629120] Node 0 Normal: 7394*4kB 1247*8kB 3*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 39600kB
[35525.629126] 59798 total pagecache pages
[35525.629127] 0 pages in swap cache
[35525.629128] Swap cache stats: add 0, delete 0, find 0/0
[35525.629129] Free swap  = 0kB
[35525.629130] Total swap = 0kB
[35525.638367] 1048048 pages RAM
[35525.638370] 57533 pages reserved
[35525.638370] 95356 pages shared
[35525.638371] 925311 pages non-shared
[35525.638372] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[35525.638378] [  182]     0   182     6518      390   1     -17         -1000 systemd-udevd
[35525.638380] [  188]     0   188    71437     5283   2       0             0 systemd-journal
[35525.638383] [  318]     0   318     3303      289   2       0             0 crond
[35525.638385] [  319]     0   319    17693      641   1       0             0 cupsd
[35525.638387] [  321]     0   321    10502      304   3     -17         -1000 sshd
[35525.638389] [  322]    81   322     4351      228   3     -13          -900 dbus-daemon
[35525.638391] [  324]     0   324     6512      225   2       0             0 systemd-logind
[35525.638393] [  329]     0   329    15747      284   2       0             0 login
[35525.638395] [  332]     0   332     2031      161   3       0             0 agetty
[35525.638396] [  334]     0   334     2031      161   3       0             0 agetty
[35525.638398] [  335]     0   335     2031      160   3       0             0 agetty
[35525.638400] [  336]     0   336     2031      162   3       0             0 agetty
[35525.638402] [  337]     0   337     2031      159   3       0             0 agetty
[35525.638404] [  348]     0   348    51901     1028   2       0             0 colord
[35525.638405] [  368]     0   368   123541      992   0       0             0 colord-sane
[35525.638407] [  411]     0   411     3092      172   3       0             0 master
[35525.638409] [  414]    73   414    16374      363   2       0             0 qmgr
[35525.638411] [  423]  1000   423     3423      244   2       0             0 restart-x
[35525.638413] [  434]  1000   434     3423      259   1       0             0 startx
[35525.638415] [  451]  1000   451     3966      128   1       0             0 xinit
[35525.638417] [  452]  1000   452    57695     3506   0       0             0 X
[35525.638419] [  457]  1000   457    23894      645   3       0             0 i3
[35525.638421] [  464]  1000   464     6062      190   2       0             0 unclutter
[35525.638423] [  467]  1000   467     6004      128   2       0             0 dispad
[35525.638424] [  468]  1000   468    31324     7111   1       0             0 urxvtd
[35525.638426] [  471]  1000   471     8038      470   3       0             0 xbindkeys
[35525.638428] [  493]  1000   493     8156      609   0       0             0 zsh
[35525.638429] [  506]     0   506     8481      247   0       0             0 sudo
[35525.638431] [  510]     0   510     6933      419   3       0             0 zsh
[35525.638433] [  593]     0   593     7404      210   2       0             0 wpa_supplicant
[35525.638435] [  637]     0   637     2136      133   2       0             0 dhcpcd
[35525.638436] [  919]  1000   919     8775      719   0       0             0 zsh
[35525.638438] [  926]  1000   926     3424      230   0       0             0 lh
[35525.638440] [  928]  1000   928     8322      620   2       0             0 vim
[35525.638441] [  971]  1000   971     5163      226   2       0             0 zsh
[35525.638443] [  981]  1000   981   148137    31459   2       0             0 chromium
[35525.638445] [  987]  1000   987    64813     1227   0       0             0 chromium
[35525.638447] [  988]  1000   988     1588      119   3       0             0 chromium-sandbo
[35525.638448] [  989]  1000   989    69787     1266   0       0             0 chromium
[35525.638450] [  994]  1000   994    34743      417   0       0             0 nacl_helper_boo
[35525.638452] [  995]  1000   995    73885     1172   1       0             0 chromium
[35525.638454] [ 1032]  1000  1032     4494       94   0       0             0 dbus-launch
[35525.638455] [ 1033]  1000  1033     4320      155   3       0             0 dbus-daemon
[35525.638457] [ 1034]  1000  1034   217797     4191   0       4           300 chromium
[35525.638459] [ 1042]  1000  1042   224988    12600   2       4           300 chromium
[35525.638461] [ 1055]  1000  1055   216772     3149   1       4           300 chromium
[35525.638462] [ 1104]  1000  1104   243853    28361   1       4           300 chromium
[35525.638464] [ 1304]  1000  1304     8156      608   0       0             0 zsh
[35525.638466] [ 1320]  1000  1320     8156      624   2       0             0 zsh
[35525.638468] [ 1363]  1000  1363     9742     1661   1       0             0 zsh
[35525.638469] [ 1553]  1000  1553     9667     1583   1       0             0 zsh
[35525.638471] [ 1971]  1000  1971   241871    24412   0       4           300 chromium
[35525.638473] [ 3271]  1000  3271     9119     1067   0       0             0 zsh
[35525.638474] [ 4495]  1000  4495     9974     1947   2       0             0 zsh
[35525.638476] [ 6222]  1000  6222     8156      608   1       0             0 zsh
[35525.638478] [ 6231]     0  6231     8481      239   0       0             0 sudo
[35525.638479] [ 6232]     0  6232     6933      426   1       0             0 zsh
[35525.638481] [ 8636]  1000  8636     9742     1679   2       0             0 zsh
[35525.638483] [10677]  1000 10677     8774      698   1       0             0 zsh
[35525.638485] [11030]  1000 11030    14705      739   1       0             0 mutt
[35525.638486] [11407]  1000 11407     9042     1008   2       0             0 zsh
[35525.638488] [12800]  1000 12800   227387    10437   1       4           300 chromium
[35525.638490] [12864]  1000 12864   221397     6071   2       4           300 chromium
[35525.638492] [14270]  1000 14270     9742     1738   2       0             0 zsh
[35525.638494] [15083]  1000 15083   227316    13099   2       4           300 chromium
[35525.638496] [15161]  1000 15161     8156      665   3       0             0 zsh
[35525.638498] [15212]  1000 15212     3423      288   0       0             0 ressh.sh
[35525.638500] [16063]  1000 16063   223107     8575   1       4           300 chromium
[35525.638501] [16086]  1000 16086   223595    11217   2       4           300 chromium
[35525.638503] [16332]  1000 16332     8827      839   0       0             0 zsh
[35525.638505] [16510]  1000 16510   224510     8840   3       4           300 chromium
[35525.638506] [18144]  1000 18144     8156      671   3       0             0 zsh
[35525.638508] [31725]  1000 31725     8877      879   2       0             0 zsh
[35525.638510] [31786]  1000 31786    15089     1160   1       0             0 mutt
[35525.638512] [ 1347]  1000  1347     8156      665   1       0             0 zsh
[35525.638514] [ 1355]  1000  1355     4979     2424   3       0             0 atop
[35525.638515] [ 1910]  1000  1910     8774      774   1       0             0 zsh
[35525.638517] [ 1924]  1000  1924    14644      727   3       0             0 mutt
[35525.638519] [ 7985]  1000  7985     8290      642   2       0             0 vim
[35525.638520] [ 9011]  1000  9011   229069    12852   2       4           300 chromium
[35525.638522] [10434]  1000 10434   235759    18531   3       4           300 chromium
[35525.638524] [10979]  1000 10979   247543    29759   2       4           300 chromium
[35525.638526] [11521]  1000 11521   226701    12735   0       4           300 chromium
[35525.638527] [11530]  1000 11530   227129    12037   2       4           300 chromium
[35525.638529] [11750]  1000 11750   245983    29006   2       4           300 chromium
[35525.638531] [11939]  1000 11939     8774      778   2       0             0 zsh
[35525.638532] [11946]  1000 11946     8730     1456   1       0             0 python3
[35525.638534] [11954]  1000 11954   223107     8253   3       4           300 chromium
[35525.638537] [12000]  1000 12000   236940    22987   2       4           300 chromium
[35525.638538] [12034]  1000 12034   230495    15149   1       4           300 chromium
[35525.638540] [12158]  1000 12158   239315    31208   3       4           300 chromium
[35525.638542] [12168]  1000 12168   244008    28591   3       4           300 chromium
[35525.638544] [12331]  1000 12331   227906    12017   2       4           300 chromium
[35525.638545] [12950]  1000 12950     8156      689   1       0             0 zsh
[35525.638547] [14370]  1000 14370     8156      683   0       0             0 zsh
[35525.638549] [15093]  1000 15093     9059     1056   1       0             0 zsh
[35525.638550] [15512]  1000 15512   224951    10247   2       4           300 chromium
[35525.638552] [15991]  1000 15991     8302      631   1       0             0 vim
[35525.638554] [30476]  1000 30476     8787      804   0       0             0 zsh
[35525.638555] [30652]  1000 30652     8290      692   0       0             0 vim
[35525.638557] [31863]  1000 31863     8749      760   2       0             0 zsh
[35525.638559] [  511]  1000   511    19148      532   3       0             0 i3bar
[35525.638561] [  512]  1000   512     7746      285   2       0             0 i3status
[35525.638562] [  879]  1000   879   217113     2685   2       4           300 chromium
[35525.638565] [ 1345]    73  1345    16331      371   1       0             0 pickup
[35525.638567] [ 1531]  1000  1531     8156      671   0       0             0 zsh
[35525.638569] [ 3095]  1000  3095     8798      804   1       0             0 zsh
[35525.638570] [ 7615]  1000  7615     9005      363   0       0             0 ssh
[35525.638572] [ 7808]  1000  7808     9005      338   1       0             0 ssh
[35525.638574] [ 7855]  1000  7855     8970      211   3       0             0 ssh
[35525.638576] [ 7866]  1000  7866     8970      306   2       0             0 ssh
[35525.638577] [ 8307]     0  8307     8481      281   2       0             0 sudo
[35525.638579] [ 8407]     0  8407     3457      298   1       0             0 ccollect
[35525.638581] [ 8412]     0  8412     3457      204   2       0             0 ccollect
[35525.638582] [ 8413]     0  8413     3457      147   0       0             0 ccollect
[35525.638584] [ 8414]     0  8414     2919      224   0       0             0 awk
[35525.638586] [ 8863]  1000  8863     8156      666   3       0             0 zsh
[35525.638588] [ 8918]     0  8918     8482      276   2       0             0 sudo
[35525.638590] [ 8919]     0  8919     6933      443   1       0             0 zsh
[35525.638592] [ 9295]     0  9295    30145    13061   2       0             0 rsync
[35525.638594] [ 9296]     0  9296    14062     6072   0       0             0 rsync
[35525.638595] [ 9297]     0  9297    18268     7405   2       0             0 rsync
[35525.638597] [10198]     0 10198     2755      374   2       0             0 slabtop
[35525.638599] [10199]     0 10199     1504      133   3       0             0 tee
[35525.638601] [11107]  1000 11107     8775      775   1       0             0 zsh
[35525.638603] [11369]  1000 11369     3424      268   3       0             0 nz.sh
[35525.638604] [11371]  1000 11371     8388      761   2       0             0 vim
[35525.638606] [13875]  1000 13875   233159    27916   3       4           300 chromium
[35525.638608] [17237]  1000 17237     8717      704   1       0             0 zsh
[35525.638610] [17802]  1000 17802     8156      650   2       0             0 zsh
[35525.638612] [19458]  1000 19458   220482     5036   3       4           300 chromium
[35525.638614] [ 3405]  1000  3405     2749      209   2       0             0 less
[35525.638616] [11482]  1000 11482   234080    25563   3       4           300 chromium
[35525.638617] [12262]  1000 12262     8156      643   3       0             0 zsh
[35525.638619] [12269]  1000 12269    14618      633   1       0             0 mutt
[35525.638621] [12275]     0 12275     9170      396   3       0             0 crond
[35525.638623] [12277]  1000 12277     2937      212   2       0             0 sh
[35525.638625] [12280]  1000 12280    59752     2571   2       0             0 offlineimap
[35525.638627] [12327]  1000 12327   219954     4428   3       4           300 chromium
[35525.638629] [12338]  1000 12338   215748     1983   3       4           300 chromium
[35525.638631] [12436]     0 12436     2776      287   3       0             0 wpa_cli
[35525.638633] [12475]  1000 12475   232267    22770   2       4           300 chromium
[35525.638635] [12488]     0 12488     9170      396   2       0             0 crond
[35525.638636] [12489]  1000 12489     2937      151   2       0             0 sh
[35525.638638] Out of memory: Kill process 12158 (chromium) score 331 or sacrifice child
[35525.638640] Killed process 12158 (chromium) total-vm:957260kB, anon-rss:123612kB, file-rss:1220kB
[35525.641777] urxvtd invoked oom-killer: gfp_mask=0x44d0, order=2, oom_adj=0, oom_score_adj=0
[35525.641780] urxvtd cpuset=/ mems_allowed=0
[35525.641783] Pid: 468, comm: urxvtd Tainted: G        W    3.5.4-1-ARCH #1
[35525.641784] Call Trace:
[35525.641790]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[35525.641794]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[35525.641797]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[35525.641802]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[35525.641806]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[35525.641809]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[35525.641812]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[35525.641814]  [<ffffffff81476834>] kmalloc_large_node+0x61/0x8e
[35525.641819]  [<ffffffff81166b0f>] __kmalloc_node_track_caller+0x19f/0x230
[35525.641822]  [<ffffffff8136fc51>] ? sock_alloc_send_pskb+0x1d1/0x320
[35525.641825]  [<ffffffff81374ec9>] __alloc_skb+0x79/0x230
[35525.641827]  [<ffffffff8136fc51>] sock_alloc_send_pskb+0x1d1/0x320
[35525.641830]  [<ffffffff8118cd16>] ? do_sys_poll+0x3e6/0x4c0
[35525.641833]  [<ffffffff8136fdb5>] sock_alloc_send_skb+0x15/0x20
[35525.641836]  [<ffffffff81411e8b>] unix_stream_sendmsg+0x27b/0x450
[35525.641840]  [<ffffffff8136c4a7>] sock_aio_write+0x147/0x180
[35525.641844]  [<ffffffff8136c360>] ? sock_aio_read+0x40/0x40
[35525.641847]  [<ffffffff8117952a>] do_sync_readv_writev+0xda/0x120
[35525.641852]  [<ffffffff8120567c>] ? security_file_permission+0x2c/0xb0
[35525.641857]  [<ffffffff81178c41>] ? rw_verify_area+0x61/0xf0
[35525.641859]  [<ffffffff81179814>] do_readv_writev+0xd4/0x1e0
[35525.641862]  [<ffffffff81179955>] vfs_writev+0x35/0x60
[35525.641864]  [<ffffffff81179aea>] sys_writev+0x4a/0xc0
[35525.641867]  [<ffffffff8118cecb>] ? sys_poll+0x6b/0x100
[35525.641872]  [<ffffffff814853ed>] system_call_fastpath+0x1a/0x1f
[35525.641878] Mem-Info:
[35525.641880] Node 0 DMA per-cpu:
[35525.641883] CPU    0: hi:    0, btch:   1 usd:   0
[35525.641885] CPU    1: hi:    0, btch:   1 usd:   0
[35525.641886] CPU    2: hi:    0, btch:   1 usd:   0
[35525.641888] CPU    3: hi:    0, btch:   1 usd:   0
[35525.641890] Node 0 DMA32 per-cpu:
[35525.641892] CPU    0: hi:  186, btch:  31 usd:   0
[35525.641893] CPU    1: hi:  186, btch:  31 usd:   0
[35525.641894] CPU    2: hi:  186, btch:  31 usd:   0
[35525.641895] CPU    3: hi:  186, btch:  31 usd:   0
[35525.641896] Node 0 Normal per-cpu:
[35525.641898] CPU    0: hi:  186, btch:  31 usd:   1
[35525.641899] CPU    1: hi:  186, btch:  31 usd:  28
[35525.641900] CPU    2: hi:  186, btch:  31 usd:  26
[35525.641901] CPU    3: hi:  186, btch:  31 usd:  28
[35525.641904] active_anon:575284 inactive_anon:16417 isolated_anon:27
[35525.641904]  active_file:206 inactive_file:825 isolated_file:32
[35525.641904]  unevictable:2423 dirty:1 writeback:0 unstable:0
[35525.641904]  free:34355 slab_reclaimable:322763 slab_unreclaimable:6863
[35525.641904]  mapped:4294 shmem:58035 pagetables:9128 bounce:0
[35525.641906] Node 0 DMA free:15864kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:32kB slab_unreclaimable:0kB kernel_stack:8kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[35525.641910] lowmem_reserve[]: 0 2137 3899 3899
[35525.641913] Node 0 DMA32 free:83492kB min:36900kB low:46124kB high:55348kB active_anon:1073224kB inactive_anon:13176kB active_file:488kB inactive_file:1356kB unevictable:2620kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:2620kB dirty:0kB writeback:0kB mapped:5888kB shmem:79004kB slab_reclaimable:984528kB slab_unreclaimable:6000kB kernel_stack:888kB pagetables:8772kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:3803 all_unreclaimable? yes
[35525.641917] lowmem_reserve[]: 0 0 1762 1762
[35525.641920] Node 0 Normal free:38064kB min:30416kB low:38020kB high:45624kB active_anon:1227912kB inactive_anon:52492kB active_file:336kB inactive_file:1944kB unevictable:7072kB isolated(anon):108kB isolated(file):128kB present:1804320kB mlocked:7072kB dirty:4kB writeback:0kB mapped:11288kB shmem:153136kB slab_reclaimable:306492kB slab_unreclaimable:21452kB kernel_stack:1984kB pagetables:27740kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:1824 all_unreclaimable? yes
[35525.641924] lowmem_reserve[]: 0 0 0 0
[35525.641926] Node 0 DMA: 2*4kB 0*8kB 1*16kB 3*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15864kB
[35525.641932] Node 0 DMA32: 11823*4kB 3817*8kB 241*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 83732kB
[35525.641938] Node 0 Normal: 7216*4kB 1156*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 38112kB
[35525.641944] 60074 total pagecache pages
[35525.641945] 0 pages in swap cache
[35525.641946] Swap cache stats: add 0, delete 0, find 0/0
[35525.641947] Free swap  = 0kB
[35525.641947] Total swap = 0kB
[35525.653360] 1048048 pages RAM
[35525.653363] 57533 pages reserved
[35525.653364] 95459 pages shared
[35525.653365] 922266 pages non-shared
[35525.653367] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[35525.653375] [  182]     0   182     6518      390   1     -17         -1000 systemd-udevd
[35525.653378] [  188]     0   188    71437     5283   1       0             0 systemd-journal
[35525.653382] [  318]     0   318     3303      289   2       0             0 crond
[35525.653384] [  319]     0   319    17693      641   1       0             0 cupsd
[35525.653387] [  321]     0   321    10502      304   3     -17         -1000 sshd
[35525.653390] [  322]    81   322     4351      228   3     -13          -900 dbus-daemon
[35525.653393] [  324]     0   324     6512      225   2       0             0 systemd-logind
[35525.653396] [  329]     0   329    15747      284   2       0             0 login
[35525.653398] [  332]     0   332     2031      161   3       0             0 agetty
[35525.653401] [  334]     0   334     2031      161   3       0             0 agetty
[35525.653404] [  335]     0   335     2031      160   3       0             0 agetty
[35525.653406] [  336]     0   336     2031      162   3       0             0 agetty
[35525.653409] [  337]     0   337     2031      159   3       0             0 agetty
[35525.653412] [  348]     0   348    51901     1028   2       0             0 colord
[35525.653415] [  368]     0   368   123541      992   0       0             0 colord-sane
[35525.653418] [  411]     0   411     3092      172   3       0             0 master
[35525.653421] [  414]    73   414    16374      363   2       0             0 qmgr
[35525.653424] [  423]  1000   423     3423      244   2       0             0 restart-x
[35525.653426] [  434]  1000   434     3423      259   1       0             0 startx
[35525.653429] [  451]  1000   451     3966      128   1       0             0 xinit
[35525.653432] [  452]  1000   452    57695     3506   0       0             0 X
[35525.653434] [  457]  1000   457    23894      645   3       0             0 i3
[35525.653437] [  464]  1000   464     6062      190   2       0             0 unclutter
[35525.653440] [  467]  1000   467     6004      128   2       0             0 dispad
[35525.653443] [  468]  1000   468    31324     7111   3       0             0 urxvtd
[35525.653446] [  471]  1000   471     8038      470   3       0             0 xbindkeys
[35525.653448] [  493]  1000   493     8156      609   0       0             0 zsh
[35525.653451] [  506]     0   506     8481      247   0       0             0 sudo
[35525.653453] [  510]     0   510     6933      419   3       0             0 zsh
[35525.653456] [  593]     0   593     7404      210   2       0             0 wpa_supplicant
[35525.653458] [  637]     0   637     2136      133   2       0             0 dhcpcd
[35525.653461] [  919]  1000   919     8775      719   0       0             0 zsh
[35525.653464] [  926]  1000   926     3424      230   0       0             0 lh
[35525.653467] [  928]  1000   928     8322      620   2       0             0 vim
[35525.653469] [  971]  1000   971     5163      226   2       0             0 zsh
[35525.653472] [  981]  1000   981   148137    31459   0       0             0 chromium
[35525.653475] [  987]  1000   987    64813     1227   0       0             0 chromium
[35525.653477] [  988]  1000   988     1588      119   3       0             0 chromium-sandbo
[35525.653480] [  989]  1000   989    69787     1266   0       0             0 chromium
[35525.653483] [  994]  1000   994    34743      417   0       0             0 nacl_helper_boo
[35525.653486] [  995]  1000   995    73885     1172   1       0             0 chromium
[35525.653489] [ 1032]  1000  1032     4494       94   0       0             0 dbus-launch
[35525.653491] [ 1033]  1000  1033     4320      155   3       0             0 dbus-daemon
[35525.653495] [ 1034]  1000  1034   217797     4191   0       4           300 chromium
[35525.653497] [ 1042]  1000  1042   224988    12600   2       4           300 chromium
[35525.653500] [ 1055]  1000  1055   216772     3149   1       4           300 chromium
[35525.653503] [ 1104]  1000  1104   243853    28361   1       4           300 chromium
[35525.653505] [ 1304]  1000  1304     8156      608   0       0             0 zsh
[35525.653508] [ 1320]  1000  1320     8156      624   2       0             0 zsh
[35525.653510] [ 1363]  1000  1363     9742     1661   1       0             0 zsh
[35525.653513] [ 1553]  1000  1553     9667     1583   1       0             0 zsh
[35525.653516] [ 1971]  1000  1971   241871    24412   0       4           300 chromium
[35525.653519] [ 3271]  1000  3271     9119     1067   0       0             0 zsh
[35525.653522] [ 4495]  1000  4495     9974     1947   2       0             0 zsh
[35525.653524] [ 6222]  1000  6222     8156      608   1       0             0 zsh
[35525.653527] [ 6231]     0  6231     8481      239   0       0             0 sudo
[35525.653530] [ 6232]     0  6232     6933      426   1       0             0 zsh
[35525.653532] [ 8636]  1000  8636     9742     1679   2       0             0 zsh
[35525.653535] [10677]  1000 10677     8774      698   1       0             0 zsh
[35525.653537] [11030]  1000 11030    14705      739   1       0             0 mutt
[35525.653540] [11407]  1000 11407     9042     1008   2       0             0 zsh
[35525.653543] [12800]  1000 12800   227387    10437   1       4           300 chromium
[35525.653546] [12864]  1000 12864   221397     6071   2       4           300 chromium
[35525.653548] [14270]  1000 14270     9742     1738   2       0             0 zsh
[35525.653551] [15083]  1000 15083   227316    13099   2       4           300 chromium
[35525.653553] [15161]  1000 15161     8156      665   3       0             0 zsh
[35525.653556] [15212]  1000 15212     3423      288   0       0             0 ressh.sh
[35525.653558] [16063]  1000 16063   223107     8575   1       4           300 chromium
[35525.653561] [16086]  1000 16086   223595    11217   2       4           300 chromium
[35525.653564] [16332]  1000 16332     8827      839   0       0             0 zsh
[35525.653567] [16510]  1000 16510   224510     8840   3       4           300 chromium
[35525.653569] [18144]  1000 18144     8156      671   3       0             0 zsh
[35525.653572] [31725]  1000 31725     8877      879   2       0             0 zsh
[35525.653575] [31786]  1000 31786    15089     1160   1       0             0 mutt
[35525.653578] [ 1347]  1000  1347     8156      665   1       0             0 zsh
[35525.653581] [ 1355]  1000  1355     4979     2424   3       0             0 atop
[35525.653583] [ 1910]  1000  1910     8774      774   1       0             0 zsh
[35525.653586] [ 1924]  1000  1924    14644      727   3       0             0 mutt
[35525.653588] [ 7985]  1000  7985     8290      642   2       0             0 vim
[35525.653591] [ 9011]  1000  9011   229069    12852   2       4           300 chromium
[35525.653593] [10434]  1000 10434   235759    18531   3       4           300 chromium
[35525.653596] [10979]  1000 10979   247543    29759   2       4           300 chromium
[35525.653599] [11521]  1000 11521   226701    12735   0       4           300 chromium
[35525.653601] [11530]  1000 11530   227129    12037   2       4           300 chromium
[35525.653604] [11750]  1000 11750   245983    29006   2       4           300 chromium
[35525.653606] [11939]  1000 11939     8774      778   2       0             0 zsh
[35525.653609] [11946]  1000 11946     8730     1456   1       0             0 python3
[35525.653612] [11954]  1000 11954   223107     8253   3       4           300 chromium
[35525.653615] [12000]  1000 12000   236940    22987   2       4           300 chromium
[35525.653618] [12034]  1000 12034   230495    15149   1       4           300 chromium
[35525.653621] [12168]  1000 12168   244008    28591   3       4           300 chromium
[35525.653624] [12331]  1000 12331   227906    12017   2       4           300 chromium
[35525.653626] [12950]  1000 12950     8156      689   1       0             0 zsh
[35525.653629] [14370]  1000 14370     8156      683   0       0             0 zsh
[35525.653632] [15093]  1000 15093     9059     1056   1       0             0 zsh
[35525.653635] [15512]  1000 15512   224951    10247   2       4           300 chromium
[35525.653638] [15991]  1000 15991     8302      631   1       0             0 vim
[35525.653640] [30476]  1000 30476     8787      804   0       0             0 zsh
[35525.653643] [30652]  1000 30652     8290      692   0       0             0 vim
[35525.653646] [31863]  1000 31863     8749      760   2       0             0 zsh
[35525.653649] [  511]  1000   511    19148      532   3       0             0 i3bar
[35525.653651] [  512]  1000   512     7746      285   2       0             0 i3status
[35525.653654] [  879]  1000   879   217113     2685   2       4           300 chromium
[35525.653658] [ 1345]    73  1345    16331      371   1       0             0 pickup
[35525.653660] [ 1531]  1000  1531     8156      671   0       0             0 zsh
[35525.653663] [ 3095]  1000  3095     8798      804   1       0             0 zsh
[35525.653665] [ 7615]  1000  7615     9005      363   0       0             0 ssh
[35525.653667] [ 7808]  1000  7808     9005      338   1       0             0 ssh
[35525.653670] [ 7855]  1000  7855     8970      211   3       0             0 ssh
[35525.653672] [ 7866]  1000  7866     8970      306   2       0             0 ssh
[35525.653675] [ 8307]     0  8307     8481      281   2       0             0 sudo
[35525.653678] [ 8407]     0  8407     3457      298   1       0             0 ccollect
[35525.653680] [ 8412]     0  8412     3457      204   2       0             0 ccollect
[35525.653683] [ 8413]     0  8413     3457      147   0       0             0 ccollect
[35525.653685] [ 8414]     0  8414     2919      224   0       0             0 awk
[35525.653689] [ 8863]  1000  8863     8156      666   3       0             0 zsh
[35525.653692] [ 8918]     0  8918     8482      276   2       0             0 sudo
[35525.653694] [ 8919]     0  8919     6933      443   1       0             0 zsh
[35525.653697] [ 9295]     0  9295    30145    13061   2       0             0 rsync
[35525.653699] [ 9296]     0  9296    14062     6072   0       0             0 rsync
[35525.653702] [ 9297]     0  9297    18268     7405   2       0             0 rsync
[35525.653705] [10198]     0 10198     2755      374   2       0             0 slabtop
[35525.653708] [10199]     0 10199     1504      133   3       0             0 tee
[35525.653711] [11107]  1000 11107     8775      775   1       0             0 zsh
[35525.653714] [11369]  1000 11369     3424      268   3       0             0 nz.sh
[35525.653717] [11371]  1000 11371     8388      761   2       0             0 vim
[35525.653720] [13875]  1000 13875   233159    27916   3       4           300 chromium
[35525.653722] [17237]  1000 17237     8717      704   1       0             0 zsh
[35525.653725] [17802]  1000 17802     8156      650   2       0             0 zsh
[35525.653728] [19458]  1000 19458   220482     5036   3       4           300 chromium
[35525.653731] [ 3405]  1000  3405     2749      209   2       0             0 less
[35525.653733] [11482]  1000 11482   234080    25563   3       4           300 chromium
[35525.653737] [12262]  1000 12262     8156      643   3       0             0 zsh
[35525.653739] [12269]  1000 12269    14618      633   1       0             0 mutt
[35525.653742] [12275]     0 12275     9170      396   3       0             0 crond
[35525.653745] [12277]  1000 12277     2937      212   2       0             0 sh
[35525.653748] [12280]  1000 12280    59752     2571   2       0             0 offlineimap
[35525.653751] [12327]  1000 12327   219954     4428   3       4           300 chromium
[35525.653754] [12338]  1000 12338   215748     1983   3       4           300 chromium
[35525.653757] [12436]     0 12436     2776      287   3       0             0 wpa_cli
[35525.653760] [12475]  1000 12475   232267    22770   2       4           300 chromium
[35525.653763] [12488]     0 12488     9170      396   2       0             0 crond
[35525.653765] [12489]  1000 12489     2937      298   0       0             0 sh
[35525.653768] Out of memory: Kill process 10979 (chromium) score 330 or sacrifice child
[35525.653771] Killed process 10979 (chromium) total-vm:990172kB, anon-rss:117576kB, file-rss:1460kB

--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg7-system-heating-slab-2.4g"

[33192.700652] [Hardware Error]: Machine check events logged
[33292.043986] CPU3: Core temperature above threshold, cpu clock throttled (total events = 15877)
[33292.043988] CPU1: Core temperature above threshold, cpu clock throttled (total events = 15877)
[33292.043990] CPU2: Package temperature above threshold, cpu clock throttled (total events = 16107)
[33292.043992] CPU0: Package temperature above threshold, cpu clock throttled (total events = 16107)
[33292.043993] CPU1: Package temperature above threshold, cpu clock throttled (total events = 16107)
[33292.044001] CPU3: Package temperature above threshold, cpu clock throttled (total events = 16107)
[33292.045019] CPU1: Core temperature/speed normal
[33292.045021] CPU3: Core temperature/speed normal
[33292.045022] CPU2: Package temperature/speed normal
[33292.045025] CPU0: Package temperature/speed normal
[33292.045025] CPU3: Package temperature/speed normal
[33292.045030] CPU1: Package temperature/speed normal
[33342.467259] [Hardware Error]: Machine check events logged
[33591.760948] CPU1: Core temperature above threshold, cpu clock throttled (total events = 18681)
[33591.760950] CPU3: Core temperature above threshold, cpu clock throttled (total events = 18681)
[33591.760953] CPU2: Package temperature above threshold, cpu clock throttled (total events = 18934)
[33591.760954] CPU0: Package temperature above threshold, cpu clock throttled (total events = 18934)
[33591.760955] CPU3: Package temperature above threshold, cpu clock throttled (total events = 18934)
[33591.760964] CPU1: Package temperature above threshold, cpu clock throttled (total events = 18934)
[33591.761969] CPU1: Core temperature/speed normal
[33591.761970] CPU3: Core temperature/speed normal
[33591.761972] CPU2: Package temperature/speed normal
[33591.761973] CPU3: Package temperature/speed normal
[33591.761974] CPU0: Package temperature/speed normal
[33591.761980] CPU1: Package temperature/speed normal
[33791.777048] [Hardware Error]: Machine check events logged
[33892.168853] CPU1: Core temperature above threshold, cpu clock throttled (total events = 22098)
[33892.168855] CPU3: Core temperature above threshold, cpu clock throttled (total events = 22098)
[33892.168857] CPU2: Package temperature above threshold, cpu clock throttled (total events = 22372)
[33892.168859] CPU0: Package temperature above threshold, cpu clock throttled (total events = 22372)
[33892.168860] CPU3: Package temperature above threshold, cpu clock throttled (total events = 22372)
[33892.168868] CPU1: Package temperature above threshold, cpu clock throttled (total events = 22372)
[33892.169825] CPU3: Core temperature/speed normal
[33892.169827] CPU1: Core temperature/speed normal
[33892.169829] CPU2: Package temperature/speed normal
[33892.169830] CPU0: Package temperature/speed normal
[33892.169831] CPU1: Package temperature/speed normal
[33892.169837] CPU3: Package temperature/speed normal
[33941.543648] [Hardware Error]: Machine check events logged
[34228.108113] CPU1: Core temperature above threshold, cpu clock throttled (total events = 25701)
[34228.108115] CPU3: Core temperature above threshold, cpu clock throttled (total events = 25701)
[34228.108117] CPU2: Package temperature above threshold, cpu clock throttled (total events = 25990)
[34228.108119] CPU0: Package temperature above threshold, cpu clock throttled (total events = 25990)
[34228.108120] CPU3: Package temperature above threshold, cpu clock throttled (total events = 25990)
[34228.108128] CPU1: Package temperature above threshold, cpu clock throttled (total events = 25990)
[34228.109121] CPU1: Core temperature/speed normal
[34228.109122] CPU3: Core temperature/speed normal
[34228.109124] CPU2: Package temperature/speed normal
[34228.109125] CPU0: Package temperature/speed normal
[34228.109126] CPU3: Package temperature/speed normal
[34228.109132] CPU1: Package temperature/speed normal
[34390.853422] [Hardware Error]: Machine check events logged
[35287.476223] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[35287.476242] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[35287.476247] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[35287.479475] cfg80211: Calling CRDA to update world regulatory domain
[35330.664210] wlan0: authenticate with c8:6c:87:a9:df:a9
[35330.664227] wlan0: send auth to c8:6c:87:a9:df:a9 (try 1/3)
[35330.665291] wlan0: authenticated
[35330.665640] wlan0: associate with c8:6c:87:a9:df:a9 (try 1/3)
[35330.667101] wlan0: RX AssocResp from c8:6c:87:a9:df:a9 (capab=0x431 status=0 aid=1)
[35330.667851] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[35330.667856] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[35330.667858] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[35330.668148] wlan0: associated
[35344.673912] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[35379.150325] wlan0: deauthenticating from c8:6c:87:a9:df:a9 by local choice (reason=3)
[35379.161186] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[35379.161194] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[35379.161196] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[35379.161779] cfg80211: Calling CRDA to update world regulatory domain
[35379.162226] wlan0: authenticate with c8:6c:87:a9:df:a9
[35379.162239] wlan0: send auth to c8:6c:87:a9:df:a9 (try 1/3)
[35379.165402] wlan0: authenticated
[35379.166593] wlan0: associate with c8:6c:87:a9:df:a9 (try 1/3)
[35379.168016] wlan0: RX AssocResp from c8:6c:87:a9:df:a9 (capab=0x431 status=0 aid=1)
[35379.168897] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[35379.168903] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[35379.168905] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[35379.168910] wlan0: associated
[35389.114525] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[35434.190991] wlan0: deauthenticating from c8:6c:87:a9:df:a9 by local choice (reason=3)
[35434.200827] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[35434.200837] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[35434.200839] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[35434.201382] wlan0: authenticate with c8:6c:87:a9:df:a9
[35434.201396] wlan0: send auth to c8:6c:87:a9:df:a9 (try 1/3)
[35434.202561] wlan0: authenticated
[35434.204116] wlan0: associate with c8:6c:87:a9:df:a9 (try 1/3)
[35434.205616] wlan0: RX AssocResp from c8:6c:87:a9:df:a9 (capab=0x431 status=0 aid=1)
[35434.206518] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[35434.206523] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[35434.206526] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[35434.206533] wlan0: associated
[35443.239129] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[35525.628979] urxvtd invoked oom-killer: gfp_mask=0x44d0, order=2, oom_adj=0, oom_score_adj=0
[35525.628983] urxvtd cpuset=/ mems_allowed=0
[35525.628985] Pid: 468, comm: urxvtd Tainted: G        W    3.5.4-1-ARCH #1
[35525.628987] Call Trace:
[35525.628992]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[35525.628996]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[35525.629000]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[35525.629004]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[35525.629009]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[35525.629011]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[35525.629015]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[35525.629017]  [<ffffffff81476834>] kmalloc_large_node+0x61/0x8e
[35525.629021]  [<ffffffff81166b0f>] __kmalloc_node_track_caller+0x19f/0x230
[35525.629024]  [<ffffffff8136fc51>] ? sock_alloc_send_pskb+0x1d1/0x320
[35525.629027]  [<ffffffff81374ec9>] __alloc_skb+0x79/0x230
[35525.629029]  [<ffffffff8136fc51>] sock_alloc_send_pskb+0x1d1/0x320
[35525.629033]  [<ffffffff8118cd16>] ? do_sys_poll+0x3e6/0x4c0
[35525.629035]  [<ffffffff8136fdb5>] sock_alloc_send_skb+0x15/0x20
[35525.629038]  [<ffffffff81411e8b>] unix_stream_sendmsg+0x27b/0x450
[35525.629041]  [<ffffffff8136c4a7>] sock_aio_write+0x147/0x180
[35525.629043]  [<ffffffff8136c360>] ? sock_aio_read+0x40/0x40
[35525.629045]  [<ffffffff8117952a>] do_sync_readv_writev+0xda/0x120
[35525.629050]  [<ffffffff8120567c>] ? security_file_permission+0x2c/0xb0
[35525.629052]  [<ffffffff81178c41>] ? rw_verify_area+0x61/0xf0
[35525.629054]  [<ffffffff81179814>] do_readv_writev+0xd4/0x1e0
[35525.629056]  [<ffffffff81179955>] vfs_writev+0x35/0x60
[35525.629058]  [<ffffffff81179aea>] sys_writev+0x4a/0xc0
[35525.629060]  [<ffffffff8118cecb>] ? sys_poll+0x6b/0x100
[35525.629063]  [<ffffffff814853ed>] system_call_fastpath+0x1a/0x1f
[35525.629065] Mem-Info:
[35525.629066] Node 0 DMA per-cpu:
[35525.629068] CPU    0: hi:    0, btch:   1 usd:   0
[35525.629069] CPU    1: hi:    0, btch:   1 usd:   0
[35525.629070] CPU    2: hi:    0, btch:   1 usd:   0
[35525.629072] CPU    3: hi:    0, btch:   1 usd:   0
[35525.629072] Node 0 DMA32 per-cpu:
[35525.629075] CPU    0: hi:  186, btch:  31 usd:   0
[35525.629076] CPU    1: hi:  186, btch:  31 usd:   0
[35525.629077] CPU    2: hi:  186, btch:  31 usd:   0
[35525.629078] CPU    3: hi:  186, btch:  31 usd:   0
[35525.629079] Node 0 Normal per-cpu:
[35525.629080] CPU    0: hi:  186, btch:  31 usd:   1
[35525.629081] CPU    1: hi:  186, btch:  31 usd:   0
[35525.629082] CPU    2: hi:  186, btch:  31 usd:   0
[35525.629083] CPU    3: hi:  186, btch:  31 usd:   0
[35525.629087] active_anon:575284 inactive_anon:16417 isolated_anon:27
[35525.629087]  active_file:206 inactive_file:546 isolated_file:32
[35525.629087]  unevictable:2423 dirty:1 writeback:0 unstable:0
[35525.629087]  free:34644 slab_reclaimable:322763 slab_unreclaimable:6863
[35525.629087]  mapped:4294 shmem:58035 pagetables:9128 bounce:0
[35525.629089] Node 0 DMA free:15864kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:32kB slab_unreclaimable:0kB kernel_stack:8kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[35525.629092] lowmem_reserve[]: 0 2137 3899 3899
[35525.629095] Node 0 DMA32 free:83492kB min:36900kB low:46124kB high:55348kB active_anon:1073224kB inactive_anon:13176kB active_file:488kB inactive_file:1356kB unevictable:2620kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:2620kB dirty:0kB writeback:0kB mapped:5888kB shmem:79004kB slab_reclaimable:984528kB slab_unreclaimable:6000kB kernel_stack:888kB pagetables:8772kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:3803 all_unreclaimable? yes
[35525.629099] lowmem_reserve[]: 0 0 1762 1762
[35525.629102] Node 0 Normal free:39220kB min:30416kB low:38020kB high:45624kB active_anon:1227912kB inactive_anon:52492kB active_file:336kB inactive_file:828kB unevictable:7072kB isolated(anon):108kB isolated(file):128kB present:1804320kB mlocked:7072kB dirty:4kB writeback:0kB mapped:11288kB shmem:153136kB slab_reclaimable:306492kB slab_unreclaimable:21452kB kernel_stack:1984kB pagetables:27740kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:1824 all_unreclaimable? yes
[35525.629106] lowmem_reserve[]: 0 0 0 0
[35525.629108] Node 0 DMA: 2*4kB 0*8kB 1*16kB 3*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15864kB
[35525.629114] Node 0 DMA32: 11823*4kB 3817*8kB 241*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 83732kB
[35525.629120] Node 0 Normal: 7394*4kB 1247*8kB 3*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 39600kB
[35525.629126] 59798 total pagecache pages
[35525.629127] 0 pages in swap cache
[35525.629128] Swap cache stats: add 0, delete 0, find 0/0
[35525.629129] Free swap  = 0kB
[35525.629130] Total swap = 0kB
[35525.638367] 1048048 pages RAM
[35525.638370] 57533 pages reserved
[35525.638370] 95356 pages shared
[35525.638371] 925311 pages non-shared
[35525.638372] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[35525.638378] [  182]     0   182     6518      390   1     -17         -1000 systemd-udevd
[35525.638380] [  188]     0   188    71437     5283   2       0             0 systemd-journal
[35525.638383] [  318]     0   318     3303      289   2       0             0 crond
[35525.638385] [  319]     0   319    17693      641   1       0             0 cupsd
[35525.638387] [  321]     0   321    10502      304   3     -17         -1000 sshd
[35525.638389] [  322]    81   322     4351      228   3     -13          -900 dbus-daemon
[35525.638391] [  324]     0   324     6512      225   2       0             0 systemd-logind
[35525.638393] [  329]     0   329    15747      284   2       0             0 login
[35525.638395] [  332]     0   332     2031      161   3       0             0 agetty
[35525.638396] [  334]     0   334     2031      161   3       0             0 agetty
[35525.638398] [  335]     0   335     2031      160   3       0             0 agetty
[35525.638400] [  336]     0   336     2031      162   3       0             0 agetty
[35525.638402] [  337]     0   337     2031      159   3       0             0 agetty
[35525.638404] [  348]     0   348    51901     1028   2       0             0 colord
[35525.638405] [  368]     0   368   123541      992   0       0             0 colord-sane
[35525.638407] [  411]     0   411     3092      172   3       0             0 master
[35525.638409] [  414]    73   414    16374      363   2       0             0 qmgr
[35525.638411] [  423]  1000   423     3423      244   2       0             0 restart-x
[35525.638413] [  434]  1000   434     3423      259   1       0             0 startx
[35525.638415] [  451]  1000   451     3966      128   1       0             0 xinit
[35525.638417] [  452]  1000   452    57695     3506   0       0             0 X
[35525.638419] [  457]  1000   457    23894      645   3       0             0 i3
[35525.638421] [  464]  1000   464     6062      190   2       0             0 unclutter
[35525.638423] [  467]  1000   467     6004      128   2       0             0 dispad
[35525.638424] [  468]  1000   468    31324     7111   1       0             0 urxvtd
[35525.638426] [  471]  1000   471     8038      470   3       0             0 xbindkeys
[35525.638428] [  493]  1000   493     8156      609   0       0             0 zsh
[35525.638429] [  506]     0   506     8481      247   0       0             0 sudo
[35525.638431] [  510]     0   510     6933      419   3       0             0 zsh
[35525.638433] [  593]     0   593     7404      210   2       0             0 wpa_supplicant
[35525.638435] [  637]     0   637     2136      133   2       0             0 dhcpcd
[35525.638436] [  919]  1000   919     8775      719   0       0             0 zsh
[35525.638438] [  926]  1000   926     3424      230   0       0             0 lh
[35525.638440] [  928]  1000   928     8322      620   2       0             0 vim
[35525.638441] [  971]  1000   971     5163      226   2       0             0 zsh
[35525.638443] [  981]  1000   981   148137    31459   2       0             0 chromium
[35525.638445] [  987]  1000   987    64813     1227   0       0             0 chromium
[35525.638447] [  988]  1000   988     1588      119   3       0             0 chromium-sandbo
[35525.638448] [  989]  1000   989    69787     1266   0       0             0 chromium
[35525.638450] [  994]  1000   994    34743      417   0       0             0 nacl_helper_boo
[35525.638452] [  995]  1000   995    73885     1172   1       0             0 chromium
[35525.638454] [ 1032]  1000  1032     4494       94   0       0             0 dbus-launch
[35525.638455] [ 1033]  1000  1033     4320      155   3       0             0 dbus-daemon
[35525.638457] [ 1034]  1000  1034   217797     4191   0       4           300 chromium
[35525.638459] [ 1042]  1000  1042   224988    12600   2       4           300 chromium
[35525.638461] [ 1055]  1000  1055   216772     3149   1       4           300 chromium
[35525.638462] [ 1104]  1000  1104   243853    28361   1       4           300 chromium
[35525.638464] [ 1304]  1000  1304     8156      608   0       0             0 zsh
[35525.638466] [ 1320]  1000  1320     8156      624   2       0             0 zsh
[35525.638468] [ 1363]  1000  1363     9742     1661   1       0             0 zsh
[35525.638469] [ 1553]  1000  1553     9667     1583   1       0             0 zsh
[35525.638471] [ 1971]  1000  1971   241871    24412   0       4           300 chromium
[35525.638473] [ 3271]  1000  3271     9119     1067   0       0             0 zsh
[35525.638474] [ 4495]  1000  4495     9974     1947   2       0             0 zsh
[35525.638476] [ 6222]  1000  6222     8156      608   1       0             0 zsh
[35525.638478] [ 6231]     0  6231     8481      239   0       0             0 sudo
[35525.638479] [ 6232]     0  6232     6933      426   1       0             0 zsh
[35525.638481] [ 8636]  1000  8636     9742     1679   2       0             0 zsh
[35525.638483] [10677]  1000 10677     8774      698   1       0             0 zsh
[35525.638485] [11030]  1000 11030    14705      739   1       0             0 mutt
[35525.638486] [11407]  1000 11407     9042     1008   2       0             0 zsh
[35525.638488] [12800]  1000 12800   227387    10437   1       4           300 chromium
[35525.638490] [12864]  1000 12864   221397     6071   2       4           300 chromium
[35525.638492] [14270]  1000 14270     9742     1738   2       0             0 zsh
[35525.638494] [15083]  1000 15083   227316    13099   2       4           300 chromium
[35525.638496] [15161]  1000 15161     8156      665   3       0             0 zsh
[35525.638498] [15212]  1000 15212     3423      288   0       0             0 ressh.sh
[35525.638500] [16063]  1000 16063   223107     8575   1       4           300 chromium
[35525.638501] [16086]  1000 16086   223595    11217   2       4           300 chromium
[35525.638503] [16332]  1000 16332     8827      839   0       0             0 zsh
[35525.638505] [16510]  1000 16510   224510     8840   3       4           300 chromium
[35525.638506] [18144]  1000 18144     8156      671   3       0             0 zsh
[35525.638508] [31725]  1000 31725     8877      879   2       0             0 zsh
[35525.638510] [31786]  1000 31786    15089     1160   1       0             0 mutt
[35525.638512] [ 1347]  1000  1347     8156      665   1       0             0 zsh
[35525.638514] [ 1355]  1000  1355     4979     2424   3       0             0 atop
[35525.638515] [ 1910]  1000  1910     8774      774   1       0             0 zsh
[35525.638517] [ 1924]  1000  1924    14644      727   3       0             0 mutt
[35525.638519] [ 7985]  1000  7985     8290      642   2       0             0 vim
[35525.638520] [ 9011]  1000  9011   229069    12852   2       4           300 chromium
[35525.638522] [10434]  1000 10434   235759    18531   3       4           300 chromium
[35525.638524] [10979]  1000 10979   247543    29759   2       4           300 chromium
[35525.638526] [11521]  1000 11521   226701    12735   0       4           300 chromium
[35525.638527] [11530]  1000 11530   227129    12037   2       4           300 chromium
[35525.638529] [11750]  1000 11750   245983    29006   2       4           300 chromium
[35525.638531] [11939]  1000 11939     8774      778   2       0             0 zsh
[35525.638532] [11946]  1000 11946     8730     1456   1       0             0 python3
[35525.638534] [11954]  1000 11954   223107     8253   3       4           300 chromium
[35525.638537] [12000]  1000 12000   236940    22987   2       4           300 chromium
[35525.638538] [12034]  1000 12034   230495    15149   1       4           300 chromium
[35525.638540] [12158]  1000 12158   239315    31208   3       4           300 chromium
[35525.638542] [12168]  1000 12168   244008    28591   3       4           300 chromium
[35525.638544] [12331]  1000 12331   227906    12017   2       4           300 chromium
[35525.638545] [12950]  1000 12950     8156      689   1       0             0 zsh
[35525.638547] [14370]  1000 14370     8156      683   0       0             0 zsh
[35525.638549] [15093]  1000 15093     9059     1056   1       0             0 zsh
[35525.638550] [15512]  1000 15512   224951    10247   2       4           300 chromium
[35525.638552] [15991]  1000 15991     8302      631   1       0             0 vim
[35525.638554] [30476]  1000 30476     8787      804   0       0             0 zsh
[35525.638555] [30652]  1000 30652     8290      692   0       0             0 vim
[35525.638557] [31863]  1000 31863     8749      760   2       0             0 zsh
[35525.638559] [  511]  1000   511    19148      532   3       0             0 i3bar
[35525.638561] [  512]  1000   512     7746      285   2       0             0 i3status
[35525.638562] [  879]  1000   879   217113     2685   2       4           300 chromium
[35525.638565] [ 1345]    73  1345    16331      371   1       0             0 pickup
[35525.638567] [ 1531]  1000  1531     8156      671   0       0             0 zsh
[35525.638569] [ 3095]  1000  3095     8798      804   1       0             0 zsh
[35525.638570] [ 7615]  1000  7615     9005      363   0       0             0 ssh
[35525.638572] [ 7808]  1000  7808     9005      338   1       0             0 ssh
[35525.638574] [ 7855]  1000  7855     8970      211   3       0             0 ssh
[35525.638576] [ 7866]  1000  7866     8970      306   2       0             0 ssh
[35525.638577] [ 8307]     0  8307     8481      281   2       0             0 sudo
[35525.638579] [ 8407]     0  8407     3457      298   1       0             0 ccollect
[35525.638581] [ 8412]     0  8412     3457      204   2       0             0 ccollect
[35525.638582] [ 8413]     0  8413     3457      147   0       0             0 ccollect
[35525.638584] [ 8414]     0  8414     2919      224   0       0             0 awk
[35525.638586] [ 8863]  1000  8863     8156      666   3       0             0 zsh
[35525.638588] [ 8918]     0  8918     8482      276   2       0             0 sudo
[35525.638590] [ 8919]     0  8919     6933      443   1       0             0 zsh
[35525.638592] [ 9295]     0  9295    30145    13061   2       0             0 rsync
[35525.638594] [ 9296]     0  9296    14062     6072   0       0             0 rsync
[35525.638595] [ 9297]     0  9297    18268     7405   2       0             0 rsync
[35525.638597] [10198]     0 10198     2755      374   2       0             0 slabtop
[35525.638599] [10199]     0 10199     1504      133   3       0             0 tee
[35525.638601] [11107]  1000 11107     8775      775   1       0             0 zsh
[35525.638603] [11369]  1000 11369     3424      268   3       0             0 nz.sh
[35525.638604] [11371]  1000 11371     8388      761   2       0             0 vim
[35525.638606] [13875]  1000 13875   233159    27916   3       4           300 chromium
[35525.638608] [17237]  1000 17237     8717      704   1       0             0 zsh
[35525.638610] [17802]  1000 17802     8156      650   2       0             0 zsh
[35525.638612] [19458]  1000 19458   220482     5036   3       4           300 chromium
[35525.638614] [ 3405]  1000  3405     2749      209   2       0             0 less
[35525.638616] [11482]  1000 11482   234080    25563   3       4           300 chromium
[35525.638617] [12262]  1000 12262     8156      643   3       0             0 zsh
[35525.638619] [12269]  1000 12269    14618      633   1       0             0 mutt
[35525.638621] [12275]     0 12275     9170      396   3       0             0 crond
[35525.638623] [12277]  1000 12277     2937      212   2       0             0 sh
[35525.638625] [12280]  1000 12280    59752     2571   2       0             0 offlineimap
[35525.638627] [12327]  1000 12327   219954     4428   3       4           300 chromium
[35525.638629] [12338]  1000 12338   215748     1983   3       4           300 chromium
[35525.638631] [12436]     0 12436     2776      287   3       0             0 wpa_cli
[35525.638633] [12475]  1000 12475   232267    22770   2       4           300 chromium
[35525.638635] [12488]     0 12488     9170      396   2       0             0 crond
[35525.638636] [12489]  1000 12489     2937      151   2       0             0 sh
[35525.638638] Out of memory: Kill process 12158 (chromium) score 331 or sacrifice child
[35525.638640] Killed process 12158 (chromium) total-vm:957260kB, anon-rss:123612kB, file-rss:1220kB
[35525.641777] urxvtd invoked oom-killer: gfp_mask=0x44d0, order=2, oom_adj=0, oom_score_adj=0
[35525.641780] urxvtd cpuset=/ mems_allowed=0
[35525.641783] Pid: 468, comm: urxvtd Tainted: G        W    3.5.4-1-ARCH #1
[35525.641784] Call Trace:
[35525.641790]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[35525.641794]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[35525.641797]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[35525.641802]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[35525.641806]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[35525.641809]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[35525.641812]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[35525.641814]  [<ffffffff81476834>] kmalloc_large_node+0x61/0x8e
[35525.641819]  [<ffffffff81166b0f>] __kmalloc_node_track_caller+0x19f/0x230
[35525.641822]  [<ffffffff8136fc51>] ? sock_alloc_send_pskb+0x1d1/0x320
[35525.641825]  [<ffffffff81374ec9>] __alloc_skb+0x79/0x230
[35525.641827]  [<ffffffff8136fc51>] sock_alloc_send_pskb+0x1d1/0x320
[35525.641830]  [<ffffffff8118cd16>] ? do_sys_poll+0x3e6/0x4c0
[35525.641833]  [<ffffffff8136fdb5>] sock_alloc_send_skb+0x15/0x20
[35525.641836]  [<ffffffff81411e8b>] unix_stream_sendmsg+0x27b/0x450
[35525.641840]  [<ffffffff8136c4a7>] sock_aio_write+0x147/0x180
[35525.641844]  [<ffffffff8136c360>] ? sock_aio_read+0x40/0x40
[35525.641847]  [<ffffffff8117952a>] do_sync_readv_writev+0xda/0x120
[35525.641852]  [<ffffffff8120567c>] ? security_file_permission+0x2c/0xb0
[35525.641857]  [<ffffffff81178c41>] ? rw_verify_area+0x61/0xf0
[35525.641859]  [<ffffffff81179814>] do_readv_writev+0xd4/0x1e0
[35525.641862]  [<ffffffff81179955>] vfs_writev+0x35/0x60
[35525.641864]  [<ffffffff81179aea>] sys_writev+0x4a/0xc0
[35525.641867]  [<ffffffff8118cecb>] ? sys_poll+0x6b/0x100
[35525.641872]  [<ffffffff814853ed>] system_call_fastpath+0x1a/0x1f
[35525.641878] Mem-Info:
[35525.641880] Node 0 DMA per-cpu:
[35525.641883] CPU    0: hi:    0, btch:   1 usd:   0
[35525.641885] CPU    1: hi:    0, btch:   1 usd:   0
[35525.641886] CPU    2: hi:    0, btch:   1 usd:   0
[35525.641888] CPU    3: hi:    0, btch:   1 usd:   0
[35525.641890] Node 0 DMA32 per-cpu:
[35525.641892] CPU    0: hi:  186, btch:  31 usd:   0
[35525.641893] CPU    1: hi:  186, btch:  31 usd:   0
[35525.641894] CPU    2: hi:  186, btch:  31 usd:   0
[35525.641895] CPU    3: hi:  186, btch:  31 usd:   0
[35525.641896] Node 0 Normal per-cpu:
[35525.641898] CPU    0: hi:  186, btch:  31 usd:   1
[35525.641899] CPU    1: hi:  186, btch:  31 usd:  28
[35525.641900] CPU    2: hi:  186, btch:  31 usd:  26
[35525.641901] CPU    3: hi:  186, btch:  31 usd:  28
[35525.641904] active_anon:575284 inactive_anon:16417 isolated_anon:27
[35525.641904]  active_file:206 inactive_file:825 isolated_file:32
[35525.641904]  unevictable:2423 dirty:1 writeback:0 unstable:0
[35525.641904]  free:34355 slab_reclaimable:322763 slab_unreclaimable:6863
[35525.641904]  mapped:4294 shmem:58035 pagetables:9128 bounce:0
[35525.641906] Node 0 DMA free:15864kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:32kB slab_unreclaimable:0kB kernel_stack:8kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[35525.641910] lowmem_reserve[]: 0 2137 3899 3899
[35525.641913] Node 0 DMA32 free:83492kB min:36900kB low:46124kB high:55348kB active_anon:1073224kB inactive_anon:13176kB active_file:488kB inactive_file:1356kB unevictable:2620kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:2620kB dirty:0kB writeback:0kB mapped:5888kB shmem:79004kB slab_reclaimable:984528kB slab_unreclaimable:6000kB kernel_stack:888kB pagetables:8772kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:3803 all_unreclaimable? yes
[35525.641917] lowmem_reserve[]: 0 0 1762 1762
[35525.641920] Node 0 Normal free:38064kB min:30416kB low:38020kB high:45624kB active_anon:1227912kB inactive_anon:52492kB active_file:336kB inactive_file:1944kB unevictable:7072kB isolated(anon):108kB isolated(file):128kB present:1804320kB mlocked:7072kB dirty:4kB writeback:0kB mapped:11288kB shmem:153136kB slab_reclaimable:306492kB slab_unreclaimable:21452kB kernel_stack:1984kB pagetables:27740kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:1824 all_unreclaimable? yes
[35525.641924] lowmem_reserve[]: 0 0 0 0
[35525.641926] Node 0 DMA: 2*4kB 0*8kB 1*16kB 3*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15864kB
[35525.641932] Node 0 DMA32: 11823*4kB 3817*8kB 241*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 83732kB
[35525.641938] Node 0 Normal: 7216*4kB 1156*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 38112kB
[35525.641944] 60074 total pagecache pages
[35525.641945] 0 pages in swap cache
[35525.641946] Swap cache stats: add 0, delete 0, find 0/0
[35525.641947] Free swap  = 0kB
[35525.641947] Total swap = 0kB
[35525.653360] 1048048 pages RAM
[35525.653363] 57533 pages reserved
[35525.653364] 95459 pages shared
[35525.653365] 922266 pages non-shared
[35525.653367] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[35525.653375] [  182]     0   182     6518      390   1     -17         -1000 systemd-udevd
[35525.653378] [  188]     0   188    71437     5283   1       0             0 systemd-journal
[35525.653382] [  318]     0   318     3303      289   2       0             0 crond
[35525.653384] [  319]     0   319    17693      641   1       0             0 cupsd
[35525.653387] [  321]     0   321    10502      304   3     -17         -1000 sshd
[35525.653390] [  322]    81   322     4351      228   3     -13          -900 dbus-daemon
[35525.653393] [  324]     0   324     6512      225   2       0             0 systemd-logind
[35525.653396] [  329]     0   329    15747      284   2       0             0 login
[35525.653398] [  332]     0   332     2031      161   3       0             0 agetty
[35525.653401] [  334]     0   334     2031      161   3       0             0 agetty
[35525.653404] [  335]     0   335     2031      160   3       0             0 agetty
[35525.653406] [  336]     0   336     2031      162   3       0             0 agetty
[35525.653409] [  337]     0   337     2031      159   3       0             0 agetty
[35525.653412] [  348]     0   348    51901     1028   2       0             0 colord
[35525.653415] [  368]     0   368   123541      992   0       0             0 colord-sane
[35525.653418] [  411]     0   411     3092      172   3       0             0 master
[35525.653421] [  414]    73   414    16374      363   2       0             0 qmgr
[35525.653424] [  423]  1000   423     3423      244   2       0             0 restart-x
[35525.653426] [  434]  1000   434     3423      259   1       0             0 startx
[35525.653429] [  451]  1000   451     3966      128   1       0             0 xinit
[35525.653432] [  452]  1000   452    57695     3506   0       0             0 X
[35525.653434] [  457]  1000   457    23894      645   3       0             0 i3
[35525.653437] [  464]  1000   464     6062      190   2       0             0 unclutter
[35525.653440] [  467]  1000   467     6004      128   2       0             0 dispad
[35525.653443] [  468]  1000   468    31324     7111   3       0             0 urxvtd
[35525.653446] [  471]  1000   471     8038      470   3       0             0 xbindkeys
[35525.653448] [  493]  1000   493     8156      609   0       0             0 zsh
[35525.653451] [  506]     0   506     8481      247   0       0             0 sudo
[35525.653453] [  510]     0   510     6933      419   3       0             0 zsh
[35525.653456] [  593]     0   593     7404      210   2       0             0 wpa_supplicant
[35525.653458] [  637]     0   637     2136      133   2       0             0 dhcpcd
[35525.653461] [  919]  1000   919     8775      719   0       0             0 zsh
[35525.653464] [  926]  1000   926     3424      230   0       0             0 lh
[35525.653467] [  928]  1000   928     8322      620   2       0             0 vim
[35525.653469] [  971]  1000   971     5163      226   2       0             0 zsh
[35525.653472] [  981]  1000   981   148137    31459   0       0             0 chromium
[35525.653475] [  987]  1000   987    64813     1227   0       0             0 chromium
[35525.653477] [  988]  1000   988     1588      119   3       0             0 chromium-sandbo
[35525.653480] [  989]  1000   989    69787     1266   0       0             0 chromium
[35525.653483] [  994]  1000   994    34743      417   0       0             0 nacl_helper_boo
[35525.653486] [  995]  1000   995    73885     1172   1       0             0 chromium
[35525.653489] [ 1032]  1000  1032     4494       94   0       0             0 dbus-launch
[35525.653491] [ 1033]  1000  1033     4320      155   3       0             0 dbus-daemon
[35525.653495] [ 1034]  1000  1034   217797     4191   0       4           300 chromium
[35525.653497] [ 1042]  1000  1042   224988    12600   2       4           300 chromium
[35525.653500] [ 1055]  1000  1055   216772     3149   1       4           300 chromium
[35525.653503] [ 1104]  1000  1104   243853    28361   1       4           300 chromium
[35525.653505] [ 1304]  1000  1304     8156      608   0       0             0 zsh
[35525.653508] [ 1320]  1000  1320     8156      624   2       0             0 zsh
[35525.653510] [ 1363]  1000  1363     9742     1661   1       0             0 zsh
[35525.653513] [ 1553]  1000  1553     9667     1583   1       0             0 zsh
[35525.653516] [ 1971]  1000  1971   241871    24412   0       4           300 chromium
[35525.653519] [ 3271]  1000  3271     9119     1067   0       0             0 zsh
[35525.653522] [ 4495]  1000  4495     9974     1947   2       0             0 zsh
[35525.653524] [ 6222]  1000  6222     8156      608   1       0             0 zsh
[35525.653527] [ 6231]     0  6231     8481      239   0       0             0 sudo
[35525.653530] [ 6232]     0  6232     6933      426   1       0             0 zsh
[35525.653532] [ 8636]  1000  8636     9742     1679   2       0             0 zsh
[35525.653535] [10677]  1000 10677     8774      698   1       0             0 zsh
[35525.653537] [11030]  1000 11030    14705      739   1       0             0 mutt
[35525.653540] [11407]  1000 11407     9042     1008   2       0             0 zsh
[35525.653543] [12800]  1000 12800   227387    10437   1       4           300 chromium
[35525.653546] [12864]  1000 12864   221397     6071   2       4           300 chromium
[35525.653548] [14270]  1000 14270     9742     1738   2       0             0 zsh
[35525.653551] [15083]  1000 15083   227316    13099   2       4           300 chromium
[35525.653553] [15161]  1000 15161     8156      665   3       0             0 zsh
[35525.653556] [15212]  1000 15212     3423      288   0       0             0 ressh.sh
[35525.653558] [16063]  1000 16063   223107     8575   1       4           300 chromium
[35525.653561] [16086]  1000 16086   223595    11217   2       4           300 chromium
[35525.653564] [16332]  1000 16332     8827      839   0       0             0 zsh
[35525.653567] [16510]  1000 16510   224510     8840   3       4           300 chromium
[35525.653569] [18144]  1000 18144     8156      671   3       0             0 zsh
[35525.653572] [31725]  1000 31725     8877      879   2       0             0 zsh
[35525.653575] [31786]  1000 31786    15089     1160   1       0             0 mutt
[35525.653578] [ 1347]  1000  1347     8156      665   1       0             0 zsh
[35525.653581] [ 1355]  1000  1355     4979     2424   3       0             0 atop
[35525.653583] [ 1910]  1000  1910     8774      774   1       0             0 zsh
[35525.653586] [ 1924]  1000  1924    14644      727   3       0             0 mutt
[35525.653588] [ 7985]  1000  7985     8290      642   2       0             0 vim
[35525.653591] [ 9011]  1000  9011   229069    12852   2       4           300 chromium
[35525.653593] [10434]  1000 10434   235759    18531   3       4           300 chromium
[35525.653596] [10979]  1000 10979   247543    29759   2       4           300 chromium
[35525.653599] [11521]  1000 11521   226701    12735   0       4           300 chromium
[35525.653601] [11530]  1000 11530   227129    12037   2       4           300 chromium
[35525.653604] [11750]  1000 11750   245983    29006   2       4           300 chromium
[35525.653606] [11939]  1000 11939     8774      778   2       0             0 zsh
[35525.653609] [11946]  1000 11946     8730     1456   1       0             0 python3
[35525.653612] [11954]  1000 11954   223107     8253   3       4           300 chromium
[35525.653615] [12000]  1000 12000   236940    22987   2       4           300 chromium
[35525.653618] [12034]  1000 12034   230495    15149   1       4           300 chromium
[35525.653621] [12168]  1000 12168   244008    28591   3       4           300 chromium
[35525.653624] [12331]  1000 12331   227906    12017   2       4           300 chromium
[35525.653626] [12950]  1000 12950     8156      689   1       0             0 zsh
[35525.653629] [14370]  1000 14370     8156      683   0       0             0 zsh
[35525.653632] [15093]  1000 15093     9059     1056   1       0             0 zsh
[35525.653635] [15512]  1000 15512   224951    10247   2       4           300 chromium
[35525.653638] [15991]  1000 15991     8302      631   1       0             0 vim
[35525.653640] [30476]  1000 30476     8787      804   0       0             0 zsh
[35525.653643] [30652]  1000 30652     8290      692   0       0             0 vim
[35525.653646] [31863]  1000 31863     8749      760   2       0             0 zsh
[35525.653649] [  511]  1000   511    19148      532   3       0             0 i3bar
[35525.653651] [  512]  1000   512     7746      285   2       0             0 i3status
[35525.653654] [  879]  1000   879   217113     2685   2       4           300 chromium
[35525.653658] [ 1345]    73  1345    16331      371   1       0             0 pickup
[35525.653660] [ 1531]  1000  1531     8156      671   0       0             0 zsh
[35525.653663] [ 3095]  1000  3095     8798      804   1       0             0 zsh
[35525.653665] [ 7615]  1000  7615     9005      363   0       0             0 ssh
[35525.653667] [ 7808]  1000  7808     9005      338   1       0             0 ssh
[35525.653670] [ 7855]  1000  7855     8970      211   3       0             0 ssh
[35525.653672] [ 7866]  1000  7866     8970      306   2       0             0 ssh
[35525.653675] [ 8307]     0  8307     8481      281   2       0             0 sudo
[35525.653678] [ 8407]     0  8407     3457      298   1       0             0 ccollect
[35525.653680] [ 8412]     0  8412     3457      204   2       0             0 ccollect
[35525.653683] [ 8413]     0  8413     3457      147   0       0             0 ccollect
[35525.653685] [ 8414]     0  8414     2919      224   0       0             0 awk
[35525.653689] [ 8863]  1000  8863     8156      666   3       0             0 zsh
[35525.653692] [ 8918]     0  8918     8482      276   2       0             0 sudo
[35525.653694] [ 8919]     0  8919     6933      443   1       0             0 zsh
[35525.653697] [ 9295]     0  9295    30145    13061   2       0             0 rsync
[35525.653699] [ 9296]     0  9296    14062     6072   0       0             0 rsync
[35525.653702] [ 9297]     0  9297    18268     7405   2       0             0 rsync
[35525.653705] [10198]     0 10198     2755      374   2       0             0 slabtop
[35525.653708] [10199]     0 10199     1504      133   3       0             0 tee
[35525.653711] [11107]  1000 11107     8775      775   1       0             0 zsh
[35525.653714] [11369]  1000 11369     3424      268   3       0             0 nz.sh
[35525.653717] [11371]  1000 11371     8388      761   2       0             0 vim
[35525.653720] [13875]  1000 13875   233159    27916   3       4           300 chromium
[35525.653722] [17237]  1000 17237     8717      704   1       0             0 zsh
[35525.653725] [17802]  1000 17802     8156      650   2       0             0 zsh
[35525.653728] [19458]  1000 19458   220482     5036   3       4           300 chromium
[35525.653731] [ 3405]  1000  3405     2749      209   2       0             0 less
[35525.653733] [11482]  1000 11482   234080    25563   3       4           300 chromium
[35525.653737] [12262]  1000 12262     8156      643   3       0             0 zsh
[35525.653739] [12269]  1000 12269    14618      633   1       0             0 mutt
[35525.653742] [12275]     0 12275     9170      396   3       0             0 crond
[35525.653745] [12277]  1000 12277     2937      212   2       0             0 sh
[35525.653748] [12280]  1000 12280    59752     2571   2       0             0 offlineimap
[35525.653751] [12327]  1000 12327   219954     4428   3       4           300 chromium
[35525.653754] [12338]  1000 12338   215748     1983   3       4           300 chromium
[35525.653757] [12436]     0 12436     2776      287   3       0             0 wpa_cli
[35525.653760] [12475]  1000 12475   232267    22770   2       4           300 chromium
[35525.653763] [12488]     0 12488     9170      396   2       0             0 crond
[35525.653765] [12489]  1000 12489     2937      298   0       0             0 sh
[35525.653768] Out of memory: Kill process 10979 (chromium) score 330 or sacrifice child
[35525.653771] Killed process 10979 (chromium) total-vm:990172kB, anon-rss:117576kB, file-rss:1460kB

--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=mounts-during-backup

proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
sys on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
dev on /dev type devtmpfs (rw,nosuid,relatime,size=1977832k,nr_inodes=494458,mode=755)
run on /run type tmpfs (rw,nosuid,nodev,relatime,mode=755)
/dev/mapper/root on / type jfs (rw,relatime)
securityfs on /sys/kernel/security type securityfs (rw,nosuid,nodev,noexec,relatime)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000)
tmpfs on /sys/fs/cgroup type tmpfs (rw,nosuid,nodev,noexec,mode=755)
cgroup on /sys/fs/cgroup/systemd type cgroup (rw,nosuid,nodev,noexec,relatime,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd)
cgroup on /sys/fs/cgroup/cpuset type cgroup (rw,nosuid,nodev,noexec,relatime,cpuset)
cgroup on /sys/fs/cgroup/cpu,cpuacct type cgroup (rw,nosuid,nodev,noexec,relatime,cpuacct,cpu)
cgroup on /sys/fs/cgroup/memory type cgroup (rw,nosuid,nodev,noexec,relatime,memory)
cgroup on /sys/fs/cgroup/devices type cgroup (rw,nosuid,nodev,noexec,relatime,devices)
cgroup on /sys/fs/cgroup/freezer type cgroup (rw,nosuid,nodev,noexec,relatime,freezer)
cgroup on /sys/fs/cgroup/net_cls type cgroup (rw,nosuid,nodev,noexec,relatime,net_cls)
cgroup on /sys/fs/cgroup/blkio type cgroup (rw,nosuid,nodev,noexec,relatime,blkio)
systemd-1 on /proc/sys/fs/binfmt_misc type autofs (rw,relatime,fd=25,pgrp=1,timeout=300,minproto=5,maxproto=5,direct)
debugfs on /sys/kernel/debug type debugfs (rw,relatime)
hugetlbfs on /dev/hugepages type hugetlbfs (rw,relatime)
mqueue on /dev/mqueue type mqueue (rw,relatime)
tmpfs on /tmp type tmpfs (rw,nosuid,nodev,relatime)
/dev/sda4 on /boot type ext4 (rw,relatime,commit=600,data=ordered)
binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc (rw,relatime)
/dev/mapper/usbhd on /home/services/usbhd type jfs (rw,relatime)

--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=slabtop6

 Active / Total Objects (% used)    : 1456769 / 1493903 (97.5%)
 Active / Total Slabs (% used)      : 104212 / 104212 (100.0%)
 Active / Total Caches (% used)     : 69 / 101 (68.3%)
 Active / Total Size (% used)       : 1546523.14K / 1553721.27K (99.5%)
 Minimum / Average / Maximum Object : 0.01K / 1.04K / 15.23K

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
1228135 1228135 100%    1.21K  95344       26   3051008K jfs_ip

  8624   8550  99%    1.00K   1421       32     45472K kmalloc-1024
 30828  30828 100%    0.55K   1101       28     17616K radix_tree_node
  8775   7239  82%    0.58K    325       27      5200K inode_cache
 20454  17306  84%    0.19K    974       21      3896K dentry
 20631  14341  69%    0.17K    897       23      3588K vm_area_struct
  2532   2355  93%    0.64K    185       24      2960K proc_inode_cache
 22816  22816 100%    0.12K    713       32      2852K jfs_mp
 20592  20367  98%    0.11K    572       36      2288K sysfs_dir_cache
 11508   9966  86%    0.19K    548       21      2192K kmalloc-192
   850    658  77%    2.00K     54       16      1728K kmalloc-2048
  6272   4313  68%    0.25K    196       32      1568K kmalloc-256
   360    286  79%    4.00K     45        8      1440K kmalloc-4096
  1872   1557  83%    0.66K     78       24      1248K shmem_inode_cache
 23970  16479  68%    0.05K    282       85      1128K shared_policy_node
   525    348  66%    2.02K     35       15      1120K task_struct       

--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=slabtop7

 Active / Total Objects (% used)    : 2103178 / 2144412 (98.1%)
 Active / Total Slabs (% used)      : 161439 / 161439 (100.0%)
 Active / Total Caches (% used)     : 69 / 101 (68.3%)
 Active / Total Size (% used)       : 2412546.38K / 2422966.80K (99.6%)
 Minimum / Average / Maximum Object : 0.01K / 1.13K / 15.23K

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
1968917 1968415  99%    1.21K 156531       26   5008992K jfs_ip
               
  8775   7234  82%    0.58K    325       27      5200K inode_cache
  2124   1577  74%    1.00K    139       32      4448K kmalloc-1024
 18648  10712  57%    0.19K    888       21      3552K dentry      
  6188   2613  42%    0.55K    221       28      3536K radix_tree_node
 15732  10682  67%    0.17K    684       23      2736K vm_area_struct
 20592  20351  98%    0.11K    572       36      2288K sysfs_dir_cache
   832    716  86%    2.00K     52       16      1664K kmalloc-2048   
  6208   3873  62%    0.25K    194       32      1552K kmalloc-256
   360    278  77%    4.00K     45        8      1440K kmalloc-4096
  1872   1594  85%    0.66K     78       24      1248K shmem_inode_cache
   495    306  61%    2.02K     33       15      1056K task_struct
  1792   1348  75%    0.50K     56       32       896K kmalloc-512            
  1092    927  84%    0.81K     28       39       896K task_xstate
   405    310  76%    2.06K     27       15       864K sighand_cache
 17425  10370  59%    0.05K    205       85       820K shared_policy_node


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=slabtop4-during-backup

 Active / Total Objects (% used)    : 1165130 / 1198087 (97.2%)
 Active / Total Slabs (% used)      : 81027 / 81027 (100.0%)
 Active / Total Caches (% used)     : 69 / 101 (68.3%)
 Active / Total Size (% used)       : 1237249.81K / 1246521.94K (99.3%)
 Minimum / Average / Maximum Object : 0.01K / 1.04K / 15.23K

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
993607 993607 100%    1.21K  75358       26   2411456K jfs_ip
  8829   7254  82%    0.58K    327       27      5232K inode_cache
  8036   2411  30%    0.55K    287       28      4592K radix_tree_node
 23920  22012  92%    0.17K   1040       23      4160K vm_area_struct
 21357  13777  64%    0.19K   1017       21      4068K dentry
 20592  20388  99%    0.11K    572       36      2288K sysfs_dir_cache
  1932   1576  81%    1.00K     63       32      2016K kmalloc-1024
   880    736  83%    2.00K     55       16      1760K kmalloc-2048
  6304   4854  76%    0.25K    197       32      1576K kmalloc-256
   368    342  92%    4.00K     46        8      1472K kmalloc-4096
  2208   2208 100%    0.64K     92       24      1472K proc_inode_cache
  1872   1574  84%    0.66K     78       24      1248K shmem_inode_cache
 25840  23394  90%    0.05K    304       85      1216K shared_policy_node
   525    401  76%    2.02K     35       15      1120K task_struct
 11546  10480  90%    0.09K    251       46      1004K anon_vma
  1092    972  89%    0.81K     28       39       896K task_xstate


--ikeVEW9yuYc//A+q--
