Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab2IGGzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:55:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:58057 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189Ab2IGGzP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:55:15 -0400
Message-ID: <1347000873.18408.69.camel@twins>
Subject: Re: [PATCH tip/core/rcu 01/15] rcu: Add PROVE_RCU_DELAY to provoke
 difficult races
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Date: Fri, 07 Sep 2012 08:54:33 +0200
In-Reply-To: <20120906205156.GZ2448@linux.vnet.ibm.com>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
	 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346942312.18408.26.camel@twins>
	 <20120906205156.GZ2448@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 13:51 -0700, Paul E. McKenney wrote:
> On Thu, Sep 06, 2012 at 04:38:32PM +0200, Peter Zijlstra wrote:
> > On Thu, 2012-08-30 at 11:56 -0700, Paul E. McKenney wrote:
> > > +#ifdef CONFIG_PROVE_RCU_DELAY
> > > +               udelay(10); /* Make preemption more probable. */
> > 		cond_resched(); /* for extra fun? */
> 
> The additional fun could include "scheduling while atomic", so I will
> pass.  ;-)
> 
> (The problem is that __rcu_read_unlock() can be called with interrupts
> disabled, among other things.)

Hmm, too bad. Without a preemption point here you're relying on forced
preemption, which of course can only happen on PREEMPT=y kernels.

> > > +#endif /* #ifdef CONFIG_PROVE_RCU_DELAY */ 
> > 
> > 
> 

