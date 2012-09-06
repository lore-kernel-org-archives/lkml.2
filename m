Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146Ab2IFUwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 16:52:16 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:43258 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933119Ab2IFUwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 16:52:13 -0400
Date: Thu, 6 Sep 2012 13:51:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 01/15] rcu: Add PROVE_RCU_DELAY to provoke
 difficult races
Message-ID: <20120906205156.GZ2448@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346942312.18408.26.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346942312.18408.26.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090620-5518-0000-0000-0000076F8DC1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 04:38:32PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-08-30 at 11:56 -0700, Paul E. McKenney wrote:
> > +#ifdef CONFIG_PROVE_RCU_DELAY
> > +               udelay(10); /* Make preemption more probable. */
> 		cond_resched(); /* for extra fun? */

The additional fun could include "scheduling while atomic", so I will
pass.  ;-)

(The problem is that __rcu_read_unlock() can be called with interrupts
disabled, among other things.)

							Thanx, Paul

> > +#endif /* #ifdef CONFIG_PROVE_RCU_DELAY */ 
> 
> 

