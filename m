Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab0FHATi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 20:19:38 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:58029 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab0FHATf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 20:19:35 -0400
Date: Mon, 7 Jun 2010 17:19:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Eric Paris <eparis@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, nauman@google.com,
       eric.dumazet@gmail.com, netdev@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: 2.6.35-rc2-git1 - include/linux/cgroup.h:534 invoked
 rcu_dereference_check() without protection!
Message-ID: <20100608001929.GF2387@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <AANLkTin2pPqOUx--9fIX3BH3e-cU6oCRufijcx_4ozx5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin2pPqOUx--9fIX3BH3e-cU6oCRufijcx_4ozx5@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 02:14:25PM -0400, Miles Lane wrote:
> Hi All,
> 
> I just reproduced a warning I reported quite a while ago.  Is a patch
> for this in the pipeline?

I proposed a patch, thinking that it was a false positive.  Peter Zijlstra
pointed out that there was a real race, and proposed an alternative patch,
which may be found at http://lkml.org/lkml/2010/4/22/603.

Could you please test Peter's patch and let us know if it cures the problem?

							Thanx, Paul

> [    0.167267] [ INFO: suspicious rcu_dereference_check() usage. ]
> [    0.167396] ---------------------------------------------------
> [    0.167526] include/linux/cgroup.h:534 invoked
> rcu_dereference_check() without protection!
> [    0.167728]
> [    0.167729] other info that might help us debug this:
> [    0.167731]
> [    0.168092]
> [    0.168093] rcu_scheduler_active = 1, debug_locks = 1
> [    0.168337] no locks held by watchdog/0/5.
> [    0.168462]
> [    0.168463] stack backtrace:
> [    0.168704] Pid: 5, comm: watchdog/0 Not tainted 2.6.35-rc2-git1 #8
> [    0.168834] Call Trace:
> [    0.168965]  [<ffffffff81064e9c>] lockdep_rcu_dereference+0x9d/0xa5
> [    0.169100]  [<ffffffff8102c1ce>] task_subsys_state+0x59/0x70
> [    0.169232]  [<ffffffff8103189b>] __sched_setscheduler+0x19d/0x2f8
> [    0.169365]  [<ffffffff8102a5ef>] ? need_resched+0x1e/0x28
> [    0.169497]  [<ffffffff813c7d01>] ? schedule+0x586/0x619
> [    0.169628]  [<ffffffff81081c33>] ? watchdog+0x0/0x8c
> [    0.169758]  [<ffffffff81031a11>] sched_setscheduler+0xe/0x10
> [    0.169889]  [<ffffffff81081c5d>] watchdog+0x2a/0x8c
> [    0.170010]  [<ffffffff81081c33>] ? watchdog+0x0/0x8c
> [    0.170141]  [<ffffffff81054a82>] kthread+0x89/0x91
> [    0.170274]  [<ffffffff81003054>] kernel_thread_helper+0x4/0x10
> [    0.170405]  [<ffffffff813ca480>] ? restore_args+0x0/0x30
> [    0.170536]  [<ffffffff810549f9>] ? kthread+0x0/0x91
> [    0.170667]  [<ffffffff81003050>] ? kernel_thread_helper+0x0/0x10
> [    0.176751] lockdep: fixing up alternatives.
