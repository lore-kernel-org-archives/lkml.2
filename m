Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab2GJC6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 22:58:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:7034 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966Ab2GJC6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 22:58:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="175314616"
Date: Tue, 10 Jul 2012 10:58:35 +0800
From: wfg@linux.intel.com
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [kgdb:kgdb-next] KGDB: BP remove failed: ffffffff81026ed0
Message-ID: <20120710025835.GA8600@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jason,

This HEAD commit in kgdb-next makes kgdb boot time tests freeze.
The kernel is tested inside kvm with the attached config.

3751d3e85cf693e10e2c47c03c8caa65e171099b is the first bad commit
commit 3751d3e85cf693e10e2c47c03c8caa65e171099b
Author: Jason Wessel <jason.wessel@windriver.com>
Date:   Fri Mar 23 09:35:05 2012 -0500

    x86,kgdb: Fix DEBUG_RODATA limitation using text_poke()

    There has long been a limitation using software breakpoints with a
    kernel compiled with CONFIG_DEBUG_RODATA going back to 2.6.26. For
    this particular patch, it will apply cleanly and has been tested all
    the way back to 2.6.36.

    The kprobes code uses the text_poke() function which accommodates
    writing a breakpoint into a read-only page.  The x86 kgdb code can
    solve the problem similarly by overriding the default breakpoint
    set/remove routines and using text_poke() directly.

    The x86 kgdb code will first attempt to use the traditional
    probe_kernel_write(), and next try using a the text_poke() function.
    The break point install method is tracked such that the correct break
    point removal routine will get called later on.

    Cc: x86@kernel.org
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Cc: Ingo Molnar <mingo@redhat.com>
    Cc: H. Peter Anvin <hpa@zytor.com>
    Cc: stable@vger.kernel.org # >= 2.6.36
    Inspried-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
    Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

:040000 040000 a06ac46574fcf63533d558f52c2b6b116f3c5db4 cccfa3e5eeab293de1a8b4858624fffca86dd95b M      arch
:040000 040000 5a989b035ad4054136ce69869ad4979d0ad73207 dc27a5810e1469b596dd82481c4d1a594e21f0bc M      drivers
:040000 040000 ca2ec2c143aea2a044d656b3df461a5067043b56 8980fef454edd7e18e353c81593a208badb4833f M      include
bisect run success

Thanks,
Fengguang

