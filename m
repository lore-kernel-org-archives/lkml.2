Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641Ab1IMUvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 16:51:07 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:45882 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932446Ab1IMUvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 16:51:04 -0400
Date: Tue, 13 Sep 2011 13:50:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 44/55] rcu: wire up RCU_BOOST_PRIO for
 rcutree
Message-ID: <20110913205055.GF3301@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110906180015.GA2560@linux.vnet.ibm.com>
 <1315332049-2604-44-git-send-email-paulmck@linux.vnet.ibm.com>
 <1315915334.6300.15.camel@marge.simson.net>
 <20110913153413.GB2416@linux.vnet.ibm.com>
 <1315929858.6312.16.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315929858.6312.16.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 06:04:18PM +0200, Mike Galbraith wrote:
> On Tue, 2011-09-13 at 08:34 -0700, Paul E. McKenney wrote:
> > On Tue, Sep 13, 2011 at 02:02:14PM +0200, Mike Galbraith wrote:
> 
> > > @@ -1608,7 +1618,7 @@ static int rcu_node_kthread(void *arg)
> > >  				continue;
> > >  			}
> > >  			per_cpu(rcu_cpu_has_work, cpu) = 1;
> > > -			sp.sched_priority = RCU_KTHREAD_PRIO;
> > > +			sp.sched_priority = current->rt_priority;
> > 
> > This is broken -- the per-node kthread runs at RT prio 99, but we usually
> > would not want to boost that high.
> 
> Ouch, right.  My userland sets things on boot, so it works.

;-)

> > Seems like we should have a global variable that tracks the current
> > priority.  This global variable could then be set in a manner similar
> > to the softirq priorities -- or, perhaps better, simply set whenever
> > the softirq priority is changed.
> > 
> > Thoughts?
> 
> RCU threads would have to constantly watch for user priority changes on
> their own, and update private data methinks.

I believe that we are going to need some sort of -rt-specific handling
of the RCU boost priority in the short term.  Though maybe I could think
about getting runtime modification into mainline as well -- but it would
be different that -rt for a bit.

							Thanx, Paul
