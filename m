Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936Ab2IFSJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 14:09:40 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:42557 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373Ab2IFSJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 14:09:38 -0400
Date: Thu, 6 Sep 2012 11:02:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 14/23] rcu: Remove now-unused rcu_state
 fields
Message-ID: <20120906180251.GO2448@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-14-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346941023.18408.15.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346941023.18408.15.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090618-4242-0000-0000-000002CF7E36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 04:17:03PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-08-30 at 11:18 -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > Moving the RCU grace-period processing to a kthread and adjusting the
> > tracing resulted in two of the rcu_state structure's fields being unused.
> > This commit therefore removes them.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcutree.h |    7 -------
> >  1 files changed, 0 insertions(+), 7 deletions(-)
> > 
> > diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> > index 2d4cc18..8f0293c 100644
> > --- a/kernel/rcutree.h
> > +++ b/kernel/rcutree.h
> > @@ -378,13 +378,6 @@ struct rcu_state {
> >  
> >  	u8	fqs_state ____cacheline_internodealigned_in_smp;
> >  						/* Force QS state. */
> > -	u8	fqs_active;			/* force_quiescent_state() */
> > -						/*  is running. */
> > -	u8	fqs_need_gp;			/* A CPU was prevented from */
> > -						/*  starting a new grace */
> > -						/*  period because */
> > -						/*  force_quiescent_state() */
> > -						/*  was running. */
> >  	u8	boost;				/* Subject to priority boost. */
> >  	unsigned long gpnum;			/* Current gp number. */
> >  	unsigned long completed;		/* # of last completed gp. */
> 
> Typically one would fold this change into the patch that caused said
> redundancy and not mention it. Save a patch to (post/review/merge) and
> makes the patches a more solid whole.

Fair enough.  I still like the idea of pulling the stuff creating
rcu_gp_kthread() into one patch, though.

							Thanx, Paul

