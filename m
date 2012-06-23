Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab2FWRsf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 13:48:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:14808 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518Ab2FWRse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 13:48:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="169281141"
Date: Sun, 24 Jun 2012 01:48:30 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: BUG: tracer_alloc_buffers returned with preemption imbalance
Message-ID: <20120623174830.GA5617@localhost>
References: <20120623101251.GA10162@localhost>
 <20120623170147.GI2516@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120623170147.GI2516@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  static inline int rcu_blocking_is_gp(void)
> >  {
> >         might_sleep();  /* Check for RCU read-side critical section. */
> > +       preempt_disable();
> >         return num_online_cpus() <= 1;
> > +       preempt_enable();
> >  }
> 
> Thank you!  I have no idea how a preempt_disable() causes that badness
> to happen, but this commit is not yet critically important, so I will
> drop it.

preempt_enable() becomes dead code because of the return statement?
I wonder why gcc didn't issue a warning (or I failed to catch it)...

Thanks,
Fengguang
