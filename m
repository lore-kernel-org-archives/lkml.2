Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab0HIQbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 12:31:11 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46909 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597Ab0HIQbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 12:31:02 -0400
Date: Mon, 9 Aug 2010 09:30:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.35-rc3-git8 - include/linux/fdtable.h:88 invoked
 rcu_dereference_check() without protection!
Message-ID: <20100809163044.GD3026@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <AANLkTinof0k28rk4rMr66aubxcRL2rFa5ZEArj1lqD3o@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinof0k28rk4rMr66aubxcRL2rFa5ZEArj1lqD3o@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 04, 2010 at 06:04:20PM -0400, Miles Lane wrote:
> [ 1619.938226] [ INFO: suspicious rcu_dereference_check() usage. ]
> [ 1619.938230] ---------------------------------------------------
> [ 1619.938235] include/linux/fdtable.h:88 invoked
> rcu_dereference_check() without protection!
> [ 1619.938239]
> [ 1619.938240] other info that might help us debug this:
> [ 1619.938242]
> [ 1619.938245]
> [ 1619.938246] rcu_scheduler_active = 1, debug_locks = 1
> [ 1619.938250] no locks held by dbus-daemon/4254.
> [ 1619.938253]
> [ 1619.938254] stack backtrace:
> [ 1619.938260] Pid: 4254, comm: dbus-daemon Not tainted 2.6.35-rc3-git8 #5
> [ 1619.938264] Call Trace:
> [ 1619.938277]  [<ffffffff8106756a>] lockdep_rcu_dereference+0x9d/0xa6
> [ 1619.938286]  [<ffffffff810cae92>] fcheck_files+0xb1/0xca
> [ 1619.938292]  [<ffffffff810caf03>] fget_light+0x35/0x96
> [ 1619.938300]  [<ffffffff810d8d5e>] do_sys_poll+0x1ff/0x3e5
> [ 1619.938307]  [<ffffffff810d8572>] ? __pollwait+0x0/0xc7
> [ 1619.938314]  [<ffffffff810d8639>] ? pollwake+0x0/0x4f
> [ 1619.938320]  [<ffffffff810d8639>] ? pollwake+0x0/0x4f
> [ 1619.938327]  [<ffffffff810d8639>] ? pollwake+0x0/0x4f
> [ 1619.938333]  [<ffffffff810d8639>] ? pollwake+0x0/0x4f
> [ 1619.938340]  [<ffffffff810d8639>] ? pollwake+0x0/0x4f
> [ 1619.938346]  [<ffffffff810d8639>] ? pollwake+0x0/0x4f
> [ 1619.938353]  [<ffffffff810d8639>] ? pollwake+0x0/0x4f
> [ 1619.938359]  [<ffffffff810d8639>] ? pollwake+0x0/0x4f
> [ 1619.938365]  [<ffffffff810d8639>] ? pollwake+0x0/0x4f
> [ 1619.938374]  [<ffffffff810d90d8>] sys_poll+0x50/0xba
> [ 1619.938383]  [<ffffffff81009c82>] system_call_fastpath+0x16/0x1b

Hello, Miles!

Thank you again for your continued testing!

I believe that this one has been fixed by commit 844b9a8707f, which was
added in v2.6.35-rc6.  This commit added rcu_my_thread_group_empty()
to the list of rcu_dereference_check() conditions in the
rcu_dereference_check_fdtable() macro.

							Thanx, Paul
