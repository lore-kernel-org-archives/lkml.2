Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab1AEMDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 07:03:44 -0500
Received: from vwp2514.webpack.hosteurope.de ([87.230.42.24]:38740 "EHLO
	vwp2514.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751716Ab1AEMDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 07:03:43 -0500
X-Greylist: delayed 1217 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Jan 2011 07:03:42 EST
Subject: kernel NULL pointer dereference in pxa3xx_nand_probe
From: Sven Neumann <s.neumann@raumfeld.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Daniel Mack <daniel@caiaq.de>
Content-Type: text/plain; charset="UTF-8"
Organization: RAUMFELD GmbH
Date: Wed, 05 Jan 2011 12:43:21 +0100
Message-ID: <1294227801.3996.62.camel@sven>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;s.neumann@raumfeld.com;1294229022;a9e4ff8a;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've tried upgrading the kernel for a PXA300 based device from 2.6.36.2
to 2.6.37 and now it crashes on boot. Looks like a regression in the
PXA3XX NAND code. Does anyone have a clue on what might be going wrong
or will I have to bisect this?

[    0.000000] Linux version 2.6.37 (sven@sven) (gcc version 4.3.5 (GCC) ) #1 Wed Jan 5 12:22:57 CET 2011
[    0.000000] CPU: XScale-V3 based processor [69056881] revision 1 (ARMv5TE), cr=0000397f
[    0.000000] CPU: VIVT data cache, VIVT instruction cache
[    0.000000] Machine: Raumfeld Controller
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32512
[    0.000000] Kernel command line: console=ttyS0,115200 root=ubi0:RootFS rootfstype=ubifs rw ubi.mtd=3
[    0.000000] PID hash table entries: 512 (order: -1, 2048 bytes)
[    0.000000] Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
[    0.000000] Memory: 128MB = 128MB total
[    0.000000] Memory: 124428k/124428k available, 6644k reserved, 0K highmem
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     DMA     : 0xffc00000 - 0xffe00000   (   2 MB)
[    0.000000]     vmalloc : 0xc8800000 - 0xe8000000   ( 504 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xc8000000   ( 128 MB)
[    0.000000]     modules : 0xbf000000 - 0xc0000000   (  16 MB)
[    0.000000]       .init : 0xc0008000 - 0xc0047000   ( 252 kB)
[    0.000000]       .text : 0xc0047000 - 0xc04fcfc0   (4824 kB)
[    0.000000]       .data : 0xc04fe000 - 0xc05240e0   ( 153 kB)
[    0.000000] SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:288 nr_irqs:288 288
[    0.000000] Console: colour dummy device 80x30
[   24.433568] Calibrating delay loop... 103.83 BogoMIPS (lpj=519168)
[   24.613627] pid_max: default: 32768 minimum: 301
[   24.614271] Mount-cache hash table entries: 512
[   24.615944] CPU: Testing write buffer coherency: ok
[   24.637025] regulator: core version 0.5
[   24.640368] regulator: dummy: 
[   24.641070] NET: Registered protocol family 16
[   24.800409] bio: create slab <bio-0> at 0
[   24.811068] SCSI subsystem initialized
[   24.816485] usbcore: registered new interface driver usbfs
[   24.818824] usbcore: registered new interface driver hub
[   24.820260] usbcore: registered new device driver usb
[   24.829244] regulator: V6(LDO): 3300 mV normal 
[   24.829495] max8660 1-0034: Maxim 8660/8661 regulator driver loaded
[   24.829627] I2C: i2c-1: PXA I2C adapter
[   24.833247] I2C: i2c-0: PXA I2C adapter
[   24.841836] Advanced Linux Sound Architecture Driver Version 1.0.23.
[   24.849337] cfg80211: Calling CRDA to update world regulatory domain
[   24.856798] Switching to clocksource oscr0
[   24.857409] FS-Cache: Loaded
[   24.859185] CacheFiles: Loaded
[   24.866203] Switched to NOHz mode on CPU #0
[   24.989241] NET: Registered protocol family 2
[   24.989794] IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
[   24.991284] TCP established hash table entries: 4096 (order: 3, 32768 bytes)
[   24.992050] TCP bind hash table entries: 4096 (order: 2, 16384 bytes)
[   24.992548] TCP: Hash tables configured (established 4096 bind 4096)
[   24.992641] TCP reno registered
[   24.992732] UDP hash table entries: 256 (order: 0, 4096 bytes)
[   24.992924] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
[   24.994044] NET: Registered protocol family 1
[   24.995271] RPC: Registered udp transport module.
[   24.995365] RPC: Registered tcp transport module.
[   24.995444] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   24.998402] CPUFREQ support for PXA3xx initialized
[   25.039293] FS-Cache: Netfs 'nfs' registered for caching
[   25.042156] msgmni has been set to 243
[   25.043502] io scheduler noop registered
[   25.043527] io scheduler deadline registered
[   25.043712] io scheduler cfq registered (default)
[   25.096255] Console: switching to colour frame buffer device 60x34
[   25.110165] pxa3xx-gcu pxa3xx-gcu: registered @0x54000000, DMA 0xa6180000 (262144 bytes), IRQ 39
[   25.901212] pxa2xx-uart.0: ttyS0 at MMIO 0x40100000 (irq = 22) is a FFUART
[   26.264311] console [ttyS0] enabled
[   26.280438] loop: module loaded
[   26.288066] Unable to handle kernel NULL pointer dereference at virtual address 00000008
[   26.296120] pgd = c0004000
[   26.298893] [00000008] *pgd=00000000
[   26.302445] Internal error: Oops: 5 [#1]
[   26.306332] last sysfs file: 
[   26.309272] Modules linked in:
[   26.312301] CPU: 0    Not tainted  (2.6.37 #1)
[   26.316724] PC is at __readid+0x10/0xd4
[   26.320537] LR is at pxa3xx_nand_probe+0x350/0x6d0
[   26.325293] pc : [<c0204a68>]    lr : [<c0205108>]    psr: 60000013
[   26.325305] sp : c6031ed8  ip : 00000800  fp : 0000002d
[   26.336695] r10: c05054e8  r9 : c62437a0  r8 : c60c2800
[   26.341884] r7 : c0503d28  r6 : c6031ef8  r5 : 00000040  r4 : c60c2998
[   26.348362] r3 : 00000000  r2 : c104dfff  r1 : c6031ef8  r0 : c60c2998
[   26.354843] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[   26.362103] Control: 0000397f  Table: a0004018  DAC: 00000035
[   26.367806] Process swapper (pid: 1, stack limit = 0xc6030278)
[   26.373596] Stack: (0xc6031ed8 to 0xc6032000)
[   26.377925] 1ec0:                                                       c0503d20 c0503d28
[   26.386055] 1ee0: c60c2998 00000040 c0503d20 c0205108 c0487ed2 c60c2998 ffffffff ffffffff
[   26.394188] 1f00: c05149dc c0503d28 c0503d28 c05149dc c05149dc c0511098 00000000 00000000
[   26.402322] 1f20: 00000000 c01daa70 c05149dc c01d9a94 c6232e40 c0503d28 c0503d5c c05149dc
[   26.410455] 1f40: c6031f58 c01d9bd8 00000000 c01d9b78 c05149dc c01d92c4 c6004d38 c6056750
[   26.418587] 1f60: c0511098 c00217bc c05149dc c05149dc c6232e40 c01d8b8c c0487ed2 c051b3cc
[   26.426720] 1f80: c6243700 c00217bc c002195c c05149dc 00000013 c00188dc 00000000 c01d9ee0
[   26.434853] 1fa0: c00217bc c002195c c0048984 00000013 c00188dc c0047404 00000033 00000000
[   26.442985] 1fc0: 00000013 00000120 c05086ec c00217bc c002195c c0048984 00000013 00000000
[   26.451117] 1fe0: 00000000 c000853c 00000000 00000000 c00084a4 c0048984 00000000 00000000
[   26.459268] [<c0204a68>] (__readid+0x10/0xd4) from [<c0205108>] (pxa3xx_nand_probe+0x350/0x6d0)
[   26.467942] [<c0205108>] (pxa3xx_nand_probe+0x350/0x6d0) from [<c01daa70>] (platform_drv_probe+0x1c/0x24)
[   26.477464] [<c01daa70>] (platform_drv_probe+0x1c/0x24) from [<c01d9a94>] (driver_probe_device+0xb4/0x198)
[   26.487067] [<c01d9a94>] (driver_probe_device+0xb4/0x198) from [<c01d9bd8>] (__driver_attach+0x60/0x84)
[   26.496414] [<c01d9bd8>] (__driver_attach+0x60/0x84) from [<c01d92c4>] (bus_for_each_dev+0x4c/0x8c)
[   26.505408] [<c01d92c4>] (bus_for_each_dev+0x4c/0x8c) from [<c01d8b8c>] (bus_add_driver+0xac/0x22c)
[   26.514403] [<c01d8b8c>] (bus_add_driver+0xac/0x22c) from [<c01d9ee0>] (driver_register+0xc0/0x150)
[   26.523416] [<c01d9ee0>] (driver_register+0xc0/0x150) from [<c0047404>] (do_one_initcall+0xc4/0x198)
[   26.532506] [<c0047404>] (do_one_initcall+0xc4/0x198) from [<c000853c>] (kernel_init+0x98/0x150)
[   26.541252] [<c000853c>] (kernel_init+0x98/0x150) from [<c0048984>] (kernel_thread_exit+0x0/0x8)
[   26.549987] Code: e92d4070 e590322c e24dd008 e1a06001 (e1d310b8) 
[   26.556173] ---[ end trace 5df7be383a843a01 ]---
[   26.560823] Kernel panic - not syncing: Attempted to kill init!
[   26.566768] [<c004c7d4>] (unwind_backtrace+0x0/0xec) from [<c0375c18>] (panic+0x4c/0x188)
[   26.574955] [<c0375c18>] (panic+0x4c/0x188) from [<c005d9bc>] (do_exit+0x64/0x5e8)
[   26.582531] [<c005d9bc>] (do_exit+0x64/0x5e8) from [<c004b59c>] (die+0x1b4/0x1e4)
[   26.590027] [<c004b59c>] (die+0x1b4/0x1e4) from [<c004d930>] (__do_kernel_fault+0x64/0x88)
[   26.598295] [<c004d930>] (__do_kernel_fault+0x64/0x88) from [<c004db0c>] (do_page_fault+0x1b8/0x1d0)
[   26.607437] [<c004db0c>] (do_page_fault+0x1b8/0x1d0) from [<c00472dc>] (do_DataAbort+0x34/0x94)
[   26.616099] [<c00472dc>] (do_DataAbort+0x34/0x94) from [<c0047b4c>] (__dabt_svc+0x4c/0x60)
[   26.624339] Exception stack(0xc6031e90 to 0xc6031ed8)
[   26.629391] 1e80:                                     c60c2998 c6031ef8 c104dfff 00000000
[   26.637556] 1ea0: c60c2998 00000040 c6031ef8 c0503d28 c60c2800 c62437a0 c05054e8 0000002d
[   26.645685] 1ec0: 00000800 c6031ed8 c0205108 c0204a68 60000013 ffffffff
[   26.652304] [<c0047b4c>] (__dabt_svc+0x4c/0x60) from [<c0204a68>] (__readid+0x10/0xd4)
[   26.660223] [<c0204a68>] (__readid+0x10/0xd4) from [<c0205108>] (pxa3xx_nand_probe+0x350/0x6d0)
[   26.668930] [<c0205108>] (pxa3xx_nand_probe+0x350/0x6d0) from [<c01daa70>] (platform_drv_probe+0x1c/0x24)
[   26.678498] [<c01daa70>] (platform_drv_probe+0x1c/0x24) from [<c01d9a94>] (driver_probe_device+0xb4/0x198)
[   26.688146] [<c01d9a94>] (driver_probe_device+0xb4/0x198) from [<c01d9bd8>] (__driver_attach+0x60/0x84)
[   26.697538] [<c01d9bd8>] (__driver_attach+0x60/0x84) from [<c01d92c4>] (bus_for_each_dev+0x4c/0x8c)
[   26.706542] [<c01d92c4>] (bus_for_each_dev+0x4c/0x8c) from [<c01d8b8c>] (bus_add_driver+0xac/0x22c)
[   26.715577] [<c01d8b8c>] (bus_add_driver+0xac/0x22c) from [<c01d9ee0>] (driver_register+0xc0/0x150)
[   26.724627] [<c01d9ee0>] (driver_register+0xc0/0x150) from [<c0047404>] (do_one_initcall+0xc4/0x198)
[   26.733757] [<c0047404>] (do_one_initcall+0xc4/0x198) from [<c000853c>] (kernel_init+0x98/0x150)
[   26.742546] [<c000853c>] (kernel_init+0x98/0x150) from [<c0048984>] (kernel_thread_exit+0x0/0x8)


Regards,
Sven


