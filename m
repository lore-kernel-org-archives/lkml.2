Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342Ab1FQO5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 10:57:37 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56409 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757946Ab1FQO5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 10:57:35 -0400
Date: Fri, 17 Jun 2011 07:57:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, akpm@linux-foundation.org,
        benh@kernel.crashing.org, fweisbec@gmail.com, ak@linux.intel.com,
        tim.c.chen@linux.intel.com
Subject: [GIT PULL rcu/urgent] Banishing kthreads
Message-ID: <20110617145723.GA3261@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

This pull request banishes RCU kthreads in the RCU_BOOST=n case,
in response to popular demand.  There are two commits in this
series:

1.	Minimal patch that #ifdefs out the kthread code.

2.	Code-movement patch that puts the code #ifdefed out above
	under existing #ifdefs in kernel/rcutree_plugin.h.

These changes are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/urgent

  							Thanx, Paul

------------------>

Paul E. McKenney (1):
      rcu: Simplify curing of load woes

Shaohua Li (1):
      rcu: Use softirq to address performance regression

 Documentation/filesystems/proc.txt  |    1 +
 include/linux/interrupt.h           |    1 +
 include/trace/events/irq.h          |    3 +-
 kernel/rcutree.c                    |   88 ++++++++++++++++-------------------
 kernel/rcutree.h                    |    1 +
 kernel/rcutree_plugin.h             |   20 ++++----
 kernel/softirq.c                    |    2 +-
 tools/perf/util/trace-event-parse.c |    1 +
 8 files changed, 57 insertions(+), 60 deletions(-)