--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg-kvm-stoakley-27984-2012-07-10-00-02-27

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.5.0-rc4+ (wfg@bee) (gcc version 4.7.0 (Debian 4.7.1-1) ) #1 Mon Jul 9 22:58:40 CST 2012
[    0.000000] Command line: rcutorture.rcutorture_runnable=0 trinity=10m tree=asoc:for-next auth_hashtable_size=10 sunrpc.auth_hashtable_size=10 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 hung_task_panic=1 softlockup_panic=1 unknown_nmi_panic=1 nmi_watchdog=panic,lapic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2012-07-09-23-01-14-sound-asoc.for-next-34f3280-a837987-x86_64-randconfig-sound1-1-stoakley BOOT_IMAGE=kernel-tests/kernels/x86_64-randconfig-sound1/a837987e7b36a9056cd17c0967efe1ce73a102ff/vmlinuz-3.5.0-rc4+
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffcfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffd000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffbc000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0xfffd max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x0, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f8860-0x000f886f] mapped at [ffff8800000f8860]
[    0.000000]   mpc: f8870-f898c
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffcfff]
[    0.000000]  [mem 0x00000000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffcfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffcfff @ [mem 0x0e854000-0x0e8d5fff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127876(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000f8810 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffde10 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000ffffe40 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffdfd0 01E22 (v01   BXPC   BXDSDT 00000001 INTL 20090123)
[    0.000000] ACPI: FACS 000000000ffffe00 00040
[    0.000000] ACPI: SSDT 000000000fffdf80 00044 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000fffde90 0007A (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000fffde50 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 12 and 11
[    0.000000] kvm-clock: cpu 0, msr 0:162bd81, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000d400000-ffff88000d7fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffcfff]
[    0.000000] On node 0 totalpages: 65420
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3913 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 960 pages used for memmap
[    0.000000]   DMA32 zone: 60477 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1/0x1 ignored.
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] e820: [mem 0x10000000-0xfffbbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64390
[    0.000000] Kernel command line: rcutorture.rcutorture_runnable=0 trinity=10m tree=asoc:for-next auth_hashtable_size=10 sunrpc.auth_hashtable_size=10 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 hung_task_panic=1 softlockup_panic=1 unknown_nmi_panic=1 nmi_watchdog=panic,lapic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2012-07-09-23-01-14-sound-asoc.for-next-34f3280-a837987-x86_64-randconfig-sound1-1-stoakley BOOT_IMAGE=kernel-tests/kernels/x86_64-randconfig-sound1/a837987e7b36a9056cd17c0967efe1ce73a102ff/vmlinuz-3.5.0-rc4+
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 206460k/262132k available (3026k kernel code, 452k absent, 55220k reserved, 5335k data, 444k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] allocated 1048576 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] HPET counter not counting. HPET disabled
[    0.000000] Detected 2833.456 MHz processor.
[    0.020000] Calibrating delay loop (skipped) preset value.. 5666.91 BogoMIPS (lpj=28334560)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020335] Mount-cache hash table entries: 256
[    0.023820] Initializing cgroup subsys debug
[    0.025410] Initializing cgroup subsys cpuacct
[    0.027029] Initializing cgroup subsys memory
[    0.028724] Initializing cgroup subsys freezer
[    0.030018] Initializing cgroup subsys blkio
[    0.031598] Initializing cgroup subsys perf_event
[    0.033459] Disabled fast string operations
[    0.035033] CPU: Intel Common KVM processor stepping 01
[    0.040498] ACPI: Core revision 20120320
[    0.061296] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.064894] Getting VERSION: 50014
[    0.066262] Getting VERSION: 50014
[    0.067616] Getting ID: 0
[    0.068780] Getting ID: ff000000
[    0.070483] Getting LVT0: 8700
[    0.071760] Getting LVT1: 8400
[    0.073093] enabled ExtINT on CPU#0
[    0.075691] ENABLING IO-APIC IRQs
[    0.077036] init IO_APIC IRQs
[    0.078277]  apic 2 pin 0 not connected
[    0.079758] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.080035] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.082968] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.085882] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.090030] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.092884] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.095745] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.100030] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.102901] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.105760] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.108668] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.110030] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.112928] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.115912] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.120031] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.122929]  apic 2 pin 16 not connected
[    0.124407]  apic 2 pin 17 not connected
[    0.125878]  apic 2 pin 18 not connected
[    0.127355]  apic 2 pin 19 not connected
[    0.128830]  apic 2 pin 20 not connected
[    0.130004]  apic 2 pin 21 not connected
[    0.131483]  apic 2 pin 22 not connected
[    0.132955]  apic 2 pin 23 not connected
[    0.134591] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.136889] Using local APIC timer interrupts.
[    0.136889] calibrating APIC timer ...
[    0.150000] ... lapic delta = 6249044
[    0.150000] ... PM-Timer delta = 357900
[    0.150000] ... PM-Timer result ok
[    0.150000] ..... delta 6249044
[    0.150000] ..... mult: 268394396
[    0.150000] ..... calibration result: 9998470
[    0.150000] ..... CPU clock speed is 2832.8670 MHz.
[    0.150000] ..... host bus clock speed is 999.8470 MHz.
[    0.150524] device: 'platform': device_add
[    0.152354] PM: Adding info for No Bus:platform
[    0.154360] bus: 'platform': registered
[    0.156120] bus: 'cpu': registered
[    0.157661] device: 'cpu': device_add
[    0.159358] PM: Adding info for No Bus:cpu
[    0.160088] bus: 'memory': registered
[    0.161705] device: 'memory': device_add
[    0.163440] PM: Adding info for No Bus:memory
[    0.165291] device: 'memory0': device_add
[    0.167042] bus: 'memory': add device memory0
[    0.168950] PM: Adding info for memory:memory0
[    0.170107] device: 'memory1': device_add
[    0.171841] bus: 'memory': add device memory1
[    0.173729] PM: Adding info for memory:memory1
[    0.176919] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.180112] RTC time: 15:02:19, date: 07/09/12
[    0.182365] NET: Registered protocol family 16
[    0.184344] device class 'bdi': registering
[    0.186364] device class 'gpio': registering
[    0.188211] device class 'pci_bus': registering
[    0.190124] bus: 'pci': registered
[    0.191670] device class 'tty': registering
[    0.193466] device class 'vtconsole': registering
[    0.195430] device: 'vtcon0': device_add
[    0.197267] PM: Adding info for No Bus:vtcon0
[    0.200214] ACPI: bus type pci registered
[    0.201991] PCI: Using configuration type 1 for base access
[    0.204203] device: 'cpu0': device_add
[    0.205895] bus: 'cpu': add device cpu0
[    0.207627] PM: Adding info for cpu:cpu0
[    0.214239] device: 'default': device_add
[    0.216083] PM: Adding info for No Bus:default
[    0.218137] bio: create slab <bio-0> at 0
[    0.219918] device class 'block': registering
[    0.220300] ACPI: Added _OSI(Module Device)
[    0.222072] ACPI: Added _OSI(Processor Device)
[    0.223933] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.225863] ACPI: Added _OSI(Processor Aggregator Device)
[    0.232272] ACPI: EC: Look up EC in DSDT
[    0.274757] ACPI: Interpreter enabled
[    0.276596] ACPI: (supports S0 S4 S5)
[    0.278239] ACPI: Using IOAPIC for interrupt routing
[    0.280173] bus: 'acpi': registered
[    0.281753] bus: 'acpi': add driver power
[    0.283710] device: 'LNXSYSTM:00': device_add
[    0.285566] bus: 'acpi': add device LNXSYSTM:00
[    0.287526] PM: Adding info for acpi:LNXSYSTM:00
[    0.290011] device: 'LNXCPU:00': device_add
[    0.291799] bus: 'acpi': add device LNXCPU:00
[    0.293716] PM: Adding info for acpi:LNXCPU:00
[    0.295830] device: 'LNXCPU:01': device_add
[    0.297623] bus: 'acpi': add device LNXCPU:01
[    0.299532] PM: Adding info for acpi:LNXCPU:01
[    0.300606] device: 'device:00': device_add
[    0.302453] bus: 'acpi': add device device:00
[    0.304394] PM: Adding info for acpi:device:00
[    0.306916] device: 'PNP0A03:00': device_add
[    0.310026] bus: 'acpi': add device PNP0A03:00
[    0.311951] PM: Adding info for acpi:PNP0A03:00
[    0.314532] device: 'device:01': device_add
[    0.316327] bus: 'acpi': add device device:01
[    0.318244] PM: Adding info for acpi:device:01
[    0.320737] device: 'device:02': device_add
[    0.322540] bus: 'acpi': add device device:02
[    0.324473] PM: Adding info for acpi:device:02
[    0.327044] device: 'device:03': device_add
[    0.328828] bus: 'acpi': add device device:03
[    0.330110] PM: Adding info for acpi:device:03
[    0.332662] device: 'device:04': device_add
[    0.334502] bus: 'acpi': add device device:04
[    0.336400] PM: Adding info for acpi:device:04
[    0.338944] device: 'device:05': device_add
[    0.340026] bus: 'acpi': add device device:05
[    0.341946] PM: Adding info for acpi:device:05
[    0.344497] device: 'device:06': device_add
[    0.346285] bus: 'acpi': add device device:06
[    0.348204] PM: Adding info for acpi:device:06
[    0.350711] device: 'device:07': device_add
[    0.352510] bus: 'acpi': add device device:07
[    0.354436] PM: Adding info for acpi:device:07
[    0.356992] device: 'device:08': device_add
[    0.360026] bus: 'acpi': add device device:08
[    0.361931] PM: Adding info for acpi:device:08
[    0.364479] device: 'device:09': device_add
[    0.366265] bus: 'acpi': add device device:09
[    0.368182] PM: Adding info for acpi:device:09
[    0.370772] device: 'device:0a': device_add
[    0.372562] bus: 'acpi': add device device:0a
[    0.374487] PM: Adding info for acpi:device:0a
[    0.377056] device: 'device:0b': device_add
[    0.378848] bus: 'acpi': add device device:0b
[    0.380093] PM: Adding info for acpi:device:0b
[    0.382657] device: 'device:0c': device_add
[    0.384467] bus: 'acpi': add device device:0c
[    0.386367] PM: Adding info for acpi:device:0c
[    0.390158] device: 'device:0d': device_add
[    0.391946] bus: 'acpi': add device device:0d
[    0.393845] PM: Adding info for acpi:device:0d
[    0.396443] device: 'device:0e': device_add
[    0.398252] bus: 'acpi': add device device:0e
[    0.400090] PM: Adding info for acpi:device:0e
[    0.402655] device: 'device:0f': device_add
[    0.404460] bus: 'acpi': add device device:0f
[    0.406372] PM: Adding info for acpi:device:0f
[    0.408929] device: 'device:10': device_add
[    0.410026] bus: 'acpi': add device device:10
[    0.416850] PM: Adding info for acpi:device:10
[    0.420236] device: 'device:11': device_add
[    0.422043] bus: 'acpi': add device device:11
[    0.423937] PM: Adding info for acpi:device:11
[    0.426543] device: 'device:12': device_add
[    0.428388] bus: 'acpi': add device device:12
[    0.430103] PM: Adding info for acpi:device:12
[    0.432677] device: 'device:13': device_add
[    0.434487] bus: 'acpi': add device device:13
[    0.436403] PM: Adding info for acpi:device:13
[    0.438970] device: 'device:14': device_add
[    0.440033] bus: 'acpi': add device device:14
[    0.441941] PM: Adding info for acpi:device:14
[    0.444504] device: 'device:15': device_add
[    0.446290] bus: 'acpi': add device device:15
[    0.448216] PM: Adding info for acpi:device:15
[    0.450708] device: 'device:16': device_add
[    0.452512] bus: 'acpi': add device device:16
[    0.454432] PM: Adding info for acpi:device:16
[    0.456994] device: 'device:17': device_add
[    0.458780] bus: 'acpi': add device device:17
[    0.460090] PM: Adding info for acpi:device:17
[    0.462665] device: 'device:18': device_add
[    0.464465] bus: 'acpi': add device device:18
[    0.466384] PM: Adding info for acpi:device:18
[    0.470616] device: 'device:19': device_add
[    0.472407] bus: 'acpi': add device device:19
[    0.474315] PM: Adding info for acpi:device:19
[    0.476917] device: 'device:1a': device_add
[    0.478712] bus: 'acpi': add device device:1a
[    0.480105] PM: Adding info for acpi:device:1a
[    0.482682] device: 'device:1b': device_add
[    0.484480] bus: 'acpi': add device device:1b
[    0.486375] PM: Adding info for acpi:device:1b
[    0.488967] device: 'device:1c': device_add
[    0.490026] bus: 'acpi': add device device:1c
[    0.491954] PM: Adding info for acpi:device:1c
[    0.494510] device: 'device:1d': device_add
[    0.496308] bus: 'acpi': add device device:1d
[    0.498220] PM: Adding info for acpi:device:1d
[    0.500718] device: 'device:1e': device_add
[    0.502505] bus: 'acpi': add device device:1e
[    0.504430] PM: Adding info for acpi:device:1e
[    0.506989] device: 'device:1f': device_add
[    0.510026] bus: 'acpi': add device device:1f
[    0.511938] PM: Adding info for acpi:device:1f
[    0.514854] device: 'device:20': device_add
[    0.516653] bus: 'acpi': add device device:20
[    0.518557] PM: Adding info for acpi:device:20
[    0.520639] device: 'device:21': device_add
[    0.522428] bus: 'acpi': add device device:21
[    0.524345] PM: Adding info for acpi:device:21
[    0.526866] device: 'PNP0B00:00': device_add
[    0.528686] bus: 'acpi': add device PNP0B00:00
[    0.530091] PM: Adding info for acpi:PNP0B00:00
[    0.532854] device: 'PNP0303:00': device_add
[    0.534685] bus: 'acpi': add device PNP0303:00
[    0.536625] PM: Adding info for acpi:PNP0303:00
[    0.540682] device: 'PNP0F13:00': device_add
[    0.542506] bus: 'acpi': add device PNP0F13:00
[    0.544443] PM: Adding info for acpi:PNP0F13:00
[    0.547219] device: 'PNP0700:00': device_add
[    0.549057] bus: 'acpi': add device PNP0700:00
[    0.550096] PM: Adding info for acpi:PNP0700:00
[    0.554649] device: 'PNP0400:00': device_add
[    0.556467] bus: 'acpi': add device PNP0400:00
[    0.558402] PM: Adding info for acpi:PNP0400:00
[    0.561724] device: 'PNP0501:00': device_add
[    0.563562] bus: 'acpi': add device PNP0501:00
[    0.565515] PM: Adding info for acpi:PNP0501:00
[    0.568555] device: 'device:22': device_add
[    0.570027] bus: 'acpi': add device device:22
[    0.571940] PM: Adding info for acpi:device:22
[    0.574726] device: 'PNP0103:00': device_add
[    0.576547] bus: 'acpi': add device PNP0103:00
[    0.580090] PM: Adding info for acpi:PNP0103:00
[    0.583774] device: 'PNP0C0F:00': device_add
[    0.585605] bus: 'acpi': add device PNP0C0F:00
[    0.587555] PM: Adding info for acpi:PNP0C0F:00
[    0.590964] device: 'PNP0C0F:01': device_add
[    0.592781] bus: 'acpi': add device PNP0C0F:01
[    0.594718] PM: Adding info for acpi:PNP0C0F:01
[    0.598107] device: 'PNP0C0F:02': device_add
[    0.599932] bus: 'acpi': add device PNP0C0F:02
[    0.600090] PM: Adding info for acpi:PNP0C0F:02
[    0.603467] device: 'PNP0C0F:03': device_add
[    0.605292] bus: 'acpi': add device PNP0C0F:03
[    0.607238] PM: Adding info for acpi:PNP0C0F:03
[    0.610619] device: 'device:23': device_add
[    0.612463] bus: 'acpi': add device device:23
[    0.614422] PM: Adding info for acpi:device:23
[    0.616386] device: 'LNXPWRBN:00': device_add
[    0.618233] bus: 'acpi': add device LNXPWRBN:00
[    0.620183] PM: Adding info for acpi:LNXPWRBN:00
[    0.622528] bus: 'acpi': add driver ec
[    0.624412] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.628162] bus: 'acpi': add driver pci_root
[    0.630027] bus: 'acpi': driver_probe_device: matched device PNP0A03:00 with driver pci_root
[    0.633476] bus: 'acpi': really_probe: probing driver pci_root with device PNP0A03:00
[    0.636874] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.640151] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.643335] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.646450] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.650005] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    0.653361] PCI: root bus 00: using default resources
[    0.655449] device: 'pci0000:00': device_add
[    0.657373] PM: Adding info for No Bus:pci0000:00
[    0.659328] device: '0000:00': device_add
[    0.660218] PM: Adding info for No Bus:0000:00
[    0.662122] PCI host bridge to bus 0000:00
[    0.663874] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.666247] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
[    0.670069] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.672958] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.676262] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.679076] pci 0000:00:01.1: reg 20: [io  0xc000-0xc00f]
[    0.680370] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.683403] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.686523] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.690261] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.697284] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf1ffffff pref]
[    0.702599] pci 0000:00:02.0: reg 14: [mem 0xf2000000-0xf2000fff]
[    0.717063] pci 0000:00:02.0: reg 30: [mem 0xf2010000-0xf201ffff pref]
[    0.720412] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.723639] pci 0000:00:03.0: reg 10: [mem 0xf2020000-0xf203ffff]
[    0.726792] pci 0000:00:03.0: reg 14: [io  0xc040-0xc07f]
[    0.733077] pci 0000:00:03.0: reg 30: [mem 0xf2040000-0xf2047fff pref]
[    0.735817] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.738449] pci 0000:00:04.0: reg 10: [io  0xc080-0xc0bf]
[    0.740120] pci 0000:00:04.0: reg 14: [mem 0xf2048000-0xf2048fff]
[    0.743446] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.745973] pci 0000:00:05.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.748239] pci 0000:00:05.0: reg 14: [mem 0xf2049000-0xf2049fff]
[    0.750920] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.753442] pci 0000:00:06.0: reg 10: [io  0xc100-0xc13f]
[    0.755707] pci 0000:00:06.0: reg 14: [mem 0xf204a000-0xf204afff]
[    0.760484] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.763018] pci 0000:00:07.0: reg 10: [io  0xc140-0xc17f]
[    0.765303] pci 0000:00:07.0: reg 14: [mem 0xf204b000-0xf204bfff]
[    0.768739] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.770204] pci 0000:00:08.0: reg 10: [io  0xc180-0xc1bf]
[    0.772457] pci 0000:00:08.0: reg 14: [mem 0xf204c000-0xf204cfff]
[    0.775729] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.778260] pci 0000:00:09.0: reg 10: [io  0xc1c0-0xc1ff]
[    0.780115] pci 0000:00:09.0: reg 14: [mem 0xf204d000-0xf204dfff]
[    0.783389] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.785871] pci 0000:00:0a.0: reg 10: [mem 0xf204e000-0xf204e00f]
[    0.790806] pci_bus 0000:00: on NUMA node 0
[    0.792716] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.811875]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.815055] device: '0000:00:00.0': device_add
[    0.829446] bus: 'pci': add device 0000:00:00.0
[    0.830263] PM: Adding info for pci:0000:00:00.0
[    0.832250] device: '0000:00:01.0': device_add
[    0.847968] bus: 'pci': add device 0000:00:01.0
[    0.850116] PM: Adding info for pci:0000:00:01.0
[    0.852062] device: '0000:00:01.1': device_add
[    0.866347] bus: 'pci': add device 0000:00:01.1
[    0.868445] PM: Adding info for pci:0000:00:01.1
[    0.870049] device: '0000:00:01.3': device_add
[    0.884618] bus: 'pci': add device 0000:00:01.3
[    0.886721] PM: Adding info for pci:0000:00:01.3
[    0.888679] device: '0000:00:02.0': device_add
[    0.903002] bus: 'pci': add device 0000:00:02.0
[    0.905103] PM: Adding info for pci:0000:00:02.0
[    0.907033] device: '0000:00:03.0': device_add
[    0.921372] bus: 'pci': add device 0000:00:03.0
[    0.923530] PM: Adding info for pci:0000:00:03.0
[    0.925460] device: '0000:00:04.0': device_add
[    0.939774] bus: 'pci': add device 0000:00:04.0
[    0.940228] PM: Adding info for pci:0000:00:04.0
[    0.947088] device: '0000:00:05.0': device_add
[    0.963125] bus: 'pci': add device 0000:00:05.0
[    0.965222] PM: Adding info for pci:0000:00:05.0
[    0.967176] device: '0000:00:06.0': device_add
[    0.981502] bus: 'pci': add device 0000:00:06.0
[    0.983610] PM: Adding info for pci:0000:00:06.0
[    0.985660] device: '0000:00:07.0': device_add
[    0.999974] bus: 'pci': add device 0000:00:07.0
[    1.000238] PM: Adding info for pci:0000:00:07.0
[    1.002162] device: '0000:00:08.0': device_add
[    1.018376] bus: 'pci': add device 0000:00:08.0
[    1.020214] PM: Adding info for pci:0000:00:08.0
[    1.022155] device: '0000:00:09.0': device_add
[    1.036786] bus: 'pci': add device 0000:00:09.0
[    1.038884] PM: Adding info for pci:0000:00:09.0
[    1.040050] device: '0000:00:0a.0': device_add
[    1.055131] bus: 'pci': add device 0000:00:0a.0
[    1.057349] PM: Adding info for pci:0000:00:0a.0
[    1.059282] driver: 'PNP0A03:00': driver_bound: bound to device 'pci_root'
[    1.060055] bus: 'acpi': really_probe: bound device PNP0A03:00 to driver pci_root
[    1.063327] bus: 'acpi': add driver pci_link
[    1.065291] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 with driver pci_link
[    1.070005] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:00
[    1.074274] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.076757] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_link'
[    1.080006] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver pci_link
[    1.083125] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 with driver pci_link
[    1.086540] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:01
[    1.090758] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.093232] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_link'
[    1.095809] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver pci_link
[    1.098929] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 with driver pci_link
[    1.100010] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:02
[    1.104151] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.106680] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_link'
[    1.110006] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver pci_link
[    1.113167] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 with driver pci_link
[    1.116592] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:03
[    1.120898] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.123368] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_link'
[    1.125955] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver pci_link
[    1.130169] bus: 'pnp': registered
[    1.131811] device class 'misc': registering
[    1.133807] device: 'vga_arbiter': device_add
[    1.135800] PM: Adding info for No Bus:vga_arbiter
[    1.137908] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.140082] vgaarb: loaded
[    1.141407] vgaarb: bridge control possible 0000:00:02.0
[    1.143627] bus: 'serio': registered
[    1.145226] device class 'input': registering
[    1.147176] device class 'rtc': registering
[    1.150066] device class 'watchdog': registering
[    1.152047] device class 'devfreq': registering
[    1.153959] PCI: Using ACPI for IRQ routing
[    1.155727] PCI: pci_cache_line_size set to 64 bytes
[    1.158438] e820: reserve RAM buffer [mem 0x0009f400-0x0009ffff]
[    1.160028] e820: reserve RAM buffer [mem 0x0fffd000-0x0fffffff]
[    1.162483] device class 'net': registering
[    1.164477] device: 'lo': device_add
[    1.166580] PM: Adding info for No Bus:lo
[    1.170658] Switching to clocksource kvm-clock
[    1.173038] bus: 'pnp': add driver system
[    1.174839] pnp: PnP ACPI init
[    1.176292] device: 'pnp0': device_add
[    1.178053] PM: Adding info for No Bus:pnp0
[    1.179815] ACPI: bus type pnp registered
[    1.180000] pnp 00:00: [bus 00-ff]
[    1.180826] pnp 00:00: [io  0x0cf8-0x0cff]
[    1.182565] pnp 00:00: [io  0x0000-0x0cf7 window]
[    1.184504] pnp 00:00: [io  0x0d00-0xffff window]
[    1.186435] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    1.188565] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    1.190705] device: '00:00': device_add
[    1.192518] bus: 'pnp': add device 00:00
[    1.194346] PM: Adding info for pnp:00:00
[    1.196095] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    1.199705] pnp 00:01: [io  0x0070-0x0071]
[    1.201503] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    1.204806] pnp 00:01: [irq 8]
[    1.206239] pnp 00:01: [io  0x0072-0x0077]
[    1.207988] device: '00:01': device_add
[    1.209774] bus: 'pnp': add device 00:01
[    1.211607] PM: Adding info for pnp:00:01
[    1.213361] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.216338] pnp 00:02: [io  0x0060]
[    1.217924] pnp 00:02: [io  0x0064]
[    1.219493] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    1.222827] pnp 00:02: [irq 1]
[    1.224270] device: '00:02': device_add
[    1.226049] bus: 'pnp': add device 00:02
[    1.227863] PM: Adding info for pnp:00:02
[    1.229612] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.232618] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    1.235954] pnp 00:03: [irq 12]
[    1.237424] device: '00:03': device_add
[    1.239208] bus: 'pnp': add device 00:03
[    1.241045] PM: Adding info for pnp:00:03
[    1.242792] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.245709] pnp 00:04: [io  0x03f2-0x03f5]
[    1.247475] pnp 00:04: [io  0x03f7]
[    1.249033] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    1.252358] pnp 00:04: [irq 6]
[    1.253795] pnp 00:04: [dma 2]
[    1.255235] device: '00:04': device_add
[    1.257021] bus: 'pnp': add device 00:04
[    1.258836] PM: Adding info for pnp:00:04
[    1.260602] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.263921] pnp 00:05: [io  0x0378-0x037f]
[    1.265713] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    1.268982] pnp 00:05: [irq 7]
[    1.270447] device: '00:05': device_add
[    1.272241] bus: 'pnp': add device 00:05
[    1.274064] PM: Adding info for pnp:00:05
[    1.275809] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.279088] pnp 00:06: [io  0x03f8-0x03ff]
[    1.280859] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    1.284141] pnp 00:06: [irq 4]
[    1.285605] device: '00:06': device_add
[    1.287382] bus: 'pnp': add device 00:06
[    1.289208] PM: Adding info for pnp:00:06
[    1.290845] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.294312] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    1.296276] device: '00:07': device_add
[    1.298059] bus: 'pnp': add device 00:07
[    1.299853] PM: Adding info for pnp:00:07
[    1.301621] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.306040] pnp: PnP ACPI: found 8 devices
[    1.307787] ACPI: ACPI bus type pnp unregistered
[    1.309724] device class 'mem': registering
[    1.311575] device: 'mem': device_add
[    1.313355] PM: Adding info for No Bus:mem
[    1.315157] device: 'kmem': device_add
[    1.316926] PM: Adding info for No Bus:kmem
[    1.318768] device: 'null': device_add
[    1.320553] PM: Adding info for No Bus:null
[    1.322395] device: 'port': device_add
[    1.324218] PM: Adding info for No Bus:port
[    1.326030] device: 'zero': device_add
[    1.327804] PM: Adding info for No Bus:zero
[    1.329618] device: 'full': device_add
[    1.331399] PM: Adding info for No Bus:full
[    1.333211] device: 'random': device_add
[    1.335043] PM: Adding info for No Bus:random
[    1.336904] device: 'urandom': device_add
[    1.338741] PM: Adding info for No Bus:urandom
[    1.340653] device: 'kmsg': device_add
[    1.342414] PM: Adding info for No Bus:kmsg
[    1.344254] device: 'tty': device_add
[    1.346003] PM: Adding info for No Bus:tty
[    1.347863] device: 'console': device_add
[    1.349721] PM: Adding info for No Bus:console
[    1.351653] device: 'tty0': device_add
[    1.353408] PM: Adding info for No Bus:tty0
[    1.355373] device class 'vc': registering
[    1.357174] device: 'vcs': device_add
[    1.358938] PM: Adding info for No Bus:vcs
[    1.360755] device: 'vcsa': device_add
[    1.362520] PM: Adding info for No Bus:vcsa
[    1.364336] device: 'vcs1': device_add
[    1.366097] PM: Adding info for No Bus:vcs1
[    1.372857] device: 'vcsa1': device_add
[    1.374671] PM: Adding info for No Bus:vcsa1
[    1.376586] device: 'tty1': device_add
[    1.378360] PM: Adding info for No Bus:tty1
[    1.380184] device: 'tty2': device_add
[    1.381964] PM: Adding info for No Bus:tty2
[    1.383834] device: 'tty3': device_add
[    1.385646] PM: Adding info for No Bus:tty3
[    1.387504] device: 'tty4': device_add
[    1.389270] PM: Adding info for No Bus:tty4
[    1.391062] device: 'tty5': device_add
[    1.392868] PM: Adding info for No Bus:tty5
[    1.394673] device: 'tty6': device_add
[    1.396435] PM: Adding info for No Bus:tty6
[    1.398260] device: 'tty7': device_add
[    1.400027] PM: Adding info for No Bus:tty7
[    1.401864] device: 'tty8': device_add
[    1.403615] PM: Adding info for No Bus:tty8
[    1.405433] device: 'tty9': device_add
[    1.407322] PM: Adding info for No Bus:tty9
[    1.409112] device: 'tty10': device_add
[    1.410928] PM: Adding info for No Bus:tty10
[    1.412871] device: 'tty11': device_add
[    1.414652] PM: Adding info for No Bus:tty11
[    1.416547] device: 'tty12': device_add
[    1.418357] PM: Adding info for No Bus:tty12
[    1.420183] device: 'tty13': device_add
[    1.421987] PM: Adding info for No Bus:tty13
[    1.423825] device: 'tty14': device_add
[    1.425627] PM: Adding info for No Bus:tty14
[    1.427461] device: 'tty15': device_add
[    1.429252] PM: Adding info for No Bus:tty15
[    1.431088] device: 'tty16': device_add
[    1.432910] PM: Adding info for No Bus:tty16
[    1.434758] device: 'tty17': device_add
[    1.436551] PM: Adding info for No Bus:tty17
[    1.438398] device: 'tty18': device_add
[    1.440194] PM: Adding info for No Bus:tty18
[    1.442090] device: 'tty19': device_add
[    1.443892] PM: Adding info for No Bus:tty19
[    1.445738] device: 'tty20': device_add
[    1.447591] PM: Adding info for No Bus:tty20
[    1.449479] device: 'tty21': device_add
[    1.451286] PM: Adding info for No Bus:tty21
[    1.453119] device: 'tty22': device_add
[    1.454923] PM: Adding info for No Bus:tty22
[    1.456785] device: 'tty23': device_add
[    1.458570] PM: Adding info for No Bus:tty23
[    1.460423] device: 'tty24': device_add
[    1.462221] PM: Adding info for No Bus:tty24
[    1.464050] device: 'tty25': device_add
[    1.465830] PM: Adding info for No Bus:tty25
[    1.467670] device: 'tty26': device_add
[    1.469462] PM: Adding info for No Bus:tty26
[    1.471378] device: 'tty27': device_add
[    1.473165] PM: Adding info for No Bus:tty27
[    1.474993] device: 'tty28': device_add
[    1.476801] PM: Adding info for No Bus:tty28
[    1.478686] device: 'tty29': device_add
[    1.480489] PM: Adding info for No Bus:tty29
[    1.482319] device: 'tty30': device_add
[    1.484107] PM: Adding info for No Bus:tty30
[    1.485944] device: 'tty31': device_add
[    1.487722] PM: Adding info for No Bus:tty31
[    1.489558] device: 'tty32': device_add
[    1.491369] PM: Adding info for No Bus:tty32
[    1.493186] device: 'tty33': device_add
[    1.494984] PM: Adding info for No Bus:tty33
[    1.496817] device: 'tty34': device_add
[    1.498598] PM: Adding info for No Bus:tty34
[    1.500492] device: 'tty35': device_add
[    1.502297] PM: Adding info for No Bus:tty35
[    1.504141] device: 'tty36': device_add
[    1.505922] PM: Adding info for No Bus:tty36
[    1.507777] device: 'tty37': device_add
[    1.509643] PM: Adding info for No Bus:tty37
[    1.511515] device: 'tty38': device_add
[    1.513302] PM: Adding info for No Bus:tty38
[    1.515151] device: 'tty39': device_add
[    1.516949] PM: Adding info for No Bus:tty39
[    1.518791] device: 'tty40': device_add
[    1.520599] PM: Adding info for No Bus:tty40
[    1.522442] device: 'tty41': device_add
[    1.524234] PM: Adding info for No Bus:tty41
[    1.526092] device: 'tty42': device_add
[    1.527886] PM: Adding info for No Bus:tty42
[    1.529766] device: 'tty43': device_add
[    1.531593] PM: Adding info for No Bus:tty43
[    1.533432] device: 'tty44': device_add
[    1.535226] PM: Adding info for No Bus:tty44
[    1.537054] device: 'tty45': device_add
[    1.538852] PM: Adding info for No Bus:tty45
[    1.540819] device: 'tty46': device_add
[    1.542605] PM: Adding info for No Bus:tty46
[    1.544453] device: 'tty47': device_add
[    1.546273] PM: Adding info for No Bus:tty47
[    1.548095] device: 'tty48': device_add
[    1.549877] PM: Adding info for No Bus:tty48
[    1.551742] device: 'tty49': device_add
[    1.553538] PM: Adding info for No Bus:tty49
[    1.555368] device: 'tty50': device_add
[    1.557149] PM: Adding info for No Bus:tty50
[    1.559022] device: 'tty51': device_add
[    1.560807] PM: Adding info for No Bus:tty51
[    1.562677] device: 'tty52': device_add
[    1.564468] PM: Adding info for No Bus:tty52
[    1.566323] device: 'tty53': device_add
[    1.568118] PM: Adding info for No Bus:tty53
[    1.569955] device: 'tty54': device_add
[    1.571865] PM: Adding info for No Bus:tty54
[    1.573729] device: 'tty55': device_add
[    1.575524] PM: Adding info for No Bus:tty55
[    1.577372] device: 'tty56': device_add
[    1.579140] PM: Adding info for No Bus:tty56
[    1.580982] device: 'tty57': device_add
[    1.582820] PM: Adding info for No Bus:tty57
[    1.584657] device: 'tty58': device_add
[    1.586451] PM: Adding info for No Bus:tty58
[    1.588338] device: 'tty59': device_add
[    1.590119] PM: Adding info for No Bus:tty59
[    1.591977] device: 'tty60': device_add
[    1.593780] PM: Adding info for No Bus:tty60
[    1.595624] device: 'tty61': device_add
[    1.597394] PM: Adding info for No Bus:tty61
[    1.599251] device: 'tty62': device_add
[    1.601052] PM: Adding info for No Bus:tty62
[    1.603006] device: 'tty63': device_add
[    1.604806] PM: Adding info for No Bus:tty63
[    1.606849] device class 'firmware': registering
[    1.618944] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    1.621196] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[    1.623838] NET: Registered protocol family 2
[    1.625928] IP route cache hash table entries: 2048 (order: 2, 16384 bytes)
[    1.629438] TCP established hash table entries: 8192 (order: 5, 131072 bytes)
[    1.632518] TCP bind hash table entries: 8192 (order: 7, 655360 bytes)
[    1.636958] TCP: Hash tables configured (established 8192 bind 8192)
[    1.639397] TCP: reno registered
[    1.640923] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    1.643352] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    1.646289] NET: Registered protocol family 1
[    1.648200] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.650535] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.652856] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.655333] pci 0000:00:02.0: Boot video device
[    1.657421] PCI: CLS 0 bytes, default 64
[    1.659663] Unpacking initramfs...
[    2.902527] Freeing initrd memory: 23656k freed
[    2.933590] Registering platform device 'pcspkr'. Parent at platform
[    2.936163] device: 'pcspkr': device_add
[    2.937913] bus: 'platform': add device pcspkr
[    2.939838] PM: Adding info for platform:pcspkr
[    2.980719] device: 'snapshot': device_add
[    2.985804] PM: Adding info for No Bus:snapshot
[    2.987856] bus: 'clocksource': registered
[    2.989616] device: 'clocksource': device_add
[    2.991518] PM: Adding info for No Bus:clocksource
[    2.993482] device: 'clocksource0': device_add
[    2.995348] bus: 'clocksource': add device clocksource0
[    2.997600] PM: Adding info for clocksource:clocksource0
[    2.999780] bus: 'platform': add driver alarmtimer
[    3.001873] Registering platform device 'alarmtimer'. Parent at platform
[    3.004395] device: 'alarmtimer': device_add
[    3.006222] bus: 'platform': add device alarmtimer
[    3.008252] PM: Adding info for platform:alarmtimer
[    3.010247] bus: 'platform': driver_probe_device: matched device alarmtimer with driver alarmtimer
[    3.013836] bus: 'platform': really_probe: probing driver alarmtimer with device alarmtimer
[    3.017254] driver: 'alarmtimer': driver_bound: bound to device 'alarmtimer'
[    3.019881] bus: 'platform': really_probe: bound device alarmtimer to driver alarmtimer
[    3.023369] bus: 'rttest': registered
[    3.025001] device: 'rttest': device_add
[    3.026738] PM: Adding info for No Bus:rttest
[    3.029055] device: 'rttest0': device_add
[    3.030831] bus: 'rttest': add device rttest0
[    3.032749] PM: Adding info for rttest:rttest0
[    3.034764] device: 'rttest1': device_add
[    3.036522] bus: 'rttest': add device rttest1
[    3.038416] PM: Adding info for rttest:rttest1
[    3.045368] device: 'rttest2': device_add
[    3.047112] bus: 'rttest': add device rttest2
[    3.049000] PM: Adding info for rttest:rttest2
[    3.051006] device: 'rttest3': device_add
[    3.052787] bus: 'rttest': add device rttest3
[    3.054667] PM: Adding info for rttest:rttest3
[    3.056643] device: 'rttest4': device_add
[    3.058462] bus: 'rttest': add device rttest4
[    3.060388] PM: Adding info for rttest:rttest4
[    3.062416] device: 'rttest5': device_add
[    3.064198] bus: 'rttest': add device rttest5
[    3.066080] PM: Adding info for rttest:rttest5
[    3.068062] device: 'rttest6': device_add
[    3.069795] bus: 'rttest': add device rttest6
[    3.071713] PM: Adding info for rttest:rttest6
[    3.073668] device: 'rttest7': device_add
[    3.075412] bus: 'rttest': add device rttest7
[    3.077297] PM: Adding info for rttest:rttest7
[    3.079176] Initializing RT-Tester: OK
[    3.091408] bus: 'event_source': registered
[    3.093247] device: 'breakpoint': device_add
[    3.095152] bus: 'event_source': add device breakpoint
[    3.097282] PM: Adding info for event_source:breakpoint
[    3.099412] device: 'software': device_add
[    3.101211] bus: 'event_source': add device software
[    3.103278] PM: Adding info for event_source:software
[    3.105801] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.131265] VFS: Disk quotas dquot_6.5.2
[    3.133436] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.137656] device class 'bsg': registering
[    3.139580] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    3.143014] io scheduler noop registered (default)
[    3.145101] bus: 'pci': add driver langwell_gpio
[    3.147198] bus: 'platform': add driver wp_gpio
[    3.149425] device: 'ptyp0': device_add
[    3.151310] PM: Adding info for No Bus:ptyp0
[    3.153293] device: 'ptyp1': device_add
[    3.155145] PM: Adding info for No Bus:ptyp1
[    3.157074] device: 'ptyp2': device_add
[    3.158787] PM: Adding info for No Bus:ptyp2
[    3.160402] device: 'ptyp3': device_add
[    3.161981] PM: Adding info for No Bus:ptyp3
[    3.163854] device: 'ptyp4': device_add
[    3.165617] PM: Adding info for No Bus:ptyp4
[    3.167560] device: 'ptyp5': device_add
[    3.169413] PM: Adding info for No Bus:ptyp5
[    3.171366] device: 'ptyp6': device_add
[    3.173208] PM: Adding info for No Bus:ptyp6
[    3.175139] device: 'ptyp7': device_add
[    3.176995] PM: Adding info for No Bus:ptyp7
[    3.178919] device: 'ptyp8': device_add
[    3.180788] PM: Adding info for No Bus:ptyp8
[    3.182770] device: 'ptyp9': device_add
[    3.184653] PM: Adding info for No Bus:ptyp9
[    3.186256] device: 'ptypa': device_add
[    3.187800] PM: Adding info for No Bus:ptypa
[    3.189728] device: 'ptypb': device_add
[    3.191604] PM: Adding info for No Bus:ptypb
[    3.193223] device: 'ptypc': device_add
[    3.194771] PM: Adding info for No Bus:ptypc
[    3.196708] device: 'ptypd': device_add
[    3.198520] PM: Adding info for No Bus:ptypd
[    3.200463] device: 'ptype': device_add
[    3.202353] PM: Adding info for No Bus:ptype
[    3.204288] device: 'ptypf': device_add
[    3.205954] PM: Adding info for No Bus:ptypf
[    3.207548] device: 'ptyq0': device_add
[    3.209348] PM: Adding info for No Bus:ptyq0
[    3.211304] device: 'ptyq1': device_add
[    3.212966] PM: Adding info for No Bus:ptyq1
[    3.214978] device: 'ptyq2': device_add
[    3.216824] PM: Adding info for No Bus:ptyq2
[    3.218641] device: 'ptyq3': device_add
[    3.220225] PM: Adding info for No Bus:ptyq3
[    3.222011] device: 'ptyq4': device_add
[    3.223868] PM: Adding info for No Bus:ptyq4
[    3.225674] device: 'ptyq5': device_add
[    3.227337] PM: Adding info for No Bus:ptyq5
[    3.229265] device: 'ptyq6': device_add
[    3.231138] PM: Adding info for No Bus:ptyq6
[    3.233057] device: 'ptyq7': device_add
[    3.234916] PM: Adding info for No Bus:ptyq7
[    3.236855] device: 'ptyq8': device_add
[    3.238624] PM: Adding info for No Bus:ptyq8
[    3.240418] device: 'ptyq9': device_add
[    3.242270] PM: Adding info for No Bus:ptyq9
[    3.244201] device: 'ptyqa': device_add
[    3.246102] PM: Adding info for No Bus:ptyqa
[    3.248030] device: 'ptyqb': device_add
[    3.249897] PM: Adding info for No Bus:ptyqb
[    3.251857] device: 'ptyqc': device_add
[    3.253703] PM: Adding info for No Bus:ptyqc
[    3.255547] device: 'ptyqd': device_add
[    3.257097] PM: Adding info for No Bus:ptyqd
[    3.258814] device: 'ptyqe': device_add
[    3.260361] PM: Adding info for No Bus:ptyqe
[    3.261980] device: 'ptyqf': device_add
[    3.263825] PM: Adding info for No Bus:ptyqf
[    3.265641] device: 'ptyr0': device_add
[    3.267197] PM: Adding info for No Bus:ptyr0
[    3.268914] device: 'ptyr1': device_add
[    3.270457] PM: Adding info for No Bus:ptyr1
[    3.272406] device: 'ptyr2': device_add
[    3.273961] PM: Adding info for No Bus:ptyr2
[    3.275696] device: 'ptyr3': device_add
[    3.277450] PM: Adding info for No Bus:ptyr3
[    3.279278] device: 'ptyr4': device_add
[    3.281054] PM: Adding info for No Bus:ptyr4
[    3.282878] device: 'ptyr5': device_add
[    3.284633] PM: Adding info for No Bus:ptyr5
[    3.286469] device: 'ptyr6': device_add
[    3.288251] PM: Adding info for No Bus:ptyr6
[    3.290078] device: 'ptyr7': device_add
[    3.291873] PM: Adding info for No Bus:ptyr7
[    3.293699] device: 'ptyr8': device_add
[    3.295459] PM: Adding info for No Bus:ptyr8
[    3.297292] device: 'ptyr9': device_add
[    3.299055] PM: Adding info for No Bus:ptyr9
[    3.300914] device: 'ptyra': device_add
[    3.302683] PM: Adding info for No Bus:ptyra
[    3.304530] device: 'ptyrb': device_add
[    3.306295] PM: Adding info for No Bus:ptyrb
[    3.308168] device: 'ptyrc': device_add
[    3.309956] PM: Adding info for No Bus:ptyrc
[    3.311803] device: 'ptyrd': device_add
[    3.313564] PM: Adding info for No Bus:ptyrd
[    3.315398] device: 'ptyre': device_add
[    3.317160] PM: Adding info for No Bus:ptyre
[    3.318992] device: 'ptyrf': device_add
[    3.320743] PM: Adding info for No Bus:ptyrf
[    3.322611] device: 'ptys0': device_add
[    3.324377] PM: Adding info for No Bus:ptys0
[    3.326203] device: 'ptys1': device_add
[    3.327973] PM: Adding info for No Bus:ptys1
[    3.329801] device: 'ptys2': device_add
[    3.331585] PM: Adding info for No Bus:ptys2
[    3.333430] device: 'ptys3': device_add
[    3.335192] PM: Adding info for No Bus:ptys3
[    3.337032] device: 'ptys4': device_add
[    3.338836] PM: Adding info for No Bus:ptys4
[    3.340682] device: 'ptys5': device_add
[    3.342525] PM: Adding info for No Bus:ptys5
[    3.344371] device: 'ptys6': device_add
[    3.346139] PM: Adding info for No Bus:ptys6
[    3.348011] device: 'ptys7': device_add
[    3.349772] PM: Adding info for No Bus:ptys7
[    3.351630] device: 'ptys8': device_add
[    3.353391] PM: Adding info for No Bus:ptys8
[    3.355228] device: 'ptys9': device_add
[    3.357002] PM: Adding info for No Bus:ptys9
[    3.358851] device: 'ptysa': device_add
[    3.360608] PM: Adding info for No Bus:ptysa
[    3.362478] device: 'ptysb': device_add
[    3.364350] PM: Adding info for No Bus:ptysb
[    3.366186] device: 'ptysc': device_add
[    3.367991] PM: Adding info for No Bus:ptysc
[    3.369862] device: 'ptysd': device_add
[    3.371643] PM: Adding info for No Bus:ptysd
[    3.373476] device: 'ptyse': device_add
[    3.375248] PM: Adding info for No Bus:ptyse
[    3.377074] device: 'ptysf': device_add
[    3.378841] PM: Adding info for No Bus:ptysf
[    3.380676] device: 'ptyt0': device_add
[    3.382475] PM: Adding info for No Bus:ptyt0
[    3.384327] device: 'ptyt1': device_add
[    3.386095] PM: Adding info for No Bus:ptyt1
[    3.387929] device: 'ptyt2': device_add
[    3.389692] PM: Adding info for No Bus:ptyt2
[    3.391558] device: 'ptyt3': device_add
[    3.393318] PM: Adding info for No Bus:ptyt3
[    3.395161] device: 'ptyt4': device_add
[    3.396916] PM: Adding info for No Bus:ptyt4
[    3.398735] device: 'ptyt5': device_add
[    3.400588] PM: Adding info for No Bus:ptyt5
[    3.402460] device: 'ptyt6': device_add
[    3.404219] PM: Adding info for No Bus:ptyt6
[    3.406044] device: 'ptyt7': device_add
[    3.407803] PM: Adding info for No Bus:ptyt7
[    3.409642] device: 'ptyt8': device_add
[    3.416370] PM: Adding info for No Bus:ptyt8
[    3.418199] device: 'ptyt9': device_add
[    3.419975] PM: Adding info for No Bus:ptyt9
[    3.421833] device: 'ptyta': device_add
[    3.423591] PM: Adding info for No Bus:ptyta
[    3.425426] device: 'ptytb': device_add
[    3.427209] PM: Adding info for No Bus:ptytb
[    3.429041] device: 'ptytc': device_add
[    3.430882] PM: Adding info for No Bus:ptytc
[    3.432696] device: 'ptytd': device_add
[    3.434456] PM: Adding info for No Bus:ptytd
[    3.436284] device: 'ptyte': device_add
[    3.438057] PM: Adding info for No Bus:ptyte
[    3.439879] device: 'ptytf': device_add
[    3.441653] PM: Adding info for No Bus:ptytf
[    3.443481] device: 'ptyu0': device_add
[    3.445245] PM: Adding info for No Bus:ptyu0
[    3.447069] device: 'ptyu1': device_add
[    3.448830] PM: Adding info for No Bus:ptyu1
[    3.450650] device: 'ptyu2': device_add
[    3.452443] PM: Adding info for No Bus:ptyu2
[    3.454279] device: 'ptyu3': device_add
[    3.456038] PM: Adding info for No Bus:ptyu3
[    3.457862] device: 'ptyu4': device_add
[    3.459618] PM: Adding info for No Bus:ptyu4
[    3.461527] device: 'ptyu5': device_add
[    3.463345] PM: Adding info for No Bus:ptyu5
[    3.465168] device: 'ptyu6': device_add
[    3.466936] PM: Adding info for No Bus:ptyu6
[    3.468760] device: 'ptyu7': device_add
[    3.470519] PM: Adding info for No Bus:ptyu7
[    3.472389] device: 'ptyu8': device_add
[    3.474157] PM: Adding info for No Bus:ptyu8
[    3.475980] device: 'ptyu9': device_add
[    3.477732] PM: Adding info for No Bus:ptyu9
[    3.479555] device: 'ptyua': device_add
[    3.481338] PM: Adding info for No Bus:ptyua
[    3.483171] device: 'ptyub': device_add
[    3.484936] PM: Adding info for No Bus:ptyub
[    3.486762] device: 'ptyuc': device_add
[    3.488532] PM: Adding info for No Bus:ptyuc
[    3.490383] device: 'ptyud': device_add
[    3.492145] PM: Adding info for No Bus:ptyud
[    3.494086] device: 'ptyue': device_add
[    3.495859] PM: Adding info for No Bus:ptyue
[    3.497691] device: 'ptyuf': device_add
[    3.499449] PM: Adding info for No Bus:ptyuf
[    3.501308] device: 'ptyv0': device_add
[    3.503072] PM: Adding info for No Bus:ptyv0
[    3.504900] device: 'ptyv1': device_add
[    3.506672] PM: Adding info for No Bus:ptyv1
[    3.508514] device: 'ptyv2': device_add
[    3.510288] PM: Adding info for No Bus:ptyv2
[    3.512117] device: 'ptyv3': device_add
[    3.513893] PM: Adding info for No Bus:ptyv3
[    3.515716] device: 'ptyv4': device_add
[    3.517482] PM: Adding info for No Bus:ptyv4
[    3.519316] device: 'ptyv5': device_add
[    3.521105] PM: Adding info for No Bus:ptyv5
[    3.522930] device: 'ptyv6': device_add
[    3.524754] PM: Adding info for No Bus:ptyv6
[    3.526582] device: 'ptyv7': device_add
[    3.528360] PM: Adding info for No Bus:ptyv7
[    3.530193] device: 'ptyv8': device_add
[    3.531973] PM: Adding info for No Bus:ptyv8
[    3.533810] device: 'ptyv9': device_add
[    3.535566] PM: Adding info for No Bus:ptyv9
[    3.537395] device: 'ptyva': device_add
[    3.539158] PM: Adding info for No Bus:ptyva
[    3.541007] device: 'ptyvb': device_add
[    3.542769] PM: Adding info for No Bus:ptyvb
[    3.544611] device: 'ptyvc': device_add
[    3.546400] PM: Adding info for No Bus:ptyvc
[    3.548229] device: 'ptyvd': device_add
[    3.549988] PM: Adding info for No Bus:ptyvd
[    3.551854] device: 'ptyve': device_add
[    3.553620] PM: Adding info for No Bus:ptyve
[    3.555564] device: 'ptyvf': device_add
[    3.557327] PM: Adding info for No Bus:ptyvf
[    3.559158] device: 'ptyw0': device_add
[    3.560936] PM: Adding info for No Bus:ptyw0
[    3.562760] device: 'ptyw1': device_add
[    3.564530] PM: Adding info for No Bus:ptyw1
[    3.566359] device: 'ptyw2': device_add
[    3.568117] PM: Adding info for No Bus:ptyw2
[    3.569943] device: 'ptyw3': device_add
[    3.571722] PM: Adding info for No Bus:ptyw3
[    3.573550] device: 'ptyw4': device_add
[    3.575318] PM: Adding info for No Bus:ptyw4
[    3.577148] device: 'ptyw5': device_add
[    3.578920] PM: Adding info for No Bus:ptyw5
[    3.580738] device: 'ptyw6': device_add
[    3.582534] PM: Adding info for No Bus:ptyw6
[    3.584366] device: 'ptyw7': device_add
[    3.586170] PM: Adding info for No Bus:ptyw7
[    3.588054] device: 'ptyw8': device_add
[    3.589826] PM: Adding info for No Bus:ptyw8
[    3.591675] device: 'ptyw9': device_add
[    3.593436] PM: Adding info for No Bus:ptyw9
[    3.595266] device: 'ptywa': device_add
[    3.597025] PM: Adding info for No Bus:ptywa
[    3.598850] device: 'ptywb': device_add
[    3.600605] PM: Adding info for No Bus:ptywb
[    3.602461] device: 'ptywc': device_add
[    3.604224] PM: Adding info for No Bus:ptywc
[    3.606048] device: 'ptywd': device_add
[    3.607820] PM: Adding info for No Bus:ptywd
[    3.609649] device: 'ptywe': device_add
[    3.611432] PM: Adding info for No Bus:ptywe
[    3.613271] device: 'ptywf': device_add
[    3.615035] PM: Adding info for No Bus:ptywf
[    3.616942] device: 'ptyx0': device_add
[    3.618712] PM: Adding info for No Bus:ptyx0
[    3.620559] device: 'ptyx1': device_add
[    3.622355] PM: Adding info for No Bus:ptyx1
[    3.624185] device: 'ptyx2': device_add
[    3.625954] PM: Adding info for No Bus:ptyx2
[    3.627791] device: 'ptyx3': device_add
[    3.629548] PM: Adding info for No Bus:ptyx3
[    3.631415] device: 'ptyx4': device_add
[    3.633192] PM: Adding info for No Bus:ptyx4
[    3.635023] device: 'ptyx5': device_add
[    3.636787] PM: Adding info for No Bus:ptyx5
[    3.638628] device: 'ptyx6': device_add
[    3.640395] PM: Adding info for No Bus:ptyx6
[    3.642248] device: 'ptyx7': device_add
[    3.644012] PM: Adding info for No Bus:ptyx7
[    3.645863] device: 'ptyx8': device_add
[    3.647678] PM: Adding info for No Bus:ptyx8
[    3.649569] device: 'ptyx9': device_add
[    3.651359] PM: Adding info for No Bus:ptyx9
[    3.653204] device: 'ptyxa': device_add
[    3.654967] PM: Adding info for No Bus:ptyxa
[    3.656807] device: 'ptyxb': device_add
[    3.658649] PM: Adding info for No Bus:ptyxb
[    3.660489] device: 'ptyxc': device_add
[    3.662312] PM: Adding info for No Bus:ptyxc
[    3.664150] device: 'ptyxd': device_add
[    3.665943] PM: Adding info for No Bus:ptyxd
[    3.667780] device: 'ptyxe': device_add
[    3.669552] PM: Adding info for No Bus:ptyxe
[    3.671426] device: 'ptyxf': device_add
[    3.673188] PM: Adding info for No Bus:ptyxf
[    3.675013] device: 'ptyy0': device_add
[    3.676785] PM: Adding info for No Bus:ptyy0
[    3.678662] device: 'ptyy1': device_add
[    3.680467] PM: Adding info for No Bus:ptyy1
[    3.682332] device: 'ptyy2': device_add
[    3.684100] PM: Adding info for No Bus:ptyy2
[    3.685940] device: 'ptyy3': device_add
[    3.687689] PM: Adding info for No Bus:ptyy3
[    3.689522] device: 'ptyy4': device_add
[    3.691299] PM: Adding info for No Bus:ptyy4
[    3.693144] device: 'ptyy5': device_add
[    3.694901] PM: Adding info for No Bus:ptyy5
[    3.696724] device: 'ptyy6': device_add
[    3.698487] PM: Adding info for No Bus:ptyy6
[    3.700331] device: 'ptyy7': device_add
[    3.702106] PM: Adding info for No Bus:ptyy7
[    3.703935] device: 'ptyy8': device_add
[    3.705688] PM: Adding info for No Bus:ptyy8
[    3.707520] device: 'ptyy9': device_add
[    3.709285] PM: Adding info for No Bus:ptyy9
[    3.711183] device: 'ptyya': device_add
[    3.712941] PM: Adding info for No Bus:ptyya
[    3.714771] device: 'ptyyb': device_add
[    3.716532] PM: Adding info for No Bus:ptyyb
[    3.718388] device: 'ptyyc': device_add
[    3.720166] PM: Adding info for No Bus:ptyyc
[    3.722004] device: 'ptyyd': device_add
[    3.723786] PM: Adding info for No Bus:ptyyd
[    3.725609] device: 'ptyye': device_add
[    3.727365] PM: Adding info for No Bus:ptyye
[    3.729199] device: 'ptyyf': device_add
[    3.730989] PM: Adding info for No Bus:ptyyf
[    3.732833] device: 'ptyz0': device_add
[    3.734596] PM: Adding info for No Bus:ptyz0
[    3.736445] device: 'ptyz1': device_add
[    3.738219] PM: Adding info for No Bus:ptyz1
[    3.740046] device: 'ptyz2': device_add
[    3.746868] PM: Adding info for No Bus:ptyz2
[    3.748701] device: 'ptyz3': device_add
[    3.750466] PM: Adding info for No Bus:ptyz3
[    3.752327] device: 'ptyz4': device_add
[    3.754093] PM: Adding info for No Bus:ptyz4
[    3.755917] device: 'ptyz5': device_add
[    3.757669] PM: Adding info for No Bus:ptyz5
[    3.759508] device: 'ptyz6': device_add
[    3.761300] PM: Adding info for No Bus:ptyz6
[    3.763139] device: 'ptyz7': device_add
[    3.764904] PM: Adding info for No Bus:ptyz7
[    3.766731] device: 'ptyz8': device_add
[    3.768495] PM: Adding info for No Bus:ptyz8
[    3.770348] device: 'ptyz9': device_add
[    3.772167] PM: Adding info for No Bus:ptyz9
[    3.773996] device: 'ptyza': device_add
[    3.775760] PM: Adding info for No Bus:ptyza
[    3.777586] device: 'ptyzb': device_add
[    3.779348] PM: Adding info for No Bus:ptyzb
[    3.781197] device: 'ptyzc': device_add
[    3.782962] PM: Adding info for No Bus:ptyzc
[    3.784805] device: 'ptyzd': device_add
[    3.786558] PM: Adding info for No Bus:ptyzd
[    3.788392] device: 'ptyze': device_add
[    3.790181] PM: Adding info for No Bus:ptyze
[    3.792013] device: 'ptyzf': device_add
[    3.793785] PM: Adding info for No Bus:ptyzf
[    3.795617] device: 'ptya0': device_add
[    3.797383] PM: Adding info for No Bus:ptya0
[    3.799214] device: 'ptya1': device_add
[    3.800998] PM: Adding info for No Bus:ptya1
[    3.802884] device: 'ptya2': device_add
[    3.804653] PM: Adding info for No Bus:ptya2
[    3.806490] device: 'ptya3': device_add
[    3.808256] PM: Adding info for No Bus:ptya3
[    3.810093] device: 'ptya4': device_add
[    3.811872] PM: Adding info for No Bus:ptya4
[    3.813697] device: 'ptya5': device_add
[    3.815463] PM: Adding info for No Bus:ptya5
[    3.817297] device: 'ptya6': device_add
[    3.819070] PM: Adding info for No Bus:ptya6
[    3.820912] device: 'ptya7': device_add
[    3.822686] PM: Adding info for No Bus:ptya7
[    3.824547] device: 'ptya8': device_add
[    3.826317] PM: Adding info for No Bus:ptya8
[    3.828145] device: 'ptya9': device_add
[    3.829922] PM: Adding info for No Bus:ptya9
[    3.831769] device: 'ptyaa': device_add
[    3.833575] PM: Adding info for No Bus:ptyaa
[    3.835444] device: 'ptyab': device_add
[    3.837200] PM: Adding info for No Bus:ptyab
[    3.839025] device: 'ptyac': device_add
[    3.840808] PM: Adding info for No Bus:ptyac
[    3.842632] device: 'ptyad': device_add
[    3.844391] PM: Adding info for No Bus:ptyad
[    3.846232] device: 'ptyae': device_add
[    3.847995] PM: Adding info for No Bus:ptyae
[    3.849834] device: 'ptyaf': device_add
[    3.851609] PM: Adding info for No Bus:ptyaf
[    3.853451] device: 'ptyb0': device_add
[    3.855243] PM: Adding info for No Bus:ptyb0
[    3.857071] device: 'ptyb1': device_add
[    3.858845] PM: Adding info for No Bus:ptyb1
[    3.860673] device: 'ptyb2': device_add
[    3.862477] PM: Adding info for No Bus:ptyb2
[    3.864313] device: 'ptyb3': device_add
[    3.866163] PM: Adding info for No Bus:ptyb3
[    3.867991] device: 'ptyb4': device_add
[    3.869759] PM: Adding info for No Bus:ptyb4
[    3.871601] device: 'ptyb5': device_add
[    3.873366] PM: Adding info for No Bus:ptyb5
[    3.875199] device: 'ptyb6': device_add
[    3.876964] PM: Adding info for No Bus:ptyb6
[    3.878797] device: 'ptyb7': device_add
[    3.880555] PM: Adding info for No Bus:ptyb7
[    3.882409] device: 'ptyb8': device_add
[    3.884168] PM: Adding info for No Bus:ptyb8
[    3.885992] device: 'ptyb9': device_add
[    3.887758] PM: Adding info for No Bus:ptyb9
[    3.889578] device: 'ptyba': device_add
[    3.891349] PM: Adding info for No Bus:ptyba
[    3.893188] device: 'ptybb': device_add
[    3.894945] PM: Adding info for No Bus:ptybb
[    3.896820] device: 'ptybc': device_add
[    3.898571] PM: Adding info for No Bus:ptybc
[    3.900395] device: 'ptybd': device_add
[    3.902184] PM: Adding info for No Bus:ptybd
[    3.904011] device: 'ptybe': device_add
[    3.905777] PM: Adding info for No Bus:ptybe
[    3.907611] device: 'ptybf': device_add
[    3.909379] PM: Adding info for No Bus:ptybf
[    3.911235] device: 'ptyc0': device_add
[    3.912995] PM: Adding info for No Bus:ptyc0
[    3.914828] device: 'ptyc1': device_add
[    3.916591] PM: Adding info for No Bus:ptyc1
[    3.918429] device: 'ptyc2': device_add
[    3.920210] PM: Adding info for No Bus:ptyc2
[    3.922034] device: 'ptyc3': device_add
[    3.923801] PM: Adding info for No Bus:ptyc3
[    3.925628] device: 'ptyc4': device_add
[    3.927486] PM: Adding info for No Bus:ptyc4
[    3.929320] device: 'ptyc5': device_add
[    3.931111] PM: Adding info for No Bus:ptyc5
[    3.932939] device: 'ptyc6': device_add
[    3.934699] PM: Adding info for No Bus:ptyc6
[    3.936542] device: 'ptyc7': device_add
[    3.938300] PM: Adding info for No Bus:ptyc7
[    3.940132] device: 'ptyc8': device_add
[    3.941924] PM: Adding info for No Bus:ptyc8
[    3.943748] device: 'ptyc9': device_add
[    3.945511] PM: Adding info for No Bus:ptyc9
[    3.947338] device: 'ptyca': device_add
[    3.949109] PM: Adding info for No Bus:ptyca
[    3.950953] device: 'ptycb': device_add
[    3.952812] PM: Adding info for No Bus:ptycb
[    3.954651] device: 'ptycc': device_add
[    3.956446] PM: Adding info for No Bus:ptycc
[    3.958331] device: 'ptycd': device_add
[    3.960094] PM: Adding info for No Bus:ptycd
[    3.961951] device: 'ptyce': device_add
[    3.963752] PM: Adding info for No Bus:ptyce
[    3.965583] device: 'ptycf': device_add
[    3.967339] PM: Adding info for No Bus:ptycf
[    3.969179] device: 'ptyd0': device_add
[    3.970955] PM: Adding info for No Bus:ptyd0
[    3.972797] device: 'ptyd1': device_add
[    3.974580] PM: Adding info for No Bus:ptyd1
[    3.976404] device: 'ptyd2': device_add
[    3.978177] PM: Adding info for No Bus:ptyd2
[    3.980025] device: 'ptyd3': device_add
[    3.981811] PM: Adding info for No Bus:ptyd3
[    3.983640] device: 'ptyd4': device_add
[    3.985413] PM: Adding info for No Bus:ptyd4
[    3.987240] device: 'ptyd5': device_add
[    3.989058] PM: Adding info for No Bus:ptyd5
[    3.990946] device: 'ptyd6': device_add
[    3.992746] PM: Adding info for No Bus:ptyd6
[    3.994575] device: 'ptyd7': device_add
[    3.996336] PM: Adding info for No Bus:ptyd7
[    3.998175] device: 'ptyd8': device_add
[    3.999947] PM: Adding info for No Bus:ptyd8
[    4.001804] device: 'ptyd9': device_add
[    4.003559] PM: Adding info for No Bus:ptyd9
[    4.005394] device: 'ptyda': device_add
[    4.007157] PM: Adding info for No Bus:ptyda
[    4.008988] device: 'ptydb': device_add
[    4.010782] PM: Adding info for No Bus:ptydb
[    4.012615] device: 'ptydc': device_add
[    4.014386] PM: Adding info for No Bus:ptydc
[    4.016215] device: 'ptydd': device_add
[    4.017979] PM: Adding info for No Bus:ptydd
[    4.019869] device: 'ptyde': device_add
[    4.021703] PM: Adding info for No Bus:ptyde
[    4.023553] device: 'ptydf': device_add
[    4.025317] PM: Adding info for No Bus:ptydf
[    4.027145] device: 'ptye0': device_add
[    4.028914] PM: Adding info for No Bus:ptye0
[    4.030766] device: 'ptye1': device_add
[    4.032531] PM: Adding info for No Bus:ptye1
[    4.034368] device: 'ptye2': device_add
[    4.036127] PM: Adding info for No Bus:ptye2
[    4.037950] device: 'ptye3': device_add
[    4.039721] PM: Adding info for No Bus:ptye3
[    4.041581] device: 'ptye4': device_add
[    4.043343] PM: Adding info for No Bus:ptye4
[    4.045167] device: 'ptye5': device_add
[    4.046934] PM: Adding info for No Bus:ptye5
[    4.048758] device: 'ptye6': device_add
[    4.050581] PM: Adding info for No Bus:ptye6
[    4.052555] device: 'ptye7': device_add
[    4.054325] PM: Adding info for No Bus:ptye7
[    4.056160] device: 'ptye8': device_add
[    4.057928] PM: Adding info for No Bus:ptye8
[    4.059773] device: 'ptye9': device_add
[    4.061590] PM: Adding info for No Bus:ptye9
[    4.063464] device: 'ptyea': device_add
[    4.065224] PM: Adding info for No Bus:ptyea
[    4.067048] device: 'ptyeb': device_add
[    4.068803] PM: Adding info for No Bus:ptyeb
[    4.070619] device: 'ptyec': device_add
[    4.077378] PM: Adding info for No Bus:ptyec
[    4.079207] device: 'ptyed': device_add
[    4.080985] PM: Adding info for No Bus:ptyed
[    4.082905] device: 'ptyee': device_add
[    4.084716] PM: Adding info for No Bus:ptyee
[    4.086535] device: 'ptyef': device_add
[    4.088297] PM: Adding info for No Bus:ptyef
[    4.090147] device: 'ttyp0': device_add
[    4.091939] PM: Adding info for No Bus:ttyp0
[    4.093772] device: 'ttyp1': device_add
[    4.095540] PM: Adding info for No Bus:ttyp1
[    4.097365] device: 'ttyp2': device_add
[    4.099127] PM: Adding info for No Bus:ttyp2
[    4.100976] device: 'ttyp3': device_add
[    4.102773] PM: Adding info for No Bus:ttyp3
[    4.104598] device: 'ttyp4': device_add
[    4.106360] PM: Adding info for No Bus:ttyp4
[    4.108190] device: 'ttyp5': device_add
[    4.109954] PM: Adding info for No Bus:ttyp5
[    4.111807] device: 'ttyp6': device_add
[    4.113617] PM: Adding info for No Bus:ttyp6
[    4.115454] device: 'ttyp7': device_add
[    4.117212] PM: Adding info for No Bus:ttyp7
[    4.119037] device: 'ttyp8': device_add
[    4.120813] PM: Adding info for No Bus:ttyp8
[    4.122632] device: 'ttyp9': device_add
[    4.124403] PM: Adding info for No Bus:ttyp9
[    4.126238] device: 'ttypa': device_add
[    4.128003] PM: Adding info for No Bus:ttypa
[    4.129836] device: 'ttypb': device_add
[    4.131613] PM: Adding info for No Bus:ttypb
[    4.133458] device: 'ttypc': device_add
[    4.135232] PM: Adding info for No Bus:ttypc
[    4.137059] device: 'ttypd': device_add
[    4.138822] PM: Adding info for No Bus:ttypd
[    4.140641] device: 'ttype': device_add
[    4.142432] PM: Adding info for No Bus:ttype
[    4.144366] device: 'ttypf': device_add
[    4.146140] PM: Adding info for No Bus:ttypf
[    4.147969] device: 'ttyq0': device_add
[    4.149746] PM: Adding info for No Bus:ttyq0
[    4.151583] device: 'ttyq1': device_add
[    4.153355] PM: Adding info for No Bus:ttyq1
[    4.155195] device: 'ttyq2': device_add
[    4.156964] PM: Adding info for No Bus:ttyq2
[    4.158801] device: 'ttyq3': device_add
[    4.160562] PM: Adding info for No Bus:ttyq3
[    4.162431] device: 'ttyq4': device_add
[    4.164217] PM: Adding info for No Bus:ttyq4
[    4.166046] device: 'ttyq5': device_add
[    4.167802] PM: Adding info for No Bus:ttyq5
[    4.169626] device: 'ttyq6': device_add
[    4.171416] PM: Adding info for No Bus:ttyq6
[    4.173252] device: 'ttyq7': device_add
[    4.175053] PM: Adding info for No Bus:ttyq7
[    4.176925] device: 'ttyq8': device_add
[    4.178701] PM: Adding info for No Bus:ttyq8
[    4.180528] device: 'ttyq9': device_add
[    4.182317] PM: Adding info for No Bus:ttyq9
[    4.184155] device: 'ttyqa': device_add
[    4.185927] PM: Adding info for No Bus:ttyqa
[    4.187769] device: 'ttyqb': device_add
[    4.189523] PM: Adding info for No Bus:ttyqb
[    4.191372] device: 'ttyqc': device_add
[    4.193171] PM: Adding info for No Bus:ttyqc
[    4.194998] device: 'ttyqd': device_add
[    4.196770] PM: Adding info for No Bus:ttyqd
[    4.198612] device: 'ttyqe': device_add
[    4.200393] PM: Adding info for No Bus:ttyqe
[    4.202251] device: 'ttyqf': device_add
[    4.204013] PM: Adding info for No Bus:ttyqf
[    4.205896] device: 'ttyr0': device_add
[    4.207668] PM: Adding info for No Bus:ttyr0
[    4.209516] device: 'ttyr1': device_add
[    4.211298] PM: Adding info for No Bus:ttyr1
[    4.213137] device: 'ttyr2': device_add
[    4.214905] PM: Adding info for No Bus:ttyr2
[    4.216743] device: 'ttyr3': device_add
[    4.218521] PM: Adding info for No Bus:ttyr3
[    4.220353] device: 'ttyr4': device_add
[    4.222170] PM: Adding info for No Bus:ttyr4
[    4.223993] device: 'ttyr5': device_add
[    4.225757] PM: Adding info for No Bus:ttyr5
[    4.227596] device: 'ttyr6': device_add
[    4.229360] PM: Adding info for No Bus:ttyr6
[    4.231212] device: 'ttyr7': device_add
[    4.232977] PM: Adding info for No Bus:ttyr7
[    4.234807] device: 'ttyr8': device_add
[    4.236616] PM: Adding info for No Bus:ttyr8
[    4.238478] device: 'ttyr9': device_add
[    4.240255] PM: Adding info for No Bus:ttyr9
[    4.242110] device: 'ttyra': device_add
[    4.243871] PM: Adding info for No Bus:ttyra
[    4.245690] device: 'ttyrb': device_add
[    4.247536] PM: Adding info for No Bus:ttyrb
[    4.249380] device: 'ttyrc': device_add
[    4.251207] PM: Adding info for No Bus:ttyrc
[    4.253032] device: 'ttyrd': device_add
[    4.254799] PM: Adding info for No Bus:ttyrd
[    4.256628] device: 'ttyre': device_add
[    4.258392] PM: Adding info for No Bus:ttyre
[    4.260283] device: 'ttyrf': device_add
[    4.262054] PM: Adding info for No Bus:ttyrf
[    4.263889] device: 'ttys0': device_add
[    4.265663] PM: Adding info for No Bus:ttys0
[    4.267543] device: 'ttys1': device_add
[    4.269352] PM: Adding info for No Bus:ttys1
[    4.271199] device: 'ttys2': device_add
[    4.272953] PM: Adding info for No Bus:ttys2
[    4.274785] device: 'ttys3': device_add
[    4.276545] PM: Adding info for No Bus:ttys3
[    4.278378] device: 'ttys4': device_add
[    4.280134] PM: Adding info for No Bus:ttys4
[    4.281997] device: 'ttys5': device_add
[    4.283768] PM: Adding info for No Bus:ttys5
[    4.285589] device: 'ttys6': device_add
[    4.287354] PM: Adding info for No Bus:ttys6
[    4.289183] device: 'ttys7': device_add
[    4.290960] PM: Adding info for No Bus:ttys7
[    4.292785] device: 'ttys8': device_add
[    4.294551] PM: Adding info for No Bus:ttys8
[    4.296373] device: 'ttys9': device_add
[    4.298144] PM: Adding info for No Bus:ttys9
[    4.300008] device: 'ttysa': device_add
[    4.301787] PM: Adding info for No Bus:ttysa
[    4.303618] device: 'ttysb': device_add
[    4.305400] PM: Adding info for No Bus:ttysb
[    4.307241] device: 'ttysc': device_add
[    4.309023] PM: Adding info for No Bus:ttysc
[    4.310868] device: 'ttysd': device_add
[    4.312673] PM: Adding info for No Bus:ttysd
[    4.314501] device: 'ttyse': device_add
[    4.316269] PM: Adding info for No Bus:ttyse
[    4.318103] device: 'ttysf': device_add
[    4.319882] PM: Adding info for No Bus:ttysf
[    4.321734] device: 'ttyt0': device_add
[    4.323505] PM: Adding info for No Bus:ttyt0
[    4.325332] device: 'ttyt1': device_add
[    4.327091] PM: Adding info for No Bus:ttyt1
[    4.328919] device: 'ttyt2': device_add
[    4.330790] PM: Adding info for No Bus:ttyt2
[    4.332616] device: 'ttyt3': device_add
[    4.334380] PM: Adding info for No Bus:ttyt3
[    4.336238] device: 'ttyt4': device_add
[    4.338006] PM: Adding info for No Bus:ttyt4
[    4.339837] device: 'ttyt5': device_add
[    4.341663] PM: Adding info for No Bus:ttyt5
[    4.343490] device: 'ttyt6': device_add
[    4.345256] PM: Adding info for No Bus:ttyt6
[    4.347102] device: 'ttyt7': device_add
[    4.348864] PM: Adding info for No Bus:ttyt7
[    4.350737] device: 'ttyt8': device_add
[    4.352509] PM: Adding info for No Bus:ttyt8
[    4.354337] device: 'ttyt9': device_add
[    4.356106] PM: Adding info for No Bus:ttyt9
[    4.357929] device: 'ttyta': device_add
[    4.359707] PM: Adding info for No Bus:ttyta
[    4.361627] device: 'ttytb': device_add
[    4.363409] PM: Adding info for No Bus:ttytb
[    4.365254] device: 'ttytc': device_add
[    4.367031] PM: Adding info for No Bus:ttytc
[    4.368856] device: 'ttytd': device_add
[    4.370645] PM: Adding info for No Bus:ttytd
[    4.372490] device: 'ttyte': device_add
[    4.374264] PM: Adding info for No Bus:ttyte
[    4.376094] device: 'ttytf': device_add
[    4.377871] PM: Adding info for No Bus:ttytf
[    4.379715] device: 'ttyu0': device_add
[    4.381515] PM: Adding info for No Bus:ttyu0
[    4.383353] device: 'ttyu1': device_add
[    4.385117] PM: Adding info for No Bus:ttyu1
[    4.386974] device: 'ttyu2': device_add
[    4.388763] PM: Adding info for No Bus:ttyu2
[    4.390583] device: 'ttyu3': device_add
[    4.392467] PM: Adding info for No Bus:ttyu3
[    4.394308] device: 'ttyu4': device_add
[    4.396070] PM: Adding info for No Bus:ttyu4
[    4.397904] device: 'ttyu5': device_add
[    4.399669] PM: Adding info for No Bus:ttyu5
[    4.401534] device: 'ttyu6': device_add
[    4.408178] PM: Adding info for No Bus:ttyu6
[    4.410012] device: 'ttyu7': device_add
[    4.411799] PM: Adding info for No Bus:ttyu7
[    4.413629] device: 'ttyu8': device_add
[    4.415391] PM: Adding info for No Bus:ttyu8
[    4.417238] device: 'ttyu9': device_add
[    4.418991] PM: Adding info for No Bus:ttyu9
[    4.420858] device: 'ttyua': device_add
[    4.422696] PM: Adding info for No Bus:ttyua
[    4.424528] device: 'ttyub': device_add
[    4.426286] PM: Adding info for No Bus:ttyub
[    4.428121] device: 'ttyuc': device_add
[    4.429879] PM: Adding info for No Bus:ttyuc
[    4.431782] device: 'ttyud': device_add
[    4.433553] PM: Adding info for No Bus:ttyud
[    4.435410] device: 'ttyue': device_add
[    4.437170] PM: Adding info for No Bus:ttyue
[    4.438998] device: 'ttyuf': device_add
[    4.440776] PM: Adding info for No Bus:ttyuf
[    4.442634] device: 'ttyv0': device_add
[    4.444416] PM: Adding info for No Bus:ttyv0
[    4.446254] device: 'ttyv1': device_add
[    4.448014] PM: Adding info for No Bus:ttyv1
[    4.449839] device: 'ttyv2': device_add
[    4.451623] PM: Adding info for No Bus:ttyv2
[    4.453525] device: 'ttyv3': device_add
[    4.455368] PM: Adding info for No Bus:ttyv3
[    4.457207] device: 'ttyv4': device_add
[    4.458962] PM: Adding info for No Bus:ttyv4
[    4.460804] device: 'ttyv5': device_add
[    4.462561] PM: Adding info for No Bus:ttyv5
[    4.464418] device: 'ttyv6': device_add
[    4.466204] PM: Adding info for No Bus:ttyv6
[    4.468033] device: 'ttyv7': device_add
[    4.469798] PM: Adding info for No Bus:ttyv7
[    4.471663] device: 'ttyv8': device_add
[    4.473439] PM: Adding info for No Bus:ttyv8
[    4.475277] device: 'ttyv9': device_add
[    4.477052] PM: Adding info for No Bus:ttyv9
[    4.478891] device: 'ttyva': device_add
[    4.480672] PM: Adding info for No Bus:ttyva
[    4.482508] device: 'ttyvb': device_add
[    4.484291] PM: Adding info for No Bus:ttyvb
[    4.486181] device: 'ttyvc': device_add
[    4.487976] PM: Adding info for No Bus:ttyvc
[    4.489829] device: 'ttyvd': device_add
[    4.491649] PM: Adding info for No Bus:ttyvd
[    4.493498] device: 'ttyve': device_add
[    4.495262] PM: Adding info for No Bus:ttyve
[    4.497096] device: 'ttyvf': device_add
[    4.498855] PM: Adding info for No Bus:ttyvf
[    4.500729] device: 'ttyw0': device_add
[    4.502486] PM: Adding info for No Bus:ttyw0
[    4.504325] device: 'ttyw1': device_add
[    4.506108] PM: Adding info for No Bus:ttyw1
[    4.507946] device: 'ttyw2': device_add
[    4.509733] PM: Adding info for No Bus:ttyw2
[    4.511580] device: 'ttyw3': device_add
[    4.513354] PM: Adding info for No Bus:ttyw3
[    4.515214] device: 'ttyw4': device_add
[    4.517028] PM: Adding info for No Bus:ttyw4
[    4.518863] device: 'ttyw5': device_add
[    4.520673] PM: Adding info for No Bus:ttyw5
[    4.522495] device: 'ttyw6': device_add
[    4.524279] PM: Adding info for No Bus:ttyw6
[    4.526131] device: 'ttyw7': device_add
[    4.527901] PM: Adding info for No Bus:ttyw7
[    4.529766] device: 'ttyw8': device_add
[    4.531547] PM: Adding info for No Bus:ttyw8
[    4.533389] device: 'ttyw9': device_add
[    4.535169] PM: Adding info for No Bus:ttyw9
[    4.537002] device: 'ttywa': device_add
[    4.538765] PM: Adding info for No Bus:ttywa
[    4.540607] device: 'ttywb': device_add
[    4.542457] PM: Adding info for No Bus:ttywb
[    4.544292] device: 'ttywc': device_add
[    4.546101] PM: Adding info for No Bus:ttywc
[    4.547980] device: 'ttywd': device_add
[    4.549750] PM: Adding info for No Bus:ttywd
[    4.551650] device: 'ttywe': device_add
[    4.553437] PM: Adding info for No Bus:ttywe
[    4.555268] device: 'ttywf': device_add
[    4.557052] PM: Adding info for No Bus:ttywf
[    4.558882] device: 'ttyx0': device_add
[    4.560661] PM: Adding info for No Bus:ttyx0
[    4.562472] device: 'ttyx1': device_add
[    4.564242] PM: Adding info for No Bus:ttyx1
[    4.566078] device: 'ttyx2': device_add
[    4.567846] PM: Adding info for No Bus:ttyx2
[    4.569698] device: 'ttyx3': device_add
[    4.571474] PM: Adding info for No Bus:ttyx3
[    4.573319] device: 'ttyx4': device_add
[    4.575081] PM: Adding info for No Bus:ttyx4
[    4.576920] device: 'ttyx5': device_add
[    4.578785] PM: Adding info for No Bus:ttyx5
[    4.580632] device: 'ttyx6': device_add
[    4.582412] PM: Adding info for No Bus:ttyx6
[    4.584254] device: 'ttyx7': device_add
[    4.586026] PM: Adding info for No Bus:ttyx7
[    4.587862] device: 'ttyx8': device_add
[    4.589632] PM: Adding info for No Bus:ttyx8
[    4.591494] device: 'ttyx9': device_add
[    4.593272] PM: Adding info for No Bus:ttyx9
[    4.595102] device: 'ttyxa': device_add
[    4.596890] PM: Adding info for No Bus:ttyxa
[    4.598756] device: 'ttyxb': device_add
[    4.600519] PM: Adding info for No Bus:ttyxb
[    4.602399] device: 'ttyxc': device_add
[    4.604186] PM: Adding info for No Bus:ttyxc
[    4.606021] device: 'ttyxd': device_add
[    4.607791] PM: Adding info for No Bus:ttyxd
[    4.609671] device: 'ttyxe': device_add
[    4.611471] PM: Adding info for No Bus:ttyxe
[    4.613309] device: 'ttyxf': device_add
[    4.615069] PM: Adding info for No Bus:ttyxf
[    4.616919] device: 'ttyy0': device_add
[    4.618682] PM: Adding info for No Bus:ttyy0
[    4.620515] device: 'ttyy1': device_add
[    4.622333] PM: Adding info for No Bus:ttyy1
[    4.624169] device: 'ttyy2': device_add
[    4.625932] PM: Adding info for No Bus:ttyy2
[    4.627774] device: 'ttyy3': device_add
[    4.629533] PM: Adding info for No Bus:ttyy3
[    4.631389] device: 'ttyy4': device_add
[    4.633158] PM: Adding info for No Bus:ttyy4
[    4.634997] device: 'ttyy5': device_add
[    4.636761] PM: Adding info for No Bus:ttyy5
[    4.638601] device: 'ttyy6': device_add
[    4.640453] PM: Adding info for No Bus:ttyy6
[    4.642319] device: 'ttyy7': device_add
[    4.644113] PM: Adding info for No Bus:ttyy7
[    4.645951] device: 'ttyy8': device_add
[    4.647727] PM: Adding info for No Bus:ttyy8
[    4.649574] device: 'ttyy9': device_add
[    4.651366] PM: Adding info for No Bus:ttyy9
[    4.653220] device: 'ttyya': device_add
[    4.654979] PM: Adding info for No Bus:ttyya
[    4.656816] device: 'ttyyb': device_add
[    4.658614] PM: Adding info for No Bus:ttyyb
[    4.660478] device: 'ttyyc': device_add
[    4.662298] PM: Adding info for No Bus:ttyyc
[    4.664128] device: 'ttyyd': device_add
[    4.665909] PM: Adding info for No Bus:ttyyd
[    4.667740] device: 'ttyye': device_add
[    4.669492] PM: Adding info for No Bus:ttyye
[    4.671444] device: 'ttyyf': device_add
[    4.673228] PM: Adding info for No Bus:ttyyf
[    4.675064] device: 'ttyz0': device_add
[    4.676828] PM: Adding info for No Bus:ttyz0
[    4.678673] device: 'ttyz1': device_add
[    4.680438] PM: Adding info for No Bus:ttyz1
[    4.682314] device: 'ttyz2': device_add
[    4.684093] PM: Adding info for No Bus:ttyz2
[    4.685920] device: 'ttyz3': device_add
[    4.687677] PM: Adding info for No Bus:ttyz3
[    4.689507] device: 'ttyz4': device_add
[    4.691312] PM: Adding info for No Bus:ttyz4
[    4.693146] device: 'ttyz5': device_add
[    4.694919] PM: Adding info for No Bus:ttyz5
[    4.696758] device: 'ttyz6': device_add
[    4.698515] PM: Adding info for No Bus:ttyz6
[    4.700343] device: 'ttyz7': device_add
[    4.702189] PM: Adding info for No Bus:ttyz7
[    4.704044] device: 'ttyz8': device_add
[    4.705804] PM: Adding info for No Bus:ttyz8
[    4.707638] device: 'ttyz9': device_add
[    4.709410] PM: Adding info for No Bus:ttyz9
[    4.711279] device: 'ttyza': device_add
[    4.713055] PM: Adding info for No Bus:ttyza
[    4.714890] device: 'ttyzb': device_add
[    4.716650] PM: Adding info for No Bus:ttyzb
[    4.718484] device: 'ttyzc': device_add
[    4.720260] PM: Adding info for No Bus:ttyzc
[    4.722122] device: 'ttyzd': device_add
[    4.723929] PM: Adding info for No Bus:ttyzd
[    4.725755] device: 'ttyze': device_add
[    4.727517] PM: Adding info for No Bus:ttyze
[    4.729356] device: 'ttyzf': device_add
[    4.731141] PM: Adding info for No Bus:ttyzf
[    4.733031] device: 'ttya0': device_add
[    4.739663] PM: Adding info for No Bus:ttya0
[    4.741517] device: 'ttya1': device_add
[    4.743314] PM: Adding info for No Bus:ttya1
[    4.745157] device: 'ttya2': device_add
[    4.746930] PM: Adding info for No Bus:ttya2
[    4.748766] device: 'ttya3': device_add
[    4.750523] PM: Adding info for No Bus:ttya3
[    4.752392] device: 'ttya4': device_add
[    4.754160] PM: Adding info for No Bus:ttya4
[    4.756010] device: 'ttya5': device_add
[    4.757780] PM: Adding info for No Bus:ttya5
[    4.759635] device: 'ttya6': device_add
[    4.761427] PM: Adding info for No Bus:ttya6
[    4.763318] device: 'ttya7': device_add
[    4.765142] PM: Adding info for No Bus:ttya7
[    4.766983] device: 'ttya8': device_add
[    4.768743] PM: Adding info for No Bus:ttya8
[    4.770589] device: 'ttya9': device_add
[    4.772367] PM: Adding info for No Bus:ttya9
[    4.774196] device: 'ttyaa': device_add
[    4.775964] PM: Adding info for No Bus:ttyaa
[    4.777790] device: 'ttyab': device_add
[    4.779551] PM: Adding info for No Bus:ttyab
[    4.781417] device: 'ttyac': device_add
[    4.783210] PM: Adding info for No Bus:ttyac
[    4.785045] device: 'ttyad': device_add
[    4.786810] PM: Adding info for No Bus:ttyad
[    4.788645] device: 'ttyae': device_add
[    4.790410] PM: Adding info for No Bus:ttyae
[    4.792287] device: 'ttyaf': device_add
[    4.794072] PM: Adding info for No Bus:ttyaf
[    4.795998] device: 'ttyb0': device_add
[    4.797802] PM: Adding info for No Bus:ttyb0
[    4.799643] device: 'ttyb1': device_add
[    4.801436] PM: Adding info for No Bus:ttyb1
[    4.803281] device: 'ttyb2': device_add
[    4.805074] PM: Adding info for No Bus:ttyb2
[    4.806916] device: 'ttyb3': device_add
[    4.808685] PM: Adding info for No Bus:ttyb3
[    4.810522] device: 'ttyb4': device_add
[    4.812329] PM: Adding info for No Bus:ttyb4
[    4.814179] device: 'ttyb5': device_add
[    4.815960] PM: Adding info for No Bus:ttyb5
[    4.817809] device: 'ttyb6': device_add
[    4.819595] PM: Adding info for No Bus:ttyb6
[    4.821444] device: 'ttyb7': device_add
[    4.823228] PM: Adding info for No Bus:ttyb7
[    4.825058] device: 'ttyb8': device_add
[    4.826908] PM: Adding info for No Bus:ttyb8
[    4.828732] device: 'ttyb9': device_add
[    4.830485] PM: Adding info for No Bus:ttyb9
[    4.832352] device: 'ttyba': device_add
[    4.834138] PM: Adding info for No Bus:ttyba
[    4.835977] device: 'ttybb': device_add
[    4.837821] PM: Adding info for No Bus:ttybb
[    4.839660] device: 'ttybc': device_add
[    4.841465] PM: Adding info for No Bus:ttybc
[    4.843305] device: 'ttybd': device_add
[    4.845067] PM: Adding info for No Bus:ttybd
[    4.846895] device: 'ttybe': device_add
[    4.848659] PM: Adding info for No Bus:ttybe
[    4.850486] device: 'ttybf': device_add
[    4.852284] PM: Adding info for No Bus:ttybf
[    4.854131] device: 'ttyc0': device_add
[    4.855896] PM: Adding info for No Bus:ttyc0
[    4.857818] device: 'ttyc1': device_add
[    4.859621] PM: Adding info for No Bus:ttyc1
[    4.861480] device: 'ttyc2': device_add
[    4.863252] PM: Adding info for No Bus:ttyc2
[    4.865085] device: 'ttyc3': device_add
[    4.866846] PM: Adding info for No Bus:ttyc3
[    4.868682] device: 'ttyc4': device_add
[    4.870471] PM: Adding info for No Bus:ttyc4
[    4.872339] device: 'ttyc5': device_add
[    4.874106] PM: Adding info for No Bus:ttyc5
[    4.875930] device: 'ttyc6': device_add
[    4.877693] PM: Adding info for No Bus:ttyc6
[    4.879518] device: 'ttyc7': device_add
[    4.881327] PM: Adding info for No Bus:ttyc7
[    4.883189] device: 'ttyc8': device_add
[    4.884952] PM: Adding info for No Bus:ttyc8
[    4.886790] device: 'ttyc9': device_add
[    4.888644] PM: Adding info for No Bus:ttyc9
[    4.890478] device: 'ttyca': device_add
[    4.892277] PM: Adding info for No Bus:ttyca
[    4.894135] device: 'ttycb': device_add
[    4.895911] PM: Adding info for No Bus:ttycb
[    4.897732] device: 'ttycc': device_add
[    4.899503] PM: Adding info for No Bus:ttycc
[    4.901360] device: 'ttycd': device_add
[    4.903120] PM: Adding info for No Bus:ttycd
[    4.904959] device: 'ttyce': device_add
[    4.906718] PM: Adding info for No Bus:ttyce
[    4.908558] device: 'ttycf': device_add
[    4.910323] PM: Adding info for No Bus:ttycf
[    4.912187] device: 'ttyd0': device_add
[    4.913960] PM: Adding info for No Bus:ttyd0
[    4.915783] device: 'ttyd1': device_add
[    4.917537] PM: Adding info for No Bus:ttyd1
[    4.919444] device: 'ttyd2': device_add
[    4.921246] PM: Adding info for No Bus:ttyd2
[    4.923081] device: 'ttyd3': device_add
[    4.924849] PM: Adding info for No Bus:ttyd3
[    4.926693] device: 'ttyd4': device_add
[    4.928494] PM: Adding info for No Bus:ttyd4
[    4.930332] device: 'ttyd5': device_add
[    4.932127] PM: Adding info for No Bus:ttyd5
[    4.933962] device: 'ttyd6': device_add
[    4.935732] PM: Adding info for No Bus:ttyd6
[    4.937568] device: 'ttyd7': device_add
[    4.939326] PM: Adding info for No Bus:ttyd7
[    4.941223] device: 'ttyd8': device_add
[    4.942986] PM: Adding info for No Bus:ttyd8
[    4.944820] device: 'ttyd9': device_add
[    4.946604] PM: Adding info for No Bus:ttyd9
[    4.948453] device: 'ttyda': device_add
[    4.950314] PM: Adding info for No Bus:ttyda
[    4.952190] device: 'ttydb': device_add
[    4.953968] PM: Adding info for No Bus:ttydb
[    4.955803] device: 'ttydc': device_add
[    4.957597] PM: Adding info for No Bus:ttydc
[    4.959423] device: 'ttydd': device_add
[    4.961209] PM: Adding info for No Bus:ttydd
[    4.963062] device: 'ttyde': device_add
[    4.964838] PM: Adding info for No Bus:ttyde
[    4.966686] device: 'ttydf': device_add
[    4.968473] PM: Adding info for No Bus:ttydf
[    4.970308] device: 'ttye0': device_add
[    4.972110] PM: Adding info for No Bus:ttye0
[    4.973946] device: 'ttye1': device_add
[    4.975714] PM: Adding info for No Bus:ttye1
[    4.977540] device: 'ttye2': device_add
[    4.979300] PM: Adding info for No Bus:ttye2
[    4.981226] device: 'ttye3': device_add
[    4.983042] PM: Adding info for No Bus:ttye3
[    4.984879] device: 'ttye4': device_add
[    4.986657] PM: Adding info for No Bus:ttye4
[    4.988483] device: 'ttye5': device_add
[    4.990250] PM: Adding info for No Bus:ttye5
[    4.992110] device: 'ttye6': device_add
[    4.993885] PM: Adding info for No Bus:ttye6
[    4.995707] device: 'ttye7': device_add
[    4.997480] PM: Adding info for No Bus:ttye7
[    4.999321] device: 'ttye8': device_add
[    5.001110] PM: Adding info for No Bus:ttye8
[    5.002938] device: 'ttye9': device_add
[    5.004700] PM: Adding info for No Bus:ttye9
[    5.006530] device: 'ttyea': device_add
[    5.008291] PM: Adding info for No Bus:ttyea
[    5.010122] device: 'ttyeb': device_add
[    5.011978] PM: Adding info for No Bus:ttyeb
[    5.013812] device: 'ttyec': device_add
[    5.015586] PM: Adding info for No Bus:ttyec
[    5.017413] device: 'ttyed': device_add
[    5.019181] PM: Adding info for No Bus:ttyed
[    5.021036] device: 'ttyee': device_add
[    5.022800] PM: Adding info for No Bus:ttyee
[    5.024649] device: 'ttyef': device_add
[    5.026403] PM: Adding info for No Bus:ttyef
[    5.028287] device: 'ptmx': device_add
[    5.030027] PM: Adding info for No Bus:ptmx
[    5.031838] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    5.034314] Registering platform device 'serial8250'. Parent at platform
[    5.036840] device: 'serial8250': device_add
[    5.038644] bus: 'platform': add device serial8250
[    5.040677] PM: Adding info for platform:serial8250
[    5.068524] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    5.070888] device: 'ttyS0': device_add
[    5.072739] PM: Adding info for No Bus:ttyS0
[    5.074822] device: 'ttyS1': device_add
[    5.076600] PM: Adding info for No Bus:ttyS1
[    5.078558] device: 'ttyS2': device_add
[    5.080341] PM: Adding info for No Bus:ttyS2
[    5.082332] device: 'ttyS3': device_add
[    5.084121] PM: Adding info for No Bus:ttyS3
[    5.085999] bus: 'platform': add driver serial8250
[    5.087973] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[    5.091552] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[    5.099799] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[    5.102442] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[    5.105850] bus: 'pnp': add driver serial
[    5.107608] bus: 'pnp': driver_probe_device: matched device 00:06 with driver serial
[    5.110833] bus: 'pnp': really_probe: probing driver serial with device 00:06
[    5.113864] device: 'ttyS0': device_unregister
[    5.115710] PM: Removing info for No Bus:ttyS0
[    5.118402] device: 'ttyS0': device_create_release
[    5.146034] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    5.148250] device: 'ttyS0': device_add
[    5.150139] PM: Adding info for No Bus:ttyS0
[    5.152095] driver: '00:06': driver_bound: bound to device 'serial'
[    5.154502] bus: 'pnp': really_probe: bound device 00:06 to driver serial
[    5.157082] bus: 'pci': add driver serial
[    5.158970] kgdb: Registered I/O driver kgdbts.
[    5.161059] kgdbts:RUN hw breakpoint test
[    5.162932] kgdbts:RUN hw write breakpoint test
[    5.164871] kgdbts:RUN access write breakpoint test
[    5.166988] kgdbts:RUN plant and detach test
[    5.168806] kgdbts:RUN sw breakpoint test
[    5.170616] kgdbts:RUN bad memory access test
[    5.172490] kgdbts:RUN singlestep test 1000 iterations
[    5.174651] kgdbts:RUN singlestep [0/1000]
[    5.185439] kgdbts:RUN singlestep [100/1000]
[    5.196302] kgdbts:RUN singlestep [200/1000]
[    5.207274] kgdbts:RUN singlestep [300/1000]
[    5.218122] kgdbts:RUN singlestep [400/1000]
[    5.228979] kgdbts:RUN singlestep [500/1000]
[    5.239843] kgdbts:RUN singlestep [600/1000]
[    5.250716] kgdbts:RUN singlestep [700/1000]
[    5.261601] kgdbts:RUN singlestep [800/1000]
[    5.272437] kgdbts:RUN singlestep [900/1000]
[    5.283186] kgdbts:RUN do_fork for 100 breakpoints
[    5.285791] bus: 'pnp': add driver i8042 kbd
[    5.287614] bus: 'pnp': driver_probe_device: matched device 00:02 with driver i8042 kbd
[    5.291002] bus: 'pnp': really_probe: probing driver i8042 kbd with device 00:02
[    5.294210] driver: '00:02': driver_bound: bound to device 'i8042 kbd'
[    5.296702] bus: 'pnp': really_probe: bound device 00:02 to driver i8042 kbd
[    5.299398] bus: 'pnp': add driver i8042 aux
[    5.300989] bus: 'pnp': driver_probe_device: matched device 00:03 with driver i8042 aux
[    5.304552] bus: 'pnp': really_probe: probing driver i8042 aux with device 00:03
[    5.307679] driver: '00:03': driver_bound: bound to device 'i8042 aux'
[    5.310163] bus: 'pnp': really_probe: bound device 00:03 to driver i8042 aux
[    5.312861] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    5.316196] Registering platform device 'i8042'. Parent at platform
[    5.318608] device: 'i8042': device_add
[    5.320302] bus: 'platform': add device i8042
[    5.322329] PM: Adding info for platform:i8042
[    5.324198] bus: 'platform': add driver i8042
[    5.326038] bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
[    5.329353] bus: 'platform': really_probe: probing driver i8042 with device i8042
[    5.333812] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.335856] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.337898] driver: 'i8042': driver_bound: bound to device 'i8042'
[    5.340256] bus: 'platform': really_probe: bound device i8042 to driver i8042
[    5.343014] device: 'mice': device_add
[    5.344780] PM: Adding info for No Bus:mice
[    5.346608] device: 'psaux': device_add
[    5.348370] PM: Adding info for No Bus:psaux
[    5.350189] mousedev: PS/2 mouse device common for all mice
[    5.352477] bus: 'serio': add driver atkbd
[    5.354355] cpuidle: using governor ladder
[    5.356096] cpuidle: using governor menu
[    5.358278] TCP: cubic registered
[    5.359856] 
[    5.359856] printing PIC contents
[    5.362209] ... PIC  IMR: ffff
[    5.363644] ... PIC  IRR: 1013
[    5.365088] ... PIC  ISR: 0000
[    5.366523] ... PIC ELCR: 0c00
[    5.367953] printing local APIC contents on CPU#0/0:
[    5.369960] ... APIC ID:      00000000 (0)
[    5.371725] ... APIC VERSION: 00050014
[    5.372191] ... APIC TASKPRI: 00000000 (00)
[    5.372191] ... APIC PROCPRI: 00000000
[    5.372191] ... APIC LDR: 01000000
[    5.372191] ... APIC DFR: ffffffff
[    5.372191] ... APIC SPIV: 000001ff
[    5.372191] ... APIC ISR field:
[    5.372191] 0000000000000000000000000000000000000000000000000000000000000000
[    5.372191] ... APIC TMR field:
[    5.372191] 0000000000000000000000000000000000000000000000000000000000000000
[    5.372191] ... APIC IRR field:
[    5.372191] 0000000000000000000000000000000000000000000000000000000000008000
[    5.372191] ... APIC ESR: 00000000
[    5.372191] ... APIC ICR: 00000831
[    5.372191] ... APIC ICR2: 01000000
[    5.372191] ... APIC LVTT: 000000ef
[    5.372191] ... APIC LVTPC: 00010000
[    5.372191] ... APIC LVT0: 00010700
[    5.372191] ... APIC LVT1: 00000400
[    5.372191] ... APIC LVTERR: 000000fe
[    5.372191] ... APIC TMICT: 00077176
[    5.372191] ... APIC TMCCT: 00000000
[    5.372191] ... APIC TDCR: 00000003
[    5.372191] 
[    5.412379] number of MP IRQ sources: 15.
[    5.414129] number of IO-APIC #2 registers: 24.
[    5.416050] testing the IO APIC.......................
[    5.418116] 
[    5.419086] IO APIC #2......
[    5.420533] .... register #00: 00000000
[    5.422194] .......    : physical APIC id: 00
[    5.424012] .......    : Delivery Type: 0
[    5.425730] .......    : LTS          : 0
[    5.427459] .... register #01: 00170011
[    5.429114] .......     : max redirection entries: 17
[    5.431150] .......     : PRQ implemented: 0
[    5.432939] .......     : IO APIC version: 11
[    5.434774] .... register #02: 00000000
[    5.436437] .......     : arbitration: 00
[    5.438145] .... IRQ redirection table:
[    5.439806]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    5.442022]  00 00  1    0    0   0   0    0    0    00
[    5.444120]  01 01  0    0    0   0   0    1    1    31
[    5.446313]  02 01  0    0    0   0   0    1    1    30
[    5.448412]  03 01  0    0    0   0   0    1    1    33
[    5.450490]  04 01  1    0    0   0   0    1    1    34
[    5.452600]  05 01  1    1    0   0   0    1    1    35
[    5.454692]  06 01  0    0    0   0   0    1    1    36
[    5.456784]  07 01  0    0    0   0   0    1    1    37
[    5.458866]  08 01  0    0    0   0   0    1    1    38
[    5.460983]  09 01  0    1    0   0   0    1    1    39
[    5.463070]  0a 01  1    1    0   0   0    1    1    3A
[    5.465167]  0b 01  1    1    0   0   0    1    1    3B
[    5.467250]  0c 01  0    0    0   0   0    1    1    3C
[    5.469341]  0d 01  0    0    0   0   0    1    1    3D
[    5.471462]  0e 01  0    0    0   0   0    1    1    3E
[    5.473572]  0f 01  0    0    0   0   0    1    1    3F
[    5.475657]  10 00  1    0    0   0   0    0    0    00
[    5.477835]  11 00  1    0    0   0   0    0    0    00
[    5.479927]  12 00  1    0    0   0   0    0    0    00
[    5.482042]  13 00  1    0    0   0   0    0    0    00
[    5.484162]  14 00  1    0    0   0   0    0    0    00
[    5.486270]  15 00  1    0    0   0   0    0    0    00
[    5.488356]  16 00  1    0    0   0   0    0    0    00
[    5.490494]  17 00  1    0    0   0   0    0    0    00
[    5.492562] IRQ to pin mappings:
[    5.494054] IRQ0 -> 0:2
[    5.495305] IRQ1 -> 0:1
[    5.496549] IRQ3 -> 0:3
[    5.497805] IRQ4 -> 0:4
[    5.499049] IRQ5 -> 0:5
[    5.500299] IRQ6 -> 0:6
[    5.501577] IRQ7 -> 0:7
[    5.502819] IRQ8 -> 0:8
[    5.504059] IRQ9 -> 0:9
[    5.505307] IRQ10 -> 0:10
[    5.506603] IRQ11 -> 0:11
[    5.507900] IRQ12 -> 0:12
[    5.509188] IRQ13 -> 0:13
[    5.510507] IRQ14 -> 0:14
[    5.511805] IRQ15 -> 0:15
[    5.513109] .................................... done.
[    5.515256] device: 'cpu_dma_latency': device_add
[    5.517327] PM: Adding info for No Bus:cpu_dma_latency
[    5.519428] device: 'network_latency': device_add
[    5.521502] PM: Adding info for No Bus:network_latency
[    5.523592] device: 'network_throughput': device_add
[    5.525702] PM: Adding info for No Bus:network_throughput
[    5.527905] PM: Hibernation image not present or could not be loaded.
[    5.530558] device: 'serio0': device_add
[    5.532335] bus: 'serio': add device serio0
[    5.534221] PM: Adding info for serio:serio0
[    5.536063] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[    5.539419] bus: 'serio': really_probe: probing driver atkbd with device serio0
[    5.543287] device: 'input0': device_add
[    5.545519] PM: Adding info for No Bus:input0
[    5.547411] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    5.555898] driver: 'serio0': driver_bound: bound to device 'atkbd'
[    5.558336] bus: 'serio': really_probe: bound device serio0 to driver atkbd
[    5.561004] device: 'serio1': device_add
[    5.562782] bus: 'serio': add device serio1
[    5.564650] PM: Adding info for serio:serio1
[    5.566486] bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
[    5.569816] bus: 'serio': really_probe: probing driver atkbd with device serio1
[    5.573303] atkbd: probe of serio1 rejects match -19
[    5.575374] bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
[    5.578664] bus: 'serio': really_probe: probing driver atkbd with device serio1
[    5.582092] atkbd: probe of serio1 rejects match -19
[    5.584267] kmemleak: Kernel memory leak detector initialized
[    5.588236] kmemleak: Automatic memory scanning thread started
[    5.590695]   Magic number: 4:234:32
[    5.592345] tty ttydf: hash matches
[    5.594063] /c/kernel-tests/sound/drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    5.599018] Freeing unused kernel memory: 444k freed
[    5.601464] Write protecting the kernel read-only data: 6144k
[    5.603935] Testing CPA: undo ffffffff81000000-ffffffff81600000
[    5.606575] Testing CPA: again
[    5.611901] Freeing unused kernel memory: 1064k freed
[    5.616562] Freeing unused kernel memory: 704k freed
[    5.635107] KGDB: BP remove failed: ffffffff81026ed0
Kernel freezed on [    5.635107] KGDB: BP remove failed: ffffffff81026ed0

