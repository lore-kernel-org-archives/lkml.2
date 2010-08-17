Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110Ab0HQQGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 12:06:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59872 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab0HQQGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 12:06:42 -0400
X-Authority-Analysis: v=1.1 cv=nbWoJD01ruQLYOYE44JZbYtzz81AmFDL3LnuPvZDHs8= c=1 sm=0 a=ApKsrK4jzPIA:10 a=Q9fys5e9bTEA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:17 a=USDaeMPFjngXFri8BmkA:9 a=XTRqaNffMP-zUc5cnE8A:7 a=tRGaIE3CJ6yWQdMUcSI05x6VKTMA:4 a=PUjeQqilurYA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.87.39
Subject: Re: [PATCH tip/core/rcu 08/10] rcu: Add a TINY_PREEMPT_RCU
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1282061090.3268.1514.camel@gandalf.stny.rr.com>
References: <20100816150737.GB8320@Krystal>
	 <20100816183355.GH2388@linux.vnet.ibm.com> <20100816191947.GA970@Krystal>
	 <20100816213200.GK2388@linux.vnet.ibm.com> <20100816214123.GA15663@Krystal>
	 <20100816215555.GL2388@linux.vnet.ibm.com> <20100816220705.GA18650@Krystal>
	 <1282051639.3268.1335.camel@gandalf.stny.rr.com>
	 <20100817141638.GA5722@Krystal>
	 <1282056878.3268.1437.camel@gandalf.stny.rr.com>
	 <20100817155521.GA17849@Krystal>
	 <1282061090.3268.1514.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 17 Aug 2010 12:06:39 -0400
Message-ID: <1282061199.3268.1519.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-17 at 12:04 -0400, Steven Rostedt wrote:

> > Then we could go for the simpler:
> > 
> >   	--t->rcu_read_lock_nesting;
> >  	barrier();
> >         if (t->rcu_read_lock_nesting == 0 &&
> >              unlikely((t->rcu_read_unlock_special))
> 
> Yeah, that's what I meant, I was too lazy to remove the ACCESS_ONCE()
> from the cut and paste I did.
> 
> > 
> > Which puts a constraint across all memory accesses. I'd be fine with
> > that if you are afraid of too much micro-optimization (e.g. my
> > barrier2(a, b) proposal).
> 
> Not afraid, but just too much code for a simple solution.

IOW,

I think just pulling out the '--' and adding the barrier() is the proper
solution here. Compiler barriers are rather cheap.

Can we all agree on this solution?

-- Steve


