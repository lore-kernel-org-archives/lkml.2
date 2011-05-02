Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab1EBIg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 04:36:27 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58567 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab1EBIgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 04:36:25 -0400
Date: Mon, 2 May 2011 01:36:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 45/86] net,act_police,rcu: remove
 rcu_barrier()
Message-ID: <20110502083618.GB2297@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110501132142.GA25494@linux.vnet.ibm.com>
 <1304256126-26015-45-git-send-email-paulmck@linux.vnet.ibm.com>
 <20110501155935.GH14829@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110501155935.GH14829@feather>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 01, 2011 at 08:59:35AM -0700, Josh Triplett wrote:
> On Sun, May 01, 2011 at 06:21:25AM -0700, Paul E. McKenney wrote:
> > From: Lai Jiangshan <laijs@cn.fujitsu.com>
> > 
> > There is no callback of this module maybe queued
> > since we use kfree_rcu(), we can safely remove the rcu_barrier().
> > 
> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Acked-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  net/sched/act_police.c |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> > 
> > diff --git a/net/sched/act_police.c b/net/sched/act_police.c
> > index d6bcd64..b3b9b32 100644
> > --- a/net/sched/act_police.c
> > +++ b/net/sched/act_police.c
> > @@ -396,7 +396,6 @@ static void __exit
> >  police_cleanup_module(void)
> >  {
> >  	tcf_unregister_action(&act_police_ops);
> > -	rcu_barrier(); /* Wait for completion of call_rcu()'s (tcf_police_free_rcu) */
> >  }
> 
> Very nice side-effect of having common callback code.  Seems worth doing
> a review of other callers of rcu_barrier as well, to see if they still
> need to do so.

Agreed, and good point on the review.  /me wonders how this review could
be automated...

							Thanx, Paul