--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.5.0-rc4+"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.5.0-rc4 Kernel Configuration
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_FHANDLE is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_CGROUP_MEM_RES_CTLR=y
CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
# CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED is not set
CONFIG_CGROUP_MEM_RES_CTLR_KMEM=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
CONFIG_SCHED_AUTOGROUP=y
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EXPERT is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_OPTPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLK_DEV_THROTTLING=y

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=m
# CONFIG_CFQ_GROUP_IOSCHED is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
CONFIG_I8K=m
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
# CONFIG_ACPI_BUTTON is not set
CONFIG_ACPI_VIDEO=m
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=m
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_DEBUG_FUNC_TRACE is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=m
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_BGRT=m
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=m
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K8=m
CONFIG_X86_SPEEDSTEP_CENTRINO=m
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_INTEL_IDLE=y

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=m

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=m
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_IOAPIC=m
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=m
# CONFIG_PCMCIA is not set
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_HOTPLUG_PCI=m
# CONFIG_HOTPLUG_PCI_FAKE is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
# CONFIG_IA32_EMULATION is not set
# CONFIG_COMPAT_FOR_U64_ALIGNMENT is not set
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=m
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
# CONFIG_IP_ROUTE_VERBOSE is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_ARPD=y
# CONFIG_SYN_COOKIES is not set
CONFIG_INET_AH=m
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_INET_UDP_DIAG=m
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETWORK_PHY_TIMESTAMPING=y
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_NET_SCTPPROBE is not set
CONFIG_SCTP_DBG_MSG=y
# CONFIG_SCTP_DBG_OBJCNT is not set
CONFIG_SCTP_HMAC_NONE=y
# CONFIG_SCTP_HMAC_SHA1 is not set
# CONFIG_SCTP_HMAC_MD5 is not set
# CONFIG_RDS is not set
CONFIG_TIPC=m
CONFIG_TIPC_ADVANCED=y
CONFIG_TIPC_PORTS=8191
CONFIG_TIPC_LOG=0
CONFIG_TIPC_DEBUG=y
# CONFIG_ATM is not set
CONFIG_L2TP=m
# CONFIG_L2TP_DEBUGFS is not set
CONFIG_L2TP_V3=y
# CONFIG_L2TP_IP is not set
# CONFIG_L2TP_ETH is not set
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_NET_DSA=m
# CONFIG_NET_DSA_TAG_DSA is not set
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_DECNET=m
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=m
CONFIG_LLC2=m
CONFIG_IPX=m
# CONFIG_IPX_INTERN is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
CONFIG_LAPB=m
CONFIG_WAN_ROUTER=m
CONFIG_PHONET=m
CONFIG_IEEE802154=m
# CONFIG_MAC802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=m
CONFIG_BATMAN_ADV=m
CONFIG_BATMAN_ADV_BLA=y
CONFIG_BATMAN_ADV_DEBUG=y
# CONFIG_OPENVSWITCH is not set
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set

