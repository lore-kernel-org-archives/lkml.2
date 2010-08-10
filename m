Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab0HJAeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 20:34:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757814Ab0HJAeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 20:34:03 -0400
Date: Tue, 10 Aug 2010 02:31:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.35 - INFO: kernel/signal.c:660 invoked
	rcu_dereference_check() without protection!
Message-ID: <20100810003121.GA3778@redhat.com>
References: <AANLkTin4RV1uw4vPqRjmM4HDEi8TT3YT5WVZ91a-8AWj@mail.gmail.com> <20100809171329.GF3026@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100809171329.GF3026@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09, Paul E. McKenney wrote:
>
> On Tue, Aug 03, 2010 at 11:18:07PM -0400, Miles Lane wrote:
> > [ INFO: suspicious rcu_dereference_check() usage. ]
> > ---------------------------------------------------
> > kernel/signal.c:660 invoked rcu_dereference_check() without protection!
> >
> > other info that might help us debug this:
> >
> > rcu_scheduler_active = 1, debug_locks = 1
> > 1 lock held by udevd/670:
> >  #0:  (tasklist_lock){.+.+..}, at: [<ffffffff8104628c>] do_exit+0x252/0x671
> >  stack backtrace:
> >  Pid: 670, comm: udevd Not tainted 2.6.35 #15
> >  Call Trace:
> >  [<ffffffff8106759c>] lockdep_rcu_dereference+0x9d/0xa6
> >  [<ffffffff8104f297>] check_kill_permission+0x9d/0x132
> >  [<ffffffff8105010e>] group_send_sig_info+0x1a/0x3d
> >  [<ffffffff81046388>] do_exit+0x34e/0x671
> >  [<ffffffff81046723>] do_group_exit+0x78/0xa3
> >  [<ffffffff81046760>] sys_exit_group+0x12/0x16
> >  [<ffffffff81009c82>] system_call_fastpath+0x16/0x1b
>
> Thank you again for your testing efforts!
>
> This one is a bit odd.  exit_signals() holds either the tasklist_lock
> or the ->sighand->siglock over its signal manipulations, so this is
> not the code path triggering the above.  I might be missing something,
> but I don't see either hrtimer_cancel() or exit_itimers() attempting
> to send signals.

Agreed, this is strange and shouldn't happen.

Perhaps, this kernel lack's David's 694f690d27dadccc8cb9d90532e76593b61fe098
"CRED: Fix RCU warning due to previous patch fixing __task_cred()'s checks"
patch?

Oleg.

