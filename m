Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266Ab2JIEAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 00:00:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:19143 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab2JIEAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 00:00:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,557,1344236400"; 
   d="scan'208";a="203240853"
Date: Tue, 9 Oct 2012 12:00:34 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: kvm vmwrite error
Message-ID: <20121009040034.GA13022@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

FYI, I got lots of these errors in 3.6.0 in one of my test box.
Attached is the full dmesg.

[ 5174.699117] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5174.701692] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5174.701696] Pid: 3948, comm: kvm Not tainted 3.6.0 #23
[ 5174.701696] Call Trace:
[ 5174.701708]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5174.701713]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5174.701716]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5174.701719]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5174.701723]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5174.701725]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5174.701727]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5174.701730]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5174.701732]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5174.701736]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5174.701740]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5174.701742]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5174.701746]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5174.702587] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5174.702589] Pid: 3947, comm: kvm Not tainted 3.6.0 #23
[ 5174.702589] Call Trace:
[ 5174.702594]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5174.702597]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5174.702599]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5174.702601]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5174.702603]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5174.702606]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5174.702608]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5174.702609]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5174.702611]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5174.702614]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5174.702616]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5174.702617]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5174.702620]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b

Another test box running the same kernel hangs and keep emitting the
following dmesg lines:

vmx_handle_exit: unexpected, valid vectoring info (0x80000b0e) and
exit reason is 0x31

Thanks,
Fengguang