#
# Network testing
#
CONFIG_NET_PKTGEN=m
# CONFIG_NET_TCPPROBE is not set
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
# CONFIG_CAN is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
# CONFIG_IRNET is not set
CONFIG_IRCOMM=m
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
# CONFIG_IRDA_FAST_RR is not set
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=m

#
# Dongle support
#
CONFIG_DONGLE=y
# CONFIG_ESI_DONGLE is not set
# CONFIG_ACTISYS_DONGLE is not set
# CONFIG_TEKRAM_DONGLE is not set
# CONFIG_TOIM3232_DONGLE is not set
# CONFIG_LITELINK_DONGLE is not set
# CONFIG_MA600_DONGLE is not set
# CONFIG_GIRBIL_DONGLE is not set
CONFIG_MCP2120_DONGLE=m
# CONFIG_OLD_BELKIN_DONGLE is not set
# CONFIG_ACT200L_DONGLE is not set
# CONFIG_KINGSUN_DONGLE is not set
CONFIG_KSDAZZLE_DONGLE=m
# CONFIG_KS959_DONGLE is not set

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
# CONFIG_SIGMATEL_FIR is not set
# CONFIG_NSC_FIR is not set
# CONFIG_WINBOND_FIR is not set
CONFIG_SMC_IRCC_FIR=m
CONFIG_ALI_FIR=m
# CONFIG_VLSI_FIR is not set
CONFIG_VIA_FIR=m
# CONFIG_MCS_FIR is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=m
CONFIG_NL80211_TESTMODE=y
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_REG_DEBUG=y
# CONFIG_CFG80211_DEFAULT_PS is not set
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
# CONFIG_WIRELESS_EXT_SYSFS is not set
CONFIG_LIB80211=m
CONFIG_LIB80211_CRYPT_WEP=m
CONFIG_LIB80211_CRYPT_CCMP=m
CONFIG_LIB80211_CRYPT_TKIP=m
CONFIG_LIB80211_DEBUG=y
# CONFIG_MAC80211 is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=m
CONFIG_CEPH_LIB_PRETTYDEBUG=y
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
# CONFIG_DMA_SHARED_BUFFER is not set
CONFIG_CONNECTOR=m
CONFIG_MTD=m
CONFIG_MTD_TESTS=m
# CONFIG_MTD_REDBOOT_PARTS is not set
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
# CONFIG_MTD_CHAR is not set
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
CONFIG_MTD_BLOCK_RO=m
CONFIG_FTL=m
# CONFIG_NFTL is not set
CONFIG_INFTL=m
CONFIG_RFD_FTL=m
# CONFIG_SSFDC is not set
CONFIG_SM_FTL=m
CONFIG_MTD_OOPS=m
CONFIG_MTD_SWAP=m

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=m
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=m
# CONFIG_MTD_RAM is not set
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=m
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
CONFIG_MTD_TS5500=m
CONFIG_MTD_AMD76XROM=m
# CONFIG_MTD_ICHXROM is not set
CONFIG_MTD_ESB2ROM=m
CONFIG_MTD_CK804XROM=m
# CONFIG_MTD_SCB2_FLASH is not set
CONFIG_MTD_NETtel=m
CONFIG_MTD_L440GX=m
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=m
CONFIG_MTD_PHRAM=m
# CONFIG_MTD_MTDRAM is not set
CONFIG_MTD_BLOCK2MTD=m

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOC2000=m
CONFIG_MTD_DOC2001=m
# CONFIG_MTD_DOC2001PLUS is not set
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_DOCPROBE=m
CONFIG_MTD_DOCECC=m
CONFIG_MTD_DOCPROBE_ADVANCED=y
CONFIG_MTD_DOCPROBE_ADDRESS=0x0
# CONFIG_MTD_DOCPROBE_HIGH is not set
# CONFIG_MTD_DOCPROBE_55AA is not set
CONFIG_MTD_NAND_ECC=m
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=m
CONFIG_MTD_NAND_VERIFY_WRITE=y
CONFIG_MTD_NAND_BCH=m
CONFIG_MTD_NAND_ECC_BCH=y
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_MUSEUM_IDS=y
CONFIG_MTD_NAND_DENALI=m
CONFIG_MTD_NAND_DENALI_SCRATCH_REG_ADDR=0xFF108018
CONFIG_MTD_NAND_IDS=m
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=m
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH is not set
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
# CONFIG_MTD_NAND_DOCG4 is not set
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_NANDSIM=m
CONFIG_MTD_NAND_PLATFORM=m
# CONFIG_MTD_ALAUDA is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_RESERVE=1
CONFIG_MTD_UBI_GLUEBI=m
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
CONFIG_IBM_ASM=m
# CONFIG_PHANTOM is not set
CONFIG_INTEL_MID_PTI=m
CONFIG_SGI_IOC4=m
CONFIG_TIFM_CORE=m
# CONFIG_TIFM_7XX1 is not set
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_CS5535_MFGPT is not set
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=m
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=m
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=m
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=m
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=m
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
CONFIG_PCH_PHUB=m
CONFIG_USB_SWITCH_FSA9480=m
CONFIG_C2PORT=m
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=m
CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y
CONFIG_IWMC3200TOP=m
# CONFIG_IWMC3200TOP_DEBUG is not set
# CONFIG_IWMC3200TOP_DEBUGFS is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=m
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_INTEL_MEI=m
CONFIG_HAVE_IDE=y
CONFIG_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_BLK_DEV_IDE_SATA=y
# CONFIG_IDE_GD is not set
# CONFIG_BLK_DEV_IDECD is not set
CONFIG_BLK_DEV_IDETAPE=m
CONFIG_BLK_DEV_IDEACPI=y
# CONFIG_IDE_TASK_IOCTL is not set
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
CONFIG_BLK_DEV_PLATFORM=m
CONFIG_BLK_DEV_CMD640=m
# CONFIG_BLK_DEV_CMD640_ENHANCED is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_BLK_DEV_OFFBOARD=y
CONFIG_BLK_DEV_GENERIC=m
CONFIG_BLK_DEV_OPTI621=m
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=m
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
CONFIG_BLK_DEV_ATIIXP=m
CONFIG_BLK_DEV_CMD64X=m
CONFIG_BLK_DEV_TRIFLEX=m
CONFIG_BLK_DEV_CS5520=m
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
CONFIG_BLK_DEV_SC1200=m
# CONFIG_BLK_DEV_PIIX is not set
CONFIG_BLK_DEV_IT8172=m
CONFIG_BLK_DEV_IT8213=m
CONFIG_BLK_DEV_IT821X=m
# CONFIG_BLK_DEV_NS87415 is not set
CONFIG_BLK_DEV_PDC202XX_OLD=m
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
CONFIG_BLK_DEV_SLC90E66=m
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=m
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=m
# CONFIG_SCSI_ENCLOSURE is not set
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=m
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=m
CONFIG_SCSI_DH_RDAC=m
CONFIG_SCSI_DH_HP_SW=m
# CONFIG_SCSI_DH_EMC is not set
# CONFIG_SCSI_DH_ALUA is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
# CONFIG_ATA_ACPI is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
CONFIG_SATA_AHCI_PLATFORM=m
CONFIG_SATA_INIC162X=m
CONFIG_SATA_ACARD_AHCI=m
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
CONFIG_SATA_QSTOR=m
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
# CONFIG_ATA_PIIX is not set
CONFIG_SATA_MV=m
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
CONFIG_SATA_SVW=m
CONFIG_SATA_ULI=m
CONFIG_SATA_VIA=m
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
CONFIG_PATA_ARTOP=m
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
CONFIG_PATA_CMD64X=m
CONFIG_PATA_CS5520=m
# CONFIG_PATA_CS5530 is not set
CONFIG_PATA_CS5536=m
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
CONFIG_PATA_HPT366=m
CONFIG_PATA_HPT37X=m
CONFIG_PATA_HPT3X2N=m
CONFIG_PATA_HPT3X3=m
# CONFIG_PATA_HPT3X3_DMA is not set
CONFIG_PATA_IT8213=m
# CONFIG_PATA_IT821X is not set
CONFIG_PATA_JMICRON=m
# CONFIG_PATA_MARVELL is not set
CONFIG_PATA_NETCELL=m
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
CONFIG_PATA_OPTIDMA=m
CONFIG_PATA_PDC2027X=m
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
CONFIG_PATA_RDC=m
CONFIG_PATA_SC1200=m
CONFIG_PATA_SCH=m
CONFIG_PATA_SERVERWORKS=m
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
CONFIG_PATA_VIA=m
CONFIG_PATA_WINBOND=m

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_NS87410=m
CONFIG_PATA_OPTI=m
CONFIG_PATA_RZ1000=m

