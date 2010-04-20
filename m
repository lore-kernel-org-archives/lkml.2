Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab0DTTSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 15:18:12 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54892 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696Ab0DTTSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 15:18:10 -0400
Date: Tue, 20 Apr 2010 12:18:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, eric.dumazet@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 10/16] rcu: slim down rcutiny by
 removing rcu_scheduler_active and friends
Message-ID: <20100420191805.GL2628@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1271355219-20714-10-git-send-email-paulmck@linux.vnet.ibm.com>
 <20100415181255.GA19588@linux.vnet.ibm.com>
 <31681.1271758508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31681.1271758508@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 11:15:08AM +0100, David Howells wrote:
> Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > +void rcu_scheduler_starting(void)
> > +{
> > +	WARN_ON(nr_context_switches() > 0);
> > +	rcu_scheduler_active = 1;
> > +}
> 
> Since rcu_scheduler_active is a global variable, does it make sense to make
> this an inline function in the header file?

Unfortunately, nr_context_switches() put me in #include hell when I
tried that.

> It looks decidedly odd in its own include file as you've done it.  Wouldn't
> the right way to do this be to split it into its own .c file and conditionally
> compile it in the Makefile?

It will soon have lots of company, as this is where the plugins
for CONFIG_TINY_PREEMPT_RCU will go.  In other words, kernel/rcutiny.c
will have the same relationship to kernel/rcutiny_plugin.h that
kernel/rcutree.c has with kernel/rcutree_plugin.h.

							Thanx, Paul
