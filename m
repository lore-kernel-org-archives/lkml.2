Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab1GZUyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 16:54:12 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:61785 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab1GZUyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 16:54:10 -0400
Date: Tue, 26 Jul 2011 16:51:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: jj@chaosbits.net, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, arjan@infradead.org,
        JBeulich@novell.com, richard.weinberger@gmail.com, mikpe@it.uu.se,
        andi@firstfloor.org, brgerst@gmail.com, Louis.Rilling@kerlabs.com,
        Valdis.Kletnieks@vt.edu, pageexec@freemail.hu, mingo@elte.hu,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: Re: git commit 9fd67b4ed0714ab718f1f9bd14c344af336a6df7 (x86-64:
 Give vvars their own page) breaks Xen PV guests (64-bit).
Message-ID: <20110726205121.GA29604@dumpdata.com>
References: <20110725155442.GA21759@dumpdata.com>
 <20110725161009.GA9193@dumpdata.com>
 <CAObL_7F9+Wn1DBf5te7BHoAe3CbEzR=pxTqy_S_vpkwcG57NKQ@mail.gmail.com>
 <20110726161808.GA5333@dumpdata.com>
 <CAObL_7Fi5F6Xxv7Z5UtEQAA+gH4429gN=GG8ur6rxa6-rgr+2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAObL_7Fi5F6Xxv7Z5UtEQAA+gH4429gN=GG8ur6rxa6-rgr+2w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4E2F28DB.003C:SCFMA922111,ss=1,re=-6.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That one means that the vvar fixmap isn't working.  Can you try the
> attached patch?

Sure. Albeit it looks to be missing a check for the 0xe033 cs?

This is what I get from launching a guest:

