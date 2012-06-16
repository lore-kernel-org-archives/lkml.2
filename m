Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953Ab2FPAiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 20:38:05 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:33913 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758482Ab2FPAiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 20:38:03 -0400
Date: Fri, 15 Jun 2012 17:37:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 02/15] rcu: Size rcu_node tree from
 nr_cpu_ids rather than NR_CPUS
Message-ID: <20120616003714.GS2389@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120615210550.GA27506@linux.vnet.ibm.com>
 <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1339794370-28119-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120615214726.GT31184@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615214726.GT31184@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061600-6148-0000-0000-000006BE8D2F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 02:47:26PM -0700, Josh Triplett wrote:
> On Fri, Jun 15, 2012 at 02:05:57PM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > The rcu_node tree array is sized based on compile-time constants,
> > including NR_CPUS.  Although this approach has worked well in the past,
> > the recent trend by many distros to define NR_CPUS=4096 results in
> > excessive grace-period-initialization latencies.
> > 
> > This commit therefore substitutes the run-time computed nr_cpu_ids for
> > the compile-time NR_CPUS when building the tree.  This can result in
> > much of the compile-time-allocated rcu_node array being unused.  If
> > this is a major problem, you are in a specialized situation anyway,
> > so you can manually adjust the NR_CPUS, RCU_FANOUT, and RCU_FANOUT_LEAF
> > kernel config parameters.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcutree.c        |    2 +-
> >  kernel/rcutree_plugin.h |    2 ++
> >  2 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index a151184..9098910 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -2672,7 +2672,7 @@ static void __init rcu_init_geometry(void)
> >  {
> >  	int i;
> >  	int j;
> > -	int n = NR_CPUS;
> > +	int n = nr_cpu_ids;
> 
> Same question as before: why have this as a variable when it never
> changes?

Ah, that explains why.  This prevented me from forgetting the random
NR_CPUS.

							Thanx, Paul

