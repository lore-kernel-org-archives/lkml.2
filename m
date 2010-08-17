Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab0HQQE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 12:04:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57876 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab0HQQEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 12:04:54 -0400
X-Authority-Analysis: v=1.1 cv=FLDyhxrUEZZDQYGWQdnXfbzWjjll+fIPMqQTcKt1R7E= c=1 sm=0 a=ApKsrK4jzPIA:10 a=Q9fys5e9bTEA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:17 a=z0FOyJqDpP-ErVhUdG8A:9 a=EnMItNdSnJXHMDoZP04A:7 a=QAeP71OHOD8u_Wh4tGHHQy6ksdAA:4 a=PUjeQqilurYA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:117
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
In-Reply-To: <20100817155521.GA17849@Krystal>
References: <20100816150737.GB8320@Krystal>
	 <20100816183355.GH2388@linux.vnet.ibm.com> <20100816191947.GA970@Krystal>
	 <20100816213200.GK2388@linux.vnet.ibm.com> <20100816214123.GA15663@Krystal>
	 <20100816215555.GL2388@linux.vnet.ibm.com> <20100816220705.GA18650@Krystal>
	 <1282051639.3268.1335.camel@gandalf.stny.rr.com>
	 <20100817141638.GA5722@Krystal>
	 <1282056878.3268.1437.camel@gandalf.stny.rr.com>
	 <20100817155521.GA17849@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 17 Aug 2010 12:04:50 -0400
Message-ID: <1282061090.3268.1514.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-17 at 11:55 -0400, Mathieu Desnoyers wrote:

> > Heck, this is too much micro optimization. We could just be safe and do
> > the:
> >  	--t->rcu_read_lock_nesting;
> > 	barrier();
> >          if (ACCESS_ONCE(t->rcu_read_lock_nesting) == 0 &&
> >               unlikely((ACCESS_ONCE(t->rcu_read_unlock_special)))
> >  
> > And be done with it.
> 
> Then we could go for the simpler:
> 
>   	--t->rcu_read_lock_nesting;
>  	barrier();
>         if (t->rcu_read_lock_nesting == 0 &&
>              unlikely((t->rcu_read_unlock_special))

Yeah, that's what I meant, I was too lazy to remove the ACCESS_ONCE()
from the cut and paste I did.

> 
> Which puts a constraint across all memory accesses. I'd be fine with
> that if you are afraid of too much micro-optimization (e.g. my
> barrier2(a, b) proposal).

Not afraid, but just too much code for a simple solution.

-- Steve


