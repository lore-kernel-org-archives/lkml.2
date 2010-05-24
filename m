Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758481Ab0EXWyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 18:54:04 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:39644 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab0EXWyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 18:54:00 -0400
X-Greylist: delayed 2963 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 May 2010 18:53:59 EDT
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+3aIibppu0283ogF9SEP3jBxhhKcbMg==
X-RZG-CLASS-ID: mo00
Date: Tue, 25 May 2010 00:53:57 +0200
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org
Subject: acquire_console_mutex: WARNING: at
 2.6.33.4-rt20/kernel/mutex-debug.c:65 mutex_remove_waiter+0xe8/0x11c()
Message-ID: <20100524225357.GA19513@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I get this warning when busybox /sbin/init opens the console.
It does not happen when CONFIG_PREEMPT_RT is enabled.
Any ideas how to fix it for CONFIG_PREEMPT_DESKTOP?

[   16.450000] ------------[ cut here ]------------
[   16.450000] WARNING: at /work/rt/linux-2.6.33-rt/kernel/mutex-debug.c:65 mutex_remove_waiter+0xe8/0x11c()
[   16.450000] Modules linked in:
[   16.450000] [<c0033e68>] (unwind_backtrace+0x0/0xdc) from [<c0324994>] (dump_stack+0x18/0x1c)
[   16.450000] [<c0324994>] (dump_stack+0x18/0x1c) from [<c0049aec>] (warn_slowpath_common+0x50/0x68)
[   16.450000] [<c0049aec>] (warn_slowpath_common+0x50/0x68) from [<c0049b1c>] (warn_slowpath_null+0x18/0x1c)
[   16.450000] [<c0049b1c>] (warn_slowpath_null+0x18/0x1c) from [<c006d640>] (mutex_remove_waiter+0xe8/0x11c)
[   16.450000] [<c006d640>] (mutex_remove_waiter+0xe8/0x11c) from [<c032709c>] (mutex_lock_nested+0x268/0x304)
[   16.450000] [<c032709c>] (mutex_lock_nested+0x268/0x304) from [<c004a2d8>] (acquire_console_mutex+0x40/0x68)
[   16.450000] [<c004a2d8>] (acquire_console_mutex+0x40/0x68) from [<c01d8420>] (con_open+0x18/0xc4)
[   16.450000] [<c01d8420>] (con_open+0x18/0xc4) from [<c01c80dc>] (tty_open+0x398/0x55c)
[   16.450000] [<c01c80dc>] (tty_open+0x398/0x55c) from [<c00ae628>] (chrdev_open+0x198/0x1bc)
[   16.450000] [<c00ae628>] (chrdev_open+0x198/0x1bc) from [<c00a9928>] (__dentry_open+0x188/0x294)
[   16.450000] [<c00a9928>] (__dentry_open+0x188/0x294) from [<c00a9b04>] (nameidata_to_filp+0x48/0x60)
[   16.450000] [<c00a9b04>] (nameidata_to_filp+0x48/0x60) from [<c00b795c>] (do_filp_open+0x42c/0x8a8)
[   16.450000] [<c00b795c>] (do_filp_open+0x42c/0x8a8) from [<c00a968c>] (do_sys_open+0x64/0x11c)
[   16.450000] [<c00a968c>] (do_sys_open+0x64/0x11c) from [<c00a977c>] (sys_open+0x24/0x28)
[   16.450000] [<c00a977c>] (sys_open+0x24/0x28) from [<c002e000>] (ret_fast_syscall+0x0/0x34)
[   16.450000] ---[ end trace cdbe849ecfa1acdf ]---

The used config is shown after dmesg.


