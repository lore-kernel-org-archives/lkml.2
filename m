Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab1DAD2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 23:28:46 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:47786 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab1DAD2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 23:28:45 -0400
Date: Thu, 31 Mar 2011 20:28:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Michal Marek <mmarek@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
Message-ID: <20110401032838.GA4443@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110330004725.GO2261@linux.vnet.ibm.com>
 <4D92BECA.50802@cn.fujitsu.com>
 <4D92DA32.2010809@cn.fujitsu.com>
 <20110330105505.GA3195@sepie.suse.cz>
 <1301482656.4859.171.camel@twins>
 <4D931814.9090100@suse.cz>
 <4D93D29C.5010702@cn.fujitsu.com>
 <20110331012155.GZ2255@linux.vnet.ibm.com>
 <4D93DE91.1050606@cn.fujitsu.com>
 <20110331233004.GP2258@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331233004.GP2258@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 04:30:04PM -0700, Paul E. McKenney wrote:
> On Thu, Mar 31, 2011 at 09:53:21AM +0800, Lai Jiangshan wrote:
> > On 03/31/2011 09:21 AM, Paul E. McKenney wrote:
> > > On Thu, Mar 31, 2011 at 09:02:20AM +0800, Lai Jiangshan wrote:
> > >> On 03/30/2011 07:46 PM, Michal Marek wrote:
> > >>> On 30.3.2011 12:57, Peter Zijlstra wrote:
> > >>>> On Wed, 2011-03-30 at 12:55 +0200, Michal Marek wrote:
> > >>>>> Subject: [PATCH] headers: Allow for lightweight inclusion of task_struct definition
> > >>>>>
> > >>>>> Factor out a couple of type definitions to <header>_types.h to allow
> > >>>>> using task_struct without pulling tons of new dependencies via sched.h.
> > >>>>
> > >>>> Urgh, not pretty.. so why not clean up sched.h properly? There's way too
> > >>>> much cruft in there.
> > >>>
> > >>> It was a proof-of-concept to show that it is doable to have proper
> > >>> definition of task_struct in rcupdate.h. Not an entry for any code
> > >>> beauty contest.
> > >>>
> > >>> Michal
> > >>>
> > >>
> > >> I like this cleanup, could you continue for this hard job? I will help you if required.
> > >>
> > >> Ingo & Peter - will you accept the patches when it is done.
> > >>
> > >> Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > > 
> > > I certainly like the idea of being able to inline TREE_PREEMPT_RCU's
> > > rcu_read_lock() and rcu_read_unlock() using normal C code!
> > > 
> > > 							Thanx, Paul
> > > 
> > 
> > kernel-offset.c can be merged to some branch of your tree for
> > testing inlined TREE_PREEMPT_RCU's rcu_read_lock() and rcu_read_unlock()
> > before the kernel headers splitting is done.
> > 
> > Can the [patch 1/5] be merged to mainline earlier? could you add it to origin/rcu/next?
> 
> Let's first settle on the overall direction, on the off-chance that someone
> comes up with an approach that doesn't require task_rcu_struct, or that
> requires it to be located somewhere other than include/linux/rcupdate.h.

And I have created a branch rcu/dev that contains the commits that
I don't yet trust enough to send to -next.  As before, rcu/kfree_rcu
contains the commits that apply kfree_rcu() elsewhere in the kernel.

							Thanx, Paul
