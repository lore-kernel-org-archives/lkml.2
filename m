Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab1HYQon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:44:43 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44551 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab1HYQol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:44:41 -0400
MIME-Version: 1.0
Date: Thu, 25 Aug 2011 09:44:41 -0700
Message-ID: <CAOH1cHnymZ1WasD4q+HXbeQb9wBAWmS9f451gEekA0-YjCZtLA@mail.gmail.com>
Subject: 3.0.3 64-bit Crash running fscache/cachefilesd
From: Mark Moseley <moseleymark@gmail.com>
To: Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get this after a handful of hours. It's not terribly deterministic
when it's going to melt down, but typically doesn't last more than a
few hours before panicking.

This is 3.0.3, 64-bit, running Debian Squeeze, running on a usually
stable Dell PE 1950. I'm happy to run any sort of traces or send it
whatever would be useful in debugging (.config, etc). Output is over
IPMI, so it's a tad scrambled, but I didn't want to mess with it for
fear of obscuring something important. Environment is heavy NFS-backed
web hosting. Backing device that the fscache cache is on is an SSD,
but I've seen the same thing on a regular drive. The filesystem for
the fscache cache in the below example is EXT4, but I've seen the same
thing on XFS.

I should mention too that there's nothing special about the 3.0.3
crash. I get similar crashes with 2.6.39.4 and any previous kernel
I've tested. 3.0.3 is just the most recent one I've tested.


[25625.932971] ------------[ cut here ]------------
[25625.942202] kernel BUG at fs/cachefiles/namei.c:166!
[25625.942874] invalid opcode: 0000 [#1] SMP
[25625.942874] CPU 6
[25625.942874] Modules linked in: xfs ioatdma dca loop joydev fan
evdev i5000_edac edac_core psmouse i5k_amb dcdbas serio_raw shpchp
pcspkr pci_hotplug ]
[25625.942874]
[25625.942874] Pid: 23795, comm: kworker/u:5 Not tainted 3.0.3 #1 Dell
Inc. PowerEdge 1950/0DT097
[25625.942874] RIP: 0010:[<ffffffff81299cf3>]  [<ffffffff81299cf3>]
cachefiles_walk_to_object+0xcb3/0xdd0
[25625.942874] RSP: 0018:ffff8801ab84dc60  EFLAGS: 00010282
[25625.942874] RAX: ffff88003935e601 RBX: ffff8801d8cff330 RCX: 000000000047bea6
[25625.942874] RDX: 000000000047bea5 RSI: 0000000000010200 RDI: ffff88022ec02780
[25625.942874] RBP: ffff8801ab84dd50 R08: 000000000047bea5 R09: ffffea0000c83c20
[25625.942874] R10: ffffffff812982aa R11: 0000000000000003 R12: ffff8801d8cff200
[25625.942874] R13: ffff8801a4a06300 R14: ffff880224ffa780 R15: ffff8801c0dddf00
[25625.942874] FS:  0000000000000000(0000) GS:ffff88022fd80000(0000)
knlGS:0000000000000000
[25625.942874] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[25625.942874] CR2: ffffffffff600400 CR3: 00000000016a2000 CR4: 00000000000006f0
[25625.942874] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[25625.942874] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[25625.942874] Process kworker/u:5 (pid: 23795, threadinfo
ffff880082bc6300, task ffff880082bc5e00)
[25625.942874] Stack:
[25625.942874]  0000000000000003 0000000000000000 ffff8801ab84dc90
ffff880082bc5e00
[25625.942874]  ffff880082bc6228 ffff880082bc6228 ffff880082bc6228
ffff8801ab84dd08
[25625.942874]  ffff880082bc5e00 ffff88022eee5310 ffff880104639400
ffff8801f0e5f664
[25625.942874] Call Trace:
[25625.942874]  [<ffffffff81074010>] ? wake_up_bit+0x40/0x40
[25625.942874]  [<ffffffff812973ab>] cachefiles_lookup_object+0x5b/0x170
[25625.942874]  [<ffffffff811ad864>] fscache_lookup_object+0xd4/0x2b0
[25625.942874]  [<ffffffff811ae789>] fscache_object_work_func+0x4f9/0xd60
[25625.942874]  [<ffffffff8106c594>] process_one_work+0x164/0x450
[25625.942874]  [<ffffffff811ae290>] ? fscache_enqueue_dependents+0x120/0x120
[25625.942874]  [<ffffffff8106cc2b>] worker_thread+0x19b/0x430
[25625.942874]  [<ffffffff8106ca90>] ? manage_workers+0x210/0x210
[25625.942874]  [<ffffffff81073abe>] kthread+0x9e/0xb0
[25625.942874]  [<ffffffff81671194>] kernel_thread_helper+0x4/0x10
[25625.942874]  [<ffffffff8166866d>] ? retint_restore_args+0x13/0x13
[25625.942874]  [<ffffffff81073a20>] ? kthread_worker_fn+0x1a0/0x1a0
[25625.942874]  [<ffffffff81671190>] ? gs_change+0xb/0xb
[25625.942874] Code: 00 48 c7 c7 78 6d 90 81 31 c0 e8 92 b0 3c 00 0f
0b eb fe 48 c7 c7 78 7b 90 81 31 c0 e8 80 b0 3c 00 31 f6 4c 89 f7 e8
3d e5 ff ff <0
[25625.942874] RIP  [<ffffffff81299cf3>] cachefiles_walk_to_object+0xcb3/0xdd0
[25625.942874]  RSP <ffff8801ab84dc60>
2011 Aug 25 07:01:04 boscust2102[25626.490246] ---[ end trace
abce6c7388af252a ]---
 [25625.932971] ------------[ cu[25626.505216] Kernel panic - not
syncing: Fatal exception
t here ]--------[25626.520310] Pid: 23795, comm: kworker/u:5 Tainted:
G      D     3.0.3 #1
----
    2011 Aug 25[25626.534651] Call Trace:
 07:01:04 boscus[25626.542237]  [<ffffffff81664c4e>] panic+0xbf/0x1da
