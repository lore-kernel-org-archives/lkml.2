Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab0CSRLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 13:11:13 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38684 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660Ab0CSRLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 13:11:10 -0400
Date: Fri, 19 Mar 2010 10:11:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] tree/tiny rcu: Add debug RCU head option (v2)
Message-ID: <20100319171105.GB2520@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100319013024.GA28456@Krystal>
 <4BA2FA01.30102@cn.fujitsu.com>
 <alpine.DEB.2.00.1003190730440.9184@router.home>
 <20100319144434.GA2520@linux.vnet.ibm.com>
 <20100319165637.GA28123@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100319165637.GA28123@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 12:56:38PM -0400, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Fri, Mar 19, 2010 at 07:34:07AM -0500, Christoph Lameter wrote:
> > > On Fri, 19 Mar 2010, Lai Jiangshan wrote:
> > > 
> > > > but SLUB opposed me, so I did not post it.
> > > >
> > > > @ slub.c
> > > > static void free_slab(struct kmem_cache *s, struct page *page)
> > > > {
> > > > 	if (unlikely(s->flags & SLAB_DESTROY_BY_RCU)) {
> > > > 		/*
> > > > 		 * RCU free overloads the RCU head over the LRU
> > > > 		 */
> > > > 		struct rcu_head *head = (void *)&page->lru;
> > > >
> > > > 		call_rcu(head, rcu_free_slab);
> > > > 	} else
> > > > 		__free_slab(s, page);
> > > > }
> > > >
> > > > I think it is not your patch's fault, but the above code has
> > > > already existed.
> > > >
> > > > In your patch, struct rcu_head::debug will share the same memory of
> > > > the other field of struct page, (especially share the struct page::flags
> > > > which I encountered)
> > > 
> > > Right. I like the smallness of the RCU structure but if you must
> > > increase its size then we could:
> > > 
> > > A) put the rcu structure at the end of each page like SLOB
> > >    but that will take away memory that could be used by objects.
> > > 
> > > B) Move the rcu object up by a word so that it overloads the index field
> > >    in the page struct. That would give another exact fit but will cause
> > >    trouble again if you bloat the structure some more.
> > 
> > The size increase is strictly under a debug option -- the non-debug
> > size remains the same as always.  And I expect that in the longer term,
> > we will be able to shrink the size back down even with this debug option
> > available.
> > 
> > One question: do any of the other allocators care about the size of the
> > struct rcu_head?  If not, a temporary work-around would be to simply
> > prohibit use of this debug option when running with SLUB.
> > 
> > 							Thanx, Paul
> 
> Don't worry about the struct rcu_head size too much. I'm currently working on a
> debugobjects implementation. I should have something by the end of the day.

Even better!!!  Thank you, Mathieu!!!

							Thanx, Paul
