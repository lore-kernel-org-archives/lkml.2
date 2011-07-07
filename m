Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab1GGP2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 11:28:05 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:57388 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221Ab1GGP2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 11:28:00 -0400
Date: Thu, 7 Jul 2011 08:27:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [linux-next, rcu] smp_call_function_single triggers kernel
 warning in kernel/smp.c:320
Message-ID: <20110707152746.GR6014@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.DEB.2.00.1107061108160.19547@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1107061108160.19547@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 11:12:02AM -0500, Christoph Lameter wrote:
> Got a backtrace in kvm with a !NUMA (SMP) configuration of linux-next on
> Sandybridge:

I will be removing this commit (b983032b7).  Your testing along with
others shows that it is not ready for 3.0 prime time.

If you would like to test the result in parallel with my testing, please
let me know.

							Thanx, Paul

> Decompressing Linux... Parsing ELF... done.
> Booting the kernel.
> Linux version 3.0.0-rc6-next-20110706-kvm-dirty (christoph@sandy) (gcc
> version 4.5.2 (Ubuntu/Linaro 4.5.2-8ubuntu4) ) #1 SMP Wed Jul 6 11:00:57
> CDT 2011
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
>  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 000000003fffd000 (usable)
>  BIOS-e820: 000000003fffd000 - 0000000040000000 (reserved)
>  BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
> bootconsole [earlyser0] enabled
> Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
> DMI 2.4 present.
> last_pfn = 0x3fffd max_arch_pfn = 0x100000
> found SMP MP-table at [400fd760] fd760
> init_memory_mapping: 0000000000000000-000000003fffd000
> ACPI: RSDP 000fd710 00014 (v00 BOCHS )
> ACPI: RSDT 3fffda70 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> ACPI: FACP 3ffffdf0 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> ACPI: DSDT 3fffddc0 01FB7 (v01   BXPC   BXDSDT 00000001 INTL 20090123)
> ACPI: FACS 3ffffd80 00040
> ACPI: SSDT 3fffdbf0 001C1 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> ACPI: APIC 3fffdaf0 0008A (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> ACPI: HPET 3fffdab0 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
> 1023MB LOWMEM available.
>   mapped low ram: 0 - 3fffd000
>   low ram: 0 - 3fffd000
> Zone PFN ranges:
>   DMA      0x00000010 -> 0x00001000
>   Normal   0x00001000 -> 0x0003fffd
> Movable zone start PFN for each node
> early_node_map[2] active PFN ranges
>     0: 0x00000010 -> 0x0000009f
>     0: 0x00000100 -> 0x0003fffd
> Using APIC driver default
> ACPI: PM-Timer IO Port: 0xb008
> ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
> ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
> ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
> IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
> Using ACPI (MADT) for SMP configuration information
> ACPI: HPET id: 0x8086a201 base: 0xfed00000
> SMP: Allowing 4 CPUs, 0 hotplug CPUs
> Allocating PCI resources starting at 40000000 (gap: 40000000:bffc0000)
> setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
> PERCPU: Embedded 11 pages/cpu @7f000000 s23488 r0 d21568 u1048576
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages:
> 259980
> Kernel command line: root=/dev/hda1 earlyprintk=ttyS0,115200
> console=ttyS0,115200
> PID hash table entries: 4096 (order: 2, 16384 bytes)
> Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> Initializing CPU#0
> Memory: 1032388k/1048564k available (3859k kernel code, 15724k reserved,
> 1794k data, 352k init, 0k highmem)
> virtual kernel memory layout:
>     fixmap  : 0xfff17000 - 0xfffff000   ( 928 kB)
>     vmalloc : 0x807fd000 - 0xfff15000   (2039 MB)
>     lowmem  : 0x40000000 - 0x7fffd000   (1023 MB)
>       .init : 0x40686000 - 0x406de000   ( 352 kB)
>       .data : 0x404c4e1f - 0x40685980   (1794 kB)
>       .text : 0x40100000 - 0x404c4e1f   (3859 kB)
> Checking if this processor honours the WP bit even in supervisor
> mode...Ok.
> SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
> Hierarchical RCU implementation.
> NR_IRQS:512
> Console: colour VGA+ 80x25
> console [ttyS0] enabled, bootconsole disabled
> console [ttyS0] enabled, bootconsole disabled
> Fast TSC calibration using PIT
> Detected 3491.312 MHz processor.
> Marking TSC unstable due to TSCs unsynchronized
> Calibrating delay loop (skipped), value calculated using timer frequency..
> 6982.62 BogoMIPS (lpj=3491312)
> pid_max: default: 32768 minimum: 301
> Mount-cache hash table entries: 512
> ACPI: Core revision 20110413
> Enabling APIC mode:  Flat.  Using 1 I/O APICs
> ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> CPU0: AMD QEMU Virtual CPU version 0.14.0 stepping 03
> Performance Events: Broken PMU hardware detected, using software events
> only.
> Booting Node   0, Processors  #1
> Initializing CPU#1
> ------------[ cut here ]------------
> WARNING: at arch/x86/kernel/cpu/amd.c:187 init_amd+0x2ac/0x495()
> Hardware name: Bochs
> WARNING: This combination of AMD processors is not suitable for SMP.
> Modules linked in:
> Pid: 0, comm: kworker/0:0 Not tainted 3.0.0-rc6-next-20110706-kvm-dirty #1
> Call Trace:
>  [<4012694e>] warn_slowpath_common+0x65/0x7a
>  [<404bc3f5>] ? init_amd+0x2ac/0x495
>  [<401269c7>] warn_slowpath_fmt+0x26/0x2a
>  [<404bc3f5>] init_amd+0x2ac/0x495
>  [<404bb4f6>] ? get_cpu_cap+0xb7/0xbc
>  [<404bb6bc>] identify_cpu+0x1c1/0x2d4
>  [<404bb7e0>] identify_secondary_cpu+0x11/0x18
>  [<404bde75>] smp_store_cpu_info+0x31/0x35
>  [<404be197>] start_secondary+0xd5/0x1e3
> ---[ end trace a7919e7f17c0a725 ]---
> Disabling lock debugging due to kernel taint
> mce: CPU supports 10 MCE banks
>  #2
> Initializing CPU#2
>  #3 Ok.
> Initializing CPU#3
> Brought up 4 CPUs
> Total of 4 processors activated (28516.12 BogoMIPS).
> xor: automatically using best checksumming function: pIII_sse
>    pIII_sse  :  1124.000 MB/sec
> xor: using function: pIII_sse (1124.000 MB/sec)
> NET: Registered protocol family 16
> ACPI: bus type pci registered
> PCI: PCI BIOS revision 2.10 entry at 0xfc566, last bus=0
> PCI: Using configuration type 1 for base access
> bio: create slab <bio-0> at 0
> raid6: int32x1    191 MB/s
> raid6: int32x2    140 MB/s
> raid6: int32x4    148 MB/s
> raid6: int32x8     97 MB/s
> raid6: mmxx1      191 MB/s
> raid6: mmxx2      203 MB/s
> raid6: sse1x1     203 MB/s
> raid6: sse1x2     199 MB/s
> raid6: sse2x1     398 MB/s
> raid6: sse2x2     378 MB/s
> raid6: using algorithm sse2x1 (398 MB/s)
> ACPI: Interpreter enabled
> ACPI: (supports S0 S3 S5)
> ACPI: Using IOAPIC for interrupt routing
> ACPI: No dock devices found.
> PCI: Ignoring host bridge windows from ACPI; if necessary, use
> "pci=use_crs" and report a bug
> ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
> pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
>  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x18)
> ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
> ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
> ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
> ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
> ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
> vgaarb: device added:
> PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> vgaarb: loaded
> vgaarb: bridge control possible 0000:00:02.0
> SCSI subsystem initialized
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> PCI: Using ACPI for IRQ routing
> HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> hpet0: 3 comparators, 64-bit 100.000000 MHz counter
> Switching to clocksource hpet
> Switched to NOHz mode on CPU #1
> Switched to NOHz mode on CPU #2
> Switched to NOHz mode on CPU #3
> Switched to NOHz mode on CPU #0
> pnp: PnP ACPI init
> ACPI: bus type pnp registered
> pnp: PnP ACPI: found 8 devices
> ACPI: ACPI bus type pnp unregistered
> NET: Registered protocol family 2
> IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
> TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
> TCP bind hash table entries: 65536 (order: 8, 1310720 bytes)
> TCP: Hash tables configured (established 131072 bind 65536)
> TCP reno registered
> UDP hash table entries: 512 (order: 2, 24576 bytes)
> UDP-Lite hash table entries: 512 (order: 2, 24576 bytes)
> NET: Registered protocol family 1
> RPC: Registered named UNIX socket transport module.
> RPC: Registered udp transport module.
> RPC: Registered tcp transport module.
> RPC: Registered tcp NFSv4.1 backchannel transport module.
> pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> pci 0000:00:01.0: PIIX3: Enabling Passive Release
> pci 0000:00:01.0: Activating ISA DMA hang workarounds
> HugeTLB registered 4 MB page size, pre-allocated 0 pages
> VFS: Disk quotas dquot_6.5.2
> Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> SGI XFS with ACLs, security attributes, realtime, large block/inode
> numbers, no debug enabled
> SGI XFS Quota Management subsystem
> msgmni has been set to 2016
> Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
> io scheduler noop registered
> io scheduler deadline registered (default)
> io scheduler cfq registered
> start plist test
> end plist test
> input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> ACPI: Power Button [PWRF]
> Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> Linux agpgart interface v0.103
> Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is
> 60 seconds).
> Hangcheck: Using getrawmonotonic().
> FDC 0 is a S82078B
> brd: module loaded
> loop: module loaded
> Uniform Multi-Platform E-IDE driver
> piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
> piix 0000:00:01.1: not 100% native mode: will probe irqs later
>     ide0: BM-DMA at 0xc000-0xc007
>     ide1: BM-DMA at 0xc008-0xc00f
> hda: QEMU HARDDISK, ATA DISK drive
> hda: MWDMA2 mode selected
> hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
> hdc: MWDMA2 mode selected
> ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> ide1 at 0x170-0x177,0x376 on irq 15
> ide_generic: please use "probe_mask=0x3f" module parameter for probing all
> legacy ISA IDE ports
> ide-gd driver 1.18
> hda: max request size: 512KiB
> hda: 2047248 sectors (1048 MB) w/256KiB Cache, CHS=2031/255/63
> hda: cache flushes supported
>  hda: hda1
> ide-cd driver 5.00
> ide-cd: hdc: ATAPI 4X CD-ROM drive, 512kB Cache
> cdrom: Uniform CD-ROM driver Revision: 3.20
> Adaptec aacraid driver 1.1-7[28000]-ms
> 8139cp: 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
> ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
> 8139cp 0000:00:03.0: PCI INT A -> Link[LNKC] -> GSI 11 (level, high) ->
> IRQ 11
> 8139cp 0000:00:03.0: eth0: RTL-8139C+ at 0x80814000, 52:54:00:12:34:56,
> IRQ 11
> console [netcon0] enabled
> netconsole: network logging started
> Fusion MPT base driver 3.04.19
> Copyright (c) 1999-2008 LSI Corporation
> Fusion MPT FC Host driver 3.04.19
> Fusion MPT SAS Host driver 3.04.19
> Fusion MPT misc device (ioctl) driver 3.04.19
> mptctl: Registered with Fusion MPT base driver
> mptctl: /dev/mptctl @ (major,minor=10,220)
> usbcore: registered new interface driver usblp
> i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq
> 1,12
> serio: i8042 KBD port at 0x60,0x64 irq 1
> serio: i8042 AUX port at 0x60,0x64 irq 12
> mousedev: PS/2 mouse device common for all mice
> input: AT Translated Set 2 keyboard as
> /devices/platform/i8042/serio0/input/input1
> rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
> rtc0: alarms up to one day, 114 bytes nvram, hpet irqs
> rtc-test rtc-test.0: rtc core: registered test as rtc1
> rtc-test rtc-test.1: rtc core: registered test as rtc2
> md: linear personality registered for level -1
> md: raid0 personality registered for level 0
> md: raid1 personality registered for level 1
> md: raid10 personality registered for level 10
> md: raid6 personality registered for level 6
> md: raid5 personality registered for level 5
> md: raid4 personality registered for level 4
> md: multipath personality registered for level -4
> md: faulty personality registered for level -5
> device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised:
> dm-devel@redhat.com
> cpuidle: using governor ladder
> cpuidle: using governor menu
> usbcore: registered new interface driver usbhid
> usbhid: USB HID core driver
> TCP cubic registered
> NET: Registered protocol family 17
> RPC: Registered rdma transport module.
> NET: Registered protocol family 33
> Registering the dns_resolver key type
> Using IPI No-Shortcut mode
> kAFS: Red Hat AFS client v0.1 registering.
> 
> 
> 
> 
> 
> 
> 
> input: ImExPS/2 Generic Explorer Mouse as
> /devices/platform/i8042/serio1/input/input2
> md: Waiting for all devices to be available before autodetect
> md: If you don't use raid, use raid=noautodetect
> md: Autodetecting RAID arrays.
> md: Scanned 0 and added 0 devices.
> md: autorun ...
> md: ... autorun DONE.
> VFS: Mounted root (ext2 filesystem) readonly on device 3:1.
> Freeing unused kernel memory: 352k freed
> Write protecting the kernel text: 3860k
> Write protecting the kernel read-only data: 1504k
> modprobe: FATAL: Could not load
> /lib/modules/3.0.0-rc6-next-20110706-kvm-dirty/modules.dep: No such file
> or directory
> 
> INIT: version 2.86 booting
> Setting the system clock.
> Activating swap...done.
> Checking root file system...fsck 1.41.3 (12-Oct-2008)
> /lib/init/rw/rootdev: clean, 9054/64000 files, 235871/255898 blocks
> done.
> Setting the system clock.
> Cleaning up ifupdown....
> Loading kernel modules...done.
> Checking file systems...fsck 1.41.3 (12-Oct-2008)
> done.
> Setting kernel variables (/etc/sysctl.conf)...done.
> Mounting local filesystems...done.
> Activating swapfile swap...done.
> Setting up networking....
> Configuring network interfaces...Internet Systems Consortium DHCP Client
> V3.1.1
> Copyright 2004-2008 Internet Systems Consortium.
> All rights reserved.
> For info, please visit http://www.isc.org/sw/dhcp/
> 
> 8139cp 0000:00:03.0: eth0: link up, 100Mbps, full-duplex, lpa 0x05E1
> Listening on LPF/eth0/52:54:00:12:34:56
> Sending on   LPF/eth0/52:54:00:12:34:56
> Sending on   Socket/fallback
> DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 7
> DHCPOFFER from 10.0.2.2
> DHCPREQUEST on eth0 to 255.255.255.255 port 67
> DHCPACK from 10.0.2.2
> ------------[ cut here ]------------
> WARNING: at kernel/smp.c:320 smp_call_function_single+0x59/0xc7()
> Hardware name: Bochs
> Modules linked in:
> Pid: 1446, comm: ifconfig Tainted: G S      W
> 3.0.0-rc6-next-20110706-kvm-dirty #1
> Call Trace:
>  [<4012694e>] warn_slowpath_common+0x65/0x7a
>  [<4014a1e7>] ? smp_call_function_single+0x59/0xc7
>  [<40153de7>] ? invoke_rcu_core+0xf/0xf
>  [<40126972>] warn_slowpath_null+0xf/0x13
>  [<4014a1e7>] smp_call_function_single+0x59/0xc7
>  [<40154070>] rcu_start_gp+0x13e/0x21a
>  [<401549ee>] __rcu_process_callbacks+0xd5/0x224
>  [<4012ee1b>] ? run_timer_softirq+0x1a0/0x1a8
>  [<40154b6c>] rcu_process_callbacks+0x2f/0x31
>  [<4012abe2>] __do_softirq+0x6b/0xe3
>  [<4012ab77>] ? local_bh_enable+0x6e/0x6e
>  <IRQ>  [<4012adb2>] ? irq_exit+0x35/0x70
>  [<40112c29>] ? smp_apic_timer_interrupt+0x6c/0x7a
>  [<404c3a39>] ? apic_timer_interrupt+0x31/0x38
>  [<4044bb68>] ? rt_do_flush.clone.42+0x98/0xab
>  [<4044c0d2>] ? rt_cache_flush+0x28/0x2b
>  [<404735e6>] ? fib_disable_ip+0x23/0x2e
>  [<40474030>] ? fib_inetaddr_event+0x4f/0x67
>  [<4013d5ad>] ? notifier_call_chain+0x26/0x48
>  [<4013d768>] ? __blocking_notifier_call_chain+0x34/0x48
>  [<4013d788>] ? blocking_notifier_call_chain+0xc/0xe
>  [<4046d75a>] ? __inet_del_ifa+0x152/0x1d7
>  [<4046d7eb>] ? inet_del_ifa+0xc/0x10
>  [<4046e9ee>] ? devinet_ioctl+0x4c2/0x53e
>  [<4046f5cf>] ? inet_ioctl+0x8e/0xa7
>  [<40428a01>] ? sock_ioctl+0x1a8/0x1cc
>  [<40428859>] ? sock_fasync+0x6a/0x6a
>  [<40191e49>] ? do_vfs_ioctl+0x447/0x478
>  [<401185e0>] ? do_page_fault+0x2d3/0x303
>  [<4013cb49>] ? hrtimer_interrupt+0x12e/0x1c7
>  [<40191ea8>] ? sys_ioctl+0x2e/0x4a
>  [<404c3604>] ? syscall_call+0x7/0xb
> ---[ end trace a7919e7f17c0a727 ]---
> bound to 10.0.2.15 -- renewal in 34486 seconds.
> done.
> INIT: Entering runlevel: 2
> Starting enhanced syslogd: rsyslogd.
> Starting OpenBSD Secure Shell server: sshdsshd (1557): /proc/1557/oom_adj
> is deprecated, please use /proc/1557/oom_score_adj instead.
> .
> 
> Debian GNU/Linux squeeze/sid qmdr ttyS0
> 
> qmdr login:
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
