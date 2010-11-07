Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab0KGCFN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 22:05:13 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38832 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905Ab0KGCFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 22:05:11 -0400
Date: Sat, 6 Nov 2010 19:05:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com
Subject: [PATCH RFC tip/core/rcu 0/12] preview of RCU patches for 2.6.38
Message-ID: <20101107020507.GA4974@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patchset contains RCU priority boosting for the tiny RCU
implementations and a number of fixes and cleanups.  The patches
are as follows:

1.	Add rcutorture tests to check for boosting.
2-6.	RCU priority boosting for the tiny RCU implementations.
7.	Fix a few naming holdouts from old Classic RCU.
8.	Move synchronize_sched_expedited() out of sched.c
	(from Lai Jiangshan).
9.	Simplify the RCU callback orphan/adopt code for CPU hotplug
	(from Lai Jiangshan).
10.	Update RCU tracing documentation to reflect patch #9.
11.	Fix a race condition in synchronize_sched_expedited(),
	but Tejun Heo has suggested another approach that might
	be better longer term.
12.	Make synchronize_srcu_expedited() spin for a bit to avoid
	blocking -- again, there may be a better long-term fix.

For a testing-only version of this patchset from git, please see:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/testing

							Thanx, Paul

 Documentation/RCU/trace.txt   |   12 -
 b/Documentation/RCU/trace.txt |  132 ++++++++++++-
 b/include/linux/init_task.h   |    9 
 b/include/linux/rcupdate.h    |    1 
 b/include/linux/rcutiny.h     |    8 
 b/include/linux/rcutree.h     |    1 
 b/include/linux/sched.h       |   11 -
 b/init/Kconfig                |   39 +++
 b/kernel/rcutiny.c            |   71 +++++--
 b/kernel/rcutiny_plugin.h     |   15 -
 b/kernel/rcutorture.c         |  270 ++++++++++++++++++++++++++-
 b/kernel/rcutree.c            |   81 ++------
 b/kernel/rcutree.h            |   16 -
 b/kernel/rcutree_plugin.h     |   71 +++++++
 b/kernel/rcutree_trace.c      |    8 
 b/kernel/sched.c              |   69 ------
 b/kernel/srcu.c               |    8 
 include/linux/rcupdate.h      |    1 
 include/linux/rcutiny.h       |    5 
 include/linux/rcutree.h       |    1 
 init/Kconfig                  |    1 
 kernel/rcutiny.c              |   70 +++----
 kernel/rcutiny_plugin.h       |  418 ++++++++++++++++++++++++++++++++++++++++--
 kernel/rcutree.c              |   10 -
 kernel/rcutree_plugin.h       |   28 ++
 kernel/rcutree_trace.c        |    4 
 26 files changed, 1090 insertions(+), 270 deletions(-)