(early) [    0.000000] Initializing cgroup subsys cpuset
(early) [    0.000000] Initializing cgroup subsys cpu
(early) [    0.000000] Linux version 3.0.0-05046-ge08dc13-dirty (konrad@phenom) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #1 SMP PREEMPT Tue Jul 26 16:24:01 EDT 2011
(early) [    0.000000] Command line: console=hvc0 debug     earlyprintk=xenboot test=test
(early) [    0.000000] ACPI in unprivileged domain disabled
(early) [    0.000000] released 0 pages of unused memory
(early) [    0.000000] Set 0 page(s) to 1-1 mapping.
(early) [    0.000000] BIOS-provided physical RAM map:
(early) [    0.000000]  Xen: 0000000000000000 - 00000000000a0000 (usable)
(early) [    0.000000]  Xen: 00000000000a0000 - 0000000000100000 (reserved)
(early) [    0.000000]  Xen: 0000000000100000 - 0000000080800000 (usable)
(early) [    0.000000] bootconsole [xenboot0] enabled
(early) [    0.000000] NX (Execute Disable) protection: active
(early) [    0.000000] DMI not present or invalid.
(early) [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (early) (usable)(early)  ==> (early) (reserved)(early) 
(early) [    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (early) (usable)(early) 
(early) [    0.000000] No AGP bridge found
(early) [    0.000000] last_pfn = 0x80800 max_arch_pfn = 0x400000000
(early) [    0.000000] initial memory mapped : 0 - 1028f000
(early) [    0.000000] Base memory trampoline at [ffff88000009b000] 9b000 size 20480
(early) [    0.000000] init_memory_mapping: 0000000000000000-0000000080800000
(early) [    0.000000]  0000000000 - 0080800000 page 4k
(early) [    0.000000] kernel direct mapping tables up to 80800000 @ 7fbf8000-80000000
(early) [    0.000000] xen: setting RW the range 7ff76000 - 80000000
(early) [    0.000000] RAMDISK: 01b76000 - 1028f000
(early) [    0.000000] No NUMA configuration found
(early) [    0.000000] Faking a node at 0000000000000000-0000000080800000
(early) [    0.000000] Initmem setup node 0 0000000000000000-0000000080800000
(early) [    0.000000]   NODE_DATA [000000007fffb000 - 000000007fffffff]
(early) [    0.000000] Zone PFN ranges:
(early) [    0.000000]   DMA      (early) 0x00000010 -> 0x00001000
(early) [    0.000000]   DMA32    (early) 0x00001000 -> 0x00100000
(early) [    0.000000]   Normal   (early) empty
(early) [    0.000000] Movable zone start PFN for each node
(early) [    0.000000] early_node_map[2] active PFN ranges
(early) [    0.000000]     0: 0x00000010 -> 0x000000a0
(early) [    0.000000]     0: 0x00000100 -> 0x00080800
(early) [    0.000000] On node 0 totalpages: 526224
(early) [    0.000000]   DMA zone: 56 pages used for memmap
(early) [    0.000000]   DMA zone: 5 pages reserved
(early) [    0.000000]   DMA zone: 3923 pages, LIFO batch:0
(early) [    0.000000]   DMA32 zone: 7140 pages used for memmap
(early) [    0.000000]   DMA32 zone: 515100 pages, LIFO batch:31
(early) [    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
(early) [    0.000000] No local APIC present
(early) [    0.000000] APIC: disable apic facility
(early) [    0.000000] APIC: switched to apic NOOP
(early) [    0.000000] nr_irqs_gsi: 16
(early) [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
(early) [    0.000000] Allocating PCI resources starting at 80800000 (gap: 80800000:7f800000)
(early) [    0.000000] Booting paravirtualized kernel on Xen
(early) [    0.000000] Xen version: 4.2-unstable (preserve-AD)
(early) [    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:4 nr_node_ids:1
(early) [    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88007fb88000 s82048 r8192 d24448 u114688
(early) [    0.000000] pcpu-alloc: s82048 r8192 d24448 u114688 alloc=28*4096(early) 
(early) [    0.000000] pcpu-alloc: (early) [0] (early) 0 (early) [0] (early) 1 (early) [0] (early) 2 (early) [0] (early) 3 (early) 
(early) [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 519023
(early) [    0.000000] Policy zone: DMA32
(early) [    0.000000] Kernel command line: console=hvc0 debug     earlyprintk=xenboot test=test
(early) [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
(early) [    0.000000] Checking aperture...
(early) [    0.000000] No AGP bridge found
(early) [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
(early) [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
(early) [    0.000000] Memory: 1810140k/2105344k available (5942k kernel code, 448k absent, 294756k reserved, 2808k data, 692k init)
(early) [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
(early) [    0.000000] Preemptible hierarchical RCU implementation.
(early) [    0.000000] NR_IRQS:16640 nr_irqs:304 16
(early) [    0.000000] Console: colour dummy device 80x25
(early) [    0.000000] console [tty0] enabled
[    0.000000] console [hvc0] enabled, bootconsole disabled
(early) [    0.000000] console [hvc0] enabled, bootconsole disabled
[    0.000000] Xen: using vcpuop timer interface
[    0.000000] installing Xen timer for CPU 0
[    0.000000] Detected 3000.212 MHz processor.
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[    0.000999] Calibrating delay loop (skipped), value calculated using timer frequency.. 6000.42 BogoMIPS (lpj=3000212)
[    0.000999] pid_max: default: 32768 minimum: 301
[    0.000999] Security Framework initialized
[    0.000999] SELinux:  Initializing.
[    0.000999] SELinux:  Starting in permissive mode
[    0.000999] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.001391] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.001664] Mount-cache hash table entries: 256
[    0.001828] Initializing cgroup subsys cpuacct
[    0.001838] Initializing cgroup subsys freezer
[    0.001879] tseg: 0000000000
[    0.001891] CPU: Physical Processor ID: 0
[    0.001896] CPU: Processor Core ID: 3
[    0.001952] SMP alternatives: switching to UP code
[    0.002067] cpu 0 spinlock event irq 17
[    0.002113] Performance Events: 
[    0.002118] no APIC, boot with the "lapic" boot parameter to force-enable it.
[    0.002124] no hardware sampling interrupt available.
[    0.002145] Broken PMU hardware detected, using software events only.
[    0.008116] MCE: In-kernel MCE decoding enabled.
[    0.008136] NMI watchdog disabled (cpu0): hardware events not enabled
[    0.014060] installing Xen timer for CPU 1
[    0.014116] cpu 1 spinlock event irq 23
[    0.014192] SMP alternatives: switching to SMP code
[    0.015097] NMI watchdog disabled (cpu1): hardware events not enabled
[    0.021064] installing Xen timer for CPU 2
[    0.021119] cpu 2 spinlock event irq 29
[    0.021369] NMI watchdog disabled (cpu2): hardware events not enabled
[    0.027065] installing Xen timer for CPU 3
[    0.027119] cpu 3 spinlock event irq 35
[    0.027356] NMI watchdog disabled (cpu3): hardware events not enabled
[    0.029021] Brought up 4 CPUs
[    0.029137] kworker/u:0 used greatest stack depth: 5496 bytes left
[    0.029174] Grant table initialized
[    0.048869] RTC time: 165:165:165, date: 165/165/65
[    0.048909] NET: Registered protocol family 16
[    0.049143] Extended Config Space enabled on 0 nodes
[    0.050326] PCI: setting up Xen PCI frontend stub
[    0.050341] PCI: pci_cache_line_size set to 64 bytes
[    0.059045] bio: create slab <bio-0> at 0
[    0.060044] ACPI: Interpreter disabled.
[    0.060044] xen/balloon: Initialising balloon driver.
[    0.060044] last_pfn = 0x80800 max_arch_pfn = 0x400000000
[    0.062138] xen-balloon: Initialising balloon driver.
[    0.063082] vgaarb: loaded
[    0.063082] usbcore: registered new interface driver usbfs
[    0.063082] usbcore: registered new interface driver hub
[    0.063082] usbcore: registered new device driver usb
[    0.064035] PCI: System does not support PCI
[    0.064035] PCI: System does not support PCI
[    0.064054] NetLabel: Initializing
[    0.064054] NetLabel:  domain hash size = 128
[    0.064054] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.064054] NetLabel:  unlabeled traffic allowed by default
[    0.064085] Switching to clocksource xen
[    0.064406] Switched to NOHz mode on CPU #0
[    0.064962] Switched to NOHz mode on CPU #2
[    0.064995] Switched to NOHz mode on CPU #1
[    0.065071] Switched to NOHz mode on CPU #3
[    0.066298] pnp: PnP ACPI: disabled
[    0.071088] PCI: max bus depth: 0 pci_try_num: 1
[    0.071143] NET: Registered protocol family 2
[    0.071324] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.072659] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.073918] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.074217] TCP: Hash tables configured (established 262144 bind 65536)
[    0.074228] TCP reno registered
[    0.074249] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.074276] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.074364] NET: Registered protocol family 1
[    0.074542] RPC: Registered named UNIX socket transport module.
[    0.074550] RPC: Registered udp transport module.
[    0.074555] RPC: Registered tcp transport module.
[    0.074559] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.074566] PCI: CLS 0 bytes, default 64
[    0.074682] Trying to unpack rootfs image as initramfs...
[    0.318696] Freeing initrd memory: 236644k freed
[    0.378844] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    0.380209] Machine check injector initialized
[    0.380975] microcode: CPU0: patch_level=0x010000bf
[    0.381010] microcode: CPU1: patch_level=0x010000bf
[    0.381083] microcode: CPU2: patch_level=0x010000bf
[    0.381179] microcode: CPU3: patch_level=0x010000bf
[    0.381256] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.381648] audit: initializing netlink socket (disabled)
[    0.381670] type=2000 audit(1311713301.894:1): initialized
[    0.395872] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.401251] VFS: Disk quotas dquot_6.5.2
[    0.401400] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.402131] NTFS driver 2.1.30 [Flags: R/W].
[    0.402462] msgmni has been set to 3997
[    0.402606] SELinux:  Registering netfilter hooks
[    0.403425] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.403434] io scheduler noop registered
[    0.403452] io scheduler deadline registered
[    0.403554] io scheduler cfq registered (default)
[    0.403897] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.449804] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.515715] Non-volatile memory driver v1.3
[    0.515740] Linux agpgart interface v0.103
[    0.516231] [drm] Initialized drm 1.1.0 20060810
[    0.518833] brd: module loaded
[    0.520221] loop: module loaded
[    0.520875] Fixed MDIO Bus: probed
[    0.521447] tun: Universal TUN/TAP device driver, 1.6
[    0.521461] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.521835] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.521844] ehci_hcd: block sizes: qh 112 qtd 96 itd 192 sitd 96
[    0.521931] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.521937] ohci_hcd: block sizes: ed 80 td 96
[    0.522023] uhci_hcd: USB Universal Host Controller Interface driver
[    0.522222] usbcore: registered new interface driver usblp
[    0.522307] usbcore: registered new interface driver libusual
[    0.522613] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.523442] i8042: No controller found
[    0.523595] mousedev: PS/2 mouse device common for all mice
[    0.564242] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[    0.564478] rtc_cmos: probe of rtc_cmos failed with error -38
[    0.564858] cpuidle: using governor ladder
[    0.564866] cpuidle: using governor menu
[    0.564872] EFI Variables Facility v0.08 2004-May-17
[    0.564965] zram: num_devices not specified. Using default: 1
[    0.564973] zram: Creating 1 devices ...
[    0.565379] Netfilter messages via NETLINK v0.30.
[    0.565401] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    0.565729] ctnetlink v0.93: registering with nfnetlink.
[    0.566215] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.566278] TCP cubic registered
[    0.566282] Initializing XFRM netlink socket
[    0.566843] NET: Registered protocol family 10
[    0.567453] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    0.567512] IPv6 over IPv4 tunneling driver
[    0.568324] NET: Registered protocol family 17
[    0.568355] Registering the dns_resolver key type
[    0.568867] PM: Hibernation image not present or could not be loaded.
[    0.568891] registered taskstats version 1
[    0.568926] XENBUS: Device with no driver: device/vif/0
[    0.568932] XENBUS: Device with no driver: device/vfb/0
[    0.568937] XENBUS: Device with no driver: device/vkbd/0
[    0.568951]   Magic number: 1:252:3141
[    0.569157] powernow-k8: Found 1 AMD Phenom(tm) II X6 1075T Processor (4 cpu cores) (version 2.20.00)
[    0.569202] powernow-k8: Core Performance Boosting: on.
[    0.569220] [Firmware Bug]: powernow-k8: No compatible ACPI _PSS objects found.
[    0.569221] [Firmware Bug]: powernow-k8: Try again with latest BIOS.
[    0.569692] Freeing unused kernel memory: 692k freed
[    0.569888] Write protecting the kernel read-only data: 8192k
[    0.572708] Freeing unused kernel memory: 180k freed
[    0.572901] Freeing unused kernel memory: 328k freed
[    0.574137] init[1] illegal int 0xcc from 32-bit mode ip:ffffffffff600400 cs:e033 sp:7fff741c01a8 ax:ffffffffff600400 si:7fd5c2af52bf di:7fff741c0278
[    0.574370] init used greatest stack depth: 5104 bytes left
[    0.574382] Kernel panic - not syncing: Attempted to kill init!
[    0.574389] Pid: 1, comm: init Not tainted 3.0.0-05046-ge08dc13-dirty #1
[    0.574395] Call Trace:
[    0.574414]  [<ffffffff815be353>] panic+0x96/0x1ad
[    0.574422]  [<ffffffff810845d1>] ? get_parent_ip+0x11/0x50
[    0.574430]  [<ffffffff810966ac>] do_exit+0x93c/0x940
[    0.574437]  [<ffffffff810966fc>] do_group_exit+0x4c/0xc0
[    0.574445]  [<ffffffff810a84cf>] get_signal_to_deliver+0x20f/0x5c0
[    0.574453]  [<ffffffff81049473>] do_signal+0x63/0x710
[    0.574461]  [<ffffffff810402b2>] ? check_events+0x12/0x20
[    0.574467]  [<ffffffff810845d1>] ? get_parent_ip+0x11/0x50
[    0.574475]  [<ffffffff815c4b2d>] ? sub_preempt_count+0x9d/0xd0
[    0.574482]  [<ffffffff815c1607>] ? _raw_spin_unlock_irqrestore+0x27/0x50
[    0.574489]  [<ffffffff810a702d>] ? force_sig_info+0x9d/0x110
[    0.574496]  [<ffffffff81049b85>] do_notify_resume+0x65/0x80
[    0.574504]  [<ffffffff8104deee>] ? do_emulate_vsyscall+0x5e/0x190
[    0.574511]  [<ffffffff815c1b3c>] retint_signal+0x48/0x8c
Parsing config file /root/pv.xm
Daemon running with PID 29568
