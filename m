Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794Ab1KHOoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:44:16 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38271 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724Ab1KHOoM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:44:12 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1111041037290.16959@tux.localdomain>
References: <alpine.LFD.2.02.1111041037290.16959@tux.localdomain>
Date: Tue, 8 Nov 2011 15:44:11 +0100
Message-ID: <CAFLxGvzccUb1WZOjCyuYPjS4AseS2G4BxJWvofxvbDXqf019+A@mail.gmail.com>
Subject: Re: [RFC/GIT PULL] Linux KVM tool for v3.2
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka,

On Fri, Nov 4, 2011 at 9:38 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>    ./kvm run
>
> We also support booting both raw images and QCOW2 images in read-only
> mode:
>
>    ./kvm run -d debian_squeeze_amd64_standard.qcow2 -p "root=/dev/vda1"
>

I'm trying to use the kvm tool, but the virtio_blk userland seems to freeze.
Any idea what happens here?

./kvm run -d /scratch/rw/fc14_64_image.qcow2 -p "root=/dev/vda1
nolapic init=/bin/sh notsc hpet=disable debug"
  Warning: Forcing read-only support for QCOW
  # kvm run -k ../../arch/x86/boot/bzImage -m 320 -c 2 --name guest-9815
eeaarrllyy  ccoonnssoollee  iinn  sseettuupp  ccooddee

