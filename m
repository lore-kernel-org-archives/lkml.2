Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab1KOU1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 15:27:47 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53609 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757394Ab1KOU1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 15:27:46 -0500
Date: Tue, 15 Nov 2011 12:27:36 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: [PATCH tip/core/rcu 0/9] Preview of additional RCU changes for 3.3
Message-ID: <20111115202736.GA11030@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11111520-3534-0000-0000-000001F63057
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patchset is in addition to the set previously posted (see
https://lkml.org/lkml/2011/11/2/363).  This new set permits the
reworked RCU_FAST_NO_HZ code to be used from TREE_PREEMPT_RCU,
allows rcutorture to shut down the system after a fixed time
period (useful for KVM-based testing), adds an API to
replace the "->pid == 0" discussed in response to the earlier
patch set, and applies this API where applicable.  The patches are
as follows:

1.	Update the RCU_FAST_NO_HZ config definition to allow it to
	be used in TREE_PREEMPT_RCU builds, since that is now legal.
2.	Add a module parameter that permit rcutorture to shut down the
	system cleanly after the test has run for the specified time.
3.	Add a module parameter to allow rcutorture start running
	as soon as it is initialized.
4.	Add is_idle_task() API to replace open-coded tests of ->pid
	against zero.
5-9.	Apply the new is_idle_task() API where it makes sense.

For a testing-only version of this patchset from git, please see the
following subject-to-rebase branch:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/dev

							Thanx, Paul

------------------------------------------------------------------------

 b/Documentation/RCU/torture.txt  |    5 +++
 b/arch/sparc/kernel/setup_32.c   |    2 -
 b/arch/tile/mm/fault.c           |    4 +-
 b/include/linux/sched.h          |    1 
 b/init/Kconfig                   |   10 +++---
 b/kernel/debug/kdb/kdb_support.c |    2 -
 b/kernel/events/core.c           |    2 -
 b/kernel/rcutiny.c               |    4 +-
 b/kernel/rcutorture.c            |   62 ++++++++++++++++++++++++++++++++++++---
 b/kernel/rcutree.c               |    4 +-
 b/kernel/sched.c                 |    9 +++++
 kernel/rcutorture.c              |    2 +
 12 files changed, 89 insertions(+), 18 deletions(-)

