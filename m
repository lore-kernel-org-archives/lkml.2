Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943Ab2C2Uco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 16:32:44 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42572 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab2C2Uch convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 16:32:37 -0400
MIME-Version: 1.0
In-Reply-To: <CA+1xoqcf6qJOouKXGEHsjWSBJdA7qtMnuVopq+hoHS+TX8fvSg@mail.gmail.com>
References: <CA+1xoqcf6qJOouKXGEHsjWSBJdA7qtMnuVopq+hoHS+TX8fvSg@mail.gmail.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Thu, 29 Mar 2012 22:32:16 +0200
Message-ID: <CA+1xoqcJAwgTgQG=nZPsH_SLkPFkGt2rUiVWGn5SO5JOAC1RAA@mail.gmail.com>
Subject: sched: WARNING: at include/linux/cpumask.h:108 select_fallback_rq+0x241/0x280()
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(and now with lkml)

Hi all,

I got the following spew using trinity in a kvm tools guest on the
latest linux-next kernel.

This is the result of trying to offline CPU1. I'm not sure how to
reproduce it easily besides putting some pressure on the system and
shutting down CPUs until it happens.

[  317.238839] Cannot set affinity for irq 0
[  317.238839] ------------[ cut here ]------------
[  317.238839] WARNING: at include/linux/cpumask.h:108
select_fallback_rq+0x241/0x280()
[  317.238839] Pid: 13, comm: migration/1 Not tainted
3.3.0-next-20120329-sasha #4
[  317.238839] Call Trace:
[  317.238839]  [<ffffffff810b26b5>] warn_slowpath_common+0x75/0xb0
[  317.238839]  [<ffffffff810b2705>] warn_slowpath_null+0x15/0x20
[  317.238839]  [<ffffffff810e5991>] select_fallback_rq+0x241/0x280
[  317.238839]  [<ffffffff810f1a40>] ? dequeue_task_fair+0x100/0x100
[  317.238839]  [<ffffffff810f1a40>] ? dequeue_task_fair+0x100/0x100
[  317.238839]  [<ffffffff810ecd20>] migrate_tasks+0x80/0xf0
[  317.238839]  [<ffffffff826fe03a>] ? migration_call+0xae/0x16b
[  317.238839]  [<ffffffff826fe073>] migration_call+0xe7/0x16b
[  317.238839]  [<ffffffff810ddebf>] notifier_call_chain+0x5f/0x150
[  317.238839]  [<ffffffff810ddfb9>] __raw_notifier_call_chain+0x9/0x10
[  317.238839]  [<ffffffff810b489b>] __cpu_notify+0x1b/0x30
[  317.238839]  [<ffffffff826c3fbd>] take_cpu_down+0x2d/0x40
[  317.238839]  [<ffffffff811357fa>] stop_machine_cpu_stop+0xda/0x1a0
[  317.238839]  [<ffffffff81135720>] ? queue_stop_cpus_work+0x190/0x190
[  317.238839]  [<ffffffff811352ae>] cpu_stopper_thread+0xee/0x200
[  317.238839]  [<ffffffff82705c1a>] ? __schedule+0x49a/0x860
[  317.238839]  [<ffffffff811351c0>] ? res_counter_init+0x50/0x50
[  317.238839]  [<ffffffff810d715e>] kthread+0xbe/0xd0
[  317.238839]  [<ffffffff82709e74>] kernel_thread_helper+0x4/0x10
[  317.238839]  [<ffffffff810e3ee0>] ? finish_task_switch+0x80/0x110
[  317.238839]  [<ffffffff82708174>] ? retint_restore_args+0x13/0x13
[  317.238839]  [<ffffffff810d70a0>] ? __init_kthread_worker+0x70/0x70
[  317.238839]  [<ffffffff82709e70>] ? gs_change+0x13/0x13
[  317.238839] ---[ end trace 79079cf527253aab ]---
[  317.250645] [sched_delayed] process 2267 (trinity) no longer affine to cpu1
[  317.323711] CPU 1 is now offline
[  317.591059] [sched_delayed] process 1956 (trinity) no longer affine to cpu1
[  317.812110] [sched_delayed] process 2004 (trinity) no longer affine to cpu1
[  318.401016] [sched_delayed] process 2228 (trinity) no longer affine to cpu1
[  318.581015] [sched_delayed] process 2099 (trinity) no longer affine to cpu1
