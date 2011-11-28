Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab1K1XcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:32:25 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40077 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755809Ab1K1XcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:32:23 -0500
Date: Mon, 28 Nov 2011 15:32:12 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mutt@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: [PATCH tip/core/rcu 0/13] Preview of yet more RCU changes for 3.3
Message-ID: <20111128233212.GA32279@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11112823-7182-0000-0000-00000045754F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patchset adds to the pair that were previously posted
earlier this month (see https://lkml.org/lkml/2011/11/2/363
and https://lkml.org/lkml/2011/11/15/302).  This third set adds
more rcutorture capabilities to ease automated testing under KVM
(randomized CPU hotplug operations), updates Frederic's user-mode nohz
RCU infrastructure, adds tracing for RCU_FAST_NO_HZ, makes a number of
improvements to RCU_FAST_NO_HZ suggested by the resulting traces, speeds
up TREE_RCU's dyntick-idle identification, and provides documentation
updates.  The patches are as follows:

1.	Add randomized CPU-hotplug capability to rcutorture.
2.	Decouple turning off the scheduler tick and informing RCU
	of CPU idleness (courtesy of Frederic Weisbecker).
3,4,12.	Documentation updates, with the addition of load/store atomicity
	guarantees (#3) being of the most widespread interest.
5.	Add event tracing for RCU_FAST_NO_HZ.
6,7,8,9,10,11,13.
	RCU_FAST_NO_HZ improvements suggested by event-tracing output.

For a testing-only version of this patchset from git, please see the
following subject-to-rebase branch:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/dev

							Thanx, Paul

------------------------------------------------------------------------

 b/Documentation/RCU/torture.txt          |    8 +
 b/Documentation/atomic_ops.txt           |   87 +++++++++++++
 b/arch/arm/kernel/process.c              |    6 
 b/arch/avr32/kernel/process.c            |    6 
 b/arch/blackfin/kernel/process.c         |    6 
 b/arch/microblaze/kernel/process.c       |    6 
 b/arch/mips/kernel/process.c             |    6 
 b/arch/openrisc/kernel/idle.c            |    6 
 b/arch/powerpc/kernel/idle.c             |   15 +-
 b/arch/powerpc/platforms/iseries/setup.c |   12 +
 b/arch/s390/kernel/process.c             |    6 
 b/arch/sh/kernel/idle.c                  |    6 
 b/arch/sparc/kernel/process_64.c         |    6 
 b/arch/tile/kernel/process.c             |    6 
 b/arch/um/kernel/process.c               |    6 
 b/arch/unicore32/kernel/process.c        |    6 
 b/arch/x86/kernel/process_32.c           |    6 
 b/include/linux/rcupdate.h               |   15 ++
 b/include/linux/srcu.h                   |    5 
 b/include/linux/tick.h                   |   47 -------
 b/include/trace/events/rcu.h             |   12 +
 b/kernel/rcutorture.c                    |  117 ++++++++++++++++-
 b/kernel/rcutree.c                       |    2 
 b/kernel/rcutree.h                       |    3 
 b/kernel/rcutree_plugin.h                |   18 ++
 b/kernel/time/tick-sched.c               |   15 +-
 include/trace/events/rcu.h               |   41 +++++-
 kernel/rcutree.c                         |   10 +
 kernel/rcutree.h                         |    2 
 kernel/rcutree_plugin.h                  |  205 ++++++++++++++++---------------
 30 files changed, 488 insertions(+), 204 deletions(-)

