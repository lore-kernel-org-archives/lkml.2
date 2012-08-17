Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169Ab2HQOqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:46:14 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:43267 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359Ab2HQOqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:46:00 -0400
Date: Fri, 17 Aug 2012 07:44:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org
Subject: Re: lockdep warning on rt_mutex_lock()
Message-ID: <20120817144437.GC2872@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120817100635.GA30765@localhost>
 <20120817134328.GB2872@linux.vnet.ibm.com>
 <20120817140240.GB539@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120817140240.GB539@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081714-8974-0000-0000-00000C4CBB2A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 10:02:40PM +0800, Fengguang Wu wrote:
> On Fri, Aug 17, 2012 at 06:43:28AM -0700, Paul E. McKenney wrote:
> > On Fri, Aug 17, 2012 at 06:06:35PM +0800, Fengguang Wu wrote:
> > > Greetings,
> > > 
> > > FYI, a lockdep warning:
> > 
> > Certainly looks problematic!
> > 
> > Any hint as to what version of the kernel produced this splat?
> > (Yes, lazy of me to ask, I know, but I am not seeing it in my testing.)
> 
> It happens on both 3.5.0 and 3.6-rc1. Will bisect (try older kernels) help?
> Bisect is handy for me :)

Bisection would be very welcome!!!  ;-)

> Sorry the back trace in the original email only happens in _one_ test box.
> That makes it hard to reproduce..
> 
> The more common test boxes see these traces (with different config).
> I'll send full config/dmesg for the first one in another email.

Ah, I see part of my difficulty earlier -- I was looking at TREE_PREEMPT_RCU
rather than the TINY_PREEMPT_RCU you are actually running here.

							Thanx, Paul

