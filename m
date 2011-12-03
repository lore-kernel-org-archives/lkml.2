Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab1LCSfB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 13:35:01 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59806 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab1LCSey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 13:34:54 -0500
Date: Sat, 3 Dec 2011 10:34:17 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: [PATCH tip/core/rcu 0/7] Preview of fourth set of RCU changes for
 3.3
Message-ID: <20111203183417.GA18914@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11120318-5112-0000-0000-000002B3E10E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patchset adds to the earlier sets:

	https://lkml.org/lkml/2011/11/2/363
	https://lkml.org/lkml/2011/11/15/302
	https://lkml.org/lkml/2011/11/28/588

This fourth set adds more infrastructure for Frederic's user-mode nohz
work, additional improvements to RCU_FAST_NO_HZ, and a few bug fixes.
The patches are as follows:

1,2.	More support for user-mode nohz (courtesy of Frederic Weisbecker).
3.	Ignore RCU callback batch limits if the CPU is otherwise idle.
	This allows a CPU to more quickly clear a backlog of callbacks,
	and thus more quickly enter dyntick-idle mode.
4.	Adaptive dyntick-entry approach that more efficiently handles
	the various possible grace-period begin/end scenarios.
5.	Remove a redundant variable declaration.
6.	Allow rcutorture to avoid attempting to offline unhotpluggable CPUs.
7.	Fix RCU-lockdep splats involving RCU read-side critical sections
	that partially overlap irq-disable code sections (courtesy of
	Yong Zhang).

For a testing-only version of this patchset from git, please see the
following subject-to-rebase branch, based on 3.2-rc3:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/dev

							Thanx, Paul

------------------------------------------------------------------------

 b/drivers/base/cpu.c      |   12 ++++++++
 b/include/linux/cpu.h     |    1 
 b/kernel/rcutorture.c     |    4 +-
 b/kernel/rcutree.c        |   18 +++++--------
 b/kernel/rcutree.h        |    1 
 b/kernel/rcutree_plugin.h |   14 ++++++++++
 kernel/rcutree.c          |   12 ++++----
 kernel/rcutree_plugin.h   |   62 ++++++++++++++++++++++++++++++++++++----------
 8 files changed, 92 insertions(+), 32 deletions(-)

