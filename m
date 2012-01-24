Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab2AXQZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 11:25:18 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58743 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab2AXQZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 11:25:16 -0500
Message-ID: <1327422312.7231.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [GIT PULL] RCU changes for v3.3
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 24 Jan 2012 17:25:12 +0100
In-Reply-To: <20120105135432.GA31450@elte.hu>
References: <20120105135432.GA31450@elte.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 05 janvier 2012 à 14:54 +0100, Ingo Molnar a écrit :
> Linus,
> 
> Please pull the latest core-rcu-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-rcu-for-linus
> 
>  Thanks,
> 

Hi guys

New lockdep warning here :


[  850.464548] 
[  850.464550] ===============================
[  850.464553] [ INFO: suspicious RCU usage. ]
[  850.464555] 3.3.0-rc1+ #569 Not tainted
[  850.464557] -------------------------------
[  850.464559] include/trace/events/power.h:102 suspicious rcu_dereference_check() usage!
[  850.464562] 
[  850.464562] other info that might help us debug this:
[  850.464564] 
[  850.464566] 
[  850.464567] rcu_scheduler_active = 1, debug_locks = 1
[  850.464569] RCU used illegally from extended quiescent state!
[  850.464571] no locks held by swapper/1/0.
[  850.464572] 
[  850.464572] stack backtrace:
[  850.464575] Pid: 0, comm: swapper/1 Not tainted 3.3.0-rc1+ #569
[  850.464578] Call Trace:
[  850.464584]  [<ffffffff81094a2a>] lockdep_rcu_suspicious+0xca/0xf0
[  850.464588]  [<ffffffff8100abb9>] mwait_idle+0x499/0x4c0
[  850.464592]  [<ffffffff810011e6>] cpu_idle+0x96/0xe0
[  850.464597]  [<ffffffff8176bbae>] start_secondary+0x1df/0x1e3
[  850.464765] ------------[ cut here ]------------
[  850.464769] WARNING: at include/linux/rcupdate.h:242 __perf_event_overflow+0x27c/0x2c0()
[  850.464771] Hardware name: ProLiant BL460c G6
[  850.464772] Modules linked in: ipmi_devintf nfsd exportfs ipmi_si hpilo bnx2x crc32c libcrc32c mdio [last unloaded: scsi_wait_scan]
[  850.464783] Pid: 0, comm: swapper/1 Not tainted 3.3.0-rc1+ #569
[  850.464784] Call Trace:
[  850.464788]  [<ffffffff81038f1f>] warn_slowpath_common+0x7f/0xc0
[  850.464791]  [<ffffffff81038f7a>] warn_slowpath_null+0x1a/0x20
[  850.464794]  [<ffffffff810f8f2c>] __perf_event_overflow+0x27c/0x2c0
[  850.464797]  [<ffffffff8177126e>] ? printk+0x41/0x43
[  850.464801]  [<ffffffff810a1ff6>] ? __module_text_address+0x16/0x80
[  850.464804]  [<ffffffff810f9019>] perf_swevent_overflow+0xa9/0xc0
[  850.464806]  [<ffffffff810f909f>] perf_swevent_event+0x6f/0x90
[  850.464809]  [<ffffffff810f9136>] perf_tp_event+0x76/0xf0
[  850.464813]  [<ffffffff810f153e>] perf_trace_power+0xbe/0xe0
[  850.464816]  [<ffffffff8100ab2f>] ? mwait_idle+0x40f/0x4c0
[  850.464818]  [<ffffffff8100ab2f>] mwait_idle+0x40f/0x4c0
[  850.464821]  [<ffffffff810011e6>] cpu_idle+0x96/0xe0
[  850.464824]  [<ffffffff8176bbae>] start_secondary+0x1df/0x1e3
[  850.464826] ---[ end trace d3b6df8c2cde8681 ]---
[  850.464828] ------------[ cut here ]------------
[  850.464831] WARNING: at include/linux/rcupdate.h:242 perf_output_begin+0x2f6/0x330()
[  850.464832] Hardware name: ProLiant BL460c G6
[  850.464833] Modules linked in: ipmi_devintf nfsd exportfs ipmi_si hpilo bnx2x crc32c libcrc32c mdio [last unloaded: scsi_wait_scan]
[  850.464842] Pid: 0, comm: swapper/1 Tainted: G        W    3.3.0-rc1+ #569
[  850.464844] Call Trace:
[  850.464846]  [<ffffffff81038f1f>] warn_slowpath_common+0x7f/0xc0
[  850.464849]  [<ffffffff81038f7a>] warn_slowpath_null+0x1a/0x20
[  850.464852]  [<ffffffff810fc2f6>] perf_output_begin+0x2f6/0x330
[  850.464855]  [<ffffffff810769e5>] ? sched_clock_cpu+0xc5/0x120
[  850.464858]  [<ffffffff8109378d>] ? trace_hardirqs_off+0xd/0x10
[  850.464860]  [<ffffffff81076a8f>] ? local_clock+0x4f/0x60
[  850.464863]  [<ffffffff810f223d>] ? __perf_event_header__init_id+0xad/0xf0
[  850.464866]  [<ffffffff810f8c03>] ? perf_prepare_sample+0x63/0x110
[  850.464869]  [<ffffffff810f8e3d>] __perf_event_overflow+0x18d/0x2c0
[  850.464871]  [<ffffffff810f8df5>] ? __perf_event_overflow+0x145/0x2c0
[  850.464874]  [<ffffffff8177126e>] ? printk+0x41/0x43
[  850.464876]  [<ffffffff810f9019>] perf_swevent_overflow+0xa9/0xc0
[  850.464879]  [<ffffffff810f909f>] perf_swevent_event+0x6f/0x90
[  850.464881]  [<ffffffff810f9136>] perf_tp_event+0x76/0xf0
[  850.464884]  [<ffffffff810f153e>] perf_trace_power+0xbe/0xe0
[  850.464887]  [<ffffffff8100ab2f>] ? mwait_idle+0x40f/0x4c0
[  850.464890]  [<ffffffff8100ab2f>] mwait_idle+0x40f/0x4c0
[  850.464893]  [<ffffffff810011e6>] cpu_idle+0x96/0xe0
[  850.464895]  [<ffffffff8176bbae>] start_secondary+0x1df/0x1e3
[  850.464897] ---[ end trace d3b6df8c2cde8682 ]---
[  850.464899] 
[  850.464900] ===============================
[  850.464901] [ INFO: suspicious RCU usage. ]
[  850.464902] 3.3.0-rc1+ #569 Tainted: G        W   
[  850.464904] -------------------------------
[  850.464905] kernel/events/ring_buffer.c:120 suspicious rcu_dereference_check() usage!
[  850.464907] 
[  850.464907] other info that might help us debug this:
[  850.464908] 
[  850.464909] 
[  850.464910] rcu_scheduler_active = 1, debug_locks = 1
[  850.464911] RCU used illegally from extended quiescent state!
[  850.464913] 2 locks held by swapper/1/0:
[  850.464914]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff810f8df5>] __perf_event_overflow+0x145/0x2c0
[  850.464920]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff810fc03f>] perf_output_begin+0x3f/0x330
[  850.464924] 
[  850.464925] stack backtrace:
[  850.464927] Pid: 0, comm: swapper/1 Tainted: G        W    3.3.0-rc1+ #569
[  850.464928] Call Trace:
[  850.464931]  [<ffffffff81094a2a>] lockdep_rcu_suspicious+0xca/0xf0
[  850.464933]  [<ffffffff810fc268>] perf_output_begin+0x268/0x330
[  850.464936]  [<ffffffff810fc03f>] ? perf_output_begin+0x3f/0x330
[  850.464938]  [<ffffffff810769e5>] ? sched_clock_cpu+0xc5/0x120
[  850.464941]  [<ffffffff8109378d>] ? trace_hardirqs_off+0xd/0x10
[  850.464943]  [<ffffffff81076a8f>] ? local_clock+0x4f/0x60
[  850.464946]  [<ffffffff810f223d>] ? __perf_event_header__init_id+0xad/0xf0
[  850.464949]  [<ffffffff810f8c03>] ? perf_prepare_sample+0x63/0x110
[  850.464952]  [<ffffffff810f8e3d>] __perf_event_overflow+0x18d/0x2c0
[  850.464954]  [<ffffffff810f8df5>] ? __perf_event_overflow+0x145/0x2c0
[  850.464957]  [<ffffffff8177126e>] ? printk+0x41/0x43
[  850.464959]  [<ffffffff810f9019>] perf_swevent_overflow+0xa9/0xc0
[  850.464962]  [<ffffffff810f909f>] perf_swevent_event+0x6f/0x90
[  850.464964]  [<ffffffff810f9136>] perf_tp_event+0x76/0xf0
[  850.464967]  [<ffffffff810f153e>] perf_trace_power+0xbe/0xe0
[  850.464970]  [<ffffffff8100ab2f>] ? mwait_idle+0x40f/0x4c0
[  850.464973]  [<ffffffff8100ab2f>] mwait_idle+0x40f/0x4c0
[  850.464975]  [<ffffffff810011e6>] cpu_idle+0x96/0xe0
[  850.464978]  [<ffffffff8176bbae>] start_secondary+0x1df/0x1e3
[  850.464980] ------------[ cut here ]------------
[  850.464983] WARNING: at include/linux/rcupdate.h:248 perf_output_end+0x5b/0x70()
[  850.464984] Hardware name: ProLiant BL460c G6
[  850.464985] Modules linked in: ipmi_devintf nfsd exportfs ipmi_si hpilo bnx2x crc32c libcrc32c mdio [last unloaded: scsi_wait_scan]
[  850.464994] Pid: 0, comm: swapper/1 Tainted: G        W    3.3.0-rc1+ #569
[  850.464995] Call Trace:
[  850.464998]  [<ffffffff81038f1f>] warn_slowpath_common+0x7f/0xc0
[  850.465001]  [<ffffffff81038f7a>] warn_slowpath_null+0x1a/0x20
[  850.465003]  [<ffffffff810fc38b>] perf_output_end+0x5b/0x70
[  850.465006]  [<ffffffff810f8edc>] __perf_event_overflow+0x22c/0x2c0
[  850.465008]  [<ffffffff810f8df5>] ? __perf_event_overflow+0x145/0x2c0
[  850.465011]  [<ffffffff810f9019>] perf_swevent_overflow+0xa9/0xc0
[  850.465014]  [<ffffffff810f909f>] perf_swevent_event+0x6f/0x90
[  850.465016]  [<ffffffff810f9136>] perf_tp_event+0x76/0xf0
[  850.465019]  [<ffffffff810f153e>] perf_trace_power+0xbe/0xe0
[  850.465022]  [<ffffffff8100ab2f>] ? mwait_idle+0x40f/0x4c0
[  850.465025]  [<ffffffff8100ab2f>] mwait_idle+0x40f/0x4c0
[  850.465027]  [<ffffffff810011e6>] cpu_idle+0x96/0xe0
[  850.465030]  [<ffffffff8176bbae>] start_secondary+0x1df/0x1e3
[  850.465032] ---[ end trace d3b6df8c2cde8683 ]---
[  850.465033] ------------[ cut here ]------------
[  850.465036] WARNING: at include/linux/rcupdate.h:248 __perf_event_overflow+0x2a6/0x2c0()
[  850.465037] Hardware name: ProLiant BL460c G6
[  850.465038] Modules linked in: ipmi_devintf nfsd exportfs ipmi_si hpilo bnx2x crc32c libcrc32c mdio [last unloaded: scsi_wait_scan]
[  850.465047] Pid: 0, comm: swapper/1 Tainted: G        W    3.3.0-rc1+ #569
[  850.465048] Call Trace:
[  850.465051]  [<ffffffff81038f1f>] warn_slowpath_common+0x7f/0xc0
[  850.465054]  [<ffffffff81038f7a>] warn_slowpath_null+0x1a/0x20
[  850.465056]  [<ffffffff810f8f56>] __perf_event_overflow+0x2a6/0x2c0
[  850.465059]  [<ffffffff810f8df5>] ? __perf_event_overflow+0x145/0x2c0
[  850.465061]  [<ffffffff810f9019>] perf_swevent_overflow+0xa9/0xc0
[  850.465064]  [<ffffffff810f909f>] perf_swevent_event+0x6f/0x90
[  850.465066]  [<ffffffff810f9136>] perf_tp_event+0x76/0xf0
[  850.465069]  [<ffffffff810f153e>] perf_trace_power+0xbe/0xe0
[  850.465072]  [<ffffffff8100ab2f>] ? mwait_idle+0x40f/0x4c0
[  850.465075]  [<ffffffff8100ab2f>] mwait_idle+0x40f/0x4c0
[  850.465077]  [<ffffffff810011e6>] cpu_idle+0x96/0xe0
[  850.465080]  [<ffffffff8176bbae>] start_secondary+0x1df/0x1e3
[  850.465082] ---[ end trace d3b6df8c2cde8684 ]---
[  850.467615] 
[  850.467617] ===============================
[  850.467619] [ INFO: suspicious RCU usage. ]
[  850.467621] 3.3.0-rc1+ #569 Tainted: G        W   
[  850.467624] -------------------------------
[  850.467626] include/trace/events/power.h:127 suspicious rcu_dereference_check() usage!
[  850.467629] 
[  850.467629] other info that might help us debug this:
[  850.467630] 
[  850.467632] 
[  850.467632] rcu_scheduler_active = 1, debug_locks = 1
[  850.467634] RCU used illegally from extended quiescent state!
[  850.467636] no locks held by swapper/1/0.
[  850.467637] 
[  850.467638] stack backtrace:
[  850.467640] Pid: 0, comm: swapper/1 Tainted: G        W    3.3.0-rc1+ #569
[  850.467642] Call Trace:
[  850.467646]  [<ffffffff81094a2a>] lockdep_rcu_suspicious+0xca/0xf0
[  850.467650]  [<ffffffff8100a9cd>] mwait_idle+0x2ad/0x4c0
[  850.467653]  [<ffffffff810011e6>] cpu_idle+0x96/0xe0
[  850.467656]  [<ffffffff8176bbae>] start_secondary+0x1df/0x1e3


