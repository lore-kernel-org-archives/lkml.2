Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab2FNQUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:20:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:58860 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403Ab2FNQUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:20:42 -0400
Date: Thu, 14 Jun 2012 18:20:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 2/5] smpboot: Provide infrastructure for percpu
 hotplug threads
In-Reply-To: <20120614154556.GD2458@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.02.1206141820181.3086@ionos>
References: <20120613185748.GF2427@linux.vnet.ibm.com> <alpine.LFD.2.02.1206132101440.3086@ionos> <20120613191745.GG2427@linux.vnet.ibm.com> <20120613204725.GA9858@linux.vnet.ibm.com> <20120614045125.GA30257@linux.vnet.ibm.com> <alpine.LFD.2.02.1206141234400.3086@ionos>
 <20120614125939.GC2443@linux.vnet.ibm.com> <1339678887.2559.30.camel@twins> <20120614144734.GA2458@linux.vnet.ibm.com> <1339685789.2559.37.camel@twins> <20120614154556.GD2458@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2012, Paul E. McKenney wrote:

> On Thu, Jun 14, 2012 at 04:56:29PM +0200, Peter Zijlstra wrote:
> > On Thu, 2012-06-14 at 07:47 -0700, Paul E. McKenney wrote:
> > > RCU callback processing consumes the entire CPU in RCU_BOOST case where
> > > processing runs at real-time priority.  This is analogous to RT throttling
> > > in the scheduler. 
> > 
> > But previously we can in non-preemptible softirq context, why would if
> > behave differently when done from a RT task?
> 
> In -rt, yes, but in mainline, ksoftirqd does not run at RT prio, right?
> 
> > Also, no its not quite like the throttling, that really idles the cpu
> > even if there's no SCHED_OTHER tasks to run.
> 
> Agreed, not -exactly- like throttling, but it has a broadly similar
> goal, namely to prevent a given type of processing from starving
> everything else in the system.
> 
> That said, why does throttling idle the CPU even if there is no other
> SCHED_OTHER tasks to run?

For simplicity reasons :)

Thanks,

	tglx
