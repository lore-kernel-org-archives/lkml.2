Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab2ECICN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 04:02:13 -0400
Received: from websrv.saout.de ([78.46.99.52]:38463 "EHLO websrv.saout.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab2ECICE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 04:02:04 -0400
Message-ID: <1336032119.3614.6.camel@localhost>
Subject: Re: Oops with DCACHE_WORD_ACCESS and ocfs2, autofs4
From: Jana Saout <jana@saout.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@gmail.com>, Joel Becker <jlbec@evilplan.org>,
        "H.PeterAnvin" <hpa@zytor.com>, IngoMolnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Date: Thu, 03 May 2012 10:01:59 +0200
In-Reply-To: <CA+55aFwPgWqCPA=ao6XmZy56PaJZ4WC+hOZ_CHGWpo_zO425VA@mail.gmail.com>
References: <1335788867.29087.19.camel@localhost>
	 <20120501110024.GC6649@dhcp-172-17-9-228.mtv.corp.google.com>
	 <1335875321.26671.15.camel@localhost>
	 <CAPa8GCANv=-c7HsYvDqM+8JqJq6Gr9muxAivU2Ni16x9Ru5EXw@mail.gmail.com>
	 <CA+55aFwPgWqCPA=ao6XmZy56PaJZ4WC+hOZ_CHGWpo_zO425VA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

> Jana, can you send me the whole dmesg for the bootup up to and
> including the oops?

[ note: that kernel has the Xen frontswap/selfballooning patch applied,
but the same issue happened with vanilla 3.4.0-rc5 too, I tried that
too, just to make sure ]

BTW, the Oops is not fatal, the kernel keeps running for hours
afterwards.

	Jana


Apr 30 00:19:35 web kernel: Initializing cgroup subsys cpu
Apr 30 00:19:35 web kernel: Linux version 3.4.0-js1 (root@app1.aufwind.intern) (gcc version 4.6.3) #1 SMP PREEMPT Sun Apr 29 22:13:22 CEST 2012
Apr 30 00:19:35 web kernel: Command line: root=/dev/mapper/xvda console=hvc0 tmem reboot=10 automap=xvda
Apr 30 00:19:35 web kernel: KERNEL supported cpus:
Apr 30 00:19:35 web kernel:   Intel GenuineIntel
Apr 30 00:19:35 web kernel:   AMD AuthenticAMD
Apr 30 00:19:35 web kernel:   Centaur CentaurHauls
Apr 30 00:19:35 web kernel: BIOS-provided physical RAM map:
Apr 30 00:19:35 web kernel:  Xen: 0000000000000000 - 00000000000a0000 (usable)
Apr 30 00:19:35 web kernel:  Xen: 00000000000a0000 - 0000000000100000 (reserved)
Apr 30 00:19:35 web kernel:  Xen: 0000000000100000 - 0000000100800000 (usable)
Apr 30 00:19:35 web kernel: NX (Execute Disable) protection: active
Apr 30 00:19:35 web kernel: DMI not present or invalid.
Apr 30 00:19:35 web kernel: e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
Apr 30 00:19:35 web kernel: e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
Apr 30 00:19:35 web kernel: last_pfn = 0x100800 max_arch_pfn = 0x400000000
Apr 30 00:19:35 web kernel: last_pfn = 0x100000 max_arch_pfn = 0x400000000
Apr 30 00:19:35 web kernel: initial memory mapped : 0 - 01f4e000
Apr 30 00:19:35 web kernel: Base memory trampoline at [ffff88000009e000] 9e000 size 8192
Apr 30 00:19:35 web kernel: init_memory_mapping: 0000000000000000-0000000100000000
Apr 30 00:19:35 web kernel:  0000000000 - 0100000000 page 4k
Apr 30 00:19:35 web kernel: kernel direct mapping tables up to 100000000 @ 7fb000-1000000
Apr 30 00:19:35 web kernel: xen: setting RW the range fe8000 - 1000000
Apr 30 00:19:35 web kernel: init_memory_mapping: 0000000100000000-0000000100800000
Apr 30 00:19:35 web kernel:  0100000000 - 0100800000 page 4k
Apr 30 00:19:35 web kernel: kernel direct mapping tables up to 100800000 @ 7f7f6000-80000000
Apr 30 00:19:35 web kernel: xen: setting RW the range 7f7fb000 - 80000000
Apr 30 00:19:35 web kernel: No NUMA configuration found
Apr 30 00:19:35 web kernel: Faking a node at 0000000000000000-0000000100800000
Apr 30 00:19:35 web kernel: Initmem setup node 0 0000000000000000-0000000100800000
Apr 30 00:19:35 web kernel:   NODE_DATA [000000007fffe000 - 000000007fffffff]
Apr 30 00:19:35 web kernel: Zone PFN ranges:
Apr 30 00:19:35 web kernel:   DMA      0x00000010 -> 0x00001000
Apr 30 00:19:35 web kernel:   DMA32    0x00001000 -> 0x00100000
Apr 30 00:19:35 web kernel:   Normal   0x00100000 -> 0x00100800
Apr 30 00:19:35 web kernel: Movable zone start PFN for each node
Apr 30 00:19:35 web kernel: Early memory PFN ranges
Apr 30 00:19:35 web kernel:     0: 0x00000010 -> 0x000000a0
Apr 30 00:19:35 web kernel:     0: 0x00000100 -> 0x00100800
Apr 30 00:19:35 web kernel: On node 0 totalpages: 1050512
Apr 30 00:19:35 web kernel:   DMA zone: 64 pages used for memmap
Apr 30 00:19:35 web kernel:   DMA zone: 2031 pages reserved
Apr 30 00:19:35 web kernel:   DMA zone: 1889 pages, LIFO batch:0
Apr 30 00:19:35 web kernel:   DMA32 zone: 16320 pages used for memmap
Apr 30 00:19:35 web kernel:   DMA32 zone: 1028160 pages, LIFO batch:31
Apr 30 00:19:35 web kernel:   Normal zone: 32 pages used for memmap
Apr 30 00:19:35 web kernel:   Normal zone: 2016 pages, LIFO batch:0
Apr 30 00:19:35 web kernel: SMP: Allowing 6 CPUs, 0 hotplug CPUs
Apr 30 00:19:35 web kernel: No local APIC present
Apr 30 00:19:35 web kernel: APIC: disable apic facility
Apr 30 00:19:35 web kernel: APIC: switched to apic NOOP
Apr 30 00:19:35 web kernel: nr_irqs_gsi: 16
Apr 30 00:19:35 web kernel: PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
Apr 30 00:19:35 web kernel: PCI: Warning: Cannot find a gap in the 32bit address range
Apr 30 00:19:35 web kernel: PCI: Unassigned devices with 32bit resource registers may break!
Apr 30 00:19:35 web kernel: Allocating PCI resources starting at 100900000 (gap: 100900000:400000)
Apr 30 00:19:35 web kernel: Booting paravirtualized kernel on Xen
Apr 30 00:19:35 web kernel: Xen version: 4.1.2 (preserve-AD)
Apr 30 00:19:35 web kernel: setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:6 nr_node_ids:1
Apr 30 00:19:35 web kernel: PERCPU: Embedded 27 pages/cpu @ffff88007ff0c000 s81536 r8192 d20864 u110592
Apr 30 00:19:35 web kernel: pcpu-alloc: s81536 r8192 d20864 u110592 alloc=27*4096
Apr 30 00:19:35 web kernel: pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5 
Apr 30 00:19:35 web kernel: Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1032065
Apr 30 00:19:35 web kernel: Policy zone: Normal
Apr 30 00:19:35 web kernel: Kernel command line: root=/dev/mapper/xvda console=hvc0 tmem reboot=10 automap=xvda
Apr 30 00:19:35 web kernel: PID hash table entries: 4096 (order: 3, 32768 bytes)
Apr 30 00:19:35 web kernel: Memory: 1938152k/4202496k available (4255k kernel code, 448k absent, 2263896k reserved, 4389k data, 2032k init)
Apr 30 00:19:35 web kernel: SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=6, Nodes=1
Apr 30 00:19:35 web kernel: Preemptible hierarchical RCU implementation.
Apr 30 00:19:35 web kernel: ^IAdditional per-CPU info printed with stalls.
Apr 30 00:19:35 web kernel: NR_IRQS:4352 nr_irqs:64 16
Apr 30 00:19:35 web kernel: Console: colour dummy device 80x25
Apr 30 00:19:35 web kernel: console [tty0] enabled
Apr 30 00:19:35 web kernel: console [hvc0] enabled
Apr 30 00:19:35 web kernel: Xen: using vcpuop timer interface
Apr 30 00:19:35 web kernel: installing Xen timer for CPU 0
Apr 30 00:19:35 web kernel: Detected 2100.082 MHz processor.
Apr 30 00:19:35 web kernel: Marking TSC unstable due to TSCs unsynchronized
Apr 30 00:19:35 web kernel: Calibrating delay loop (skipped), value calculated using timer frequency.. 4201.17 BogoMIPS (lpj=7000273)
Apr 30 00:19:35 web kernel: pid_max: default: 32768 minimum: 301
Apr 30 00:19:35 web kernel: Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Apr 30 00:19:35 web kernel: Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Apr 30 00:19:35 web kernel: Mount-cache hash table entries: 256
Apr 30 00:19:35 web kernel: tseg: 00d7f00000
Apr 30 00:19:35 web kernel: CPU: Physical Processor ID: 1
Apr 30 00:19:35 web kernel: CPU: Processor Core ID: 4
Apr 30 00:19:35 web kernel: SMP alternatives: switching to UP code
Apr 30 00:19:35 web kernel: cpu 0 spinlock event irq 17
Apr 30 00:19:35 web kernel: Performance Events: 
Apr 30 00:19:35 web kernel: no APIC, boot with the "lapic" boot parameter to force-enable it.
Apr 30 00:19:35 web kernel: no hardware sampling interrupt available.
Apr 30 00:19:35 web kernel: Broken PMU hardware detected, using software events only.
Apr 30 00:19:35 web kernel: NMI watchdog: disabled (cpu0): hardware events not enabled
Apr 30 00:19:35 web kernel: installing Xen timer for CPU 1
Apr 30 00:19:35 web kernel: cpu 1 spinlock event irq 24
Apr 30 00:19:35 web kernel: SMP alternatives: switching to SMP code
Apr 30 00:19:35 web kernel: NMI watchdog: disabled (cpu1): hardware events not enabled
Apr 30 00:19:35 web kernel: installing Xen timer for CPU 2
Apr 30 00:19:35 web kernel: cpu 2 spinlock event irq 31
Apr 30 00:19:35 web kernel: NMI watchdog: disabled (cpu2): hardware events not enabled
Apr 30 00:19:35 web kernel: installing Xen timer for CPU 3
Apr 30 00:19:35 web kernel: cpu 3 spinlock event irq 38
Apr 30 00:19:35 web kernel: NMI watchdog: disabled (cpu3): hardware events not enabled
Apr 30 00:19:35 web kernel: installing Xen timer for CPU 4
Apr 30 00:19:35 web kernel: cpu 4 spinlock event irq 45
Apr 30 00:19:35 web kernel: NMI watchdog: disabled (cpu4): hardware events not enabled
Apr 30 00:19:35 web kernel: installing Xen timer for CPU 5
Apr 30 00:19:35 web kernel: cpu 5 spinlock event irq 52
Apr 30 00:19:35 web kernel: NMI watchdog: disabled (cpu5): hardware events not enabled
Apr 30 00:19:35 web kernel: Brought up 6 CPUs
Apr 30 00:19:35 web kernel: devtmpfs: initialized
Apr 30 00:19:35 web kernel: Grant tables using version 2 layout.
Apr 30 00:19:35 web kernel: Grant table initialized
Apr 30 00:19:35 web kernel: NET: Registered protocol family 16
Apr 30 00:19:35 web kernel: bio: create slab <bio-0> at 0
Apr 30 00:19:35 web kernel: xen/balloon: Initialising balloon driver.
Apr 30 00:19:35 web kernel: xen-balloon: Initialising balloon driver.
Apr 30 00:19:35 web kernel: xen/balloon: Initializing Xen selfballooning driver.
Apr 30 00:19:35 web kernel: xen/balloon: Initializing frontswap selfshrinking driver.
Apr 30 00:19:35 web kernel: SCSI subsystem initialized
Apr 30 00:19:35 web kernel: Switching to clocksource xen
Apr 30 00:19:35 web kernel: NET: Registered protocol family 2
Apr 30 00:19:35 web kernel: IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
Apr 30 00:19:35 web kernel: TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
Apr 30 00:19:35 web kernel: TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Apr 30 00:19:35 web kernel: TCP: Hash tables configured (established 524288 bind 65536)
Apr 30 00:19:35 web kernel: TCP: reno registered
Apr 30 00:19:35 web kernel: UDP hash table entries: 2048 (order: 4, 65536 bytes)
Apr 30 00:19:35 web kernel: UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
Apr 30 00:19:35 web kernel: NET: Registered protocol family 1
Apr 30 00:19:35 web kernel: PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Apr 30 00:19:35 web kernel: Placing 64MB software IO TLB between ffff880077400000 - ffff88007b400000
Apr 30 00:19:35 web kernel: software IO TLB at phys 0x77400000 - 0x7b400000
Apr 30 00:19:35 web kernel: platform rtc_cmos: registered platform RTC device (no PNP device found)
Apr 30 00:19:35 web kernel: microcode: CPU0: patch_level=0x010000c4
Apr 30 00:19:35 web kernel: microcode: CPU1: patch_level=0x010000c4
Apr 30 00:19:35 web kernel: microcode: CPU2: patch_level=0x010000c4
Apr 30 00:19:35 web kernel: microcode: CPU3: patch_level=0x010000c4
Apr 30 00:19:35 web kernel: microcode: CPU4: patch_level=0x010000c4
Apr 30 00:19:35 web kernel: microcode: CPU5: patch_level=0x010000c4
Apr 30 00:19:35 web kernel: microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Apr 30 00:19:35 web kernel: sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
Apr 30 00:19:35 web kernel: audit: initializing netlink socket (disabled)
Apr 30 00:19:35 web kernel: type=2000 audit(1335737960.553:1): initialized
Apr 30 00:19:35 web kernel: HugeTLB registered 2 MB page size, pre-allocated 0 pages
Apr 30 00:19:35 web kernel: VFS: Disk quotas dquot_6.5.2
Apr 30 00:19:35 web kernel: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Apr 30 00:19:35 web kernel: msgmni has been set to 3785
Apr 30 00:19:35 web kernel: io scheduler noop registered
Apr 30 00:19:35 web kernel: io scheduler deadline registered
Apr 30 00:19:35 web kernel: io scheduler cfq registered (default)
Apr 30 00:19:35 web kernel: Event-channel device installed.
Apr 30 00:19:35 web kernel: frontswap enabled, RAM provided by Xen Transcendent Memory
Apr 30 00:19:35 web kernel: cleancache enabled, RAM provided by Xen Transcendent Memory
Apr 30 00:19:35 web kernel: Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
Apr 30 00:19:35 web kernel: brd: module loaded
Apr 30 00:19:35 web kernel: blkfront: xvda: flush diskcache: enabled
Apr 30 00:19:35 web kernel: Initialising Xen virtual ethernet driver.
Apr 30 00:19:35 web kernel:  xvda: unknown partition table
Apr 30 00:19:35 web kernel: blkfront: xvdb: flush diskcache: enabled
Apr 30 00:19:35 web kernel:  xvdb: unknown partition table
Apr 30 00:19:35 web kernel: Setting capacity to 8388608
Apr 30 00:19:35 web kernel: xvdb: detected capacity change from 0 to 4294967296
Apr 30 00:19:35 web kernel: blkfront: xvde: flush diskcache: enabled
Apr 30 00:19:35 web kernel:  xvde: unknown partition table
Apr 30 00:19:35 web kernel: Setting capacity to 9856614400
Apr 30 00:19:35 web kernel: xvde: detected capacity change from 0 to 5046586572800
Apr 30 00:19:35 web kernel: i8042: No controller found
Apr 30 00:19:35 web kernel: mousedev: PS/2 mouse device common for all mice
Apr 30 00:19:35 web kernel: md: linear personality registered for level -1
Apr 30 00:19:35 web kernel: md: raid0 personality registered for level 0
Apr 30 00:19:35 web kernel: md: raid1 personality registered for level 1
Apr 30 00:19:35 web kernel: md: raid10 personality registered for level 10
Apr 30 00:19:35 web kernel: md: multipath personality registered for level -4
Apr 30 00:19:35 web kernel: device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
Apr 30 00:19:35 web kernel: IPv4 over IPv4 tunneling driver
Apr 30 00:19:35 web kernel: TCP: cubic registered
Apr 30 00:19:35 web kernel: Initializing XFRM netlink socket
Apr 30 00:19:35 web kernel: NET: Registered protocol family 10
Apr 30 00:19:35 web kernel: IPv6 over IPv4 tunneling driver
Apr 30 00:19:35 web kernel: NET: Registered protocol family 17
Apr 30 00:19:35 web kernel: NET: Registered protocol family 15
Apr 30 00:19:35 web kernel: Registering the dns_resolver key type
Apr 30 00:19:35 web kernel: BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
Apr 30 00:19:35 web kernel: EDD information not available.
Apr 30 00:19:35 web kernel: Freeing unused kernel memory: 2032k freed
Apr 30 00:19:35 web kernel: Write protecting the kernel read-only data: 8192k
Apr 30 00:19:35 web kernel: Freeing unused kernel memory: 1872k freed
Apr 30 00:19:35 web kernel: Freeing unused kernel memory: 832k freed
Apr 30 00:19:35 web kernel: PM: Starting manual resume from disk
Apr 30 00:19:35 web kernel: kjournald starting.  Commit interval 5 seconds
Apr 30 00:19:35 web kernel: EXT3-fs (dm-0): using internal journal
Apr 30 00:19:35 web kernel: EXT3-fs (dm-0): mounted filesystem with ordered data mode
Apr 30 00:19:35 web kernel: udevd (1070): /proc/1070/oom_adj is deprecated, please use /proc/1070/oom_score_adj instead.
Apr 30 00:19:35 web kernel: Adding 4194300k swap on /dev/xvdb.  Priority:-1 extents:1 across:4194300k SSFS
Apr 30 00:19:35 web kernel: EXT3-fs (dm-0): using internal journal
Apr 30 00:19:35 web kernel: OCFS2 Node Manager 1.5.0
Apr 30 00:19:35 web kernel: OCFS2 DLM 1.5.0
Apr 30 00:19:35 web kernel: ocfs2: Registered cluster interface o2cb
Apr 30 00:19:35 web kernel: OCFS2 DLMFS 1.5.0
Apr 30 00:19:35 web kernel: OCFS2 User DLM kernel interface loaded
Apr 30 00:19:35 web kernel: warning: `rpc.statd' uses 32-bit capabilities (legacy support in use)
Apr 30 00:19:35 web kernel: o2net: Connected to node adm (num 2) at 192.168.101.101:7778
Apr 30 00:19:35 web kernel: o2net: Connected to node app (num 3) at 192.168.101.105:7778
Apr 30 00:19:35 web kernel: o2net: Accepted connection from node web-xxxxx (num 7) at 192.168.101.106:7778
Apr 30 00:19:35 web kernel: o2net: Accepted connection from node web5 (num 5) at 192.168.101.110:7778
Apr 30 00:19:35 web kernel: o2net: Accepted connection from node web-php5 (num 6) at 192.168.101.111:7778
Apr 30 00:19:35 web kernel: OCFS2 1.5.0
Apr 30 00:19:35 web kernel: o2dlm: Joining domain 94B06879B4C442399BFFD9BA45B4D52F ( 2 3 4 5 6 7 ) 6 nodes
Apr 30 00:19:35 web kernel: ocfs2: Mounting device (202,64) on (node 4, slot 3) with writeback data mode.
Apr 30 00:19:35 web kernel: eth0: no IPv6 routers present
Apr 30 00:19:35 web kernel: eth1: no IPv6 routers present
Apr 30 00:19:35 web kernel: eth2: no IPv6 routers present
Apr 30 04:55:54 web kernel: BUG: unable to handle kernel paging request at ffff880064de9000
Apr 30 04:55:54 web kernel: IP: [<ffffffff8113c38b>] link_path_walk+0xab/0x890
Apr 30 04:55:54 web kernel: PGD 180c067 PUD 9e5067 PMD b0c067 PTE 0
Apr 30 04:55:54 web kernel: Oops: 0000 [#1] PREEMPT SMP 
Apr 30 04:55:54 web kernel: CPU 0 
Apr 30 04:55:54 web kernel: Modules linked in: autofs4 ocfs2 jbd2 ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue configfs
Apr 30 04:55:54 web kernel: 
Apr 30 04:55:54 web kernel: Pid: 23654, comm: apache2 Not tainted 3.4.0-js1 #1  
Apr 30 04:55:54 web kernel: RIP: e030:[<ffffffff8113c38b>]  [<ffffffff8113c38b>] link_path_walk+0xab/0x890
Apr 30 04:55:54 web kernel: RSP: e02b:ffff8800582b9c78  EFLAGS: 00010257
Apr 30 04:55:54 web kernel: RAX: 0000000000000000 RBX: ffff8800582b9e68 RCX: 0000000000000000
Apr 30 04:55:54 web kernel: RDX: 0000000000000000 RSI: 0000000000001a18 RDI: 8080808080808080
Apr 30 04:55:54 web kernel: RBP: ffff880064de8ffb R08: fefefefefefefeff R09: 2f2f2f2f2f2f2f2f
Apr 30 04:55:54 web kernel: R10: 0000000000000000 R11: 0000000000000000 R12: ffff88007246db78
Apr 30 04:55:54 web kernel: R13: ffff8800d599e000 R14: 0000000000000000 R15: ffff8800d599e000
Apr 30 04:55:54 web kernel: FS:  00007fdb37a6c6d0(0000) GS:ffff88007ff0c000(0000) knlGS:0000000000000000
Apr 30 04:55:54 web kernel: CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
Apr 30 04:55:54 web kernel: CR2: ffff880064de9000 CR3: 0000000066be7000 CR4: 0000000000000660
Apr 30 04:55:54 web kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Apr 30 04:55:54 web kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Apr 30 04:55:54 web kernel: Process apache2 (pid: 23654, threadinfo ffff8800582b8000, task ffff8800d599e000)
Apr 30 04:55:54 web kernel: Stack:
Apr 30 04:55:54 web kernel:  0000000000008050 ffffffff8112538c 0000000000000020 ffffffffa014f7d5
Apr 30 04:55:54 web kernel:  ffff8800582b9cf0 ffff8800d599e000 ffff8800582b9e68 ffff8800754c5220
Apr 30 04:55:54 web kernel:  ffff88001835d3c0 000000066573e6d5 ffff880064de8ff4 ffffffffa014f808
Apr 30 04:55:54 web kernel: Call Trace:
Apr 30 04:55:54 web kernel:  [<ffffffff8112538c>] ? __kmalloc+0x17c/0x1e0
Apr 30 04:55:54 web kernel:  [<ffffffffa014f7d5>] ? ocfs2_fast_follow_link+0x95/0x320 [ocfs2]
Apr 30 04:55:54 web kernel:  [<ffffffffa014f808>] ? ocfs2_fast_follow_link+0xc8/0x320 [ocfs2]
Apr 30 04:55:54 web kernel:  [<ffffffff8113c760>] ? link_path_walk+0x480/0x890
Apr 30 04:55:54 web kernel:  [<ffffffff8113e7fe>] ? path_openat+0xbe/0x3f0
Apr 30 04:55:54 web kernel:  [<ffffffffa00e1617>] ? ocfs2_lock_res_free+0x77/0x730 [ocfs2]
Apr 30 04:55:54 web kernel:  [<ffffffff8113ec55>] ? do_filp_open+0x45/0xb0
Apr 30 04:55:54 web kernel:  [<ffffffff8114a98b>] ? alloc_fd+0xcb/0x110
Apr 30 04:55:54 web kernel:  [<ffffffff8112f0e6>] ? do_sys_open+0xf6/0x1d0
Apr 30 04:55:54 web kernel:  [<ffffffff814241b9>] ? system_call_fastpath+0x16/0x1b
Apr 30 04:55:54 web kernel: Code: 49 b9 2f 2f 2f 2f 2f 2f 2f 2f 49 b8 ff fe fe fe fe fe fe fe 48 bf 80 80 80 80 80 80 80 80 66 90 4c 01 d0 48 83 c1 08 4c 8d 14 c0 <48> 8b 44 0d 00 48 89 c6 4e 8d 24 00 4c 31 ce 4a 8d 14 06 48 f7 
Apr 30 04:55:54 web kernel: RIP  [<ffffffff8113c38b>] link_path_walk+0xab/0x890
Apr 30 04:55:54 web kernel:  RSP <ffff8800582b9c78>
Apr 30 04:55:54 web kernel: CR2: ffff880064de9000
Apr 30 04:55:54 web kernel: ---[ end trace a05958e307359332 ]---
Apr 30 08:21:08 web kernel: BUG: unable to handle kernel paging request at ffff88008db0e000
Apr 30 08:21:08 web kernel: IP: [<ffffffff8113c38b>] link_path_walk+0xab/0x890
Apr 30 08:21:08 web kernel: PGD 180c067 PUD be6067 PMD c54067 PTE 0
Apr 30 08:21:08 web kernel: Oops: 0000 [#2] PREEMPT SMP 
Apr 30 08:21:08 web kernel: CPU 0 
Apr 30 08:21:08 web kernel: Modules linked in: autofs4 ocfs2 jbd2 ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue configfs
Apr 30 08:21:08 web kernel: 
Apr 30 08:21:08 web kernel: Pid: 17151, comm: apache2 Tainted: G      D      3.4.0-js1 #1  
Apr 30 08:21:08 web kernel: RIP: e030:[<ffffffff8113c38b>]  [<ffffffff8113c38b>] link_path_walk+0xab/0x890
Apr 30 08:21:08 web kernel: RSP: e02b:ffff880004737bc8  EFLAGS: 00010257
Apr 30 08:21:08 web kernel: RAX: 0000000000000000 RBX: ffff880004737e08 RCX: 0000000000000000
Apr 30 08:21:08 web kernel: RDX: 0000000000000000 RSI: 000000000000a4a2 RDI: 8080808080808080
Apr 30 08:21:08 web kernel: RBP: ffff88008db0dffc R08: fefefefefefefeff R09: 2f2f2f2f2f2f2f2f
Apr 30 08:21:08 web kernel: R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800047ca178
Apr 30 08:21:08 web kernel: R13: ffff880017b10600 R14: 0000000000000000 R15: ffff880017b10600
Apr 30 08:21:08 web kernel: FS:  00007f7eadb206d0(0000) GS:ffff88007ff0c000(0000) knlGS:0000000000000000
Apr 30 08:21:08 web kernel: CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
Apr 30 08:21:08 web kernel: CR2: ffff88008db0e000 CR3: 000000003dbcd000 CR4: 0000000000000660
Apr 30 08:21:08 web kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Apr 30 08:21:08 web kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Apr 30 08:21:08 web kernel: Process apache2 (pid: 17151, threadinfo ffff880004736000, task ffff880017b10600)
Apr 30 08:21:08 web kernel: Stack:
Apr 30 08:21:08 web kernel:  ffff880017b10600 ffffffff8112538c 0000000000000020 ffffffffa014f7d5
Apr 30 08:21:08 web kernel:  ffff880004737c40 ffff880017b10600 ffff880004737e08 ffff8800754c5220
Apr 30 08:21:08 web kernel:  ffff880073e77000 000000066573e6d5 ffff88008db0dff5 ffffffffa014f808
Apr 30 08:21:08 web kernel: Call Trace:
Apr 30 08:21:08 web kernel:  [<ffffffff8112538c>] ? __kmalloc+0x17c/0x1e0
Apr 30 08:21:08 web kernel:  [<ffffffffa014f7d5>] ? ocfs2_fast_follow_link+0x95/0x320 [ocfs2]
Apr 30 08:21:08 web kernel:  [<ffffffffa014f808>] ? ocfs2_fast_follow_link+0xc8/0x320 [ocfs2]
Apr 30 08:21:08 web kernel:  [<ffffffff8113c760>] ? link_path_walk+0x480/0x890
Apr 30 08:21:08 web kernel:  [<ffffffff8113ccd2>] ? path_lookupat+0x52/0x740
Apr 30 08:21:08 web kernel:  [<ffffffff8100b4dd>] ? xen_clocksource_read+0x3d/0x70
Apr 30 08:21:08 web kernel:  [<ffffffff810876ea>] ? getnstimeofday+0x4a/0xc0
Apr 30 08:21:08 web kernel:  [<ffffffff8113d3ec>] ? do_path_lookup+0x2c/0xc0
Apr 30 08:21:08 web kernel:  [<ffffffff8113a9fd>] ? getname_flags+0xed/0x260
Apr 30 08:21:08 web kernel:  [<ffffffff8113ebae>] ? user_path_at_empty+0x5e/0xb0
Apr 30 08:21:08 web kernel:  [<ffffffff814162c7>] ? __bad_area_nosemaphore+0x8e/0x1fd
Apr 30 08:21:08 web kernel:  [<ffffffff81420ab2>] ? do_page_fault+0x492/0x540
Apr 30 08:21:08 web kernel:  [<ffffffff81134482>] ? vfs_fstatat+0x32/0x60
Apr 30 08:21:08 web kernel:  [<ffffffff811345f2>] ? sys_newstat+0x12/0x30
Apr 30 08:21:08 web kernel:  [<ffffffff8112fdee>] ? vfs_read+0x11e/0x150
Apr 30 08:21:08 web kernel:  [<ffffffff8141db25>] ? page_fault+0x25/0x30
Apr 30 08:21:08 web kernel:  [<ffffffff814241b9>] ? system_call_fastpath+0x16/0x1b
Apr 30 08:21:08 web kernel: Code: 49 b9 2f 2f 2f 2f 2f 2f 2f 2f 49 b8 ff fe fe fe fe fe fe fe 48 bf 80 80 80 80 80 80 80 80 66 90 4c 01 d0 48 83 c1 08 4c 8d 14 c0 <48> 8b 44 0d 00 48 89 c6 4e 8d 24 00 4c 31 ce 4a 8d 14 06 48 f7 
Apr 30 08:21:08 web kernel: RIP  [<ffffffff8113c38b>] link_path_walk+0xab/0x890
Apr 30 08:21:08 web kernel:  RSP <ffff880004737bc8>
Apr 30 08:21:08 web kernel: CR2: ffff88008db0e000
Apr 30 08:21:08 web kernel: ---[ end trace a05958e307359333 ]---
Apr 30 08:23:59 web kernel: BUG: unable to handle kernel paging request at ffff8800b5244000
Apr 30 08:23:59 web kernel: IP: [<ffffffff8113c38b>] link_path_walk+0xab/0x890
Apr 30 08:23:59 web kernel: PGD 180c067 PUD be6067 PMD d90067 PTE 0
Apr 30 08:23:59 web kernel: Oops: 0000 [#3] PREEMPT SMP 
Apr 30 08:23:59 web kernel: CPU 0 
Apr 30 08:23:59 web kernel: Modules linked in: autofs4 ocfs2 jbd2 ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue configfs
Apr 30 08:23:59 web kernel: 
Apr 30 08:23:59 web kernel: Pid: 18840, comm: apache2 Tainted: G      D      3.4.0-js1 #1  
Apr 30 08:23:59 web kernel: RIP: e030:[<ffffffff8113c38b>]  [<ffffffff8113c38b>] link_path_walk+0xab/0x890
Apr 30 08:23:59 web kernel: RSP: e02b:ffff8800aaba7c28  EFLAGS: 00010257
Apr 30 08:23:59 web kernel: RAX: 0000000000000000 RBX: ffff8800aaba7e68 RCX: 0000000000000000
Apr 30 08:23:59 web kernel: RDX: 0000000000000000 RSI: 000000000000aeac RDI: 8080808080808080
Apr 30 08:23:59 web kernel: RBP: ffff8800b5243ffb R08: fefefefefefefeff R09: 2f2f2f2f2f2f2f2f
Apr 30 08:23:59 web kernel: R10: 0000000000000000 R11: 0000000000000000 R12: ffff88007246db78
Apr 30 08:23:59 web kernel: R13: ffff880074cc6000 R14: 0000000000000000 R15: ffff880074cc6000
Apr 30 08:23:59 web kernel: FS:  00007f7eadb206d0(0000) GS:ffff88007ff0c000(0000) knlGS:0000000000000000
Apr 30 08:23:59 web kernel: CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
Apr 30 08:23:59 web kernel: CR2: ffff8800b5244000 CR3: 00000000aab8a000 CR4: 0000000000000660
Apr 30 08:23:59 web kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Apr 30 08:23:59 web kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Apr 30 08:23:59 web kernel: Process apache2 (pid: 18840, threadinfo ffff8800aaba6000, task ffff880074cc6000)
Apr 30 08:23:59 web kernel: Stack:
Apr 30 08:23:59 web kernel:  0000000000008050 ffffffff8112538c 0000000000000020 ffffffffa014f7d5
Apr 30 08:23:59 web kernel:  ffff8800aaba7ca0 ffff880074cc6000 ffff8800aaba7e68 ffff8800754c5220
Apr 30 08:23:59 web kernel:  ffff88001835d3c0 000000066573e6d5 ffff8800b5243ff4 ffffffffa014f808
Apr 30 08:23:59 web kernel: Call Trace:
Apr 30 08:23:59 web kernel:  [<ffffffff8112538c>] ? __kmalloc+0x17c/0x1e0
Apr 30 08:23:59 web kernel:  [<ffffffffa014f7d5>] ? ocfs2_fast_follow_link+0x95/0x320 [ocfs2]
Apr 30 08:23:59 web kernel:  [<ffffffffa014f808>] ? ocfs2_fast_follow_link+0xc8/0x320 [ocfs2]
Apr 30 08:23:59 web kernel:  [<ffffffff8113c760>] ? link_path_walk+0x480/0x890
Apr 30 08:23:59 web kernel:  [<ffffffff81036c52>] ? pvclock_clocksource_read+0x52/0xf0
Apr 30 08:23:59 web kernel:  [<ffffffff8113ccd2>] ? path_lookupat+0x52/0x740
Apr 30 08:23:59 web kernel:  [<ffffffff8104bad1>] ? sys_gettimeofday+0x31/0x80
Apr 30 08:23:59 web kernel:  [<ffffffff8101a2eb>] ? emulate_vsyscall+0x31b/0x350
Apr 30 08:23:59 web kernel:  [<ffffffff8113d3ec>] ? do_path_lookup+0x2c/0xc0
Apr 30 08:23:59 web kernel:  [<ffffffff8113a9fd>] ? getname_flags+0xed/0x260
Apr 30 08:23:59 web kernel:  [<ffffffff8113ebae>] ? user_path_at_empty+0x5e/0xb0
Apr 30 08:23:59 web kernel:  [<ffffffff8104c912>] ? local_bh_enable_ip+0x22/0xb0
Apr 30 08:23:59 web kernel:  [<ffffffff81325e9b>] ? sock_setsockopt+0x8b/0x870
Apr 30 08:23:59 web kernel:  [<ffffffff8112e961>] ? sys_faccessat+0xa1/0x1c0
Apr 30 08:23:59 web kernel:  [<ffffffff814241b9>] ? system_call_fastpath+0x16/0x1b
Apr 30 08:23:59 web kernel: Code: 49 b9 2f 2f 2f 2f 2f 2f 2f 2f 49 b8 ff fe fe fe fe fe fe fe 48 bf 80 80 80 80 80 80 80 80 66 90 4c 01 d0 48 83 c1 08 4c 8d 14 c0 <48> 8b 44 0d 00 48 89 c6 4e 8d 24 00 4c 31 ce 4a 8d 14 06 48 f7 
Apr 30 08:23:59 web kernel: RIP  [<ffffffff8113c38b>] link_path_walk+0xab/0x890
Apr 30 08:23:59 web kernel:  RSP <ffff8800aaba7c28>
Apr 30 08:23:59 web kernel: CR2: ffff8800b5244000
Apr 30 08:23:59 web kernel: ---[ end trace a05958e307359334 ]---


