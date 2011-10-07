Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156Ab1JGQ1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 12:27:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38399 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab1JGQ1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 12:27:40 -0400
MIME-Version: 1.0
Date: Fri, 7 Oct 2011 12:27:38 -0400
Message-ID: <CAHFgRy8t44sSgfdSSH7SOoCWFkeHeL5gnN_CaCY3ZmnS39WNQQ@mail.gmail.com>
Subject: 3.1.0-rc9-00020-g3ee72ca (Linus git tree) -- INFO: possible circular
 locking dependency detected
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I hope I have CCed the right maintainers.

[   73.223063] [ INFO: possible circular locking dependency detected ]
[   73.223065] 3.1.0-rc9-00020-g3ee72ca #3
[   73.223066] -------------------------------------------------------
[   73.223068] chrome/2324 is trying to acquire lock:
[   73.223069]  (&(&sig->cputimer.lock)->rlock){......}, at:
[<ffffffff81027953>] account_group_exec_runtime+0x2d/0x45
[   73.223077]
[   73.223078] but task is already holding lock:
[   73.223079]  (&rq->lock){-.-.-.}, at: [<ffffffff813aada9>]
__schedule+0xd2/0x636
[   73.223085]
[   73.223085] which lock already depends on the new lock.
[   73.223086]
[   73.223087]
[   73.223088] the existing dependency chain (in reverse order) is:
[   73.223089]
[   73.223090] -> #2 (&rq->lock){-.-.-.}:
[   73.223093]        [<ffffffff81062007>] lock_acquire+0x8a/0xa2
[   73.223097]        [<ffffffff813acb99>] _raw_spin_lock+0x36/0x45
[   73.223100]        [<ffffffff81027b5b>] __task_rq_lock+0x59/0x85
[   73.223103]        [<ffffffff81032a34>] wake_up_new_task+0x3f/0x92
[   73.223106]        [<ffffffff8103682e>] do_fork+0x198/0x236
[   73.223109]        [<ffffffff81008549>] kernel_thread+0x6b/0x6d
[   73.223113]        [<ffffffff8139205d>] rest_init+0x21/0xd2
[   73.223117]        [<ffffffff81671b1e>] start_kernel+0x394/0x39f
[   73.223121]        [<ffffffff8167129f>] x86_64_start_reservations+0xaf/0xb3
[   73.223123]        [<ffffffff81671393>] x86_64_start_kernel+0xf0/0xf7
[   73.223126]
[   73.223126] -> #1 (&p->pi_lock){-.-.-.}:
[   73.223129]        [<ffffffff81062007>] lock_acquire+0x8a/0xa2
[   73.223132]        [<ffffffff813acc92>] _raw_spin_lock_irqsave+0x44/0x57
[   73.223135]        [<ffffffff81050c79>] thread_group_cputimer+0x2d/0xb8
[   73.223138]        [<ffffffff81050d2a>] cpu_timer_sample_group+0x26/0x70
[   73.223141]        [<ffffffff81051c81>] set_process_cpu_timer+0x31/0xdb
[   73.223143]        [<ffffffff8103b201>] set_cpu_itimer+0x121/0x179
[   73.223147]        [<ffffffff8103b64f>] do_setitimer+0x1e4/0x1f5
[   73.223149]        [<ffffffff8103b724>] sys_setitimer+0x69/0xa9
[   73.223152]        [<ffffffff813b1d3b>] system_call_fastpath+0x16/0x1b
[   73.223155]
[   73.223155] -> #0 (&(&sig->cputimer.lock)->rlock){......}:
[   73.223158]        [<ffffffff810618f7>] __lock_acquire+0xa73/0xd67
[   73.223160]        [<ffffffff81062007>] lock_acquire+0x8a/0xa2
[   73.223163]        [<ffffffff813acb99>] _raw_spin_lock+0x36/0x45
[   73.223165]        [<ffffffff81027953>] account_group_exec_runtime+0x2d/0x45
[   73.223168]        [<ffffffff810279e7>] update_curr+0x7c/0x85
[   73.223171]        [<ffffffff8102aa11>] dequeue_task_fair+0x30/0x10b
[   73.223173]        [<ffffffff81029685>] dequeue_task+0x75/0x7c
[   73.223176]        [<ffffffff810296b2>] deactivate_task+0x26/0x2f
[   73.223178]        [<ffffffff813aae09>] __schedule+0x132/0x636
[   73.223180]        [<ffffffff813ab45e>] schedule+0x55/0x57
[   73.223183]        [<ffffffff813ab4be>] io_schedule+0x5e/0x79
[   73.223186]        [<ffffffff8109912f>] sleep_on_page_killable+0x9/0x36
[   73.223190]        [<ffffffff813ab945>] __wait_on_bit+0x43/0x76
[   73.223192]        [<ffffffff8109aef6>] wait_on_page_bit_killable+0x6f/0x71
[   73.223196]        [<ffffffff8109af3c>] __lock_page_or_retry+0x44/0x8d
[   73.223198]        [<ffffffff8109b154>] filemap_fault+0x1cf/0x35b
[   73.223201]        [<ffffffff810ae9f1>] __do_fault+0x98/0x333
[   73.223205]        [<ffffffff810b0a97>] handle_pte_fault+0x20f/0x5a0
[   73.223208]        [<ffffffff810b10d8>] handle_mm_fault+0x155/0x168
[   73.223211]        [<ffffffff813afedd>] do_page_fault+0x30a/0x351
[   73.223213]        [<ffffffff813ad97f>] page_fault+0x1f/0x30
[   73.223216]        [<ffffffff811aae8d>] strncpy_from_user+0x33/0x35
[   73.223220]        [<ffffffff810d941c>] getname_flags+0x16b/0x1db
[   73.223223]        [<ffffffff810d9497>] getname+0xb/0xd
[   73.223226]        [<ffffffff810cf4cf>] do_sys_open+0x31/0xfb
[   73.223229]        [<ffffffff810cf5b4>] sys_open+0x1b/0x1d
[   73.223232]        [<ffffffff813b1d3b>] system_call_fastpath+0x16/0x1b
[   73.223234]
[   73.223235] other info that might help us debug this:
[   73.223235]
[   73.223237] Chain exists of:
[   73.223237]   &(&sig->cputimer.lock)->rlock --> &p->pi_lock --> &rq->lock
[   73.223241]
[   73.223242]  Possible unsafe locking scenario:
[   73.223243]
[   73.223244]        CPU0                    CPU1
[   73.223245]        ----                    ----
[   73.223246]   lock(&rq->lock);
[   73.223248]                                lock(&p->pi_lock);
[   73.223250]                                lock(&rq->lock);
[   73.223253]   lock(&(&sig->cputimer.lock)->rlock);
[   73.223255]
[   73.223255]  *** DEADLOCK ***
[   73.223255]
[   73.223257] 1 lock held by chrome/2324:
[   73.223258]  #0:  (&rq->lock){-.-.-.}, at: [<ffffffff813aada9>]
__schedule+0xd2/0x636
[   73.223263]
[   73.223263] stack backtrace:
[   73.223265] Pid: 2324, comm: chrome Not tainted 3.1.0-rc9-00020-g3ee72ca #3
[   73.223267] Call Trace:
[   73.223271]  [<ffffffff813a4884>] print_circular_bug+0x1f8/0x209
[   73.223274]  [<ffffffff810618f7>] __lock_acquire+0xa73/0xd67
[   73.223277]  [<ffffffff81062007>] lock_acquire+0x8a/0xa2
[   73.223279]  [<ffffffff81027953>] ? account_group_exec_runtime+0x2d/0x45
[   73.223282]  [<ffffffff813acb99>] _raw_spin_lock+0x36/0x45
[   73.223285]  [<ffffffff81027953>] ? account_group_exec_runtime+0x2d/0x45
[   73.223287]  [<ffffffff81027953>] account_group_exec_runtime+0x2d/0x45
[   73.223290]  [<ffffffff810279e7>] update_curr+0x7c/0x85
[   73.223292]  [<ffffffff8102aa11>] dequeue_task_fair+0x30/0x10b
[   73.223295]  [<ffffffff81099126>] ? sleep_on_page+0xd/0xd
[   73.223297]  [<ffffffff81029685>] dequeue_task+0x75/0x7c
[   73.223299]  [<ffffffff810296b2>] deactivate_task+0x26/0x2f
[   73.223302]  [<ffffffff813aae09>] __schedule+0x132/0x636
[   73.223304]  [<ffffffff8105736c>] ? ktime_get_ts+0x80/0x89
[   73.223307]  [<ffffffff81099126>] ? sleep_on_page+0xd/0xd
[   73.223309]  [<ffffffff813ab45e>] schedule+0x55/0x57
[   73.223312]  [<ffffffff813ab4be>] io_schedule+0x5e/0x79
[   73.223314]  [<ffffffff8109912f>] sleep_on_page_killable+0x9/0x36
[   73.223317]  [<ffffffff813ab945>] __wait_on_bit+0x43/0x76
[   73.223320]  [<ffffffff8109aef6>] wait_on_page_bit_killable+0x6f/0x71
[   73.223323]  [<ffffffff8104f6f4>] ? autoremove_wake_function+0x38/0x38
[   73.223326]  [<ffffffff8109af3c>] __lock_page_or_retry+0x44/0x8d
[   73.223328]  [<ffffffff8109b154>] filemap_fault+0x1cf/0x35b
[   73.223331]  [<ffffffff810ae9f1>] __do_fault+0x98/0x333
[   73.223334]  [<ffffffff810af353>] ? __pte_alloc+0x3e/0xf8
[   73.223337]  [<ffffffff810b0a97>] handle_pte_fault+0x20f/0x5a0
[   73.223339]  [<ffffffff813ad13c>] ? _raw_spin_unlock+0x43/0x51
[   73.223342]  [<ffffffff810b10d8>] handle_mm_fault+0x155/0x168
[   73.223345]  [<ffffffff813afedd>] do_page_fault+0x30a/0x351
[   73.223347]  [<ffffffff81061bdc>] ? __lock_acquire+0xd58/0xd67
[   73.223350]  [<ffffffff810d92dd>] ? getname_flags+0x2c/0x1db
[   73.223352]  [<ffffffff8105e77c>] ? trace_hardirqs_off_caller+0xa3/0x10b
[   73.223355]  [<ffffffff811aab1d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   73.223358]  [<ffffffff813ad97f>] page_fault+0x1f/0x30
[   73.223361]  [<ffffffff811aae47>] ? __strncpy_from_user+0x30/0x43
[   73.223363]  [<ffffffff811aae30>] ? __strncpy_from_user+0x19/0x43
[   73.223366]  [<ffffffff811aae8d>] strncpy_from_user+0x33/0x35
[   73.223369]  [<ffffffff810d941c>] getname_flags+0x16b/0x1db
[   73.223373]  [<ffffffff810d9497>] getname+0xb/0xd
[   73.223375]  [<ffffffff810cf4cf>] do_sys_open+0x31/0xfb
[   73.223378]  [<ffffffff810cf5b4>] sys_open+0x1b/0x1d
[   73.223380]  [<ffffffff813b1d3b>] system_call_fastpath+0x16/0x1b
