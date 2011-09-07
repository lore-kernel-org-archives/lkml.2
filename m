Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab1IGUuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 16:50:07 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57990 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab1IGUuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 16:50:04 -0400
MIME-Version: 1.0
Date: Wed, 7 Sep 2011 22:50:02 +0200
Message-ID: <CAJJYPd=g9LYqH3OCVA674=aTF2qJSZHzgqBck1nJ_WpqVV4iAw@mail.gmail.com>
Subject: kernel BUG at drivers/gpu/drm/i915/i915_gem.c:3459
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This happened to today probably in the moment, LCD was turned off by
Xserver as a screenblank
My hw is Lenovo T61  4GB, intel driver.

Seem to be related to:
https://bbs.archlinux.org/viewtopic.php?id=124900

However my machine is good old C2D - no SandyBridge in my case.
xorg-x11-drv-intel-2.16.0-2.fc17.x86_64
xorg-x11-server-Xorg-1.10.99.902-1.20110818.fc17.x86_64
3.1.0-rc5 (with my 8 unrelated patches)

kernel BUG at drivers/gpu/drm/i915/i915_gem.c:3459!
invalid opcode: 0000 [#1] PREEMPT SMP
CPU 1
Modules linked in: nls_iso8859_1 nls_cp1250 vfat fat dm_zero dm_mirror
dm_region_hash dm_log dm_snapshot cryptd crypto_hash crypto_wq
crypto_blkcipher aes_x86_64 aes_generic dm_raid raid1 raid456 md_mod
async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq
async_tx i915 drm_kms_helper drm i2c_algo_bit lockd sunrpc
snd_hda_codec_analog cryptomgr aead arc4 crypto_algapi iwl3945
iwl_legacy mac80211 usbhid snd_hda_intel hid snd_hda_codec snd_pcm
cfg80211 binfmt_misc psmouse e1000e snd_timer serio_raw i2c_i801
iTCO_wdt thinkpad_acpi i2c_core snd iTCO_vendor_support snd_page_alloc
soundcore wmi nvram evdev dm_mod loop virtio_net kvm_intel kvm uinput
ipv6 autofs4 mmc_block pcmcia uhci_hcd ehci_hcd yenta_socket sdhci_pci
sdhci mmc_core sr_mod cdrom usbcore video backlight

Pid: 1029, comm: X Not tainted 3.1.0-rc5-00008-gedaa057 #11 LENOVO
6464CTO/6464CTO
RIP: 0010:[<ffffffffa048f33b>]  [<ffffffffa048f33b>]
i915_gem_object_unpin+0xab/0xb0 [i915]
RSP: 0018:ffff880130db3b98  EFLAGS: 00010246
RAX: ffff880128ea9000 RBX: ffff880128d7d800 RCX: 0000000000000006
RDX: 0000000000020427 RSI: ffff88012d73a000 RDI: ffff880119ca8600
RBP: ffff880130db3b98 R08: 2222222222222222 R09: 2222222222222222
R10: 0000000000000000 R11: 0000000000000000 R12: ffff880128ea9068
R13: ffff880128ea9920 R14: 0000000000000000 R15: ffff8800283ec300
FS:  00007fb25ca178a0(0000) GS:ffff88013bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fb258d65982 CR3: 0000000133746000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process X (pid: 1029, threadinfo ffff880130db2000, task ffff88012d53a350)
Stack:
 ffff880130db3bb8 ffffffffa0498ffb ffff880128d7d800 ffffffffa04efda0
 ffff880130db3be8 ffffffffa02567d5 0000000000000001 ffff880128d7d800
 ffff880130db3ca8 ffff880128ea98f0 ffff880130db3c98 ffffffffa025805b
Call Trace:
 [<ffffffffa0498ffb>] intel_crtc_disable+0x4b/0x60 [i915]
 [<ffffffffa02567d5>] drm_helper_disable_unused_functions+0x115/0x190
[drm_kms_helper]
 [<ffffffffa025805b>] drm_crtc_helper_set_config+0x8db/0x9f0 [drm_kms_helper]
 [<ffffffff81090ba6>] ? mark_held_locks+0x86/0x150
 [<ffffffffa043150e>] drm_framebuffer_cleanup+0xce/0x100 [drm]
 [<ffffffffa0499a91>] intel_user_framebuffer_destroy+0x21/0x70 [i915]
 [<ffffffffa0434143>] drm_mode_rmfb+0xd3/0x130 [drm]
 [<ffffffffa04245d4>] drm_ioctl+0x3d4/0x4b0 [drm]
 [<ffffffffa0434070>] ? drm_mode_addfb+0x180/0x180 [drm]
 [<ffffffff814bb009>] ? sub_preempt_count+0xa9/0xe0
 [<ffffffff8107c341>] ? __srcu_read_unlock+0x41/0x70
 [<ffffffff81191e52>] ? fsnotify+0x282/0x5b0
 [<ffffffff81191c63>] ? fsnotify+0x93/0x5b0
 [<ffffffff81165d58>] do_vfs_ioctl+0x98/0x570
 [<ffffffff81153e70>] ? fget_light+0x340/0x3a0
 [<ffffffff811662c1>] sys_ioctl+0x91/0xa0
 [<ffffffff814befab>] system_call_fastpath+0x16/0x1b
Code: 00 48 89 96 f8 19 00 00 48 81 c6 f0 19 00 00 48 89 b7 b0 00 00
00 48 89 87 b8 00 00 00 48 89 10 80 a7 e2 00 00 00 f7 5d c3 0f 0b <0f>
0b 0f 1f 00 55 48 89 e5 48 81 ec c0 00 00 00 48 89 5d d8 4c
RIP  [<ffffffffa048f33b>] i915_gem_object_unpin+0xab/0xb0 [i915]
 RSP <ffff880130db3b98>
INFO: task X:1029 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
X               D 0000000000000000     0  1029   1028 0x00400000
 ffff880130db35e8 0000000000000046 ffffffff814b3b40 0000000000000046
 0000000000000000 ffff88012d53a350 0000000000000000 ffff880130db3fd8
 ffff880130db3fd8 ffff880130db3fd8 ffff8801371446a0 ffff88012d53a350
Call Trace:
 [<ffffffff814b3b40>] ? schedule+0x920/0xb10
 [<ffffffff814b50b1>] mutex_lock_nested+0x1a1/0x3d0
 [<ffffffffa02547c9>] ? drm_fb_helper_pan_display+0x39/0xe0 [drm_kms_helper]
 [<ffffffffa02547c9>] ? drm_fb_helper_pan_display+0x39/0xe0 [drm_kms_helper]
 [<ffffffffa02547c9>] drm_fb_helper_pan_display+0x39/0xe0 [drm_kms_helper]
 [<ffffffff812d56de>] fb_pan_display+0xce/0x190
 [<ffffffff812e70a9>] bit_update_start+0x29/0x60
 [<ffffffff812e50f0>] fbcon_switch+0x390/0x540
 [<ffffffff813472a9>] redraw_screen+0x179/0x280
 [<ffffffff812e37ea>] fbcon_blank+0x21a/0x2d0
 [<ffffffff814b7908>] ? _raw_spin_unlock_irqrestore+0x38/0x80
 [<ffffffff814bb009>] ? sub_preempt_count+0xa9/0xe0
 [<ffffffff814b7912>] ? _raw_spin_unlock_irqrestore+0x42/0x80
 [<ffffffff810622ff>] ? mod_timer+0x13f/0x430
 [<ffffffff81347fa4>] do_unblank_screen+0xc4/0x1f0
 [<ffffffff813480e0>] unblank_screen+0x10/0x20
 [<ffffffff812aa2fd>] bust_spinlocks+0x1d/0x40
 [<ffffffff814b8e00>] oops_end+0x40/0xf0
 [<ffffffff810059e8>] die+0x58/0x90
 [<ffffffff814b85b4>] do_trap+0xc4/0x170
 [<ffffffff81002e35>] do_invalid_op+0x95/0xb0
 [<ffffffffa048f33b>] ? i915_gem_object_unpin+0xab/0xb0 [i915]
 [<ffffffff812a932d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff814b7f51>] ? restore_args+0x30/0x30
 [<ffffffff814c00b5>] invalid_op+0x15/0x20
 [<ffffffffa048f33b>] ? i915_gem_object_unpin+0xab/0xb0 [i915]
 [<ffffffffa0498ffb>] intel_crtc_disable+0x4b/0x60 [i915]
 [<ffffffffa02567d5>] drm_helper_disable_unused_functions+0x115/0x190
[drm_kms_helper]
 [<ffffffffa025805b>] drm_crtc_helper_set_config+0x8db/0x9f0 [drm_kms_helper]
 [<ffffffff81090ba6>] ? mark_held_locks+0x86/0x150
 [<ffffffffa043150e>] drm_framebuffer_cleanup+0xce/0x100 [drm]
 [<ffffffffa0499a91>] intel_user_framebuffer_destroy+0x21/0x70 [i915]
 [<ffffffffa0434143>] drm_mode_rmfb+0xd3/0x130 [drm]
 [<ffffffffa04245d4>] drm_ioctl+0x3d4/0x4b0 [drm]
 [<ffffffffa0434070>] ? drm_mode_addfb+0x180/0x180 [drm]
 [<ffffffff814bb009>] ? sub_preempt_count+0xa9/0xe0
 [<ffffffff8107c341>] ? __srcu_read_unlock+0x41/0x70
 [<ffffffff81191e52>] ? fsnotify+0x282/0x5b0
 [<ffffffff81191c63>] ? fsnotify+0x93/0x5b0
 [<ffffffff81165d58>] do_vfs_ioctl+0x98/0x570
 [<ffffffff81153e70>] ? fget_light+0x340/0x3a0
 [<ffffffff811662c1>] sys_ioctl+0x91/0xa0
 [<ffffffff814befab>] system_call_fastpath+0x16/0x1b
INFO: lockdep is turned off.
INFO: task X:1029 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
X               D 0000000000000000     0  1029   1028 0x00400000
 ffff880130db35e8 0000000000000046 ffffffff814b3b40 0000000000000046
 0000000000000000 ffff88012d53a350 0000000000000000 ffff880130db3fd8
 ffff880130db3fd8 ffff880130db3fd8 ffff8801371446a0 ffff88012d53a350
Call Trace:
 [<ffffffff814b3b40>] ? schedule+0x920/0xb10
 [<ffffffff814b50b1>] mutex_lock_nested+0x1a1/0x3d0
 [<ffffffffa02547c9>] ? drm_fb_helper_pan_display+0x39/0xe0 [drm_kms_helper]
 [<ffffffffa02547c9>] ? drm_fb_helper_pan_display+0x39/0xe0 [drm_kms_helper]
 [<ffffffffa02547c9>] drm_fb_helper_pan_display+0x39/0xe0 [drm_kms_helper]
 [<ffffffff812d56de>] fb_pan_display+0xce/0x190
 [<ffffffff812e70a9>] bit_update_start+0x29/0x60
 [<ffffffff812e50f0>] fbcon_switch+0x390/0x540
 [<ffffffff813472a9>] redraw_screen+0x179/0x280
 [<ffffffff812e37ea>] fbcon_blank+0x21a/0x2d0
 [<ffffffff814b7908>] ? _raw_spin_unlock_irqrestore+0x38/0x80
 [<ffffffff814bb009>] ? sub_preempt_count+0xa9/0xe0
 [<ffffffff814b7912>] ? _raw_spin_unlock_irqrestore+0x42/0x80
 [<ffffffff810622ff>] ? mod_timer+0x13f/0x430
 [<ffffffff81347fa4>] do_unblank_screen+0xc4/0x1f0
 [<ffffffff813480e0>] unblank_screen+0x10/0x20
 [<ffffffff812aa2fd>] bust_spinlocks+0x1d/0x40
 [<ffffffff814b8e00>] oops_end+0x40/0xf0
 [<ffffffff810059e8>] die+0x58/0x90
 [<ffffffff814b85b4>] do_trap+0xc4/0x170
 [<ffffffff81002e35>] do_invalid_op+0x95/0xb0
 [<ffffffffa048f33b>] ? i915_gem_object_unpin+0xab/0xb0 [i915]
 [<ffffffff812a932d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff814b7f51>] ? restore_args+0x30/0x30
 [<ffffffff814c00b5>] invalid_op+0x15/0x20
 [<ffffffffa048f33b>] ? i915_gem_object_unpin+0xab/0xb0 [i915]
 [<ffffffffa0498ffb>] intel_crtc_disable+0x4b/0x60 [i915]
 [<ffffffffa02567d5>] drm_helper_disable_unused_functions+0x115/0x190
[drm_kms_helper]
 [<ffffffffa025805b>] drm_crtc_helper_set_config+0x8db/0x9f0 [drm_kms_helper]
 [<ffffffff81090ba6>] ? mark_held_locks+0x86/0x150
 [<ffffffffa043150e>] drm_framebuffer_cleanup+0xce/0x100 [drm]
 [<ffffffffa0499a91>] intel_user_framebuffer_destroy+0x21/0x70 [i915]
 [<ffffffffa0434143>] drm_mode_rmfb+0xd3/0x130 [drm]
 [<ffffffffa04245d4>] drm_ioctl+0x3d4/0x4b0 [drm]
 [<ffffffffa0434070>] ? drm_mode_addfb+0x180/0x180 [drm]
 [<ffffffff814bb009>] ? sub_preempt_count+0xa9/0xe0
 [<ffffffff8107c341>] ? __srcu_read_unlock+0x41/0x70
 [<ffffffff81191e52>] ? fsnotify+0x282/0x5b0
 [<ffffffff81191c63>] ? fsnotify+0x93/0x5b0
 [<ffffffff81165d58>] do_vfs_ioctl+0x98/0x570
 [<ffffffff81153e70>] ? fget_light+0x340/0x3a0
 [<ffffffff811662c1>] sys_ioctl+0x91/0xa0
 [<ffffffff814befab>] system_call_fastpath+0x16/0x1b
INFO: lockdep is turned off.
Sep  7 21:01:57 linux kernel: [65128.810768] SysRq : Emergency Sync


Zdenek
