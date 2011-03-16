Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751157Ab1CPE3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 00:29:22 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:33871 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab1CPE3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 00:29:16 -0400
Date: Tue, 15 Mar 2011 21:29:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH V4 1/1] rcu: introduce kfree_rcu()
Message-ID: <20110316042909.GG2273@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4D7F356C.8020903@cn.fujitsu.com>
 <20110315113038.GB2167@linux.vnet.ibm.com>
 <4D802578.8050603@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D802578.8050603@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 10:50:32AM +0800, Lai Jiangshan wrote:
> On 03/15/2011 07:30 PM, Paul E. McKenney wrote:
> > On Tue, Mar 15, 2011 at 05:46:20PM +0800, Lai Jiangshan wrote:
> >> kfree_rcu() which was original proposed by Lai 2.5 years ago is one of
> >> the most important RCU TODO list entries, Lai and Manfred have worked on
> >> patches for this. This V4 patch is based on the Manfred's patch and
> >> the V1 of Lai's patch. (These two patches are almost the same
> >> in implementation, and this patch is mainly based on the Manfred's).
> >>
> >> Lai's V1 patch: http://lkml.org/lkml/2008/9/18/1
> >> Manfred's patch: http://lkml.org/lkml/2009/1/2/115
> >> RCU TODO list: http://www.kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html
> >>
> >> This new introduced API kfree_rcu() primitive kfree()s the specified memory
> >> after a RCU grace period elapses.
> >>
> >> It replaces many simple "call_rcu(head, simple_kfree_callback)";
> >> These many simple_kfree_callback() instances just does
> >>
> >> 	kfree(containerof(head,struct whatever_struct,rcu_member));
> >>
> >> These simple_kfree_callback() instances are just duplicate code, we need
> >> a generic function for them.
> >>
> >> And kfree_rcu() is also help for unloadable modules, kfree_rcu() does not
> >> queue any function which belong to the module, so a rcu_barrier() can
> >> be avoid when module exit. (If we queue any other function by call_rcu(),
> >> rcu_barrier() is still needed.)
> > 
> > Thank you for putting this together!  It does represent a nice
> > reduction in code size.
> > 
> > Once it settles out a bit, I intend to queue this patch.  It would be
> > best if the subsystems queue their own patches using kfree_rcu() once
> > this patch reaches mainline.
> > 
> 
> It seems that the subsystems maintainers just Ack the patches.
> I hope Ingo queue the Acked using kfree_rcu() patches into -tip,
> it will help the kfree_rcu() reaches mainline earlier.

Yep, I am comfortable pushing the patches that have received acks.

							Thanx, Paul