[    0.000000] Linux version 2.6.33.4-rt20-arm9-at91sam9263ek (olaf@esprimo) (gcc version 4.4.4 (GCC) ) #13 PREEMPT Mon May 24 23:06:36 CEST 2010
[    0.000000] CPU: ARM926EJ-S [41069265] revision 5 (ARMv5TEJ), cr=00053177
[    0.000000] CPU: VIVT data cache, VIVT instruction cache
[    0.000000] Machine: Atmel AT91SAM9263-EK
[    0.000000] Ignoring unrecognised tag 0x54410008
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] On node 0 totalpages: 16384
[    0.000000] free_area_init_node: node 0, pgdat c049351c, node_mem_map c0ba6000
[    0.000000]   Normal zone: 128 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 16256 pages, LIFO batch:3
[    0.000000] Clocks: CPU 199 MHz, master 99 MHz, main 16.367 MHz
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 16256
[    0.000000] Kernel command line: console=ttyS0 root=/dev/nfs nfsroot=192.168.2.100:/opt/cross/sys-root/arm-linux-gnueabi,tcp rw debug ip=dhcp panic=3
[    0.000000] PID hash table entries: 256 (order: -2, 1024 bytes)
[    0.000000] Dentry cache hash table entries: 8192 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 4096 (order: 5, 131072 bytes)
[    0.000000] Memory: 64MB = 64MB total
[    0.000000] Memory: 52636KB available (4044K code, 7435K data, 148K init, 0K highmem)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:192
[    0.000000] AT91: 160 gpio irqs in 5 banks
[    0.000000] Console: colour dummy device 80x30
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3695 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.190000] Calibrating delay loop... 98.91 BogoMIPS (lpj=494592)
[    0.400000] Mount-cache hash table entries: 512
[    0.430000] CPU: Testing write buffer coherency: ok
[    0.490000] khelper used greatest stack depth: 6464 bytes left
[    0.490000] khelper used greatest stack depth: 5936 bytes left
[    0.540000] NET: Registered protocol family 16
[    0.640000] tcb_clksrc: tc0 at 12.994 MHz
[    0.820000] bio: create slab <bio-0> at 0
[    0.840000] SCSI subsystem initialized
[    0.860000] usbcore: registered new interface driver usbfs
[    0.870000] usbcore: registered new interface driver hub
[    0.880000] usbcore: registered new device driver usb
[    0.910000] Switching to clocksource tcb_clksrc
[    0.940000] NET: Registered protocol family 2
[    0.950000] IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.960000] TCP established hash table entries: 2048 (order: 2, 16384 bytes)
[    0.970000] TCP bind hash table entries: 2048 (order: 4, 65536 bytes)
[    0.990000] TCP: Hash tables configured (established 2048 bind 2048)
[    0.990000] TCP reno registered
[    1.000000] UDP hash table entries: 64 (order: 0, 5120 bytes)
[    1.000000] UDP-Lite hash table entries: 64 (order: 0, 5120 bytes)
[    1.020000] NET: Registered protocol family 1
[    1.030000] RPC: Registered udp transport module.
[    1.030000] RPC: Registered tcp transport module.
[    1.040000] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.050000] NetWinder Floating Point Emulator V0.97 (double precision)
[    1.090000] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    1.120000] Slow work thread pool: Starting up
[    1.120000] Slow work thread pool: Ready
[    1.130000] JFFS2 version 2.2. (NAND) © 2001-2006 Red Hat, Inc.
[    1.140000] msgmni has been set to 102
[    1.150000] io scheduler noop registered (default)
[    1.160000] atmel_lcdfb atmel_lcdfb.0: backlight control is not available
[    1.170000] atmel_lcdfb atmel_lcdfb.0: 150KiB frame buffer at 23a00000 (mapped at ffc00000)
[    1.270000] Console: switching to colour frame buffer device 30x40
[    1.280000] atmel_lcdfb atmel_lcdfb.0: fb0: Atmel LCDC at 0x00700000 (mapped at c4876000), irq 26
[    1.490000] atmel_usart.0: ttyS0 at MMIO 0xfeffee00 (irq = 1) is a ATMEL_SERIAL
[    1.510000] atmel_usart.1: ttyS1 at MMIO 0xfff8c000 (irq = 7) is a ATMEL_SERIAL
[    1.650000] brd: module loaded
[    1.690000] khelper used greatest stack depth: 5864 bytes left
[    1.720000] loop: module loaded
[    1.770000] NAND device: Manufacturer ID: 0x2c, Chip ID: 0xda (Micron NAND 256MiB 3,3V 8-bit)
[    1.780000] Scanning device for bad blocks
[    1.810000] Bad eraseblock 301 at 0x0000025a0000
[    1.820000] Bad eraseblock 514 at 0x000004040000
[    1.870000] Bad eraseblock 1180 at 0x000009380000
[    1.870000] Bad eraseblock 1193 at 0x000009520000
[    1.890000] Bad eraseblock 1365 at 0x00000aaa0000
[    1.930000] Creating 2 MTD partitions on "atmel_nand":
[    1.940000] 0x000000000000-0x000004000000 : "Partition 1"
[    1.970000] 0x000004000000-0x000010000000 : "Partition 2"
[    1.990000] atmel_spi atmel_spi.0: Atmel SPI Controller at 0xfffa4000 (irq 14)
[    2.030000] CAN device driver interface
[    2.050000] MACB_mii_bus: probed
[    2.060000] eth0: Atmel MACB at 0xfffbc000 irq 21 (3a:1f:34:08:54:54)
[    2.060000] eth0: attached PHY driver [Generic PHY] (mii_bus:phy_addr=ffffffff:00, irq=-1)
[    2.080000] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.090000] at91_ohci at91_ohci: AT91 OHCI
[    2.120000] at91_ohci at91_ohci: new USB bus registered, assigned bus number 1
[    2.130000] at91_ohci at91_ohci: irq 29, io mem 0x00a00000
[    2.200000] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    2.210000] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.220000] usb usb1: Product: AT91 OHCI
[    2.220000] usb usb1: Manufacturer: Linux 2.6.33.4-rt20-arm9-at91sam9263ek ohci_hcd
[    2.230000] usb usb1: SerialNumber: at91
[    2.260000] hub 1-0:1.0: USB hub found
[    2.260000] hub 1-0:1.0: 2 ports detected
[    2.280000] Initializing USB Mass Storage driver...
[    2.290000] usbcore: registered new interface driver usb-storage
[    2.300000] USB Mass Storage support registered.
[    2.300000] usbcore: registered new interface driver ums-alauda
[    2.310000] usbcore: registered new interface driver ums-cypress
[    2.320000] usbcore: registered new interface driver ums-datafab
[    2.330000] usbcore: registered new interface driver ums-freecom
[    2.340000] usbcore: registered new interface driver ums-isd200
[    2.350000] usbcore: registered new interface driver ums-jumpshot
[    2.360000] usbcore: registered new interface driver ums-karma
[    2.360000] usbcore: registered new interface driver ums-onetouch
[    2.380000] usbcore: registered new interface driver ums-sddr09
[    2.390000] usbcore: registered new interface driver ums-sddr55
[    2.390000] usbcore: registered new interface driver ums-usbat
[    2.400000] udc: at91_udc version 3 May 2006
[    2.410000] mice: PS/2 mouse device common for all mice
[    2.420000] input: gpio-keys as /devices/platform/gpio-keys/input/input0
[    2.440000] ads7846 spi0.3: external vREF for ADS7843 not specified
[    2.450000] ads7846 spi0.3: touchscreen, irq 31
[    2.460000] input: ADS7843 Touchscreen as /devices/platform/atmel_spi.0/spi0.3/input/input1
[    2.490000] rtc-at91sam9 at91_rtt.0: rtc core: registered at91_rtt as rtc0
[    2.490000] IRQ 1/rtc0: IRQF_DISABLED is not guaranteed on shared IRQs
[    2.500000] rtc-at91sam9 at91_rtt.0: rtc0: SET TIME!
[    2.510000] i2c /dev entries driver
[    2.530000] at24 0-0050: 65536 byte 24c512 EEPROM (writable)
[    2.550000] i2c-gpio i2c-gpio: using pins 68 (SDA) and 69 (SCL)
[    2.560000] AT91SAM9 Watchdog: sorry, watchdog is disabled
[    2.570000] at91_wdt: probe of at91_wdt failed with error -5
[    2.650000] usbcore: registered new interface driver hiddev
[    2.660000] usbcore: registered new interface driver usbhid
[    2.670000] usbhid: USB HID core driver
[    2.670000] TCP cubic registered
[    2.680000] NET: Registered protocol family 10
[    2.690000] lo: Disabled Privacy Extensions
[    2.700000] IPv6 over IPv4 tunneling driver
[    2.710000] sit0: Disabled Privacy Extensions
[    2.720000] NET: Registered protocol family 17
[    2.730000] can: controller area network core (rev 20090105 abi 8)
[    2.730000] NET: Registered protocol family 29
[    2.740000] can: raw protocol (rev 20090105)
[    2.740000] can: broadcast manager protocol (rev 20090105 t)
[    2.760000] rtc-at91sam9 at91_rtt.0: hctosys: unable to read the hardware clock
[    4.310000] Sending DHCP requests .
[    5.060000] eth0: link up (100/Full)
[    6.500000] ., OK
[    6.520000] IP-Config: Got DHCP answer from 192.168.2.100, my address is 192.168.2.42
[    6.530000] IP-Config: Complete:
[    6.530000]      device=eth0, addr=192.168.2.42, mask=255.255.255.0, gw=192.168.2.100,
[    6.540000]      host=at91sam9263ek, domain=easybox, nis-domain=(none),
[    6.550000]      bootserver=192.168.2.100, rootserver=192.168.2.100, rootpath=
[    6.560000] Looking up port of RPC 100003/2 on 192.168.2.100
[    6.610000] Looking up port of RPC 100005/1 on 192.168.2.100
[    6.980000] VFS: Mounted root (nfs filesystem) on device 0:14.
[    6.980000] *****************************************************************************
[    6.990000] *                                                                           *
[    7.000000] *  REMINDER, the following debugging options are turned on in your .config: *
[    7.010000] *                                                                           *
[    7.020000] *        CONFIG_DEBUG_RT_MUTEXES                                            *
[    7.030000] *        CONFIG_LOCKDEP                                                     *
[    7.040000] *                                                                           *
[    7.050000] *  they may increase runtime overhead and latencies.                        *
[    7.050000] *                                                                           *
[    7.060000] *****************************************************************************
[    7.070000] Freeing init memory: 148K
[    9.940000] ldconfig used greatest stack depth: 3480 bytes left
[   13.430000] eth0: no IPv6 routers present
[   16.240000] /etc/init.d/rcS done.
[   16.450000] ------------[ cut here ]------------
[   16.450000] WARNING: at /work/rt/linux-2.6.33-rt/kernel/mutex-debug.c:65 mutex_remove_waiter+0xe8/0x11c()
[   16.450000] Modules linked in:
[   16.450000] [<c0033e68>] (unwind_backtrace+0x0/0xdc) from [<c0324994>] (dump_stack+0x18/0x1c)
[   16.450000] [<c0324994>] (dump_stack+0x18/0x1c) from [<c0049aec>] (warn_slowpath_common+0x50/0x68)
[   16.450000] [<c0049aec>] (warn_slowpath_common+0x50/0x68) from [<c0049b1c>] (warn_slowpath_null+0x18/0x1c)
[   16.450000] [<c0049b1c>] (warn_slowpath_null+0x18/0x1c) from [<c006d640>] (mutex_remove_waiter+0xe8/0x11c)
[   16.450000] [<c006d640>] (mutex_remove_waiter+0xe8/0x11c) from [<c032709c>] (mutex_lock_nested+0x268/0x304)
[   16.450000] [<c032709c>] (mutex_lock_nested+0x268/0x304) from [<c004a2d8>] (acquire_console_mutex+0x40/0x68)
[   16.450000] [<c004a2d8>] (acquire_console_mutex+0x40/0x68) from [<c01d8420>] (con_open+0x18/0xc4)
[   16.450000] [<c01d8420>] (con_open+0x18/0xc4) from [<c01c80dc>] (tty_open+0x398/0x55c)
[   16.450000] [<c01c80dc>] (tty_open+0x398/0x55c) from [<c00ae628>] (chrdev_open+0x198/0x1bc)
[   16.450000] [<c00ae628>] (chrdev_open+0x198/0x1bc) from [<c00a9928>] (__dentry_open+0x188/0x294)
[   16.450000] [<c00a9928>] (__dentry_open+0x188/0x294) from [<c00a9b04>] (nameidata_to_filp+0x48/0x60)
[   16.450000] [<c00a9b04>] (nameidata_to_filp+0x48/0x60) from [<c00b795c>] (do_filp_open+0x42c/0x8a8)
[   16.450000] [<c00b795c>] (do_filp_open+0x42c/0x8a8) from [<c00a968c>] (do_sys_open+0x64/0x11c)
[   16.450000] [<c00a968c>] (do_sys_open+0x64/0x11c) from [<c00a977c>] (sys_open+0x24/0x28)
[   16.450000] [<c00a977c>] (sys_open+0x24/0x28) from [<c002e000>] (ret_fast_syscall+0x0/0x34)
[   16.450000] ---[ end trace cdbe849ecfa1acdf ]---


