Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690Ab0HQOgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 10:36:35 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38489 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757726Ab0HQOg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 10:36:29 -0400
Date: Tue, 17 Aug 2010 07:35:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, josh@joshtriplett.org, dvhltc@us.ibm.com,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com
Subject: Re: [PATCH tip/core/rcu 08/10] rcu: Add a TINY_PREEMPT_RCU
Message-ID: <20100817143514.GA2471@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1281392111-25060-8-git-send-email-paulmck@linux.vnet.ibm.com>
 <20100816150737.GB8320@Krystal>
 <20100816183355.GH2388@linux.vnet.ibm.com>
 <20100816191947.GA970@Krystal>
 <20100816213200.GK2388@linux.vnet.ibm.com>
 <20100816214123.GA15663@Krystal>
 <20100816215555.GL2388@linux.vnet.ibm.com>
 <20100816220705.GA18650@Krystal>
 <20100816222402.GM2388@linux.vnet.ibm.com>
 <4C6A580D.5010903@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6A580D.5010903@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 05:36:13PM +0800, Lai Jiangshan wrote:
> On 08/17/2010 06:24 AM, Paul E. McKenney wrote:
> 
> >> --(t->rcu_read_lock_nesting)
> >>
> >> could be split in two distinct operations:
> >>
> >> read t->rcu_read_lock_nesting
> >> decrement t->rcu_read_lock_nesting
> >>
> >> Note that in order to know the result required to pass the sequence
> >> point "&&" (the test), we only need to perform the read, not the
> >> decrement. AFAIU, gcc would be in its rights to move the
> >> t->rcu_read_lock_nesting update after the volatile access.
> > 
> > I will run this by some compiler experts.
> 
> We can just use "read and decrement statements" instead of "--" to
> avoid dependency from compilers.

You mean something like local_add_return()?  This turns into
atomic_add_return() on many platforms, including x86 as it turns out,
so I am reluctant to use it.

If you had something else in mind, please don't keep it a secret!

							Thanx, Paul