t2102 [25625.942[25626.554578]  [<ffffffff8104ef9f>] ? kmsg_dump+0x4f/0x100
874] invalid opc[25626.567722]  [<ffffffff81669655>] oops_end+0xa5/0xf0
ode: 0000 [#1] S[25626.580262]  [<ffffffff810058db>] die+0x5b/0x90
MP
   [25626.592190]  [<ffffffff81669170>] do_trap+0x190/0x1a0
[25626.602854]  [<ffffffff8166bf2a>] ? atomic_notifier_call_chain+0x1a/0x20
[25626.616517]  [<ffffffff810034f5>] do_invalid_op+0x95/0xb0
[25626.627565]  [<ffffffff81299cf3>] ? cachefiles_walk_to_object+0xcb3/0xdd0
[25626.641457]  [<ffffffff812febfa>] ? trace_hardirqs_off_thunk+0x3a/0x6c
[25626.654860]  [<ffffffff812982aa>] ? cachefiles_printk_object+0x7a/0x90
[25626.668259]  [<ffffffff8166869d>] ? restore_args+0x30/0x30
[25626.679472]  [<ffffffff8167101a>] invalid_op+0x1a/0x20
[25626.689963]  [<ffffffff812982aa>] ? cachefiles_printk_object+0x7a/0x90
[25626.703239]  [<ffffffff81299cf3>] ? cachefiles_walk_to_object+0xcb3/0xdd0
[25626.716973]  [<ffffffff81074010>] ? wake_up_bit+0x40/0x40
[25626.727868]  [<ffffffff812973ab>] cachefiles_lookup_object+0x5b/0x170
[25626.740810]  [<ffffffff811ad864>] fscache_lookup_object+0xd4/0x2b0
[25626.753283]  [<ffffffff811ae789>] fscache_object_work_func+0x4f9/0xd60
[25626.766459]  [<ffffffff8106c594>] process_one_work+0x164/0x450
[25626.778255]  [<ffffffff811ae290>] ? fscache_enqueue_dependents+0x120/0x120
[25626.792232]  [<ffffffff8106cc2b>] worker_thread+0x19b/0x430
[25626.803638]  [<ffffffff8106ca90>] ? manage_workers+0x210/0x210
[25626.815400]  [<ffffffff81073abe>] kthread+0x9e/0xb0
[25626.825307]  [<ffffffff81671194>] kernel_thread_helper+0x4/0x10
[25626.837233]  [<ffffffff8166866d>] ? retint_restore_args+0x13/0x13
[25626.849515]  [<ffffffff81073a20>] ? kthread_worker_fn+0x1a0/0x1a0
[25626.861838]  [<ffffffff81671190>] ? gs_change+0xb/0xb
[25626.881978] Rebooting in 120 seconds..
