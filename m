Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab0C2QBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:01:14 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39117 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab0C2QBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:01:13 -0400
Date: Mon, 29 Mar 2010 09:01:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       adobriyan@gmail.com
Subject: Re: [patch 0/6] rcu head debugobjects
Message-ID: <20100329160107.GH2569@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100327153233.993367557@efficios.com>
 <20100327224606.GK2343@linux.vnet.ibm.com>
 <20100327231421.GA4685@Krystal>
 <20100327232024.GB4685@Krystal>
 <20100327234314.GL2343@linux.vnet.ibm.com>
 <20100329133933.GA23238@Krystal>
 <20100329145329.GA2569@linux.vnet.ibm.com>
 <20100329150425.GA26746@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100329150425.GA26746@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 11:04:25AM -0400, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Mon, Mar 29, 2010 at 09:39:33AM -0400, Mathieu Desnoyers wrote:
> > > Hi Paul,
> > > 
> > > Thinking about the rcu head init topic, we might be able to drop the
> > > init_rcu_head() initializer. The idea is the following:
> > > 
> > > - We need init_rcu_head_on_stack()/destroy_rcu_head_on_stack().
> > > - call_rcu() populates the rcu_head and normally does not care about it being
> > >   pre-initialized.
> > > - The activation fixup can detect if a non-initialized rcu head is being
> > >   activated and just perform the fixup without complaining.
> > > - If we have two call_rcu() in a row in the same GP on the same rcu_head, the
> > >   activation check will detect it.
> > > 
> > > So either we remove all the init_rcu_head(), as was originally proposed, or we
> > > use one that is a no-op on !DEBUG configs and initialize the object with DEBUG
> > > configs.
> > > 
> > > That removes the dependency on object_is_static().
> > 
> > If I understand correctly, this does sound good.  Here is what I think
> > you are proposing:
> > 
> > o	call_rcu() and friends only complain if handed an rcu_head
> > 	structure that is still queued awaiting a grace period.
> > 	They don't care otherwise.
> > 
> > o	rcu_do_batch() complains unless the rcu_head structure has
> > 	most recently been enqueued by call_rcu() or one if its friends.
> > 
> > Did I get it right?
> 
> Exactly.

Very good!!!

							Thanx, Paul
