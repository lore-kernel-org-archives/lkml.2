Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238Ab2FVPgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:36:47 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:57058 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933224Ab2FVPgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:36:43 -0400
Date: Fri, 22 Jun 2012 08:35:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: [PATCH tip/core/rcu 0/17] v2 Fixups for 3.6
Message-ID: <20120622153501.GA6626@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062215-5518-0000-0000-0000056D6931
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch series has general fixups and improvements.  This is version 2,
the prior version may be found at: https://lkml.org/lkml/2012/6/15/388.
The individual patches are as follows:

1.	Get rid of the false positives from the code that recognizes
	a CPU stall that ends just as it is detected.
2.	Consolidate open-coded initializations of RCU callback lists.
3.	Protect unsynchronized accesses to ->qlen with ACCESS_ONCE()
	to document the unsynchronized access and to prevent compiler
	mischief.
4.	Add RCU_POINTER_INITIALIZER() for static initialization to allow
	do-while formulation of the existing RCU_INIT_POINTER().
5.	Convert clever use of RCU_INIT_POINTER() for gcc-style
	initialization to RCU_POINTER_INITIALIZER().
6.	Wrap RCU_INIT_POINTER() macro in obligatory do-while.
7.	Remove extraneous parentheses from rcu_assign_keypointer()
	to allow rcu_assign_pointer() to be wrapped in do-while.
8.	Wrap rcu_assign_pointer() macro in obligatory do-while.
9.	Consolidate the identical CONFIG_TREE_PREEMPT_RCU and
	CONFIG_TINY_PREEMPT_RCU versions of __rcu_read_lock() and
	__rcu_read_unlock().
10.	Remove the old inline-function version of __kfree_rcu() and
	__is_kfree_rcu_offset().
11.	Make __call_rcu() correctly handle calls from the idle loop.
12.	Make __call_rcu() correctly handle calls from a CPU that is
	in the process of going offline.
13.	Split __call_rcu() into the part that actually deals with
	enqueueing the callback and the part that kicks RCU's
	grace-period machinery.
14.	Make RCU_TINY's rcu_is_cpu_idle() function safe for "make
	randconfig".
15.	Properly initialize the preemptible-RCU string in kernels built
	without CONFIG_RCU_FAST_NO_HZ (courtesy of Carsten Emde).
16.	Disable preemption in rcu_blocking_is_gp() to allow future
	optimization of preemptible-RCU synchronize_rcu() for single-CPU
	systems.
17.	Add a warning for CPUs going offline with RCU callbacks queued.

Changes since version 1:

o	Applied Josh Triplett review comments.
o	Added patches 15-17.

							Thanx, Paul

 b/include/linux/init_task.h |    4 -
 b/include/linux/key.h       |    2 
 b/include/linux/rcupdate.h  |    8 ++
 b/kernel/rcupdate.c         |   44 +++++++++++
 b/kernel/rcutiny.c          |    4 -
 b/kernel/rcutiny_plugin.h   |   47 ------------
 b/kernel/rcutree.c          |    4 -
 b/kernel/rcutree_plugin.h   |   47 ------------
 include/linux/rcupdate.h    |   42 ++---------
 kernel/rcutree.c            |  164 ++++++++++++++++++++++----------------------
 kernel/rcutree_plugin.h     |    1 
 11 files changed, 157 insertions(+), 210 deletions(-)