CONFIG_ARM=y
CONFIG_SYS_SUPPORTS_APM_EMULATION=y
CONFIG_GENERIC_GPIO=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_HARDIRQS_SW_RESEND=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_VECTORS_BASE=0xffff0000
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION="-arm9-at91sam9263ek"
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_TREE_RCU=y
CONFIG_RCU_FANOUT=32
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=21
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_LZO=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
CONFIG_HAVE_OPROFILE=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_CLK=y
CONFIG_SLOW_WORK=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_BLOCK=y
CONFIG_IOSCHED_NOOP=y
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_MMU=y
CONFIG_ARCH_AT91=y
CONFIG_HAVE_AT91_DATAFLASH_CARD=y
CONFIG_HAVE_NAND_ATMEL_BUSWIDTH_16=y
CONFIG_ARCH_AT91SAM9263=y
CONFIG_AT91_PMC_UNIT=y
CONFIG_MACH_AT91SAM9263EK=y
CONFIG_MTD_AT91_DATAFLASH_CARD=y
CONFIG_AT91_PROGRAMMABLE_CLOCKS=y
CONFIG_AT91_TIMER_HZ=100
CONFIG_AT91_EARLY_DBGU=y
CONFIG_CPU_ARM926T=y
CONFIG_CPU_32v5=y
CONFIG_CPU_ABRT_EV5TJ=y
CONFIG_CPU_PABRT_LEGACY=y
CONFIG_CPU_CACHE_VIVT=y
CONFIG_CPU_COPY_V4WB=y
CONFIG_CPU_TLB_V4WBI=y
CONFIG_CPU_CP15=y
CONFIG_CPU_CP15_MMU=y
CONFIG_ARM_THUMB=y
CONFIG_ARM_L1_CACHE_SHIFT=5
CONFIG_TICK_ONESHOT=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_VMSPLIT_3G=y
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_PREEMPT_DESKTOP=y
CONFIG_PREEMPT=y
CONFIG_HZ=100
CONFIG_AEABI=y
CONFIG_OABI_COMPAT=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ALIGNMENT_TRAP=y
CONFIG_ZBOOT_ROM_TEXT=0
CONFIG_ZBOOT_ROM_BSS=0
CONFIG_CMDLINE="debug panic=3 console=ttyS0,115200 mem=64M"
CONFIG_FPE_NWFPE=y
CONFIG_BINFMT_ELF=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_MISC=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_NET=y
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_INET=y
CONFIG_IP_FIB_HASH=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_INET_TUNNEL=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
CONFIG_IPV6_SIT=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=y
CONFIG_CAN_VCAN=m
CONFIG_CAN_DEV=y
CONFIG_CAN_CALC_BITTIMING=y
CONFIG_CAN_AT91=m
CONFIG_CAN_MCP251X=m
CONFIG_CAN_SJA1000=m
CONFIG_CAN_SJA1000_PLATFORM=m
CONFIG_CAN_EMS_USB=m
CONFIG_CAN_DEBUG_DEVICES=y
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_MTD=y
CONFIG_MTD_PARTITIONS=y
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_CHAR=y
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
CONFIG_MTD_DATAFLASH=y
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_IDS=y
CONFIG_MTD_NAND_ATMEL=y
CONFIG_MTD_NAND_ATMEL_ECC_HW=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=8192
CONFIG_MISC_DEVICES=y
CONFIG_ATMEL_TCLIB=y
CONFIG_ATMEL_TCB_CLKSRC=y
CONFIG_ATMEL_TCB_CLKSRC_BLOCK=0
CONFIG_ATMEL_TCB_CLKSRC_USE_SLOW_CLOCK=y
CONFIG_ATMEL_SSC=y
CONFIG_EEPROM_AT24=y
CONFIG_HAVE_IDE=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_PROC_FS=y
CONFIG_BLK_DEV_SD=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_WAIT_SCAN=m
CONFIG_SCSI_LOWLEVEL=y
CONFIG_NETDEVICES=y
CONFIG_PHYLIB=y
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_MACB=y
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_CDC_EEM=m
CONFIG_USB_NET_DM9601=m
CONFIG_USB_NET_SMSC95XX=m
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=m
CONFIG_USB_NET_INT51X1=m
CONFIG_INPUT=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_GPIO=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_GPIO=y
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_DEVKMEM=y
CONFIG_SERIAL_ATMEL=y
CONFIG_SERIAL_ATMEL_CONSOLE=y
CONFIG_SERIAL_ATMEL_PDC=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_UNIX98_PTYS=y
CONFIG_HW_RANDOM=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_GPIO=y
CONFIG_SPI=y
CONFIG_SPI_MASTER=y
CONFIG_SPI_ATMEL=y
CONFIG_ARCH_REQUIRE_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_SYSFS=y
CONFIG_HWMON=y
CONFIG_SENSORS_LM75=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_NOWAYOUT=y
CONFIG_AT91SAM9X_WATCHDOG=y
CONFIG_SSB_POSSIBLE=y
CONFIG_HAVE_FB_ATMEL=y
CONFIG_FB=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_ATMEL=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HIDRAW=y
CONFIG_USB_HID=y
CONFIG_USB_HIDDEV=y
CONFIG_HID_A4TECH=y
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
CONFIG_HID_EZKEY=y
CONFIG_HID_KYE=y
CONFIG_HID_GYRATION=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_NTRIG=y
CONFIG_HID_PANTHERLORD=y
CONFIG_HID_PETALYNX=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_HID_ZEROPLUS=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
CONFIG_USB_MON=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_STORAGE=y
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_SELECTED=y
CONFIG_USB_GADGET_AT91=y
CONFIG_USB_AT91=y
CONFIG_USB_ZERO=m
CONFIG_USB_ETH=m
CONFIG_USB_ETH_RNDIS=y
CONFIG_USB_GADGETFS=m
CONFIG_USB_FILE_STORAGE=m
CONFIG_USB_G_SERIAL=m
CONFIG_USB_CDC_COMPOSITE=m
CONFIG_USB_G_MULTI=m
CONFIG_USB_G_MULTI_RNDIS=y
CONFIG_MMC=y
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_MMC_AT91=m
CONFIG_MMC_ATMELMCI=m
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_DRV_AT91SAM9=y
CONFIG_RTC_DRV_AT91SAM9_RTT=0
CONFIG_RTC_DRV_AT91SAM9_GPBR=0
CONFIG_UIO=y
CONFIG_UIO_PDRV=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y
CONFIG_FAT_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_PROC_FS=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
CONFIG_JFFS2_ZLIB=y
CONFIG_JFFS2_RTIME=y
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
CONFIG_ROOT_NFS=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_CIFS=y
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_PARTITION_ADVANCED=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_UTF8=y
CONFIG_PRINTK_TIME=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_DEBUG_PREEMPT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_FRAME_POINTER=y
CONFIG_LATENCYTOP=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_ARM_UNWIND=y
CONFIG_DEBUG_USER=y
CONFIG_DEBUG_ERRORS=y
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_LL=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=m
CONFIG_CRYPTO_ALGAPI2=m
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=m
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_HW=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y
