Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab1CXNH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 09:07:27 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:32896 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab1CXNHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 09:07:25 -0400
Date: Thu, 24 Mar 2011 06:07:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com
Subject: Re: [PATCH RFC tip/core/rcu 01/11] rcu: call __rcu_read_unlock()
 in exit_rcu for tiny RCU
Message-ID: <20110324130712.GH2322@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110223013917.GA20996@linux.vnet.ibm.com>
 <1298425183-21265-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <4D67687A.6010906@cn.fujitsu.com>
 <20110225194007.GC2269@linux.vnet.ibm.com>
 <4D8ABE6C.7000105@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8ABE6C.7000105@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 11:45:48AM +0800, Lai Jiangshan wrote:
> On 02/26/2011 03:40 AM, Paul E. McKenney wrote:
> > On Fri, Feb 25, 2011 at 04:29:46PM +0800, Lai Jiangshan wrote:
> >> On 02/23/2011 09:39 AM, Paul E. McKenney wrote:
> >>>
> >>> diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
> >>> index 015abae..3cb8e36 100644
> >>> --- a/kernel/rcutiny_plugin.h
> >>> +++ b/kernel/rcutiny_plugin.h
> >>
> >> My original patch was just for tree RCU. It is not merged.
> >> I forgot the tiny RCU case then, this change is needed for tree & tiny RCU.
> > 
> > Good catch, I have applied the TREE_RCU patch.  I intend to submit
> > both for the next merge window.
> > 
> 
> Hi, Paul
> 
> It is still not merged, and it is not in your git tree.

Indeed it is not yet in my external git tree.  Here is my normal work
flow:

1.	Develop and test continuously.

2.	Based on testing, review, etc., determin which commits are
	ready for the next merge window.

3.	Midway through the -rc releases, push the commits targeted
	to the next merge window to rcu/next.  Push any additional
	commits to rcu/testing.

4.	Towards the last -rc, rebase, retest, wait for the -next
	tree to take the changes, and, if all is well, send Ingo
	a pull request.

Exposing your changes to -next during the merge window would cause
pointless irritation due to random conflicts with rapidly changing
code.

> I'm writing some patches, to avoid conflict with your code,
> which branch I should based on?

But, yes, it would be much easier for us to handle your changes if
I post them via -rcu.  So I have created a new branch rcu/kfree_rcu
that is -not- consumed by -next.  The rcu/next and rcu/testing
branches include your base kfree_rcu() patch, but not the uses of
it.  These branches are based on 2.6.38, and I will move them ahead
at -rc3 or -rc4.

These currently contain your original patches, but I will be pulling
your latest set.

> Is origin/rcu/next OK?

origin/rcu/kfree_rcu for the moment to avoid messing up -next.  But
it will be origin/rcu/next after rebasing onto -rc3 or -rc4.

							Thanx, Paul
