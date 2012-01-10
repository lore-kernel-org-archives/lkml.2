Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab2AJQOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 11:14:03 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:64059 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407Ab2AJQN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 11:13:59 -0500
Message-ID: <1326212033.19095.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [BUG] kernel freezes with latest tree
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 10 Jan 2012 17:13:53 +0100
In-Reply-To: <1326183371.6638.6.camel@edumazet-laptop>
References: <1326171444.6638.3.camel@edumazet-laptop>
	 <1326171798.6638.4.camel@edumazet-laptop>
	 <1326183371.6638.6.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 10 janvier 2012 à 09:16 +0100, Eric Dumazet a écrit :
> Le mardi 10 janvier 2012 à 06:03 +0100, Eric Dumazet a écrit :
> > Le mardi 10 janvier 2012 à 05:57 +0100, Eric Dumazet a écrit :
> > > Hi Linus
> > > 
> > > I got some freezes on two different machines, using latest kernel.
> > > 
> > > while :; do hackbench 10 thread 4000; done
> > > 
> > > Not sure I'll have time today to find the problem.
> > > 
> > > It might be related to "perf top" also being run at least once.
> > > 
> > 
> > Hmm, I can trigger the bug without ever using "perf".
> > 
> > 
> 
> OK I managed to bisect it, but I have to run now.
> 
> $ git bisect log
> git bisect start
> # bad: [31ae26ae7ba5ff6209b9ec5d1e1ba9442d6b87e6] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
> git bisect bad 31ae26ae7ba5ff6209b9ec5d1e1ba9442d6b87e6
> # good: [805a6af8dba5dfdd35ec35dc52ec0122400b2610] Linux 3.2
> git bisect good 805a6af8dba5dfdd35ec35dc52ec0122400b2610
> # bad: [e4e88f31bcb5f05f24b9ae518d4ecb44e1a7774d] Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc
> git bisect bad e4e88f31bcb5f05f24b9ae518d4ecb44e1a7774d
> # good: [ab9c17a009ee8eb8c667f22dc0be0709effceab9] mlx4_core: Modify driver initialization flow to accommodate SRIOV for Ethernet
> git bisect good ab9c17a009ee8eb8c667f22dc0be0709effceab9
> # good: [117ff42fd43e92d24c6aa6f3e4f0f1e1edada140] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
> git bisect good 117ff42fd43e92d24c6aa6f3e4f0f1e1edada140
> # bad: [67b0243131150391125d8d0beb5359d7aec78b55] Merge branch 'x86-apic-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect bad 67b0243131150391125d8d0beb5359d7aec78b55
> # good: [423d091dfe58d3109d84c408810a7cfa82f6f184] Merge branch 'core-rcu-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good 423d091dfe58d3109d84c408810a7cfa82f6f184
> # good: [f1ac18af219835fd5b8e19c14d2dd75c55f78737] perf: Add support for PERF_HW_COUNT_REF_CPU_CYCLES
> git bisect good f1ac18af219835fd5b8e19c14d2dd75c55f78737
> # good: [1ac9bc6943edf7d181b4b1cc734981350d4f6bae] sched/tracing: Add a new tracepoint for sleeptime
> git bisect good 1ac9bc6943edf7d181b4b1cc734981350d4f6bae
> # bad: [0db49b72bce26341274b74fd968501489a361ae3] Merge branch 'sched-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect bad 0db49b72bce26341274b74fd968501489a361ae3
> # good: [1b5495043d5bc058def21f9b66fd8feaa794eb44] perf tools: Moving code in some files
> git bisect good 1b5495043d5bc058def21f9b66fd8feaa794eb44
> # good: [29c9862f1b818bf4caa4c48a30dbe5f25c84ee08] perf session: Remove impossible condition check
> git bisect good 29c9862f1b818bf4caa4c48a30dbe5f25c84ee08
> # good: [466e2876bcb9ddc9b92502c46689679bee7d72a0] perf script: Kill script_spec__delete
> git bisect good 466e2876bcb9ddc9b92502c46689679bee7d72a0
> # good: [35b740e4662ef386f0c60e1b60aaf5b44db9914c] Merge branch 'perf-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good 35b740e4662ef386f0c60e1b60aaf5b44db9914c
> 
> 
> Could it be a merge error ?
> 
> commit 0db49b72bce26341274b74fd968501489a361ae3
> Merge: 35b740e 1ac9bc6
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Fri Jan 6 08:33:28 2012 -0800

Here are two traces of the lockups, since I had some free time to reproduce the
bug on current tree (plus a minor change in bnx2 driver to avoid a
netconsole related stack trace)

1st one : PREEMPT is enabled (CONFIG_PREEMPT=y)
-----------------------------------------------