#
# Generic fallback / legacy drivers
#
# CONFIG_ATA_GENERIC is not set
CONFIG_PATA_LEGACY=m
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
# CONFIG_BLK_DEV_DM is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=m
CONFIG_I2O=m
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
# CONFIG_I2O_EXT_ADAPTEC is not set
# CONFIG_I2O_CONFIG is not set
CONFIG_I2O_BUS=m
CONFIG_I2O_BLOCK=m
# CONFIG_I2O_SCSI is not set
CONFIG_I2O_PROC=m
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_BONDING=m
CONFIG_DUMMY=m
CONFIG_EQUALIZER=m
CONFIG_NET_FC=y
CONFIG_MII=m
# CONFIG_IEEE802154_DRIVERS is not set
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=m
CONFIG_SUNGEM_PHY=m
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=m
CONFIG_NET_DSA_MV88E6060=m
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
CONFIG_NET_DSA_MV88E6123_61_65=m
CONFIG_ETHERNET=y
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
CONFIG_PCNET32=m
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
CONFIG_ATL1=m
CONFIG_ATL1E=m
# CONFIG_ATL1C is not set
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=m
CONFIG_CNIC=m
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_CALXEDA_XGMAC=m
# CONFIG_NET_VENDOR_CHELSIO is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
CONFIG_DE600=m
# CONFIG_DE620 is not set
# CONFIG_DL2K is not set
CONFIG_SUNDANCE=m
# CONFIG_SUNDANCE_MMIO is not set
# CONFIG_NET_VENDOR_EMULEX is not set
# CONFIG_NET_VENDOR_EXAR is not set
# CONFIG_NET_VENDOR_HP is not set
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=m
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
CONFIG_IGB=m
CONFIG_IGBVF=m
CONFIG_IXGB=m
# CONFIG_IXGBE is not set
# CONFIG_NET_VENDOR_I825XX is not set
CONFIG_IP1000=m
CONFIG_JME=m
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_SKGE is not set
CONFIG_SKY2=m
CONFIG_SKY2_DEBUG=y
# CONFIG_NET_VENDOR_MELLANOX is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MYRI is not set
CONFIG_FEALNX=m
CONFIG_NET_VENDOR_NATSEMI=y
CONFIG_NATSEMI=m
# CONFIG_NS83820 is not set
# CONFIG_NET_VENDOR_8390 is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
CONFIG_QLCNIC=m
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_ATP=m
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
CONFIG_R8169=m
CONFIG_NET_VENDOR_RDC=y
CONFIG_R6040=m
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_SEEQ8005=m
CONFIG_NET_VENDOR_SILAN=y
CONFIG_SC92031=m
# CONFIG_NET_VENDOR_SIS is not set
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
CONFIG_EPIC100=m
CONFIG_SMSC9420=m
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
CONFIG_SUNGEM=m
# CONFIG_CASSINI is not set
CONFIG_NIU=m
CONFIG_NET_VENDOR_TEHUTI=y
CONFIG_TEHUTI=m
CONFIG_NET_VENDOR_TI=y
# CONFIG_TLAN is not set
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
CONFIG_FDDI=m
# CONFIG_DEFXX is not set
# CONFIG_SKFP is not set
CONFIG_HIPPI=y
# CONFIG_ROADRUNNER is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
CONFIG_AMD_PHY=m
# CONFIG_MARVELL_PHY is not set
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
CONFIG_NATIONAL_PHY=m
CONFIG_STE10XP=m
CONFIG_LSI_ET1011C_PHY=m
CONFIG_MICREL_PHY=m
CONFIG_MDIO_BITBANG=m
CONFIG_MDIO_GPIO=m
CONFIG_PLIP=m
CONFIG_PPP=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_FILTER=y
# CONFIG_PPP_MPPE is not set
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPPOE=m
# CONFIG_PPTP is not set
# CONFIG_PPPOL2TP is not set
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
# CONFIG_SLIP is not set
CONFIG_SLHC=m

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_USBNET=m
# CONFIG_USB_NET_AX8817X is not set
CONFIG_USB_NET_CDCETHER=m
# CONFIG_USB_NET_CDC_EEM is not set
CONFIG_USB_NET_CDC_NCM=m
CONFIG_USB_NET_DM9601=m
CONFIG_USB_NET_SMSC75XX=m
CONFIG_USB_NET_SMSC95XX=m
# CONFIG_USB_NET_GL620A is not set
CONFIG_USB_NET_NET1080=m
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
CONFIG_USB_NET_RNDIS_HOST=m
# CONFIG_USB_NET_CDC_SUBSET is not set
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_USB_NET_CX82310_ETH is not set
CONFIG_USB_NET_KALMIA=m
CONFIG_USB_NET_QMI_WWAN=m
# CONFIG_USB_NET_INT51X1 is not set
# CONFIG_USB_CDC_PHONET is not set
# CONFIG_USB_IPHETH is not set
CONFIG_USB_SIERRA_NET=m
# CONFIG_USB_VL600 is not set
CONFIG_WLAN=y
CONFIG_AIRO=m
# CONFIG_ATMEL is not set
CONFIG_PRISM54=m
# CONFIG_USB_ZD1201 is not set
CONFIG_USB_NET_RNDIS_WLAN=m
# CONFIG_ATH_COMMON is not set
# CONFIG_BRCMFMAC is not set
CONFIG_HOSTAP=m
# CONFIG_HOSTAP_FIRMWARE is not set
# CONFIG_HOSTAP_PLX is not set
# CONFIG_HOSTAP_PCI is not set
CONFIG_IPW2100=m
# CONFIG_IPW2100_MONITOR is not set
CONFIG_IPW2100_DEBUG=y
CONFIG_LIBIPW=m
CONFIG_LIBIPW_DEBUG=y
CONFIG_IWM=m
CONFIG_IWM_DEBUG=y
CONFIG_LIBERTAS=m
CONFIG_LIBERTAS_USB=m
# CONFIG_LIBERTAS_SDIO is not set
CONFIG_LIBERTAS_DEBUG=y
CONFIG_LIBERTAS_MESH=y
# CONFIG_WL_TI is not set
CONFIG_MWIFIEX=m
# CONFIG_MWIFIEX_SDIO is not set
CONFIG_MWIFIEX_PCIE=m
# CONFIG_MWIFIEX_USB is not set

