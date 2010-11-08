Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab0KHRC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 12:02:28 -0500
Received: from smtp-out-096.synserver.de ([212.40.180.96]:1045 "EHLO
	smtp-out-091.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752747Ab0KHRC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 12:02:27 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 9584
Date: Mon, 8 Nov 2010 18:02:21 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, airlied@linux.ie
Subject: Radeon RS780 - BUG: unable to handle kernel NULL pointer
 dereference
Message-ID: <20101108170221.GA1602@arch.trippelsdorf.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I can trigger a kernel crash on my system by simply loading this png
image with firefox:
http://mediaarchive.cern.ch/MediaArchive/Photo/Public/2010/1011251/1011251_01/1011251_01-A4-at-144-dpi.jpg

The system has an embedded RS780 and is running the latest git kernel. 
(Xorg.0.log is attached)

The crash looks as follows:

Nov  8 17:37:21 arch kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
Nov  8 17:37:21 arch kernel: IP: [<ffffffff81449f1f>] _raw_write_lock+0xf/0x20
Nov  8 17:37:21 arch kernel: PGD 11bf20067 PUD 11bfa7067 PMD 0
Nov  8 17:37:21 arch kernel: Oops: 0002 [#1] PREEMPT SMP
Nov  8 17:37:21 arch kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:18.3/temp1_input
Nov  8 17:37:21 arch kernel: CPU 0
Nov  8 17:37:21 arch kernel: Pid: 1502, comm: X Not tainted 2.6.37-rc1-00116-g151f52f-dirty #31 M4A78T-E/System Product Name
Nov  8 17:37:21 arch kernel: RIP: 0010:[<ffffffff81449f1f>]  [<ffffffff81449f1f>] _raw_write_lock+0xf/0x20
Nov  8 17:37:21 arch kernel: RSP: 0018:ffff88011b523cc0  EFLAGS: 00010202
Nov  8 17:37:21 arch kernel: RAX: ffff88011b523fd8 RBX: 0000000000000020 RCX: 00000000ffffffff
Nov  8 17:37:22 arch kernel: RDX: 00000000ffffffff RSI: ffffffff8120a6f0 RDI: 0000000000000020
Nov  8 17:37:22 arch kernel: RBP: ffff880113f39c48 R08: 0000000000000006 R09: 0000000000000006
Nov  8 17:37:22 arch kernel: R10: 0000000000000006 R11: 0000000000000006 R12: 0000000000000071
Nov  8 17:37:22 arch kernel: R13: ffff8800c07ffb40 R14: 0000000040086409 R15: 00000000fffffff2
Nov  8 17:37:22 arch kernel: FS:  00007f3786cdc700(0000) GS:ffff8800dfc00000(0000) knlGS:0000000000000000
Nov  8 17:37:22 arch kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Nov  8 17:37:22 arch kernel: CR2: 0000000000000020 CR3: 000000011f60a000 CR4: 00000000000006f0
Nov  8 17:37:22 arch kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov  8 17:37:22 arch kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov  8 17:37:22 arch kernel: Process X (pid: 1502, threadinfo ffff88011b522000, task ffff88011cc3d460)
Nov  8 17:37:22 arch kernel: Stack:
Nov  8 17:37:22 arch kernel: ffffffff8121cbb8 0000000000000292 ffff88011ffabbc0 ffff88011b523d20
Nov  8 17:37:22 arch kernel: ffffffff81252a92 0000000000000296 0000000000000000 ffff88011d9410a8
Nov  8 17:37:22 arch kernel: ffff8800c07ffb40 ffffffff8120a6f0 ffffffff8126711e ffff88011f632a90
Nov  8 17:37:22 arch kernel: Call Trace:
Nov  8 17:37:22 arch kernel: [<ffffffff8121cbb8>] ? ttm_bo_unref+0x28/0x50
Nov  8 17:37:22 arch kernel: [<ffffffff81252a92>] ? radeon_bo_unref+0x42/0x80
Nov  8 17:37:22 arch kernel: [<ffffffff8120a6f0>] ? drm_gem_object_free+0x0/0x30
Nov  8 17:37:22 arch kernel: [<ffffffff8126711e>] ? radeon_gem_object_free+0x2e/0x50
Nov  8 17:37:22 arch kernel: [<ffffffff81183493>] ? kref_put+0x33/0x70
Nov  8 17:37:22 arch kernel: [<ffffffff8120aeb0>] ? drm_gem_close_ioctl+0xc0/0xf0
Nov  8 17:37:22 arch kernel: [<ffffffff8120963c>] ? drm_ioctl+0x39c/0x450
Nov  8 17:37:22 arch kernel: [<ffffffff8120adf0>] ? drm_gem_close_ioctl+0x0/0xf0
Nov  8 17:37:22 arch kernel: [<ffffffff810cd80f>] ? do_sync_read+0xbf/0x100
Nov  8 17:37:22 arch kernel: [<ffffffff810dd2c9>] ? do_vfs_ioctl+0xa9/0x610
Nov  8 17:37:22 arch kernel: [<ffffffff810dd879>] ? sys_ioctl+0x49/0x80
Nov  8 17:37:22 arch kernel: [<ffffffff810ce24e>] ? sys_read+0x4e/0x90
Nov  8 17:37:22 arch kernel: [<ffffffff8102dc2b>] ? system_call_fastpath+0x16/0x1b
Nov  8 17:37:22 arch kernel: Code: 83 c4 08 c3 e8 f3 dd ff ff 31 c0 eb f2 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 65 48 8b 04 25 c8 b6 00 00 ff 80 44 e0 ff ff <f0> 81 2f 00 00 00 01 74 05 e8 83 ff d3 ff c3 66 90 9c 58 fa 65
Nov  8 17:37:22 arch kernel: RIP  [<ffffffff81449f1f>] _raw_write_lock+0xf/0x20
Nov  8 17:37:22 arch kernel: RSP <ffff88011b523cc0>
Nov  8 17:37:22 arch kernel: CR2: 0000000000000020
Nov  8 17:37:22 arch kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000088
Nov  8 17:37:22 arch kernel: IP: [<ffffffff81449b84>] _raw_spin_lock+0x14/0x30
Nov  8 17:37:22 arch kernel: PGD 11bf20067 PUD 11bfa7067 PMD 0
Nov  8 17:37:22 arch kernel: Oops: 0002 [#2] PREEMPT SMP
Nov  8 17:37:22 arch kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:18.3/temp1_input
Nov  8 17:37:22 arch kernel: CPU 0
Nov  8 17:37:22 arch kernel: Pid: 1502, comm: X Not tainted 2.6.37-rc1-00116-g151f52f-dirty #31 M4A78T-E/System Product Name
Nov  8 17:37:22 arch kernel: RIP: 0010:[<ffffffff81449b84>]  [<ffffffff81449b84>] _raw_spin_lock+0x14/0x30
Nov  8 17:37:22 arch kernel: RSP: 0018:ffff88011b523660  EFLAGS: 00010002
Nov  8 17:37:22 arch kernel: RAX: 0000000000000100 RBX: ffff88011ff2c048 RCX: 0000000000000000
Nov  8 17:37:22 arch kernel: RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000088
Nov  8 17:37:22 arch kernel: RBP: 0000000000000088 R08: 0000000000000000 R09: ffffffff816a0a00
Nov  8 17:37:22 arch kernel: R10: 0000000000000000 R11: 0000000000000002 R12: 0000000000000001
Nov  8 17:37:22 arch kernel: R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Nov  8 17:37:22 arch kernel: FS:  00007f3786cdc700(0000) GS:ffff8800dfc00000(0000) knlGS:0000000000000000
Nov  8 17:37:22 arch kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Nov  8 17:37:22 arch kernel: CR2: 0000000000000088 CR3: 000000011f60a000 CR4: 00000000000006f0
Nov  8 17:37:22 arch kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov  8 17:37:22 arch kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov  8 17:37:22 arch kernel: Process X (pid: 1502, threadinfo ffff88011b522000, task ffff88011cc3d460)
Nov  8 17:37:22 arch kernel: Stack:
Nov  8 17:37:22 arch kernel: ffffffff8121c97f 0000000000000000 ffff880100000000 ffff88011ffaa000
Nov  8 17:37:22 arch kernel: ffff88011ff99000 ffff88011f67beb8 ffff88011ff2c000 ffff88011fcf6cc0
Nov  8 17:37:22 arch kernel: ffffffff8124540c ffffffff00000028 ffff88011b523708 ffff88011ff2c048
Nov  8 17:37:22 arch kernel: Call Trace:
Nov  8 17:37:22 arch kernel: [<ffffffff8121c97f>] ? ttm_bo_reserve+0x2f/0x120
Nov  8 17:37:22 arch kernel: [<ffffffff8124540c>] ? avivo_crtc_do_set_base+0x6c/0x8e0
Nov  8 17:37:22 arch kernel: [<ffffffff812044da>] ? drm_crtc_helper_set_config+0x72a/0x8c0
Nov  8 17:37:22 arch kernel: [<ffffffff812027f4>] ? drm_fb_helper_pan_display+0x84/0xc0
Nov  8 17:37:22 arch kernel: [<ffffffff8119efad>] ? fb_pan_display+0xad/0x140
Nov  8 17:37:22 arch kernel: [<ffffffff811b1d85>] ? ccw_update_start+0x45/0x70
Nov  8 17:37:22 arch kernel: [<ffffffff811abdbd>] ? fbcon_switch+0x44d/0x5f0
Nov  8 17:37:22 arch kernel: [<ffffffff811f6961>] ? redraw_screen+0x181/0x270
Nov  8 17:37:22 arch kernel: [<ffffffff811aa652>] ? fbcon_blank+0x232/0x2e0
Nov  8 17:37:22 arch kernel: [<ffffffff8105d6b7>] ? release_console_sem+0x1a7/0x1f0
Nov  8 17:37:22 arch kernel: [<ffffffff81447163>] ? printk+0x40/0x45
Nov  8 17:37:22 arch kernel: [<ffffffff81067f93>] ? lock_timer_base.clone.25+0x33/0x70
Nov  8 17:37:22 arch kernel: [<ffffffff810683d0>] ? mod_timer+0x130/0x210
Nov  8 17:37:22 arch kernel: [<ffffffff811f8136>] ? do_unblank_screen+0xa6/0x1a0
Nov  8 17:37:22 arch kernel: [<ffffffff8118ad0d>] ? bust_spinlocks+0x1d/0x40
Nov  8 17:37:22 arch kernel: [<ffffffff81031f79>] ? oops_end+0x39/0xe0
Nov  8 17:37:22 arch kernel: [<ffffffff8104aae5>] ? no_context+0xf5/0x260
Nov  8 17:37:22 arch kernel: [<ffffffff810ddf50>] ? __pollwait+0x0/0x110
Nov  8 17:37:22 arch kernel: [<ffffffff8104b41e>] ? do_page_fault+0x36e/0x410
Nov  8 17:37:22 arch kernel: [<ffffffff810de060>] ? pollwake+0x0/0x60
Nov  8 17:37:22 arch kernel: [<ffffffff810de060>] ? pollwake+0x0/0x60
Nov  8 17:37:22 arch kernel: [<ffffffff813ae4aa>] ? sock_wfree+0x4a/0x60
Nov  8 17:37:22 arch kernel: [<ffffffff81430323>] ? unix_destruct_scm+0x93/0xb0
Nov  8 17:37:22 arch kernel: [<ffffffff8144a40f>] ? page_fault+0x1f/0x30
Nov  8 17:37:22 arch kernel: [<ffffffff8120a6f0>] ? drm_gem_object_free+0x0/0x30
Nov  8 17:37:22 arch kernel: [<ffffffff81449f1f>] ? _raw_write_lock+0xf/0x20
Nov  8 17:37:22 arch kernel: [<ffffffff8121cbb8>] ? ttm_bo_unref+0x28/0x50
Nov  8 17:37:22 arch kernel: [<ffffffff81252a92>] ? radeon_bo_unref+0x42/0x80
Nov  8 17:37:22 arch kernel: [<ffffffff8120a6f0>] ? drm_gem_object_free+0x0/0x30
Nov  8 17:37:22 arch kernel: [<ffffffff8126711e>] ? radeon_gem_object_free+0x2e/0x50
Nov  8 17:37:22 arch kernel: [<ffffffff81183493>] ? kref_put+0x33/0x70
Nov  8 17:37:22 arch kernel: [<ffffffff8120aeb0>] ? drm_gem_close_ioctl+0xc0/0xf0
Nov  8 17:37:22 arch kernel: [<ffffffff8120963c>] ? drm_ioctl+0x39c/0x450
Nov  8 17:37:22 arch kernel: [<ffffffff8120adf0>] ? drm_gem_close_ioctl+0x0/0xf0
Nov  8 17:37:22 arch kernel: [<ffffffff810cd80f>] ? do_sync_read+0xbf/0x100
Nov  8 17:37:22 arch kernel: [<ffffffff810dd2c9>] ? do_vfs_ioctl+0xa9/0x610
Nov  8 17:37:22 arch kernel: [<ffffffff810dd879>] ? sys_ioctl+0x49/0x80
Nov  8 17:37:22 arch kernel: [<ffffffff810ce24e>] ? sys_read+0x4e/0x90
Nov  8 17:37:22 arch kernel: [<ffffffff8102dc2b>] ? system_call_fastpath+0x16/0x1b
Nov  8 17:37:22 arch kernel: Code: 4a 1c 48 8b 7c 24 08 e8 2b 85 c1 ff 31 c0 5b c3 0f 1f 80 00 00 00 00 65 48 8b 04 25 c8 b6 00 00 ff 80 44 e0 ff ff b8 00 01 00 00 <f0> 66 0f c1 07 38 e0 74 06 f3 90 8a 07 eb f6 c3 66 66 66 2e 0f
Nov  8 17:37:22 arch kernel: RIP  [<ffffffff81449b84>] _raw_spin_lock+0x14/0x30
Nov  8 17:37:22 arch kernel: RSP <ffff88011b523660>
Nov  8 17:37:22 arch kernel: CR2: 0000000000000088
Nov  8 17:37:22 arch kernel: ---[ end trace f7be0a67c5c584c7 ]---
Nov  8 17:37:22 arch kernel: note: X[1502] exited with preempt_count 2
Nov  8 17:37:22 arch kernel: BUG: scheduling while atomic: X/1502/0x10000003
Nov  8 17:37:22 arch kernel: Pid: 1502, comm: X Tainted: G      D     2.6.37-rc1-00116-g151f52f-dirty #31
Nov  8 17:37:22 arch kernel: Call Trace:
Nov  8 17:37:22 arch kernel: [<ffffffff81447ad9>] ? schedule+0x639/0x850
Nov  8 17:37:22 arch kernel: [<ffffffff8105826d>] ? __cond_resched+0x1d/0x30
Nov  8 17:37:22 arch kernel: [<ffffffff81447f2f>] ? _cond_resched+0x2f/0x40
Nov  8 17:37:22 arch kernel: [<ffffffff810b57fc>] ? unmap_vmas+0x82c/0x9c0
Nov  8 17:37:22 arch kernel: [<ffffffff810bcb62>] ? exit_mmap+0xe2/0x1a0
Nov  8 17:37:22 arch kernel: [<ffffffff8105a705>] ? mmput+0x25/0xc0
Nov  8 17:37:22 arch kernel: [<ffffffff8105e734>] ? exit_mm+0x104/0x130
Nov  8 17:37:22 arch kernel: [<ffffffff81449ca0>] ? _raw_spin_unlock_irq+0x10/0x30
Nov  8 17:37:22 arch kernel: [<ffffffff8106045a>] ? do_exit+0x5aa/0x760
Nov  8 17:37:22 arch kernel: [<ffffffff81447163>] ? printk+0x40/0x45
Nov  8 17:37:22 arch kernel: [<ffffffff8105e33c>] ? kmsg_dump+0x7c/0x150
Nov  8 17:37:22 arch kernel: [<ffffffff81031fda>] ? oops_end+0x9a/0xe0
Nov  8 17:37:22 arch kernel: [<ffffffff8104aae5>] ? no_context+0xf5/0x260
Nov  8 17:37:22 arch kernel: [<ffffffff8104b41e>] ? do_page_fault+0x36e/0x410
Nov  8 17:37:22 arch kernel: [<ffffffff8102c722>] ? __switch_to+0x1e2/0x2b0
Nov  8 17:37:22 arch kernel: [<ffffffff8118885e>] ? vsnprintf+0x46e/0x620
Nov  8 17:37:22 arch kernel: [<ffffffff81187957>] ? number.clone.2+0x2b7/0x2f0
Nov  8 17:37:22 arch kernel: [<ffffffff8144a40f>] ? page_fault+0x1f/0x30
Nov  8 17:37:22 arch kernel: [<ffffffff81449b84>] ? _raw_spin_lock+0x14/0x30
Nov  8 17:37:22 arch kernel: [<ffffffff8121c97f>] ? ttm_bo_reserve+0x2f/0x120
Nov  8 17:37:22 arch kernel: [<ffffffff8124540c>] ? avivo_crtc_do_set_base+0x6c/0x8e0
Nov  8 17:37:22 arch kernel: [<ffffffff812044da>] ? drm_crtc_helper_set_config+0x72a/0x8c0
Nov  8 17:37:22 arch kernel: [<ffffffff812027f4>] ? drm_fb_helper_pan_display+0x84/0xc0
Nov  8 17:37:22 arch kernel: [<ffffffff8119efad>] ? fb_pan_display+0xad/0x140
Nov  8 17:37:22 arch kernel: [<ffffffff811b1d85>] ? ccw_update_start+0x45/0x70
Nov  8 17:37:22 arch kernel: [<ffffffff811abdbd>] ? fbcon_switch+0x44d/0x5f0
Nov  8 17:37:22 arch kernel: [<ffffffff811f6961>] ? redraw_screen+0x181/0x270
Nov  8 17:37:22 arch kernel: [<ffffffff811aa652>] ? fbcon_blank+0x232/0x2e0
Nov  8 17:37:22 arch kernel: [<ffffffff8105d6b7>] ? release_console_sem+0x1a7/0x1f0
Nov  8 17:37:22 arch kernel: [<ffffffff81447163>] ? printk+0x40/0x45
Nov  8 17:37:22 arch kernel: [<ffffffff81067f93>] ? lock_timer_base.clone.25+0x33/0x70
Nov  8 17:37:22 arch kernel: [<ffffffff810683d0>] ? mod_timer+0x130/0x210
Nov  8 17:37:22 arch kernel: [<ffffffff811f8136>] ? do_unblank_screen+0xa6/0x1a0
Nov  8 17:37:22 arch kernel: [<ffffffff8118ad0d>] ? bust_spinlocks+0x1d/0x40
Nov  8 17:37:22 arch kernel: [<ffffffff81031f79>] ? oops_end+0x39/0xe0
Nov  8 17:37:22 arch kernel: [<ffffffff8104aae5>] ? no_context+0xf5/0x260
Nov  8 17:37:22 arch kernel: [<ffffffff810ddf50>] ? __pollwait+0x0/0x110
Nov  8 17:37:22 arch kernel: [<ffffffff8104b41e>] ? do_page_fault+0x36e/0x410
Nov  8 17:37:22 arch kernel: [<ffffffff810de060>] ? pollwake+0x0/0x60
Nov  8 17:37:22 arch kernel: [<ffffffff810de060>] ? pollwake+0x0/0x60
Nov  8 17:37:22 arch kernel: [<ffffffff813ae4aa>] ? sock_wfree+0x4a/0x60
Nov  8 17:37:22 arch kernel: [<ffffffff81430323>] ? unix_destruct_scm+0x93/0xb0
Nov  8 17:37:22 arch kernel: [<ffffffff8144a40f>] ? page_fault+0x1f/0x30
Nov  8 17:37:22 arch kernel: [<ffffffff8120a6f0>] ? drm_gem_object_free+0x0/0x30
Nov  8 17:37:22 arch kernel: [<ffffffff81449f1f>] ? _raw_write_lock+0xf/0x20
Nov  8 17:37:22 arch kernel: [<ffffffff8121cbb8>] ? ttm_bo_unref+0x28/0x50
Nov  8 17:37:22 arch kernel: [<ffffffff81252a92>] ? radeon_bo_unref+0x42/0x80
Nov  8 17:37:22 arch kernel: [<ffffffff8120a6f0>] ? drm_gem_object_free+0x0/0x30
Nov  8 17:37:22 arch kernel: [<ffffffff8126711e>] ? radeon_gem_object_free+0x2e/0x50
Nov  8 17:37:22 arch kernel: [<ffffffff81183493>] ? kref_put+0x33/0x70
Nov  8 17:37:22 arch kernel: [<ffffffff8120aeb0>] ? drm_gem_close_ioctl+0xc0/0xf0
Nov  8 17:37:22 arch kernel: [<ffffffff8120963c>] ? drm_ioctl+0x39c/0x450
Nov  8 17:37:22 arch kernel: [<ffffffff8120adf0>] ? drm_gem_close_ioctl+0x0/0xf0
Nov  8 17:37:22 arch kernel: [<ffffffff810cd80f>] ? do_sync_read+0xbf/0x100
Nov  8 17:37:22 arch kernel: [<ffffffff810dd2c9>] ? do_vfs_ioctl+0xa9/0x610
Nov  8 17:37:22 arch kernel: [<ffffffff810dd879>] ? sys_ioctl+0x49/0x80
Nov  8 17:37:22 arch kernel: [<ffffffff810ce24e>] ? sys_read+0x4e/0x90
Nov  8 17:37:22 arch kernel: [<ffffffff8102dc2b>] ? system_call_fastpath+0x16/0x1b


-- 
Markus

--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="Xorg.0.log"

[     6.482] 
X.Org X Server 1.9.2
Release Date: 2010-10-30
[     6.483] X Protocol Version 11, Revision 0
[     6.483] Build Operating System: Linux 2.6.35-ARCH x86_64 
[     6.483] Current Operating System: Linux arch.trippelsdorf.de 2.6.37-rc1-00116-g151f52f-dirty #31 SMP PREEMPT Sat Nov 6 04:07:34 CET 2010 x86_64
[     6.483] Kernel command line: BOOT_IMAGE=/usr/src/linux/arch/x86/boot/bzImage root=/dev/sdb2 fbcon=rotate:3 drm_kms_helper.poll=0 quiet
[     6.483] Build Date: 01 November 2010  10:29:19PM
[     6.483]  
[     6.483] Current version of pixman: 0.20.0
[     6.483] 	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
[     6.484] Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[     6.484] (==) Log file: "/var/log/Xorg.0.log", Time: Mon Nov  8 17:44:24 2010
[     6.487] (==) Using config file: "/etc/X11/xorg.conf"
[     6.487] (==) Using config directory: "/etc/X11/xorg.conf.d"
[     6.489] (==) No Layout section.  Using the first Screen section.
[     6.489] (==) No screen section available. Using defaults.
[     6.489] (**) |-->Screen "Default Screen Section" (0)
[     6.489] (**) |   |-->Monitor "<default monitor>"
[     6.489] (==) No device specified for screen "Default Screen Section".
	Using the first device section listed.
[     6.489] (**) |   |-->Device "devname"
[     6.489] (==) No monitor specified for screen "Default Screen Section".
	Using a default monitor configuration.
[     6.489] (**) Option "DontZap" "no"
[     6.489] (==) Automatically adding devices
[     6.489] (==) Automatically enabling devices
[     6.493] (WW) The directory "/usr/share/fonts/OTF/" does not exist.
[     6.493] 	Entry deleted from font path.
[     6.494] (==) FontPath set to:
	/usr/share/fonts/misc/,
	/usr/share/fonts/TTF/,
	/usr/share/fonts/Type1/,
	/usr/share/fonts/100dpi/,
	/usr/share/fonts/75dpi/
[     6.494] (==) ModulePath set to "/usr/lib/xorg/modules"
[     6.494] (II) The server relies on udev to provide the list of input devices.
	If no devices become available, reconfigure udev or disable AutoAddDevices.
[     6.494] (II) Loader magic: 0x7d3360
[     6.494] (II) Module ABI versions:
[     6.494] 	X.Org ANSI C Emulation: 0.4
[     6.494] 	X.Org Video Driver: 8.0
[     6.494] 	X.Org XInput driver : 11.0
[     6.494] 	X.Org Server Extension : 4.0
[     6.495] (--) PCI:*(0:1:5:0) 1002:9614:1043:834d rev 0, Mem @ 0xf0000000/134217728, 0xfbee0000/65536, 0xfbd00000/1048576, I/O @ 0x0000d000/256
[     6.496] (WW) Open ACPI failed (/var/run/acpid.socket) (No such file or directory)
[     6.496] (II) LoadModule: "extmod"
[     6.501] (II) Loading /usr/lib/xorg/modules/extensions/libextmod.so
[     6.503] (II) Module extmod: vendor="X.Org Foundation"
[     6.503] 	compiled for 1.9.2, module version = 1.0.0
[     6.503] 	Module class: X.Org Server Extension
[     6.503] 	ABI class: X.Org Server Extension, version 4.0
[     6.503] (II) Loading extension MIT-SCREEN-SAVER
[     6.503] (II) Loading extension XFree86-VidModeExtension
[     6.503] (II) Loading extension XFree86-DGA
[     6.503] (II) Loading extension DPMS
[     6.503] (II) Loading extension XVideo
[     6.503] (II) Loading extension XVideo-MotionCompensation
[     6.503] (II) Loading extension X-Resource
[     6.503] (II) LoadModule: "dbe"
[     6.503] (II) Loading /usr/lib/xorg/modules/extensions/libdbe.so
[     6.504] (II) Module dbe: vendor="X.Org Foundation"
[     6.504] 	compiled for 1.9.2, module version = 1.0.0
[     6.504] 	Module class: X.Org Server Extension
[     6.504] 	ABI class: X.Org Server Extension, version 4.0
[     6.504] (II) Loading extension DOUBLE-BUFFER
[     6.504] (II) LoadModule: "glx"
[     6.504] (II) Loading /usr/lib/xorg/modules/extensions/libglx.so
[     6.507] (II) Module glx: vendor="X.Org Foundation"
[     6.507] 	compiled for 1.9.2, module version = 1.0.0
[     6.508] 	ABI class: X.Org Server Extension, version 4.0
[     6.508] (==) AIGLX enabled
[     6.508] (II) Loading extension GLX
[     6.508] (II) LoadModule: "record"
[     6.509] (II) Loading /usr/lib/xorg/modules/extensions/librecord.so
[     6.509] (II) Module record: vendor="X.Org Foundation"
[     6.509] 	compiled for 1.9.2, module version = 1.13.0
[     6.509] 	Module class: X.Org Server Extension
[     6.509] 	ABI class: X.Org Server Extension, version 4.0
[     6.509] (II) Loading extension RECORD
[     6.509] (II) LoadModule: "dri"
[     6.510] (II) Loading /usr/lib/xorg/modules/extensions/libdri.so
[     6.511] (II) Module dri: vendor="X.Org Foundation"
[     6.512] 	compiled for 1.9.2, module version = 1.0.0
[     6.512] 	ABI class: X.Org Server Extension, version 4.0
[     6.512] (II) Loading extension XFree86-DRI
[     6.512] (II) LoadModule: "dri2"
[     6.512] (II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
[     6.512] (II) Module dri2: vendor="X.Org Foundation"
[     6.512] 	compiled for 1.9.2, module version = 1.2.0
[     6.513] 	ABI class: X.Org Server Extension, version 4.0
[     6.513] (II) Loading extension DRI2
[     6.513] (II) LoadModule: "radeon"
[     6.513] (II) Loading /usr/lib/xorg/modules/drivers/radeon_drv.so
[     6.518] (II) Module radeon: vendor="X.Org Foundation"
[     6.518] 	compiled for 1.9.0.901, module version = 6.13.99
[     6.518] 	Module class: X.Org Video Driver
[     6.518] 	ABI class: X.Org Video Driver, version 8.0
[     6.519] (II) RADEON: Driver for ATI Radeon chipsets:
	ATI Radeon Mobility X600 (M24) 3150 (PCIE), ATI FireMV 2400 (PCI),
	ATI Radeon Mobility X300 (M24) 3152 (PCIE),
	ATI FireGL M24 GL 3154 (PCIE), ATI FireMV 2400 3155 (PCI),
	ATI Radeon X600 (RV380) 3E50 (PCIE),
	ATI FireGL V3200 (RV380) 3E54 (PCIE), ATI Radeon IGP320 (A3) 4136,
	ATI Radeon IGP330/340/350 (A4) 4137, ATI Radeon 9500 AD (AGP),
	ATI Radeon 9500 AE (AGP), ATI Radeon 9600TX AF (AGP),
	ATI FireGL Z1 AG (AGP), ATI Radeon 9800SE AH (AGP),
	ATI Radeon 9800 AI (AGP), ATI Radeon 9800 AJ (AGP),
	ATI FireGL X2 AK (AGP), ATI Radeon 9600 AP (AGP),
	ATI Radeon 9600SE AQ (AGP), ATI Radeon 9600XT AR (AGP),
	ATI Radeon 9600 AS (AGP), ATI FireGL T2 AT (AGP), ATI Radeon 9650,
	ATI FireGL RV360 AV (AGP), ATI Radeon 7000 IGP (A4+) 4237,
	ATI Radeon 8500 AIW BB (AGP), ATI Radeon 8500 AIW BC (AGP),
	ATI Radeon IGP320M (U1) 4336, ATI Radeon IGP330M/340M/350M (U2) 4337,
	ATI Radeon Mobility 7000 IGP 4437, ATI Radeon 9000/PRO If (AGP/PCI),
	ATI Radeon 9000 Ig (AGP/PCI), ATI Radeon X800 (R420) JH (AGP),
	ATI Radeon X800PRO (R420) JI (AGP),
	ATI Radeon X800SE (R420) JJ (AGP), ATI Radeon X800 (R420) JK (AGP),
	ATI Radeon X800 (R420) JL (AGP), ATI FireGL X3 (R420) JM (AGP),
	ATI Radeon Mobility 9800 (M18) JN (AGP),
	ATI Radeon X800 SE (R420) (AGP), ATI Radeon X800XT (R420) JP (AGP),
	ATI Radeon X800 VE (R420) JT (AGP), ATI Radeon X850 (R480) (AGP),
	ATI Radeon X850 XT (R480) (AGP), ATI Radeon X850 SE (R480) (AGP),
	ATI Radeon X850 PRO (R480) (AGP), ATI Radeon X850 XT PE (R480) (AGP),
	ATI Radeon Mobility M7 LW (AGP),
	ATI Mobility FireGL 7800 M7 LX (AGP),
	ATI Radeon Mobility M6 LY (AGP), ATI Radeon Mobility M6 LZ (AGP),
	ATI FireGL Mobility 9000 (M9) Ld (AGP),
	ATI Radeon Mobility 9000 (M9) Lf (AGP),
	ATI Radeon Mobility 9000 (M9) Lg (AGP), ATI Radeon 9700 Pro ND (AGP),
	ATI Radeon 9700/9500Pro NE (AGP), ATI Radeon 9600TX NF (AGP),
	ATI FireGL X1 NG (AGP), ATI Radeon 9800PRO NH (AGP),
	ATI Radeon 9800 NI (AGP), ATI FireGL X2 NK (AGP),
	ATI Radeon 9800XT NJ (AGP),
	ATI Radeon Mobility 9600/9700 (M10/M11) NP (AGP),
	ATI Radeon Mobility 9600 (M10) NQ (AGP),
	ATI Radeon Mobility 9600 (M11) NR (AGP),
	ATI Radeon Mobility 9600 (M10) NS (AGP),
	ATI FireGL Mobility T2 (M10) NT (AGP),
	ATI FireGL Mobility T2e (M11) NV (AGP), ATI Radeon QD (AGP),
	ATI Radeon QE (AGP), ATI Radeon QF (AGP), ATI Radeon QG (AGP),
	ATI FireGL 8700/8800 QH (AGP), ATI Radeon 8500 QL (AGP),
	ATI Radeon 9100 QM (AGP), ATI Radeon 7500 QW (AGP/PCI),
	ATI Radeon 7500 QX (AGP/PCI), ATI Radeon VE/7000 QY (AGP/PCI),
	ATI Radeon VE/7000 QZ (AGP/PCI), ATI ES1000 515E (PCI),
	ATI Radeon Mobility X300 (M22) 5460 (PCIE),
	ATI Radeon Mobility X600 SE (M24C) 5462 (PCIE),
	ATI FireGL M22 GL 5464 (PCIE), ATI Radeon X800 (R423) UH (PCIE),
	ATI Radeon X800PRO (R423) UI (PCIE),
	ATI Radeon X800LE (R423) UJ (PCIE),
	ATI Radeon X800SE (R423) UK (PCIE),
	ATI Radeon X800 XTP (R430) (PCIE), ATI Radeon X800 XL (R430) (PCIE),
	ATI Radeon X800 SE (R430) (PCIE), ATI Radeon X800 (R430) (PCIE),
	ATI FireGL V7100 (R423) (PCIE), ATI FireGL V5100 (R423) UQ (PCIE),
	ATI FireGL unknown (R423) UR (PCIE),
	ATI FireGL unknown (R423) UT (PCIE),
	ATI Mobility FireGL V5000 (M26) (PCIE),
	ATI Mobility FireGL V5000 (M26) (PCIE),
	ATI Mobility Radeon X700 XL (M26) (PCIE),
	ATI Mobility Radeon X700 (M26) (PCIE),
	ATI Mobility Radeon X700 (M26) (PCIE),
	ATI Radeon X550XTX 5657 (PCIE), ATI Radeon 9100 IGP (A5) 5834,
	ATI Radeon Mobility 9100 IGP (U3) 5835,
	ATI Radeon XPRESS 200 5954 (PCIE),
	ATI Radeon XPRESS 200M 5955 (PCIE), ATI Radeon 9250 5960 (AGP),
	ATI Radeon 9200 5961 (AGP), ATI Radeon 9200 5962 (AGP),
	ATI Radeon 9200SE 5964 (AGP), ATI FireMV 2200 (PCI),
	ATI ES1000 5969 (PCI), ATI Radeon XPRESS 200 5974 (PCIE),
	ATI Radeon XPRESS 200M 5975 (PCIE),
	ATI Radeon XPRESS 200 5A41 (PCIE),
	ATI Radeon XPRESS 200M 5A42 (PCIE),
	ATI Radeon XPRESS 200 5A61 (PCIE),
	ATI Radeon XPRESS 200M 5A62 (PCIE),
	ATI Radeon X300 (RV370) 5B60 (PCIE),
	ATI Radeon X600 (RV370) 5B62 (PCIE),
	ATI Radeon X550 (RV370) 5B63 (PCIE),
	ATI FireGL V3100 (RV370) 5B64 (PCIE),
	ATI FireMV 2200 PCIE (RV370) 5B65 (PCIE),
	ATI Radeon Mobility 9200 (M9+) 5C61 (AGP),
	ATI Radeon Mobility 9200 (M9+) 5C63 (AGP),
	ATI Mobility Radeon X800 XT (M28) (PCIE),
	ATI Mobility FireGL V5100 (M28) (PCIE),
	ATI Mobility Radeon X800 (M28) (PCIE), ATI Radeon X850 5D4C (PCIE),
	ATI Radeon X850 XT PE (R480) (PCIE),
	ATI Radeon X850 SE (R480) (PCIE), ATI Radeon X850 PRO (R480) (PCIE),
	ATI unknown Radeon / FireGL (R480) 5D50 (PCIE),
	ATI Radeon X850 XT (R480) (PCIE),
	ATI Radeon X800XT (R423) 5D57 (PCIE),
	ATI FireGL V5000 (RV410) (PCIE), ATI Radeon X700 XT (RV410) (PCIE),
	ATI Radeon X700 PRO (RV410) (PCIE),
	ATI Radeon X700 SE (RV410) (PCIE), ATI Radeon X700 (RV410) (PCIE),
	ATI Radeon X700 SE (RV410) (PCIE), ATI Radeon X1800,
	ATI Mobility Radeon X1800 XT, ATI Mobility Radeon X1800,
	ATI Mobility FireGL V7200, ATI FireGL V7200, ATI FireGL V5300,
	ATI Mobility FireGL V7100, ATI Radeon X1800, ATI Radeon X1800,
	ATI Radeon X1800, ATI Radeon X1800, ATI Radeon X1800,
	ATI FireGL V7300, ATI FireGL V7350, ATI Radeon X1600, ATI RV505,
	ATI Radeon X1300/X1550, ATI Radeon X1550, ATI M54-GL,
	ATI Mobility Radeon X1400, ATI Radeon X1300/X1550,
	ATI Radeon X1550 64-bit, ATI Mobility Radeon X1300,
	ATI Mobility Radeon X1300, ATI Mobility Radeon X1300,
	ATI Mobility Radeon X1300, ATI Radeon X1300, ATI Radeon X1300,
	ATI RV505, ATI RV505, ATI FireGL V3300, ATI FireGL V3350,
	ATI Radeon X1300, ATI Radeon X1550 64-bit, ATI Radeon X1300/X1550,
	ATI Radeon X1600, ATI Radeon X1300/X1550, ATI Mobility Radeon X1450,
	ATI Radeon X1300/X1550, ATI Mobility Radeon X2300,
	ATI Mobility Radeon X2300, ATI Mobility Radeon X1350,
	ATI Mobility Radeon X1350, ATI Mobility Radeon X1450,
	ATI Radeon X1300, ATI Radeon X1550, ATI Mobility Radeon X1350,
	ATI FireMV 2250, ATI Radeon X1550 64-bit, ATI Radeon X1600,
	ATI Radeon X1650, ATI Radeon X1600, ATI Radeon X1600,
	ATI Mobility FireGL V5200, ATI Mobility Radeon X1600,
	ATI Radeon X1650, ATI Radeon X1650, ATI Radeon X1600,
	ATI Radeon X1300 XT/X1600 Pro, ATI FireGL V3400,
	ATI Mobility FireGL V5250, ATI Mobility Radeon X1700,
	ATI Mobility Radeon X1700 XT, ATI FireGL V5200,
	ATI Mobility Radeon X1700, ATI Radeon X2300HD,
	ATI Mobility Radeon HD 2300, ATI Mobility Radeon HD 2300,
	ATI Radeon X1950, ATI Radeon X1900, ATI Radeon X1950,
	ATI Radeon X1900, ATI Radeon X1900, ATI Radeon X1900,
	ATI Radeon X1900, ATI Radeon X1900, ATI Radeon X1900,
	ATI Radeon X1900, ATI Radeon X1900, ATI Radeon X1900,
	ATI AMD Stream Processor, ATI Radeon X1900, ATI Radeon X1950,
	ATI RV560, ATI RV560, ATI Mobility Radeon X1900, ATI RV560,
	ATI Radeon X1950 GT, ATI RV570, ATI RV570, ATI FireGL V7400,
	ATI RV560, ATI Radeon X1650, ATI Radeon X1650, ATI RV560,
	ATI Radeon 9100 PRO IGP 7834, ATI Radeon Mobility 9200 IGP 7835,
	ATI Radeon X1200, ATI Radeon X1200, ATI Radeon X1200,
	ATI Radeon X1200, ATI Radeon X1200, ATI RS740, ATI RS740M, ATI RS740,
	ATI RS740M, ATI Radeon HD 2900 XT, ATI Radeon HD 2900 XT,
	ATI Radeon HD 2900 XT, ATI Radeon HD 2900 Pro, ATI Radeon HD 2900 GT,
	ATI FireGL V8650, ATI FireGL V8600, ATI FireGL V7600,
	ATI Radeon 4800 Series, ATI Radeon HD 4870 x2,
	ATI Radeon 4800 Series, ATI Radeon HD 4850 x2,
	ATI FirePro V8750 (FireGL), ATI FirePro V7760 (FireGL),
	ATI Mobility RADEON HD 4850, ATI Mobility RADEON HD 4850 X2,
	ATI Radeon 4800 Series, ATI FirePro RV770, AMD FireStream 9270,
	AMD FireStream 9250, ATI FirePro V8700 (FireGL),
	ATI Mobility RADEON HD 4870, ATI Mobility RADEON M98,
	ATI Mobility RADEON HD 4870, ATI Radeon 4800 Series,
	ATI Radeon 4800 Series, ATI FirePro M7750, ATI M98, ATI M98, ATI M98,
	ATI Mobility Radeon HD 4650, ATI Radeon RV730 (AGP),
	ATI Mobility Radeon HD 4670, ATI FirePro M5750,
	ATI Mobility Radeon HD 4670, ATI Radeon RV730 (AGP),
	ATI RV730XT [Radeon HD 4670], ATI RADEON E4600,
	ATI Radeon HD 4600 Series, ATI RV730 PRO [Radeon HD 4650],
	ATI FirePro V7750 (FireGL), ATI FirePro V5700 (FireGL),
	ATI FirePro V3750 (FireGL), ATI Mobility Radeon HD 4830,
	ATI Mobility Radeon HD 4850, ATI FirePro M7740, ATI RV740,
	ATI Radeon HD 4770, ATI Radeon HD 4700 Series, ATI Radeon HD 4770,
	ATI FirePro M5750, ATI RV610, ATI Radeon HD 2400 XT,
	ATI Radeon HD 2400 Pro, ATI Radeon HD 2400 PRO AGP, ATI FireGL V4000,
	ATI RV610, ATI Radeon HD 2350, ATI Mobility Radeon HD 2400 XT,
	ATI Mobility Radeon HD 2400, ATI RADEON E2400, ATI RV610,
	ATI FireMV 2260, ATI RV670, ATI Radeon HD3870,
	ATI Mobility Radeon HD 3850, ATI Radeon HD3850,
	ATI Mobility Radeon HD 3850 X2, ATI RV670,
	ATI Mobility Radeon HD 3870, ATI Mobility Radeon HD 3870 X2,
	ATI Radeon HD3870 X2, ATI FireGL V7700, ATI Radeon HD3850,
	ATI Radeon HD3690, AMD Firestream 9170, ATI Radeon HD 4550,
	ATI Radeon RV710, ATI Radeon RV710, ATI Radeon RV710,
	ATI Radeon HD 4350, ATI Mobility Radeon 4300 Series,
	ATI Mobility Radeon 4500 Series, ATI Mobility Radeon 4500 Series,
	ATI FirePro RG220, ATI Mobility Radeon 4330, ATI RV630,
	ATI Mobility Radeon HD 2600, ATI Mobility Radeon HD 2600 XT,
	ATI Radeon HD 2600 XT AGP, ATI Radeon HD 2600 Pro AGP,
	ATI Radeon HD 2600 XT, ATI Radeon HD 2600 Pro, ATI Gemini RV630,
	ATI Gemini Mobility Radeon HD 2600 XT, ATI FireGL V5600,
	ATI FireGL V3600, ATI Radeon HD 2600 LE,
	ATI Mobility FireGL Graphics Processor, ATI Radeon HD 3470,
	ATI Mobility Radeon HD 3430, ATI Mobility Radeon HD 3400 Series,
	ATI Radeon HD 3450, ATI Radeon HD 3450, ATI Radeon HD 3430,
	ATI Radeon HD 3450, ATI FirePro V3700, ATI FireMV 2450,
	ATI FireMV 2260, ATI FireMV 2260, ATI Radeon HD 3600 Series,
	ATI Radeon HD 3650 AGP, ATI Radeon HD 3600 PRO,
	ATI Radeon HD 3600 XT, ATI Radeon HD 3600 PRO,
	ATI Mobility Radeon HD 3650, ATI Mobility Radeon HD 3670,
	ATI Mobility FireGL V5700, ATI Mobility FireGL V5725,
	ATI Radeon HD 3200 Graphics, ATI Radeon 3100 Graphics,
	ATI Radeon HD 3200 Graphics, ATI Radeon 3100 Graphics,
	ATI Radeon HD 3300 Graphics, ATI Radeon HD 3200 Graphics,
	ATI Radeon 3000 Graphics, ATI Radeon HD 4200, ATI Radeon 4100,
	ATI Mobility Radeon HD 4200, ATI Mobility Radeon 4100,
	ATI Radeon HD 4290, ATI Radeon HD 4290, CYPRESS,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter, AMD Firestream 9370,
	AMD Firestream 9350, ATI Radeon HD 5800 Series,
	ATI Radeon HD 5800 Series, ATI Radeon HD 5800 Series,
	ATI Radeon HD 5900 Series, ATI Radeon HD 5900 Series,
	ATI Mobility Radeon HD 5800 Series,
	ATI Mobility Radeon HD 5800 Series,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI Mobility Radeon HD 5800 Series, ATI Radeon HD 5700 Series,
	ATI Radeon HD 5700 Series, ATI Radeon HD 5700 Series,
	ATI Mobility Radeon HD 5000 Series,
	ATI Mobility Radeon HD 5000 Series, ATI Mobility Radeon HD 5570,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter, ATI Radeon HD 5670,
	ATI Radeon HD 5570, ATI Radeon HD 5500 Series, REDWOOD,
	ATI Mobility Radeon HD 5000 Series,
	ATI Mobility Radeon HD 5000 Series, ATI Mobility Radeon Graphics,
	ATI Mobility Radeon Graphics, CEDAR,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter, ATI FirePro 2270, CEDAR,
	ATI Radeon HD 5450, CEDAR
[     6.525] (--) using VT number 7

[     6.553] (II) [KMS] Kernel modesetting enabled.
[     6.553] (WW) VGA arbiter: cannot open kernel arbiter, no multi-card support
[     6.554] (II) RADEON(0): Creating default Display subsection in Screen section
	"Default Screen Section" for depth/fbbpp 24/32
[     6.554] (==) RADEON(0): Depth 24, (--) framebuffer bpp 32
[     6.554] (II) RADEON(0): Pixel depth = 24 bits stored in 4 bytes (32 bpp pixmaps)
[     6.554] (==) RADEON(0): Default visual is TrueColor
[     6.554] (==) RADEON(0): RGB weight 888
[     6.554] (II) RADEON(0): Using 8 bits per RGB (8 bit DAC)
[     6.554] (--) RADEON(0): Chipset: "ATI Radeon HD 3300 Graphics" (ChipID = 0x9614)
[     6.554] (II) RADEON(0): PCI card detected
[     6.554] drmOpenDevice: node name is /dev/dri/card0
[     6.554] drmOpenDevice: open result is 7, (OK)
[     6.554] drmOpenByBusid: Searching for BusID pci:0000:01:05.0
[     6.554] drmOpenDevice: node name is /dev/dri/card0
[     6.554] drmOpenDevice: open result is 7, (OK)
[     6.554] drmOpenByBusid: drmOpenMinor returns 7
[     6.554] drmOpenByBusid: drmGetBusid reports pci:0000:01:05.0
[     6.554] (II) RADEON(0): KMS Color Tiling: disabled
[     6.569] (II) RADEON(0): Output VGA-0 has no monitor section
[     6.623] (II) RADEON(0): Output DVI-0 using monitor section DVI-0
[     6.623] (**) RADEON(0): Option "Rotate" "left"
[     6.638] (II) RADEON(0): EDID for output VGA-0
[     6.692] (II) RADEON(0): EDID for output DVI-0
[     6.692] (II) RADEON(0): Manufacturer: GSM  Model: 4e48  Serial#: 148502
[     6.692] (II) RADEON(0): Year: 2006  Week: 8
[     6.692] (II) RADEON(0): EDID Version: 1.3
[     6.692] (II) RADEON(0): Digital Display Input
[     6.692] (II) RADEON(0): Max Image Size [cm]: horiz.: 43  vert.: 27
[     6.692] (II) RADEON(0): Gamma: 2.20
[     6.692] (II) RADEON(0): DPMS capabilities: StandBy Suspend Off
[     6.692] (II) RADEON(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
[     6.692] (II) RADEON(0): First detailed timing is preferred mode
[     6.692] (II) RADEON(0): redX: 0.651 redY: 0.333   greenX: 0.277 greenY: 0.614
[     6.692] (II) RADEON(0): blueX: 0.145 blueY: 0.082   whiteX: 0.313 whiteY: 0.329
[     6.692] (II) RADEON(0): Supported established timings:
[     6.692] (II) RADEON(0): 720x400@70Hz
[     6.692] (II) RADEON(0): 640x480@60Hz
[     6.692] (II) RADEON(0): 640x480@75Hz
[     6.692] (II) RADEON(0): 800x600@56Hz
[     6.692] (II) RADEON(0): 800x600@60Hz
[     6.692] (II) RADEON(0): 800x600@75Hz
[     6.692] (II) RADEON(0): 832x624@75Hz
[     6.692] (II) RADEON(0): 1024x768@60Hz
[     6.692] (II) RADEON(0): 1024x768@75Hz
[     6.692] (II) RADEON(0): 1280x1024@75Hz
[     6.692] (II) RADEON(0): 1152x864@75Hz
[     6.692] (II) RADEON(0): Manufacturer's mask: 0
[     6.692] (II) RADEON(0): Supported standard timings:
[     6.692] (II) RADEON(0): #1: hsize: 1280  vsize 1024  refresh: 60  vid: 32897
[     6.692] (II) RADEON(0): #2: hsize: 1280  vsize 960  refresh: 60  vid: 16513
[     6.692] (II) RADEON(0): #3: hsize: 1152  vsize 864  refresh: 75  vid: 20337
[     6.692] (II) RADEON(0): Supported detailed timing:
[     6.692] (II) RADEON(0): clock: 146.2 MHz   Image Size:  434 x 270 mm
[     6.692] (II) RADEON(0): h_active: 1680  h_sync: 1784  h_sync_end 1960 h_blank_end 2240 h_border: 0
[     6.692] (II) RADEON(0): v_active: 1050  v_sync: 1053  v_sync_end 1059 v_blanking: 1089 v_border: 0
[     6.692] (II) RADEON(0): Ranges: V min: 56 V max: 75 Hz, H min: 28 H max: 83 kHz, PixClock max 155 MHz
[     6.692] (II) RADEON(0): Monitor name: L204WT
[     6.692] (II) RADEON(0): Monitor name: 
[     6.692] (II) RADEON(0): EDID (in hex):
[     6.692] (II) RADEON(0): 	00ffffffffffff001e6d484e16440200
[     6.692] (II) RADEON(0): 	08100103ea2b1b78ead105a655479d25
[     6.692] (II) RADEON(0): 	155054a76b80010181808140714f0101
[     6.692] (II) RADEON(0): 	01010101010121399030621a274068b0
[     6.692] (II) RADEON(0): 	3600b20e1100001c000000fd00384b1c
[     6.692] (II) RADEON(0): 	530f000a202020202020000000fc004c
[     6.692] (II) RADEON(0): 	32303457540a202020202020000000fc
[     6.692] (II) RADEON(0): 	000a2020202020202020202020200051
[     6.692] (II) RADEON(0): Printing probed modes for output DVI-0
[     6.692] (II) RADEON(0): Modeline "1680x1050"x60.0  146.25  1680 1784 1960 2240  1050 1053 1059 1089 -hsync +vsync (65.3 kHz)
[     6.692] (II) RADEON(0): Modeline "1280x1024"x75.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[     6.692] (II) RADEON(0): Modeline "1280x1024"x60.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[     6.692] (II) RADEON(0): Modeline "1280x960"x60.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[     6.692] (II) RADEON(0): Modeline "1152x864"x75.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[     6.692] (II) RADEON(0): Modeline "1024x768"x75.1   78.80  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.1 kHz)
[     6.692] (II) RADEON(0): Modeline "1024x768"x60.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[     6.692] (II) RADEON(0): Modeline "832x624"x74.6   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[     6.692] (II) RADEON(0): Modeline "800x600"x75.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[     6.692] (II) RADEON(0): Modeline "800x600"x60.3   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[     6.692] (II) RADEON(0): Modeline "800x600"x56.2   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[     6.692] (II) RADEON(0): Modeline "640x480"x75.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[     6.692] (II) RADEON(0): Modeline "640x480"x60.0   25.20  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[     6.692] (II) RADEON(0): Modeline "720x400"x70.1   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[     6.692] (II) RADEON(0): Output VGA-0 disconnected
[     6.692] (II) RADEON(0): Output DVI-0 connected
[     6.692] (II) RADEON(0): Using exact sizes for initial modes
[     6.692] (II) RADEON(0): Output DVI-0 using initial mode 1680x1050
[     6.692] (II) RADEON(0): Using default gamma of (1.0, 1.0, 1.0) unless otherwise stated.
[     6.692] (II) RADEON(0): mem size init: gart size :1fdff000 vram size: s:8000000 visible:78d4000
[     6.692] (II) RADEON(0): EXA: Driver will allow EXA pixmaps in VRAM
[     6.693] (==) RADEON(0): DPI set to (96, 96)
[     6.693] (II) Loading sub module "fb"
[     6.693] (II) LoadModule: "fb"
[     6.693] (II) Loading /usr/lib/xorg/modules/libfb.so
[     6.695] (II) Module fb: vendor="X.Org Foundation"
[     6.695] 	compiled for 1.9.2, module version = 1.0.0
[     6.695] 	ABI class: X.Org ANSI C Emulation, version 0.4
[     6.695] (II) Loading sub module "ramdac"
[     6.695] (II) LoadModule: "ramdac"
[     6.695] (II) Module "ramdac" already built-in
[     6.695] (II) Loading sub module "exa"
[     6.695] (II) LoadModule: "exa"
[     6.695] (II) Loading /usr/lib/xorg/modules/libexa.so
[     6.696] (II) Module exa: vendor="X.Org Foundation"
[     6.696] 	compiled for 1.9.2, module version = 2.5.0
[     6.696] 	ABI class: X.Org Video Driver, version 8.0
[     6.696] (--) Depth 24 pixmap format is 32 bpp
[     6.696] (II) RADEON(0): [DRI2] Setup complete
[     6.696] (II) RADEON(0): [DRI2]   DRI driver: r600
[     6.697] (II) RADEON(0): Front buffer size: 8400K
[     6.697] (II) RADEON(0): VRAM usage limit set to 103795K
[     6.699] (==) RADEON(0): Backing store disabled
[     6.699] (II) RADEON(0): Direct rendering enabled
[     6.700] (II) RADEON(0): Setting EXA maxPitchBytes
[     6.700] (II) EXA(0): Driver allocated offscreen pixmaps
[     6.700] (II) EXA(0): Driver registered support for the following operations:
[     6.700] (II)         Solid
[     6.700] (II)         Copy
[     6.700] (II)         Composite (RENDER acceleration)
[     6.700] (II)         UploadToScreen
[     6.700] (II)         DownloadFromScreen
[     6.700] (II) RADEON(0): Acceleration enabled
[     6.700] (==) RADEON(0): DPMS enabled
[     6.700] (==) RADEON(0): Silken mouse enabled
[     6.701] (II) RADEON(0): Set up textured video
[     6.701] (II) RADEON(0): RandR 1.2 enabled, ignore the following RandR disabled message.
[     6.701] (--) RandR disabled
[     6.701] (II) Initializing built-in extension Generic Event Extension
[     6.701] (II) Initializing built-in extension SHAPE
[     6.701] (II) Initializing built-in extension MIT-SHM
[     6.701] (II) Initializing built-in extension XInputExtension
[     6.701] (II) Initializing built-in extension XTEST
[     6.701] (II) Initializing built-in extension BIG-REQUESTS
[     6.701] (II) Initializing built-in extension SYNC
[     6.701] (II) Initializing built-in extension XKEYBOARD
[     6.701] (II) Initializing built-in extension XC-MISC
[     6.701] (II) Initializing built-in extension SECURITY
[     6.701] (II) Initializing built-in extension XINERAMA
[     6.701] (II) Initializing built-in extension XFIXES
[     6.701] (II) Initializing built-in extension RENDER
[     6.701] (II) Initializing built-in extension RANDR
[     6.701] (II) Initializing built-in extension COMPOSITE
[     6.701] (II) Initializing built-in extension DAMAGE
[     6.722] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[     6.722] (II) AIGLX: enabled GLX_INTEL_swap_event
[     6.722] (II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_control
[     6.722] (II) AIGLX: enabled GLX_SGI_make_current_read
[     6.722] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects
[     6.723] (II) AIGLX: Loaded and initialized /usr/lib/xorg/modules/dri/r600_dri.so
[     6.723] (II) GLX: Initialized DRI2 GL provider for screen 0
[     6.725] (II) RADEON(0): Setting screen physical size to 277 x 444
[     6.905] (II) config/udev: Adding input device Power Button (/dev/input/event1)
[     6.905] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[     6.905] (II) LoadModule: "evdev"
[     6.905] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[     6.906] (II) Module evdev: vendor="X.Org Foundation"
[     6.906] 	compiled for 1.9.0, module version = 2.5.0
[     6.906] 	Module class: X.Org XInput Driver
[     6.906] 	ABI class: X.Org XInput driver, version 11.0
[     6.906] (**) Power Button: always reports core events
[     6.906] (**) Power Button: Device: "/dev/input/event1"
[     6.911] (--) Power Button: Found keys
[     6.911] (II) Power Button: Configuring as keyboard
[     6.911] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
[     6.911] (**) Option "xkb_rules" "evdev"
[     6.911] (**) Option "xkb_model" "evdev"
[     6.911] (**) Option "xkb_layout" "us"
[     6.950] (II) config/udev: Adding input device Power Button (/dev/input/event0)
[     6.950] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[     6.950] (**) Power Button: always reports core events
[     6.950] (**) Power Button: Device: "/dev/input/event0"
[     6.964] (--) Power Button: Found keys
[     6.964] (II) Power Button: Configuring as keyboard
[     6.964] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
[     6.964] (**) Option "xkb_rules" "evdev"
[     6.964] (**) Option "xkb_model" "evdev"
[     6.964] (**) Option "xkb_layout" "us"
[     6.972] (II) config/udev: Adding input device C-Media USB Headphone Set   (/dev/input/event2)
[     6.973] (**) C-Media USB Headphone Set  : Applying InputClass "evdev keyboard catchall"
[     6.973] (**) C-Media USB Headphone Set  : always reports core events
[     6.973] (**) C-Media USB Headphone Set  : Device: "/dev/input/event2"
[     6.980] (--) C-Media USB Headphone Set  : Found keys
[     6.980] (II) C-Media USB Headphone Set  : Configuring as keyboard
[     6.980] (II) XINPUT: Adding extended input device "C-Media USB Headphone Set  " (type: KEYBOARD)
[     6.980] (**) Option "xkb_rules" "evdev"
[     6.980] (**) Option "xkb_model" "evdev"
[     6.980] (**) Option "xkb_layout" "us"
[     6.981] (II) config/udev: Adding input device Logitech USB Receiver (/dev/input/event3)
[     6.981] (**) Logitech USB Receiver: Applying InputClass "evdev keyboard catchall"
[     6.981] (**) Logitech USB Receiver: always reports core events
[     6.981] (**) Logitech USB Receiver: Device: "/dev/input/event3"
[     6.988] (--) Logitech USB Receiver: Found keys
[     6.988] (II) Logitech USB Receiver: Configuring as keyboard
[     6.988] (II) XINPUT: Adding extended input device "Logitech USB Receiver" (type: KEYBOARD)
[     6.988] (**) Option "xkb_rules" "evdev"
[     6.988] (**) Option "xkb_model" "evdev"
[     6.988] (**) Option "xkb_layout" "us"
[     6.989] (II) config/udev: Adding input device Logitech USB Receiver (/dev/input/event4)
[     6.989] (**) Logitech USB Receiver: Applying InputClass "evdev pointer catchall"
[     6.989] (**) Logitech USB Receiver: Applying InputClass "evdev keyboard catchall"
[     6.989] (**) Logitech USB Receiver: always reports core events
[     6.989] (**) Logitech USB Receiver: Device: "/dev/input/event4"
[     6.996] (--) Logitech USB Receiver: Found 20 mouse buttons
[     6.996] (--) Logitech USB Receiver: Found scroll wheel(s)
[     6.996] (--) Logitech USB Receiver: Found relative axes
[     6.996] (--) Logitech USB Receiver: Found x and y relative axes
[     6.996] (--) Logitech USB Receiver: Found absolute axes
[     6.996] (--) Logitech USB Receiver: Found keys
[     6.996] (II) Logitech USB Receiver: Configuring as mouse
[     6.996] (II) Logitech USB Receiver: Configuring as keyboard
[     6.996] (**) Logitech USB Receiver: YAxisMapping: buttons 4 and 5
[     6.996] (**) Logitech USB Receiver: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[     6.996] (II) XINPUT: Adding extended input device "Logitech USB Receiver" (type: KEYBOARD)
[     6.996] (**) Option "xkb_rules" "evdev"
[     6.996] (**) Option "xkb_model" "evdev"
[     6.996] (**) Option "xkb_layout" "us"
[     6.996] (**) Logitech USB Receiver: (accel) keeping acceleration scheme 1
[     6.996] (**) Logitech USB Receiver: (accel) acceleration profile 0
[     6.997] (**) Logitech USB Receiver: (accel) acceleration factor: 2.000
[     6.997] (**) Logitech USB Receiver: (accel) acceleration threshold: 4
[     6.997] (II) Logitech USB Receiver: initialized for relative axes.
[     6.997] (WW) Logitech USB Receiver: ignoring absolute axes.
[     6.997] (II) config/udev: Adding input device Logitech USB Receiver (/dev/input/mouse0)
[     6.997] (II) No input driver/identifier specified (ignoring)
[     6.999] (II) config/udev: Adding input device HID 046a:0011 (/dev/input/event5)
[     6.999] (**) HID 046a:0011: Applying InputClass "evdev keyboard catchall"
[     6.999] (**) HID 046a:0011: always reports core events
[     6.999] (**) HID 046a:0011: Device: "/dev/input/event5"
[     7.004] (--) HID 046a:0011: Found keys
[     7.004] (II) HID 046a:0011: Configuring as keyboard
[     7.004] (II) XINPUT: Adding extended input device "HID 046a:0011" (type: KEYBOARD)
[     7.004] (**) Option "xkb_rules" "evdev"
[     7.004] (**) Option "xkb_model" "evdev"
[     7.004] (**) Option "xkb_layout" "us"
[    10.691] (II) RADEON(0): EDID vendor "GSM", prod id 20040
[    10.691] (II) RADEON(0): Using EDID range info for horizontal sync
[    10.691] (II) RADEON(0): Using EDID range info for vertical refresh
[    10.691] (II) RADEON(0): Printing DDC gathered Modelines:
[    10.691] (II) RADEON(0): Modeline "1680x1050"x0.0  146.25  1680 1784 1960 2240  1050 1053 1059 1089 -hsync +vsync (65.3 kHz)
[    10.691] (II) RADEON(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    10.691] (II) RADEON(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    10.691] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    10.691] (II) RADEON(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    10.691] (II) RADEON(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    10.691] (II) RADEON(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    10.691] (II) RADEON(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    10.691] (II) RADEON(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    10.691] (II) RADEON(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    10.691] (II) RADEON(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    10.691] (II) RADEON(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    10.691] (II) RADEON(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    10.691] (II) RADEON(0): Modeline "1280x960"x0.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[    10.760] (II) RADEON(0): EDID vendor "GSM", prod id 20040
[    10.760] (II) RADEON(0): Using hsync ranges from config file
[    10.760] (II) RADEON(0): Using vrefresh ranges from config file
[    10.760] (II) RADEON(0): Printing DDC gathered Modelines:
[    10.760] (II) RADEON(0): Modeline "1680x1050"x0.0  146.25  1680 1784 1960 2240  1050 1053 1059 1089 -hsync +vsync (65.3 kHz)
[    10.760] (II) RADEON(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    10.760] (II) RADEON(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    10.760] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    10.760] (II) RADEON(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    10.760] (II) RADEON(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    10.760] (II) RADEON(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    10.760] (II) RADEON(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    10.760] (II) RADEON(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    10.760] (II) RADEON(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    10.760] (II) RADEON(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    10.760] (II) RADEON(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    10.760] (II) RADEON(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    10.760] (II) RADEON(0): Modeline "1280x960"x0.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[    10.833] (II) RADEON(0): EDID vendor "GSM", prod id 20040
[    10.833] (II) RADEON(0): Using hsync ranges from config file
[    10.834] (II) RADEON(0): Using vrefresh ranges from config file
[    10.834] (II) RADEON(0): Printing DDC gathered Modelines:
[    10.834] (II) RADEON(0): Modeline "1680x1050"x0.0  146.25  1680 1784 1960 2240  1050 1053 1059 1089 -hsync +vsync (65.3 kHz)
[    10.834] (II) RADEON(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    10.834] (II) RADEON(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    10.834] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    10.834] (II) RADEON(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    10.834] (II) RADEON(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    10.834] (II) RADEON(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    10.834] (II) RADEON(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    10.834] (II) RADEON(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    10.834] (II) RADEON(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    10.834] (II) RADEON(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    10.834] (II) RADEON(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    10.834] (II) RADEON(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    10.834] (II) RADEON(0): Modeline "1280x960"x0.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)

--/9DWx/yDrRhgMJTb--