[ 3753.138509] ------------[ cut here ]------------
[ 3753.138509] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9c/0xc0()
[ 3753.138509] Hardware name: ProLiant BL460c G1
[ 3753.138509] Watchdog detected hard LOCKUP on cpu 5
[ 3753.138509] Modules linked in: netconsole xt_hashlimit ipmi_devintf ipmi_si ipmi_msghandler af_packet tg3 bonding
[ 3753.138509] Pid: 5449, comm: IVR Not tainted 3.2.0-05066-g31ae26a-dirty #761
[ 3753.138509] Call Trace:
[ 3753.138509]  [<c022b2c2>] warn_slowpath_common+0x72/0xa0
[ 3753.138509]  [<c0284f4c>] ? watchdog_overflow_callback+0x9c/0xc0
[ 3753.138509]  [<c0284f4c>] ? watchdog_overflow_callback+0x9c/0xc0
[ 3753.138509]  [<c0284eb0>] ? watchdog_timer_fn+0x170/0x170
[ 3753.138509]  [<c022b393>] warn_slowpath_fmt+0x33/0x40
[ 3753.138509]  [<c0284f4c>] watchdog_overflow_callback+0x9c/0xc0
[ 3753.138509]  [<c02aed6a>] __perf_event_overflow+0x9a/0x240
[ 3753.138509]  [<c02af695>] perf_event_overflow+0x15/0x20
[ 3753.138509]  [<c0213fd9>] intel_pmu_handle_irq+0x129/0x250
[ 3753.138509]  [<c03b4388>] ? cpumask_next_and+0x28/0x40
[ 3753.138509]  [<c020f540>] perf_event_nmi_handler+0x20/0x30
[ 3753.138509]  [<c0205f18>] nmi_handle.clone.0+0x38/0x50
[ 3753.138509]  [<c02060e4>] do_nmi+0x1b4/0x350
[ 3753.138509]  [<c061969d>] nmi_stack_correct+0x28/0x2d
[ 3753.138509]  [<c06189f4>] ? _raw_spin_lock+0x34/0x40
[ 3753.138509]  [<c02613c1>] load_balance+0x361/0x560
[ 3753.138509]  [<c0261912>] idle_balance+0xd2/0x150
[ 3753.138509]  [<c0617919>] __schedule+0x5e9/0x6b0
[ 3753.138509]  [<c03bbca0>] ? timerqueue_add+0x60/0xc0
[ 3753.138509]  [<c025a14b>] ? get_parent_ip+0xb/0x40
[ 3753.138509]  [<c025a1fb>] ? sub_preempt_count+0x7b/0xb0
[ 3753.138509]  [<c025a14b>] ? get_parent_ip+0xb/0x40
[ 3753.138509]  [<c025a2ab>] ? add_preempt_count+0x7b/0xc0
[ 3753.138509]  [<c0618637>] ? _raw_spin_unlock_irqrestore+0x17/0x40
[ 3753.138509]  [<c0617a65>] schedule+0x35/0x50
[ 3753.138509]  [<c0616bfc>] schedule_hrtimeout_range_clock+0xcc/0x180
[ 3753.138509]  [<c0250310>] ? update_rmtp+0x80/0x80
[ 3753.138509]  [<c02511d6>] ? hrtimer_start_range_ns+0x26/0x30
[ 3753.138509]  [<c0616cc7>] schedule_hrtimeout_range+0x17/0x20
[ 3753.138509]  [<c0305f5e>] poll_schedule_timeout+0x3e/0x60
[ 3753.138509]  [<c0306822>] do_select+0x552/0x690
[ 3753.138509]  [<c025a14b>] ? get_parent_ip+0xb/0x40
[ 3753.138509]  [<c0306030>] ? poll_freewait+0xb0/0xb0
[ 3753.138509]  [<c022489b>] ? __change_page_attr_set_clr+0xbb/0x8f0
[ 3753.138509]  [<c02ba9de>] ? __alloc_pages_nodemask+0xde/0x600
[ 3753.138509]  [<c022489b>] ? __change_page_attr_set_clr+0xbb/0x8f0
[ 3753.138509]  [<c0209665>] ? native_sched_clock+0x25/0xc0
[ 3753.138509]  [<c0209665>] ? native_sched_clock+0x25/0xc0
[ 3753.138509]  [<c025dd12>] ? sched_clock_local+0xe2/0x1e0
[ 3753.138509]  [<c0209665>] ? native_sched_clock+0x25/0xc0
[ 3753.138509]  [<c025dd12>] ? sched_clock_local+0xe2/0x1e0
[ 3753.138509]  [<c025df99>] ? sched_clock_cpu+0x119/0x1b0
[ 3753.138509]  [<c0259632>] ? check_preempt_curr+0x72/0x90
[ 3753.138509]  [<c025a14b>] ? get_parent_ip+0xb/0x40
[ 3753.138509]  [<c025a1fb>] ? sub_preempt_count+0x7b/0xb0
[ 3753.138509]  [<c0231854>] ? irq_exit+0x74/0xb0
[ 3753.138509]  [<c025bb73>] ? scheduler_ipi+0x73/0xc0
[ 3753.138509]  [<c021b997>] ? smp_reschedule_interrupt+0x27/0x30
[ 3753.138509]  [<c0618ce2>] ? reschedule_interrupt+0x2a/0x30
[ 3753.138509]  [<c0306ab2>] core_sys_select+0x152/0x280
[ 3753.138509]  [<c0209665>] ? native_sched_clock+0x25/0xc0
[ 3753.138509]  [<c025dd12>] ? sched_clock_local+0xe2/0x1e0
[ 3753.138509]  [<c0209665>] ? native_sched_clock+0x25/0xc0
[ 3753.138509]  [<c025dd12>] ? sched_clock_local+0xe2/0x1e0
[ 3753.138509]  [<c0266f87>] ? ktime_get_ts+0xe7/0x110
[ 3753.138509]  [<c0266f87>] ? ktime_get_ts+0xe7/0x110
[ 3753.138509]  [<c0306c11>] sys_select+0x31/0xb0
[ 3753.138509]  [<c061984c>] sysenter_do_call+0x12/0x22
[ 3753.138509] ---[ end trace 994a369c06c2c208 ]---
[ 3753.061448] ------------[ cut here ]------------
[ 3753.061448] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9c/0xc0()
[ 3753.061448] Hardware name: ProLiant BL460c G1
[ 3753.061448] Watchdog detected hard LOCKUP on cpu 7
[ 3753.061448] Modules linked in: netconsole xt_hashlimit ipmi_devintf ipmi_si ipmi_msghandler af_packet tg3 bonding
[ 3753.061448] Pid: 8922, comm: hackbench Tainted: G        W    3.2.0-05066-g31ae26a-dirty #761
[ 3753.061448] Call Trace:
[ 3753.061448]  [<c022b2c2>] warn_slowpath_common+0x72/0xa0
[ 3753.061448]  [<c0284f4c>] ? watchdog_overflow_callback+0x9c/0xc0
[ 3753.061448]  [<c0284f4c>] ? watchdog_overflow_callback+0x9c/0xc0
[ 3753.061448]  [<c0284eb0>] ? watchdog_timer_fn+0x170/0x170
[ 3753.061448]  [<c022b393>] warn_slowpath_fmt+0x33/0x40
[ 3753.061448]  [<c0284f4c>] watchdog_overflow_callback+0x9c/0xc0
[ 3753.061448]  [<c02aed6a>] __perf_event_overflow+0x9a/0x240
[ 3753.061448]  [<c02af695>] perf_event_overflow+0x15/0x20
[ 3753.061448]  [<c0213fd9>] intel_pmu_handle_irq+0x129/0x250
[ 3753.061448]  [<c021401b>] ? intel_pmu_handle_irq+0x16b/0x250
[ 3753.061448]  [<c03b4388>] ? cpumask_next_and+0x28/0x40
[ 3753.061448]  [<c020f540>] perf_event_nmi_handler+0x20/0x30
[ 3753.061448]  [<c0205f18>] nmi_handle.clone.0+0x38/0x50
[ 3753.061448]  [<c0205fde>] do_nmi+0xae/0x350
[ 3753.061448]  [<c061969d>] nmi_stack_correct+0x28/0x2d
[ 3753.061448]  [<c06189f2>] ? _raw_spin_lock+0x32/0x40
[ 3753.061448]  [<c02613c1>] load_balance+0x361/0x560
[ 3753.061448]  [<c0261912>] idle_balance+0xd2/0x150
[ 3753.061448]  [<c0617919>] __schedule+0x5e9/0x6b0
[ 3753.061448]  [<c025a14b>] ? get_parent_ip+0xb/0x40
[ 3753.061448]  [<c025a1fb>] ? sub_preempt_count+0x7b/0xb0
[ 3753.061448]  [<c02b723e>] ? __probe_kernel_read+0x4e/0x90
[ 3753.061448]  [<c0617a65>] schedule+0x35/0x50
[ 3753.061448]  [<c06160cd>] schedule_timeout+0x21d/0x2a0
[ 3753.061448]  [<c04e0f41>] ? __alloc_skb+0x31/0x110
[ 3753.061448]  [<c025a14b>] ? get_parent_ip+0xb/0x40
[ 3753.061448]  [<c025a14b>] ? get_parent_ip+0xb/0x40
[ 3753.061448]  [<c025a1fb>] ? sub_preempt_count+0x7b/0xb0
[ 3753.061448]  [<c0618637>] ? _raw_spin_unlock_irqrestore+0x17/0x40
[ 3753.061448]  [<c024cc68>] ? prepare_to_wait+0x48/0x70
[ 3753.061448]  [<c04dcc1c>] sock_alloc_send_pskb+0x12c/0x290
[ 3753.061448]  [<c024ca10>] ? wake_up_bit+0x30/0x30
[ 3753.061448]  [<c04dcd9d>] sock_alloc_send_skb+0x1d/0x30
[ 3753.061448]  [<c056ed7f>] unix_stream_sendmsg+0x26f/0x3b0
[ 3753.061448]  [<c04d86a8>] sock_aio_write+0xf8/0x110
[ 3753.061448]  [<c02f4ddc>] do_sync_write+0xac/0xf0
[ 3753.061448]  [<c02f5926>] vfs_write+0x126/0x140
[ 3753.061448]  [<c02f6d87>] ? fget_light+0x77/0xe0
[ 3753.061448]  [<c02f5b22>] sys_write+0x42/0x70
[ 3753.061448]  [<c061984c>] sysenter_do_call+0x12/0x22
[ 3753.061448] ---[ end trace 994a369c06c2c209 ]---
[ 3776.910004] BUG: soft lockup - CPU#3 stuck for 22s! [hackbench:9191]
[ 3776.910040] Modules linked in: netconsole xt_hashlimit ipmi_devintf ipmi_si ipmi_msghandler af_packet tg3 bonding
[ 3776.910114] Modules linked in: netconsole xt_hashlimit ipmi_devintf ipmi_si ipmi_msghandler af_packet tg3 bonding
[ 3776.910187] 
[ 3776.910207] Pid: 9191, comm: hackbench Tainted: G        W    3.2.0-05066-g31ae26a-dirty #761 HP ProLiant BL460c G1
[ 3776.910262] EIP: 0060:[<c026136a>] EFLAGS: 00000202 CPU: 3
[ 3776.910290] EIP is at load_balance+0x30a/0x560
[ 3776.910316] EAX: 00000000 EBX: 00000000 ECX: 00000001 EDX: 00000100
[ 3776.910345] ESI: f4d9f060 EDI: 00000021 EBP: f4d5df6c ESP: f4d5df0c
[ 3776.910373]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[ 3776.910401] Process hackbench (pid: 9191, ti=f4d5c000 task=f1a9a7e0 task.ti=ec502000)
[ 3776.910446] Stack:
[ 3776.910467]  00000001 f50c2c74 f4d5df90 00000202 f4d32348 f4d3231c f4d32300 f50c6ec0
[ 3776.910533]  c0883ec0 00001133 c0883ec0 f50c2c74 f5086ec0 00001133 00000000 00000003
[ 3776.910598]  00000002 f5086f34 00001133 00001133 00001133 f4d32300 000544dc 00000007
[ 3776.910663] Call Trace:
[ 3776.910687]  [<c0261649>] rebalance_domains+0x89/0x160
[ 3776.910716]  [<c026175d>] run_rebalance_domains+0x3d/0x120
[ 3776.910745]  [<c023146a>] __do_softirq+0x8a/0x1e0
[ 3776.910772]  [<c02313e0>] ? local_bh_enable+0xa0/0xa0
[ 3776.910798]  <IRQ> 
[ 3776.910822]  [<c023186e>] ? irq_exit+0x8e/0xb0
[ 3776.910849]  [<c0619f38>] ? smp_apic_timer_interrupt+0x58/0x87
[ 3776.910880]  [<c02eea10>] ? kmem_cache_free+0x110/0x120
[ 3776.910907]  [<c04e094d>] ? __kfree_skb+0x3d/0x90
[ 3776.910934]  [<c06193fe>] ? apic_timer_interrupt+0x2a/0x30
[ 3776.910962]  [<c056fdbf>] ? unix_stream_recvmsg+0x18f/0x590
[ 3776.910990]  [<c024ca10>] ? wake_up_bit+0x30/0x30
[ 3776.911017]  [<c04d87c7>] ? sock_aio_read+0x107/0x110
[ 3776.911045]  [<c02f4ecc>] ? do_sync_read+0xac/0xf0
[ 3776.911073]  [<c02f5a5f>] ? vfs_read+0x11f/0x130
[ 3776.911099]  [<c02f6d87>] ? fget_light+0x77/0xe0
[ 3776.911131]  [<c02f5ab2>] ? sys_read+0x42/0x70
[ 3776.911158]  [<c061984c>] ? sysenter_do_call+0x12/0x22
[ 3776.911185] Code: d8 39 4d c4 76 08 85 c0 0f 85 eb fe ff ff 8b 45 bc 31 db 83 7d d8 00 0f 95 c3 e8 02 73 3b 00 8b 45 d0 e8 fa 72 3b 00 ff 75 ac 9d <85> db 0f 85 a2 00 00 00 f6 45 e0 04 0f 85 f7 00 00 00 f6 45 e0 
[ 3776.911525] Call Trace:
[ 3776.911548]  [<c0261649>] rebalance_domains+0x89/0x160
[ 3776.911575]  [<c026175d>] run_rebalance_domains+0x3d/0x120
[ 3776.911603]  [<c023146a>] __do_softirq+0x8a/0x1e0
[ 3776.911630]  [<c02313e0>] ? local_bh_enable+0xa0/0xa0
[ 3776.911656]  <IRQ>  [<c023186e>] ? irq_exit+0x8e/0xb0
[ 3776.911686]  [<c0619f38>] ? smp_apic_timer_interrupt+0x58/0x87
[ 3776.911715]  [<c02eea10>] ? kmem_cache_free+0x110/0x120
[ 3776.911742]  [<c04e094d>] ? __kfree_skb+0x3d/0x90
[ 3776.911768]  [<c06193fe>] ? apic_timer_interrupt+0x2a/0x30
[ 3776.911796]  [<c056fdbf>] ? unix_stream_recvmsg+0x18f/0x590
[ 3776.911825]  [<c024ca10>] ? wake_up_bit+0x30/0x30
[ 3776.911851]  [<c04d87c7>] ? sock_aio_read+0x107/0x110
[ 3776.911879]  [<c02f4ecc>] ? do_sync_read+0xac/0xf0
[ 3776.911906]  [<c02f5a5f>] ? vfs_read+0x11f/0x130
[ 3776.911933]  [<c02f6d87>] ? fget_light+0x77/0xe0
[ 3776.911959]  [<c02f5ab2>] ? sys_read+0x42/0x70
[ 3776.911985]  [<c061984c>] ? sysenter_do_call+0x12/0x22
[ 3776.912011] Kernel panic - not syncing: softlockup: hung tasks
[ 3753.128530] ------------[ cut here ]------------
[ 3753.128530] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9c/0xc0()
[ 3753.128530] Hardware name: ProLiant BL460c G1
[ 3753.128530] Watchdog detected hard LOCKUP on cpu 1
[ 3753.128530] Modules linked in: netconsole xt_hashlimit ipmi_devintf ipmi_si ipmi_msghandler af_packet tg3 bonding
[ 3753.128530] Pid: 9073, comm: hackbench Tainted: G        W    3.2.0-05066-g31ae26a-dirty #761
[ 3753.128530] Call Trace:
[ 3753.128530]  [<c022b2c2>] warn_slowpath_common+0x72/0xa0
[ 3753.128530]  [<c0284f4c>] ? watchdog_overflow_callback+0x9c/0xc0
[ 3753.128530]  [<c0284f4c>] ? watchdog_overflow_callback+0x9c/0xc0
[ 3753.128530]  [<c0284eb0>] ? watchdog_timer_fn+0x170/0x170
[ 3753.128530]  [<c022b393>] warn_slowpath_fmt+0x33/0x40
[ 3753.128530]  [<c0284f4c>] watchdog_overflow_callback+0x9c/0xc0
[ 3753.128530]  [<c02aed6a>] __perf_event_overflow+0x9a/0x240
[ 3753.128530]  [<c02af695>] perf_event_overflow+0x15/0x20
[ 3753.128530]  [<c0213fd9>] intel_pmu_handle_irq+0x129/0x250
[ 3753.128530]  [<c021401b>] ? intel_pmu_handle_irq+0x16b/0x250
[ 3753.128530]  [<c03b4388>] ? cpumask_next_and+0x28/0x40
[ 3753.128530]  [<c020f540>] perf_event_nmi_handler+0x20/0x30
[ 3753.128530]  [<c0205f18>] nmi_handle.clone.0+0x38/0x50
[ 3753.128530]  [<c0205fde>] do_nmi+0xae/0x350
[ 3753.128530]  [<c061969d>] nmi_stack_correct+0x28/0x2d
[ 3753.128530]  [<c06189f0>] ? _raw_spin_lock+0x30/0x40
[ 3753.128530]  [<c0261208>] load_balance+0x1a8/0x560
[ 3753.128530]  [<c0261912>] idle_balance+0xd2/0x150
[ 3753.128530]  [<c0617919>] __schedule+0x5e9/0x6b0
[ 3753.128530]  [<c02ee769>] ? __slab_free+0x1b9/0x350
[ 3753.128530]  [<c0619f38>] ? smp_apic_timer_interrupt+0x58/0x87
[ 3753.128530]  [<c025a1fb>] ? sub_preempt_count+0x7b/0xb0
[ 3753.128530]  [<c0617a65>] schedule+0x35/0x50
[ 3753.128530]  [<c06160cd>] schedule_timeout+0x21d/0x2a0
[ 3753.128530]  [<c02eea10>] ? kmem_cache_free+0x110/0x120
[ 3753.128530]  [<c04e094d>] ? __kfree_skb+0x3d/0x90
[ 3753.128530]  [<c04e094d>] ? __kfree_skb+0x3d/0x90
[ 3753.128530]  [<c025a14b>] ? get_parent_ip+0xb/0x40
[ 3753.128530]  [<c025a1fb>] ? sub_preempt_count+0x7b/0xb0
[ 3753.128530]  [<c056ffbe>] unix_stream_recvmsg+0x38e/0x590
[ 3753.128530]  [<c024ca10>] ? wake_up_bit+0x30/0x30
[ 3753.128530]  [<c04d87c7>] sock_aio_read+0x107/0x110
[ 3753.128530]  [<c02f4ecc>] do_sync_read+0xac/0xf0
[ 3753.128530]  [<c025dd12>] ? sched_clock_local+0xe2/0x1e0
[ 3753.128530]  [<c025df99>] ? sched_clock_cpu+0x119/0x1b0
[ 3753.128530]  [<c02f5a5f>] vfs_read+0x11f/0x130
[ 3753.128530]  [<c02f6d87>] ? fget_light+0x77/0xe0
[ 3753.128530]  [<c02f5ab2>] sys_read+0x42/0x70
[ 3753.128530]  [<c061984c>] sysenter_do_call+0x12/0x22
[ 3753.128530] ---[ end trace 994a369c06c2c20a ]---
[ 3753.060025] ------------[ cut here ]------------
[ 3753.060025] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9c/0xc0()
[ 3753.060025] Hardware name: ProLiant BL460c G1
[ 3753.060025] Watchdog detected hard LOCKUP on cpu 0
[ 3753.060025] Modules linked in: netconsole xt_hashlimit ipmi_devintf ipmi_si ipmi_msghandler af_packet tg3 bonding
[ 3753.060025] Pid: 9083, comm: hackbench Tainted: G        W    3.2.0-05066-g31ae26a-dirty #761
[ 3753.060025] Call Trace:
[ 3753.060025]  [<c022b2c2>] warn_slowpath_common+0x72/0xa0
[ 3753.060025]  [<c0284f4c>] ? watchdog_overflow_callback+0x9c/0xc0
[ 3753.060025]  [<c0284f4c>] ? watchdog_overflow_callback+0x9c/0xc0
[ 3753.060025]  [<c0284eb0>] ? watchdog_timer_fn+0x170/0x170
[ 3753.060025]  [<c022b393>] warn_slowpath_fmt+0x33/0x40
[ 3753.060025]  [<c0284f4c>] watchdog_overflow_callback+0x9c/0xc0
[ 3753.060025]  [<c02aed6a>] __perf_event_overflow+0x9a/0x240
[ 3753.060025]  [<c02af695>] perf_event_overflow+0x15/0x20
[ 3753.060025]  [<c0213fd9>] intel_pmu_handle_irq+0x129/0x250
[ 3753.060025]  [<c025a1fb>] ? sub_preempt_count+0x7b/0xb0
[ 3753.060025]  [<c020f540>] perf_event_nmi_handler+0x20/0x30
[ 3753.060025]  [<c0205f18>] nmi_handle.clone.0+0x38/0x50
[ 3753.060025]  [<c0205fde>] do_nmi+0xae/0x350
[ 3753.060025]  [<c04e0f41>] ? __alloc_skb+0x31/0x110
[ 3753.060025]  [<c061969d>] nmi_stack_correct+0x28/0x2d
[ 3753.060025]  [<c025007b>] ? hrtimer_force_reprogram+0x4b/0xe0
[ 3753.060025]  [<c06189b0>] ? _raw_spin_lock_irqsave+0x30/0x40
[ 3753.060025]  [<c0257964>] __wake_up_sync_key+0x24/0x60
[ 3753.060025]  [<c04dc59d>] sock_def_readable+0x3d/0x70
[ 3753.060025]  [<c056ed27>] unix_stream_sendmsg+0x217/0x3b0
[ 3753.060025]  [<c04d86a8>] sock_aio_write+0xf8/0x110
[ 3753.060025]  [<c02f4ddc>] do_sync_write+0xac/0xf0
[ 3753.060025]  [<c02f5926>] vfs_write+0x126/0x140
[ 3753.060025]  [<c02f6d87>] ? fget_light+0x77/0xe0
[ 3753.060025]  [<c02f5b22>] sys_write+0x42/0x70
[ 3753.060025]  [<c061984c>] sysenter_do_call+0x12/0x22
[ 3753.060025] ---[ end trace 994a369c06c2c20b ]---
[ 3753.110224] ------------[ cut here ]------------
[ 3753.110224] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9c/0xc0()
[ 3753.110224] Hardware name: ProLiant BL460c G1
[ 3753.110224] Watchdog detected hard LOCKUP on cpu 4
[ 3753.110224] Modules linked in: netconsole xt_hashlimit ipmi_devintf ipmi_si ipmi_msghandler af_packet tg3 bonding
[ 3753.110224] Pid: 9077, comm: hackbench Tainted: G        W    3.2.0-05066-g31ae26a-dirty #761
[ 3753.110224] Call Trace:
[ 3753.110224]  [<c022b2c2>] warn_slowpath_common+0x72/0xa0
[ 3753.110224]  [<c0284f4c>] ? watchdog_overflow_callback+0x9c/0xc0
[ 3753.110224]  [<c0284f4c>] ? watchdog_overflow_callback+0x9c/0xc0
[ 3753.110224]  [<c0284eb0>] ? watchdog_timer_fn+0x170/0x170
[ 3753.110224]  [<c022b393>] warn_slowpath_fmt+0x33/0x40
[ 3753.110224]  [<c0284f4c>] watchdog_overflow_callback+0x9c/0xc0
[ 3753.110224]  [<c02aed6a>] __perf_event_overflow+0x9a/0x240
[ 3753.110224]  [<c02af695>] perf_event_overflow+0x15/0x20
[ 3753.110224]  [<c0213fd9>] intel_pmu_handle_irq+0x129/0x250
[ 3753.110224]  [<c025a14b>] ? get_parent_ip+0xb/0x40
[ 3753.110224]  [<c02edc81>] ? get_partial_node.clone.38+0x231/0x290
[ 3753.110224]  [<c0259632>] ? check_preempt_curr+0x72/0x90
[ 3753.110224]  [<c020f540>] perf_event_nmi_handler+0x20/0x30
[ 3753.110224]  [<c0205f18>] nmi_handle.clone.0+0x38/0x50
[ 3753.110224]  [<c0205fde>] do_nmi+0xae/0x350
[ 3753.110224]  [<c025a14b>] ? get_parent_ip+0xb/0x40
[ 3753.110224]  [<c061969d>] nmi_stack_correct+0x28/0x2d
[ 3753.110224]  [<c04e007b>] ? sock_queue_err_skb+0x9b/0xb0
[ 3753.110224]  [<c025c40f>] ? try_to_wake_up+0x8f/0x220
[ 3753.110224]  [<c025c5b0>] default_wake_function+0x10/0x20
[ 3753.110224]  [<c024ca30>] autoremove_wake_function+0x20/0x40
[ 3753.110224]  [<c0254508>] __wake_up_common+0x48/0x70
[ 3753.110224]  [<c0257983>] __wake_up_sync_key+0x43/0x60
[ 3753.110224]  [<c04dc59d>] sock_def_readable+0x3d/0x70
[ 3753.110224]  [<c056ed27>] unix_stream_sendmsg+0x217/0x3b0
[ 3753.110224]  [<c04d86a8>] sock_aio_write+0xf8/0x110
[ 3753.110224]  [<c02f4ddc>] do_sync_write+0xac/0xf0
[ 3753.110224]  [<c02f5926>] vfs_write+0x126/0x140
[ 3753.110224]  [<c02f6d87>] ? fget_light+0x77/0xe0
[ 3753.110224]  [<c02f5b22>] sys_write+0x42/0x70
[ 3753.110224]  [<c061984c>] sysenter_do_call+0x12/0x22
[ 3753.110224] ---[ end trace 994a369c06c2c20c ]---
[ 3753.070006] ------------[ cut here ]------------
[ 3753.070006] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9c/0xc0()
[ 3753.070006] Hardware name: ProLiant BL460c G1
[ 3753.070006] Watchdog detected hard LOCKUP on cpu 2
[ 3753.070006] Modules linked in: netconsole xt_hashlimit ipmi_devintf ipmi_si ipmi_msghandler af_packet tg3 bonding
[ 3753.070006] Pid: 8897, comm: hackbench Tainted: G        W    3.2.0-05066-g31ae26a-dirty #761
[ 3753.070006] Call Trace:
[ 3753.070006]  [<c022b2c2>] warn_slowpath_common+0x72/0xa0
[ 3753.070006]  [<c0284f4c>] ? watchdog_overflow_callback+0x9c/0xc0
[ 3753.070006]  [<c0284f4c>] ? watchdog_overflow_callback+0x9c/0xc0
[ 3753.070006]  [<c0284eb0>] ? watchdog_timer_fn+0x170/0x170
[ 3753.070006]  [<c022b393>] warn_slowpath_fmt+0x33/0x40
[ 3753.070006]  [<c0284f4c>] watchdog_overflow_callback+0x9c/0xc0
[ 3753.070006]  [<c02aed6a>] __perf_event_overflow+0x9a/0x240
[ 3753.070006]  [<c0616c8d>] ? schedule_hrtimeout_range_clock+0x15d/0x180
[ 3753.070006]  [<c02af695>] perf_event_overflow+0x15/0x20
[ 3753.070006]  [<c0213fd9>] intel_pmu_handle_irq+0x129/0x250
[ 3753.070006]  [<c020f540>] perf_event_nmi_handler+0x20/0x30
[ 3753.070006]  [<c0205f18>] nmi_handle.clone.0+0x38/0x50
[ 3753.070006]  [<c0205fde>] do_nmi+0xae/0x350
[ 3753.070006]  [<c025a1fb>] ? sub_preempt_count+0x7b/0xb0
[ 3753.070006]  [<c0618675>] ? _raw_spin_unlock+0x15/0x40
[ 3753.070006]  [<c061969d>] nmi_stack_correct+0x28/0x2d
[ 3753.070006]  [<c025c40d>] ? try_to_wake_up+0x8d/0x220
[ 3753.070006]  [<c02ba12f>] ? __free_pages+0x1f/0x40
[ 3753.070006]  [<c025c5b0>] default_wake_function+0x10/0x20
[ 3753.070006]  [<c024ca30>] autoremove_wake_function+0x20/0x40
[ 3753.070006]  [<c0254508>] __wake_up_common+0x48/0x70
[ 3753.070006]  [<c0257983>] __wake_up_sync_key+0x43/0x60
[ 3753.070006]  [<c056f6ee>] unix_write_space+0x4e/0x90
[ 3753.070006]  [<c04dd028>] sock_wfree+0x48/0x50
[ 3753.070006]  [<c056fc10>] unix_destruct_scm+0x80/0xa0
[ 3753.070006]  [<c04e0b9d>] skb_release_head_state+0x4d/0xe0
[ 3753.070006]  [<c04e0920>] __kfree_skb+0x10/0x90
[ 3753.070006]  [<c04e09c7>] consume_skb+0x27/0x90
[ 3753.070006]  [<c056fe23>] unix_stream_recvmsg+0x1f3/0x590
[ 3753.070006]  [<c024ca10>] ? wake_up_bit+0x30/0x30
[ 3753.070006]  [<c04d87c7>] sock_aio_read+0x107/0x110
[ 3753.070006]  [<c02f4ecc>] do_sync_read+0xac/0xf0
[ 3753.070006]  [<c02f5a5f>] vfs_read+0x11f/0x130
[ 3753.070006]  [<c02f6d87>] ? fget_light+0x77/0xe0
[ 3753.070006]  [<c02f5ab2>] sys_read+0x42/0x70
[ 3753.070006]  [<c061984c>] sysenter_do_call+0x12/0x22
[ 3753.070006] ---[ end trace 994a369c06c2c20d ]---


