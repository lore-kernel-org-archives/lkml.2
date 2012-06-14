Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357Ab2FNPqN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 11:46:13 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:48750 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000Ab2FNPqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 11:46:12 -0400
Date: Thu, 14 Jun 2012 08:45:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 2/5] smpboot: Provide infrastructure for percpu
 hotplug threads
Message-ID: <20120614154556.GD2458@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120613185748.GF2427@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1206132101440.3086@ionos>
 <20120613191745.GG2427@linux.vnet.ibm.com>
 <20120613204725.GA9858@linux.vnet.ibm.com>
 <20120614045125.GA30257@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1206141234400.3086@ionos>
 <20120614125939.GC2443@linux.vnet.ibm.com>
 <1339678887.2559.30.camel@twins>
 <20120614144734.GA2458@linux.vnet.ibm.com>
 <1339685789.2559.37.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339685789.2559.37.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061415-4242-0000-0000-000001F7CB7C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 04:56:29PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-06-14 at 07:47 -0700, Paul E. McKenney wrote:
> > RCU callback processing consumes the entire CPU in RCU_BOOST case where
> > processing runs at real-time priority.  This is analogous to RT throttling
> > in the scheduler. 
> 
> But previously we can in non-preemptible softirq context, why would if
> behave differently when done from a RT task?

In -rt, yes, but in mainline, ksoftirqd does not run at RT prio, right?

> Also, no its not quite like the throttling, that really idles the cpu
> even if there's no SCHED_OTHER tasks to run.

Agreed, not -exactly- like throttling, but it has a broadly similar
goal, namely to prevent a given type of processing from starving
everything else in the system.

That said, why does throttling idle the CPU even if there is no other
SCHED_OTHER tasks to run?

							Thanx, Paul