> [   24.647556] init: Temporary process spawn error: No such file or directory
> [   24.806072] ------------[ cut here ]------------
> [   24.807042] WARNING: at /c/kernel-tests/src/linux/kernel/lockdep.c:3493 check_flags+0x113/0x2a7()
> [   24.807042] Hardware name: Bochs
> [   24.807042] Pid: 8, comm: rcu_kthread Not tainted 3.6.0-rc1-00011-gf8cdda8 #2
> [   24.807042] Call Trace:
> [   24.807042]  [<ffffffff81089d10>] ? up+0x50/0x5c
> [   24.807042]  [<ffffffff8105cc87>] warn_slowpath_common+0xb3/0xe1
> [   24.807042]  [<ffffffff8105cdb7>] warn_slowpath_null+0x23/0x2c
> [   24.807042]  [<ffffffff810aabdb>] check_flags+0x113/0x2a7
> [   24.807042]  [<ffffffff810ac9f9>] lock_is_held+0x4b/0xe4
> [   24.807042]  [<ffffffff810918fd>] __might_sleep+0x4e/0x277
> [   24.807042]  [<ffffffff8199fa1d>] rt_mutex_lock+0x23/0x54
> [   24.807042]  [<ffffffff810d9c89>] rcu_boost+0xeb/0x140
> [   24.807042]  [<ffffffff819a06e7>] ? _raw_spin_unlock_irqrestore+0x78/0xeb
> [   24.807042]  [<ffffffff81082a0c>] ? spin_unlock_irqrestore+0x10/0x19
> [   24.807042]  [<ffffffff81082d75>] ? finish_wait+0x8f/0x9f
> [   24.807042]  [<ffffffff810da3fc>] rcu_kthread+0xf2/0x1f0
> [   24.807042]  [<ffffffff81082e3c>] ? abort_exclusive_wait+0xb7/0xb7
> [   24.807042]  [<ffffffff810da30a>] ? __rcu_process_callbacks+0x1b4/0x1b4
> [   24.807042]  [<ffffffff81082032>] kthread+0x95/0xa4
> [   24.807042]  [<ffffffff819a33c4>] kernel_thread_helper+0x4/0x10
> [   24.807042]  [<ffffffff819a1bb0>] ? retint_restore_args+0x13/0x13
> [   24.807042]  [<ffffffff81081f9d>] ? freezing+0x2c/0x2c
> [   24.807042]  [<ffffffff819a33c0>] ? gs_change+0x13/0x13
> 
> [   22.951027] [sched_delayed] sched: RT throttling activated
> [   34.752102] ------------[ cut here ]------------
> [   34.753023] WARNING: at /c/kernel-tests/src/tip/kernel/lockdep.c:3493 check_flags+0xc1/0x1d0()
> [   34.753023] Pid: 6, comm: rcu_kthread Not tainted 3.5.0-03701-g899852a #1
> [   34.753023] Call Trace:
> [   34.753023]  [<ffffffff8107a311>] ? check_flags+0xc1/0x1d0
> [   34.753023]  [<ffffffff8103a906>] warn_slowpath_common+0x66/0x90
> [   34.753023]  [<ffffffff8103aa05>] warn_slowpath_null+0x15/0x20
> [   34.753023]  [<ffffffff8107a311>] check_flags+0xc1/0x1d0
> [   34.753023]  [<ffffffff8107d983>] lock_acquire+0x63/0xe0
> [   34.753023]  [<ffffffff810688f6>] ? update_curr_rt+0xd6/0x190
> [   34.753023]  [<ffffffff8164963b>] _raw_spin_lock+0x3b/0x50
> [   34.753023]  [<ffffffff81648cf8>] ? rt_mutex_slowlock+0x38/0x150
> [   34.753023]  [<ffffffff81648cf8>] rt_mutex_slowlock+0x38/0x150
> [   34.753023]  [<ffffffff81266d58>] ? __raw_spin_lock_init+0x38/0x70
> [   34.753023]  [<ffffffff81648e38>] rt_mutex_lock+0x28/0x30
> [   34.753023]  [<ffffffff8109b1e6>] rcu_boost+0x76/0xf0
> [   34.753023]  [<ffffffff8109b405>] rcu_kthread+0xa5/0x140
> [   34.753023]  [<ffffffff8105a160>] ? abort_exclusive_wait+0xa0/0xa0
> [   34.753023]  [<ffffffff8109b360>] ? __rcu_process_callbacks+0x100/0x100
> [   34.753023]  [<ffffffff8105964d>] kthread+0x8d/0xa0
> [   34.753023]  [<ffffffff8164ba04>] kernel_thread_helper+0x4/0x10
> [   34.753023]  [<ffffffff8164a330>] ? retint_restore_args+0x13/0x13
> [   34.753023]  [<ffffffff810595c0>] ? kthread_flush_work_fn+0x10/0x10
> [   34.753023]  [<ffffffff8164ba00>] ? gs_change+0x13/0x13
> 
> [   11.635806] HugeTLB registered 4 MB page size, pre-allocated 0 pages
> [   12.105729] ------------[ cut here ]------------
> [   12.105729] WARNING: at /c/kernel-tests/src/i386/kernel/lockdep.c:3493 check_flags+0xaa/0x190()
> [   12.105729] Hardware name: Bochs
> [   12.105729] Pid: 6, comm: rcu_kthread Not tainted 3.5.0-rc5+ #30
> [   12.105729] Call Trace:
> [   12.105729]  [<c102773a>] warn_slowpath_common+0x7a/0xa0
> [   12.105729]  [<c10646ca>] ? check_flags+0xaa/0x190
> [   12.105729]  [<c10646ca>] ? check_flags+0xaa/0x190
> [   12.105729]  [<c10277fd>] warn_slowpath_null+0x1d/0x20
> [   12.105729]  [<c10646ca>] check_flags+0xaa/0x190
> [   12.105729]  [<c1067b3c>] lock_acquire+0x3c/0xb0
> [   12.105729]  [<c1007668>] ? sched_clock+0x8/0x10
> [   12.105729]  [<c104ecf5>] ? sched_clock_local.constprop.2+0x15/0x150
> [   12.105729]  [<c14c9a20>] _raw_spin_lock+0x40/0x70
> [   12.105729]  [<c14c9296>] ? rt_mutex_slowlock+0x26/0x130
> [   12.105729]  [<c14c9296>] rt_mutex_slowlock+0x26/0x130
> [   12.105729]  [<c1068837>] ? debug_check_no_locks_freed+0x127/0x160
> [   12.105729]  [<c1062f9d>] ? put_lock_stats.isra.19+0xd/0x30
> [   12.105729]  [<c14c93b9>] rt_mutex_lock+0x19/0x20
> [   12.105729]  [<c107eeac>] rcu_kthread+0x10c/0x1c0
> [   12.105729]  [<c14c8cff>] ? preempt_schedule+0x2f/0x50
> [   12.105729]  [<c104d169>] ? complete+0x49/0x60
> [   12.105729]  [<c107eda0>] ? __rcu_process_callbacks+0x110/0x110
> [   12.105729]  [<c1042cc7>] kthread+0x67/0x70
> [   12.105729]  [<c1042c60>] ? kthread_flush_work_fn+0x10/0x10
> [   12.105729]  [<c14cb33a>] kernel_thread_helper+0x6/0xd
> 
> Thanks,
> Fengguang
> 

