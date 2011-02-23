Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738Ab1BWBj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 20:39:28 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47939 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755570Ab1BWBj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 20:39:27 -0500
Date: Tue, 22 Feb 2011 17:39:17 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com
Subject: [PATCH tip/core/rcu 0/14] Preview of RCU patches for 2.6.39
Message-ID: <20110223013917.GA20996@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patchset fixes a few bugs and introduces some of the infrastructure
for TREE_RCU priority boosting.  If testing goes well, TREE_RCU priority
boosting itself might make it as well.  The patches are as follows:

1.	call __rcu_read_unlock() in exit_rcu for tiny RCU to preserve
	debug state  (from Lai Jiangshan).
2.	Get rid of duplicate sched.h include from rcutorture.c
	(from Jesper Juhl).
3.	Add documentation saying which RCU flavor to choose.
4.	Remove dead code from DEBUG_OBJECTS_RCU_HEAD implementation
	(from Amerigo Wang).
5.	Document transitivity for memory barriers.
6.	Remove conditional compilation for RCU CPU stall warnings.
	(These can now be controlled by boot/module parameters.)
7.	Decrease memory-barrier usage based on semi-formal proof.
	Expedited RCU has invalidated an assumption that the old
	dyntick-idle interface depended on, and here is a fix.  I
	am still working on a lighter-weight fix, but safety first!
8.	Merge TREE_PREEPT_RCU blocked_tasks[] lists, which is a first
	step towards TREE_RCU priority boosting.
9.	Update documentation to reflect blocked_tasks[] merge.
10.	move TREE_RCU from softirq to kthread, which is a second step
	towards TREE_RCU priority boosting.

For a testing-only version of this patchset from git, please see the
following subject-to-rebase branch:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/testing

I am more confident in the first five of the above patches, which are
available at:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/next

							Thanx, Paul