--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=bens-kvm-dmesg

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.0 (wfg@bee) (gcc version 4.6.3 (Debian 4.6.3-1) ) #23 SMP Mon Oct 8 09:07:07 CST 2012
[    0.000000] Command line: BOOT_IMAGE=x86_64/vmlinuz-3.6.0 hpet=disable pci=nomsi log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal netconsole=6667@192.168.1.134:/eth0,6666@192.168.1.1/00:1b:21:11:78:3e ip=192.168.1.134:192.168.1.1:192.168.1.1:255.255.255.0:bens:eth0:none nfsroot=192.168.1.1:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009dbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009dc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e4000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bff5ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bff60000-0x00000000bff68fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bff69000-0x00000000bff7ffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bff80000-0x00000000bfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000013fffffff] usable
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: Supermicro X7DB8/X7DB8, BIOS 6.00 04/28/2006
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x140000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E3FFF uncachable
[    0.000000]   E4000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   1 base 000000000 mask F00000000 write-back
[    0.000000]   2 base 100000000 mask FC0000000 write-back
[    0.000000]   3 base 0BFF80000 mask FFFF80000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xbff80000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xbff60 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f58f0-0x000f58ff] mapped at [ffff8800000f58f0]
[    0.000000]   mpc: 9e171-9e33d
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0xbff5ffff]
[    0.000000]  [mem 0x00000000-0xbfdfffff] page 2M
[    0.000000]  [mem 0xbfe00000-0xbff5ffff] page 4k
[    0.000000] kernel direct mapping tables up to 0xbff5ffff @ [mem 0x1f9fc000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x13fffffff]
[    0.000000]  [mem 0x100000000-0x13fffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x13fffffff @ [mem 0xbff5a000-0xbff5ffff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 257944(98%)
[    0.000000] ACPI: RSDP 00000000000f58c0 00014 (v00 PTLTD )
[    0.000000] ACPI: RSDT 00000000bff64382 0003C (v01 PTLTD    RSDT   06040000  LTP 00000000)
[    0.000000] ACPI: FACP 00000000bff68e48 00074 (v01 INTEL  TUMWATER 06040000 PTL  00000003)
[    0.000000] ACPI: DSDT 00000000bff64a6a 043DE (v01  Intel BLAKFORD 06040000 MSFT 0100000E)
[    0.000000] ACPI: FACS 00000000bff69fc0 00040
[    0.000000] ACPI: APIC 00000000bff68ebc 00090 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: MCFG 00000000bff68f4c 0003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000bff68f88 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: SPCR 00000000bff68fb0 00050 (v01 PTLTD  $UCRTBL$ 06040000 PTL  00000001)
[    0.000000] ACPI: SSDT 00000000bff643be 006AC (v01 DpgPmm    CpuPm 00000012 INTL 20030224)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000013fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13fffffff]
[    0.000000]   NODE_DATA [mem 0x13f7fb000-0x13f7fffff]
[    0.000000]  [ffffea0000000000-ffffea0004ffffff] PMD -> [ffff88013ae00000-ffff88013edfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x13fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0xbff5ffff]
[    0.000000]   node   0: [mem 0x100000000-0x13fffffff]
[    0.000000] On node 0 totalpages: 1048301
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3911 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 765856 pages, LIFO batch:31
[    0.000000]   Normal zone: 4096 pages used for memmap
[    0.000000]   Normal zone: 258048 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec80000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 3, version 32, address 0xfec80000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] Int: type 0, pol 1, trig 1, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec80000)
[    0.000000] nr_irqs_gsi: 64
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bff60000 - 00000000bff69000
[    0.000000] PM: Registered nosave memory: 00000000bff69000 - 00000000bff80000
[    0.000000] PM: Registered nosave memory: 00000000bff80000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff000000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
[    0.000000] e820: [mem 0xc0000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88013f400000 s80640 r8192 d21760 u524288
[    0.000000] pcpu-alloc: s80640 r8192 d21760 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1027815
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=x86_64/vmlinuz-3.6.0 hpet=disable pci=nomsi log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal netconsole=6667@192.168.1.134:/eth0,6666@192.168.1.1/00:1b:21:11:78:3e ip=192.168.1.134:192.168.1.1:192.168.1.1:255.255.255.0:bens:eth0:none nfsroot=192.168.1.1:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 4034604k/5242880k available (9720k kernel code, 1049676k absent, 158600k reserved, 6032k data, 972k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU debugfs-based tracing is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=64 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:4352 nr_irqs:1024 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2666.448 MHz processor
[    0.004004] Calibrating delay loop (skipped), value calculated using timer frequency.. 5332.89 BogoMIPS (lpj=2666448)
[    0.006002] pid_max: default: 32768 minimum: 301
[    0.008294] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.012618] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.015204] Mount-cache hash table entries: 256
[    0.017331] Initializing cgroup subsys debug
[    0.018003] Initializing cgroup subsys cpuacct
[    0.019000] Initializing cgroup subsys devices
[    0.020000] Initializing cgroup subsys freezer
[    0.021000] Initializing cgroup subsys blkio
[    0.022041] CPU: Physical Processor ID: 0
[    0.022999] CPU: Processor Core ID: 0
[    0.024000] mce: CPU supports 6 MCE banks
[    0.025005] CPU0: Thermal monitoring handled by SMI
[    0.026002] process: using mwait in idle threads
[    0.028003] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
[    0.028003] Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32
[    0.028003] tlb_flushall_shift is 0xffffffff
[    0.031187] ACPI: Core revision 20120711
[    0.035944] ftrace: allocating 38132 entries in 149 pages
[    0.046090] Getting VERSION: 50014
[    0.046997] Getting VERSION: 50014
[    0.047995] Getting ID: 0
[    0.048995] Getting ID: 0
[    0.049998] enabled ExtINT on CPU#0
[    0.051264] ENABLING IO-APIC IRQs
[    0.051994] init IO_APIC IRQs
[    0.052995]  apic 2 pin 0 not connected
[    0.053999] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.054999] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.055998] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.056996] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.057996] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.058996] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.059996] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.060996] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.061996] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.062995] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
[    0.063997] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
[    0.064995] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.065995] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.066995] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.067995] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.068993]  apic 2 pin 16 not connected
[    0.069991]  apic 2 pin 17 not connected
[    0.070990]  apic 2 pin 18 not connected
[    0.071990]  apic 2 pin 19 not connected
[    0.072990]  apic 2 pin 20 not connected
[    0.073990]  apic 2 pin 21 not connected
[    0.074990]  apic 2 pin 22 not connected
[    0.075990]  apic 2 pin 23 not connected
[    0.076990]  apic 3 pin 0 not connected
[    0.077989]  apic 3 pin 1 not connected
[    0.078989]  apic 3 pin 2 not connected
[    0.079989]  apic 3 pin 3 not connected
[    0.080989]  apic 3 pin 4 not connected
[    0.081989]  apic 3 pin 5 not connected
[    0.082989]  apic 3 pin 6 not connected
[    0.083988]  apic 3 pin 7 not connected
[    0.084988]  apic 3 pin 8 not connected
[    0.085988]  apic 3 pin 9 not connected
[    0.086988]  apic 3 pin 10 not connected
[    0.087988]  apic 3 pin 11 not connected
[    0.088988]  apic 3 pin 12 not connected
[    0.089988]  apic 3 pin 13 not connected
[    0.090987]  apic 3 pin 14 not connected
[    0.091987]  apic 3 pin 15 not connected
[    0.092987]  apic 3 pin 16 not connected
[    0.093987]  apic 3 pin 17 not connected
[    0.094987]  apic 3 pin 18 not connected
[    0.095987]  apic 3 pin 19 not connected
[    0.096986]  apic 3 pin 20 not connected
[    0.097986]  apic 3 pin 21 not connected
[    0.098986]  apic 3 pin 22 not connected
[    0.099986]  apic 3 pin 23 not connected
[    0.101117] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.112112] smpboot: CPU0: Genuine Intel(R) CPU                  @ 2.66GHz stepping 04
[    0.114984] Using local APIC timer interrupts.
[    0.114984] calibrating APIC timer ...
[    0.116982] ... lapic delta = 2083020
[    0.116982] ... PM-Timer delta = 357900
[    0.116982] ... PM-Timer result ok
[    0.116982] ..... delta 2083020
[    0.116982] ..... mult: 89478628
[    0.116982] ..... calibration result: 333283
[    0.116982] ..... CPU clock speed is 2666.0265 MHz.
[    0.116982] ..... host bus clock speed is 333.0283 MHz.
[    0.116996] Performance Events: PEBS fmt0-, 4-deep LBR, Core2 events, Intel PMU driver.
[    0.121982] perf_event_intel: PEBS disabled due to CPU errata
[    0.122983] ... version:                2
[    0.123982] ... bit width:              40
[    0.124982] ... generic registers:      2
[    0.125982] ... value mask:             000000ffffffffff
[    0.126982] ... max period:             000000007fffffff
[    0.127981] ... fixed-purpose events:   3
[    0.128981] ... event mask:             0000000700000003
[    0.130303] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.004999] masked ExtINT on CPU#1
[    0.004999] CPU1: Thermal monitoring handled by SMI
[    0.004999] masked ExtINT on CPU#2
[    0.004999] CPU2: Thermal monitoring handled by SMI
[    0.131132] smpboot: Booting Node   0, Processors  #1 #2 #3 OK
[    0.004999] masked ExtINT on CPU#3
[    0.004999] CPU3: Thermal monitoring handled by SMI
[    0.255017] Brought up 4 CPUs
[    0.255964] smpboot: Total of 4 processors activated (21331.00 BogoMIPS)
[    0.258036] CPU0 attaching sched-domain:
[    0.258969]  domain 0: span 0,2 level MC
[    0.260961]   groups: 0 (cpu_power = 1023) 2
[    0.263636]   domain 1: span 0-3 level CPU
[    0.264960]    groups: 0,2 (cpu_power = 2047) 1,3 (cpu_power = 2048)
[    0.270964] CPU1 attaching sched-domain:
[    0.271960]  domain 0: span 1,3 level MC
[    0.273959]   groups: 1 3
[    0.276625]   domain 1: span 0-3 level CPU
[    0.277959]    groups: 1,3 (cpu_power = 2048) 0,2 (cpu_power = 2047)
[    0.281960] CPU2 attaching sched-domain:
[    0.282959]  domain 0: span 0,2 level MC
[    0.284957]   groups: 2 0 (cpu_power = 1023)
[    0.288957]   domain 1: span 0-3 level CPU
[    0.290958]    groups: 0,2 (cpu_power = 2047) 1,3 (cpu_power = 2048)
[    0.295398] CPU3 attaching sched-domain:
[    0.295956]  domain 0: span 1,3 level MC
[    0.297955]   groups: 3 1
[    0.299956]   domain 1: span 0-3 level CPU
[    0.301955]    groups: 1,3 (cpu_power = 2048) 0,2 (cpu_power = 2047)
[    0.307483] devtmpfs: initialized
[    0.310964] PM: Registering ACPI NVS region [mem 0xbff69000-0xbff7ffff] (94208 bytes)
[    0.312614] xor: automatically using best checksumming function:
[    0.322953]    generic_sse:  9748.000 MB/sec
[    0.323986] RTC time: 10:24:41, date: 10/09/12
[    0.325003] NET: Registered protocol family 16
[    0.328063] ACPI: bus type pci registered
[    0.328985] dca service started, version 1.12.1
[    0.329968] PCI: MMCONFIG for domain 0000 [bus 00-0a] at [mem 0xe0000000-0xe0afffff] (base 0xe0000000)
[    0.330954] PCI: MMCONFIG at [mem 0xe0000000-0xe0afffff] reserved in E820
[    0.332609] PCI: Using configuration type 1 for base access
[    0.357088] bio: create slab <bio-0> at 0
[    0.374960] raid6: sse2x1    3261 MB/s
[    0.392943] raid6: sse2x2    6761 MB/s
[    0.410941] raid6: sse2x4    7460 MB/s
[    0.411939] raid6: using algorithm sse2x4 (7460 MB/s)
[    0.412938] raid6: using ssse3x2 recovery algorithm
[    0.413958] ACPI: Added _OSI(Module Device)
[    0.414941] ACPI: Added _OSI(Processor Device)
[    0.415939] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.416938] ACPI: Added _OSI(Processor Aggregator Device)
[    0.419187] ACPI: EC: Look up EC in DSDT
[    0.423217] ACPI: Interpreter enabled
[    0.423941] ACPI: (supports S0 S1 S4 S5)
[    0.426463] ACPI: Using IOAPIC for interrupt routing
[    0.434071] ACPI: No dock devices found.
[    0.434939] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.437104] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.440738] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.440936] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.441935] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.442937] pci_root PNP0A03:00: host bridge window [mem 0x000cc000-0x000cffff] (ignored)
[    0.443935] pci_root PNP0A03:00: host bridge window [mem 0x000d8000-0x000dbfff] (ignored)
[    0.444935] pci_root PNP0A03:00: host bridge window [mem 0x000dc000-0x000dffff] (ignored)
[    0.445935] pci_root PNP0A03:00: host bridge window [mem 0x000e0000-0x000e3fff] (ignored)
[    0.446936] pci_root PNP0A03:00: host bridge window [mem 0xc0000000-0xfdffffff] (ignored)
[    0.447935] PCI: root bus 00: using default resources
[    0.448937] pci_root PNP0A03:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-0a] only partially covers this bridge
[    0.449962] PCI host bridge to bus 0000:00
[    0.450938] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under domain [bus 00-ff]
[    0.451934] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.452934] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.453934] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffffff]
[    0.454947] pci 0000:00:00.0: [8086:25d8] type 00 class 0x060000
[    0.455981] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.456951] pci 0000:00:02.0: [8086:25f7] type 01 class 0x060400
[    0.457974] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.458950] pci 0000:00:04.0: [8086:25f8] type 01 class 0x060400
[    0.459974] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.460948] pci 0000:00:06.0: [8086:25f9] type 01 class 0x060400
[    0.461974] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.462949] pci 0000:00:08.0: [8086:1a38] type 00 class 0x088000
[    0.463940] pci 0000:00:08.0: reg 10: [mem 0xfe700000-0xfe7003ff 64bit]
[    0.464970] pci 0000:00:08.0: PME# supported from D0 D3hot D3cold
[    0.465948] pci 0000:00:10.0: [8086:25f0] type 00 class 0x060000
[    0.466958] pci 0000:00:10.1: [8086:25f0] type 00 class 0x060000
[    0.467957] pci 0000:00:10.2: [8086:25f0] type 00 class 0x060000
[    0.468965] pci 0000:00:11.0: [8086:25f1] type 00 class 0x060000
[    0.469957] pci 0000:00:13.0: [8086:25f3] type 00 class 0x060000
[    0.470956] pci 0000:00:15.0: [8086:25f5] type 00 class 0x060000
[    0.471955] pci 0000:00:16.0: [8086:25f6] type 00 class 0x060000
[    0.472964] pci 0000:00:1c.0: [8086:2690] type 01 class 0x060400
[    0.473997] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.474953] pci 0000:00:1d.0: [8086:2688] type 00 class 0x0c0300
[    0.475967] pci 0000:00:1d.0: reg 20: [io  0x1800-0x181f]
[    0.476958] pci 0000:00:1d.1: [8086:2689] type 00 class 0x0c0300
[    0.477966] pci 0000:00:1d.1: reg 20: [io  0x1820-0x183f]
[    0.478957] pci 0000:00:1d.2: [8086:268a] type 00 class 0x0c0300
[    0.479966] pci 0000:00:1d.2: reg 20: [io  0x1840-0x185f]
[    0.480967] pci 0000:00:1d.7: [8086:268c] type 00 class 0x0c0320
[    0.481946] pci 0000:00:1d.7: reg 10: [mem 0xc8000000-0xc80003ff]
[    0.483007] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.483946] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.484984] pci 0000:00:1f.0: [8086:2670] type 00 class 0x060100
[    0.486003] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.486946] pci 0000:00:1f.2: [8086:2680] type 00 class 0x010180
[    0.487940] pci 0000:00:1f.2: reg 10: [io  0x0000-0x0007]
[    0.488934] pci 0000:00:1f.2: reg 14: [io  0x0000-0x0003]
[    0.489933] pci 0000:00:1f.2: reg 18: [io  0x0000-0x0007]
[    0.490933] pci 0000:00:1f.2: reg 1c: [io  0x0000-0x0003]
[    0.491933] pci 0000:00:1f.2: reg 20: [io  0x1870-0x187f]
[    0.492960] pci 0000:00:1f.2: PME# supported from D3hot
[    0.493940] pci 0000:00:1f.3: [8086:269b] type 00 class 0x0c0500
[    0.494975] pci 0000:00:1f.3: reg 20: [io  0x1100-0x111f]
[    0.496955] pci_bus 0000:01: busn_res: [bus 01-07] is inserted under [bus 00-ff]
[    0.497935] pci 0000:01:00.0: [8086:3500] type 01 class 0x060400
[    0.498983] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.499945] pci 0000:01:00.3: [8086:350c] type 01 class 0x060400
[    0.500981] pci 0000:01:00.3: PME# supported from D0 D3hot D3cold
[    0.501939] pci 0000:00:02.0: PCI bridge to [bus 01-07]
[    0.502927] pci 0000:00:02.0:   bridge window [io  0x2000-0x3fff]
[    0.503927] pci 0000:00:02.0:   bridge window [mem 0xc8100000-0xc82fffff]
[    0.504928] pci 0000:00:02.0:   bridge window [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.505953] pci_bus 0000:02: busn_res: [bus 02-06] is inserted under [bus 01-07]
[    0.506933] pci 0000:02:00.0: [8086:3510] type 01 class 0x060400
[    0.507989] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.508948] pci 0000:02:02.0: [8086:3518] type 01 class 0x060400
[    0.509987] pci 0000:02:02.0: PME# supported from D0 D3hot D3cold
[    0.510958] pci 0000:01:00.0: PCI bridge to [bus 02-06]
[    0.511926] pci 0000:01:00.0:   bridge window [io  0x2000-0x3fff]
[    0.512926] pci 0000:01:00.0:   bridge window [mem 0xc8100000-0xc82fffff]
[    0.513927] pci 0000:01:00.0:   bridge window [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.514957] pci_bus 0000:03: busn_res: [bus 03-05] is inserted under [bus 02-06]
[    0.515933] pci 0000:03:00.0: [8086:0329] type 01 class 0x060400
[    0.516941] pci 0000:03:00.0: PXH quirk detected; SHPC device MSI disabled
[    0.517991] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.518947] pci 0000:03:00.2: [8086:032a] type 01 class 0x060400
[    0.519940] pci 0000:03:00.2: PXH quirk detected; SHPC device MSI disabled
[    0.520991] pci 0000:03:00.2: PME# supported from D0 D3hot D3cold
[    0.521940] pci 0000:02:00.0: PCI bridge to [bus 03-05]
[    0.522924] pci 0000:02:00.0:   bridge window [io  0x2000-0x2fff]
[    0.524923] pci 0000:02:00.0:   bridge window [mem 0xc8100000-0xc81fffff]
[    0.525926] pci 0000:02:00.0:   bridge window [mem 0xc0000000-0xc00fffff 64bit pref]
[    0.526955] pci_bus 0000:04: busn_res: [bus 04] is inserted under [bus 03-05]
[    0.527939] pci 0000:04:02.0: [9005:801d] type 00 class 0x010000
[    0.528941] pci 0000:04:02.0: reg 10: [io  0x2400-0x24ff]
[    0.529934] pci 0000:04:02.0: reg 14: [mem 0xc8100000-0xc8101fff 64bit]
[    0.530929] pci 0000:04:02.0: reg 1c: [io  0x2000-0x20ff]
[    0.531945] pci 0000:04:02.0: reg 30: [mem 0x00000000-0x0007ffff pref]
[    0.533935] pci 0000:04:02.1: [9005:801d] type 00 class 0x010000
[    0.534940] pci 0000:04:02.1: reg 10: [io  0x2c00-0x2cff]
[    0.535933] pci 0000:04:02.1: reg 14: [mem 0xc8102000-0xc8103fff 64bit]
[    0.536928] pci 0000:04:02.1: reg 1c: [io  0x2800-0x28ff]
[    0.537944] pci 0000:04:02.1: reg 30: [mem 0x00000000-0x0007ffff pref]
[    0.539013] pci 0000:03:00.0: PCI bridge to [bus 04]
[    0.539922] pci 0000:03:00.0:   bridge window [io  0x2000-0x2fff]
[    0.540922] pci 0000:03:00.0:   bridge window [mem 0xc8100000-0xc81fffff]
[    0.541924] pci 0000:03:00.0:   bridge window [mem 0xc0000000-0xc00fffff 64bit pref]
[    0.542954] pci_bus 0000:05: busn_res: [bus 05] is inserted under [bus 03-05]
[    0.543956] pci 0000:03:00.2: PCI bridge to [bus 05]
[    0.544970] pci_bus 0000:06: busn_res: [bus 06] is inserted under [bus 02-06]
[    0.545934] pci 0000:06:00.0: [8086:1096] type 00 class 0x020000
[    0.546931] pci 0000:06:00.0: reg 10: [mem 0xc8220000-0xc823ffff]
[    0.547927] pci 0000:06:00.0: reg 14: [mem 0xc8200000-0xc821ffff]
[    0.548927] pci 0000:06:00.0: reg 18: [io  0x3000-0x301f]
[    0.549951] pci 0000:06:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.550961] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    0.551947] pci 0000:06:00.1: [8086:1096] type 00 class 0x020000
[    0.552930] pci 0000:06:00.1: reg 10: [mem 0xc8260000-0xc827ffff]
[    0.553926] pci 0000:06:00.1: reg 14: [mem 0xc8240000-0xc825ffff]
[    0.554926] pci 0000:06:00.1: reg 18: [io  0x3020-0x303f]
[    0.555950] pci 0000:06:00.1: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.556960] pci 0000:06:00.1: PME# supported from D0 D3hot D3cold
[    0.558916] pci 0000:02:02.0: PCI bridge to [bus 06]
[    0.559919] pci 0000:02:02.0:   bridge window [io  0x3000-0x3fff]
[    0.560919] pci 0000:02:02.0:   bridge window [mem 0xc8200000-0xc82fffff]
[    0.561920] pci 0000:02:02.0:   bridge window [mem 0xc0100000-0xc01fffff 64bit pref]
[    0.562952] pci_bus 0000:07: busn_res: [bus 07] is inserted under [bus 01-07]
[    0.563947] pci 0000:01:00.3: PCI bridge to [bus 07]
[    0.564953] pci_bus 0000:08: busn_res: [bus 08] is inserted under [bus 00-ff]
[    0.565917] pci 0000:00:04.0: PCI bridge to [bus 08]
[    0.566944] pci_bus 0000:09: busn_res: [bus 09] is inserted under [bus 00-ff]
[    0.567917] pci 0000:00:06.0: PCI bridge to [bus 09]
[    0.568960] pci_bus 0000:0a: busn_res: [bus 0a] is inserted under [bus 00-ff]
[    0.569917] pci 0000:00:1c.0: PCI bridge to [bus 0a]
[    0.570917] pci 0000:00:1c.0:   bridge window [io  0x5000-0x5fff]
[    0.571917] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff]
[    0.572918] pci 0000:00:1c.0:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.573934] pci_bus 0000:0b: busn_res: [bus 0b] is inserted under [bus 00-ff]
[    0.574926] pci 0000:0b:01.0: [1002:515e] type 00 class 0x030000
[    0.575930] pci 0000:0b:01.0: reg 10: [mem 0xd0000000-0xd7ffffff pref]
[    0.576923] pci 0000:0b:01.0: reg 14: [io  0x4000-0x40ff]
[    0.577922] pci 0000:0b:01.0: reg 18: [mem 0xc8300000-0xc830ffff]
[    0.578946] pci 0000:0b:01.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.579941] pci 0000:0b:01.0: supports D1 D2
[    0.580956] pci 0000:00:1e.0: PCI bridge to [bus 0b] (subtractive decode)
[    0.581915] pci 0000:00:1e.0:   bridge window [io  0x4000-0x4fff]
[    0.582915] pci 0000:00:1e.0:   bridge window [mem 0xc8300000-0xc83fffff]
[    0.583917] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
[    0.584914] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    0.585913] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xfffffffff] (subtractive decode)
[    0.586931] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.588311] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    0.588956] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2.BMD0._PRT]
[    0.589982] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2.BMD0.BPD0.PXH0._PRT]
[    0.591012] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2.BMD0.BPD0.PXH1._PRT]
[    0.591986] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2.BMD0.BPD2._PRT]
[    0.592964] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2.BMF3._PRT]
[    0.593979] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.594980] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    0.596925] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.598000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.598980]  pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.599911]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.609983] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 14 15)
[    0.614988] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 14 15)
[    0.619932] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11 14 15)
[    0.624563] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 14 15)
[    0.628416] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
[    0.633429] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 6 7 10 11 14 15) *0, disabled.
[    0.638422] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
[    0.643982] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 6 7 10 11 14 15) *0, disabled.
[    0.649938] vgaarb: device added: PCI:0000:0b:01.0,decodes=io+mem,owns=io+mem,locks=none
[    0.650904] vgaarb: loaded
[    0.651902] vgaarb: bridge control possible 0000:0b:01.0
[    0.652985] SCSI subsystem initialized
[    0.653906] ACPI: bus type scsi registered
[    0.654926] libata version 3.00 loaded.
[    0.655925] ACPI: bus type usb registered
[    0.656926] usbcore: registered new interface driver usbfs
[    0.657918] usbcore: registered new interface driver hub
[    0.658920] usbcore: registered new device driver usb
[    0.659923] wmi: Mapper loaded
[    0.660918] Advanced Linux Sound Architecture Driver Version 1.0.25.
[    0.661903] PCI: Using ACPI for IRQ routing
[    0.662904] PCI: pci_cache_line_size set to 64 bytes
[    0.664005] e820: reserve RAM buffer [mem 0x0009dc00-0x0009ffff]
[    0.664901] e820: reserve RAM buffer [mem 0xbff60000-0xbfffffff]
[    0.681400] pnp: PnP ACPI init
[    0.681914] ACPI: bus type pnp registered
[    0.684241] pnp 00:00: [bus 00-ff]
[    0.685901] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.686898] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.687898] pnp 00:00: [io  0x0d00-0xffff window]
[    0.688898] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.689900] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.690898] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.691897] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.692897] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.693899] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.694897] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.695896] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.696896] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.697896] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.698900] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.699896] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.700896] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.701895] pnp 00:00: [mem 0xc0000000-0xfdffffff window]
[    0.702960] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.704083] pnp 00:01: [io  0x0010-0x001f]
[    0.704895] pnp 00:01: [io  0x0024-0x0025]
[    0.705895] pnp 00:01: [io  0x0028-0x0029]
[    0.706897] pnp 00:01: [io  0x002c-0x002d]
[    0.707895] pnp 00:01: [io  0x002e-0x002f]
[    0.708894] pnp 00:01: [io  0x0030-0x0031]
[    0.709895] pnp 00:01: [io  0x0034-0x0035]
[    0.710896] pnp 00:01: [io  0x0038-0x0039]
[    0.711894] pnp 00:01: [io  0x003c-0x003d]
[    0.712894] pnp 00:01: [io  0x004e-0x004f]
[    0.713894] pnp 00:01: [io  0x0050-0x0053]
[    0.714895] pnp 00:01: [io  0x0060]
[    0.715894] pnp 00:01: [io  0x0064]
[    0.716893] pnp 00:01: [io  0x0063]
[    0.717893] pnp 00:01: [io  0x0065]
[    0.718893] pnp 00:01: [io  0x0067]
[    0.719893] pnp 00:01: [io  0x0072-0x0077]
[    0.720892] pnp 00:01: [io  0x0080]
[    0.721892] pnp 00:01: [io  0x0090-0x009f]
[    0.722892] pnp 00:01: [io  0x00a4-0x00a5]
[    0.723892] pnp 00:01: [io  0x00a8-0x00a9]
[    0.724892] pnp 00:01: [io  0x00ac-0x00ad]
[    0.725892] pnp 00:01: [io  0x00b0-0x00b5]
[    0.726891] pnp 00:01: [io  0x00b8-0x00b9]
[    0.727891] pnp 00:01: [io  0x00bc-0x00bd]
[    0.728891] pnp 00:01: [io  0x04d0-0x04d1]
[    0.729891] pnp 00:01: [io  0x0295-0x0296]
[    0.730891] pnp 00:01: [io  0x0ca2-0x0ca3]
[    0.731891] pnp 00:01: [io  0x0ca8-0x0caf]
[    0.732891] pnp 00:01: [io  0x1000-0x107f]
[    0.733890] pnp 00:01: [io  0x1180-0x11bf]
[    0.734890] pnp 00:01: [io  0x0800-0x080f]
[    0.735890] pnp 00:01: [io  0xfe00]
[    0.736890] pnp 00:01: [mem 0xe0000000-0xefffffff]
[    0.737890] pnp 00:01: [mem 0xfee00000-0xfee0ffff]
[    0.738890] pnp 00:01: [mem 0xfec80000-0xfec80fff]
[    0.739889] pnp 00:01: [mem 0xfed1c000-0xfed1ffff]
[    0.740889] pnp 00:01: [mem 0xfe000000-0xfe007fff]
[    0.741894] pnp 00:01: [mem 0xfe600000-0xfe6fffff]
[    0.742889] pnp 00:01: [mem 0x00000400-0x000004ff]
[    0.743966] pnp 00:01: disabling [mem 0x00000400-0x000004ff] because it overlaps 0000:04:02.0 BAR 6 [mem 0x00000000-0x0007ffff pref]
[    0.744895] pnp 00:01: disabling [mem 0x00000400-0x000004ff disabled] because it overlaps 0000:04:02.1 BAR 6 [mem 0x00000000-0x0007ffff pref]
[    0.745894] pnp 00:01: disabling [mem 0x00000400-0x000004ff disabled] because it overlaps 0000:06:00.0 BAR 6 [mem 0x00000000-0x0000ffff pref]
[    0.746894] pnp 00:01: disabling [mem 0x00000400-0x000004ff disabled] because it overlaps 0000:06:00.1 BAR 6 [mem 0x00000000-0x0000ffff pref]
[    0.747894] pnp 00:01: disabling [mem 0x00000400-0x000004ff disabled] because it overlaps 0000:0b:01.0 BAR 6 [mem 0x00000000-0x0001ffff pref]
[    0.748922] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.749890] system 00:01: [io  0x0295-0x0296] has been reserved
[    0.750889] system 00:01: [io  0x0ca2-0x0ca3] has been reserved
[    0.751889] system 00:01: [io  0x0ca8-0x0caf] has been reserved
[    0.752890] system 00:01: [io  0x1000-0x107f] has been reserved
[    0.753889] system 00:01: [io  0x1180-0x11bf] has been reserved
[    0.754888] system 00:01: [io  0x0800-0x080f] has been reserved
[    0.755888] system 00:01: [io  0xfe00] has been reserved
[    0.756891] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.757888] system 00:01: [mem 0xfee00000-0xfee0ffff] could not be reserved
[    0.758887] system 00:01: [mem 0xfec80000-0xfec80fff] could not be reserved
[    0.759888] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.760890] system 00:01: [mem 0xfe000000-0xfe007fff] has been reserved
[    0.761887] system 00:01: [mem 0xfe600000-0xfe6fffff] has been reserved
[    0.762889] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.763900] pnp 00:02: [io  0x0000-0x001f]
[    0.764886] pnp 00:02: [io  0x0081-0x0091]
[    0.765885] pnp 00:02: [io  0x0093-0x009f]
[    0.766885] pnp 00:02: [io  0x00c0-0x00df]
[    0.767886] pnp 00:02: [dma 4]
[    0.768913] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.769903] pnp 00:03: [io  0x00f0-0x00fe]
[    0.770892] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:15)
[    0.771891] pnp 00:03: [irq 13]
[    0.772915] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.773970] pnp 00:04: [io  0x0070-0x0071]
[    0.774919] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.775898] pnp 00:05: [io  0x0061]
[    0.776913] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.778101] pnp 00:06: [mem 0xff000000-0xffffffff]
[    0.778917] pnp 00:06: Plug and Play ACPI device, IDs INT0800 (active)
[    0.780911] pnp 00:07: [io  0x03f8-0x03ff]
[    0.781887] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:15)
[    0.782886] pnp 00:07: [irq 4]
[    0.783969] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.785195] pnp 00:08: [io  0x02f8-0x02ff]
[    0.785885] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:15)
[    0.786885] pnp 00:08: [irq 3]
[    0.787964] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.789141] pnp: PnP ACPI: found 9 devices
[    0.789882] ACPI: ACPI bus type pnp unregistered
[    0.802148] Switching to clocksource acpi_pm
[    0.803056] pci 0000:04:02.0: BAR 6: assigned [mem 0xc0000000-0xc007ffff pref]
[    0.810752] pci 0000:04:02.1: BAR 6: assigned [mem 0xc0080000-0xc00fffff pref]
[    0.818434] pci 0000:03:00.0: PCI bridge to [bus 04]
[    0.823650] pci 0000:03:00.0:   bridge window [io  0x2000-0x2fff]
[    0.829995] pci 0000:03:00.0:   bridge window [mem 0xc8100000-0xc81fffff]
[    0.837042] pci 0000:03:00.0:   bridge window [mem 0xc0000000-0xc00fffff 64bit pref]
[    0.845241] pci 0000:03:00.2: PCI bridge to [bus 05]
[    0.850472] pci 0000:02:00.0: PCI bridge to [bus 03-05]
[    0.855950] pci 0000:02:00.0:   bridge window [io  0x2000-0x2fff]
[    0.862304] pci 0000:02:00.0:   bridge window [mem 0xc8100000-0xc81fffff]
[    0.869349] pci 0000:02:00.0:   bridge window [mem 0xc0000000-0xc00fffff 64bit pref]
[    0.877551] pci 0000:06:00.0: BAR 6: assigned [mem 0xc0100000-0xc010ffff pref]
[    0.885235] pci 0000:06:00.1: BAR 6: assigned [mem 0xc0110000-0xc011ffff pref]
[    0.899038] pci 0000:02:02.0: PCI bridge to [bus 06]
[    0.904256] pci 0000:02:02.0:   bridge window [io  0x3000-0x3fff]
[    0.910609] pci 0000:02:02.0:   bridge window [mem 0xc8200000-0xc82fffff]
[    0.917655] pci 0000:02:02.0:   bridge window [mem 0xc0100000-0xc01fffff 64bit pref]
[    0.925863] pci 0000:01:00.0: PCI bridge to [bus 02-06]
[    0.931347] pci 0000:01:00.0:   bridge window [io  0x2000-0x3fff]
[    0.937693] pci 0000:01:00.0:   bridge window [mem 0xc8100000-0xc82fffff]
[    0.944738] pci 0000:01:00.0:   bridge window [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.952938] pci 0000:01:00.3: PCI bridge to [bus 07]
[    0.958168] pci 0000:00:02.0: PCI bridge to [bus 01-07]
[    0.963648] pci 0000:00:02.0:   bridge window [io  0x2000-0x3fff]
[    0.970012] pci 0000:00:02.0:   bridge window [mem 0xc8100000-0xc82fffff]
[    0.977055] pci 0000:00:02.0:   bridge window [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.985255] pci 0000:00:04.0: PCI bridge to [bus 08]
[    0.990475] pci 0000:00:06.0: PCI bridge to [bus 09]
[    0.995703] pci 0000:00:1c.0: PCI bridge to [bus 0a]
[    1.000927] pci 0000:00:1c.0:   bridge window [io  0x5000-0x5fff]
[    1.007278] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff]
[    1.014323] pci 0000:00:1c.0:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
[    1.022524] pci 0000:0b:01.0: BAR 6: assigned [mem 0xc8320000-0xc833ffff pref]
[    1.030201] pci 0000:00:1e.0: PCI bridge to [bus 0b]
[    1.035417] pci 0000:00:1e.0:   bridge window [io  0x4000-0x4fff]
[    1.041762] pci 0000:00:1e.0:   bridge window [mem 0xc8300000-0xc83fffff]
[    1.048809] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
[    1.057035] IOAPIC[0]: Set routing entry (2-16 -> 0x41 -> IRQ 16 Mode:1 Active:1 Dest:15)
[    1.065684] IOAPIC[0]: Set routing entry (2-18 -> 0x51 -> IRQ 18 Mode:1 Active:1 Dest:15)
[    1.074342] IOAPIC[0]: Set routing entry (2-17 -> 0x61 -> IRQ 17 Mode:1 Active:1 Dest:15)
[    1.082980] pci 0000:00:1e.0: setting latency timer to 64
[    1.088642] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    1.094471] pci_bus 0000:00: resource 5 [mem 0x00000000-0xfffffffff]
[    1.101076] pci_bus 0000:01: resource 0 [io  0x2000-0x3fff]
[    1.106899] pci_bus 0000:01: resource 1 [mem 0xc8100000-0xc82fffff]
[    1.113425] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xc01fffff 64bit pref]
[    1.121104] pci_bus 0000:02: resource 0 [io  0x2000-0x3fff]
[    1.126928] pci_bus 0000:02: resource 1 [mem 0xc8100000-0xc82fffff]
[    1.133455] pci_bus 0000:02: resource 2 [mem 0xc0000000-0xc01fffff 64bit pref]
[    1.141132] pci_bus 0000:03: resource 0 [io  0x2000-0x2fff]
[    1.146957] pci_bus 0000:03: resource 1 [mem 0xc8100000-0xc81fffff]
[    1.153482] pci_bus 0000:03: resource 2 [mem 0xc0000000-0xc00fffff 64bit pref]
[    1.161161] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
[    1.166984] pci_bus 0000:04: resource 1 [mem 0xc8100000-0xc81fffff]
[    1.173510] pci_bus 0000:04: resource 2 [mem 0xc0000000-0xc00fffff 64bit pref]
[    1.181181] pci_bus 0000:06: resource 0 [io  0x3000-0x3fff]
[    1.187006] pci_bus 0000:06: resource 1 [mem 0xc8200000-0xc82fffff]
[    1.193531] pci_bus 0000:06: resource 2 [mem 0xc0100000-0xc01fffff 64bit pref]
[    1.201211] pci_bus 0000:0a: resource 0 [io  0x5000-0x5fff]
[    1.207034] pci_bus 0000:0a: resource 1 [mem 0xc0200000-0xc03fffff]
[    1.213553] pci_bus 0000:0a: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
[    1.221238] pci_bus 0000:0b: resource 0 [io  0x4000-0x4fff]
[    1.227063] pci_bus 0000:0b: resource 1 [mem 0xc8300000-0xc83fffff]
[    1.233588] pci_bus 0000:0b: resource 2 [mem 0xd0000000-0xd7ffffff 64bit pref]
[    1.241267] pci_bus 0000:0b: resource 4 [io  0x0000-0xffff]
[    1.247091] pci_bus 0000:0b: resource 5 [mem 0x00000000-0xfffffffff]
[    1.253742] NET: Registered protocol family 2
[    1.259259] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.271936] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    1.280175] TCP: Hash tables configured (established 524288 bind 65536)
[    1.287128] TCP: reno registered
[    1.290644] UDP hash table entries: 2048 (order: 5, 196608 bytes)
[    1.297139] UDP-Lite hash table entries: 2048 (order: 5, 196608 bytes)
[    1.304139] NET: Registered protocol family 1
[    1.308921] RPC: Registered named UNIX socket transport module.
[    1.315103] RPC: Registered udp transport module.
[    1.320067] RPC: Registered tcp transport module.
[    1.325023] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.331806] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    1.338343] pci 0000:00:1d.0: Performing full reset
[    1.343514] IOAPIC[0]: Set routing entry (2-19 -> 0x71 -> IRQ 19 Mode:1 Active:1 Dest:15)
[    1.352160] pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    1.358686] pci 0000:00:1d.1: Performing full reset
[    1.363837] pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    1.370360] pci 0000:00:1d.2: Performing full reset
[    1.375576] PCI: CLS mismatch (32 != 64), using 64 bytes
[    1.381160] pci 0000:0b:01.0: Boot video device
[    1.386020] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.392722] software IO TLB [mem 0xbbf5a000-0xbff59fff] (64MB) mapped at [ffff8800bbf5a000-ffff8800bff59fff]
[    1.404080] Simple Boot Flag at 0x38 set to 0x1
[    1.409037] Machine check injector initialized
[    1.414893] microcode: CPU0 sig=0x6f4, pf=0x4, revision=0x25
[    1.420822] microcode: CPU1 sig=0x6f4, pf=0x4, revision=0x25
[    1.426751] microcode: CPU2 sig=0x6f4, pf=0x4, revision=0x25
[    1.432680] microcode: CPU3 sig=0x6f4, pf=0x4, revision=0x25
[    1.438726] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.448474] audit: initializing netlink socket (disabled)
[    1.454158] type=2000 audit(1349778280.453:1): initialized
[    1.493617] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.509747] NFS: Registering the id_resolver key type
[    1.515073] Key type id_resolver registered
[    1.519512] Key type id_legacy registered
[    1.523777] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.530972] fuse init (API version 7.20)
[    1.535479] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    1.545920] NILFS version 2 loaded
[    1.550385] Btrfs loaded
[    1.553178] msgmni has been set to 7880
[    1.558471] async_tx: api initialized (async)
[    1.563272] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.571170] io scheduler noop registered
[    1.575352] io scheduler deadline registered
[    1.579880] io scheduler cfq registered (default)
[    1.585491] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.592109] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0A03:00/PNP0C0C:00/input/input0
[    1.601701] ACPI: Power Button [PWRB]
[    1.605735] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.613589] ACPI: Power Button [PWRF]
[    1.623157] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    1.784757] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.811872] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.838740] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.866268] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.892849] 00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.898995] Initializing Nozomi driver 2.1d
[    1.904029] Non-volatile memory driver v1.3
[    1.908591] Intel 82802 RNG detected
[    1.912601] Linux agpgart interface v0.103
[    1.917052] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    1.926463] Hangcheck: Using getrawmonotonic().
[    1.931337] [drm] Initialized drm 1.1.0 20060810
[    1.940192] brd: module loaded
[    1.945445] loop: module loaded
[    1.949790] Loading iSCSI transport class v2.0-870.
[    1.955941] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[    1.961777] Detecting Adaptec I2O RAID controllers...
[    2.410034] tsc: Refined TSC clocksource calibration: 2666.665 MHz
[    2.416483] Switching to clocksource tsc
[    4.952041] floppy0: no floppy controllers found
[    7.084013] scsi0 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
[    7.084013]         <Adaptec AIC7902 Ultra320 SCSI adapter>
[    7.084013]         aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI-X 67-100MHz, 512 SCBs
[    8.910806] scsi 0:0:8:0: Processor         SUPER    GEM359 REV001    1.09 PQ: 0 ANSI: 2
[    8.919377] scsi target0:0:8: asynchronous
[    8.923730] scsi target0:0:8: Beginning Domain Validation
[    8.941349] scsi target0:0:8: Ending Domain Validation
[   12.222012] scsi1 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
[   12.222012]         <Adaptec AIC7902 Ultra320 SCSI adapter>
[   12.222012]         aic7902: Ultra320 Wide Channel B, SCSI Id=7, PCI-X 67-100MHz, 512 SCBs
[   12.243111] Adaptec aacraid driver 1.2-0[29800]-ms
[   12.248341] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[   12.255460] isci: Intel(R) C600 SAS Controller Driver - version 1.1.0
[   12.262293] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.04.00.03-k.
[   12.271060] iscsi: registered transport (qla4xxx)
[   12.276076] QLogic iSCSI HBA Driver
[   12.279887] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[   12.287726] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[   12.294999] megasas: 00.00.06.15-rc1 Mon. Mar. 19 17:00:00 PDT 2012
[   12.301590] mpt2sas version 13.100.00.00 loaded
[   12.306504] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[   12.313189] ata_piix 0000:00:1f.2: version 2.13
[   12.317985] ata_piix 0000:00:1f.2: MAP [
[   12.328269]  P0 P2 IDE IDE ]
[   12.482015] ata_piix 0000:00:1f.2: setting latency timer to 64
[   12.488726] scsi2 : ata_piix
[   12.492023] scsi3 : ata_piix
[   12.495283] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x1870 irq 14
[   12.502496] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1878 irq 15
[   12.512535] tun: Universal TUN/TAP device driver, 1.6
[   12.517836] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   12.524604] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[   12.531860] Atheros(R) L2 Ethernet Driver - version 2.2.3
[   12.537510] Copyright (c) 2007 Atheros Corporation.
[   12.542901] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.12 (June 29, 2012)
[   12.550856] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[   12.557871] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
[   12.557871]   http://www.scyld.com/network/drivers.html
[   12.570783] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[   12.578048] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[   12.585349] e1000: Copyright (c) 1999-2006 Intel Corporation.
[   12.591413] e1000e: Intel(R) PRO/1000 Network Driver - 2.0.0-k
[   12.597498] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[   12.603773] e1000e 0000:06:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[   12.613543] e1000e 0000:06:00.0: (unregistered net_device): Failed to initialize MSI interrupts.  Falling back to legacy interrupts.
[   12.663270] ata1.00: ATA-6: ST3120026AS, 3.00, max UDMA/133
[   12.669097] ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   12.682244] ata1.00: configured for UDMA/133
[   12.701532] e1000e 0000:06:00.0: eth0: (PCI Express:2.5GT/s:Width x4) 00:30:48:30:70:e0
[   12.709987] e1000e 0000:06:00.0: eth0: Intel(R) PRO/1000 Network Connection
[   12.717282] e1000e 0000:06:00.0: eth0: MAC: 5, PHY: 5, PBA No: FFFFFF-0FF
[   12.724445] e1000e 0000:06:00.1: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[   12.734222] e1000e 0000:06:00.1: (unregistered net_device): Failed to initialize MSI interrupts.  Falling back to legacy interrupts.
[   12.805200] e1000e 0000:06:00.1: eth1: (PCI Express:2.5GT/s:Width x4) 00:30:48:30:70:e1
[   12.813661] e1000e 0000:06:00.1: eth1: Intel(R) PRO/1000 Network Connection
[   12.820994] e1000e 0000:06:00.1: eth1: MAC: 5, PHY: 5, PBA No: FFFFFF-0FF
[   12.828101] igb: Intel(R) Gigabit Ethernet Network Driver - version 4.0.1-k
[   12.832427] ata2.01: ATAPI: LITE-ON COMBO SOHC-5236V, R$0C, max UDMA/44
[   12.832431] ata2.01: limited to UDMA/33 due to 40-wire cable
[   12.848073] igb: Copyright (c) 2007-2012 Intel Corporation.
[   12.853976] igbvf: Intel(R) Gigabit Virtual Function Network Driver - version 2.0.1-k
[   12.854293] ata2.01: configured for UDMA/33
[   12.866782] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[   12.873019] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.9.15-k
[   12.881212] ixgbe: Copyright (c) 1999-2012 Intel Corporation.
[   12.887272] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[   12.894664] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[   12.900699] jme: JMicron JMC2XX ethernet driver version 1.0.8
[   12.906828] sky2: driver version 1.30
[   12.910868] pch_gbe: EG20T PCH Gigabit Ethernet Driver - version 1.01
[   12.918149] usbcore: registered new interface driver catc
[   12.923855] usbcore: registered new interface driver kaweth
[   12.929676] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[   12.937659] usbcore: registered new interface driver pegasus
[   12.943624] usbcore: registered new interface driver rtl8150
[   12.949594] usbcore: registered new interface driver asix
[   12.955296] usbcore: registered new interface driver cdc_ether
[   12.961432] usbcore: registered new interface driver cdc_eem
[   12.967396] usbcore: registered new interface driver dm9601
[   12.973275] usbcore: registered new interface driver smsc75xx
[   12.979337] usbcore: registered new interface driver smsc95xx
[   12.985390] usbcore: registered new interface driver gl620a
[   12.991271] usbcore: registered new interface driver net1080
[   12.997232] usbcore: registered new interface driver plusb
[   13.003028] usbcore: registered new interface driver rndis_host
[   13.009260] usbcore: registered new interface driver cdc_subset
[   13.015487] usbcore: registered new interface driver zaurus
[   13.021365] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[   13.029275] usbcore: registered new interface driver int51x1
[   13.035237] usbcore: registered new interface driver ipheth
[   13.041115] usbcore: registered new interface driver sierra_net
[   13.047342] usbcore: registered new interface driver cdc_ncm
[   13.053254] Fusion MPT base driver 3.04.20
[   13.057603] Copyright (c) 1999-2008 LSI Corporation
[   13.062746] Fusion MPT SPI Host driver 3.04.20
[   13.067506] Fusion MPT FC Host driver 3.04.20
[   13.072181] Fusion MPT SAS Host driver 3.04.20
[   13.076947] Fusion MPT misc device (ioctl) driver 3.04.20
[   13.082686] mptctl: Registered with Fusion MPT base driver
[   13.088425] mptctl: /dev/mptctl @ (major,minor=10,220)
[   13.093875] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   13.100653] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[   13.106946] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   13.113033] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   13.118513] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[   13.126364] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[   13.135780] ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
[   13.144521] ehci_hcd 0000:00:1d.7: reset command 0010002 (park)=0 ithresh=1 period=1024 Reset HALT
[   13.157812] ehci_hcd 0000:00:1d.7: debug port 1
[   13.162599] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[   13.169638] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[   13.175647] ehci_hcd 0000:00:1d.7: irq 17, io mem 0xc8000000
[   13.181561] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[   13.196010] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   13.202044] usb usb1: default language 0x0409
[   13.206662] usb usb1: udev 1, busnum 1, minor = 0
[   13.211621] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   13.218658] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.226328] usb usb1: Product: EHCI Host Controller
[   13.231458] usb usb1: Manufacturer: Linux 3.6.0 ehci_hcd
[   13.237023] usb usb1: SerialNumber: 0000:00:1d.7
[   13.242025] usb usb1: usb_probe_device
[   13.246030] usb usb1: configuration #1 chosen from 1 choice
[   13.251859] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[   13.257925] hub 1-0:1.0: usb_probe_interface
[   13.262452] hub 1-0:1.0: usb_probe_interface - got id
[   13.267756] hub 1-0:1.0: USB hub found
[   13.272632] hub 1-0:1.0: 6 ports detected
[   13.276891] hub 1-0:1.0: standalone hub
[   13.280980] hub 1-0:1.0: no power switching (usb 1.0)
[   13.286282] hub 1-0:1.0: individual port over-current protection
[   13.292541] hub 1-0:1.0: power on to power good time: 20ms
[   13.298283] hub 1-0:1.0: local power source is good
[   13.303411] hub 1-0:1.0: trying to enable port power on non-switchable hub
[   13.310669] uhci_hcd: USB Universal Host Controller Interface driver
[   13.317315] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   13.323404] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   13.328887] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[   13.336741] uhci_hcd 0000:00:1d.0: detected 2 ports
[   13.341876] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[   13.348832] uhci_hcd 0000:00:1d.0: Performing full reset
[   13.354405] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[   13.360406] uhci_hcd 0000:00:1d.0: irq 17, io base 0x00001800
[   13.366430] usb usb2: default language 0x0409
[   13.371041] usb usb2: udev 1, busnum 2, minor = 128
[   13.376176] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[   13.383213] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.390883] usb usb2: Product: UHCI Host Controller
[   13.396012] usb usb2: Manufacturer: Linux 3.6.0 uhci_hcd
[   13.401577] usb usb2: SerialNumber: 0000:00:1d.0
[   13.406571] usb usb2: usb_probe_device
[   13.410575] usb usb2: configuration #1 chosen from 1 choice
[   13.416410] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 001403 0  ACK POWER sig=k CSC CONNECT
[   13.417015] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[   13.417080] hub 2-0:1.0: usb_probe_interface
[   13.417081] hub 2-0:1.0: usb_probe_interface - got id
[   13.417083] hub 2-0:1.0: USB hub found
[   13.417087] hub 2-0:1.0: 2 ports detected
[   13.417089] hub 2-0:1.0: standalone hub
[   13.417090] hub 2-0:1.0: no power switching (usb 1.0)
[   13.417091] hub 2-0:1.0: individual port over-current protection
[   13.417092] hub 2-0:1.0: power on to power good time: 2ms
[   13.417096] hub 2-0:1.0: local power source is good
[   13.417097] hub 2-0:1.0: trying to enable port power on non-switchable hub
[   13.417150] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[   13.417173] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   13.417177] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   13.417184] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[   13.417190] uhci_hcd 0000:00:1d.1: detected 2 ports
[   13.417194] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[   13.417195] uhci_hcd 0000:00:1d.1: Performing full reset
[   13.417211] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[   13.417229] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001820
[   13.417276] usb usb3: default language 0x0409
[   13.417281] usb usb3: udev 1, busnum 3, minor = 256
[   13.417283] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   13.417285] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.417287] usb usb3: Product: UHCI Host Controller
[   13.417288] usb usb3: Manufacturer: Linux 3.6.0 uhci_hcd
[   13.417289] usb usb3: SerialNumber: 0000:00:1d.1
[   13.417394] usb usb3: usb_probe_device
[   13.417396] usb usb3: configuration #1 chosen from 1 choice
[   13.417401] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[   13.417464] hub 3-0:1.0: usb_probe_interface
[   13.417466] hub 3-0:1.0: usb_probe_interface - got id
[   13.417467] hub 3-0:1.0: USB hub found
[   13.417471] hub 3-0:1.0: 2 ports detected
[   13.417472] hub 3-0:1.0: standalone hub
[   13.417473] hub 3-0:1.0: no power switching (usb 1.0)
[   13.417475] hub 3-0:1.0: individual port over-current protection
[   13.417476] hub 3-0:1.0: power on to power good time: 2ms
[   13.417479] hub 3-0:1.0: local power source is good
[   13.417481] hub 3-0:1.0: trying to enable port power on non-switchable hub
[   13.417525] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[   13.417547] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   13.417550] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   13.417560] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[   13.417566] uhci_hcd 0000:00:1d.2: detected 2 ports
[   13.417570] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[   13.417572] uhci_hcd 0000:00:1d.2: Performing full reset
[   13.417588] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[   13.417601] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001840
[   13.417632] usb usb4: default language 0x0409
[   13.417637] usb usb4: udev 1, busnum 4, minor = 384
[   13.417639] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   13.417641] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.417642] usb usb4: Product: UHCI Host Controller
[   13.417644] usb usb4: Manufacturer: Linux 3.6.0 uhci_hcd
[   13.417645] usb usb4: SerialNumber: 0000:00:1d.2
[   13.417748] usb usb4: usb_probe_device
[   13.417750] usb usb4: configuration #1 chosen from 1 choice
[   13.417756] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[   13.417816] hub 4-0:1.0: usb_probe_interface
[   13.417817] hub 4-0:1.0: usb_probe_interface - got id
[   13.417819] hub 4-0:1.0: USB hub found
[   13.417822] hub 4-0:1.0: 2 ports detected
[   13.417824] hub 4-0:1.0: standalone hub
[   13.417825] hub 4-0:1.0: no power switching (usb 1.0)
[   13.417826] hub 4-0:1.0: individual port over-current protection
[   13.417827] hub 4-0:1.0: power on to power good time: 2ms
[   13.417831] hub 4-0:1.0: local power source is good
[   13.417832] hub 4-0:1.0: trying to enable port power on non-switchable hub
[   13.417882] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[   13.417946] Initializing USB Mass Storage driver...
[   13.418018] usbcore: registered new interface driver usb-storage
[   13.418018] USB Mass Storage support registered.
[   13.418091] usbcore: registered new interface driver libusual
[   13.418139] usbcore: registered new interface driver ums-alauda
[   13.418188] usbcore: registered new interface driver ums-cypress
[   13.418236] usbcore: registered new interface driver ums-datafab
[   13.418283] usbcore: registered new interface driver ums-freecom
[   13.418330] usbcore: registered new interface driver ums-isd200
[   13.418378] usbcore: registered new interface driver ums-jumpshot
[   13.418435] usbcore: registered new interface driver ums-karma
[   13.418484] usbcore: registered new interface driver ums-onetouch
[   13.418533] usbcore: registered new interface driver ums-sddr09
[   13.418582] usbcore: registered new interface driver ums-sddr55
[   13.418630] usbcore: registered new interface driver ums-usbat
[   13.418736] usbcore: registered new interface driver usbserial
[   13.418788] usbcore: registered new interface driver usbserial_generic
[   13.418841] USB Serial support registered for generic
[   13.418843] usbserial: USB Serial Driver core
[   13.418894] usbcore: registered new interface driver belkin_sa
[   13.418941] USB Serial support registered for Belkin / Peracom / GoHubs USB Serial Adapter
[   13.418992] usbcore: registered new interface driver mct_u232
[   13.419048] USB Serial support registered for MCT U232
[   13.419250] i8042: PNP: No PS/2 controller found. Probing ports directly.
[   13.421661] serio: i8042 KBD port at 0x60,0x64 irq 1
[   13.421666] serio: i8042 AUX port at 0x60,0x64 irq 12
[   13.421987] mousedev: PS/2 mouse device common for all mice
[   13.422561] rtc_cmos 00:04: RTC can wake from S4
[   13.422766] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[   13.422793] rtc0: alarms up to one month, y3k, 114 bytes nvram
[   13.422923] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[   13.422952] iTCO_wdt: Found a 631xESB/632xESB TCO device (Version=2, TCOBASE=0x1060)
[   13.423148] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   13.423207] iTCO_vendor_support: vendor-support=0
[   13.423288] softdog: Software Watchdog Timer: 0.08 initialized. soft_noboot=0 soft_margin=60 sec soft_panic=0 (nowayout=0)
[   13.423289] md: linear personality registered for level -1
[   13.423290] md: raid0 personality registered for level 0
[   13.423291] md: raid1 personality registered for level 1
[   13.423292] md: raid10 personality registered for level 10
[   13.423293] md: raid6 personality registered for level 6
[   13.423294] md: raid5 personality registered for level 5
[   13.423295] md: raid4 personality registered for level 4
[   13.423296] md: multipath personality registered for level -4
[   13.423297] md: faulty personality registered for level -5
[   13.423489] device-mapper: uevent: version 1.0.3
[   13.423660] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
[   13.423759] device-mapper: multipath: version 1.5.0 loaded
[   13.423761] device-mapper: multipath round-robin: version 1.0.0 loaded
[   13.423762] device-mapper: multipath queue-length: version 0.1.0 loaded
[   13.423763] device-mapper: multipath service-time: version 0.2.0 loaded
[   13.423946] device-mapper: dm-log-userspace: version 1.1.0 loaded
[   13.423955] cpuidle: using governor ladder
[   13.423956] cpuidle: using governor menu
[   13.424155] usbcore: registered new interface driver usbhid
[   13.424156] usbhid: USB HID core driver
[   13.424468] dell_wmi: No known WMI GUID found
[   13.424468] acer_wmi: Acer Laptop ACPI-WMI Extras
[   13.424476] acer_wmi: No or unsupported WMI interface, unable to load
[   13.424770] oprofile: using NMI interrupt.
[   13.424884] TCP: bic registered
[   13.424884] TCP: cubic registered
[   13.424885] TCP: westwood registered
[   13.424886] TCP: highspeed registered
[   13.424886] TCP: hybla registered
[   13.424887] TCP: htcp registered
[   13.424888] TCP: vegas registered
[   13.424889] TCP: veno registered
[   13.424889] TCP: scalable registered
[   13.424890] TCP: lp registered
[   13.424891] TCP: yeah registered
[   13.424891] TCP: illinois registered
[   13.424892] Initializing XFRM netlink socket
[   13.424898] NET: Registered protocol family 17
[   13.424909] NET: Registered protocol family 15
[   13.424947] Key type dns_resolver registered
[   13.426085] 
[   13.426085] printing PIC contents
[   13.426088] ... PIC  IMR: ffff
[   13.426091] ... PIC  IRR: 0c21
[   13.426099] ... PIC  ISR: 0000
[   13.426102] ... PIC ELCR: 0e20
[   13.426104] printing local APIC contents on CPU#0/0:
[   13.426104] ... APIC ID:      00000000 (0)
[   13.426105] ... APIC VERSION: 00050014
[   13.426106] ... APIC TASKPRI: 00000000 (00)
[   13.426106] ... APIC PROCPRI: 00000000
[   13.426107] ... APIC LDR: 01000000
[   13.426108] ... APIC DFR: ffffffff
[   13.426108] ... APIC SPIV: 000001ff
[   13.426109] ... APIC ISR field:
[   13.426113] 0000000000000000000000000000000000000000000000000000000000000000
[   13.426113] ... APIC TMR field:
[   13.426116] 0000000000000000000000020000000200000000000000000000000000000000
[   13.426117] ... APIC IRR field:
[   13.426120] 0000000000000000000000000000000000000000000000000000000000000000
[   13.426120] ... APIC ESR: 00000000
[   13.426121] ... APIC ICR: 000008fd
[   13.426122] ... APIC ICR2: 08000000
[   13.426122] ... APIC LVTT: 000000ef
[   13.426123] ... APIC LVTPC: 00000400
[   13.426123] ... APIC LVT0: 00010700
[   13.426124] ... APIC LVT1: 00000400
[   13.426124] ... APIC LVTERR: 000000fe
[   13.426125] ... APIC TMICT: 0000511b
[   13.426126] ... APIC TMCCT: 00004726
[   13.426126] ... APIC TDCR: 00000003
[   13.426127] 
[   13.426127] number of MP IRQ sources: 15.
[   13.426128] number of IO-APIC #2 registers: 24.
[   13.426129] number of IO-APIC #3 registers: 24.
[   13.426129] testing the IO APIC.......................
[   13.426136] IO APIC #2......
[   13.426137] .... register #00: 02000000
[   13.426137] .......    : physical APIC id: 02
[   13.426138] .......    : Delivery Type: 0
[   13.426139] .......    : LTS          : 0
[   13.426139] .... register #01: 00170020
[   13.426140] .......     : max redirection entries: 17
[   13.426140] .......     : PRQ implemented: 0
[   13.426141] .......     : IO APIC version: 20
[   13.426142] .... IRQ redirection table:
[   13.426142]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[   13.426147]  00 00  1    0    0   0   0    0    0    00
[   13.426152]  01 0F  0    0    0   0   0    1    1    31
[   13.426157]  02 0F  0    0    0   0   0    1    1    30
[   13.426162]  03 0F  0    0    0   0   0    1    1    33
[   13.426166]  04 0F  0    0    0   0   0    1    1    34
[   13.426171]  05 0F  0    0    0   0   0    1    1    35
[   13.426175]  06 0F  1    0    0   0   0    1    1    36
[   13.426180]  07 0F  0    0    0   0   0    1    1    37
[   13.426185]  08 0F  0    0    0   0   0    1    1    38
[   13.426190]  09 0F  0    1    0   0   0    1    1    39
[   13.426195]  0a 0F  0    0    0   0   0    1    1    3A
[   13.426199]  0b 0F  0    0    0   0   0    1    1    3B
[   13.426204]  0c 0F  0    0    0   0   0    1    1    3C
[   13.426209]  0d 0F  0    0    0   0   0    1    1    3D
[   13.426214]  0e 0F  0    0    0   0   0    1    1    3E
[   13.426218]  0f 0F  0    0    0   0   0    1    1    3F
[   13.426223]  10 0F  0    1    0   1   0    1    1    41
[   13.426228]  11 0F  0    1    0   1   0    1    1    61
[   13.426233]  12 0F  0    1    0   1   0    1    1    51
[   13.426238]  13 0F  0    1    0   1   0    1    1    71
[   13.426242]  14 00  1    0    0   0   0    0    0    00
[   13.426247]  15 00  1    0    0   0   0    0    0    00
[   13.426252]  16 00  1    0    0   0   0    0    0    00
[   13.426257]  17 00  1    0    0   0   0    0    0    00
[   13.426259] IO APIC #3......
[   13.426260] .... register #00: 03000000
[   13.426260] .......    : physical APIC id: 03
[   13.426261] .......    : Delivery Type: 0
[   13.426261] .......    : LTS          : 0
[   13.426262] .... register #01: 00178020
[   13.426263] .......     : max redirection entries: 17
[   13.426263] .......     : PRQ implemented: 1
[   13.426264] .......     : IO APIC version: 20
[   13.426264] .... register #02: 03000000
[   13.426265] .......     : arbitration: 03
[   13.426265] .... register #03: 00000001
[   13.426266] .......     : Boot DT    : 1
[   13.426266] .... IRQ redirection table:
[   13.426267]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[   13.426270]  00 00  1    0    0   0   0    0    0    00
[   13.426272]  01 00  1    0    0   0   0    0    0    00
[   13.426275]  02 00  1    0    0   0   0    0    0    00
[   13.426278]  03 00  1    0    0   0   0    0    0    00
[   13.426281]  04 00  1    0    0   0   0    0    0    00
[   13.426283]  05 00  1    0    0   0   0    0    0    00
[   13.426286]  06 00  1    0    0   0   0    0    0    00
[   13.426289]  07 00  1    0    0   0   0    0    0    00
[   13.426291]  08 00  1    0    0   0   0    0    0    00
[   13.426294]  09 00  1    0    0   0   0    0    0    00
[   13.426297]  0a 00  1    0    0   0   0    0    0    00
[   13.426299]  0b 00  1    0    0   0   0    0    0    00
[   13.426302]  0c 00  1    0    0   0   0    0    0    00
[   13.426305]  0d 00  1    0    0   0   0    0    0    00
[   13.426308]  0e 00  1    0    0   0   0    0    0    00
[   13.426310]  0f 00  1    0    0   0   0    0    0    00
[   13.426313]  10 00  1    0    0   0   0    0    0    00
[   13.426316]  11 00  1    0    0   0   0    0    0    00
[   13.426318]  12 00  1    0    0   0   0    0    0    00
[   13.426321]  13 00  1    0    0   0   0    0    0    00
[   13.426324]  14 00  1    0    0   0   0    0    0    00
[   13.426326]  15 00  1    0    0   0   0    0    0    00
[   13.426329]  16 00  1    0    0   0   0    0    0    00
[   13.426332]  17 00  1    0    0   0   0    0    0    00
[   13.426332] IRQ to pin mappings:
[   13.426335] IRQ0 -> 0:2
[   13.426336] IRQ1 -> 0:1
[   13.426337] IRQ3 -> 0:3
[   13.426339] IRQ4 -> 0:4
[   13.426340] IRQ5 -> 0:5
[   13.426342] IRQ6 -> 0:6
[   13.426343] IRQ7 -> 0:7
[   13.426344] IRQ8 -> 0:8
[   13.426345] IRQ9 -> 0:9
[   13.426347] IRQ10 -> 0:10
[   13.426348] IRQ11 -> 0:11
[   13.426349] IRQ12 -> 0:12
[   13.426351] IRQ13 -> 0:13
[   13.426352] IRQ14 -> 0:14
[   13.426353] IRQ15 -> 0:15
[   13.426354] IRQ16 -> 0:16
[   13.426356] IRQ17 -> 0:17
[   13.426357] IRQ18 -> 0:18
[   13.426358] IRQ19 -> 0:19
[   13.426359] .................................... done.
[   13.426617] PM: Hibernation image not present or could not be loaded.
[   13.426633] registered taskstats version 1
[   13.427103]   Magic number: 0:135:426
[   13.427300] netpoll: netconsole: local port 6667
[   13.427301] netpoll: netconsole: local IP 192.168.5.70
[   13.427302] netpoll: netconsole: interface 'eth0'
[   13.427302] netpoll: netconsole: remote port 6666
[   13.427303] netpoll: netconsole: remote IP 192.168.1.1
[   13.427304] netpoll: netconsole: remote ethernet address 00:1b:21:11:78:3e
[   13.427306] netpoll: netconsole: device eth0 not up yet, forcing it
[   13.517024] uhci_hcd 0000:00:1d.0: port 2 portsc 008a,00
[   13.517058] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   13.517061] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   13.617009] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   14.454013] usb usb3: suspend_rh (auto-stop)
[   14.454036] usb usb4: suspend_rh (auto-stop)
[   14.704024] usb usb2: suspend_rh (auto-stop)
[   14.915696] hub 1-0:1.0: port 2: status 0501 change 0001
[   15.021018] hub 1-0:1.0: state 7 ports 6 chg 0004 evt 0000
[   15.026761] hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[   15.033286] ehci_hcd 0000:00:1d.7: port 2 low speed --> companion
[   15.090014] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 003002 0  ACK POWER OWNER sig=se0 CSC
[   15.099264] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0004
[   15.105010] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 003002 0  ACK POWER OWNER sig=se0 CSC
[   15.114247] hub 1-0:1.0: port 2, status 0100, change 0001, 12 Mb/s
[   15.204017] usb usb2: wakeup_rh (auto-start)
[   15.224012] hub 1-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
[   15.231860] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0004
[   15.237598] uhci_hcd 0000:00:1d.0: port 2 portsc 01a3,00
[   15.243162] hub 2-0:1.0: port 2, status 0301, change 0001, 1.5 Mb/s
[   15.353012] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x301
[   15.462011] usb 2-2: new low-speed USB device number 2 using uhci_hcd
[   15.662560] usb 2-2: skipped 1 descriptor after interface
[   15.668221] usb 2-2: skipped 1 descriptor after interface
[   15.681548] usb 2-2: default language 0x0409
[   15.720554] usb 2-2: udev 2, busnum 2, minor = 129
[   15.725602] usb 2-2: New USB device found, idVendor=0557, idProduct=2220
[   15.732560] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   15.739942] usb 2-2: Product: ATEN  CS-1758/54
[   15.744641] usb 2-2: Manufacturer: ATEN
[   15.748858] usb 2-2: usb_probe_device
[   15.752771] usb 2-2: configuration #1 chosen from 1 choice
[   15.760565] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
[   15.807637] usbhid 2-2:1.0: usb_probe_interface
[   15.812424] usbhid 2-2:1.0: usb_probe_interface - got id
[   15.851939] input: ATEN ATEN  CS-1758/54 as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input2
[   15.862069] uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[   15.870362] hid-generic 0003:0557:2220.0001: input: USB HID v1.10 Keyboard [ATEN ATEN  CS-1758/54] on usb-0000:00:1d.0-2/input0
[   15.882327] usb 2-2: adding 2-2:1.1 (config #1, interface 1)
[   15.894633] usbhid 2-2:1.1: usb_probe_interface
[   15.899423] usbhid 2-2:1.1: usb_probe_interface - got id
[   15.912375] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   15.924897] console [netcon0] enabled
[   15.928817] netconsole: network logging started
[   15.933642] rtc_cmos 00:04: setting system clock to 2012-10-09 10:24:59 UTC (1349778299)
[   15.942435] input: ATEN ATEN  CS-1758/54 as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.1/input/input3
[   15.952880] hid-generic 0003:0557:2220.0002: input: USB HID v1.10 Mouse [ATEN ATEN  CS-1758/54] on usb-0000:00:1d.0-2/input1
[   15.964594] IP-Config: Complete:
[   15.968077]      device=eth0, addr=192.168.1.134, mask=255.255.255.0, gw=192.168.1.1
[   15.976274]      host=bens, domain=, nis-domain=(none)
[   15.981663]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
[   15.988853] ALSA device list:
[   15.992072]   No soundcards found.
[   17.487233] scsi 2:0:0:0: Direct-Access     ATA      ST3120026AS      3.00 PQ: 0 ANSI: 5
[   17.496047] sd 2:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)
[   17.504123] sd 2:0:0:0: [sda] Write Protect is off
[   17.504641] scsi 3:0:1:0: CD-ROM            LITE-ON  COMBO SOHC-5236V R$0C PQ: 0 ANSI: 5
[   17.517707] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   17.523035] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   17.574616]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
[   17.581117] sd 2:0:0:0: [sda] Attached SCSI disk
[   17.586011] md: Waiting for all devices to be available before autodetect
[   17.593059] md: If you don't use raid, use raid=noautodetect
[   17.599266] md: Autodetecting RAID arrays.
[   17.603618] md: Scanned 0 and added 0 devices.
[   17.608312] md: autorun ...
[   17.611352] md: ... autorun DONE.
[   17.709359] VFS: Mounted root (nfs filesystem) on device 0:14.
[   17.715665] devtmpfs: mounted
[   17.719480] Freeing unused kernel memory: 972k freed
[   17.980648] udevd[1924]: starting version 175
[   21.005391] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   21.014089] NFSD: starting 90-second grace period
[ 5164.651634] XFS (sda7): Mounting Filesystem
[ 5164.890721] XFS (sda7): Starting recovery (logdev: internal)
[ 5172.207615] XFS (sda7): Ending recovery (logdev: internal)
[ 5174.699117] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5174.701692] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5174.701696] Pid: 3948, comm: kvm Not tainted 3.6.0 #23
[ 5174.701696] Call Trace:
[ 5174.701708]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5174.701713]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5174.701716]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5174.701719]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5174.701723]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5174.701725]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5174.701727]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5174.701730]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5174.701732]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5174.701736]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5174.701740]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5174.701742]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5174.701746]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5174.702587] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5174.702589] Pid: 3947, comm: kvm Not tainted 3.6.0 #23
[ 5174.702589] Call Trace:
[ 5174.702594]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5174.702597]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5174.702599]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5174.702601]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5174.702603]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5174.702606]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5174.702608]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5174.702609]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5174.702611]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5174.702614]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5174.702616]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5174.702617]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5174.702620]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5174.702848] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5174.702849] Pid: 3950, comm: kvm Not tainted 3.6.0 #23
[ 5174.702850] Call Trace:
[ 5174.702853]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5174.702854]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5174.702856]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5174.702858]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5174.702861]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5174.702863]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5174.702865]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5174.702866]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5174.702868]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5174.702870]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5174.702872]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5174.702874]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5174.702876]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5174.979504] Pid: 3942, comm: kvm Not tainted 3.6.0 #23
[ 5174.984900] Call Trace:
[ 5174.987599]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5174.993249]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5174.998724]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5175.004636]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5175.011326]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5175.017677]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5175.023590]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5175.029933]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5175.035843]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5175.048400]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5175.054139]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5175.059962]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5175.065268]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5175.076251] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5175.078227] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5175.078229] Pid: 3953, comm: kvm Not tainted 3.6.0 #23
[ 5175.078230] Call Trace:
[ 5175.078233]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5175.078236]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5175.078238]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5175.078240]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5175.078242]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5175.078244]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5175.078246]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5175.078248]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5175.078250]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5175.078252]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5175.078254]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5175.078255]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5175.078258]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5175.173724] Pid: 3957, comm: kvm Not tainted 3.6.0 #23
[ 5175.173916] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5175.173918] Pid: 3959, comm: kvm Not tainted 3.6.0 #23
[ 5175.173919] Call Trace:
[ 5175.173929]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5175.173934]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5175.173936]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5175.173939]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5175.173943]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5175.173945]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5175.173947]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5175.173950]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5175.173952]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5175.173957]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5175.173960]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5175.173962]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5175.173966]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5175.174223] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5175.174225] Pid: 3963, comm: kvm Not tainted 3.6.0 #23
[ 5175.174226] Call Trace:
[ 5175.174230]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5175.174232]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5175.174234]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5175.174236]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5175.174238]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5175.174240]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5175.174242]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5175.174244]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5175.174246]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5175.174248]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5175.174250]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5175.174252]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5175.174254]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5175.174533] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5175.174535] Pid: 3962, comm: kvm Not tainted 3.6.0 #23
[ 5175.174536] Call Trace:
[ 5175.174539]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5175.174541]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5175.174543]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5175.174545]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5175.174547]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5175.174549]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5175.174551]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5175.174553]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5175.174555]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5175.174557]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5175.174559]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5175.174561]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5175.174563]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5175.174913] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5175.174916] Pid: 3960, comm: kvm Not tainted 3.6.0 #23
[ 5175.174917] Call Trace:
[ 5175.174924]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5175.174927]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5175.174929]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5175.174931]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5175.174934]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5175.174936]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5175.174938]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5175.174940]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5175.174942]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5175.174945]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5175.174949]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5175.174950]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5175.174954]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5175.175233] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5175.175234] Pid: 3958, comm: kvm Not tainted 3.6.0 #23
[ 5175.175235] Call Trace:
[ 5175.175238]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5175.175240]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5175.175242]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5175.175244]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5175.175246]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5175.175248]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5175.175250]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5175.175251]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5175.175253]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5175.175256]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5175.175258]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5175.175259]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5175.175262]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5175.175766] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5175.175769] Pid: 3961, comm: kvm Not tainted 3.6.0 #23
[ 5175.175770] Call Trace:
[ 5175.175780]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5175.175785]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5175.175788]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5175.175791]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5175.175795]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5175.175797]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5175.175799]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5175.175802]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5175.175804]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5175.175809]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5175.175814]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5175.175815]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5175.175820]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5175.728980] Call Trace:
[ 5175.731738]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5175.737449]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5175.742972]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5175.748932]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5175.755683]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5175.762064]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5175.767983]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5175.774363]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5175.780301]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5175.786759]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5175.792501]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5175.798331]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5175.803638]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5175.814497] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5175.820648] Pid: 3964, comm: kvm Not tainted 3.6.0 #23
[ 5175.821351] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5175.821355] Pid: 3976, comm: kvm Not tainted 3.6.0 #23
[ 5175.821357] Call Trace:
[ 5175.821368]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5175.821373]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5175.821376]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5175.821379]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5175.821383]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5175.821386]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5175.821388]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5175.821391]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5175.821393]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5175.821398]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5175.821403]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5175.821404]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5175.821409]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5175.824283] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5175.824287] Pid: 3966, comm: kvm Not tainted 3.6.0 #23
[ 5175.824288] Call Trace:
[ 5175.824297]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5175.824302]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5175.824305]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5175.824308]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5175.824311]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5175.824314]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5175.824316]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5175.824319]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5175.824321]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5175.824325]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5175.824329]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5175.824331]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5175.824335]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5176.009615] Call Trace:
[ 5176.009674] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5176.009678] Pid: 3965, comm: kvm Not tainted 3.6.0 #23
[ 5176.009679] Call Trace:
[ 5176.009690]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5176.009695]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5176.009697]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5176.009700]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5176.009704]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5176.009707]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5176.009708]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5176.009711]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5176.009713]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5176.009718]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5176.009721]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5176.009723]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5176.009727]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5176.110187]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5176.115931]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5176.121510]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5176.127503]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5176.134290]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5176.140763]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5176.146786]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5176.153261]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5176.159281]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5176.165844]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5176.171723]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5176.177679]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5176.183118]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5218.565274] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5218.571140] Pid: 4428, comm: kvm Not tainted 3.6.0 #23
[ 5218.576533] Call Trace:
[ 5218.579237]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5218.584924]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5218.590407]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5218.596321]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5218.603013]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5218.609364]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5218.615274]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5218.621619]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5218.627552]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5218.633988]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5218.639725]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5218.645555]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5218.650861]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5218.718285] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5218.724151] Pid: 4454, comm: kvm Not tainted 3.6.0 #23
[ 5218.729546] Call Trace:
[ 5218.732255]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5218.737911]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5218.743391]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5218.749306]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5218.756009]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5218.762357]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5218.768299]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5218.774648]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5218.780556]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5218.786991]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5218.792734]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5218.798558]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5218.803874]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5272.264289] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5272.270153] Pid: 5060, comm: kvm Not tainted 3.6.0 #23
[ 5272.275551] Call Trace:
[ 5272.278260]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5272.283916]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5272.289402]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5272.295323]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5272.302022]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5272.308372]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5272.314305]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5272.320652]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5272.326563]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5272.333006]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5272.338750]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5272.344582]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5272.349897]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5272.364243] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5272.370100] Pid: 5061, comm: kvm Not tainted 3.6.0 #23
[ 5272.375493] Call Trace:
[ 5272.378207]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5272.383859]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5272.389335]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5272.395256]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5272.401961]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5272.408306]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5272.414227]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5272.420584]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5272.426497]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5272.432931]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5272.438675]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5272.444508]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5272.449824]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5287.552332] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5287.558179] Pid: 5254, comm: kvm Not tainted 3.6.0 #23
[ 5287.563635] Call Trace:
[ 5287.566377]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5287.572038]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5287.577518]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5287.583430]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5287.590143]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5287.596492]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5287.602400]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5287.608786]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5287.614701]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5287.621142]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5287.626897]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5287.632730]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5287.638042]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5287.676287] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5287.682147] Pid: 5283, comm: kvm Not tainted 3.6.0 #23
[ 5287.687544] Call Trace:
[ 5287.690253]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5287.695908]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5287.701393]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5287.707319]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5287.714034]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5287.720392]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5287.726309]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5287.732657]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5287.738574]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5287.745016]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5287.750765]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5287.756598]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5287.761916]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5358.532292] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5358.538141] Pid: 5980, comm: kvm Not tainted 3.6.0 #23
[ 5358.543538] Call Trace:
[ 5358.546246]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5358.551946]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5358.557454]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5358.563375]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5358.570097]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5358.576450]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5358.582360]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5358.588713]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5358.594624]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5358.601059]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5358.606802]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5358.612632]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5358.617940]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5358.643276] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5358.649203] Pid: 5981, comm: kvm Not tainted 3.6.0 #23
[ 5358.654629] Call Trace:
[ 5358.657370]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5358.663052]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5358.668533]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5358.674474]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5358.681219]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5358.687591]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5358.693537]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5358.699896]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5358.705812]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5358.712286]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5358.718059]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5358.723887]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5358.729216]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5373.817266] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5373.823114] Pid: 6175, comm: kvm Not tainted 3.6.0 #23
[ 5373.828520] Call Trace:
[ 5373.831237]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5373.836900]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5373.842401]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5373.848416]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5373.855218]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5373.861588]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5373.867586]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5373.873954]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5373.879879]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5373.886316]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5373.892053]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5373.897928]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5373.903246]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5374.010308] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5374.016164] Pid: 6179, comm: kvm Not tainted 3.6.0 #23
[ 5374.021558] Call Trace:
[ 5374.024269]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5374.029924]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5374.035467]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5374.041420]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5374.048129]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5374.054489]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5374.060406]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5374.066761]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5374.072685]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5374.079141]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5374.084934]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5374.090771]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5374.096076]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5380.296298] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5380.302186] Pid: 6296, comm: kvm Not tainted 3.6.0 #23
[ 5380.307600] Call Trace:
[ 5380.310353]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5380.322187]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5380.327741]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5380.333719]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5380.340493]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5380.346881]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5380.352796]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5380.359153]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5380.365164]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5380.371678]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5380.377491]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5380.383400]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5380.388786]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5380.404252] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5380.410159] Pid: 6297, comm: kvm Not tainted 3.6.0 #23
[ 5380.415632] Call Trace:
[ 5380.418395]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5380.424106]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5380.429657]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5380.435656]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5380.442464]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5380.448861]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5380.454832]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5380.461207]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5380.467145]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5380.473604]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5380.479368]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5380.485197]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5380.490516]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5422.823280] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5422.829146] Pid: 6714, comm: kvm Not tainted 3.6.0 #23
[ 5422.834566] Call Trace:
[ 5422.837285]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5422.842944]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5422.848432]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5422.854406]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5422.861115]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5422.867472]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5422.873391]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5422.879751]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5422.885670]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5422.892128]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5422.897897]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5422.903732]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5422.909049]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5422.920282] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5422.926146] Pid: 6743, comm: kvm Not tainted 3.6.0 #23
[ 5422.931553] Call Trace:
[ 5422.934269]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5422.939940]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5422.945428]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5422.951354]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5422.958102]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5422.964483]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5422.970416]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5422.976773]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5422.982731]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5422.989183]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5422.994934]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5423.000761]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5423.006074]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5427.807302] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5427.813187] Pid: 6891, comm: kvm Not tainted 3.6.0 #23
[ 5427.818589] Call Trace:
[ 5427.821305]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5427.826963]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5427.832445]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5427.838367]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5427.845079]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5427.851442]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5427.857374]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5427.863724]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5427.869641]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5427.876084]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5427.881836]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5427.887670]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5427.892998]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5427.917296] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5427.923145] Pid: 6923, comm: kvm Not tainted 3.6.0 #23
[ 5427.924255] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5427.924258] Pid: 6924, comm: kvm Not tainted 3.6.0 #23
[ 5427.924259] Call Trace:
[ 5427.924269]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5427.924274]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5427.924277]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5427.924280]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5427.924284]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5427.924286]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5427.924288]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5427.924291]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5427.924293]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5427.924297]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5427.924301]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5427.924303]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5427.924307]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5428.020315] Call Trace:
[ 5428.023046]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5428.028731]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5428.034232]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5428.040150]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5428.046852]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5428.053201]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5428.059149]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5428.065506]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5428.071436]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5428.077906]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5428.083688]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5428.089523]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5428.094827]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b
[ 5428.254277] vmwrite error: reg 401e value 81e76200 (err 12)
[ 5428.260169] Pid: 6938, comm: kvm Not tainted 3.6.0 #23
[ 5428.265572] Call Trace:
[ 5428.268290]  [<ffffffff8195f111>] vmwrite_error+0x2c/0x2e
[ 5428.273953]  [<ffffffff8102e419>] vmcs_writel+0x1e/0x20
[ 5428.279464]  [<ffffffff8102f8fa>] vmx_cpuid_update+0xe4/0xf8
[ 5428.285386]  [<ffffffff8102cc9a>] kvm_vcpu_ioctl_set_cpuid2+0x68/0x7d
[ 5428.292083]  [<ffffffff81013aeb>] kvm_arch_vcpu_ioctl+0x34f/0xc55
[ 5428.298438]  [<ffffffff8102f9c2>] ? vmx_vcpu_load+0x33/0x195
[ 5428.304426]  [<ffffffff810136eb>] ? kvm_arch_vcpu_load+0xb9/0x16a
[ 5428.310791]  [<ffffffff81004916>] kvm_vcpu_ioctl+0x46c/0x4ea
[ 5428.316745]  [<ffffffff81013617>] ? kvm_arch_dev_ioctl+0x16d/0x188
[ 5428.323188]  [<ffffffff81157b8f>] do_vfs_ioctl+0x462/0x4a3
[ 5428.328934]  [<ffffffff8111c408>] ? vm_mmap_pgoff+0x6b/0x78
[ 5428.334768]  [<ffffffff81157c17>] sys_ioctl+0x47/0x6c
[ 5428.340080]  [<ffffffff81978ba9>] system_call_fastpath+0x16/0x1b

--UlVJffcvxoiEqYs2--
