Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab0C0XOZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 19:14:25 -0400
Received: from mail.openrapids.net ([64.15.138.104]:39420 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753334Ab0C0XOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 19:14:24 -0400
Date: Sat, 27 Mar 2010 19:14:21 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       adobriyan@gmail.com
Subject: Re: [patch 0/6] rcu head debugobjects
Message-ID: <20100327231421.GA4685@Krystal>
References: <20100327153233.993367557@efficios.com> <20100327224606.GK2343@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100327224606.GK2343@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 18:47:56 up 64 days,  1:25,  3 users,  load average: 0.00, 0.09,
	0.06
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Sat, Mar 27, 2010 at 11:32:33AM -0400, Mathieu Desnoyers wrote:
> > Hi,
> > 
> > Here is an updated version of the rcu head debugobjects, following the comments
> > I received in the last rounds.
> > 
> > It applies on top of -tip, based on 2.6.34-rc2, commit
> > 2e958f219d2b8d192d44e2472a214b3a93c44673
> > 
> > Unless people have any objection, it should be ready to be merged. I think the
> > appropriate maintainer to perform this merge would be Paul E. McKenney, because
> > this patchset is RCU-related.
> 
> This should be very helpful in tracking down otherwise-painful bugs!!!
> Thank you, Mathieu!!!  I am happy to apply this, especially given Dave
> Miller's Acked-by.
> 
> A few questions and comments:
> 
> o	Patches 1/6, 2/6, 3/6: Was the intent for the three Subject
> 	lines to read as follows?
> 
> 	[patch 1/6] Revert "net: remove INIT_RCU_HEAD() usage"
> 	[patch 2/6] Revert "netfilter: don't use INIT_RCU_HEAD()"
> 	[patch 3/6] Revert "net: don't use INIT_RCU_HEAD"

Yep. Oops, got burnt by git show > patches/patchname.patch. Will fix and
re-send.

> 
> o	Patch 4/6 looks good to me, and given that Thomas hasn't
> 	complained, I am guessing that he is OK with it.

OK.

> 
> o	Would it be possible to make this bisectable as follows?
> 
> 	a.	Insert a new patch after current patch 4/6 that
> 		defines destroy_rcu_head_on_stack(),
> 		rcu_head_init_on_stack(), and rcu_head_init() with
> 		their !CONFIG_DEBUG_OBJECTS_RCU_HEAD definitions.
> 
> 	b.	Move current patch 6/6 to this position.
> 
> 	c.	Move current patch 5/6 to this position, updating
> 		to reflect the new patch added in (a) above.
> 

Sure. Will do.

> o	Patch 6/6: Would it be possible to use the object_is_on_stack()
> 	function defined in include/linux/sched.h instead of passing
> 	in the flag on_stack to bdi_work_init()?  It looks like
> 	fs/fs-writeback.c already includes include/linux/sched.h, so
> 	shouldn't be a problem from a #include-hell viewpoint.

Wow, that's cool! We learn about exciting internal API functions every day,
isn't life great ? I will definitely change the fs-writeback.c code to make use
of it.

We might event want to go further. A similar scheme could be used for the
rcu_head debugobject activation fixup. Basically, I need a way to distinguish
between:

A) objects on stack and allocated objects
and
B) objects statically initialized

So either we use something resembling:

  if (object_is_on_stack() || object_is_allocated())

or

  if (object_is_static())

I am not aware of the proper API members to do that though.

> 
> Please let me know if I am missing something on any of the above.  If
> these changes seem reasonable to you, please either submit a new patch
> set or let me know that you are OK with me making these changes.

As soon as I get the information about the static vs stack/alloc, I'll complete
the update and re-send the updated patchset.

Thanks,

Mathieu


> 
> 							Thanx, Paul

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
