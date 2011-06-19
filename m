Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab1FSANA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 20:13:00 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58409 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab1FSAM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 20:12:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=R5eYpmFSeiC2A2IREKnnJ6dIShzp7yKx/q1XaYoL5Ri8peuOgJrWfLfKm3xhmuWsHY
         xHR8pbVYShYkn3AXzyaNBAGgUdwNChTuLwH4/UZ+vRNcuhkZ0T2iAOF4Ll650xgvnMRE
         N6ultoNgvz3wKCQYMqeyLtObQ2S3MWr77Xxg8=
MIME-Version: 1.0
Date: Sat, 18 Jun 2011 19:12:57 -0500
Message-ID: <BANLkTik3iseHFah_s=NNasQ22NtA+9zLWA@mail.gmail.com>
Subject: tracing kernel panics
From: Shane <software.research.development@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyone offer advice on how I should go about tracking down this kernel
panic? Apologies if I've got the wrong list, let me know.

I'm developing a networking module, my own protocol over TCP. I load
my module, I make a network connection, and then I close it. I do
nothing more, then after about 1-2 minutes, it throws this panic
output and none of it seems to come from my module code. I know my
code is the problem, and if I don't run my modules, I never get
panics. But nothing in the stack trace I recognize from my code and
I'm having a very hard time find where in my code I've gone wrong. I
run my kernel modules in a VM as a guest OS which connects to another
guest OS (currently using 2.6.36-r5).

I've read how to analyze an OOPS, but ... here I can't even find the
file that this might belong to so as to disassemble it, or understand
what device this is. Any suggestions/pointers/advice much appreciated?


