Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab2LEPbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 10:31:47 -0500
Received: from fallback4.ngs.ru ([195.19.71.24]:52900 "EHLO smtpout.ngs.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058Ab2LEPbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 10:31:45 -0500
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Dec 2012 10:31:45 EST
Message-ID: <50BF66A0.1050503@eml.ru>
Date: Wed, 05 Dec 2012 22:22:08 +0700
From: Bokhan Artem <art@eml.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/15.0 Thunderbird/15.0a1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel BUG at /build/buildd/linux-2.6.32/mm/mempolicy.c
Content-Type: multipart/mixed;
 boundary="------------030309010400020307080908"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030309010400020307080908
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello.

We have several servers with mongodb running. Each server has several mongodb 
instances. Mongodb dataset is larger then availiable memory (mongodb uses 
memory-mapped files for all disk I/O).
2.6.32 and 2.6.38 kernels periodically crash and crash happens only with mongodb 
servers.

2.6.38's trace is in attachment.
For 2.6.32 I only have "kernel BUG at 
/build/buildd/linux-2.6.32/mm/mempolicy.c:1489!"

Heed help! :)

--------------030309010400020307080908
Content-Type: text/x-log;
 name="mongodb2_2.6.38-15_kernel_trace.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mongodb2_2.6.38-15_kernel_trace.log"

