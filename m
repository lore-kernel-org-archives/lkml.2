Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534Ab1LEQzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 11:55:46 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57043 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756195Ab1LEQzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 11:55:45 -0500
Date: Mon, 5 Dec 2011 08:48:36 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 7/7] rcu: Quiet RCU-lockdep warnings
 involving interrupt disabling
Message-ID: <20111205164836.GC2326@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111203183417.GA18914@linux.vnet.ibm.com>
 <1322937282-19846-7-git-send-email-paulmck@linux.vnet.ibm.com>
 <1323078096.32012.14.camel@twins>
 <20111205100346.GA28750@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111205100346.GA28750@zhy>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11120516-9360-0000-0000-0000013F944E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 06:03:46PM +0800, Yong Zhang wrote:
> On Mon, Dec 05, 2011 at 10:41:36AM +0100, Peter Zijlstra wrote:
> > On Sat, 2011-12-03 at 10:34 -0800, Paul E. McKenney wrote:
> > > From: Yong Zhang <yong.zhang0@gmail.com>
> > > 
> > > RCU-lockdep will issue warnings given the following use pattern:
> > > 
> > > 	rcu_read_lock();
> > > 	local_irq_disable();
> > > 	rcu_read_unlock();
> > > 	local_irq_enable();
> > > 
> > > However, this use pattern is legal except for the scheduler's runqueue
> > > and priority-inheritance locks (and any other locks that the scheduler
> > > might use during priority-inheritance operations).
> > 
> > So what does this patch do? Make it not complain when you do the above?
> 
> It suppose to not complain but it bring other complain :(

Again, even with commit #5342e269b applied?

> > How often does this pattern actually happen?
> 
> IIRC, we have just one which is cured by commit [a841796: signal: align
> __lock_task_sighand() irq disabling and RCU]
> 
> > Can't be that often
> > otherwise we'd have had more complaints, no?

Maybe, maybe not.  To see the complaint, you have to have RCU_BOOST=y.
This is used heavily in -rt, but I bet that there are config options that
don't see much use in -rt.

With this one, prevention is better than after-the-fact cure.

							Thanx, Paul

> Yeah,
> 
> So that also means we don't dedicated lock_class_key for mtx.wait_lock.
> 
> Thanks,
> Yong
> 