[  330.828880] general protection fault: 0000 [#1] SMP
[  330.829809] last sysfs file: /sys/devices/virtio-pci/virtio1/block/vda/dev
[  330.829809] CPU 0
[  330.829809] Modules linked in: mod1 mod2
[  330.829809]
[  330.829809] Pid: 0, comm: swapper Not tainted 2.6.36-gentoo-r5 #8 /Bochs
[  330.829809] RIP: 0010:[<ffffffff8148c3f3>]  [<ffffffff8148c3f3>]
fib_table_lookup+0x48/0x9e
[  330.829809] RSP: 0018:ffff880001e038f0  EFLAGS: 00010246
[  330.829809] RAX: 0000000000000000 RBX: ffff88001f1edac0 RCX: 0000000000000018
[  330.829809] RDX: 00000000000000c0 RSI: ffff88001f1edac0 RDI: 00000000000000c0
[  330.829809] RBP: ffff880001e03920 R08: ffffffff81c48a10 R09: ffff880001e03b48
[  330.829809] R10: 000000001564a8c0 R11: 00000000fe64a8c0 R12: 0001e00000010100
[  330.829809] R13: 000000001e0488c0 R14: ffff880001e039f0 R15: ffff880001e03a30
[  330.829809] FS:  0000000000000000(0000) GS:ffff880001e00000(0000)
knlGS:0000000000000000
[  330.829809] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  330.829809] CR2: 00007f608e5a1240 CR3: 000000001f0ee000 CR4: 00000000000006f0
[  330.829809] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  330.829809] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  330.829809] Process swapper (pid: 0, threadinfo ffffffff81a00000,
task ffffffff81a11020)
[  330.829809] Stack:
[  330.829809]  ffff880001e03910 ffff880001e039f0 ffff880001e039a0
ffff88001fa57a80
[  330.829809] <0> ffff880001e039a0 0000000000000000 ffff880001e03940
ffffffff8148d61c
[  330.829809] <0> ffff88001fa57240 ffff880001e039f0 ffff880001e03990
ffffffff81438045
[  330.829809] Call Trace:
[  330.829809]  <IRQ>
[  330.829809]  [<ffffffff8148d61c>] fib4_rule_action+0x4e/0x5c
[  330.829809]  [<ffffffff81438045>] fib_rules_lookup+0xa2/0xd8
[  330.829809]  [<ffffffff8148d6eb>] fib_lookup+0x32/0x43
[  330.829809]  [<ffffffff814889c1>] fib_validate_source+0x23a/0x247
[  330.829809]  [<ffffffff81459845>] ip_route_input_slow+0x19b/0x85b
[  330.829809]  [<ffffffff8145a382>] ip_route_input_common+0x47d/0x493
[  330.829809]  [<ffffffff81059608>] ? check_preempt_curr_idle+0x10/0x12
[  330.829809]  [<ffffffff8107d8e0>] ? wq_worker_waking_up+0x10/0x3b
[  330.829809]  [<ffffffff8147f763>] arp_process+0x1a8/0x4e9
[  330.829809]  [<ffffffff8104b236>] ? pvclock_clocksource_read+0x4b/0xb4
[  330.829809]  [<ffffffff8147f5bb>] ? arp_process+0x0/0x4e9
[  330.829809]  [<ffffffff8147f14f>] T.964+0x4c/0x54
[  330.829809]  [<ffffffff8147f400>] arp_rcv+0xcb/0xe0
[  330.829809]  [<ffffffff81425a98>] __netif_receive_skb+0x3cd/0x3f3
[  330.829809]  [<ffffffff81426922>] netif_receive_skb+0x67/0x6e
[  330.829809]  [<ffffffff8141f561>] ? __netdev_alloc_skb+0x2f/0x4c
[  330.829809]  [<ffffffff813367c2>] virtnet_poll+0x4b3/0x58e
[  330.829809]  [<ffffffff81043857>] ? lapic_next_event+0x18/0x1c
[  330.829809]  [<ffffffff8104b236>] ? pvclock_clocksource_read+0x4b/0xb4
[  330.829809]  [<ffffffff81426ae6>] net_rx_action+0xad/0x211
[  330.829809]  [<ffffffff8106d6b8>] __do_softirq+0xe4/0x1ac
[  330.829809]  [<ffffffff810b21fc>] ? handle_IRQ_event+0x52/0x11d
[  330.829809]  [<ffffffff8102c95c>] call_softirq+0x1c/0x28
[  330.829809]  [<ffffffff8102dee1>] do_softirq+0x41/0x7e
[  330.829809]  [<ffffffff8106d52f>] irq_exit+0x36/0x78
[  330.829809]  [<ffffffff8102d61c>] do_IRQ+0xa7/0xbe
[  330.829809]  [<ffffffff815551d3>] ret_from_intr+0x0/0x11
[  330.829809]  <EOI>
[  330.829809]  [<ffffffff8104a8f0>] ? native_safe_halt+0x6/0x8
[  330.829809]  [<ffffffff81032ccc>] default_idle+0x39/0x56
[  330.829809]  [<ffffffff8102ab84>] cpu_idle+0x67/0xd9
[  330.829809]  [<ffffffff81537219>] rest_init+0x6d/0x6f
[  330.829809]  [<ffffffff81aeed0b>] start_kernel+0x384/0x38f
[  330.829809]  [<ffffffff81aee2ac>] x86_64_start_reservations+0xb3/0xb7
[  330.829809]  [<ffffffff81aee3ab>] x86_64_start_kernel+0xfb/0x10a
[  330.829809] Code: 14 ae aa 81 e8 86 89 0c 00 48 8b 9b 20 01 00 00
eb 52 44 8b 6b 20 4c 8b 63 08 45 23 6e 0c 48 89 de 44 89 ef e8 9f f7
ff ff 89 c0 <4d> 8b 24 c4 eb 1b 8b 4b 1c 49 8d 7c 24 10 4c 89 fa 4c 89
f6 e8
[  330.829809] RIP  [<ffffffff8148c3f3>] fib_table_lookup+0x48/0x9e
[  330.829809]  RSP <ffff880001e038f0>
[  330.898565] ---[ end trace 7718620ea31b2192 ]---
[  330.899433] Kernel panic - not syncing: Fatal exception in interrupt
[  330.900596] Pid: 0, comm: swapper Tainted: G      D     2.6.36-gentoo-r5 #8
[  330.901878] Call Trace:
[  330.902348]  <IRQ>  [<ffffffff81552f21>] panic+0x8c/0x19a
[  330.903362]  [<ffffffff81068744>] ? kmsg_dump+0x126/0x140
[  330.904356]  [<ffffffff81555fab>] oops_end+0xb1/0xc1
[  330.905271]  [<ffffffff8102ef35>] die+0x55/0x5e
[  330.906120]  [<ffffffff81555b86>] do_general_protection+0x130/0x138
[  330.907273]  [<ffffffff815553f5>] general_protection+0x25/0x30
[  330.908347]  [<ffffffff8148c3f3>] ? fib_table_lookup+0x48/0x9e
[  330.909418]  [<ffffffff8148d61c>] fib4_rule_action+0x4e/0x5c
[  330.910455]  [<ffffffff81438045>] fib_rules_lookup+0xa2/0xd8
[  330.911496]  [<ffffffff8148d6eb>] fib_lookup+0x32/0x43
[  330.912447]  [<ffffffff814889c1>] fib_validate_source+0x23a/0x247
[  330.913567]  [<ffffffff81459845>] ip_route_input_slow+0x19b/0x85b
[  330.914687]  [<ffffffff8145a382>] ip_route_input_common+0x47d/0x493
[  330.915863]  [<ffffffff81059608>] ? check_preempt_curr_idle+0x10/0x12
[  330.917042]  [<ffffffff8107d8e0>] ? wq_worker_waking_up+0x10/0x3b
[  330.918150]  [<ffffffff8147f763>] arp_process+0x1a8/0x4e9
[  330.919137]  [<ffffffff8104b236>] ? pvclock_clocksource_read+0x4b/0xb4
[  330.920319]  [<ffffffff8147f5bb>] ? arp_process+0x0/0x4e9
[  330.921309]  [<ffffffff8147f14f>] T.964+0x4c/0x54
[  330.922179]  [<ffffffff8147f400>] arp_rcv+0xcb/0xe0
[  330.923077]  [<ffffffff81425a98>] __netif_receive_skb+0x3cd/0x3f3
[  330.924195]  [<ffffffff81426922>] netif_receive_skb+0x67/0x6e
[  330.925248]  [<ffffffff8141f561>] ? __netdev_alloc_skb+0x2f/0x4c
[  330.926344]  [<ffffffff813367c2>] virtnet_poll+0x4b3/0x58e
[  330.927354]  [<ffffffff81043857>] ? lapic_next_event+0x18/0x1c
[  330.928441]  [<ffffffff8104b236>] ? pvclock_clocksource_read+0x4b/0xb4
[  330.929636]  [<ffffffff81426ae6>] net_rx_action+0xad/0x211
[  330.930648]  [<ffffffff8106d6b8>] __do_softirq+0xe4/0x1ac
[  330.931645]  [<ffffffff810b21fc>] ? handle_IRQ_event+0x52/0x11d
[  330.932756]  [<ffffffff8102c95c>] call_softirq+0x1c/0x28
[  330.933737]  [<ffffffff8102dee1>] do_softirq+0x41/0x7e
[  330.934674]  [<ffffffff8106d52f>] irq_exit+0x36/0x78
[  330.935600]  [<ffffffff8102d61c>] do_IRQ+0xa7/0xbe
[  330.936495]  [<ffffffff815551d3>] ret_from_intr+0x0/0x11
[  330.937477]  <EOI>  [<ffffffff8104a8f0>] ? native_safe_halt+0x6/0x8
[  330.938646]  [<ffffffff81032ccc>] default_idle+0x39/0x56
[  330.939636]  [<ffffffff8102ab84>] cpu_idle+0x67/0xd9
[  330.940552]  [<ffffffff81537219>] rest_init+0x6d/0x6f
[  330.941489]  [<ffffffff81aeed0b>] start_kernel+0x384/0x38f
[  330.942499]  [<ffffffff81aee2ac>] x86_64_start_reservations+0xb3/0xb7
[  330.943680]  [<ffffffff81aee3ab>] x86_64_start_kernel+0xfb/0x10a



