Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab2C0QlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 12:41:25 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:41578 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796Ab2C0QlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 12:41:22 -0400
Date: Tue, 27 Mar 2012 09:39:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH RFC] rcu: Make __rcu_read_lock() inlinable
Message-ID: <20120327163902.GQ2450@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120325205249.GA29528@linux.vnet.ibm.com>
 <1332748484.16159.61.camel@twins>
 <20120326183232.GK2450@linux.vnet.ibm.com>
 <1332787630.16159.182.camel@twins>
 <20120327051515.GO2450@linux.vnet.ibm.com>
 <1332851167.23924.125.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332851167.23924.125.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032716-9360-0000-0000-000004E6CBC7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 08:26:07AM -0400, Steven Rostedt wrote:
> On Mon, 2012-03-26 at 22:15 -0700, Paul E. McKenney wrote:
> 
> > Hmmm...  I am not yet sure whether it is easier to make RCU use legal
> > in switch_to() or to detect it.  I am inclined to take whatever course
> > is easiest, which is likely to make it legal.  :-/
> 
> We could just declare that we do not allow tracepoints in arch specific
> "switch_to" code. Then you shouldn't need to worry about RCU in
> switch_to().

Heh.  I expect that to work about as well as the earlier declaration
that RCU not be used in the idle loop.  ;-)

> sched_rcu can still work there correct? That is, a synchronize_sched()
> should not be affected. As that is needed for the function tracing, and
> that may be called within a switch_to.

Yep, good point.

							Thanx, Paul