2nd one (CONFIG_PREEMPT_NONE=y)
-------------------------------
[  241.920003] ------------[ cut here ]------------
[  241.920003] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9c/0xc0()
[  241.920003] Hardware name: ProLiant BL460c G1
[  241.920003] Watchdog detected hard LOCKUP on cpu 0
[  241.920003] Modules linked in: netconsole xt_hashlimit ipmi_devintf ipmi_si ipmi_msghandler af_packet tg3 bonding
[  241.920003] Pid: 8977, comm: hackbench Not tainted 3.2.0-05066-g31ae26a-dirty #762
[  241.920003] Call Trace:
[  241.920003]  [<c022a212>] warn_slowpath_common+0x72/0xa0
[  241.920003]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  241.920003]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  241.920003]  [<c0281bb0>] ? watchdog_timer_fn+0x170/0x170
[  241.920003]  [<c022a2e3>] warn_slowpath_fmt+0x33/0x40
[  241.920003]  [<c0281c4c>] watchdog_overflow_callback+0x9c/0xc0
[  241.920003]  [<c02a9f9a>] __perf_event_overflow+0x9a/0x240
[  241.920003]  [<c02100c8>] ? x86_perf_event_set_period+0x118/0x210
[  241.920003]  [<c02aa7f5>] perf_event_overflow+0x15/0x20
[  241.920003]  [<c0213639>] intel_pmu_handle_irq+0x129/0x250
[  241.920003]  [<c025dee0>] ? find_busiest_group+0x150/0xae0
[  241.920003]  [<c020ed80>] perf_event_nmi_handler+0x20/0x30
[  241.920003]  [<c0205d87>] do_nmi+0xb7/0x350
[  241.920003]  [<c0607ac9>] nmi_stack_correct+0x28/0x2d
[  241.920003]  [<c0606c14>] ? _raw_spin_lock+0x24/0x30
[  241.920003]  [<c025ea24>] load_balance+0x1b4/0x500
[  241.920003]  [<c025f092>] idle_balance+0xc2/0x140
[  241.920003]  [<c06060de>] __schedule+0x4be/0x650
[  241.920003]  [<c02e8485>] ? __slab_free+0x155/0x270
[  241.920003]  [<c0606325>] schedule+0x35/0x50
[  241.920003]  [<c0604b3d>] schedule_timeout+0x1dd/0x250
[  241.920003]  [<c0560ee0>] ? unix_destruct_scm+0x80/0xa0
[  241.920003]  [<c04d379d>] ? __kfree_skb+0x3d/0x90
[  241.920003]  [<c04d379d>] ? __kfree_skb+0x3d/0x90
[  241.920003]  [<c024ae88>] ? prepare_to_wait+0x48/0x70
[  241.920003]  [<c05612ed>] unix_stream_recvmsg+0x3ed/0x570
[  241.920003]  [<c024ac30>] ? wake_up_bit+0x30/0x30
[  241.920003]  [<c04cb997>] sock_aio_read+0x107/0x110
[  241.920003]  [<c02ee7ac>] do_sync_read+0xac/0xf0
[  241.920003]  [<c0230407>] ? irq_exit+0x67/0xa0
[  241.920003]  [<c0608349>] ? smp_apic_timer_interrupt+0x59/0x88
[  241.920003]  [<c025b829>] ? sched_clock_cpu+0x109/0x1a0
[  241.920003]  [<c02ef31f>] vfs_read+0x11f/0x130
[  241.920003]  [<c02ef372>] sys_read+0x42/0x70
[  241.920003]  [<c0607c4c>] sysenter_do_call+0x12/0x22
[  241.920003] ---[ end trace 066d964ca98ab480 ]---
[  241.835214] ------------[ cut here ]------------
[  241.835214] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9c/0xc0()
[  241.835214] Hardware name: ProLiant BL460c G1
[  241.835214] Watchdog detected hard LOCKUP on cpu 3
[  241.835214] Modules linked in: netconsole xt_hashlimit ipmi_devintf ipmi_si ipmi_msghandler af_packet tg3 bonding
[  241.835214] Pid: 8836, comm: hackbench Tainted: G        W    3.2.0-05066-g31ae26a-dirty #762
[  241.835214] Call Trace:
[  241.835214]  [<c022a212>] warn_slowpath_common+0x72/0xa0
[  241.835214]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  241.835214]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  241.835214]  [<c0281bb0>] ? watchdog_timer_fn+0x170/0x170
[  241.835214]  [<c022a2e3>] warn_slowpath_fmt+0x33/0x40
[  241.835214]  [<c0281c4c>] watchdog_overflow_callback+0x9c/0xc0
[  241.835214]  [<c02a9f9a>] __perf_event_overflow+0x9a/0x240
[  241.835214]  [<c02100c8>] ? x86_perf_event_set_period+0x118/0x210
[  241.835214]  [<c02aa7f5>] perf_event_overflow+0x15/0x20
[  241.835214]  [<c0213639>] intel_pmu_handle_irq+0x129/0x250
[  241.835214]  [<c025b5b2>] ? sched_clock_local+0xe2/0x1e0
[  241.835214]  [<c025b784>] ? sched_clock_cpu+0x64/0x1a0
[  241.835214]  [<c020ed80>] perf_event_nmi_handler+0x20/0x30
[  241.835214]  [<c0205d87>] do_nmi+0xb7/0x350
[  241.835214]  [<c0607ac9>] nmi_stack_correct+0x28/0x2d
[  241.835214]  [<c0259d32>] ? try_to_wake_up+0xa2/0x220
[  241.835214]  [<c0259ec0>] default_wake_function+0x10/0x20
[  241.835214]  [<c024ac50>] autoremove_wake_function+0x20/0x40
[  241.835214]  [<c0252418>] __wake_up_common+0x48/0x70
[  241.835214]  [<c02558b3>] __wake_up_sync_key+0x43/0x60
[  241.835214]  [<c04cf528>] sock_def_readable+0x38/0x60
[  241.835214]  [<c0560095>] unix_stream_sendmsg+0x215/0x3a0
[  241.835214]  [<c04cb878>] sock_aio_write+0xf8/0x110
[  241.835214]  [<c02ee6bc>] do_sync_write+0xac/0xf0
[  241.835214]  [<c02ef1e6>] vfs_write+0x126/0x140
[  241.835214]  [<c02ef3e2>] sys_write+0x42/0x70
[  241.835214]  [<c0607c4c>] sysenter_do_call+0x12/0x22
[  241.835214] ---[ end trace 066d964ca98ab481 ]---
[  241.344106] ------------[ cut here ]------------
[  241.344106] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9c/0xc0()
[  241.344106] Hardware name: ProLiant BL460c G1
[  241.344106] Watchdog detected hard LOCKUP on cpu 1
[  241.344106] Modules linked in: netconsole xt_hashlimit ipmi_devintf ipmi_si ipmi_msghandler af_packet tg3 bonding
[  241.344106] Pid: 8622, comm: hackbench Tainted: G        W    3.2.0-05066-g31ae26a-dirty #762
[  241.344106] Call Trace:
[  241.344106]  [<c022a212>] warn_slowpath_common+0x72/0xa0
[  241.344106]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  241.344106]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  241.344106]  [<c0281bb0>] ? watchdog_timer_fn+0x170/0x170
[  241.344106]  [<c022a2e3>] warn_slowpath_fmt+0x33/0x40
[  241.344106]  [<c0281c4c>] watchdog_overflow_callback+0x9c/0xc0
[  241.344106]  [<c02a9f9a>] __perf_event_overflow+0x9a/0x240
[  241.344106]  [<c02100c8>] ? x86_perf_event_set_period+0x118/0x210
[  241.344106]  [<c02aa7f5>] perf_event_overflow+0x15/0x20
[  241.344106]  [<c0213639>] intel_pmu_handle_irq+0x129/0x250
[  241.344106]  [<c0560e60>] ? unix_seqpacket_recvmsg+0x50/0x50
[  241.344106]  [<c020ed80>] perf_event_nmi_handler+0x20/0x30
[  241.344106]  [<c0205d87>] do_nmi+0xb7/0x350
[  241.344106]  [<c0607ac9>] nmi_stack_correct+0x28/0x2d
[  241.344106]  [<c04c007b>] ? hidinput_connect+0xa8b/0x2720
[  241.344106]  [<c0606c42>] ? _raw_spin_lock_irqsave+0x22/0x30
[  241.344106]  [<c0255894>] __wake_up_sync_key+0x24/0x60
[  241.344106]  [<c03b4c57>] ? _copy_from_user+0x37/0x60
[  241.344106]  [<c04cf528>] sock_def_readable+0x38/0x60
[  241.344106]  [<c0560095>] unix_stream_sendmsg+0x215/0x3a0
[  241.344106]  [<c04cb878>] sock_aio_write+0xf8/0x110
[  241.344106]  [<c02ee6bc>] do_sync_write+0xac/0xf0
[  241.344106]  [<c02ef1e6>] vfs_write+0x126/0x140
[  241.344106]  [<c02ef3e2>] sys_write+0x42/0x70
[  241.344106]  [<c0607c4c>] sysenter_do_call+0x12/0x22
[  241.344106] ---[ end trace 066d964ca98ab482 ]---
[  241.419616] ------------[ cut here ]------------
[  241.419616] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9c/0xc0()
[  241.419616] Hardware name: ProLiant BL460c G1
[  241.419616] Watchdog detected hard LOCKUP on cpu 4
[  241.419616] Modules linked in: netconsole xt_hashlimit ipmi_devintf ipmi_si ipmi_msghandler af_packet tg3 bonding
[  241.419616] Pid: 8637, comm: hackbench Tainted: G        W    3.2.0-05066-g31ae26a-dirty #762
[  241.419616] Call Trace:
[  241.419616]  [<c022a212>] warn_slowpath_common+0x72/0xa0
[  241.419616]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  241.419616]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  241.419616]  [<c0281bb0>] ? watchdog_timer_fn+0x170/0x170
[  241.419616]  [<c022a2e3>] warn_slowpath_fmt+0x33/0x40
[  241.419616]  [<c0281c4c>] watchdog_overflow_callback+0x9c/0xc0
[  241.419616]  [<c02a9f9a>] __perf_event_overflow+0x9a/0x240
[  241.419616]  [<c02ff240>] ? poll_freewait+0xb0/0xb0
[  241.419616]  [<c02100c8>] ? x86_perf_event_set_period+0x118/0x210
[  241.419616]  [<c02aa7f5>] perf_event_overflow+0x15/0x20
[  241.419616]  [<c0213639>] intel_pmu_handle_irq+0x129/0x250
[  241.419616]  [<c020ed80>] perf_event_nmi_handler+0x20/0x30
[  241.419616]  [<c0205d87>] do_nmi+0xb7/0x350
[  241.419616]  [<c0607ac9>] nmi_stack_correct+0x28/0x2d
[  241.419616]  [<c0259d32>] ? try_to_wake_up+0xa2/0x220
[  241.419616]  [<c0259ec0>] default_wake_function+0x10/0x20
[  241.419616]  [<c024ac50>] autoremove_wake_function+0x20/0x40
[  241.419616]  [<c0252418>] __wake_up_common+0x48/0x70
[  241.419616]  [<c02558b3>] __wake_up_sync_key+0x43/0x60
[  241.419616]  [<c04cf528>] sock_def_readable+0x38/0x60
[  241.419616]  [<c0560095>] unix_stream_sendmsg+0x215/0x3a0
[  241.419616]  [<c04cb878>] sock_aio_write+0xf8/0x110
[  241.419616]  [<c02ee6bc>] do_sync_write+0xac/0xf0
[  241.419616]  [<c02ef1e6>] vfs_write+0x126/0x140
[  241.419616]  [<c02ef3e2>] sys_write+0x42/0x70
[  241.419616]  [<c0607c4c>] sysenter_do_call+0x12/0x22
[  241.419616] ---[ end trace 066d964ca98ab483 ]---
[  241.897579] ------------[ cut here ]------------
[  241.897579] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9c/0xc0()
[  241.897579] Hardware name: ProLiant BL460c G1
[  241.897579] Watchdog detected hard LOCKUP on cpu 7
[  241.897579] Modules linked in: netconsole xt_hashlimit ipmi_devintf ipmi_si ipmi_msghandler af_packet tg3 bonding
[  241.897579] Pid: 8814, comm: hackbench Tainted: G        W    3.2.0-05066-g31ae26a-dirty #762
[  241.897579] Call Trace:
[  241.897579]  [<c022a212>] warn_slowpath_common+0x72/0xa0
[  241.897579]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  241.897579]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  241.897579]  [<c0281bb0>] ? watchdog_timer_fn+0x170/0x170
[  241.897579]  [<c022a2e3>] warn_slowpath_fmt+0x33/0x40
[  241.897579]  [<c0281c4c>] watchdog_overflow_callback+0x9c/0xc0
[  241.897579]  [<c02a9f9a>] __perf_event_overflow+0x9a/0x240
[  241.897579]  [<c02100c8>] ? x86_perf_event_set_period+0x118/0x210
[  241.897579]  [<c02aa7f5>] perf_event_overflow+0x15/0x20
[  241.897579]  [<c0213639>] intel_pmu_handle_irq+0x129/0x250
[  241.897579]  [<c021367b>] ? intel_pmu_handle_irq+0x16b/0x250
[  241.897579]  [<c025dee0>] ? find_busiest_group+0x150/0xae0
[  241.897579]  [<c020ed80>] perf_event_nmi_handler+0x20/0x30
[  241.897579]  [<c0205d87>] do_nmi+0xb7/0x350
[  241.897579]  [<c0607ac9>] nmi_stack_correct+0x28/0x2d
[  241.897579]  [<c0606c14>] ? _raw_spin_lock+0x24/0x30
[  241.897579]  [<c025ebc8>] load_balance+0x358/0x500
[  241.897579]  [<c025f092>] idle_balance+0xc2/0x140
[  241.897579]  [<c06060de>] __schedule+0x4be/0x650
[  241.897579]  [<c02e8485>] ? __slab_free+0x155/0x270
[  241.897579]  [<c02eb1d6>] ? __kmalloc_node_track_caller+0xf6/0x1b0
[  241.897579]  [<c0606325>] schedule+0x35/0x50
[  241.897579]  [<c0604b3d>] schedule_timeout+0x1dd/0x250
[  241.897579]  [<c0560ee0>] ? unix_destruct_scm+0x80/0xa0
[  241.897579]  [<c04d379d>] ? __kfree_skb+0x3d/0x90
[  241.897579]  [<c04d379d>] ? __kfree_skb+0x3d/0x90
[  241.897579]  [<c024ae88>] ? prepare_to_wait+0x48/0x70
[  241.897579]  [<c05612ed>] unix_stream_recvmsg+0x3ed/0x570
[  241.897579]  [<c024ac30>] ? wake_up_bit+0x30/0x30
[  241.897579]  [<c04cb997>] sock_aio_read+0x107/0x110
[  241.897579]  [<c02ee7ac>] do_sync_read+0xac/0xf0
[  241.897579]  [<c02880f2>] ? call_rcu_sched+0x12/0x20
[  241.897579]  [<c02ef31f>] vfs_read+0x11f/0x130
[  241.897579]  [<c02ef372>] sys_read+0x42/0x70
[  241.897579]  [<c0607c4c>] sysenter_do_call+0x12/0x22
[  241.897579] ---[ end trace 066d964ca98ab484 ]---
[  241.736351] ------------[ cut here ]------------
[  241.736351] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9c/0xc0()
[  241.736351] Hardware name: ProLiant BL460c G1
[  241.736351] Watchdog detected hard LOCKUP on cpu 2
[  241.736351] Modules linked in: netconsole xt_hashlimit ipmi_devintf ipmi_si ipmi_msghandler af_packet tg3 bonding
[  241.736351] Pid: 8725, comm: hackbench Tainted: G        W    3.2.0-05066-g31ae26a-dirty #762
[  241.736351] Call Trace:
[  241.736351]  [<c022a212>] warn_slowpath_common+0x72/0xa0
[  241.736351]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  241.736351]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  241.736351]  [<c0281bb0>] ? watchdog_timer_fn+0x170/0x170
[  241.736351]  [<c022a2e3>] warn_slowpath_fmt+0x33/0x40
[  241.736351]  [<c0281c4c>] watchdog_overflow_callback+0x9c/0xc0
[  241.736351]  [<c02a9f9a>] __perf_event_overflow+0x9a/0x240
[  241.736351]  [<c02100c8>] ? x86_perf_event_set_period+0x118/0x210
[  241.736351]  [<c02aa7f5>] perf_event_overflow+0x15/0x20
[  241.736351]  [<c0213639>] intel_pmu_handle_irq+0x129/0x250
[  241.736351]  [<c025dee0>] ? find_busiest_group+0x150/0xae0
[  241.736351]  [<c020ed80>] perf_event_nmi_handler+0x20/0x30
[  241.736351]  [<c0205d87>] do_nmi+0xb7/0x350
[  241.736351]  [<c0607ac9>] nmi_stack_correct+0x28/0x2d
[  241.736351]  [<c0606c14>] ? _raw_spin_lock+0x24/0x30
[  241.736351]  [<c025ebc8>] load_balance+0x358/0x500
[  241.736351]  [<c025f092>] idle_balance+0xc2/0x140
[  241.736351]  [<c06060de>] __schedule+0x4be/0x650
[  241.736351]  [<c0259d23>] ? try_to_wake_up+0x93/0x220
[  241.736351]  [<c02e8485>] ? __slab_free+0x155/0x270
[  241.736351]  [<c0606325>] schedule+0x35/0x50
[  241.736351]  [<c0604b3d>] schedule_timeout+0x1dd/0x250
[  241.736351]  [<c0560ee0>] ? unix_destruct_scm+0x80/0xa0
[  241.736351]  [<c02e8688>] ? kmem_cache_free+0xe8/0x100
[  241.736351]  [<c04d379d>] ? __kfree_skb+0x3d/0x90
[  241.736351]  [<c04d379d>] ? __kfree_skb+0x3d/0x90
[  241.736351]  [<c04d379d>] ? __kfree_skb+0x3d/0x90
[  241.736351]  [<c024ae88>] ? prepare_to_wait+0x48/0x70
[  241.736351]  [<c05612ed>] unix_stream_recvmsg+0x3ed/0x570
[  241.736351]  [<c024ac30>] ? wake_up_bit+0x30/0x30
[  241.736351]  [<c04cb997>] sock_aio_read+0x107/0x110
[  241.736351]  [<c02ee7ac>] do_sync_read+0xac/0xf0
[  241.736351]  [<c03ae5dc>] ? rb_insert_color+0xcc/0x110
[  241.736351]  [<c0230407>] ? irq_exit+0x67/0xa0
[  241.736351]  [<c0608349>] ? smp_apic_timer_interrupt+0x59/0x88
[  241.736351]  [<c02eee3a>] ? rw_verify_area+0x4a/0x100
[  241.736351]  [<c02ef31f>] vfs_read+0x11f/0x130
[  241.736351]  [<c02ef372>] sys_read+0x42/0x70
[  241.736351]  [<c0607c4c>] sysenter_do_call+0x12/0x22
[  241.736351] ---[ end trace 066d964ca98ab485 ]---
[  241.344282] ------------[ cut here ]------------
[  241.344282] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9c/0xc0()
[  241.344282] Hardware name: ProLiant BL460c G1
[  241.344282] Watchdog detected hard LOCKUP on cpu 5
[  241.344282] Modules linked in: netconsole xt_hashlimit ipmi_devintf ipmi_si ipmi_msghandler af_packet tg3 bonding
[  241.344282] Pid: 8600, comm: hackbench Tainted: G        W    3.2.0-05066-g31ae26a-dirty #762
[  241.344282] Call Trace:
[  241.344282]  [<c022a212>] warn_slowpath_common+0x72/0xa0
[  241.344282]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  241.344282]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  241.344282]  [<c0281bb0>] ? watchdog_timer_fn+0x170/0x170
[  241.344282]  [<c022a2e3>] warn_slowpath_fmt+0x33/0x40
[  241.344282]  [<c0281c4c>] watchdog_overflow_callback+0x9c/0xc0
[  241.344282]  [<c02a9f9a>] __perf_event_overflow+0x9a/0x240
[  241.344282]  [<c02100c8>] ? x86_perf_event_set_period+0x118/0x210
[  241.344282]  [<c02aa7f5>] perf_event_overflow+0x15/0x20
[  241.344282]  [<c0213639>] intel_pmu_handle_irq+0x129/0x250
[  241.344282]  [<c021367b>] ? intel_pmu_handle_irq+0x16b/0x250
[  241.344282]  [<c025dee0>] ? find_busiest_group+0x150/0xae0
[  241.344282]  [<c020ed80>] perf_event_nmi_handler+0x20/0x30
[  241.344282]  [<c0205d87>] do_nmi+0xb7/0x350
[  241.344282]  [<c0607ac9>] nmi_stack_correct+0x28/0x2d
[  241.344282]  [<c0606c14>] ? _raw_spin_lock+0x24/0x30
[  241.344282]  [<c025ebc8>] load_balance+0x358/0x500
[  241.344282]  [<c025f092>] idle_balance+0xc2/0x140
[  241.344282]  [<c06060de>] __schedule+0x4be/0x650
[  241.344282]  [<c025dee0>] ? find_busiest_group+0x150/0xae0
[  241.344282]  [<c02e8485>] ? __slab_free+0x155/0x270
[  241.344282]  [<c02eb1d6>] ? __kmalloc_node_track_caller+0xf6/0x1b0
[  241.344282]  [<c0606325>] schedule+0x35/0x50
[  241.344282]  [<c0604b3d>] schedule_timeout+0x1dd/0x250
[  241.344282]  [<c0560ee0>] ? unix_destruct_scm+0x80/0xa0
[  241.344282]  [<c02e8688>] ? kmem_cache_free+0xe8/0x100
[  241.344282]  [<c04d379d>] ? __kfree_skb+0x3d/0x90
[  241.344282]  [<c04d379d>] ? __kfree_skb+0x3d/0x90
[  241.344282]  [<c04d379d>] ? __kfree_skb+0x3d/0x90
[  241.344282]  [<c024ae88>] ? prepare_to_wait+0x48/0x70
[  241.344282]  [<c05612ed>] unix_stream_recvmsg+0x3ed/0x570
[  241.344282]  [<c024ac30>] ? wake_up_bit+0x30/0x30
[  241.344282]  [<c04cb997>] sock_aio_read+0x107/0x110
[  241.344282]  [<c02ee7ac>] do_sync_read+0xac/0xf0
[  241.344282]  [<c0222f2b>] ? do_page_fault+0x16b/0x3d0
[  241.344282]  [<c02ef31f>] vfs_read+0x11f/0x130
[  241.344282]  [<c02ef372>] sys_read+0x42/0x70
[  241.344282]  [<c0607c4c>] sysenter_do_call+0x12/0x22
[  241.344282] ---[ end trace 066d964ca98ab486 ]---
[  241.750004] ------------[ cut here ]------------
[  241.750004] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9c/0xc0()
[  241.750004] Hardware name: ProLiant BL460c G1
[  241.750004] Watchdog detected hard LOCKUP on cpu 6
[  241.750004] Modules linked in: netconsole xt_hashlimit ipmi_devintf ipmi_si ipmi_msghandler af_packet tg3 bonding
[  241.750004] Pid: 8745, comm: hackbench Tainted: G        W    3.2.0-05066-g31ae26a-dirty #762
[  241.750004] Call Trace:
[  241.750004]  [<c022a212>] warn_slowpath_common+0x72/0xa0
[  241.750004]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  241.750004]  [<c0281c4c>] ? watchdog_overflow_callback+0x9c/0xc0
[  241.750004]  [<c0281bb0>] ? watchdog_timer_fn+0x170/0x170
[  241.750004]  [<c022a2e3>] warn_slowpath_fmt+0x33/0x40
[  241.750004]  [<c0281c4c>] watchdog_overflow_callback+0x9c/0xc0
[  241.750004]  [<c02a9f9a>] __perf_event_overflow+0x9a/0x240
[  241.750004]  [<c02100c8>] ? x86_perf_event_set_period+0x118/0x210
[  241.750004]  [<c02aa7f5>] perf_event_overflow+0x15/0x20
[  241.750004]  [<c0213639>] intel_pmu_handle_irq+0x129/0x250
[  241.750004]  [<c025b5b2>] ? sched_clock_local+0xe2/0x1e0
[  241.750004]  [<c025b829>] ? sched_clock_cpu+0x109/0x1a0
[  241.750004]  [<c020ed80>] perf_event_nmi_handler+0x20/0x30
[  241.750004]  [<c0205d87>] do_nmi+0xb7/0x350
[  241.750004]  [<c0607ac9>] nmi_stack_correct+0x28/0x2d
[  241.750004]  [<c0259d32>] ? try_to_wake_up+0xa2/0x220
[  241.750004]  [<c0259ec0>] default_wake_function+0x10/0x20
[  241.750004]  [<c024ac50>] autoremove_wake_function+0x20/0x40
[  241.750004]  [<c0252418>] __wake_up_common+0x48/0x70
[  241.750004]  [<c02558b3>] __wake_up_sync_key+0x43/0x60
[  241.750004]  [<c04cf528>] sock_def_readable+0x38/0x60
[  241.750004]  [<c0560095>] unix_stream_sendmsg+0x215/0x3a0
[  241.750004]  [<c04cb878>] sock_aio_write+0xf8/0x110
[  241.750004]  [<c02ee6bc>] do_sync_write+0xac/0xf0
[  241.750004]  [<c03ae78a>] ? rb_erase+0x16a/0x290
[  241.750004]  [<c0230407>] ? irq_exit+0x67/0xa0
[  241.750004]  [<c0608349>] ? smp_apic_timer_interrupt+0x59/0x88
[  241.750004]  [<c02ef1e6>] vfs_write+0x126/0x140
[  241.750004]  [<c02ef3e2>] sys_write+0x42/0x70
[  241.750004]  [<c0607c4c>] sysenter_do_call+0x12/0x22
[  241.750004] ---[ end trace 066d964ca98ab487 ]---



