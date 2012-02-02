Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab2BBULd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:11:33 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:34587 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab2BBULb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:11:31 -0500
X-Originating-IP: 217.70.178.130
X-Originating-IP: 50.43.15.19
Date: Thu, 2 Feb 2012 12:11:18 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 04/41] rcu: Add diagnostic for
 misaligned rcu_head structures
Message-ID: <20120202201117.GC9279@leaf>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120202010026.GE29058@leaf>
 <20120202162235.GI2518@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202162235.GI2518@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 08:22:35AM -0800, Paul E. McKenney wrote:
> On Wed, Feb 01, 2012 at 05:00:26PM -0800, Josh Triplett wrote:
> > On Wed, Feb 01, 2012 at 11:41:22AM -0800, Paul E. McKenney wrote:
> > > The push for energy efficiency will require that RCU tag rcu_head
> > > structures to indicate whether or not their invocation is time critical.
> > > This tagging is best carried out in the bottom bits of the ->next
> > > pointers in the rcu_head structures.  This tagging requires that the
> > > rcu_head structures be properly aligned, so this commit adds the required
> > > diagnostics.
> > 
> > > --- a/kernel/rcutree.c
> > > +++ b/kernel/rcutree.c
> > > @@ -1707,6 +1707,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
> > >  	unsigned long flags;
> > >  	struct rcu_data *rdp;
> > >  
> > > +	WARN_ON_ONCE((unsigned long)head & 0x3); /* Misaligned rcu_head! */
> > 
> > I wonder if this should go out in one of the wrapper macros, so that the
> > _ONCE means once per call site?
> 
> Certainly past experience introducing lockdep-RCU would argue that way.  ;-)
> 
> However, my testing thus far (famous last words!) has found no
> misalignments.  So I expect that these will be caught as they are
> inserted, so one at a time should be fine.

Fair enough.  Doesn't seem worth introducing a new wrapper macro for,
then, since it doesn't look like an appropriate one currently exists.

- Josh Triplett
