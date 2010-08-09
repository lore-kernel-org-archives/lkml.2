Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab0HIWPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 18:15:08 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60791 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757108Ab0HIWPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 18:15:07 -0400
Date: Mon, 9 Aug 2010 15:14:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com
Subject: [PATCH tip/core/rcu 0/N] Additional RCU commits queued for 2.6.37
Message-ID: <20100809221447.GA24358@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patchset shows additional patches queued for 2.6.37, over and above
those posted at http://lkml.org/lkml/2010/7/14/334.  These are all minor
fixes, with the exception of patch #8, which adds TINY_PREEMPT_RCU.
The patches are as follows:

1.	Remove the rcu_head initialization macros (from Mathieu Desnoyers).
	This patch can move forward now that all uses of these macros
	have been removed from mainline.
2.	Update documentation to note the demise of the rcu_head
	initialization macros.
3.	Fix kernel-locking.tmpl docbook documentation, which was still
	using the now-ancient three-argument version of call_rcu().
4.	Allow RCU's CPU stall-warning messages to be controlled via sysfs.
5.	Now that TINY_RCU has been in-tree for a few releases, adjust
	the configuration so that TINY_RCU is mandatory for kernels
	built with !SMP and !PREEMPT.  Once TINY_PREEMPT_RCU has gained
	a similar level of experience, !SMP code will be eliminated
	from TREE_RCU.
6.	Allow kernels to be built such that RCU CPU stall warnings are
	suppressed at boot time.  Patch #4 above allows them to be
	manually re-enabled once the system has booted.
7.	Updates the RCU_FANOUT message to take commit cf244dc01bf68 into
	account.  This commit added a fourth level to TREE_RCU.
8.	Add TINY_PREEMPT_RCU, allowing reduced memory footprint for
	UP builds of preemptible RCU.  This is a cleaned-up version of
	the patch posted at http://lkml.org/lkml/2010/7/21/364.
9.	The "It is illegal to block while in an RCU read-side critical
	section" docbook comment was obsoleted long ago by preemptible
	RCU, so this patch brings it up to the present day.
10.	Add comments above the RCU CPU stall-warning printk()s pointing
	people at the Documentation/RCU/stallwarn.txt documentation.

For a testing-only version of this patchset from git, please see:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/testing

							Thanx, Paul

 Documentation/DocBook/kernel-locking.tmpl   |    6 
 b/Documentation/DocBook/kernel-locking.tmpl |    8 
 b/include/linux/hardirq.h                   |    2 
 b/include/linux/init_task.h                 |   10 
 b/include/linux/rcupdate.h                  |    6 
 b/include/linux/rcutiny.h                   |  126 ++++--
 b/include/linux/rcutree.h                   |    2 
 b/include/linux/sched.h                     |   10 
 b/init/Kconfig                              |    1 
 b/kernel/Makefile                           |    1 
 b/kernel/rcutiny.c                          |   33 -
 b/kernel/rcutiny_plugin.h                   |  580 +++++++++++++++++++++++++++-
 b/kernel/rcutree.c                          |    2 
 b/kernel/rcutree.h                          |    6 
 b/lib/Kconfig.debug                         |   13 
 include/linux/rcupdate.h                    |   18 
 init/Kconfig                                |   25 +
 kernel/rcutree.c                            |   14 
 18 files changed, 771 insertions(+), 92 deletions(-)
