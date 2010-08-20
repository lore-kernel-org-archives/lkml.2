Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab0HTSp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 14:45:27 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:32986 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578Ab0HTSpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 14:45:25 -0400
Date: Fri, 20 Aug 2010 11:45:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com
Subject: [PATCH tip/core/rcu 0/7] Yet more RCU commits queued for 2.6.37
Message-ID: <20100820184521.GA24715@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patchset shows additional patches queued for 2.6.37, over
and above those posted at http://lkml.org/lkml/2010/7/14/334 and
at http://lkml.org/lkml/2010/8/9/332.  These are all trivial fixes.
The patches are as follows:

1.	Allow kernel debuggers to avoid spurious RCU CPU stall warnings
	when restarting from a breakpoint via a new rcu_cpu_stall_reset().
2.	Repair code-duplication FIXMEs.  This code was temporarily
	duplicated to avoid inter-patch dependencies in the RCU tree.
3.	Document some additional ways of stalling updates to prevent
	call_rcu()-induced OOM situations.
4.	Update srcu_read_lock() docbook comment to note that it is
	illegal to wait for a given flavor of SRCU grace period while
	in that same flavor of SRCU read-side critical section.
5.	Combine duplicate code, courtesy of a newly refurbished
	CONFIG_PREEMPT_RCU symbol.  Also convert from macro to
	static inline function in a couple of places.
6.	Apply the TINY_PREEMPT_RCU read-side speedups/fixes to
	TREE_PREEMPT_RCU.  This update to TINY_PREEMPT_RCU update was
	posted at http://lkml.org/lkml/2010/8/17/437.
7.	Add a comment stating that list_empty() serves the function of
	the non-existent list_empty_rcu().

For a testing-only version of this patchset from git, please see:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/testing

							Thanx, Paul

 b/Documentation/RCU/checklist.txt |   23 ++++++++---
 b/include/linux/rculist.h         |    9 ++++
 b/include/linux/rcupdate.h        |   15 +++++++
 b/include/linux/rcutiny.h         |    4 ++
 b/include/linux/rcutree.h         |    1 
 b/include/linux/srcu.h            |    7 +++
 b/kernel/rcutiny_plugin.h         |    4 --
 b/kernel/rcutree.c                |   20 ++++++++++
 b/kernel/rcutree.h                |    1 
 b/kernel/rcutree_plugin.h         |   18 +++++++++
 include/linux/rcupdate.h          |   75 ++++++++++++++++++++++++++++++++++++--
 include/linux/rcutiny.h           |   58 -----------------------------
 include/linux/rcutree.h           |   56 ----------------------------
 kernel/rcutree.h                  |    3 -
 kernel/rcutree_plugin.h           |   15 ++-----
 15 files changed, 166 insertions(+), 143 deletions(-)
