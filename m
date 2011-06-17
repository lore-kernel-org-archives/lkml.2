Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244Ab1FQO6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 10:58:47 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55541 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007Ab1FQO6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 10:58:45 -0400
Date: Fri, 17 Jun 2011 07:58:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, akpm@linux-foundation.org,
        benh@kernel.crashing.org, fweisbec@gmail.com, ak@linux.intel.com,
        tim.c.chen@linux.intel.com
Subject: Re: [GIT PULL rcu/urgent] Banishing kthreads
Message-ID: <20110617145838.GA3312@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110617145723.GA3261@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110617145723.GA3261@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 07:57:23AM -0700, Paul E. McKenney wrote:
> Hello, Ingo,
> 
> This pull request banishes RCU kthreads in the RCU_BOOST=n case,
> in response to popular demand.  There are two commits in this
> series:
> 
> 1.	Minimal patch that #ifdefs out the kthread code.
> 
> 2.	Code-movement patch that puts the code #ifdefed out above
> 	under existing #ifdefs in kernel/rcutree_plugin.h.
> 
> These changes are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/urgent

This time with the correct request-pull info.  :-/

 							Thanx, Paul


------------------->

Paul E. McKenney (2):
      rcu: use softirq instead of kthreads except when RCU_BOOST=y
      rcu: Move RCU_BOOST #ifdefs to header file

 kernel/rcutree.c        |  382 ++-----------------------------------------
 kernel/rcutree.h        |   13 ++-
 kernel/rcutree_plugin.h |  419 +++++++++++++++++++++++++++++++++++++++++++++--
 kernel/rcutree_trace.c  |   32 +++-
 4 files changed, 456 insertions(+), 390 deletions(-)
