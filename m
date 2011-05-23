Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744Ab1EWW2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 18:28:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659Ab1EWW2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 18:28:35 -0400
Date: Mon, 23 May 2011 18:28:22 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: mingo@elte.hu
Subject: suspicious rcu_dereference_check in post_schedule.
Message-ID: <20110523222822.GA7027@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, mingo@elte.hu
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

just noticed this on a build of Linus' tree from sometime yesterday.

	Dave

===================================================
[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
kernel/sched_rt.c:1266 invoked rcu_dereference_check() without protection!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 0
1 lock held by watchdog/0/12:
 #0:  (&rq->lock){-.-.-.}, at: [<ffffffff8104c460>] post_schedule.part.25+0x14/0x4a

stack backtrace:
Pid: 12, comm: watchdog/0 Not tainted 2.6.39+ #43
Call Trace:
 [<ffffffff8108c376>] lockdep_rcu_dereference+0xa7/0xaf
 [<ffffffff8104b7ee>] find_lowest_rq+0x11b/0x19a
 [<ffffffff81055667>] push_rt_task.part.69+0x7b/0x1d2
 [<ffffffff810558cc>] post_schedule_rt+0x1f/0x27
 [<ffffffff8104c47c>] post_schedule.part.25+0x30/0x4a
 [<ffffffff814c8ac9>] schedule+0x76e/0x7ca
 [<ffffffff810bf0af>] ? watchdog_enable+0x194/0x194
 [<ffffffff810bf0af>] ? watchdog_enable+0x194/0x194
 [<ffffffff810bf122>] watchdog+0x73/0xb6
 [<ffffffff810793e9>] kthread+0xa8/0xb0
 [<ffffffff814ce230>] ? sub_preempt_count+0xa1/0xb4
 [<ffffffff814d24a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff814cb698>] ? retint_restore_args+0x13/0x13
 [<ffffffff81079341>] ? __init_kthread_worker+0x5a/0x5a
 [<ffffffff814d24a0>] ? gs_change+0x13/0x13

