Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966219Ab0CPNbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 09:31:24 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54333 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965058Ab0CPNbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 09:31:22 -0400
Date: Tue, 16 Mar 2010 06:31:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] rcu: fix lockdep for tracepoint
Message-ID: <20100316133115.GE6709@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4B9F48AD.4000404@cn.fujitsu.com> <20100316130814.GA32375@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100316130814.GA32375@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 09:08:14AM -0400, Mathieu Desnoyers wrote:
> * Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> > tracepoint.h use rcu_dereference(), it triggers this warning:
> > 
> > [    0.701161] ===================================================
> > [    0.702211] [ INFO: suspicious rcu_dereference_check() usage. ]
> > [    0.702716] ---------------------------------------------------
> > [    0.703203] include/trace/events/workqueue.h:68 invoked rcu_dereference_check() without protection!
> > [    0.703971]
> > [    0.703990] other info that might help us debug this:
> > [    0.703993]
> > [    0.705590]
> > [    0.705604] rcu_scheduler_active = 1, debug_locks = 0
> > [    0.706712] 1 lock held by swapper/1:
> > [    0.707229]  #0:  (cpu_add_remove_lock){+.+.+.}, at: [<c0142f54>] cpu_maps_update_begin+0x14/0x20
> > [    0.710097]
> > [    0.710106] stack backtrace:
> > [    0.712602] Pid: 1, comm: swapper Not tainted 2.6.34-rc1-tip-01613-g72662bb #168
> > [    0.713231] Call Trace:
> > [    0.713997]  [<c017174d>] lockdep_rcu_dereference+0x9d/0xb0
> > [    0.714746]  [<c015a117>] create_workqueue_thread+0x107/0x110
> > [    0.715353]  [<c015aee0>] ? worker_thread+0x0/0x340
> > [    0.715845]  [<c015a8e8>] __create_workqueue_key+0x138/0x240
> > [    0.716427]  [<c0142f92>] ? cpu_maps_update_done+0x12/0x20
> > [    0.717012]  [<c086b12f>] init_workqueues+0x6f/0x80
> > [    0.717530]  [<c08576d2>] kernel_init+0x102/0x1f0
> > [    0.717570]  [<c08575d0>] ? kernel_init+0x0/0x1f0
> > [    0.718944]  [<c01030fa>] kernel_thread_helper+0x6/0x10
> > 
> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> 
> Thanks Lai,

Me too!

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Mathieu
> 
> > ---
> > diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> > index f59604e..78b4bd3 100644
> > --- a/include/linux/tracepoint.h
> > +++ b/include/linux/tracepoint.h
> > @@ -49,7 +49,7 @@ struct tracepoint {
> >  		void **it_func;						\
> >  									\
> >  		rcu_read_lock_sched_notrace();				\
> > -		it_func = rcu_dereference((tp)->funcs);			\
> > +		it_func = rcu_dereference_sched((tp)->funcs);		\
> >  		if (it_func) {						\
> >  			do {						\
> >  				((void(*)(proto))(*it_func))(args);	\
> > 
> 
> -- 
> Mathieu Desnoyers
> Operating System Efficiency Consultant
> EfficiOS Inc.
> http://www.efficios.com
