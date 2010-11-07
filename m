Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab0KGSrP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 13:47:15 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:48767 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab0KGSrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 13:47:14 -0500
Date: Sun, 7 Nov 2010 10:47:11 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.36-git11 -- kernel/pid.c:419 invoked
 rcu_dereference_check() without protection!
Message-ID: <20101107184711.GB15561@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <AANLkTimGgzOZb8EwUQO16cZcL+ycveKTYzg_AAX+D+Kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimGgzOZb8EwUQO16cZcL+ycveKTYzg_AAX+D+Kw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 01:22:28AM -0400, Miles Lane wrote:
> [ INFO: suspicious rcu_dereference_check() usage. ]
> ---------------------------------------------------
> kernel/pid.c:419 invoked rcu_dereference_check() without protection!
> 
> other info that might help us debug this:
> 
> 
> rcu_scheduler_active = 1, debug_locks = 1
> 1 lock held by ureadahead/943:
>  #0:  (tasklist_lock){.+.+..}, at: [<ffffffff810ec497>]
> sys_ioprio_set+0x8e/0x2aa
> 
> stack backtrace:
> Pid: 943, comm: ureadahead Not tainted 2.6.36-git11 #8
> Call Trace:
>  [<ffffffff8105d335>] lockdep_rcu_dereference+0x9d/0xa5
>  [<ffffffff8104c825>] find_task_by_pid_ns+0x3f/0x58
>  [<ffffffff8104c85b>] find_task_by_vpid+0x1d/0x1f
>  [<ffffffff810ec4c6>] sys_ioprio_set+0xbd/0x2aa
>  [<ffffffff813547a3>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff81002aab>] system_call_fastpath+0x16/0x1b

Could you please try the patch from Sergey Senozhatsky, currently
in -mm, that may be found at http://lkml.org/lkml/2010/10/29/168?

							Thanx, Paul
