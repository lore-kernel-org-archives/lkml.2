Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab0DTBZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 21:25:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995Ab0DTBZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 21:25:38 -0400
Subject: Re: INFO: suspicious rcu_dereference_check() usage -
 include/linux/cgroup.h:492 invoked rcu_dereference_check() without
 protection!
From: Eric Paris <eparis@redhat.com>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, Eric Paris <eparis@parisplace.org>,
       Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100419230136.GA16856@linux.vnet.ibm.com>
References: <a44ae5cd1003071726u1f94336h7ab6c7b80d16723b@mail.gmail.com>
	 <20100311032843.GE6767@linux.vnet.ibm.com>
	 <q2x7e0fb38c1004121144rb097e521hd2a7d8cea77c54b7@mail.gmail.com>
	 <1271098032.4807.137.camel@twins> <1271242058.32749.19.camel@laptop>
	 <1271701612.2972.5.camel@dhcp231-113.rdu.redhat.com>
	 <20100419230136.GA16856@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 21:25:29 -0400
Message-ID: <1271726729.2972.13.camel@dhcp231-113.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-19 at 16:01 -0700, Paul E. McKenney wrote:

> Yep, different code path to the same location.  Does the following
> patch help?
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> commit 2836f18139267ea918ed2cf39023fb0eb38c4361
> Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Date:   Mon Apr 19 15:59:50 2010 -0700
> 
>     rcu: fix RCU lockdep splat on freezer_fork path
>     
>     Add an RCU read-side critical section to suppress this false positive.
>     
>     Located-by: Eric Paris <eparis@parisplace.org>
>     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

That one is also fixed so feel free to add a tested or something from
me.  But we've got another, weeeee!  If there some way I could get all
of these at once?

[    0.045164] ===================================================
[    0.047002] [ INFO: suspicious rcu_dereference_check() usage. ]
[    0.048002] ---------------------------------------------------
[    0.049012] include/linux/cgroup.h:533 invoked rcu_dereference_check() without protection!
[    0.051087] 
[    0.051088] other info that might help us debug this:
[    0.051088] 
[    0.057011] 
[    0.057011] rcu_scheduler_active = 1, debug_locks = 0
[    0.059046] no locks held by watchdog/0/5.
[    0.060002] 
[    0.060003] stack backtrace:
[    0.061003] Pid: 5, comm: watchdog/0 Not tainted 2.6.34-rc4-next-20100415+ #104
[    0.063011] Call Trace:
[    0.063654]  [<ffffffff8108652f>] lockdep_rcu_dereference+0xaf/0xc0
[    0.065009]  [<ffffffff810b53f0>] ? watchdog+0x0/0xa0
[    0.066006]  [<ffffffff8104d01b>] __sched_setscheduler+0x3ab/0x430
[    0.067005]  [<ffffffff810b53f0>] ? watchdog+0x0/0xa0
[    0.068004]  [<ffffffff8104d0be>] sched_setscheduler+0xe/0x10
[    0.070009]  [<ffffffff810b541a>] watchdog+0x2a/0xa0
[    0.071004]  [<ffffffff810b53f0>] ? watchdog+0x0/0xa0
[    0.072007]  [<ffffffff810714ec>] kthread+0xac/0xc0
[    0.073005]  [<ffffffff81087ff0>] ? trace_hardirqs_on_caller+0xc0/0x240
[    0.074006]  [<ffffffff8100bc24>] kernel_thread_helper+0x4/0x10
[    0.075005]  [<ffffffff814fee54>] ? restore_args+0x0/0x30
[    0.076004]  [<ffffffff81071440>] ? kthread+0x0/0xc0
[    0.077004]  [<ffffffff8100bc20>] ? kernel_thread_helper+0x0/0x10