#
# WiMAX Wireless Broadband devices
#
# CONFIG_WIMAX_I2400M_USB is not set
# CONFIG_WIMAX_I2400M_SDIO is not set
# CONFIG_WAN is not set
# CONFIG_VMXNET3 is not set
# CONFIG_HYPERV_NET is not set
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
CONFIG_ISDN_CAPI=m
# CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON is not set
CONFIG_CAPI_TRACE=y
# CONFIG_ISDN_CAPI_MIDDLEWARE is not set
CONFIG_ISDN_CAPI_CAPI20=m

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
CONFIG_ISDN_DRV_AVMB1_B1PCI=m
CONFIG_ISDN_DRV_AVMB1_B1PCIV4=y
# CONFIG_ISDN_DRV_AVMB1_T1PCI is not set
CONFIG_ISDN_DRV_AVMB1_C4=m
# CONFIG_CAPI_EICON is not set
# CONFIG_ISDN_DRV_GIGASET is not set
CONFIG_HYSDN=m
CONFIG_HYSDN_CAPI=y
# CONFIG_MISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=m
CONFIG_KEYBOARD_ADP5589=m
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=m
# CONFIG_KEYBOARD_QT2160 is not set
CONFIG_KEYBOARD_LKKBD=m
CONFIG_KEYBOARD_GPIO=m
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
CONFIG_KEYBOARD_MATRIX=m
# CONFIG_KEYBOARD_LM8323 is not set
CONFIG_KEYBOARD_LM8333=m
CONFIG_KEYBOARD_MAX7359=m
# CONFIG_KEYBOARD_MCS is not set
CONFIG_KEYBOARD_MPR121=m
CONFIG_KEYBOARD_NEWTON=m
CONFIG_KEYBOARD_OPENCORES=m
CONFIG_KEYBOARD_STOWAWAY=m
CONFIG_KEYBOARD_SUNKBD=m
# CONFIG_KEYBOARD_OMAP4 is not set
CONFIG_KEYBOARD_XTKBD=m
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=m
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=m
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_DB9 is not set
CONFIG_JOYSTICK_GAMECON=m
CONFIG_JOYSTICK_TURBOGRAFX=m
CONFIG_JOYSTICK_AS5011=m
CONFIG_JOYSTICK_JOYDUMP=m
CONFIG_JOYSTICK_XPAD=m
CONFIG_JOYSTICK_XPAD_FF=y
# CONFIG_JOYSTICK_XPAD_LEDS is not set
CONFIG_JOYSTICK_WALKERA0701=m
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
CONFIG_SERIO_CT82C710=m
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=m
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
# CONFIG_GAMEPORT_EMU10K1 is not set
CONFIG_GAMEPORT_FM801=m

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=m
CONFIG_N_GSM=m
# CONFIG_TRACE_ROUTER is not set
CONFIG_TRACE_SINK=m
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MFD_HSU=m
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_TIMBERDALE=m
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_PCH_UART=m
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=m
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_R3964=m
CONFIG_APPLICOM=m
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI1563=m
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=m
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=m
CONFIG_I2C_PIIX4=m
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_DESIGNWARE_PCI=m
CONFIG_I2C_EG20T=m
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_OCORES=m
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
CONFIG_I2C_PARPORT=m
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_STUB=m
CONFIG_I2C_DEBUG_CORE=y
CONFIG_I2C_DEBUG_ALGO=y
CONFIG_I2C_DEBUG_BUS=y
# CONFIG_SPI is not set
# CONFIG_HSI is not set

