Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab1KQPxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 10:53:36 -0500
Received: from vwp2514.webpack.hosteurope.de ([87.230.42.24]:59487 "EHLO
	vwp2514.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932198Ab1KQPxf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 10:53:35 -0500
X-Greylist: delayed 1001 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Nov 2011 10:53:34 EST
Message-ID: <1321544210.31090.6.camel@sven>
Subject: Oops on suspend with libertas SDIO (Linux 3.2-rc2)
From: Sven Neumann <s.neumann@raumfeld.com>
To: Chris Ball <cjb@laptop.org>, Dan Williams <dcbw@redhat.com>
Cc: linux-mmc@vger.kernel.org, libertas-dev@lists.infradead.org,
        linux-kernel@vger.kernel.org, Daniel Mack <daniel@zonque.org>
Date: Thu, 17 Nov 2011 16:36:50 +0100
Organization: RAUMFELD GmbH
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
X-bounce-key: webpack.hosteurope.de;s.neumann@raumfeld.com;1321545214;ef44742f;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've given 3.2-rc2 a try today and the kernel oopsed when going into suspend:

[   20.387912] Freezing user space processes ... (elapsed 0.01 seconds) done.
[   20.408759] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[   20.432966] libertas_sdio mmc0:0001:1: mmc0:0001:1: suspend: PM flags = 0x0
[   20.439978] libertas_sdio mmc0:0001:1: Suspend without wake params -- powering down card
[   23.456061] libertas_sdio mmc0:0001:1: wlan0: command 0x0010 timed out
[   23.462626] libertas_sdio mmc0:0001:1: wlan0: Timeout submitting command 0x0010
[   23.470026] libertas_sdio: Resetting card...
[   23.474140] ------------[ cut here ]------------
[   23.479002] WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0x50/0x11c()
[   23.486045] sysfs group c05cb5c8 not found for kobject 'mmc0:0001:1'
[   23.492358] Modules linked in: libertas_sdio libertas pxamci
[   23.498091] [<c000dbb4>] (unwind_backtrace+0x0/0xec) from [<c001ca10>] (warn_slowpath_common+0x4c/0x64)
[   23.507467] [<c001ca10>] (warn_slowpath_common+0x4c/0x64) from [<c001cabc>] (warn_slowpath_fmt+0x30/0x40)
[   23.517021] [<c001cabc>] (warn_slowpath_fmt+0x30/0x40) from [<c00d369c>] (sysfs_remove_group+0x50/0x11c)
[   23.526504] [<c00d369c>] (sysfs_remove_group+0x50/0x11c) from [<c0202ec4>] (device_del+0x3c/0x1a4)
[   23.535437] [<c0202ec4>] (device_del+0x3c/0x1a4) from [<c0295dfc>] (sdio_remove_func+0x1c/0x2c)
[   23.544127] [<c0295dfc>] (sdio_remove_func+0x1c/0x2c) from [<c0295110>] (mmc_sdio_remove+0x44/0x78)
[   23.553161] [<c0295110>] (mmc_sdio_remove+0x44/0x78) from [<c028f0e4>] (mmc_stop_host+0xd0/0x22c)
[   23.562016] [<c028f0e4>] (mmc_stop_host+0xd0/0x22c) from [<c0290578>] (mmc_remove_host+0x18/0x2c)
[   23.570898] [<c0290578>] (mmc_remove_host+0x18/0x2c) from [<bf019470>] (if_sdio_reset_card_worker+0x18/0x2c [libertas_sdio])
[   23.582138] [<bf019470>] (if_sdio_reset_card_worker+0x18/0x2c [libertas_sdio]) from [<c00302fc>] (process_one_work+0x260/0x3c8)
[   23.593594] [<c00302fc>] (process_one_work+0x260/0x3c8) from [<c0030ac8>] (worker_thread+0x224/0x458)
[   23.602816] [<c0030ac8>] (worker_thread+0x224/0x458) from [<c0036a00>] (kthread+0x80/0x88)
[   23.611078] [<c0036a00>] (kthread+0x80/0x88) from [<c0009ca8>] (kernel_thread_exit+0x0/0x8)
[   23.619409] ---[ end trace 78598ef84f325bdd ]---
[   23.624011] Unable to handle kernel NULL pointer dereference at virtual address 0000000c
[   23.632079] pgd = c0004000
[   23.634762] [0000000c] *pgd=00000000
[   23.638351] Internal error: Oops: 17 [#1] PREEMPT
[   23.643016] Modules linked in: libertas_sdio libertas pxamci
[   23.648666] CPU: 0    Tainted: G        W     (3.2.0-rc2 #2)
[   23.654316] PC is at klist_put+0x18/0x9c
[   23.658213] LR is at device_del+0x50/0x1a4
[   23.662287] pc : [<c03ca8fc>]    lr : [<c0202ed8>]    psr: a0000013
[   23.662298] sp : c6569f18  ip : 40000013  fp : c602e605
[   23.673688] r10: 00000000  r9 : bf019458  r8 : c602e600
[   23.678876] r7 : 00000000  r6 : c6447408  r5 : c64bbe50  r4 : 00000001
[   23.685363] r3 : 00000000  r2 : 00000200  r1 : 00000001  r0 : 00000001
[   23.691844] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[   23.699106] Control: 0000397f  Table: a65a0018  DAC: 00000035
[   23.704817] Process kworker/0:2 (pid: 1204, stack limit = 0xc6568278)
[   23.711218] Stack: (0xc6569f18 to 0xc656a000)
[   23.715547] 9f00:                                                       c65fe008 c6447000
[   23.723677] 9f20: c6447408 c0202ed8 c65fe008 c6447000 00000084 c0295dfc 00000001 c0295110
[   23.731810] 9f40: c63e8f00 c6447000 60000013 00000000 00000009 c028f0e4 c6447000 c6447000
[   23.739944] 9f60: c63e8f00 c0290578 bf019c9c bf019470 bf019af0 c00302fc c05c1b38 c63e8f00
[   23.748076] 9f80: c05c1b38 c05c1b38 00000009 c6568000 c63e8f10 c05c1b38 c63e8f10 c0030ac8
[   23.756208] 9fa0: c6083f14 c6569fd4 c6083f14 c63e8f00 c00308a4 00000000 00000000 00000000
[   23.764341] 9fc0: 00000000 c0036a00 c0009ca8 00000000 c63e8f00 00000000 c6569fd8 c6569fd8
[   23.772475] 9fe0: 00000000 c6083f14 c0036980 c0009ca8 00000013 c0009ca8 0340f30e 153b5900
[   23.780618] [<c03ca8fc>] (klist_put+0x18/0x9c) from [<c0202ed8>] (device_del+0x50/0x1a4)
[   23.788675] [<c0202ed8>] (device_del+0x50/0x1a4) from [<c0295dfc>] (sdio_remove_func+0x1c/0x2c)
[   23.797327] [<c0295dfc>] (sdio_remove_func+0x1c/0x2c) from [<c0295110>] (mmc_sdio_remove+0x44/0x78)
[   23.806328] [<c0295110>] (mmc_sdio_remove+0x44/0x78) from [<c028f0e4>] (mmc_stop_host+0xd0/0x22c)
[   23.815148] [<c028f0e4>] (mmc_stop_host+0xd0/0x22c) from [<c0290578>] (mmc_remove_host+0x18/0x2c)
[   23.823987] [<c0290578>] (mmc_remove_host+0x18/0x2c) from [<bf019470>] (if_sdio_reset_card_worker+0x18/0x2c [libertas_sdio])
[   23.835164] [<bf019470>] (if_sdio_reset_card_worker+0x18/0x2c [libertas_sdio]) from [<c00302fc>] (process_one_work+0x260/0x3c8)
[   23.846584] [<c00302fc>] (process_one_work+0x260/0x3c8) from [<c0030ac8>] (worker_thread+0x224/0x458)
[   23.855760] [<c0030ac8>] (worker_thread+0x224/0x458) from [<c0036a00>] (kthread+0x80/0x88)
[   23.863984] [<c0036a00>] (kthread+0x80/0x88) from [<c0009ca8>] (kernel_thread_exit+0x0/0x8)
[   23.872292] Code: e1a05000 e3a00001 e3c33001 e1a04001 (e593600c) 
[   23.878402] ---[ end trace 78598ef84f325bde ]---
[   23.883135] Unable to handle kernel paging request at virtual address fffffffc
[   23.890313] pgd = c0004000
[   23.893000] [fffffffc] *pgd=a7ffe821, *pte=00000000, *ppte=00000000
[   23.899244] Internal error: Oops: 17 [#2] PREEMPT
[   23.903915] Modules linked in: libertas_sdio libertas pxamci
[   23.909564] CPU: 0    Tainted: G      D W     (3.2.0-rc2 #2)
[   23.915199] PC is at kthread_data+0x4/0xc
[   23.919186] LR is at wq_worker_sleeping+0xc/0xb4
[   23.923772] pc : [<c003648c>]    lr : [<c0032ee0>]    psr: 20000093
[   23.923783] sp : c6569d60  ip : c05bff98  fp : c6569d94
[   23.935174] r10: c60336ec  r9 : c05bff98  r8 : c6568000
[   23.940361] r7 : c6032000  r6 : c6033768  r5 : c6033600  r4 : 00000000
[   23.946848] r3 : 00000000  r2 : c05bff98  r1 : 00000000  r0 : c6033600
[   23.953329] Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
[   23.960504] Control: 0000397f  Table: a65a0018  DAC: 00000015
[   23.966207] Process kworker/0:2 (pid: 1204, stack limit = 0xc6568278)
[   23.972600] Stack: (0xc6569d60 to 0xc656a000)
[   23.976936] 9d60: 00000000 c03d275c 00000000 00000001 c6569d9c c6033600 c6032000 c60336ec
[   23.985068] 9d80: c60335f8 c60336ec 00000001 c6569d98 c0020acc c03d265c 00000000 c6569d9c
[   23.993201] 9da0: c6569d9c c6033734 c602e605 c6569ed0 c6033600 c6568000 00000000 c04ef7d8
[   24.001334] 9dc0: 00000017 c6569ed0 c602e605 c000c51c c6568278 0000000b 0000000c c6569ed0
[   24.009466] 9de0: 00000000 00000017 00000000 c000ee00 c05bbbcc c6033600 00000000 0000000c
[   24.017600] 9e00: 0000000c c000effc c003b1ac c0015e8c c05bbbcc a0000013 00000017 c6569ed0
[   24.025732] 9e20: 0000000c bf019458 00000000 c000849c 00000025 c6569e65 c05fffaf c6569e48
[   24.033866] 9e40: c001dc78 c0015e8c 00000000 80000013 c0036980 205b6a00 33322020 3931362e
[   24.041998] 9e60: 5d393034 00000020 00000000 00000000 c6569ff8 c0009ca8 00000000 c000c2dc
[   24.050131] 9e80: c04eee5e c0036a00 00000004 00569ea8 c00d369c 0000008a c04f71e0 c00d369c
[   24.058264] 9ea0: c6569ef0 00000009 bf019458 00000000 c602e605 c03d24ac c03ca8fc a0000013
[   24.066396] 9ec0: ffffffff c6569f04 c602e600 c0008e98 00000001 00000001 00000200 00000000
[   24.074530] 9ee0: 00000001 c64bbe50 c6447408 00000000 c602e600 bf019458 00000000 c602e605
[   24.082664] 9f00: 40000013 c6569f18 c0202ed8 c03ca8fc a0000013 ffffffff c65fe008 c6447000
[   24.090796] 9f20: c6447408 c0202ed8 c65fe008 c6447000 00000084 c0295dfc 00000001 c0295110
[   24.098929] 9f40: c63e8f00 c6447000 60000013 00000000 00000009 c028f0e4 c6447000 c6447000
[   24.107063] 9f60: c63e8f00 c0290578 bf019c9c bf019470 bf019af0 c00302fc c05c1b38 c63e8f00
[   24.115195] 9f80: c05c1b38 c05c1b38 00000009 c6568000 c63e8f10 c05c1b38 c63e8f10 c0030ac8
[   24.123327] 9fa0: c6083f14 c6569fd4 c6083f14 c63e8f00 c00308a4 00000000 00000000 00000000
[   24.131460] 9fc0: 00000000 c0036a00 c0009ca8 00000000 c63e8f00 00000001 c6569fd8 c6569fd8
[   24.139594] 9fe0: 00000000 c6083f14 c0036980 c0009ca8 00000013 c0009ca8 0340f30e 153b5900
[   24.147738] [<c003648c>] (kthread_data+0x4/0xc) from [<c0032ee0>] (wq_worker_sleeping+0xc/0xb4)
[   24.156399] [<c0032ee0>] (wq_worker_sleeping+0xc/0xb4) from [<c03d275c>] (__schedule+0x10c/0x3a8)
[   24.165242] [<c03d275c>] (__schedule+0x10c/0x3a8) from [<c0020acc>] (do_exit+0x668/0x694)
[   24.173385] [<c0020acc>] (do_exit+0x668/0x694) from [<c000c51c>] (die+0x1f0/0x220)
[   24.180924] [<c000c51c>] (die+0x1f0/0x220) from [<c000ee00>] (__do_kernel_fault+0x64/0x88)
[   24.189147] [<c000ee00>] (__do_kernel_fault+0x64/0x88) from [<c000effc>] (do_page_fault+0x1d8/0x1f0)
[   24.198234] [<c000effc>] (do_page_fault+0x1d8/0x1f0) from [<c000849c>] (do_DataAbort+0x34/0x94)
[   24.206888] [<c000849c>] (do_DataAbort+0x34/0x94) from [<c0008e98>] (__dabt_svc+0x38/0x60)
[   24.215096] Exception stack(0xc6569ed0 to 0xc6569f18)
[   24.220114] 9ec0:                                     00000001 00000001 00000200 00000000
[   24.228245] 9ee0: 00000001 c64bbe50 c6447408 00000000 c602e600 bf019458 00000000 c602e605
[   24.236376] 9f00: 40000013 c6569f18 c0202ed8 c03ca8fc a0000013 ffffffff
[   24.242969] [<c0008e98>] (__dabt_svc+0x38/0x60) from [<c03ca8fc>] (klist_put+0x18/0x9c)
[   24.250946] [<c03ca8fc>] (klist_put+0x18/0x9c) from [<c0202ed8>] (device_del+0x50/0x1a4)
[   24.259012] [<c0202ed8>] (device_del+0x50/0x1a4) from [<c0295dfc>] (sdio_remove_func+0x1c/0x2c)
[   24.267666] [<c0295dfc>] (sdio_remove_func+0x1c/0x2c) from [<c0295110>] (mmc_sdio_remove+0x44/0x78)
[   24.276667] [<c0295110>] (mmc_sdio_remove+0x44/0x78) from [<c028f0e4>] (mmc_stop_host+0xd0/0x22c)
[   24.285488] [<c028f0e4>] (mmc_stop_host+0xd0/0x22c) from [<c0290578>] (mmc_remove_host+0x18/0x2c)
[   24.294330] [<c0290578>] (mmc_remove_host+0x18/0x2c) from [<bf019470>] (if_sdio_reset_card_worker+0x18/0x2c [libertas_sdio])
[   24.305514] [<bf019470>] (if_sdio_reset_card_worker+0x18/0x2c [libertas_sdio]) from [<c00302fc>] (process_one_work+0x260/0x3c8)
[   24.316932] [<c00302fc>] (process_one_work+0x260/0x3c8) from [<c0030ac8>] (worker_thread+0x224/0x458)
[   24.326107] [<c0030ac8>] (worker_thread+0x224/0x458) from [<c0036a00>] (kthread+0x80/0x88)
[   24.334331] [<c0036a00>] (kthread+0x80/0x88) from [<c0009ca8>] (kernel_thread_exit+0x0/0x8)
[   24.342632] Code: e593313c e5130008 e12fff1e e590313c (e5130004) 
[   24.348836] ---[ end trace 78598ef84f325bdf ]---
[   24.353429] Fixing recursive fault but reboot is needed!


Hardware is a PXA300 with a Marvell 8868 Wifi module attached over SDIO.


Regards,
Sven

-- 
Sven Neumann
Head of RAUMFELD Software Development

Lautsprecher Teufel GmbH | Bülowstr. 66 | 10783 Berlin | Germany
Tel: +49 (0)30-300 930 153 | s.neumann@raumfeld.com

