Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab0HQTeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 15:34:07 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:34310 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562Ab0HQTeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 15:34:03 -0400
Date: Tue, 17 Aug 2010 12:33:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, josh@joshtriplett.org, dvhltc@us.ibm.com,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH tip/core/rcu 08/10] rcu: Add a TINY_PREEMPT_RCU
Message-ID: <20100817193358.GG2364@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100816214123.GA15663@Krystal>
 <20100816215555.GL2388@linux.vnet.ibm.com>
 <20100816220705.GA18650@Krystal>
 <1282051639.3268.1335.camel@gandalf.stny.rr.com>
 <20100817141638.GA5722@Krystal>
 <1282056878.3268.1437.camel@gandalf.stny.rr.com>
 <20100817155521.GA17849@Krystal>
 <1282061090.3268.1514.camel@gandalf.stny.rr.com>
 <1282061199.3268.1519.camel@gandalf.stny.rr.com>
 <20100817162525.GA21945@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100817162525.GA21945@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 12:25:25PM -0400, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > On Tue, 2010-08-17 at 12:04 -0400, Steven Rostedt wrote:
> > 
> > > > Then we could go for the simpler:
> > > > 
> > > >   	--t->rcu_read_lock_nesting;
> > > >  	barrier();
> > > >         if (t->rcu_read_lock_nesting == 0 &&
> > > >              unlikely((t->rcu_read_unlock_special))
> > > 
> > > Yeah, that's what I meant, I was too lazy to remove the ACCESS_ONCE()
> > > from the cut and paste I did.
> > > 
> > > > 
> > > > Which puts a constraint across all memory accesses. I'd be fine with
> > > > that if you are afraid of too much micro-optimization (e.g. my
> > > > barrier2(a, b) proposal).
> > > 
> > > Not afraid, but just too much code for a simple solution.
> > 
> > IOW,
> > 
> > I think just pulling out the '--' and adding the barrier() is the proper
> > solution here. Compiler barriers are rather cheap.
> > 
> > Can we all agree on this solution?
> 
> Given that we already have a barrier() at the beginning of
> rcu_read_unlock(), adding a second one will not have much more global
> optimisation impact than what is already there. I'm personally fine with
> this solution. Let's see what others have to say about this.

Thank you both for the optimization work -- the read-side primitives do
need to be fast.  And the barrier() approach generates decent code, on
some systems better than the original.  So the second barrier wins.  ;-)

							Thanx, Paul