#
# PPS support
#
# CONFIG_PPS is not set

#
# PPS generators support
#

#
# PTP clock support
#

#
# Enable Device Drivers -> PPS to see the PTP clock options.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=m

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=m
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_VX855=m

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
CONFIG_GPIO_ADP5588=m

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=m
# CONFIG_GPIO_BT8XX is not set
CONFIG_GPIO_LANGWELL=y
# CONFIG_GPIO_PCH is not set
CONFIG_GPIO_ML_IOH=m
# CONFIG_GPIO_TIMBERDALE is not set
CONFIG_GPIO_RDC321X=m

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MCP23S08=m

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=m
# CONFIG_W1 is not set
# CONFIG_POWER_SUPPLY is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=m
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_GPIO_FAN=m
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM73=m
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=m
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=m
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
CONFIG_SENSORS_LTC4245=m
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_MAX16065=m
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=m
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=m
# CONFIG_SENSORS_SHT21 is not set
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_SMM665=m
CONFIG_SENSORS_DME1737=m
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=m
# CONFIG_SENSORS_SCH5627 is not set
CONFIG_SENSORS_SCH5636=m
CONFIG_SENSORS_ADS1015=m
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA2XX=m
CONFIG_SENSORS_THMC50=m
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_MC13783_ADC=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=m
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_ACQUIRE_WDT=m
CONFIG_ADVANTECH_WDT=m
# CONFIG_ALIM1535_WDT is not set
CONFIG_ALIM7101_WDT=m
CONFIG_F71808E_WDT=m
# CONFIG_SP5100_TCO is not set
CONFIG_SC520_WDT=m
CONFIG_SBC_FITPC2_WATCHDOG=m
CONFIG_EUROTECH_WDT=m
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=m
CONFIG_IE6XX_WDT=m
CONFIG_ITCO_WDT=m
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
CONFIG_SC1200_WDT=m
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=m
CONFIG_60XX_WDT=m
# CONFIG_SBC8360_WDT is not set
CONFIG_CPU5_WDT=m
# CONFIG_SMSC_SCH311X_WDT is not set
CONFIG_SMSC37B787_WDT=m
CONFIG_VIA_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83697HF_WDT=m
CONFIG_W83697UG_WDT=m
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
CONFIG_MACHZ_WDT=m
CONFIG_SBC_EPX_C3_WATCHDOG=m

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=m
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=m
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_PCF50633=m
CONFIG_PCF50633_ADC=m
# CONFIG_PCF50633_GPIO is not set
CONFIG_MFD_MC13783=m
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_I2C=m
CONFIG_ABX500_CORE=y
CONFIG_MFD_CS5535=m
CONFIG_MFD_TIMBERDALE=m
CONFIG_LPC_SCH=m
CONFIG_LPC_ICH=m
CONFIG_MFD_RDC321X=m
CONFIG_MFD_JANZ_CMODIO=m
CONFIG_MFD_VX855=m
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=m
CONFIG_AGP_AMD64=m
CONFIG_AGP_INTEL=m
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
# CONFIG_DRM is not set
CONFIG_STUB_POULSBO=m
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=m
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=m
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
CONFIG_FB_SYS_FOPS=m
# CONFIG_FB_WMT_GE_ROPS is not set
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=m
CONFIG_FB_PM2=m
CONFIG_FB_PM2_FIFO_DISCONNECT=y
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=m
CONFIG_FB_N411=m
# CONFIG_FB_HGA is not set
CONFIG_FB_S1D13XXX=m
CONFIG_FB_NVIDIA=m
# CONFIG_FB_NVIDIA_I2C is not set
CONFIG_FB_NVIDIA_DEBUG=y
CONFIG_FB_NVIDIA_BACKLIGHT=y
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
CONFIG_FB_LE80578=m
CONFIG_FB_CARILLO_RANCH=m
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=m
# CONFIG_FB_RADEON_I2C is not set
CONFIG_FB_RADEON_BACKLIGHT=y
CONFIG_FB_RADEON_DEBUG=y
CONFIG_FB_ATY128=m
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=m
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
# CONFIG_FB_ATY_BACKLIGHT is not set
CONFIG_FB_S3=m
CONFIG_FB_S3_DDC=y
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=m
# CONFIG_FB_VIA_DIRECT_PROCFS is not set
CONFIG_FB_VIA_X_COMPATIBILITY=y
CONFIG_FB_NEOMAGIC=m
CONFIG_FB_KYRO=m
# CONFIG_FB_3DFX is not set
CONFIG_FB_VOODOO1=m
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=m
CONFIG_FB_CARMINE=m
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
CONFIG_FB_GEODE=y
# CONFIG_FB_GEODE_LX is not set
CONFIG_FB_GEODE_GX=m
# CONFIG_FB_GEODE_GX1 is not set
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SM501 is not set
CONFIG_FB_SMSCUFX=m
# CONFIG_FB_UDL is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
CONFIG_FB_MB862XX=m
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
CONFIG_FB_BROADSHEET=m
CONFIG_FB_AUO_K190X=m
# CONFIG_FB_AUO_K1900 is not set
CONFIG_FB_AUO_K1901=m
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=m
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_PROGEAR is not set
CONFIG_BACKLIGHT_APPLE=m
CONFIG_BACKLIGHT_SAHARA=m
CONFIG_BACKLIGHT_ADP8860=m
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_PCF50633=m
# CONFIG_BACKLIGHT_LP855X is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE is not set
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set
# CONFIG_HID_SUPPORT is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=m
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
CONFIG_USB_OTG=y
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_OTG_BLACKLIST_HUB=y
CONFIG_USB_MON=m
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_OXU210HP_HCD is not set
CONFIG_USB_ISP116X_HCD=m
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_ISP1362_HCD=m
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=m
CONFIG_USB_U132_HCD=m
CONFIG_USB_SL811_HCD=m
# CONFIG_USB_SL811_HCD_ISO is not set
CONFIG_USB_R8A66597_HCD=m
# CONFIG_USB_HCD_SSB is not set
CONFIG_USB_CHIPIDEA=m
# CONFIG_USB_CHIPIDEA_HOST is not set
CONFIG_USB_CHIPIDEA_DEBUG=y

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
# CONFIG_USB_STORAGE is not set
CONFIG_USB_UAS=m
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=m
# CONFIG_USB_EZUSB is not set
# CONFIG_USB_SERIAL_GENERIC is not set
# CONFIG_USB_SERIAL_AIRCABLE is not set
CONFIG_USB_SERIAL_ARK3116=m
# CONFIG_USB_SERIAL_BELKIN is not set
CONFIG_USB_SERIAL_CH341=m
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
# CONFIG_USB_SERIAL_EMPEG is not set
CONFIG_USB_SERIAL_FTDI_SIO=m
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
# CONFIG_USB_SERIAL_F81232 is not set
CONFIG_USB_SERIAL_GARMIN=m
# CONFIG_USB_SERIAL_IPW is not set
CONFIG_USB_SERIAL_IUU=m
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
CONFIG_USB_SERIAL_METRO=m
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MOTOROLA is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_QCAUX=m
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIEMENS_MPI=m
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
# CONFIG_USB_SERIAL_XIRCOM is not set
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_VIVOPAY_SERIAL is not set
CONFIG_USB_SERIAL_ZIO=m
CONFIG_USB_SERIAL_SSU100=m
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
# CONFIG_USB_ADUTUX is not set
CONFIG_USB_SEVSEG=m
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=m
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
# CONFIG_USB_APPLEDISPLAY is not set
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=m
CONFIG_USB_TEST=m
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_YUREX is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_ISP1301=m
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=m
CONFIG_NOP_USB_XCEIV=m
# CONFIG_UWB is not set
CONFIG_MMC=m
CONFIG_MMC_DEBUG=y
CONFIG_MMC_UNSAFE_RESUME=y
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
# CONFIG_MMC_SDHCI_PCI is not set
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_CB710 is not set
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MMC_VUB300=m
CONFIG_MMC_USHC=m
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=m
# CONFIG_LEDS_PCA9633 is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=m
CONFIG_LEDS_LT3593=m
CONFIG_LEDS_MC13783=m
CONFIG_LEDS_TCA6507=m
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_GPIO=m
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_A11Y_BRAILLE_CONSOLE is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_DS3232=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_ISL12022=m
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
CONFIG_RTC_DRV_RV3029C2=m

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=m
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
CONFIG_RTC_DRV_MSM6242=m
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set
CONFIG_RTC_DRV_PCF50633=m

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=m
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV=m
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
# CONFIG_UIO_PCI_GENERIC is not set
CONFIG_UIO_NETX=m
CONFIG_VIRTIO=m
CONFIG_VIRTIO_RING=m

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MMIO=m
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=m
# CONFIG_HYPERV_UTILS is not set
CONFIG_STAGING=y
CONFIG_ET131X=m
CONFIG_SLICOSS=m
# CONFIG_USBIP_CORE is not set
CONFIG_PRISM2_USB=m
CONFIG_ECHO=m
CONFIG_COMEDI=m
# CONFIG_COMEDI_DEBUG is not set
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
# CONFIG_COMEDI_MISC_DRIVERS is not set
# CONFIG_COMEDI_PCI_DRIVERS is not set
# CONFIG_COMEDI_PCMCIA_DRIVERS is not set
# CONFIG_COMEDI_USB_DRIVERS is not set
# CONFIG_COMEDI_NI_COMMON is not set
# CONFIG_COMEDI_8255 is not set
CONFIG_COMEDI_FC=m
# CONFIG_ASUS_OLED is not set
# CONFIG_PANEL is not set
CONFIG_R8187SE=m
CONFIG_RTL8192U=m
# CONFIG_RTLLIB is not set
# CONFIG_R8712U is not set
# CONFIG_RTS_PSTOR is not set
CONFIG_RTS5139=m
# CONFIG_RTS5139_DEBUG is not set
# CONFIG_TRANZPORT is not set
CONFIG_IDE_PHISON=m
CONFIG_USB_SERIAL_QUATECH2=m
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
CONFIG_DX_SEP=m

