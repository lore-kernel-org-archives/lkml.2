Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab0IWAuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 20:50:37 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56997 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab0IWAuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 20:50:37 -0400
Date: Wed, 22 Sep 2010 17:50:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com
Subject: [PATCH tip/core/rcu 0/8] random RCU fixes and updates
Message-ID: <20100923005033.GA22006@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patchset contains fixes for problems identified in -next testing
and some statistics and documentation updates.  The patches are as follows:

1.	Update stallwarn.txt to include stall warnings caused by
	real-time processes (yes, even in mainline kernels).
2.	Fix some performance bugs in TINY_PREEMPT_RCU.
3.	Fix an overactive rcu_bootup_announce_oddness() warning.
4.	Eliminate a redundant #ifdef (from Christian Dietrich).
5.	Fix the new sparse-aware primitives to correctly handle
	macro arguments with side effects.
6.	Fix some issues sparse found in rcutorture.c.
7.	Add some tracing data to help compute estimates of how long
	RCU callbacks are queued.
8.	Fix up the Kconfig message for PROVE_RCU_REPEATEDLY.

For a testing-only version of this patchset from git, please see:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/testing

							Thanx, Paul

 Documentation/RCU/stallwarn.txt |   18 ++++++++++++++++++
 Documentation/RCU/trace.txt     |   13 ++++++++++++-
 include/linux/rcupdate.h        |   14 +++++++++++---
 kernel/rcutiny_plugin.h         |   12 ++++++++----
 kernel/rcutorture.c             |    8 +++++---
 kernel/rcutree.c                |    3 +++
 kernel/rcutree.h                |    3 +++
 kernel/rcutree_plugin.h         |    2 +-
 kernel/rcutree_trace.c          |   10 +++++++---
 kernel/srcu.c                   |    2 --
 lib/Kconfig.debug               |    4 ++++
 11 files changed, 72 insertions(+), 17 deletions(-)
