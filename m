Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab2APU1D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 15:27:03 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:65366 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401Ab2APU1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 15:27:00 -0500
Date: Mon, 16 Jan 2012 15:30:59 -0500
From: Jerome Glisse <j.glisse@gmail.com>
To: Martin Nyhus <martin.nyhus@gmx.com>
Cc: Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [next] Null pointer dereference in nouveau_vm_map_sg
Message-ID: <20120116203059.GC4482@homer.localdomain>
References: <201201152231.08561.martin.nyhus@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201201152231.08561.martin.nyhus@gmx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 15, 2012 at 10:31:08PM +0100, Martin Nyhus wrote:
> In some cases mem will be null in nouveau_vm_map_sg, resulting in a crash
> at drivers/gpu/drm/nouveau/nouveau_vm.c:84. It seems to be easy enough to
> reproduce, so I can test patches if needed.
> 
> 	Martin
> 

How do you trigger this ?

Cheers,
Jerome

> 
> 
> [  216.546584] BUG: unable to handle kernel NULL pointer dereference at 00000000000000d0
> [  216.546613] IP: [<ffffffff814a87ec>] nouveau_vm_map_sg+0x2c/0x130
> [  216.546631] PGD 5b155067 PUD 5ab71067 PMD 0 
> [  216.546647] Oops: 0000 [#1] SMP 
> [  216.546659] CPU 1 
> [  216.546664] Modules linked in: tun iwl4965 iwlegacy mac80211 cfg80211 tg3 psmouse rtc_cmos evdev ehci_hcd uhci_hcd usbcore usb_common [last unloaded: scsi_wait_scan]
> [  216.546721] 
> [  216.546727] Pid: 3327, comm: Xorg Not tainted 3.2.0-next-20120113 #56 Dell Inc. XPS M1330                       /0PU073
> [  216.546749] RIP: 0010:[<ffffffff814a87ec>]  [<ffffffff814a87ec>] nouveau_vm_map_sg+0x2c/0x130
> [  216.546770] RSP: 0018:ffff88005b0c9858  EFLAGS: 00010246
> [  216.546780] RAX: ffff88005bf84620 RBX: ffff88005ab08d20 RCX: 0000000000000000
> [  216.546791] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000000000
> [  216.546802] RBP: ffff88005b0c98a8 R08: 0000000000000000 R09: 0000000000000000
> [  216.546813] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000004000
> [  216.546823] R13: ffff88005bf84dc8 R14: ffff88007838c000 R15: 0000000000000000
> [  216.546835] FS:  00007f5f728a8880(0000) GS:ffff88007fd00000(0000) knlGS:0000000000000000
> [  216.546848] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  216.546857] CR2: 00000000000000d0 CR3: 000000006c1bb000 CR4: 00000000000006e0
> [  216.546869] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  216.546880] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  216.546892] Process Xorg (pid: 3327, threadinfo ffff88005b0c8000, task ffff8800655da180)
> [  216.546904] Stack:
> [  216.546909]  ffff88005b0c9960 ffff880037180368 0000000000000000 0000000000000000
> [  216.546930]  ffff88005b0c98d8 ffff88005bf84dc8 ffff88005b0c9960 ffff88007838c240
> [  216.546949]  ffff88007838c000 0000000000000000 ffff88005b0c98d8 ffffffff81481bdf
> [  216.546969] Call Trace:
> [  216.546979]  [<ffffffff81481bdf>] nouveau_bo_move_ntfy+0x7f/0xb0
> [  216.546991]  [<ffffffff81470614>] ttm_bo_handle_move_mem+0x204/0x3d0
> [  216.547003]  [<ffffffff8147099d>] ttm_bo_evict+0x1bd/0x2a0
> [  216.547015]  [<ffffffff81460de7>] ? drm_mm_kmalloc+0x37/0xd0
> [  216.547027]  [<ffffffff81470bf1>] ttm_mem_evict_first+0x171/0x230
> [  216.547039]  [<ffffffff814714ed>] ttm_bo_mem_space+0x30d/0x420
> [  216.547056]  [<ffffffff814716e8>] ttm_bo_move_buffer+0xe8/0x160
> [  216.547069]  [<ffffffff8108df2b>] ? __lock_release+0x6b/0xe0
> [  216.547080]  [<ffffffff81460de7>] ? drm_mm_kmalloc+0x37/0xd0
> [  216.547091]  [<ffffffff81471847>] ttm_bo_validate+0xe7/0xf0
> [  216.547102]  [<ffffffff81471a24>] ttm_bo_init+0x1d4/0x2a0
> [  216.547113]  [<ffffffff81482481>] ? nouveau_bo_new+0x51/0x1c0
> [  216.547124]  [<ffffffff8148258c>] nouveau_bo_new+0x15c/0x1c0
> [  216.547135]  [<ffffffff81481eb0>] ? nouveau_ttm_tt_create+0x80/0x80
> [  216.547148]  [<ffffffff81338bba>] ? avc_has_perm_noaudit+0xfa/0x290
> [  216.547160]  [<ffffffff81485cf3>] nouveau_gem_new+0x53/0x120
> [  216.548008]  [<ffffffff8108df81>] ? __lock_release+0xc1/0xe0
> [  216.548008]  [<ffffffff81112a97>] ? might_fault+0x57/0xb0
> [  216.548008]  [<ffffffff81485e29>] nouveau_gem_ioctl_new+0x69/0x170
> [  216.548008]  [<ffffffff81112a97>] ? might_fault+0x57/0xb0
> [  216.548008]  [<ffffffff814553e4>] drm_ioctl+0x444/0x510
> [  216.548008]  [<ffffffff81485dc0>] ? nouveau_gem_new+0x120/0x120
> [  216.548008]  [<ffffffff81150b17>] do_vfs_ioctl+0x87/0x330
> [  216.548008]  [<ffffffff8133b528>] ? selinux_file_ioctl+0x68/0x140
> [  216.548008]  [<ffffffff81150e51>] sys_ioctl+0x91/0xa0
> [  216.555939]  [<ffffffff817c1722>] system_call_fastpath+0x16/0x1b
> [  216.555939] Code: 48 89 e5 41 57 49 89 cf 41 56 41 55 49 89 fd 41 54 49 89 d4 ba 01 00 00 00 53 41 89 d3 48 83 ec 28 48 8b 47 20 48 8b 5f 18 31 ff <4c> 8b b1 d0 00 00 00 0f b6 48 30 44 8b 48 34 8b 83 20 01 00 00 
> [  216.555939] RIP  [<ffffffff814a87ec>] nouveau_vm_map_sg+0x2c/0x130
> [  216.555939]  RSP <ffff88005b0c9858>
> [  216.555939] CR2: 00000000000000d0
> [  216.581301] ---[ end trace 0d910003d5fb1cd8 ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
