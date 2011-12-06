Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab1LFRSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 12:18:33 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44517 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330Ab1LFRSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 12:18:32 -0500
Date: Tue, 6 Dec 2011 09:16:05 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 7/7] rcu: Quiet RCU-lockdep warnings
 involving interrupt disabling
Message-ID: <20111206171605.GG2325@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1322937282-19846-7-git-send-email-paulmck@linux.vnet.ibm.com>
 <20111205091924.GA28117@zhy>
 <20111205164505.GB2326@linux.vnet.ibm.com>
 <20111206012635.GA32498@zhy>
 <1323165152.32012.51.camel@twins>
 <20111206100537.GA5203@zhy>
 <1323167527.32012.61.camel@twins>
 <1323174405.30977.86.camel@frodo>
 <20111206160455.GC2325@linux.vnet.ibm.com>
 <1323190602.30977.94.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323190602.30977.94.camel@frodo>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11120617-8974-0000-0000-000003F8CE19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 11:56:42AM -0500, Steven Rostedt wrote:
> On Tue, 2011-12-06 at 08:04 -0800, Paul E. McKenney wrote:
> 
> > > Perhaps the real answer is that we need to create an API for priority
> > > inheritance, that things like RCU could use. Attach a task that another
> > > task requires to finish something and boost the priority of that task.
> > > Maybe even completions could use such a thing?
> > 
> > I would be OK with that -- that was in fact the approach I was taking
> > when I was advised to use mutexes instead.  ;-)
> 
> Maybe we should rethink it. Using the makeshift mutex looks to be a
> short term hack. But if we are starting to build on it, it will end up
> being a horrible design, based off of a hack.
> 
> A mutex is to provide mutual exclusion. If we start bastardizing it to
> do other things, it will become unmaintainable. I dare say that it's
> close to unmaintainable now ;)
> 
> If we create a new API to handle inheritance, then perhaps it could be
> used for other things like workqueues and completions (in -rt only).

Tough choice between yours and Peter's suggestion...

1.	Re-introduce ugly races by eliminating the mutex.

2.	Possibly have to deal with a new spate of lockdep-RCU splats.

Decisions, decisions!  ;-)

I suppose that one approach is to start with Peter's approach,
possibly adapting lockdep to explicitly check -- with an exception for
srcu_read_lock_raw(), of course.  If lockdep-RCU splats rain down too
hard, then perhaps the explicit priority inheritance would be one
potential umbrella.

Thoughts?

							Thanx, Paul