The following two panics are very similar, and common panics that I
get as well. I threw them in here in case anyone recognized these
aswell or could give clues on how to find such problems.


[   80.945614] BUG: unable to handle kernel paging request at ffffffff8141a744
[   80.946046] IP: [<ffffffff812cfdfb>] do_virtblk_request+0x73/0x27c
[   80.946046] PGD 1a0b067 PUD 1a0f063 PMD 14001e1
[   80.946046] Oops: 0003 [#1] SMP
[   80.946046] last sysfs file: /sys/devices/virtio-pci/virtio1/block/vda/dev
[   80.946046] CPU 0
[   80.946046] Modules linked in: mod1 mod2
[   80.946046]
[   80.946046] Pid: 1271, comm: flush-253:0 Not tainted
2.6.36-gentoo-r5 #8 /Bochs
[   80.946046] RIP: 0010:[<ffffffff812cfdfb>]
[<ffffffff812cfdfb>]do_virtblk_request+0x73/0x27c
[   80.946046] RSP: 0018:ffff88001e941750  EFLAGS: 00010082
[   80.946046] RAX: ffffffff8141a734 RBX: ffffffff8141a734 RCX: 0000000000000040
[   80.946046] RDX: 0000000000000040 RSI: ffffffff8141a734 RDI: ffffffff810d5be2
[   80.946046] RBP: ffff88001e9417c0 R08: 0000000000011220 R09: ffff88001e941740
[   80.946046] R10: ffff88001f2d2b88 R11: ffff88001f2700c0 R12: ffff88001fa52000
[   80.946046] R13: ffff88001f2d2b88 R14: 0000000000000002 R15: ffff88001f2ae618
[   80.946046] FS:  0000000000000000(0000)
GS:ffff880001e00000(0000)knlGS:0000000000000000
[   80.946046] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   80.946046] CR2: ffffffff8141a744 CR3: 000000001edea000 CR4: 00000000000006f0
[   80.946046] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   80.946046] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   80.946046] Process flush-253:0 (pid: 1271, threadinfo
ffff88001e940000, task ffff88001edf2530)
[   80.946046] Stack:
[   80.946046]  0000000000000000 0000000000000001
0000000000000001ffff88001fa52020
[   80.946046] <0> ffff88001fa52060 ffff88001fa52040
000000011e9417b00000000000000001
[   80.946046] <0> ffff88001f2ae618 ffff88001f2ae618
ffff88001f2ae618ffff88001f2d2e18
[   80.946046] Call Trace:
[   80.946046]  [<ffffffff811d85fa>] __generic_unplug_device+0x32/0x37
[   80.946046]  [<ffffffff811d30f5>] elv_insert+0x1d6/0x1df
[   80.946046]  [<ffffffff811d3196>] __elv_add_request+0x98/0x9f
[   80.946046]  [<ffffffff811d8d01>] __make_request+0x3c2/0x44b
[   80.946046]  [<ffffffff811d7400>] generic_make_request+0x287/0x2f7
[   80.946046]  [<ffffffff811d7400>] ? generic_make_request+0x287/0x2f7
[   80.946046]  [<ffffffff811f593d>] ? __percpu_counter_add+0x47/0x63
[   80.946046]  [<ffffffff811d7537>] submit_bio+0xc7/0xd0
[   80.946046]  [<ffffffff8112e081>] submit_bh+0xe6/0x108
[   80.946046]  [<ffffffff81130663>] __block_write_full_page+0x1d8/0x2b7
[   80.946046]  [<ffffffff8112f45b>] ? end_buffer_async_write+0x0/0x112
[   80.946046]  [<ffffffff8112f45b>] ? end_buffer_async_write+0x0/0x112
[   80.946046]  [<ffffffff811307c6>] block_write_full_page_endio+0x84/0x90
[   80.946046]  [<ffffffff811307e2>] block_write_full_page+0x10/0x12
[   80.946046]  [<ffffffff81167bbb>] ext3_writeback_writepage+0xad/0x123
[   80.946046]  [<ffffffff810da749>] __writepage+0x12/0x2b
[   80.946046]  [<ffffffff810db9cb>] write_cache_pages+0x25d/0x38a
[   80.946046]  [<ffffffff810da737>] ? __writepage+0x0/0x2b
[   80.946046]  [<ffffffff810dbb17>] generic_writepages+0x1f/0x21
[   80.946046]  [<ffffffff810dbb3c>] do_writepages+0x23/0x25
[   80.946046]  [<ffffffff81128934>] writeback_single_inode+0x9b/0x1fd
[   80.946046]  [<ffffffff81128dbf>] writeback_sb_inodes+0xae/0x120
[   80.946046]  [<ffffffff811294a2>] writeback_inodes_wb+0x111/0x123
[   80.946046]  [<ffffffff811296a0>] wb_writeback+0x1ec/0x313
[   80.946046]  [<ffffffff81074185>] ? try_to_del_timer_sync+0x76/0x84
[   80.946046]  [<ffffffff81129933>] wb_do_writeback+0x16c/0x18a
[   80.946046]  [<ffffffff81129a15>] bdi_writeback_thread+0xc4/0x1fd
[   80.946046]  [<ffffffff81129951>] ? bdi_writeback_thread+0x0/0x1fd
[   80.946046]  [<ffffffff81129951>] ? bdi_writeback_thread+0x0/0x1fd
[   80.946046]  [<ffffffff81080e60>] kthread+0x7d/0x85
[   80.946046]  [<ffffffff8102c864>] kernel_thread_helper+0x4/0x10
[   80.946046]  [<ffffffff81080de3>] ? kthread+0x0/0x85
[   80.946046]  [<ffffffff8102c860>] ? kernel_thread_helper+0x0/0x10
[   80.946046] Code: 00 00 83 c0 02 41 3b 44 24 38 76 04 0f 0b eb fe
49 8b 7c 24 30 be 20 00 00 00 e8 ef 5e e0 ff 48 89 c3 48 85 c0 0f 84
cc 01 00 00 <4c> 89 68 10 41 f6 45 43 04 74 09 c7 40 18 04 00 00 00 eb
36 41
[   80.946046] RIP  [<ffffffff812cfdfb>] do_virtblk_request+0x73/0x27c
[   80.946046]  RSP <ffff88001e941750>
[   80.946046] CR2: ffffffff8141a744
[   80.946046] ---[ end trace 374c5ac65f1b6e14 ]---