early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Linux version 3.1.0-00905-ge0cab7f (rw@inhelltoy) (gcc
version 4.5.1 20100924 (Red Hat 4.5.1-4) (GCC) ) #3 Tue Nov 8 14:14:24
CET 2011
[    0.000000] Command line: notsc noapic noacpi pci=conf1 reboot=k
panic=1 i8042.direct=1 i8042.dumbkbd=1 i8042.nopnp=1 console=ttyS0
earlyprintk=serial i8042.noaux=1 root=/dev/vda1 nolapic init=/bin/sh
notsc hpet=disable debug
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 00000000000fffff (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000014000000 (usable)
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI not present or invalid.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000
(usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x14000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges disabled:
[    0.000000]   00000-FFFFF uncachable
[    0.000000] MTRR variable ranges disabled:
[    0.000000]   0 disabled
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x0, new 0x7010600070106
[    0.000000] CPU MTRRs all blank - virtualized system.
[    0.000000] found SMP MP-table at [ffff8800000f0370] f0370
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-0000000014000000
[    0.000000]  0000000000 - 0014000000 page 2M
[    0.000000] kernel direct mapping tables up to 14000000 @ 13ffe000-14000000
[    0.000000] ACPI Error: A valid RSDP was not found (20110623/tbxfroot-219)
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD ->
[ffff880013000000-ffff8800135fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x00014000
[    0.000000] On node 0 totalpages: 81807
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3914 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 76608 pages, LIFO batch:15
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000] MPTABLE: OEM ID: KVMCPU00
[    0.000000] MPTABLE: Product ID: 0.1
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.
Processor 1/0x1 ignored.
[    0.000000] IOAPIC[0]: apic_id 3, version 17, address 0xfec00000, GSI 0-23
[    0.000000] Processors: 1
[    0.000000] nr_irqs_gsi: 40
[    0.000000] Allocating PCI resources starting at 14000000 (gap:
14000000:ec000000)
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 80522
[    0.000000] Kernel command line: notsc noapic noacpi pci=conf1
reboot=k panic=1 i8042.direct=1 i8042.dumbkbd=1 i8042.nopnp=1
console=ttyS0 earlyprintk=serial i8042.noaux=1 root=/dev/vda1 nolapic
init=/bin/sh notsc hpet=disable debug
[    0.000000] notsc: Kernel compiled with CONFIG_X86_TSC, cannot
disable TSC completely.
[    0.000000] notsc: Kernel compiled with CONFIG_X86_TSC, cannot
disable TSC completely.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 304564k/327680k available (3056k kernel code,
452k absent, 22664k reserved, 3527k data, 344k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0,
CPUs=1, Nodes=1
[    0.000000] NR_IRQS:288
[    0.000000] Console: colour *CGA 80x25
[    0.000000] console [ttyS0] enabled, bootconsole disabled
[    0.000000] console [ttyS0] enabled, bootconsole disabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat,
Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] Fast TSC calibration failed
[    0.000000] TSC: Unable to calibrate against PIT
[    0.000000] TSC: No reference (HPET/PMTIMER) available
[    0.000000] Marking TSC unstable due to could not calculate TSC khz
[    0.020001] Calibrating delay loop... 5656.57 BogoMIPS (lpj=11313152)
[    0.040002] pid_max: default: 32768 minimum: 301
[    0.040002] Mount-cache hash table entries: 256
[    0.044002] CPU: Intel(R) Core(TM)2 CPU         X6800  @ 2.93GHz stepping 05
[    0.048002] Performance Events: unsupported p6 CPU model 15 no PMU
driver, software events only.
[    0.052002] NMI watchdog disabled (cpu0): hardware events not enabled
[    0.056003] Apic disabled
[    0.060003] NET: Registered protocol family 16
[    0.060003] PCI: Using configuration type 1 for base access
[    0.064003] bio: create slab <bio-0> at 0
[    0.068003] ACPI: Interpreter disabled.
[    0.068003] vgaarb: loaded
[    0.068003] PCI: Probing PCI hardware
[    0.072003] PCI: Probing PCI hardware (bus 00)
[    0.076003] pci 0000:00:01.0: [1af4:1001] type 0 class 0x000180
[    0.076003] pci 0000:00:01.0: reg 10: [io  0x6200-0x62ff]
[    0.080004] pci 0000:00:01.0: reg 14: [mem 0xd1000000-0xd10000ff 64bit]
[    0.084004] pci 0000:00:01.0: reg 1c: [mem 0xd1000100-0xd10001ff 64bit]
[    0.088004] pci 0000:00:02.0: [1af4:1000] type 0 class 0x000200
[    0.088004] pci 0000:00:02.0: reg 10: [io  0x6600-0x66ff]
[    0.092004] pci 0000:00:02.0: reg 14: [mem 0xd1000200-0xd10002ff 64bit]
[    0.096005] pci 0000:00:02.0: reg 1c: [mem 0xd1000300-0xd10003ff 64bit]
[    0.100005] PCI: pci_cache_line_size set to 64 bytes
[    0.100005] reserve RAM buffer: 000000000009fc00 - 000000000009ffff
[    0.104005] pnp: PnP ACPI: disabled
[    0.108005] PCI: max bus depth: 0 pci_try_num: 1
[    0.112006] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.112006] pci_bus 0000:00: resource 1 [mem 0x00000000-0xfffffffff]
[    0.116006] NET: Registered protocol family 2
[    0.120006] IP route cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.124007] TCP established hash table entries: 16384 (order: 6,
262144 bytes)
[    0.128007] TCP bind hash table entries: 16384 (order: 8, 1048576 bytes)
[    0.136007] TCP: Hash tables configured (established 16384 bind 16384)
[    0.136007] TCP reno registered
[    0.140008] UDP hash table entries: 256 (order: 3, 40960 bytes)
[    0.140008] UDP-Lite hash table entries: 256 (order: 3, 40960 bytes)
[    0.144008] PCI: CLS 0 bytes, default 64
[    0.148008] platform rtc_cmos: registered platform RTC device (no
PNP device found)
[    0.156009] Installing v9fs 9p2000 file system support
[    0.160009] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 254)
[    0.160009] io scheduler noop registered
[    0.164009] io scheduler deadline registered
[    0.164009] io scheduler cfq registered (default)
[    0.168009] start plist test
[    0.168009] end plist test
[    0.168009] virtio-pci 0000:00:01.0: enabling device (0000 -> 0003)
[    0.172010] virtio-pci 0000:00:01.0: setting latency timer to 64
[    0.176010] virtio-pci 0000:00:02.0: enabling device (0000 -> 0003)
[    0.180010] virtio-pci 0000:00:02.0: setting latency timer to 64
[    0.200011] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.208012] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.220013] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.232013] serial8250: ttyS2 at I/O 0x3e8 (irq = 4) is a 16550A
[  240.167008] INFO: task swapper:1 blocked for more than 120 seconds.
[  240.167008] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  240.171009] swapper         D ffffffff81071c70     0     1      0 0x00000000
[  240.171009]  ffff880012c2d8b0 0000000000000046 ffff880000000000
ffff880012c2d7d0
[  240.175009]  0000000000000003 ffff880012c2d8b0 ffff880012c30000
ffff880012c2dfd8
[  240.179009]  ffff880012c2c000 ffff880012c2dfd8 ffffffff81614040
ffff880012c30000
[  240.179009] Call Trace:
[  240.179009]  [<ffffffff810a1307>] ? kmem_cache_alloc+0xa7/0xe0
[  240.183009]  [<ffffffff81057b61>] ? mark_held_locks+0x61/0x150
[  240.183009]  [<ffffffff812f97db>] ? _raw_spin_unlock_irqrestore+0x3b/0x70
[  240.187010]  [<ffffffff81071c70>] ? file_read_actor+0x190/0x190
[  240.187010]  [<ffffffff81057d4d>] ? trace_hardirqs_on_caller+0xfd/0x190
[  240.191010]  [<ffffffff81071c70>] ? file_read_actor+0x190/0x190
[  240.191010]  [<ffffffff812f6eb9>] schedule+0x39/0x50
[  240.191010]  [<ffffffff812f711e>] io_schedule+0x3e/0x60
[  240.195010]  [<ffffffff812f983b>] ? _raw_spin_unlock_irq+0x2b/0x50
[  240.195010]  [<ffffffff81071c79>] sleep_on_page+0x9/0x10
[  240.199010]  [<ffffffff812f76f1>] __wait_on_bit_lock+0x51/0xb0
[  240.203011]  [<ffffffff810d5520>] ? bioset_create+0x280/0x280
[  240.203011]  [<ffffffff810726f1>] __lock_page+0x61/0x70
[  240.203011]  [<ffffffff81045440>] ? autoremove_wake_function+0x40/0x40
[  240.207011]  [<ffffffff81072ac7>] do_read_cache_page+0x177/0x1a0
[  240.207011]  [<ffffffff810d5ac0>] ? blkdev_write_begin+0x20/0x20
[  240.211011]  [<ffffffff81074007>] read_cache_page_async+0x17/0x20
[  240.211011]  [<ffffffff81074049>] read_cache_page+0x9/0x20
[  240.215011]  [<ffffffff810f7a8b>] read_dev_sector+0x2b/0x90
[  240.215011]  [<ffffffff810f7e10>] ? parse_extended+0x2c0/0x2c0
[  240.219012]  [<ffffffff810f7e8a>] msdos_partition+0x7a/0x5b0
[  240.219012]  [<ffffffff811855e4>] ? snprintf+0x34/0x40
[  240.219012]  [<ffffffff810f7e10>] ? parse_extended+0x2c0/0x2c0
[  240.223012]  [<ffffffff810f7758>] rescan_partitions+0x1a8/0x4b0
[  240.227012]  [<ffffffff810d6c4e>] __blkdev_get+0x26e/0x3a0
[  240.227012]  [<ffffffff810d6dce>] blkdev_get+0x4e/0x380
[  240.227012]  [<ffffffff8117df77>] ? kobject_put+0x27/0x60
[  240.231012]  [<ffffffff811731c8>] ? disk_get_part+0x18/0xc0
[  240.231012]  [<ffffffff81173e57>] register_disk+0x157/0x180
[  240.235013]  [<ffffffff81173f25>] add_disk+0xa5/0x300
[  240.235013]  [<ffffffff812f4c5a>] virtblk_probe+0x51f/0x5a3
[  240.235013]  [<ffffffff812f7a9f>] ? mutex_lock_nested+0x22f/0x300
[  240.239013]  [<ffffffff81209830>] ? do_virtblk_request+0x450/0x450
[  240.239013]  [<ffffffff811d2720>] ? vp_reset+0x20/0x20
[  240.243013]  [<ffffffff811d0ee1>] virtio_dev_probe+0xe1/0x140
[  240.247013]  [<ffffffff812013e8>] driver_probe_device+0x88/0x1a0
[  240.247013]  [<ffffffff812015a3>] __driver_attach+0xa3/0xb0
[  240.247013]  [<ffffffff81201500>] ? driver_probe_device+0x1a0/0x1a0
[  240.251014]  [<ffffffff8120011e>] bus_for_each_dev+0x5e/0x90
[  240.251014]  [<ffffffff812016d9>] driver_attach+0x19/0x20
[  240.255014]  [<ffffffff81200888>] bus_add_driver+0x148/0x280
[  240.255014]  [<ffffffff8168d694>] ? firmware_class_init+0x19/0x19
[  240.255014]  [<ffffffff81201f11>] driver_register+0x71/0x140
[  240.259014]  [<ffffffff812f86d9>] ? mutex_unlock+0x9/0x10
[  240.259014]  [<ffffffff8168d694>] ? firmware_class_init+0x19/0x19
[  240.263014]  [<ffffffff811d0fcb>] register_virtio_driver+0x1b/0x30
[  240.263014]  [<ffffffff8168d6ee>] init+0x5a/0x84
[  240.267015]  [<ffffffff81670b15>] do_one_initcall+0x78/0x12b
[  240.267015]  [<ffffffff81670c58>] kernel_init+0x90/0x110
[  240.271015]  [<ffffffff811871ee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  240.271015]  [<ffffffff812fb834>] kernel_thread_helper+0x4/0x10
[  240.275015]  [<ffffffff812fa259>] ? retint_restore_args+0xe/0xe
[  240.275015]  [<ffffffff81670bc8>] ? do_one_initcall+0x12b/0x12b
[  240.275015]  [<ffffffff812fb830>] ? gs_change+0xb/0xb
[  240.279015] 3 locks held by swapper/1:
[  240.279015]  #0:  (&__lockdep_no_validate__){......}, at:
[<ffffffff81201553>] __driver_attach+0x53/0xb0
[  240.283016]  #1:  (&__lockdep_no_validate__){......}, at:
[<ffffffff81201561>] __driver_attach+0x61/0xb0
[  240.287016]  #2:  (&bdev->bd_mutex){+.+.+.}, at:
[<ffffffff810d6a1b>] __blkdev_get+0x3b/0x3a0

-- 
Thanks,
//richard
