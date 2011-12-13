Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab1LMAmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 19:42:09 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:47145 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab1LMAmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 19:42:05 -0500
Date: Mon, 12 Dec 2011 16:41:44 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: [PATCH tip/core/rcu 0/6] Preview of fifth set of RCU changes for 3.3
Message-ID: <20111213004144.GA32120@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11121300-3352-0000-0000-000001524FC9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patchset adds to the earlier sets:

	https://lkml.org/lkml/2011/11/2/363
	https://lkml.org/lkml/2011/11/15/302
	https://lkml.org/lkml/2011/11/28/588
	https://lkml.org/lkml/2011/12/3/77

This fifth set adds rcutorture tests for the recently added
srcu_read_lock_raw(), additional tracing to further evaluate
RCU_FAST_NO_HZ, addition of an export to assist with rcutorture testing,
bug fixes, and documentation.  The patches are as follows:

1.	Add rcutorture tests for srcu_read_lock_raw().
2.	Add tracing to further validate RCU_FAST_NO_HZ by giving more
	information on RCU's state at the time it decides to stop
	invoking callbacks.
3.	Add the 2010 RCU API LWN article to the RCU documentation
	(courtesy of Kees Cook).
4.	Revert patch that permitted rtmutex acquisition with interrupts
	disabled.  Per LKML discussions (https://lkml.org/lkml/2011/12/5/63),
	it was decided to illegalize IRQ-disable code sections that
	partially overlap with RCU read-side critical sections.  Code
	to enforce this illegalization is in progress.
5.	Add ACCESS_ONCE() to rcu_boost() return value.
6.	Export cpu_up() so that rcutorture can exercise CPU hotplug
	and RCU when rcutorture is built as a module.

For a testing-only version of this patchset from git, please see the
following subject-to-rebase branch, based on 3.2-rc5:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next

							Thanx, Paul

------------------------------------------------------------------------

 b/Documentation/RCU/whatisRCU.txt |    1 +
 b/include/trace/events/rcu.h      |   38 +++++++++++++++++++++++++++++---------
 b/kernel/cpu.c                    |    1 +
 b/kernel/rcutiny.c                |   10 ++++++++--
 b/kernel/rcutiny_plugin.h         |   25 +++++++++++++++++++++++++
 b/kernel/rcutorture.c             |   26 +++++++++++++++++++++++++-
 b/kernel/rcutree.c                |    8 ++++++--
 b/kernel/rcutree_plugin.h         |    5 -----
 b/kernel/rtmutex.c                |    8 --------
 kernel/rcutiny_plugin.h           |    4 ++--
 kernel/rcutree_plugin.h           |    3 ++-
 11 files changed, 99 insertions(+), 30 deletions(-)

