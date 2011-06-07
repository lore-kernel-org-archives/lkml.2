Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758990Ab1FGXNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:13:10 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58121 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086Ab1FGXNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:13:08 -0400
Date: Tue, 7 Jun 2011 16:13:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/5] Fix mismatched variable in rcutree_trace.c
Message-ID: <20110607231306.GH2286@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1307485593-27196-1-git-send-email-andi@firstfloor.org>
 <1307485593-27196-2-git-send-email-andi@firstfloor.org>
 <alpine.LFD.2.02.1106080040320.11814@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1106080040320.11814@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 12:42:17AM +0200, Thomas Gleixner wrote:
> 
> 
> On Tue, 7 Jun 2011, Andi Kleen wrote:
> 
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > rcutree.c defines rcu_cpu_kthread_cpu as int, not unsigned int,
> > so the extern has to follow that.
> > 
> > Cc: paulmck@linux.vnet.ibm.com
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
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
> 
> Can we rather fix the DEFINE to use unsigned int. Signed cpu numbers
> are pointless in that context, right ?

Hmmm...  Some arches have signed CPU numbers while others have unsigned
CPU numbers.  I do use "-1" to mean "no CPU" in some cases (for example,
in rcu_node_kthread_setaffinity()), so I guess for consistency I should
be using "int" everywhere.

So, any plans for systems with 2,147,483,648 CPUs?  ;-)

							Thanx, Paul

> >  DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
> >  DECLARE_PER_CPU(char, rcu_cpu_has_work);
> >  
> > -- 
> > 1.7.4.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
