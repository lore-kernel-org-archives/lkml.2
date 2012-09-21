Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab2IURrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 13:47:36 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:34454 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317Ab2IURrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 13:47:32 -0400
Date: Fri, 21 Sep 2012 17:47:31 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: "Bruce, Becky" <bbruce@ti.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<linux-omap@vger.kernel.org>" <linux-omap@vger.kernel.org>,
        "<linux-arm-kernel@lists.infradead.org>" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hilman, Kevin" <khilman@ti.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Hunter, Jon" <jon-hunter@ti.com>,
        "<snijsure@grid-net.com>" <snijsure@grid-net.com>
Subject: Re: rcu self-detected stall messages on OMAP3, 4 boards
In-Reply-To: <alpine.DEB.2.00.1209202244470.32589@utopia.booyaka.com>
Message-ID: <alpine.DEB.2.00.1209211740170.8839@utopia.booyaka.com>
References: <alpine.DEB.2.00.1209122237080.7275@utopia.booyaka.com> <20120913011208.GT4257@linux.vnet.ibm.com> <alpine.DEB.2.00.1209131839000.23318@utopia.booyaka.com> <20120920000351.GI2455@linux.vnet.ibm.com> <alpine.DEB.2.00.1209200753450.3801@utopia.booyaka.com>
 <F95344A7-3351-4E6B-BF61-37E591AF16A2@ti.com> <20120920220130.GN2449@linux.vnet.ibm.com> <alpine.DEB.2.00.1209202244470.32589@utopia.booyaka.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul

On Thu, 20 Sep 2012, Paul Walmsley wrote:

> On Thu, 20 Sep 2012, Paul E. McKenney wrote:
>
> > Paul Walmsley, please let me know if the config below doesn't clear things
> > up for you or if there is some reason why this config is infeasible.
> 
> Will certainly test it here once things settle down.

