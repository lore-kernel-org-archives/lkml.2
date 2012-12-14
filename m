Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266Ab2LNFbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 00:31:09 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60959 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab2LNFbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 00:31:07 -0500
MIME-Version: 1.0
Date: Fri, 14 Dec 2012 13:31:05 +0800
Message-ID: <CAM_iQpUpzJpcS215b14613nGAtgHViGHG9UC2We1Z+jJYDRruw@mail.gmail.com>
Subject: [console] INFO: possible circular locking dependency detected
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[  601.058431] ======================================================
[  601.058433] [ INFO: possible circular locking dependency detected ]
[  601.058439] 3.7.0+ #431 Not tainted
[  601.058441] -------------------------------------------------------
[  601.058445] kworker/0:1/17 is trying to acquire lock:
[  601.058572]  ((fb_notifier_list).rwsem){.+.+.+}, at:
[<ffffffff81077e33>] __blocking_notifier_call_chain+0x58/0x8d
[  601.058575]
[  601.058575] but task is already holding lock:
[  601.058633]  (console_lock){+.+.+.}, at: [<ffffffff814f75f6>]
console_callback+0x11/0xfe
[  601.058636]
[  601.058636] which lock already depends on the new lock.
[  601.058636]
[  601.058638]
[  601.058638] the existing dependency chain (in reverse order) is:
[  601.058646]
[  601.058646] -> #1 (console_lock){+.+.+.}:
[  601.058666]        [<ffffffff810a1c5e>] check_prevs_add+0x8b/0x104
[  601.058674]        [<ffffffff810a201e>] validate_chain+0x347/0x383
[  601.058680]        [<ffffffff810a272a>] __lock_acquire+0x3ab/0x424
[  601.058687]        [<ffffffff810a2cfb>] lock_acquire+0xfa/0x145
[  601.058727]        [<ffffffff810508c2>] console_lock+0x71/0x73
[  601.058736]        [<ffffffff814f460a>] register_con_driver+0x3d/0x12a
[  601.058742]        [<ffffffff814f5de3>] take_over_console+0x23/0x4a
[  601.058809]        [<ffffffff8148d713>] fbcon_takeover+0x5c/0x96
[  601.058817]        [<ffffffff81490276>] fbcon_event_notify+0x19a/0x310
[  601.058847]        [<ffffffff8195b274>] notifier_call_chain+0x96/0xcd
[  601.058856]        [<ffffffff81077e4b>]
__blocking_notifier_call_chain+0x70/0x8d
[  601.058862]        [<ffffffff81077e7c>]
blocking_notifier_call_chain+0x14/0x16
[  601.058871]        [<ffffffff8148307f>] fb_notifier_call_chain+0x1b/0x1d
[  601.058878]        [<ffffffff814844dc>] do_register_framebuffer+0x247/0x25e
[  601.058885]        [<ffffffff8148451a>] register_framebuffer+0x27/0x40
[  601.058893]        [<ffffffff81498334>] vga16fb_probe+0x1b6/0x226
[  601.058913]        [<ffffffff8151f5e4>] platform_drv_probe+0x3c/0x68
[  601.058922]        [<ffffffff8151db49>] really_probe+0x99/0x196
[  601.058930]        [<ffffffff8151dd64>] driver_probe_device+0x34/0x4c
[  601.058938]        [<ffffffff8151de38>] __device_attach+0x3a/0x3f
[  601.058945]        [<ffffffff8151c3a6>] bus_for_each_drv+0x59/0x8f
[  601.058951]        [<ffffffff8151dcee>] device_attach+0x79/0x9a
[  601.058958]        [<ffffffff8151d135>] bus_probe_device+0x35/0xae
[  601.058965]        [<ffffffff8151b8cd>] device_add+0x254/0x3d1
[  601.058972]        [<ffffffff8151f338>] platform_device_add+0x14e/0x1b4
[  601.059045]        [<ffffffff823496db>] vga16fb_init+0x88/0xb3
[  601.059065]        [<ffffffff81000256>] do_one_initcall+0x7f/0x13d
[  601.059092]        [<ffffffff8231dbf1>] do_basic_setup+0x96/0xb4
[  601.059099]        [<ffffffff8231dcc5>] kernel_init_freeable+0xb6/0x12b
[  601.059135]        [<ffffffff819218fa>] kernel_init+0xe/0xf2
[  601.059153]        [<ffffffff8195f16c>] ret_from_fork+0x7c/0xb0
[  601.059161]
[  601.059161] -> #0 ((fb_notifier_list).rwsem){.+.+.+}:
[  601.059168]        [<ffffffff810a1a34>] check_prev_add+0x68/0x207
[  601.059175]        [<ffffffff810a1c5e>] check_prevs_add+0x8b/0x104
[  601.059181]        [<ffffffff810a201e>] validate_chain+0x347/0x383
[  601.059187]        [<ffffffff810a272a>] __lock_acquire+0x3ab/0x424
[  601.059194]        [<ffffffff810a2cfb>] lock_acquire+0xfa/0x145
[  601.059212]        [<ffffffff81955614>] down_read+0x51/0x84
[  601.059221]        [<ffffffff81077e33>]
__blocking_notifier_call_chain+0x58/0x8d
[  601.059227]        [<ffffffff81077e7c>]
blocking_notifier_call_chain+0x14/0x16
[  601.059234]        [<ffffffff8148307f>] fb_notifier_call_chain+0x1b/0x1d
[  601.059241]        [<ffffffff8148375a>] fb_blank+0x3b/0x8a
[  601.059248]        [<ffffffff8148de15>] fbcon_blank+0xfb/0x1ee
[  601.059254]        [<ffffffff814f50be>] do_blank_screen+0x150/0x1cf
[  601.059261]        [<ffffffff814f76b8>] console_callback+0xd3/0xfe
[  601.059277]        [<ffffffff81069955>] process_one_work+0x249/0x3ff
[  601.059306]        [<ffffffff8106a909>] worker_thread+0x140/0x1d7
[  601.059314]        [<ffffffff81071d29>] kthread+0xb1/0xb9
[  601.059321]        [<ffffffff8195f16c>] ret_from_fork+0x7c/0xb0
[  601.059323]
[  601.059323] other info that might help us debug this:
[  601.059323]
[  601.059325]  Possible unsafe locking scenario:
[  601.059325]
[  601.059327]        CPU0                    CPU1
[  601.059329]        ----                    ----
[  601.059334]   lock(console_lock);
[  601.059339]                                lock((fb_notifier_list).rwsem);
[  601.059343]                                lock(console_lock);
[  601.059348]   lock((fb_notifier_list).rwsem);
[  601.059350]
[  601.059350]  *** DEADLOCK ***
[  601.059350]
[  601.059353] 3 locks held by kworker/0:1/17:
[  601.059365]  #0:  (events){.+.+.+}, at: [<ffffffff81069895>]
process_one_work+0x189/0x3ff
[  601.059376]  #1:  (console_work){+.+...}, at: [<ffffffff81069895>]
process_one_work+0x189/0x3ff
[  601.059388]  #2:  (console_lock){+.+.+.}, at: [<ffffffff814f75f6>]
console_callback+0x11/0xfe
[  601.059389]
[  601.059389] stack backtrace:
[  601.059395] Pid: 17, comm: kworker/0:1 Not tainted 3.7.0+ #431
[  601.059397] Call Trace:
[  601.059409]  [<ffffffff819366e6>] print_circular_bug+0xc8/0xd9
[  601.059417]  [<ffffffff810a1a34>] check_prev_add+0x68/0x207
[  601.059438]  [<ffffffff810b0019>] ? is_module_text_address+0x23/0x30
[  601.059447]  [<ffffffff810aceff>] ? __module_text_address+0x14/0x5e
[  601.059456]  [<ffffffff81029d4d>] ? pvclock_clocksource_read+0x48/0xb4
[  601.059463]  [<ffffffff810a1c5e>] check_prevs_add+0x8b/0x104
[  601.059470]  [<ffffffff810a201e>] validate_chain+0x347/0x383
[  601.059477]  [<ffffffff810a272a>] __lock_acquire+0x3ab/0x424
[  601.059486]  [<ffffffff81077e33>] ? __blocking_notifier_call_chain+0x58/0x8d
[  601.059492]  [<ffffffff810a2cfb>] lock_acquire+0xfa/0x145
[  601.059500]  [<ffffffff81077e33>] ? __blocking_notifier_call_chain+0x58/0x8d
[  601.059506]  [<ffffffff8109f925>] ? lock_is_held+0x56/0x62
[  601.059515]  [<ffffffff81955614>] down_read+0x51/0x84
[  601.059522]  [<ffffffff81077e33>] ? __blocking_notifier_call_chain+0x58/0x8d
[  601.059530]  [<ffffffff81077c8f>] ? rcu_read_lock_held+0x34/0x3c
[  601.059537]  [<ffffffff81077e33>] __blocking_notifier_call_chain+0x58/0x8d
[  601.059544]  [<ffffffff81077e7c>] blocking_notifier_call_chain+0x14/0x16
[  601.059551]  [<ffffffff8148307f>] fb_notifier_call_chain+0x1b/0x1d
[  601.059558]  [<ffffffff8148375a>] fb_blank+0x3b/0x8a
[  601.059565]  [<ffffffff8148de15>] fbcon_blank+0xfb/0x1ee
[  601.059573]  [<ffffffff81957547>] ? _raw_spin_unlock_irqrestore+0x45/0x61
[  601.059580]  [<ffffffff810a3211>] ? trace_hardirqs_on_caller+0x12d/0x164
[  601.059588]  [<ffffffff8195754f>] ? _raw_spin_unlock_irqrestore+0x4d/0x61
[  601.059598]  [<ffffffff8105dd22>] ? try_to_del_timer_sync+0x5f/0x6b
[  601.059605]  [<ffffffff8105dde9>] ? del_timer_sync+0xbb/0xce
[  601.059612]  [<ffffffff8105dd33>] ? del_timer_sync+0x5/0xce
[  601.059619]  [<ffffffff814f50be>] do_blank_screen+0x150/0x1cf
[  601.059625]  [<ffffffff814f76b8>] console_callback+0xd3/0xfe
[  601.059631]  [<ffffffff81069955>] process_one_work+0x249/0x3ff
[  601.059637]  [<ffffffff81069895>] ? process_one_work+0x189/0x3ff
[  601.059644]  [<ffffffff814f75e5>] ? poke_blanked_console+0xc8/0xc8
[  601.059651]  [<ffffffff8106a909>] worker_thread+0x140/0x1d7
[  601.059658]  [<ffffffff8106a7c9>] ? manage_workers+0xee/0xee
[  601.059663]  [<ffffffff81071d29>] kthread+0xb1/0xb9
[  601.059671]  [<ffffffff81071c78>] ? __init_kthread_worker+0x59/0x59
[  601.059678]  [<ffffffff8195f16c>] ret_from_fork+0x7c/0xb0
[  601.059684]  [<ffffffff81071c78>] ? __init_kthread_worker+0x59/0x59
