Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab1EXF7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 01:59:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62881 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab1EXF7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 01:59:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=U5WLyzLT0B3Pvv2LBXot1zAYtcDBEttHRWcC9kvfkq4suAiYtiHkr4Rw8xnwxmfbBT
         sv6X2hRWsxdXzU4ZzyIB6NuXqkTLXgQs9Hj+Wdsz/o8lFEPXwYGJBekbHQot2mnfan0t
         nL6EEwBjPp8+OEMkfvrqqaGBB5nmB88IWT1gc=
Message-ID: <4DDB491A.2070901@gmail.com>
Date: Mon, 23 May 2011 22:58:50 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: INFO: suspicious rcu_dereference_check() usage.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

seems this is just info, but probably should post this so you guys are 
aware..:



[ 1308.117068]
[ 1308.117072] ===================================================
[ 1308.117080] [ INFO: suspicious rcu_dereference_check() usage. ]
[ 1308.117085] ---------------------------------------------------
[ 1308.117091] kernel/sched_rt.c:1266 invoked rcu_dereference_check() 
without protection!
[ 1308.117096]
[ 1308.117097] other info that might help us debug this:
[ 1308.117099]
[ 1308.117104]
[ 1308.117106] rcu_scheduler_active = 1, debug_locks = 1
[ 1308.117112] 1 lock held by watchdog/1/16:
[ 1308.117116]  #0:  (&rq->lock){-.-.-.}, at: [<ffffffff8103dac0>] 
post_schedule.part.25+0x14/0x4a
[ 1308.117137]
[ 1308.117139] stack backtrace:
[ 1308.117146] Pid: 16, comm: watchdog/1 Not tainted 
2.6.39-04906-g5e152b4-dirty #2
[ 1308.117151] Call Trace:
[ 1308.117163]  [<ffffffff81079f6f>] lockdep_rcu_dereference+0x9a/0xa2
[ 1308.117172]  [<ffffffff8103d256>] find_lowest_rq+0xfe/0x179
[ 1308.117182]  [<ffffffff81043f64>] push_rt_task.part.60+0x7b/0x1c8
[ 1308.117190]  [<ffffffff810441bc>] post_schedule_rt+0x20/0x28
[ 1308.117198]  [<ffffffff8103dadc>] post_schedule.part.25+0x30/0x4a
[ 1308.117209]  [<ffffffff8148cce5>] schedule+0x725/0x773
[ 1308.117217]  [<ffffffff810a3864>] ? watchdog_enable+0x198/0x198
[ 1308.117226]  [<ffffffff8106e4b8>] ? cpu_clock+0x47/0x51
[ 1308.117234]  [<ffffffff810a3864>] ? watchdog_enable+0x198/0x198
[ 1308.117241]  [<ffffffff810a38d1>] watchdog+0x6d/0xb0
[ 1308.117249]  [<ffffffff8106877d>] kthread+0xa8/0xb0
[ 1308.117259]  [<ffffffff81496e64>] kernel_thread_helper+0x4/0x10
[ 1308.117268]  [<ffffffff8148f594>] ? retint_restore_args+0x13/0x13
[ 1308.117276]  [<ffffffff810686d5>] ? __init_kthread_worker+0x5a/0x5a
[ 1308.117283]  [<ffffffff81496e60>] ? gs_change+0x13/0x13
[ 1308.117675]
[ 1308.117678] ===================================================
[ 1308.117685] [ INFO: suspicious rcu_dereference_check() usage. ]
[ 1308.117690] ---------------------------------------------------
[ 1308.117695] kernel/sched.c:619 invoked rcu_dereference_check() 
without protection!
[ 1308.117700]
[ 1308.117701] other info that might help us debug this:
[ 1308.117704]
[ 1308.117708]
[ 1308.117710] rcu_scheduler_active = 1, debug_locks = 1
[ 1308.117715] 2 locks held by rcuc0/7:
[ 1308.117719]  #0:  (&rq->lock){-.-.-.}, at: [<ffffffff8148c6a1>] 
schedule+0xe1/0x773
[ 1308.117736]  #1:  (&rq->lock/1){..-.-.}, at: [<ffffffff8103f13e>] 
double_lock_balance+0x6c/0x78
[ 1308.117753]
[ 1308.117755] stack backtrace:
[ 1308.117761] Pid: 7, comm: rcuc0 Not tainted 
2.6.39-04906-g5e152b4-dirty #2
[ 1308.117766] Call Trace:
[ 1308.117776]  [<ffffffff81079f6f>] lockdep_rcu_dereference+0x9a/0xa2
[ 1308.117784]  [<ffffffff8103ca8e>] task_group+0x7f/0xbe
[ 1308.117792]  [<ffffffff8103cae4>] set_task_rq+0x17/0x70
[ 1308.117800]  [<ffffffff81043c8d>] set_task_cpu+0xf7/0x14c
[ 1308.117810]  [<ffffffff81217099>] ? plist_check_head+0x9a/0x9e
[ 1308.117818]  [<ffffffff812171cf>] ? plist_del+0x70/0x79
[ 1308.117825]  [<ffffffff8103e8b4>] ? dequeue_task_rt+0x38/0x3d
[ 1308.117833]  [<ffffffff8103eb5c>] ? dequeue_task+0x87/0x8e
[ 1308.117841]  [<ffffffff81043df7>] pull_rt_task+0x115/0x169
[ 1308.117849]  [<ffffffff81043ee7>] pre_schedule_rt+0x1e/0x20
[ 1308.117857]  [<ffffffff8148c889>] schedule+0x2c9/0x773
[ 1308.117865]  [<ffffffff81068e22>] ? prepare_to_wait+0x6c/0x78
[ 1308.117875]  [<ffffffff810a998a>] rcu_cpu_kthread+0xeb/0x34d
[ 1308.117883]  [<ffffffff81068ef8>] ? __init_waitqueue_head+0x4b/0x4b
[ 1308.117892]  [<ffffffff810a989f>] ? rcu_needs_cpu+0x1bd/0x1bd
[ 1308.117899]  [<ffffffff8106877d>] kthread+0xa8/0xb0
[ 1308.117908]  [<ffffffff81496e64>] kernel_thread_helper+0x4/0x10
[ 1308.117916]  [<ffffffff8148f594>] ? retint_restore_args+0x13/0x13
[ 1308.117924]  [<ffffffff810686d5>] ? __init_kthread_worker+0x5a/0x5a
[ 1308.117933]  [<ffffffff81496e60>] ? gs_change+0x13/0x13


full dmesg is here:
http://fpaste.org/IqRy/

Justin P. Mattock