I built an OMAP kernel from Linus' commit 
4651afbbae968772efd6dc4ba461cba9b49bb9d8 ("Merge branch 'for-3.6-fixes' of 
git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq").  The config used 
was 'omap2plus_defconfig', and enabled CONFIG_CPU_IDLE by hand.  Booted it 
on a Pandaboard (OMAP4430ES2) into a very minimal Debian rootfs.

Long story short, the rcu_sched stall messages continue to appear.  
Transcript below.

The above config should be easy to reproduce from mainline.  Paul, not 
sure if you're still working with Linaro, but you should be able to get 
access to a Pandaboard through them to try it yourself, should you wish.


- Paul

## Booting kernel from Legacy Image at 82000000 ...                                                   
   Image Name:   Linux-3.6.0-rc6-00025-g4651afb                                                       
   Image Type:   ARM Linux Kernel Image (uncompressed)                                                
   Data Size:    4061576 Bytes = 3.9 MiB                                                              
   Load Address: 80008000                                                                             
   Entry Point:  80008000                                                                             
   Verifying Checksum ... OK                                                                          
   Loading Kernel Image ... OK                                                                        
OK                                                                                                    
                                                                                                      
Starting kernel ...                                                                                   
                                                                                                      
Uncompressing Linux... done, booting the kernel.                                                      
[    0.000000] Booting Linux on physical CPU 0                                                        
[    0.000000] Linux version 3.6.0-rc6-00025-g4651afb (paul@dusk) (gcc version 4.5.1 (Sourcery G++ Lite 2010.09-50) ) #342 SMP Fri Sep 21 11:28:00 MDT 2012                                                                         
[    0.000000] CPU: ARMv7 Processor [411fc092] revision 2 (ARMv7), cr=10c53c7d                        
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache               
[    0.000000] Machine: OMAP4 Panda board                                                             
[    0.000000] debug: ignoring loglevel setting.                                                      
[    0.000000] Reserving 16777216 bytes SDRAM for VRAM                                                
[    0.000000] Memory policy: ECC disabled, Data cache writealloc
[    0.000000] On node 0 totalpages: 126720                                                           
[    0.000000] free_area_init_node: node 0, pgdat c07c6140, node_mem_map c0d23000
[    0.000000]   Normal zone: 1024 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 125696 pages, LIFO batch:31
[    0.000000] OMAP4430 ES2.0
[    0.000000] PERCPU: Embedded 9 pages/cpu @c112b000 s14016 r8192 d14656 u36864
[    0.000000] pcpu-alloc: s14016 r8192 d14656 u36864 alloc=9*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 125696
[    0.000000] Kernel command line: console=ttyO2,230400n8 vram=16M root=/dev/mmcblk0p2 rw rootfstype=ext3 rootwait earlyprintk debug ignore_loglevel
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Memory: 495MB = 495MB total
[    0.000000] Memory: 488828k/488828k available, 35460k reserved, 0K highmem
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xe0800000 - 0xff000000   ( 488 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xe0000000   ( 512 MB)
[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
[    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
[    0.000000]       .text : 0xc0008000 - 0xc06dad24   (6988 kB)
[    0.000000]       .init : 0xc06db000 - 0xc072a6c0   ( 318 kB)
[    0.000000]       .data : 0xc072c000 - 0xc07c8940   ( 627 kB)
[    0.000000]        .bss : 0xc07c8964 - 0xc0d22a4c   (5481 kB)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  Additional per-CPU info printed with stalls.
[    0.000000] NR_IRQS:474
[    0.000000] omap_hwmod: dpll_mpu_m2_ck: missing clockdomain for dpll_mpu_m2_ck.
[    0.000000] OMAP clockevent source: GPTIMER1 at 32768 Hz
[    0.000000] omap_hwmod: sys_32k_ck: missing clockdomain for sys_32k_ck.
[    0.000000] sched_clock: 32 bits at 32kHz, resolution 30517ns, wraps every 131071999ms
[    0.000000] OMAP clocksource: 32k_counter at 32768 Hz
[    0.000000] Console: colour dummy device 80x30
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
[    0.001190] Calibrating delay loop... 2007.19 BogoMIPS (lpj=7839744)
[    0.124725] pid_max: default: 32768 minimum: 301
[    0.125518] Security Framework initialized
[    0.125793] Mount-cache hash table entries: 512
[    0.131286] CPU: Testing write buffer coherency: ok
[    0.132751] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0value (unknown osc rate)
[    0.402343] twl 1-0048: PIH (irq 39) chaining IRQs 352..372
[    0.403930] VUSB: 3300 mV normal standby
[    0.404907] vdd_mpu: 500 <--> 1500 mV normal 
[    0.405792] vdd_iva: 500 <--> 1500 mV normal 
[    0.406890] vdd_core: 500 <--> 1500 mV normal 
[    0.408081] V1V8: 1800 mV normal standby
[    0.408966] V2V1: 2100 mV normal standby
[    0.409973] VMMC: 1200 <--> 3000 mV at 3000 mV normal standby
[    0.411132] VPP: 1800 <--> 2500 mV at 1900 mV normal standby
[    0.412445] VCXIO: 1800 mV normal standby
[    0.412506] VCXIO: supplied by V2V1
[    0.414367] VDAC: 1800 mV normal standby
[    0.414459] VDAC: supplied by V2V1
[    0.415863] VAUX2_6030: 1200 <--> 2800 mV at 1800 mV normal standby
[    0.417053] VAUX3_6030: 1000 <--> 3000 mV at 1200 mV normal standby
[    0.418487] VANA: 2100 mV normal standby
[    0.430084] omap_i2c omap_i2c.2: bus 2 rev2.4.0 at 400 kHz
[    0gistered twl_rtc as rtc0
[    1.241333] i2c /dev entries driver
[    1.245208] Driver for 1-wire Dallas network protocol.
[    1.249908] omap_wdt: OMAP Watchdog Timer Rev 0x00: initial timeout 60 sec
[    1.254272] cpuidle: using governor ladder
[    1.256530] cpuidle: using governor menu
[    1.259948] omap_hsmmc omap_hsmmc.0: Failed to get debounce clk
[    1.263305] omap-dma-engine omap-dma-engine: allocating channel for 62
[    1.266906] omap-dma-engine omap-dma-engine: allocating channel for 61
[    1.317443] omap_hsmmc omap_hsmmc.4: Failed to get debounce clk
[    1.320709] omap-dma-engine omap-dma-engine: allocating channel for 60
[    1.324279] omap-dma-engine omap-dma-engine: allocating channel for 59
[    1.444854] usbcore: registered new interface driver usbhid
[    1.447906] usbhid: USB HID core driver
[    1.450012] oprofile: hardware counters not available
[    1.452789] oprofile: using timer interrupt.
[    1.455657] TCP: cubic registered
[    1.457489] Initializing XFRM netlink socket
[    1.459930] NET: Registered protocol family 17
[    1.462402] NET: Registered protocol family 15
[    1.465057] Key type dns_resolver registered
[    1.467559] VFP support v0.3: implementor 41 architecture 3 part 30 variant 9 rev 1
[    1.476593] omap_vc_i2c_init: I2C config for vdd_iva does not match other channels (0).
[    1.480895] omap_vc_i2c_init: I2C config for vdd_mpu does not match other channels (0).[    1.486236] Power Management for TI OMAP4.
[    1.489135] ThumbEE CPU extension supported.
[    1.508178] clock: disabling unused clocks to save power
[    1.513977] VANA: incomplete constraints, leaving on
[    1.517669] VDAC: incomplete constraints, leaving on
[    1.521118] VUSB: incomplete constraints, leaving on
[    1.525665] twl_rtc twl_rtc: setting system clock to 2000-01-01 00:00:00 UTC (946684800)
[    1.532409] Waiting for root device /dev/mmcblk0p2...
[    1.599426] mmc0: host does not support reading read-only switch. assuming write-enable.
[    1.603942] mmc0: new SD card at address aaaa
[    1.607849] mmcblk0: mmc0:aaaa SD02G 1.89 GiB 
[    1.614410]  mmcblk0: p1 p2
[    3.508514] kjournald starting.  Commit interval 5 seconds
[    3.668579] EXT3-fs (mmcblk0p2): using internal journal
[    3.675384] EXT3-fs (mmcblk0p2): recovery complete
[    3.678039] EXT3-fs (mmcblk0p2): mounted filesystem with ordered data mode
[    3.682037] VFS: Mounted root (ext3 filesystem) on device 179:2.
[    3.685607] Freeing init memory: 316K
modprobe: FATAL: Could not load /lib/modules/3.6.0-rc6-00025-g4651afb/modules.dep: No such file or directory

INIT: version 2.88 booting
Using makefile-style concurrent boot in runlevel S.
Starting the hotplug events dispatcher: udevd.
Synthesizing the initial hotplug events...done.
Waiting for /dev to be fully populated...done.
Activating swap...done.
Cleaning up ifupdown....
Setting up networking....
Loading kernel modules...done.
Activating lvm and md swap...done.
Checking file systems...fsck from util-linux 2.19.1
done.
Mounting local filesystems...done.
Activating swapfile swap...done.
Cleaning up temporary files....
Configuring network interfaces...done.
Cleaning up temporary files....
Setting kernel variables ...done.
INIT: Entering runlevel: 2
Using makefile-style concurrent boot in runlevel 2.

Debian GNU/Linux wheezy/sid armel ttyO2

armel login: [  305.848632] INFO: rcu_sched self-detected stall on CPU
[  305.851470]  1: (17 GPs behind) idle=439/1/0 
[  305.853851]   (t=33915 jiffies)
[  305.855621] [<c001bcb0>] (unwind_backtrace+0x0/0xf0) from [<c00adcd0>] (rcu_check_callbacks+0x1b0/0x678)
[  305.860809] [<c00adcd0>] (rcu_check_callbacks+0x1b0/0x678) from [<c00537e8>] (update_process_times+0x38/0x68)
[  305.866210] [<c00537e8>] (update_process_times+0x38/0x68) from [<c008cf28>] (tick_sched_timer+0x80/0xec)
[  305.871398] [<c008cf28>] (tick_sched_timer+0x80/0xec) from [<c0069414>] (__run_hrtimer+0x7c/0x1e0)
[  305.876281] [<c0069414>] (__run_hrtimer+0x7c/0x1e0) from [<c006a1f8>] (hrtimer_interrupt+0x11c/0x2d0)
[  305.881317] [<c006a1f8>] (hrtimer_interrupt+0x11c/0x2d0) from [<c001a3ec>] (twd_handler+0x30/0x44)
[  305.886199] [<c001a3ec>] (twd_handler+0x30/0x44) from [<c00a8110>] (handle_percpu_devid_irq+0x90/0x13c)
[  305.891326] [<c00a8110>] (handle_percpu_devid_irq+0x90/0x13c) from [<c00a4884>] (generic_handle_irq+0x30/0x48)
[  305.896820] [<c00a4884>] (generic_handle_irq+0x30/0x48) from [<c0014e38>] (handle_IRQ+0x4c/0xac)
[  305.901611] [<c0014e38>] (handle_IRQ+0x4c/0xac) from [<c00084cc>] (gic_handle_irq+0x28/0x5c)
[  305.906219] [<c00084cc>] (gic_handle_irq+0x28/0x5c) from [<c04fdf64>] (__irq_svc+0x44/0x5c)
[  305.910766] Exception stack(0xde86ff08 to 0xde86ff50)
[  305.913513] ff00:                   0002a80e 00000001 00000000 de8660c0 35b88a9a 00000047
[  305.917968] ff20: c11345e0 00000002 efc9ba42 00000046 c0509618 00000000 00000001 de86ff50
[  305.922424] ff40: 0002a80f c03f8f1c 20000113 ffffffff
[  305.925201] [<c04fdf64>] (__irq_svc+0x44/0x5c) from [<c03f8f1c>] (cpuidle_wrap_enter+0x4c/0xa0)
[  305.929962] [<c03f8f1c>] (cpuidle_wrap_enter+0x4c/0xa0) from [<c03f8a10>] (cpuidle_enter_state+0x14/0x68)
[  305.935180] [<c03f8a10>] (cpuidle_enter_state+0x14/0x68) from [<c03fab34>] (cpuidle_enter_state_coupled+0x240/0x2e8)
[  305.940917] [<c03fab34>] (cpuidle_enter_state_coupled+0x240/0x2e8) from [<c03f8b48>] (cpuidle_idle_call+0xe4/0x2e0)
[  305.946594] [<c03f8b48>] (cpuidle_idle_call+0xe4/0x2e0) from [<c0015358>] (cpu_idle+0x98/0x124)
[  305.951324] [<c0015358>] (cpu_idle+0x98/0x124) from [<804f6df4>] (0x804f6df4)
root
[  375.629669] INFO: rcu_sched self-detected stall on CPU
[  375.632476]  0: (2 GPs behind) idle=c1b/1/0 
[  375.634796]   (t=8914 jiffies)
[  375.636505] [<c001bcb0>] (unwind_backtrace+0x0/0xf0) from [<c00adcd0>] (rcu_check_callbacks+0x1b0/0x678)
[  375.641693] [<c00adcd0>] (rcu_check_callbacks+0x1b0/0x678) from [<c00537e8>] (update_process_times+0x38/0x68)
[  375.647094] [<c00537e8>] (update_process_times+0x38/0x68) from [<c008cf28>] (tick_sched_timer+0x80/0xec)
[  375.652252] [<c008cf28>] (tick_sched_timer+0x80/0xec) from [<c0069414>] (__run_hrtimer+0x7c/0x1e0)
[  375.657135] [<c0069414>] (__run_hrtimer+0x7c/0x1e0) from [<c006a1f8>] (hrtimer_interrupt+0x11c/0x2d0)
[  375.662170] [<c006a1f8>] (hrtimer_interrupt+0x11c/0x2d0) from [<c001a3ec>] (twd_handler+0x30/0x44)
[  375.667053] [<c001a3ec>] (twd_handler+0x30/0x44) from [<c00a8110>] (handle_percpu_devid_irq+0x90/0x13c)
[  375.672180] [<c00a8110>] (handle_percpu_devid_irq+0x90/0x13c) from [<c00a4884>] (generic_handle_irq+0x30/0x48)
[  375.677642] [<c00a4884>] (generic_handle_irq+0x30/0x48) from [<c0014e38>] (handle_IRQ+0x4c/0xac)
[  375.682434] [<c0014e38>] (handle_IRQ+0x4c/0xac) from [<c00084cc>] (gic_handle_irq+0x28/0x5c)
[  375.687042] [<c00084cc>] (gic_handle_irq+0x28/0x5c) from [<c04fdf64>] (__irq_svc+0x44/0x5c)
[  375.691589] Exception stack(0xc072df08 to 0xc072df50)
[  375.694366] df00:                   0002fb7e 00000001 00000000 c074e8e8 74fea80e 00000057
[  375.698822] df20: c112b5e0 00000000 74fc5402 00000057 c0d1c94c 00000000 00000001 c072df50
[  375.703277] df40: 0002fb7f c03f8f1c 20000013 ffffffff
[  375.706024] [<c04fdf64>] (__irq_svc+0x44/0x5c) from [<c03f8f1c>] (cpuidle_wrap_enter+0x4c/0xa0)
[  375.710784] [<c03f8f1c>] (cpuidle_wrap_enter+0x4c/0xa0) from [<c03f8ba8>] (cpuidle_idle_call+0x144/0x2e0)
[  375.716003] [<c03f8ba8>] (cpuidle_idle_call+0x144/0x2e0) from [<c0015358>] (cpu_idle+0x98/0x124)
[  375.720794] [<c0015358>] (cpu_idle+0x98/0x124) from [<c06db7b0>] (start_kernel+0x2b4/0x304)
Last login: Sat Jan  1 00:09:14 UTC 2000 on ttyO2
Linux armel 3.6.0-rc6-00025-g4651afb #342 SMP Fri Sep 21 11:28:00 MDT 2012 armv7l

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
root@armel:~# cat /sys/devices/system/cpu/cpuidle/*
omap4_idle
menu
root@armel:~# 





