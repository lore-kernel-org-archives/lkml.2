Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab1IMQEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 12:04:36 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:58987 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755274Ab1IMQEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 12:04:33 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX197E54segF7h9FD1Pqdm9oSX/Pfs8KTfHiLQe8P5y
	nak9ha2/XiSO3e
Subject: Re: [PATCH tip/core/rcu 44/55] rcu: wire up RCU_BOOST_PRIO for
 rcutree
From: Mike Galbraith <efault@gmx.de>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org
In-Reply-To: <20110913153413.GB2416@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
	 <1315332049-2604-44-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1315915334.6300.15.camel@marge.simson.net>
	 <20110913153413.GB2416@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Sep 2011 18:04:18 +0200
Message-ID: <1315929858.6312.16.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-13 at 08:34 -0700, Paul E. McKenney wrote:
> On Tue, Sep 13, 2011 at 02:02:14PM +0200, Mike Galbraith wrote:

> > @@ -1608,7 +1618,7 @@ static int rcu_node_kthread(void *arg)
> >  				continue;
> >  			}
> >  			per_cpu(rcu_cpu_has_work, cpu) = 1;
> > -			sp.sched_priority = RCU_KTHREAD_PRIO;
> > +			sp.sched_priority = current->rt_priority;
> 
> This is broken -- the per-node kthread runs at RT prio 99, but we usually
> would not want to boost that high.

Ouch, right.  My userland sets things on boot, so it works.

> Seems like we should have a global variable that tracks the current
> priority.  This global variable could then be set in a manner similar
> to the softirq priorities -- or, perhaps better, simply set whenever
> the softirq priority is changed.
> 
> Thoughts?

RCU threads would have to constantly watch for user priority changes on
their own, and update private data methinks.

	-Mike

