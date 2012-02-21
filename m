Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab2BUR7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 12:59:33 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49407 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab2BUR7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 12:59:30 -0500
Date: Tue, 21 Feb 2012 09:58:11 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: [PATCH tip/core/rcu 0/4] Additional RCU commits for 3.4
Message-ID: <20120221175810.GA10708@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022117-7182-0000-0000-000000D9643A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series contains an additional four commits for 3.4.  They are all
small fixes.  This series is in addition to the set posted earlier at
https://lkml.org/lkml/2012/2/3/459, and there is some possibility that
the direct-drive SRCU at https://lkml.org/lkml/2012/2/12/117 will also
make it.  The four new patches are as follows:

1.	Fix RCU_FAST_NO_HZ to avoid continually retrying dyntick-idle
	entry if softirqs are pending.
2.	Fix RCU_FAST_NO_HZ to avoid retrying dyntick-idle entry when
	idle is re-entered after a timer was posted.  For both #1 and
	#2, the philosophy is that it is better to take a scheduling-clock
	interrupt than to burn lots of CPU in a futile attempt to process
	RCU callbacks.
3.	Eliminate spurious warnings from synchronize_sched_expedited(),
	courtesy of Hugh Dickens.
4.	Apply several fixes to rcutorture based on initial inspection.

For a testing-only version of this patchset from git, please see the
following subject-to-rebase branch:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next

							Thanx, Paul

------------------------------------------------------------------------

 b/kernel/rcutorture.c     |   19 ++++++++++++++++---
 b/kernel/rcutree.c        |    2 +-
 b/kernel/rcutree_plugin.h |    3 ++-
 kernel/rcutree.c          |    2 +-
 kernel/rcutree_plugin.h   |    2 +-
 5 files changed, 21 insertions(+), 7 deletions(-)