[10153.490832] ------------[ cut here ]------------
[10153.495452] kernel BUG at /build/buildd/linux-lts-backport-natty-2.6.38/mm/mempolicy.c:1606!
[10153.503879] invalid opcode: 0000 [#1] SMP 
[10153.508007] last sysfs file: /sys/module/megaraid_sas/version
[10153.513752] CPU 2 
[10153.515594] Modules linked in: ipmi_si ipmi_devintf ipmi_msghandler ghes lp psmouse i7core_edac edac_core hed serio_raw joydev ioatdma parport usbhid hid igb megaraid_sas dca
[10153.531904] 
[10153.533412] Pid: 34275, comm: mongod Not tainted 2.6.38-15-server #66~lucid1-Ubuntu Supermicro X8DTT/X8DTT
[10153.543178] RIP: 0010:[<ffffffff81148afe>]  [<ffffffff81148afe>] slab_node+0x2e/0x90
[10153.550965] RSP: 0018:ffff8800bf443890  EFLAGS: 00010097
[10153.556287] RAX: 0000000000000000 RBX: ffff88063f802800 RCX: 0000000000000000
[10153.563434] RDX: 00000000000003e8 RSI: 0000000000000020 RDI: ffff880553a40e70
[10153.570582] RBP: ffff8800bf4438a0 R08: 00000000000003e8 R09: ffffffff8153dcc1
[10153.577736] R10: 00000000e2979754 R11: 0000000000000002 R12: 0000000000000020
[10153.584876] R13: 0000000000000002 R14: ffff8800bf4438c8 R15: 00000000ffffffff
[10153.592084] FS:  0000000000000000(0000) GS:ffff8800bf440000(0000) knlGS:0000000000000000
[10153.600200] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[10153.605952] CR2: 00007f61f0221fd8 CR3: 000000060bc84000 CR4: 00000000000006e0
[10153.613090] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[10153.620289] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[10153.627428] Process mongod (pid: 34275, threadinfo ffff880b8cac6000, task ffff880b3f6cc4a0)
[10153.635794] Stack:
[10153.637827]  ffff8800bf453cc0 ffff8800bf453cc0 ffff8800bf443900 ffffffff81151dd0
[10153.645330]  0000000000000086 ffff880b3f6cc4a0 ffff8800bf443930 ffffffff8105f7f3
[10153.652831]  ffff8800bf443940 ffff88063f802800 0000000000000000 0000000000000000
[10153.660334] Call Trace:
[10153.662799]  <IRQ> 
[10153.664939]  [<ffffffff81151dd0>] get_any_partial+0xa0/0x190
[10153.670606]  [<ffffffff8105f7f3>] ? try_to_wake_up+0xc3/0x410
[10153.676369]  [<ffffffff81153f2b>] __slab_alloc+0x1eb/0x320
[10153.681864]  [<ffffffff8153dcc1>] ? tcp_v4_conn_request+0x101/0x6b0
[10153.688143]  [<ffffffff811549e2>] kmem_cache_alloc+0x102/0x110
[10153.693986]  [<ffffffff81038d99>] ? default_spin_lock_flags+0x9/0x10
[10153.700353]  [<ffffffff8153dcc1>] tcp_v4_conn_request+0x101/0x6b0
[10153.706455]  [<ffffffff814d597c>] ? sk_reset_timer+0x1c/0x30
[10153.712130]  [<ffffffff815342c3>] tcp_rcv_state_process+0xc3/0x4f0
[10153.718325]  [<ffffffff8153c0b3>] tcp_v4_do_rcv+0xa3/0x1c0
[10153.723818]  [<ffffffff8153d929>] tcp_v4_rcv+0x5a9/0x840
[10153.729141]  [<ffffffff812d88c3>] ? cpumask_next_and+0x23/0x40
[10153.734991]  [<ffffffff8151a58d>] ip_local_deliver_finish+0xdd/0x290
[10153.741356]  [<ffffffff8151a7c0>] ip_local_deliver+0x80/0x90
[10153.747025]  [<ffffffff81519d91>] ip_rcv_finish+0x121/0x3f0
[10153.752605]  [<ffffffff8151a3dd>] ip_rcv+0x23d/0x310
[10153.757580]  [<ffffffff814e404a>] __netif_receive_skb+0x40a/0x690
[10153.763679]  [<ffffffff814e9700>] netif_receive_skb+0x80/0x90
[10153.769434]  [<ffffffff814e9860>] napi_skb_finish+0x50/0x70
[10153.775014]  [<ffffffff814e9d05>] napi_gro_receive+0xc5/0xd0
[10153.780687]  [<ffffffffa0038eec>] igb_poll+0x71c/0x1220 [igb]
[10153.786454]  [<ffffffff81052775>] ? enqueue_entity+0x145/0x290
[10153.792303]  [<ffffffff8105290b>] ? enqueue_task_fair+0x4b/0xd0
[10153.798231]  [<ffffffff814bb7f6>] ? dma_issue_pending_all+0x86/0xc0
[10153.804512]  [<ffffffff814e9ee8>] net_rx_action+0x108/0x2d0
[10153.810092]  [<ffffffff8108b6a8>] ? __hrtimer_start_range_ns+0x188/0x480
[10153.816807]  [<ffffffff8106bf8b>] __do_softirq+0xab/0x200
[10153.822246]  [<ffffffff810d1b60>] ? handle_IRQ_event+0x50/0x170
[10153.828185]  [<ffffffff8100cf5c>] call_softirq+0x1c/0x30
[10153.833506]  [<ffffffff8100e9c5>] do_softirq+0x65/0xa0
[10153.838654]  [<ffffffff8106be55>] irq_exit+0x85/0x90
[10153.843639]  [<ffffffff815e45a6>] do_IRQ+0x66/0xe0
[10153.848441]  [<ffffffff815dc9d3>] ret_from_intr+0x0/0x15
[10153.853759]  <EOI> 
[10153.855900]  [<ffffffff815dc2de>] ? _raw_spin_lock+0xe/0x20
[10153.861488]  [<ffffffff81154e41>] ? kmem_cache_free+0x91/0x100
[10153.867328]  [<ffffffff811482d7>] __mpol_put+0x27/0x30
[10153.872477]  [<ffffffff81069b6e>] do_exit+0x1ee/0x400
[10153.877538]  [<ffffffff81069e87>] sys_exit+0x17/0x20
[10153.882514]  [<ffffffff8100c042>] system_call_fastpath+0x16/0x1b
[10153.888525] Code: e5 48 83 ec 10 0f 1f 44 00 00 48 85 ff 74 20 f6 47 06 02 75 1a 0f b7 47 04 66 83 f8 02 74 27 66 83 f8 03 74 14 66 83 f8 01 74 15 <0f> 0b eb fe 65 8b 04 25 48 08 01 00 c9 c3 e8 1f ff ff ff c9 c3 
[10153.908659] RIP  [<ffffffff81148afe>] slab_node+0x2e/0x90
[10153.914093]  RSP <ffff8800bf443890>
[10153.917835] ---[ end trace 9eecf2c10fee154d ]---
[10153.922496] Kernel panic - not syncing: Fatal exception in interrupt
[10153.928891] Pid: 34275, comm: mongod Tainted: G      D     2.6.38-15-server #66~lucid1-Ubuntu
[10153.937464] Call Trace:
[10153.939957]  <IRQ>  [<ffffffff815d9479>] ? panic+0x91/0x19e
[10153.945625]  [<ffffffff815dd9aa>] ? oops_end+0xea/0xf0
[10153.950807]  [<ffffffff8100fd0b>] ? die+0x5b/0x90
[10153.955557]  [<ffffffff815dd254>] ? do_trap+0xc4/0x170
[10153.960740]  [<ffffffff8100d9a5>] ? do_invalid_op+0x95/0xb0
[10153.966356]  [<ffffffff81148afe>] ? slab_node+0x2e/0x90
[10153.971625]  [<ffffffff814e7799>] ? dev_hard_start_xmit+0x269/0x550
[10153.977932]  [<ffffffff8153733b>] ? tcp_make_synack+0x30b/0x670
[10153.983896]  [<ffffffff815dc2de>] ? _raw_spin_lock+0xe/0x20
[10153.989510]  [<ffffffff8100ccdb>] ? invalid_op+0x1b/0x20
[10153.994866]  [<ffffffff8153dcc1>] ? tcp_v4_conn_request+0x101/0x6b0
[10154.001183]  [<ffffffff81148afe>] ? slab_node+0x2e/0x90
[10154.006451]  [<ffffffff81151dd0>] ? get_any_partial+0xa0/0x190
[10154.012327]  [<ffffffff8105f7f3>] ? try_to_wake_up+0xc3/0x410
[10154.018117]  [<ffffffff81153f2b>] ? __slab_alloc+0x1eb/0x320
[10154.023820]  [<ffffffff8153dcc1>] ? tcp_v4_conn_request+0x101/0x6b0
[10154.030133]  [<ffffffff811549e2>] ? kmem_cache_alloc+0x102/0x110
[10154.036182]  [<ffffffff81038d99>] ? default_spin_lock_flags+0x9/0x10
[10154.042577]  [<ffffffff8153dcc1>] ? tcp_v4_conn_request+0x101/0x6b0
[10154.048885]  [<ffffffff814d597c>] ? sk_reset_timer+0x1c/0x30
[10154.054586]  [<ffffffff815342c3>] ? tcp_rcv_state_process+0xc3/0x4f0
[10154.060979]  [<ffffffff8153c0b3>] ? tcp_v4_do_rcv+0xa3/0x1c0
[10154.066682]  [<ffffffff8153d929>] ? tcp_v4_rcv+0x5a9/0x840
[10154.072210]  [<ffffffff812d88c3>] ? cpumask_next_and+0x23/0x40
[10154.078086]  [<ffffffff8151a58d>] ? ip_local_deliver_finish+0xdd/0x290
[10154.084654]  [<ffffffff8151a7c0>] ? ip_local_deliver+0x80/0x90
[10154.090527]  [<ffffffff81519d91>] ? ip_rcv_finish+0x121/0x3f0
[10154.096317]  [<ffffffff8151a3dd>] ? ip_rcv+0x23d/0x310
[10154.101501]  [<ffffffff814e404a>] ? __netif_receive_skb+0x40a/0x690
[10154.107808]  [<ffffffff814e9700>] ? netif_receive_skb+0x80/0x90
[10154.113768]  [<ffffffff814e9860>] ? napi_skb_finish+0x50/0x70
[10154.119556]  [<ffffffff814e9d05>] ? napi_gro_receive+0xc5/0xd0
[10154.125435]  [<ffffffffa0038eec>] ? igb_poll+0x71c/0x1220 [igb]
[10154.131395]  [<ffffffff81052775>] ? enqueue_entity+0x145/0x290
[10154.137269]  [<ffffffff8105290b>] ? enqueue_task_fair+0x4b/0xd0
[10154.143230]  [<ffffffff814bb7f6>] ? dma_issue_pending_all+0x86/0xc0
[10154.149538]  [<ffffffff814e9ee8>] ? net_rx_action+0x108/0x2d0
[10154.155326]  [<ffffffff8108b6a8>] ? __hrtimer_start_range_ns+0x188/0x480
[10154.162067]  [<ffffffff8106bf8b>] ? __do_softirq+0xab/0x200
[10154.167683]  [<ffffffff810d1b60>] ? handle_IRQ_event+0x50/0x170
[10154.173644]  [<ffffffff8100cf5c>] ? call_softirq+0x1c/0x30
[10154.179173]  [<ffffffff8100e9c5>] ? do_softirq+0x65/0xa0
[10154.184528]  [<ffffffff8106be55>] ? irq_exit+0x85/0x90
[10154.189713]  [<ffffffff815e45a6>] ? do_IRQ+0x66/0xe0
[10154.194721]  [<ffffffff815dc9d3>] ? ret_from_intr+0x0/0x15
[10154.200248]  <EOI>  [<ffffffff815dc2de>] ? _raw_spin_lock+0xe/0x20
[10154.206516]  [<ffffffff81154e41>] ? kmem_cache_free+0x91/0x100
[10154.212390]  [<ffffffff811482d7>] ? __mpol_put+0x27/0x30
[10154.217746]  [<ffffffff81069b6e>] ? do_exit+0x1ee/0x400
[10154.223016]  [<ffffffff81069e87>] ? sys_exit+0x17/0x20
[10154.228198]  [<ffffffff8100c042>] ? system_call_fastpath+0x16/0x1b
[10154.234668] ------------[ cut here ]------------
[10154.239326] WARNING: at /build/buildd/linux-lts-backport-natty-2.6.38/arch/x86/kernel/smp.c:118 native_smp_send_reschedule+0x5c/0x60()
[10154.251456] Hardware name: X8DTT
[10154.254725] Modules linked in: ipmi_si ipmi_devintf ipmi_msghandler ghes lp psmouse i7core_edac edac_core hed serio_raw joydev ioatdma parport usbhid hid igb megaraid_sas dca
[10154.271296] Pid: 34275, comm: mongod Tainted: G      D     2.6.38-15-server #66~lucid1-Ubuntu
[10154.279869] Call Trace:
[10154.282362]  <IRQ>  [<ffffffff8106502f>] ? warn_slowpath_common+0x7f/0xc0
[10154.289241]  [<ffffffff8106508a>] ? warn_slowpath_null+0x1a/0x20
[10154.295289]  [<ffffffff8102badc>] ? native_smp_send_reschedule+0x5c/0x60
[10154.302029]  [<ffffffff8104c9e6>] ? resched_task+0x76/0x90
[10154.307559]  [<ffffffff8104c717>] ? wakeup_preempt_entity+0x47/0x50
[10154.313865]  [<ffffffff8105fd65>] ? check_preempt_wakeup+0x1c5/0x290
[10154.320261]  [<ffffffff8104caa4>] ? check_preempt_curr+0x84/0xa0
[10154.326308]  [<ffffffff8105f7ab>] ? try_to_wake_up+0x7b/0x410
[10154.332099]  [<ffffffff8109e492>] ? __module_text_address+0x12/0x60
[10154.338407]  [<ffffffff8108a770>] ? hrtimer_wakeup+0x0/0x30
[10154.344021]  [<ffffffff8105fb95>] ? wake_up_process+0x15/0x20
[10154.349808]  [<ffffffff8108a792>] ? hrtimer_wakeup+0x22/0x30
[10154.355510]  [<ffffffff8108adf5>] ? __run_hrtimer+0x95/0x1e0
[10154.361214]  [<ffffffff81013299>] ? read_tsc+0x9/0x20
[10154.366310]  [<ffffffff8108b1c6>] ? hrtimer_interrupt+0xd6/0x220
[10154.372358]  [<ffffffff815e468b>] ? smp_apic_timer_interrupt+0x6b/0x9b
[10154.378923]  [<ffffffff8100ca13>] ? apic_timer_interrupt+0x13/0x20
[10154.385145]  [<ffffffff81065a36>] ? console_unlock+0x1d6/0x220
[10154.391020]  [<ffffffff815d9546>] ? panic+0x15e/0x19e
[10154.396116]  [<ffffffff815d94ae>] ? panic+0xc6/0x19e
[10154.401128]  [<ffffffff815dd9aa>] ? oops_end+0xea/0xf0
[10154.406309]  [<ffffffff8100fd0b>] ? die+0x5b/0x90
[10154.411050]  [<ffffffff815dd254>] ? do_trap+0xc4/0x170
[10154.416234]  [<ffffffff8100d9a5>] ? do_invalid_op+0x95/0xb0
[10154.421848]  [<ffffffff81148afe>] ? slab_node+0x2e/0x90
[10154.427119]  [<ffffffff814e7799>] ? dev_hard_start_xmit+0x269/0x550
[10154.433427]  [<ffffffff8153733b>] ? tcp_make_synack+0x30b/0x670
[10154.439388]  [<ffffffff815dc2de>] ? _raw_spin_lock+0xe/0x20
[10154.445004]  [<ffffffff8100ccdb>] ? invalid_op+0x1b/0x20
[10154.450360]  [<ffffffff8153dcc1>] ? tcp_v4_conn_request+0x101/0x6b0
[10154.456666]  [<ffffffff81148afe>] ? slab_node+0x2e/0x90
[10154.461936]  [<ffffffff81151dd0>] ? get_any_partial+0xa0/0x190
[10154.467812]  [<ffffffff8105f7f3>] ? try_to_wake_up+0xc3/0x410
[10154.473600]  [<ffffffff81153f2b>] ? __slab_alloc+0x1eb/0x320
[10154.479303]  [<ffffffff8153dcc1>] ? tcp_v4_conn_request+0x101/0x6b0
[10154.485609]  [<ffffffff811549e2>] ? kmem_cache_alloc+0x102/0x110
[10154.491659]  [<ffffffff81038d99>] ? default_spin_lock_flags+0x9/0x10
[10154.498051]  [<ffffffff8153dcc1>] ? tcp_v4_conn_request+0x101/0x6b0
[10154.504360]  [<ffffffff814d597c>] ? sk_reset_timer+0x1c/0x30
[10154.511299]  [<ffffffff815342c3>] ? tcp_rcv_state_process+0xc3/0x4f0
[10154.517693]  [<ffffffff8153c0b3>] ? tcp_v4_do_rcv+0xa3/0x1c0
[10154.523396]  [<ffffffff8153d929>] ? tcp_v4_rcv+0x5a9/0x840
[10154.528923]  [<ffffffff812d88c3>] ? cpumask_next_and+0x23/0x40
[10154.534799]  [<ffffffff8151a58d>] ? ip_local_deliver_finish+0xdd/0x290
[10154.541367]  [<ffffffff8151a7c0>] ? ip_local_deliver+0x80/0x90
[10154.547242]  [<ffffffff81519d91>] ? ip_rcv_finish+0x121/0x3f0
[10154.553031]  [<ffffffff8151a3dd>] ? ip_rcv+0x23d/0x310
[10154.558213]  [<ffffffff814e404a>] ? __netif_receive_skb+0x40a/0x690
[10154.564522]  [<ffffffff814e9700>] ? netif_receive_skb+0x80/0x90
[10154.570483]  [<ffffffff814e9860>] ? napi_skb_finish+0x50/0x70
[10154.576271]  [<ffffffff814e9d05>] ? napi_gro_receive+0xc5/0xd0
[10154.582148]  [<ffffffffa0038eec>] ? igb_poll+0x71c/0x1220 [igb]
[10154.588107]  [<ffffffff81052775>] ? enqueue_entity+0x145/0x290
[10154.593981]  [<ffffffff8105290b>] ? enqueue_task_fair+0x4b/0xd0
[10154.599945]  [<ffffffff814bb7f6>] ? dma_issue_pending_all+0x86/0xc0
[10154.606251]  [<ffffffff814e9ee8>] ? net_rx_action+0x108/0x2d0
[10154.612039]  [<ffffffff8108b6a8>] ? __hrtimer_start_range_ns+0x188/0x480
[10154.618781]  [<ffffffff8106bf8b>] ? __do_softirq+0xab/0x200
[10154.624397]  [<ffffffff810d1b60>] ? handle_IRQ_event+0x50/0x170
[10154.630358]  [<ffffffff8100cf5c>] ? call_softirq+0x1c/0x30
[10154.635886]  [<ffffffff8100e9c5>] ? do_softirq+0x65/0xa0
[10154.641242]  [<ffffffff8106be55>] ? irq_exit+0x85/0x90
[10154.646424]  [<ffffffff815e45a6>] ? do_IRQ+0x66/0xe0
[10154.651434]  [<ffffffff815dc9d3>] ? ret_from_intr+0x0/0x15
[10154.656962]  <EOI>  [<ffffffff815dc2de>] ? _raw_spin_lock+0xe/0x20
[10154.663237]  [<ffffffff81154e41>] ? kmem_cache_free+0x91/0x100
[10154.669111]  [<ffffffff811482d7>] ? __mpol_put+0x27/0x30
[10154.674468]  [<ffffffff81069b6e>] ? do_exit+0x1ee/0x400
[10154.679738]  [<ffffffff81069e87>] ? sys_exit+0x17/0x20
[10154.684921]  [<ffffffff8100c042>] ? system_call_fastpath+0x16/0x1b
[10154.691141] ---[ end trace 9eecf2c10fee154e ]---

--------------030309010400020307080908--
