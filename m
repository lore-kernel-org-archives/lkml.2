Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab0IBRQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 13:16:50 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52526 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964Ab0IBRQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 13:16:49 -0400
Date: Thu, 2 Sep 2010 10:16:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: peterz@infradead.org, lizf@cn.fujitsu.com, herbert@gondor.hengli.com.au,
        davej@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cls_cgroup: Fix rcu lockdep warning
Message-ID: <20100902171646.GC2349@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4C7F446F.8040303@cn.fujitsu.com>
 <1283423916.2059.1847.camel@laptop>
 <20100902.100551.115929058.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100902.100551.115929058.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 10:05:51AM -0700, David Miller wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Thu, 02 Sep 2010 12:38:36 +0200
> 
> > On Thu, 2010-09-02 at 14:30 +0800, Li Zefan wrote:
> >> Calling task_subsys_state() without holding rcu_read_lock or
> >> cgroup_mutex can cause lockdep warning.
> >> 
> > 
> > That is not a suitable changelog.
> > 
> > Was the warning correct? Is your patch correct? What does RCU protect
> > here and why can we use classid after dropping it.
> > 
> > Simply frobbing code to make the warning go away is not good.
> 
> In fact shouldn't this be a rcu_dereference() or similar?

The rcu_dereference() is there, just buried in task_subsys_state_check()
which is called from task_subsys_state().  The code extracts the classid,
which is an integer, so the RCU-protected pointer does not leak out of
the RCU read-side critical section.

So this is OK, but the changelog should indeed say why it is OK.

							Thanx, Paul
