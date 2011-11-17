Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab1KQPti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 10:49:38 -0500
Received: from void.printf.net ([89.145.121.20]:46170 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209Ab1KQPth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 10:49:37 -0500
From: Chris Ball <cjb@laptop.org>
To: Sven Neumann <s.neumann@raumfeld.com>
Cc: Daniel Drake <dsd@laptop.org>, Dan Williams <dcbw@redhat.com>,
        linux-mmc@vger.kernel.org, libertas-dev@lists.infradead.org,
        linux-kernel@vger.kernel.org, Daniel Mack <daniel@zonque.org>
Subject: Re: Oops on suspend with libertas SDIO (Linux 3.2-rc2)
References: <1321544210.31090.6.camel@sven>
Date: Thu, 17 Nov 2011 10:49:37 -0500
In-Reply-To: <1321544210.31090.6.camel@sven> (Sven Neumann's message of "Thu,
	17 Nov 2011 16:36:50 +0100")
Message-ID: <87zkfuhhpq.fsf@laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Nov 17 2011, Sven Neumann wrote:
> I've given 3.2-rc2 a try today and the kernel oopsed when going into suspend:
>
> [   20.387912] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [ 20.408759] Freezing remaining freezable tasks ... (elapsed 0.01
> seconds) done.
> [   20.432966] libertas_sdio mmc0:0001:1: mmc0:0001:1: suspend: PM flags = 0x0
> [ 20.439978] libertas_sdio mmc0:0001:1: Suspend without wake params --
> powering down card
> [   23.456061] libertas_sdio mmc0:0001:1: wlan0: command 0x0010 timed out
> [ 23.462626] libertas_sdio mmc0:0001:1: wlan0: Timeout submitting
> command 0x0010
> [   23.470026] libertas_sdio: Resetting card...
> [   23.474140] ------------[ cut here ]------------
> [   23.479002] WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0x50/0x11c()
> [   23.486045] sysfs group c05cb5c8 not found for kobject 'mmc0:0001:1'
> [   23.492358] Modules linked in: libertas_sdio libertas pxamci
> [ 23.498091] [<c000dbb4>] (unwind_backtrace+0x0/0xec) from
> [<c001ca10>] (warn_slowpath_common+0x4c/0x64)
> [ 23.507467] [<c001ca10>] (warn_slowpath_common+0x4c/0x64) from
> [<c001cabc>] (warn_slowpath_fmt+0x30/0x40)
> [ 23.517021] [<c001cabc>] (warn_slowpath_fmt+0x30/0x40) from
> [<c00d369c>] (sysfs_remove_group+0x50/0x11c)
> [ 23.526504] [<c00d369c>] (sysfs_remove_group+0x50/0x11c) from
> [<c0202ec4>] (device_del+0x3c/0x1a4)
> [ 23.535437] [<c0202ec4>] (device_del+0x3c/0x1a4) from [<c0295dfc>]
> (sdio_remove_func+0x1c/0x2c)
> [ 23.544127] [<c0295dfc>] (sdio_remove_func+0x1c/0x2c) from
> [<c0295110>] (mmc_sdio_remove+0x44/0x78)
> [ 23.553161] [<c0295110>] (mmc_sdio_remove+0x44/0x78) from
> [<c028f0e4>] (mmc_stop_host+0xd0/0x22c)
> [ 23.562016] [<c028f0e4>] (mmc_stop_host+0xd0/0x22c) from [<c0290578>]
> (mmc_remove_host+0x18/0x2c)
> [ 23.570898] [<c0290578>] (mmc_remove_host+0x18/0x2c) from
> [<bf019470>] (if_sdio_reset_card_worker+0x18/0x2c [libertas_sdio])
> [ 23.582138] [<bf019470>] (if_sdio_reset_card_worker+0x18/0x2c
> [libertas_sdio]) from [<c00302fc>] (process_one_work+0x260/0x3c8)
> [ 23.593594] [<c00302fc>] (process_one_work+0x260/0x3c8) from
> [<c0030ac8>] (worker_thread+0x224/0x458)
> [ 23.602816] [<c0030ac8>] (worker_thread+0x224/0x458) from
> [<c0036a00>] (kthread+0x80/0x88)
> [ 23.611078] [<c0036a00>] (kthread+0x80/0x88) from [<c0009ca8>]
> (kernel_thread_exit+0x0/0x8)
> [   23.619409] ---[ end trace 78598ef84f325bdd ]---
> [ 23.624011] Unable to handle kernel NULL pointer dereference at
> virtual address 0000000c
> [   23.632079] pgd = c0004000
> [   23.634762] [0000000c] *pgd=00000000
> [   23.638351] Internal error: Oops: 17 [#1] PREEMPT
> [   23.643016] Modules linked in: libertas_sdio libertas pxamci
> [   23.648666] CPU: 0    Tainted: G        W     (3.2.0-rc2 #2)
> [   23.654316] PC is at klist_put+0x18/0x9c
> [   23.658213] LR is at device_del+0x50/0x1a4
> [   23.662287] pc : [<c03ca8fc>]    lr : [<c0202ed8>]    psr: a0000013
> [   23.662298] sp : c6569f18  ip : 40000013  fp : c602e605
> [   23.673688] r10: 00000000  r9 : bf019458  r8 : c602e600
> [   23.678876] r7 : 00000000  r6 : c6447408  r5 : c64bbe50  r4 : 00000001
> [   23.685363] r3 : 00000000  r2 : 00000200  r1 : 00000001  r0 : 00000001
> [ 23.691844] Flags: NzCv IRQs on FIQs on Mode SVC_32 ISA ARM Segment
> kernel
> [   23.699106] Control: 0000397f  Table: a65a0018  DAC: 00000035
> [   23.704817] Process kworker/0:2 (pid: 1204, stack limit = 0xc6568278)
> [   23.711218] Stack: (0xc6569f18 to 0xc656a000)
> [ 23.715547] 9f00: c65fe008 c6447000
> [ 23.723677] 9f20: c6447408 c0202ed8 c65fe008 c6447000 00000084
> c0295dfc 00000001 c0295110
> [ 23.731810] 9f40: c63e8f00 c6447000 60000013 00000000 00000009
> c028f0e4 c6447000 c6447000
> [ 23.739944] 9f60: c63e8f00 c0290578 bf019c9c bf019470 bf019af0
> c00302fc c05c1b38 c63e8f00
> [ 23.748076] 9f80: c05c1b38 c05c1b38 00000009 c6568000 c63e8f10
> c05c1b38 c63e8f10 c0030ac8
> [ 23.756208] 9fa0: c6083f14 c6569fd4 c6083f14 c63e8f00 c00308a4
> 00000000 00000000 00000000
> [ 23.764341] 9fc0: 00000000 c0036a00 c0009ca8 00000000 c63e8f00
> 00000000 c6569fd8 c6569fd8
> [ 23.772475] 9fe0: 00000000 c6083f14 c0036980 c0009ca8 00000013
> c0009ca8 0340f30e 153b5900
> [ 23.780618] [<c03ca8fc>] (klist_put+0x18/0x9c) from [<c0202ed8>]
> (device_del+0x50/0x1a4)
> [ 23.788675] [<c0202ed8>] (device_del+0x50/0x1a4) from [<c0295dfc>]
> (sdio_remove_func+0x1c/0x2c)
> [ 23.797327] [<c0295dfc>] (sdio_remove_func+0x1c/0x2c) from
> [<c0295110>] (mmc_sdio_remove+0x44/0x78)
> [ 23.806328] [<c0295110>] (mmc_sdio_remove+0x44/0x78) from
> [<c028f0e4>] (mmc_stop_host+0xd0/0x22c)
> [ 23.815148] [<c028f0e4>] (mmc_stop_host+0xd0/0x22c) from [<c0290578>]
> (mmc_remove_host+0x18/0x2c)
> [ 23.823987] [<c0290578>] (mmc_remove_host+0x18/0x2c) from
> [<bf019470>] (if_sdio_reset_card_worker+0x18/0x2c [libertas_sdio])
> [ 23.835164] [<bf019470>] (if_sdio_reset_card_worker+0x18/0x2c
> [libertas_sdio]) from [<c00302fc>] (process_one_work+0x260/0x3c8)
> [ 23.846584] [<c00302fc>] (process_one_work+0x260/0x3c8) from
> [<c0030ac8>] (worker_thread+0x224/0x458)
> [ 23.855760] [<c0030ac8>] (worker_thread+0x224/0x458) from
> [<c0036a00>] (kthread+0x80/0x88)
> [ 23.863984] [<c0036a00>] (kthread+0x80/0x88) from [<c0009ca8>]
> (kernel_thread_exit+0x0/0x8)
> [   23.872292] Code: e1a05000 e3a00001 e3c33001 e1a04001 (e593600c) 
> [   23.878402] ---[ end trace 78598ef84f325bde ]---
> [ 23.883135] Unable to handle kernel paging request at virtual address
> fffffffc
> [   23.890313] pgd = c0004000
> [   23.893000] [fffffffc] *pgd=a7ffe821, *pte=00000000, *ppte=00000000
> [   23.899244] Internal error: Oops: 17 [#2] PREEMPT
> [   23.903915] Modules linked in: libertas_sdio libertas pxamci
> [   23.909564] CPU: 0    Tainted: G      D W     (3.2.0-rc2 #2)
> [   23.915199] PC is at kthread_data+0x4/0xc
> [   23.919186] LR is at wq_worker_sleeping+0xc/0xb4
> [   23.923772] pc : [<c003648c>]    lr : [<c0032ee0>]    psr: 20000093
> [   23.923783] sp : c6569d60  ip : c05bff98  fp : c6569d94
> [   23.935174] r10: c60336ec  r9 : c05bff98  r8 : c6568000
> [   23.940361] r7 : c6032000  r6 : c6033768  r5 : c6033600  r4 : 00000000
> [   23.946848] r3 : 00000000  r2 : c05bff98  r1 : 00000000  r0 : c6033600
> [ 23.953329] Flags: nzCv IRQs off FIQs on Mode SVC_32 ISA ARM Segment
> user
> [   23.960504] Control: 0000397f  Table: a65a0018  DAC: 00000015
> [   23.966207] Process kworker/0:2 (pid: 1204, stack limit = 0xc6568278)
> [...]
>
> Hardware is a PXA300 with a Marvell 8868 Wifi module attached over SDIO.

Adding Daniel Drake to CC, for 9a821f5d0fc ("libertas: add sd8686
reset_card support").

Looks like mmc_sdio_remove() calls mmc_remove_card() after the
reset_card function has called mmc_remove_host() already.  Maybe
if_sdio_reset_card_worker() should call mmc_free_host() as well?

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