Another similiar OOPS ...


[  331.384306] BUG: unable to handle kernel paging request at 000000001ec0f398
[  331.385053] IP: [<ffffffff81106e32>] __kmalloc+0xd3/0x138
[  331.385053] PGD 1f0f7067 PUD 1f0f8067 PMD 0
[  331.385053] Oops: 0000 [#1] SMP
[  331.385053] last sysfs file: /sys/devices/virtio-pci/virtio1/block/vda/dev
[  331.385053] CPU 0
[  331.385053] Modules linked in: mod1 mod2
[  331.385053]
[  331.385053] Pid: 1267, comm: flush-253:0 Not
tainted2.6.36-gentoo-r5 #8 /Bochs
[  331.385053] RIP: 0010:[<ffffffff81106e32>]
[<ffffffff81106e32>]__kmalloc+0xd3/0x138
[  331.385053] RSP: 0018:ffff88001f08b690  EFLAGS: 00010002
[  331.385053] RAX: 0000000000000000 RBX: 000000001ec0f398 RCX: ffffffff81273866
[  331.385053] RDX: 0000000000000003 RSI: 0000000000000020 RDI: 0000000000000006
[  331.385053] RBP: ffff88001f08b6d0 R08: ffff880001e10390 R09: 0000000000000020
[  331.385053] R10: 0000160000000000 R11: 0000000000000000 R12: ffffffff81a04290
[  331.385053] R13: 0000000000000030 R14: 0000000000000020 R15: 0000000000000020
[  331.385053] FS:  0000000000000000(0000)
GS:ffff880001e00000(0000)knlGS:0000000000000000
[  331.385053] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  331.385053] CR2: 000000001ec0f398 CR3: 000000001fa85000 CR4: 00000000000006f0
[  331.385053] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  331.385053] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  331.385053] Process flush-253:0 (pid: 1267,
threadinfoffff88001f08a000, task ffff88001e8e8000)
[  331.385053] Stack:
[  331.385053]  ffff88001f08b6f8 0000000000000046
ffff88001f08b6b0ffff88001fafe800
[  331.385053] <0> 0000000000000002 ffff88001f962040
0000000000000001ffff88001ec0f3c0
[  331.385053] <0> ffff88001f08b740 ffffffff81273866
ffff88001f2a6618ffff88001f2a6618
[  331.385053] Call Trace:
[  331.385053]  [<ffffffff81273866>] virtqueue_add_buf_gfp+0x5b/0x356
[  331.385053]  [<ffffffff811d7941>] ? blk_peek_request+0x41/0x1a7
[  331.385053]  [<ffffffff812cff8f>] do_virtblk_request+0x207/0x27c
[  331.385053]  [<ffffffff811d85fa>] __generic_unplug_device+0x32/0x37
[  331.385053]  [<ffffffff811d30f5>] elv_insert+0x1d6/0x1df
[  331.385053]  [<ffffffff811d3196>] __elv_add_request+0x98/0x9f
[  331.385053]  [<ffffffff811d8d01>] __make_request+0x3c2/0x44b
[  331.385053]  [<ffffffff811d7400>] generic_make_request+0x287/0x2f7
[  331.385053]  [<ffffffff811d7400>] ? generic_make_request+0x287/0x2f7
[  331.385053]  [<ffffffff811d7537>] submit_bio+0xc7/0xd0
[  331.385053]  [<ffffffff8112e081>] submit_bh+0xe6/0x108
[  331.385053]  [<ffffffff81130663>] __block_write_full_page+0x1d8/0x2b7
[  331.385053]  [<ffffffff8112f45b>] ? end_buffer_async_write+0x0/0x112
[  331.385053]  [<ffffffff8112f45b>] ? end_buffer_async_write+0x0/0x112
[  331.385053]  [<ffffffff811307c6>] block_write_full_page_endio+0x84/0x90
[  331.385053]  [<ffffffff811307e2>] block_write_full_page+0x10/0x12
[  331.385053]  [<ffffffff81167bbb>] ext3_writeback_writepage+0xad/0x123
[  331.385053]  [<ffffffff810da749>] __writepage+0x12/0x2b
[  331.385053]  [<ffffffff810db9cb>] write_cache_pages+0x25d/0x38a
[  331.385053]  [<ffffffff810da737>] ? __writepage+0x0/0x2b
[  331.385053]  [<ffffffff810dbb17>] generic_writepages+0x1f/0x21
[  331.385053]  [<ffffffff810dbb3c>] do_writepages+0x23/0x25
[  331.385053]  [<ffffffff81128934>] writeback_single_inode+0x9b/0x1fd
[  331.385053]  [<ffffffff81128dbf>] writeback_sb_inodes+0xae/0x120
[  331.385053]  [<ffffffff811294a2>] writeback_inodes_wb+0x111/0x123
[  331.385053]  [<ffffffff811296a0>] wb_writeback+0x1ec/0x313
[  331.385053]  [<ffffffff81074185>] ? try_to_del_timer_sync+0x76/0x84
[  331.385053]  [<ffffffff81129933>] wb_do_writeback+0x16c/0x18a
[  331.385053]  [<ffffffff81129a15>] bdi_writeback_thread+0xc4/0x1fd
[  331.385053]  [<ffffffff81129951>] ? bdi_writeback_thread+0x0/0x1fd
[  331.385053]  [<ffffffff81129951>] ? bdi_writeback_thread+0x0/0x1fd
[  331.385053]  [<ffffffff81080e60>] kthread+0x7d/0x85
[  331.385053]  [<ffffffff8102c864>] kernel_thread_helper+0x4/0x10
[  331.385053]  [<ffffffff81080de3>] ? kthread+0x0/0x85
[  331.385053]  [<ffffffff8102c860>] ? kernel_thread_helper+0x0/0x10
[  331.385053] Code: 44 00 00 48 89 45 c8 fa 66 0f 1f 44 00 00 65 4c
8b 04 25 a0 d5 00 00 49 8b 04 24 49 01 c0 49 8b 18 48 85 db 74 0e 49
63 44 24 18 <48> 8b 04 03 49 89 00 eb 11 83 ca ff 44 89 fe 4c 89 e7 e8
ac f0
[  331.385053] RIP  [<ffffffff81106e32>] __kmalloc+0xd3/0x138
[  331.385053]  RSP <ffff88001f08b690>
[  331.385053] CR2: 000000001ec0f398
[  331.385053] ---[ end trace c03bf8afe807b25a ]---
