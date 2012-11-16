Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab2KPQoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:44:04 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39074 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753025Ab2KPQnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:43:51 -0500
Date: Fri, 16 Nov 2012 08:43:37 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Shan Wei <shanwei88@gmail.com>
Cc: dipankar@in.ibm.com, Kernel-Maillist <linux-kernel@vger.kernel.org>,
        cl@linux-foundation.org, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH v3 6/9] rcu: use __this_cpu_read helper instead of
 per_cpu_ptr(p, raw_smp_processor_id())
Message-ID: <20121116164337.GD3270@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <50A1A7E8.4010802@gmail.com>
 <50A5FA32.4000903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A5FA32.4000903@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111616-5112-0000-0000-00000EA3023E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 04:32:50PM +0800, Shan Wei wrote:
> Shan Wei said, at 2012/11/13 9:52:
> > From: Shan Wei <davidshan@tencent.com>
> > 
> > Signed-off-by: Shan Wei <davidshan@tencent.com>
> > Acked-by: Christoph Lameter <cl@linux.com>
> 
> Paul, would you like to pick it up to your tree?

Hello, Shan Wei,

If you either show me some significant performance benefits or get me
an independent Tested-by, in both cases on a range of hardware (e.g.,
x86 on the one hand and ARM or Power on the other), then I will queue it.

I wasn't prioritizing this one very high because it does not appear
to be on any sort of fastpath.  If I am wrong about that, then you
have a good performance-benefit case, right?  ;-)

							Thanx, Paul

> > ---
> > no changes vs v3,v2.
> > ---
> >  kernel/rcutree.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index 74df86b..441b945 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -1960,7 +1960,7 @@ static void force_quiescent_state(struct rcu_state *rsp)
> >  	struct rcu_node *rnp_old = NULL;
> >  
> >  	/* Funnel through hierarchy to reduce memory contention. */
> > -	rnp = per_cpu_ptr(rsp->rda, raw_smp_processor_id())->mynode;
> > +	rnp = __this_cpu_read(rsp->rda->mynode);
> >  	for (; rnp != NULL; rnp = rnp->parent) {
> >  		ret = (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) ||
> >  		      !raw_spin_trylock(&rnp->fqslock);
> > 
> 

