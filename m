Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215Ab1FIAD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 20:03:58 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:42237 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862Ab1FIAD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 20:03:57 -0400
Date: Wed, 8 Jun 2011 17:03:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, patches@linaro.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH tip/core/rcu 07/28] Fix mismatched variable in
 rcutree_trace.c
Message-ID: <20110609000348.GQ2324@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110608192943.GA13211@linux.vnet.ibm.com>
 <1307561407-13809-7-git-send-email-paulmck@linux.vnet.ibm.com>
 <BLU0-SMTP181D8DEE03E1353C8A106396620@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BLU0-SMTP181D8DEE03E1353C8A106396620@phx.gbl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 07:23:29PM -0400, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > rcutree.c defines rcu_cpu_kthread_cpu as int, not unsigned int,
> > so the extern has to follow that.
> 
> How comes this discrepancy was made possible in the first place ? This
> declaration should appear in a header included by both rcutree_trace.c
> and rcutree.c, which would have permitted the compiler to detect this.
> 
> Maybe kernel/rcutree.h would be a good location for these ?

I vaguely recall a time where this didn't work, but will give it
another try.  It would certainly be nicer if the compiler checked
for these sorts of mismatches!

							Thanx, Paul

> Mathieu
> 
> > 
> > Cc: paulmck@linux.vnet.ibm.com
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcutree_trace.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
> > index 9678cc3..91c56e5 100644
> > --- a/kernel/rcutree_trace.c
> > +++ b/kernel/rcutree_trace.c
> > @@ -47,7 +47,7 @@
> >  #include "rcutree.h"
> >  
> >  DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
> > -DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_cpu);
> > +DECLARE_PER_CPU(int, rcu_cpu_kthread_cpu);
> >  DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
> >  DECLARE_PER_CPU(char, rcu_cpu_has_work);
> >  
> > -- 
> > 1.7.3.2
> > 
> 
> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com
