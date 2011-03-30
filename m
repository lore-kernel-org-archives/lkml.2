Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab1C3Ard (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 20:47:33 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:43543 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab1C3Arc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 20:47:32 -0400
Date: Tue, 29 Mar 2011 17:47:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Jan Beulich <JBeulich@novell.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
Message-ID: <20110330004725.GO2261@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4D8FF8AD.5080607@cn.fujitsu.com>
 <4D8FF9BC.7050609@cn.fujitsu.com>
 <4D90647902000078000389CB@vpn.id2.novell.com>
 <4D924BAF.1020906@linux.intel.com>
 <20110329213130.GK2261@linux.vnet.ibm.com>
 <4D924FEE.8040804@linux.intel.com>
 <20110329214704.GM2261@linux.vnet.ibm.com>
 <4D9256AF.5000308@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9256AF.5000308@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 03:01:19PM -0700, H. Peter Anvin wrote:
> On 03/29/2011 02:47 PM, Paul E. McKenney wrote:
> > On Tue, Mar 29, 2011 at 02:32:30PM -0700, H. Peter Anvin wrote:
> >> On 03/29/2011 02:31 PM, Paul E. McKenney wrote:
> >>>>
> >>>> I have to say that if we have to use hardcoded offsets in C then we have
> >>>> bigger problems.
> >>>
> >>> In this case, the offsets are mechanically generated from the structure
> >>> definitions.
> >>>
> >>> Or am I missing your point?
> >>
> >> Yes.  The point is if we have to pull out these kinds of hacks in *C*
> >> code, we are doing it wrong.  Not just a little wrong, but completely
> >> and totally bonkers wrong.
> > 
> > OK, maybe we are doing it wrong.
> > 
> > But in that case, how do you suggest restructuring include/linux/sched.h
> > so that struct task_struct can be safely included everywhere
> > rcu_read_lock() and friends are invoked?  Or, on the other hand,
> > what should we be doing so that we don't need to include task_struct
> > everywhere?
> 
> Lai's text doesn't give any hint as to the specific nature of the
> conflict, which makes it hard to come up with a better alternative
> without having to rediscover the problem from first principles.
> However, a somewhat logical assumption is that the problem is that
> struct task_struct includes struct rcu_head, in which case the easiest
> thing to do is almost certainly to move the definition of struct
> rcu_head to its own header file, <linux/rcuhead.h>, and include that in
> <linux/sched.h>, which should make it possible to include
> <linux/sched.h> in <linux/rcupdate.h>.

I believe that there are other circular dependencies -- there certainly
were a few years back -- but I will defer to Lai.

							Thanx, Paul