#
# IIO staging drivers
#
CONFIG_IIO_ST_HWMON=m
CONFIG_IIO_SW_RING=m

#
# Accelerometers
#

#
# Analog to digital converters
#
# CONFIG_AD7291 is not set
# CONFIG_AD7606 is not set
CONFIG_AD799X=m
CONFIG_AD799X_RING_BUFFER=y
CONFIG_ADT7410=m
CONFIG_MAX1363=m
CONFIG_MAX1363_RING_BUFFER=y

#
# Analog digital bi-direction converters
#
# CONFIG_ADT7316 is not set

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
# CONFIG_AD7152 is not set
CONFIG_AD7746=m

#
# Digital to analog converters
#
CONFIG_AD5380=m
# CONFIG_MAX517 is not set

#
# Direct Digital Synthesis
#

#
# Digital gyroscope sensors
#

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set

#
# Inertial measurement units
#

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=m
# CONFIG_SENSORS_ISL29028 is not set
CONFIG_SENSORS_TSL2563=m
# CONFIG_TSL2583 is not set
# CONFIG_TSL2x7x is not set

#
# Magnetometer sensors
#
CONFIG_SENSORS_AK8975=m
# CONFIG_SENSORS_HMC5843 is not set

#
# Active energy metering IC
#
# CONFIG_ADE7854 is not set

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
# CONFIG_IIO_PERIODIC_RTC_TRIGGER is not set
# CONFIG_IIO_GPIO_TRIGGER is not set
# CONFIG_IIO_SYSFS_TRIGGER is not set
CONFIG_IIO_DUMMY_EVGEN=m
CONFIG_IIO_SIMPLE_DUMMY=m
CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
# CONFIG_ZRAM is not set
# CONFIG_ZSMALLOC is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_USB_ENESTORAGE is not set
# CONFIG_BCM_WIMAX is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_SPEAKUP=m
# CONFIG_SPEAKUP_SYNTH_ACNTSA is not set
CONFIG_SPEAKUP_SYNTH_ACNTPC=m
CONFIG_SPEAKUP_SYNTH_APOLLO=m
# CONFIG_SPEAKUP_SYNTH_AUDPTR is not set
CONFIG_SPEAKUP_SYNTH_BNS=m
# CONFIG_SPEAKUP_SYNTH_DECTLK is not set
# CONFIG_SPEAKUP_SYNTH_DECEXT is not set
CONFIG_SPEAKUP_SYNTH_DECPC=m
CONFIG_SPEAKUP_SYNTH_DTLK=m
# CONFIG_SPEAKUP_SYNTH_KEYPC is not set
# CONFIG_SPEAKUP_SYNTH_LTLK is not set
# CONFIG_SPEAKUP_SYNTH_SOFT is not set
# CONFIG_SPEAKUP_SYNTH_SPKOUT is not set
CONFIG_SPEAKUP_SYNTH_TXPRT=m
CONFIG_SPEAKUP_SYNTH_DUMMY=m
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
CONFIG_STAGING_MEDIA=y

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_PHONE is not set
# CONFIG_USB_WPAN_HCD is not set
# CONFIG_IPACK_BUS is not set
CONFIG_WIMAX_GDM72XX=m
# CONFIG_WIMAX_GDM72XX_QOS is not set
# CONFIG_WIMAX_GDM72XX_K_MODE is not set
CONFIG_WIMAX_GDM72XX_WIMAX2=y
CONFIG_WIMAX_GDM72XX_USB=y
# CONFIG_WIMAX_GDM72XX_SDIO is not set
CONFIG_WIMAX_GDM72XX_USB_PM=y
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACERHDF=m
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
CONFIG_FUJITSU_LAPTOP=m
CONFIG_FUJITSU_LAPTOP_DEBUG=y
CONFIG_FUJITSU_TABLET=m
CONFIG_HP_ACCEL=m
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=m
# CONFIG_INTEL_MENLOW is not set
CONFIG_EEEPC_LAPTOP=m
# CONFIG_ACPI_WMI is not set
CONFIG_TOPSTAR_LAPTOP=m
CONFIG_TOSHIBA_BT_RFKILL=m
CONFIG_ACPI_CMPC=m
CONFIG_INTEL_IPS=m
CONFIG_IBM_RTL=m
CONFIG_XO15_EBOOK=m
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
CONFIG_VIRT_DRIVERS=y
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=m

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
CONFIG_MEMORY=y
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Analog to digital converters
#

#
# Amplifiers
#
CONFIG_VME_BUS=m

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=m
# CONFIG_VME_TSI148 is not set

#
# VME Board Drivers
#
# CONFIG_VMIVME_7805 is not set

#
# VME Device Drivers
#
CONFIG_VME_USER=m
# CONFIG_VME_PIO2 is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_EFI_VARS is not set
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=m
# CONFIG_DMIID is not set
CONFIG_DMI_SYSFS=m
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=m
# CONFIG_EXT2_FS_XATTR is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=m
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=m
CONFIG_EXT4_FS_XATTR=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_EXT4_DEBUG=y
CONFIG_FS_XIP=y
CONFIG_JBD=m
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=m
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=m
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
# CONFIG_JFS_SECURITY is not set
CONFIG_JFS_DEBUG=y
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=m
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
CONFIG_XFS_RT=y
CONFIG_XFS_DEBUG=y
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=m
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=m
CONFIG_FILE_LOCKING=y
# CONFIG_FSNOTIFY is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=m
CONFIG_QFMT_V1=m
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=m
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=m
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=m
# CONFIG_BEFS_FS is not set
CONFIG_BFS_FS=m
CONFIG_EFS_FS=m
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_DEBUG=0
# CONFIG_JFFS2_FS_WRITEBUFFER is not set
# CONFIG_JFFS2_SUMMARY is not set
CONFIG_JFFS2_FS_XATTR=y
CONFIG_JFFS2_FS_POSIX_ACL=y
# CONFIG_JFFS2_FS_SECURITY is not set
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
CONFIG_UBIFS_FS=m
# CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
CONFIG_LOGFS=m
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=m
CONFIG_OMFS_FS=m
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=m
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_PSTORE_RAM is not set
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
CONFIG_UFS_DEBUG=y
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NFS_FS is not set
# CONFIG_NFSD is not set
CONFIG_CEPH_FS=m
# CONFIG_CIFS is not set
CONFIG_NCP_FS=m
# CONFIG_NCPFS_PACKET_SIGNING is not set
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
CONFIG_NCPFS_NFS_NS=y
# CONFIG_NCPFS_OS2_NS is not set
# CONFIG_NCPFS_SMALLDOS is not set
# CONFIG_NCPFS_NLS is not set
# CONFIG_NCPFS_EXTRAS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=m
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=m
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=m
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=m
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=m
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=m
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_SLUB_STATS=y
CONFIG_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=400
CONFIG_DEBUG_KMEMLEAK_TEST=m
# CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
# CONFIG_DEBUG_ATOMIC_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_BLOCK_EXT_DEVT=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
# CONFIG_KGDB_SERIAL_CONSOLE is not set
CONFIG_KGDB_TESTS=y
CONFIG_KGDB_TESTS_ON_BOOT=y
CONFIG_KGDB_TESTS_BOOT_STRING="V1F100"
CONFIG_KGDB_LOW_LEVEL_TRAP=y
# CONFIG_KGDB_KDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
CONFIG_TEST_KSTRTOX=m
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_IOMMU_DEBUG is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
# CONFIG_DEBUG_BOOT_PARAMS is not set
CONFIG_CPA_DEBUG=y
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=m

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=m
CONFIG_CRYPTO_ALGAPI2=m
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=m
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER2=m
CONFIG_CRYPTO_HASH=m
CONFIG_CRYPTO_HASH2=m
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=m
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=m
CONFIG_CRYPTO_MANAGER=m
CONFIG_CRYPTO_MANAGER2=m
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=m
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=m
CONFIG_CRYPTO_CRYPTD=m
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=m
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_GHASH=m
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA1_SSSE3=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_X86_64=m
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAST5=m
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_X86_64=m
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_TEA=m
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=m
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=m
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
# CONFIG_AVERAGE is not set
# CONFIG_CORDIC is not set
CONFIG_DDR=y

--sdtB3X0nJg68CQEu--
