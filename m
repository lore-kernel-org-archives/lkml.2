Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab1HXWpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 18:45:08 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46888 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab1HXWpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 18:45:06 -0400
Date: Thu, 25 Aug 2011 00:45:00 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Josh Boyer <jwboyer@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: 3.0-git15 Atomic scheduling in pidmap_init
Message-ID: <20110824224454.GB26417@somewhere.redhat.com>
References: <20110815152052.GA2389@linux.vnet.ibm.com>
 <20110817223735.GI2227@zod.bos.redhat.com>
 <20110817224916.GO2419@linux.vnet.ibm.com>
 <20110817230219.GJ2227@zod.bos.redhat.com>
 <20110817230641.GA7837@somewhere.redhat.com>
 <20110817231750.GK2227@zod.bos.redhat.com>
 <20110818183523.GD2325@linux.vnet.ibm.com>
 <20110818140034.668e8dea.akpm@linux-foundation.org>
 <20110818212334.GE2325@linux.vnet.ibm.com>
 <20110818215540.GA14098@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110818215540.GA14098@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 02:55:40PM -0700, Paul E. McKenney wrote:
> On Thu, Aug 18, 2011 at 02:23:34PM -0700, Paul E. McKenney wrote:
> > On Thu, Aug 18, 2011 at 02:00:34PM -0700, Andrew Morton wrote:
> > > On Thu, 18 Aug 2011 11:35:23 -0700
> > > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > > 
> > > > On Wed, Aug 17, 2011 at 07:17:50PM -0400, Josh Boyer wrote:
> > > > > On Thu, Aug 18, 2011 at 01:06:44AM +0200, Frederic Weisbecker wrote:
> > > > > > On Wed, Aug 17, 2011 at 07:02:19PM -0400, Josh Boyer wrote:
> > > > > > > On Wed, Aug 17, 2011 at 03:49:16PM -0700, Paul E. McKenney wrote:
> > > > > > > > On Wed, Aug 17, 2011 at 06:37:35PM -0400, Josh Boyer wrote:
> > > > > > > > > On Mon, Aug 15, 2011 at 08:20:52AM -0700, Paul E. McKenney wrote:
> > > > > > > > > > On Mon, Aug 15, 2011 at 10:04:17AM -0400, Josh Boyer wrote:
> > > > > > > > > > > > Please see the attached.
> > > > > > > > > > > 
> > > > > > > > > > > Fixed it up quickly to apply on top of -rc2 and it seems to solve the
> > > > > > > > > > > problem nicely.  Thanks for the patch.
> > > > > > > > > > 
> > > > > > > > > > Good to hear!  I guess I should keep it, then.  ;-)
> > > > > > > > > 
> > > > > > > > > Hey Paul, were you going to send this to Linus for -rc3?  I haven't seen
> > > > > > > > > it come across LKML yet.
> > > > > > > > 
> > > > > > > > I might...  But does it qualify as a regression?  That part of the
> > > > > > > > code hasn't changed for some time now.
> > > > > > > 
> > > > > > > It's a fix for a problem that is newly surfaced in 3.1.  A regression,
> > > > > > > likely not since it's been there forever, but new debugging options
> > > > > > > uncovered it.  I'm pretty sure the -rc stage takes fixes even if they
> > > > > > > aren't regressions.
> > > > > > 
> > > > > > Nope, after -rc1 only regressions fixes are taken (most of the time).
> > > > > 
> > > > > Sigh.
> > > > > 
> > > > > Look, either way I'm carrying this patch in Fedora because it fixes
> > > > > a bug that is actually being reported by users (and by abrtd as well).
> > > > > If you both want to wait until 3.2 to actually submit it to Linus,
> > > > > then OK.
> > > > > 
> > > > > Honestly, I'm just glad we actually run with the debug options enabled
> > > > > (which seems to be a rare thing) so bugs like this are actually found.
> > > > > Thanks for the fix.
> > > > 
> > > > I am sorry, but I didn't make the rules!  And I must carry the fix
> > > > longer as well, if that makes you feel any better.
> > > 
> > > bah, we're not that anal.  The patch fixes a bug and prevents a nasty
> > > warning spew.  Please, send it to Linus.
> > 
> > Given your Acked-by and Josh's Tested-by I might consider it.  ;-)
> > 
> > Speaking of which, Josh, does this patch help Nicolas and Michal?
> > 
> > > We appear to be referring to the patch "rcu: Avoid having just-onlined
> > > CPU resched itself when RCU is idle"?  If so, the changelog doesn't
> > > even mention that the patch fixes a scheduling-while-atomic warning and
> > > the changelog fails to refer to the redhat bug report.  These omissions
> > > should be repaired, please.
> > 
> > OK...  But I cannot bring myself to believe that my fix does more than
> > hide some other bug.  Which is OK, I will just say that in the changelog.
> 
> And here is this patch ported to v3.1-rc2, FYI.
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> rcu: Avoid having just-onlined CPU resched itself when RCU is idle
> 
> CPUs set rdp->qs_pending when coming online to resolve races with
> grace-period start.  However, this means that if RCU is idle, the
> just-onlined CPU might needlessly send itself resched IPIs.  Adjust the
> online-CPU initialization to avoid this, and also to correctly cause
> the CPU to respond to the current grace period if needed.
> 
> This patch is believed to fix or otherwise suppress problems in
> https://bugzilla.redhat.com/show_bug.cgi?id=726877, however, the
> relationship is not apparent to this patch's author.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index ba06207..6986d34 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1865,8 +1865,6 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
>  
>  	/* Set up local state, ensuring consistent view of global state. */
>  	raw_spin_lock_irqsave(&rnp->lock, flags);
> -	rdp->passed_quiesc = 0;  /* We could be racing with new GP, */
> -	rdp->qs_pending = 1;	 /*  so set up to respond to current GP. */
>  	rdp->beenonline = 1;	 /* We have now been online. */
>  	rdp->preemptible = preemptible;
>  	rdp->qlen_last_fqs_check = 0;
> @@ -1891,8 +1889,15 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
>  		rnp->qsmaskinit |= mask;
>  		mask = rnp->grpmask;
>  		if (rnp == rdp->mynode) {
> -			rdp->gpnum = rnp->completed; /* if GP in progress... */
> +			/*
> +			 * If there is a grace period in progress, we will
> +			 * set up to wait for it next time we run the
> +			 * RCU core code.
> +			 */
> +			rdp->gpnum = rnp->completed;
>  			rdp->completed = rnp->completed;
> +			rdp->passed_quiesc = 0;
> +			rdp->qs_pending = 1;

In the previous version you had rdp->qs_pending = 0 here.
If it's set to 0 I can understand that it fixes the problem.
Otherwise, set to 1 I don't know how it fixes the thing.

Should it perhaps set it to 1 only if we have rnp->gpnum > rnp->completed ?

>  			rdp->passed_quiesc_completed = rnp->completed - 1;
>  		}
>  		raw_spin_unlock(&rnp->lock); /* irqs already disabled. */
