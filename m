Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab1EUOGS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 10:06:18 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:59261 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213Ab1EUOGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 10:06:16 -0400
Date: Sat, 21 May 2011 07:06:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
        Valdis.Kletnieks@vt.edu, a.p.zijlstra@chello.nl
Subject: [GIT PULL rcu/next] fixes and breakup of memory-barrier-decrease
 patch
Message-ID: <20110521140613.GA13062@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

This pull requests covers some RCU bug fixes and one patch rework.

The first group breaks up the infamous now-reverted (but ultimately
vindicated) "Decrease memory-barrier usage based on semi-formal proof"
commit into five commits.  These five commits immediately follow the
revert, and the diff across all six of these commits is empty, so that
the effect of the five commits is to revert the revert.

Another commit, "Avoid build error for third-party modules", fixes
a build error reported by Randy Dunlap.

Another pair of commits, "Add atomic_or()" and "Avoid acquiring rcu_node
locks in timer functions", fix a lockdep splat reported by Valdis Kletnieks.

Finally, "Remove waitqueue usage for cpu, node, and boost kthreads", from
Peter Zijlstra, simplifies the RCU kthread wakeup logic and that also fixes a
bug that resulted in a crash.

These changes are available in the -rcu git repository at:

 git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/next

------------------>

Paul E. McKenney (8):
      rcu: Add memory barriers
      rcu: Remove old memory barriers from rcu_process_callbacks()
      rcu: Don't do reschedule unless in irq
      rcu: Make rcu_enter_nohz() pay attention to nesting
      rcu: Decrease memory-barrier usage based on semi-formal proof
      rcu: Avoid build error for third-party modules
      atomic: Add atomic_or()
      rcu: Avoid acquiring rcu_node locks in timer functions

Peter Zijlstra (1):
      rcu: Remove waitqueue usage for cpu, node, and boost kthreads

 Documentation/RCU/trace.txt |   17 ++---
 include/linux/atomic.h      |   13 ++++
 include/linux/rcupdate.h    |    5 +-
 kernel/rcutree.c            |  162 +++++++++++++++++--------------------------
 kernel/rcutree.h            |   30 ++++----
 kernel/rcutree_plugin.h     |   23 +-----
 kernel/rcutree_trace.c      |   12 ++--
 7 files changed, 112 insertions(+), 150 deletions(-)
