Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab1IAVEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 17:04:45 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:54184 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887Ab1IAVEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 17:04:44 -0400
Date: Thu, 1 Sep 2011 22:04:42 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: BUG: unable to handle kernel paging request at 6b6b6c6f
 (bdi_lock_two+0x22/0x50)
Message-ID: <20110901210442.GA9660@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When pulling out a USB flash disk formatted with a single FAT32
partition the following oops and errors are produced:

[  112.414392] FAT-fs (sdc1): Directory bread(block 2303) failed
[  112.427087] FAT-fs (sdc1): FAT read failed (blocknr 685)
[  112.427466] Buffer I/O error on device sdc1, logical block 13094017
[  112.427474] lost page write due to I/O error on sdc1
[  112.427744] FAT-fs (sdc1): FAT read failed (blocknr 685)
[  112.427832] FAT-fs (sdc1): unable to read inode block for updating (i_pos 209504275)
[  112.523097] BUG: unable to handle kernel paging request at 6b6b6c6f
[  112.523229] IP: [<b0157dbf>] __lock_acquire+0x23f/0x1740
[  112.523328] *pde = 00000000 
[  112.523381] Oops: 0002 [#1] DEBUG_PAGEALLOC
[  112.523459] 
[  112.523490] Pid: 1486, comm: nautilus Not tainted 3.1.0-rc4-00131-g9e79e3e-dirty #488 ASUSTeK Computer INC. 900/900
[  112.523665] EIP: 0060:[<b0157dbf>] EFLAGS: 00010002 CPU: 0
[  112.523751] EIP is at __lock_acquire+0x23f/0x1740
[  112.523826] EAX: 00000001 EBX: daa5b510 ECX: 6b6b6b6b EDX: 00000000
[  112.523922] ESI: 00000002 EDI: ee4f9e84 EBP: dae63d2c ESP: dae63cbc
[  112.524011]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[  112.524011] Process nautilus (pid: 1486, ti=dae62000 task=daa5b510 task.ti=dae62000)
[  112.524011] Stack:
[  112.524011]  dae63d38 00000246 b026be79 00000000 00160007 00000006 dc198958 00000282
[  112.524011]  daa5b528 daa5b950 b08ff1b0 00000000 b0afab18 00000001 00000000 000052d7
[  112.524011]  ee802280 ef513308 dc198e60 dc198958 00000282 dc198000 00160006 b0ca9414
[  112.524011] Call Trace:
[  112.524011]  [<b026be79>] ? kobject_release+0x49/0x90
[  112.524011]  [<b01597cb>] lock_acquire+0x7b/0x90
[  112.524011]  [<b0182b62>] ? bdi_lock_two+0x22/0x50
[  112.524011]  [<b055ef2a>] _raw_spin_lock_nested+0x3a/0x50
[  112.524011]  [<b0182b62>] ? bdi_lock_two+0x22/0x50
[  112.524011]  [<b0182b62>] bdi_lock_two+0x22/0x50
[  112.524011]  [<b01c7dde>] bdev_inode_switch_bdi+0x2e/0xa0
[  112.524011]  [<b01c8baf>] __blkdev_put+0xbf/0x160
[  112.524011]  [<b01c8be3>] __blkdev_put+0xf3/0x160
[  112.524011]  [<b01c8c92>] blkdev_put+0x42/0x120
[  112.524011]  [<b019d66f>] kill_block_super+0x3f/0x70
[  112.524011]  [<b019df1d>] deactivate_locked_super+0x3d/0x70
[  112.524011]  [<b019e890>] deactivate_super+0x50/0x70
[  112.524011]  [<b01b5a38>] mntput_no_expire+0x68/0xa0
[  112.524011]  [<b01b5a83>] mntput+0x13/0x30
[  112.524011]  [<b01a4525>] path_put+0x15/0x20
[  112.524011]  [<b01a574d>] terminate_walk+0x4d/0x60
[  112.524011]  [<b01a769f>] do_last+0x60f/0x6d0
[  112.524011]  [<b01a77f8>] path_openat+0x98/0x320
[  112.524011]  [<b0159317>] ? lock_release_non_nested+0x57/0x2e0
[  112.524011]  [<b01a7b60>] do_filp_open+0x30/0x80
[  112.524011]  [<b055f75d>] ? _raw_spin_unlock+0x1d/0x30
[  112.524011]  [<b01b404c>] ? alloc_fd+0xbc/0x100
[  112.524011]  [<b019ac61>] do_sys_open+0xf1/0x1c0
[  112.524011]  [<b019ad99>] sys_open+0x29/0x40
[  112.524011]  [<b055ff57>] sysenter_do_call+0x12/0x36
[  112.524011] Code: 83 3d 60 ed c6 b0 00 75 d3 b8 88 3c 65 b0 ba 77 0b 00 00 e8 14 0f fd ff 31 c0 eb c2 8b 45 c4 8b 4c 87 04 85 c9 0f 84 1c fe ff ff <ff> 81 04 01 00 00 a1 e4 d7 77 b0 8b 93 20 04 00 00 85 c0 89 55 
[  112.524011] EIP: [<b0157dbf>] __lock_acquire+0x23f/0x1740 SS:ESP 0068:dae63cbc
[  112.524011] CR2: 000000006b6b6c6f
[  112.524011] BUG: scheduling while atomic: nautilus/1486/0x10000003
[  112.524011] INFO: lockdep is turned off.
[  112.524011] irq event stamp: 140881
[  112.524011] hardirqs last  enabled at (140881): [<b0195405>] __slab_free+0x1d5/0x300
[  112.524011] hardirqs last disabled at (140880): [<b019533b>] __slab_free+0x10b/0x300
[  112.524011] softirqs last  enabled at (140830): [<b012e200>] __do_softirq+0xd0/0x130
[  112.524011] softirqs last disabled at (140819): [<b010419e>] do_softirq+0x7e/0xd0
[  112.524011] Pid: 1486, comm: nautilus Not tainted 3.1.0-rc4-00131-g9e79e3e-dirty #488
[  112.524011] Call Trace:
[  112.524011]  [<b01213ae>] __schedule_bug+0x6e/0x80
[  112.524011]  [<b055cf97>] schedule+0x547/0x640
[  112.524011]  [<b02aba2f>] ? bit_putcs+0x29f/0x410
[  112.524011]  [<b055d23f>] _cond_resched+0x2f/0x50
[  112.524011]  [<b055df86>] mutex_lock_nested+0x26/0x50
[  112.524011]  [<b02f9c36>] drm_fb_helper_pan_display+0x26/0xd0
[  112.524011]  [<b029dc48>] fb_pan_display+0x108/0x160
[  112.524011]  [<b02f9c10>] ? drm_fb_helper_fill_var+0x200/0x200
[  112.524011]  [<b02ab75d>] bit_update_start+0x1d/0x50
[  112.524011]  [<b02a7935>] fbcon_switch+0x375/0x540
[  112.524011]  [<b02ac0c2>] ? bit_cursor+0x522/0x5a0
[  112.524011]  [<b02ec9ee>] redraw_screen+0x12e/0x230
[  112.524011]  [<b02a74a9>] fbcon_blank+0x1d9/0x2f0
[  112.524011]  [<b0147732>] ? up+0x22/0x40
[  112.524011]  [<b01295f5>] ? console_unlock+0x1f5/0x260
[  112.524011]  [<b015534b>] ? trace_hardirqs_off+0xb/0x10
[  112.524011]  [<b055f737>] ? _raw_spin_unlock_irqrestore+0x57/0x60
[  112.524011]  [<b0285089>] ? debug_object_activate+0xc9/0x140
[  112.524011]  [<b015534b>] ? trace_hardirqs_off+0xb/0x10
[  112.524011]  [<b055f737>] ? _raw_spin_unlock_irqrestore+0x57/0x60
[  112.524011]  [<b01342d0>] ? mod_timer+0x100/0x1b0
[  112.524011]  [<b015534b>] ? trace_hardirqs_off+0xb/0x10
[  112.524011]  [<b055f737>] ? _raw_spin_unlock_irqrestore+0x57/0x60
[  112.524011]  [<b01342d0>] ? mod_timer+0x100/0x1b0
[  112.524011]  [<b02eda94>] do_unblank_screen+0xa4/0x1d0
[  112.524011]  [<b02edbca>] unblank_screen+0xa/0x10
[  112.524011]  [<b02755c5>] bust_spinlocks+0x15/0x30
[  112.524011]  [<b0105153>] oops_end+0x13/0x90
[  112.524011]  [<b055c80c>] ? printk+0x18/0x1a
[  112.524011]  [<b01197ae>] no_context+0xbe/0x150
[  112.524011]  [<b01198d8>] __bad_area_nosemaphore+0x98/0x140
[  112.524011]  [<b0119992>] bad_area_nosemaphore+0x12/0x20
[  112.524011]  [<b0119ee0>] do_page_fault+0x220/0x330
[  112.524011]  [<b01042bd>] ? dump_trace+0x7d/0xf0
[  112.524011]  [<b0157515>] ? mark_held_locks+0x65/0xf0
[  112.524011]  [<b0119cc0>] ? vmalloc_sync_all+0x120/0x120
[  112.524011]  [<b055fcc2>] error_code+0x6a/0x70
[  112.524011]  [<b0157dbf>] ? __lock_acquire+0x23f/0x1740
[  112.524011]  [<b026be79>] ? kobject_release+0x49/0x90
[  112.524011]  [<b01597cb>] lock_acquire+0x7b/0x90
[  112.524011]  [<b0182b62>] ? bdi_lock_two+0x22/0x50
[  112.524011]  [<b055ef2a>] _raw_spin_lock_nested+0x3a/0x50
[  112.524011]  [<b0182b62>] ? bdi_lock_two+0x22/0x50
[  112.524011]  [<b0182b62>] bdi_lock_two+0x22/0x50
[  112.524011]  [<b01c7dde>] bdev_inode_switch_bdi+0x2e/0xa0
[  112.524011]  [<b01c8baf>] __blkdev_put+0xbf/0x160
[  112.524011]  [<b01c8be3>] __blkdev_put+0xf3/0x160
[  112.524011]  [<b01c8c92>] blkdev_put+0x42/0x120
[  112.524011]  [<b019d66f>] kill_block_super+0x3f/0x70
[  112.524011]  [<b019df1d>] deactivate_locked_super+0x3d/0x70
[  112.524011]  [<b019e890>] deactivate_super+0x50/0x70
[  112.524011]  [<b01b5a38>] mntput_no_expire+0x68/0xa0
[  112.524011]  [<b01b5a83>] mntput+0x13/0x30
[  112.524011]  [<b01a4525>] path_put+0x15/0x20
[  112.524011]  [<b01a574d>] terminate_walk+0x4d/0x60
[  112.524011]  [<b01a769f>] do_last+0x60f/0x6d0
[  112.524011]  [<b01a77f8>] path_openat+0x98/0x320
[  112.524011]  [<b0159317>] ? lock_release_non_nested+0x57/0x2e0
[  112.524011]  [<b01a7b60>] do_filp_open+0x30/0x80
[  112.524011]  [<b055f75d>] ? _raw_spin_unlock+0x1d/0x30
[  112.524011]  [<b01b404c>] ? alloc_fd+0xbc/0x100
[  112.524011]  [<b019ac61>] do_sys_open+0xf1/0x1c0
[  112.524011]  [<b019ad99>] sys_open+0x29/0x40
[  112.524011]  [<b055ff57>] sysenter_do_call+0x12/0x36
[  112.714179] BUG: scheduling while atomic: nautilus/1486/0x10000003
[  112.715923] INFO: lockdep is turned off.
[  112.717530] Pid: 1486, comm: nautilus Not tainted 3.1.0-rc4-00131-g9e79e3e-dirty #488
[  112.719609] Call Trace:
[  112.721318]  [<b01213ae>] __schedule_bug+0x6e/0x80
[  112.723065]  [<b055cf97>] schedule+0x547/0x640
[  112.724806]  [<b02a5429>] ? get_color+0x29/0x130
[  112.726566]  [<b055d23f>] _cond_resched+0x2f/0x50
[  112.728298]  [<b055df86>] mutex_lock_nested+0x26/0x50
[  112.730047]  [<b02f9c36>] drm_fb_helper_pan_display+0x26/0xd0
[  112.731817]  [<b029dc48>] fb_pan_display+0x108/0x160
[  112.733593]  [<b02f9c10>] ? drm_fb_helper_fill_var+0x200/0x200
[  112.735420]  [<b02ab75d>] bit_update_start+0x1d/0x50
[  112.737226]  [<b02a7935>] fbcon_switch+0x375/0x540
[  112.739058]  [<b02ac0c2>] ? bit_cursor+0x522/0x5a0
[  112.740862]  [<b02ec9ee>] redraw_screen+0x12e/0x230
[  112.742672]  [<b0134201>] ? mod_timer+0x31/0x1b0
[  112.744487]  [<b02edb6c>] do_unblank_screen+0x17c/0x1d0
[  112.746315]  [<b02edbca>] unblank_screen+0xa/0x10
[  112.748426]  [<b02755c5>] bust_spinlocks+0x15/0x30
[  112.750328]  [<b0105153>] oops_end+0x13/0x90
[  112.752201]  [<b055c80c>] ? printk+0x18/0x1a
[  112.754086]  [<b01197ae>] no_context+0xbe/0x150
[  112.755959]  [<b01198d8>] __bad_area_nosemaphore+0x98/0x140
[  112.757862]  [<b0119992>] bad_area_nosemaphore+0x12/0x20
[  112.759782]  [<b0119ee0>] do_page_fault+0x220/0x330
[  112.761731]  [<b01042bd>] ? dump_trace+0x7d/0xf0
[  112.763669]  [<b0157515>] ? mark_held_locks+0x65/0xf0
[  112.765611]  [<b0119cc0>] ? vmalloc_sync_all+0x120/0x120
[  112.767584]  [<b055fcc2>] error_code+0x6a/0x70
[  112.769537]  [<b0157dbf>] ? __lock_acquire+0x23f/0x1740
[  112.771510]  [<b026be79>] ? kobject_release+0x49/0x90
[  112.773483]  [<b01597cb>] lock_acquire+0x7b/0x90
[  112.775451]  [<b0182b62>] ? bdi_lock_two+0x22/0x50
[  112.777465]  [<b055ef2a>] _raw_spin_lock_nested+0x3a/0x50
[  112.779468]  [<b0182b62>] ? bdi_lock_two+0x22/0x50
[  112.781477]  [<b0182b62>] bdi_lock_two+0x22/0x50
[  112.783478]  [<b01c7dde>] bdev_inode_switch_bdi+0x2e/0xa0
[  112.785440]  [<b01c8baf>] __blkdev_put+0xbf/0x160
[  112.787361]  [<b01c8be3>] __blkdev_put+0xf3/0x160
[  112.789192]  [<b01c8c92>] blkdev_put+0x42/0x120
[  112.791021]  [<b019d66f>] kill_block_super+0x3f/0x70
[  112.792860]  [<b019df1d>] deactivate_locked_super+0x3d/0x70
[  112.794713]  [<b019e890>] deactivate_super+0x50/0x70
[  112.796559]  [<b01b5a38>] mntput_no_expire+0x68/0xa0
[  112.798399]  [<b01b5a83>] mntput+0x13/0x30
[  112.800225]  [<b01a4525>] path_put+0x15/0x20
[  112.802018]  [<b01a574d>] terminate_walk+0x4d/0x60
[  112.803791]  [<b01a769f>] do_last+0x60f/0x6d0
[  112.805546]  [<b01a77f8>] path_openat+0x98/0x320
[  112.807312]  [<b0159317>] ? lock_release_non_nested+0x57/0x2e0
[  112.809105]  [<b01a7b60>] do_filp_open+0x30/0x80
[  112.810922]  [<b055f75d>] ? _raw_spin_unlock+0x1d/0x30
[  112.812755]  [<b01b404c>] ? alloc_fd+0xbc/0x100
[  112.814545]  [<b019ac61>] do_sys_open+0xf1/0x1c0
[  112.816341]  [<b019ad99>] sys_open+0x29/0x40
[  112.818138]  [<b055ff57>] sysenter_do_call+0x12/0x36
[  112.832789] ---[ end trace c920879a71b7788e ]---
[  112.832801] note: nautilus[1486] exited with preempt_count 2
[  112.832809] BUG: sleeping function called from invalid context at mm/memory.c:3905
[  112.832898] in_atomic(): 1, irqs_disabled(): 0, pid: 1486, name: nautilus
[  112.832903] INFO: lockdep is turned off.
[  112.832912] Pid: 1486, comm: nautilus Tainted: G      D     3.1.0-rc4-00131-g9e79e3e-dirty #488
[  112.832918] Call Trace:
[  112.832933]  [<b0120f04>] __might_sleep+0xd4/0x100
[  112.832944]  [<b0184dd5>] might_fault+0x25/0xa0
[  112.832955]  [<b015bfa5>] exit_robust_list+0x35/0x140
[  112.832964]  [<b0126fae>] mm_release+0xce/0xe0
[  112.832973]  [<b0136c15>] ? exit_signals+0x65/0xe0
[  112.832982]  [<b012a9a8>] exit_mm+0x18/0x100
[  112.832990]  [<b012b557>] do_exit+0xd7/0x660
[  112.832998]  [<b012928f>] ? kmsg_dump+0xdf/0x120
[  112.833018]  [<b012920c>] ? kmsg_dump+0x5c/0x120
[  112.833028]  [<b01051ad>] oops_end+0x6d/0x90
[  112.833039]  [<b055c80c>] ? printk+0x18/0x1a
[  112.833048]  [<b01197ae>] no_context+0xbe/0x150
[  112.833056]  [<b01198d8>] __bad_area_nosemaphore+0x98/0x140
[  112.833065]  [<b0119992>] bad_area_nosemaphore+0x12/0x20
[  112.833073]  [<b0119ee0>] do_page_fault+0x220/0x330
[  112.833081]  [<b01042bd>] ? dump_trace+0x7d/0xf0
[  112.833090]  [<b0157515>] ? mark_held_locks+0x65/0xf0
[  112.833098]  [<b0119cc0>] ? vmalloc_sync_all+0x120/0x120
[  112.833107]  [<b055fcc2>] error_code+0x6a/0x70
[  112.833115]  [<b0157dbf>] ? __lock_acquire+0x23f/0x1740
[  112.833125]  [<b026be79>] ? kobject_release+0x49/0x90
[  112.833134]  [<b01597cb>] lock_acquire+0x7b/0x90
[  112.833142]  [<b0182b62>] ? bdi_lock_two+0x22/0x50
[  112.833151]  [<b055ef2a>] _raw_spin_lock_nested+0x3a/0x50
[  112.833159]  [<b0182b62>] ? bdi_lock_two+0x22/0x50
[  112.833168]  [<b0182b62>] bdi_lock_two+0x22/0x50
[  112.833177]  [<b01c7dde>] bdev_inode_switch_bdi+0x2e/0xa0
[  112.833185]  [<b01c8baf>] __blkdev_put+0xbf/0x160
[  112.833193]  [<b01c8be3>] __blkdev_put+0xf3/0x160
[  112.833200]  [<b01c8c92>] blkdev_put+0x42/0x120
[  112.833210]  [<b019d66f>] kill_block_super+0x3f/0x70
[  112.833219]  [<b019df1d>] deactivate_locked_super+0x3d/0x70
[  112.833227]  [<b019e890>] deactivate_super+0x50/0x70
[  112.833237]  [<b01b5a38>] mntput_no_expire+0x68/0xa0
[  112.833245]  [<b01b5a83>] mntput+0x13/0x30
[  112.833253]  [<b01a4525>] path_put+0x15/0x20
[  112.833261]  [<b01a574d>] terminate_walk+0x4d/0x60
[  112.833268]  [<b01a769f>] do_last+0x60f/0x6d0
[  112.833276]  [<b01a77f8>] path_openat+0x98/0x320
[  112.833285]  [<b0159317>] ? lock_release_non_nested+0x57/0x2e0
[  112.833293]  [<b01a7b60>] do_filp_open+0x30/0x80
[  112.833301]  [<b055f75d>] ? _raw_spin_unlock+0x1d/0x30
[  112.833309]  [<b01b404c>] ? alloc_fd+0xbc/0x100
[  112.833317]  [<b019ac61>] do_sys_open+0xf1/0x1c0
[  112.833325]  [<b019ad99>] sys_open+0x29/0x40
[  112.833333]  [<b055ff57>] sysenter_do_call+0x12/0x36
[  112.833341] BUG: scheduling while atomic: nautilus/1486/0x10000003
[  112.833345] INFO: lockdep is turned off.
[  112.833352] Pid: 1486, comm: nautilus Tainted: G      D     3.1.0-rc4-00131-g9e79e3e-dirty #488
[  112.833357] Call Trace:
[  112.833365]  [<b01213ae>] __schedule_bug+0x6e/0x80
[  112.833373]  [<b055cf97>] schedule+0x547/0x640
[  112.833381]  [<b0105327>] ? show_trace_log_lvl+0x47/0x60
[  112.833390]  [<b010535b>] ? show_trace+0x1b/0x30
[  112.833398]  [<b055c68f>] ? dump_stack+0x6e/0x76
[  112.833406]  [<b0120f04>] ? __might_sleep+0xd4/0x100
[  112.833414]  [<b055d23f>] _cond_resched+0x2f/0x50
[  112.833422]  [<b0184dda>] might_fault+0x2a/0xa0
[  112.833431]  [<b015bfa5>] exit_robust_list+0x35/0x140
[  112.833439]  [<b0126fae>] mm_release+0xce/0xe0
[  112.833447]  [<b0136c15>] ? exit_signals+0x65/0xe0
[  112.833455]  [<b012a9a8>] exit_mm+0x18/0x100
[  112.833464]  [<b012b557>] do_exit+0xd7/0x660
[  112.833472]  [<b012928f>] ? kmsg_dump+0xdf/0x120
[  112.833480]  [<b012920c>] ? kmsg_dump+0x5c/0x120
[  112.833488]  [<b01051ad>] oops_end+0x6d/0x90
[  112.833496]  [<b055c80c>] ? printk+0x18/0x1a
[  112.833504]  [<b01197ae>] no_context+0xbe/0x150
[  112.833512]  [<b01198d8>] __bad_area_nosemaphore+0x98/0x140
[  112.833521]  [<b0119992>] bad_area_nosemaphore+0x12/0x20
[  112.833529]  [<b0119ee0>] do_page_fault+0x220/0x330
[  112.833537]  [<b01042bd>] ? dump_trace+0x7d/0xf0
[  112.833545]  [<b0157515>] ? mark_held_locks+0x65/0xf0
[  112.833554]  [<b0119cc0>] ? vmalloc_sync_all+0x120/0x120
[  112.833561]  [<b055fcc2>] error_code+0x6a/0x70
[  112.833570]  [<b0157dbf>] ? __lock_acquire+0x23f/0x1740
[  112.833578]  [<b026be79>] ? kobject_release+0x49/0x90
[  112.833587]  [<b01597cb>] lock_acquire+0x7b/0x90
[  112.833595]  [<b0182b62>] ? bdi_lock_two+0x22/0x50
[  112.833604]  [<b055ef2a>] _raw_spin_lock_nested+0x3a/0x50
[  112.833612]  [<b0182b62>] ? bdi_lock_two+0x22/0x50
[  112.833620]  [<b0182b62>] bdi_lock_two+0x22/0x50
[  112.833628]  [<b01c7dde>] bdev_inode_switch_bdi+0x2e/0xa0
[  112.833636]  [<b01c8baf>] __blkdev_put+0xbf/0x160
[  112.833644]  [<b01c8be3>] __blkdev_put+0xf3/0x160
[  112.833652]  [<b01c8c92>] blkdev_put+0x42/0x120
[  112.833660]  [<b019d66f>] kill_block_super+0x3f/0x70
[  112.833669]  [<b019df1d>] deactivate_locked_super+0x3d/0x70
[  112.833678]  [<b019e890>] deactivate_super+0x50/0x70
[  112.833686]  [<b01b5a38>] mntput_no_expire+0x68/0xa0
[  112.833694]  [<b01b5a83>] mntput+0x13/0x30
[  112.833702]  [<b01a4525>] path_put+0x15/0x20
[  112.833709]  [<b01a574d>] terminate_walk+0x4d/0x60
[  112.833717]  [<b01a769f>] do_last+0x60f/0x6d0
[  112.833725]  [<b01a77f8>] path_openat+0x98/0x320
[  112.833733]  [<b0159317>] ? lock_release_non_nested+0x57/0x2e0
[  112.833742]  [<b01a7b60>] do_filp_open+0x30/0x80
[  112.833750]  [<b055f75d>] ? _raw_spin_unlock+0x1d/0x30
[  112.833758]  [<b01b404c>] ? alloc_fd+0xbc/0x100
[  112.833766]  [<b019ac61>] do_sys_open+0xf1/0x1c0
[  112.833774]  [<b019ad99>] sys_open+0x29/0x40
[  112.833781]  [<b055ff57>] sysenter_do_call+0x12/0x36
[  118.372745] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id

-- 
Sitsofe | http://sucs.org/~sits/
