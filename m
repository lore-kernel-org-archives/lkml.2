Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab0HQQaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 12:30:39 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:58019 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750938Ab0HQQai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 12:30:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAF9WakxGGN19/2dsb2JhbACgPXLBU4U3BA
Date: Tue, 17 Aug 2010 12:25:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH tip/core/rcu 08/10] rcu: Add a TINY_PREEMPT_RCU
Message-ID: <20100817162525.GA21945@Krystal>
References: <20100816213200.GK2388@linux.vnet.ibm.com> <20100816214123.GA15663@Krystal> <20100816215555.GL2388@linux.vnet.ibm.com> <20100816220705.GA18650@Krystal> <1282051639.3268.1335.camel@gandalf.stny.rr.com> <20100817141638.GA5722@Krystal> <1282056878.3268.1437.camel@gandalf.stny.rr.com> <20100817155521.GA17849@Krystal> <1282061090.3268.1514.camel@gandalf.stny.rr.com> <1282061199.3268.1519.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1282061199.3268.1519.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:23:59 up 132 days,  2:15,  4 users,  load average: 0.05, 0.10,
	0.08
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Tue, 2010-08-17 at 12:04 -0400, Steven Rostedt wrote:
> 
> > > Then we could go for the simpler:
> > > 
> > >   	--t->rcu_read_lock_nesting;
> > >  	barrier();
> > >         if (t->rcu_read_lock_nesting == 0 &&
> > >              unlikely((t->rcu_read_unlock_special))
> > 
> > Yeah, that's what I meant, I was too lazy to remove the ACCESS_ONCE()
> > from the cut and paste I did.
> > 
> > > 
> > > Which puts a constraint across all memory accesses. I'd be fine with
> > > that if you are afraid of too much micro-optimization (e.g. my
> > > barrier2(a, b) proposal).
> > 
> > Not afraid, but just too much code for a simple solution.
> 
> IOW,
> 
> I think just pulling out the '--' and adding the barrier() is the proper
> solution here. Compiler barriers are rather cheap.
> 
> Can we all agree on this solution?

Given that we already have a barrier() at the beginning of
rcu_read_unlock(), adding a second one will not have much more global
optimisation impact than what is already there. I'm personally fine with
this solution. Let's see what others have to say about this.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
