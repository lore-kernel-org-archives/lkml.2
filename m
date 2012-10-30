Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964911Ab2J3QzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:55:08 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:43253 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934021Ab2J3QzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:55:00 -0400
Date: Tue, 30 Oct 2012 09:54:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: [PATCH tip/core/rcu 0/7] CPU hotplug changes for 3.8
Message-ID: <20121030165415.GA25438@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103016-5406-0000-0000-0000018E71F7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch series provides further updates to RCU's interaction with
CPU hotplug.  The individual patches are as follows:

1.	Fix an obsolete comment describing ->onofflock.
2.	Make rcutorture print the errno from cpu_down() failure if
	the "verbose" module parameter is specified.
3.	Make _cpu_down() use stop_cpus() instead of __stop_machine().
4.	Rename ->onofflock to ->orphan_lock to correctly indicate this
	lock's current scope.
5.	Avoid counter wrap in synchronize_sched_expedited().
6.	Move synchronize_sched_expedited() from global variables to
	the rcu_state structure.
7.	Instrument synchronize_rcu_expedited() for debugfs tracing.

							Thanx, Paul

 b/kernel/cpu.c            |    9 ++-
 b/kernel/rcutorture.c     |    9 +++
 b/kernel/rcutree.c        |    4 -
 b/kernel/rcutree.h        |    7 +-
 b/kernel/rcutree_plugin.h |    3 -
 kernel/rcutree.c          |  112 ++++++++++++++++++++++++++++++----------------
 kernel/rcutree.h          |   12 ++++
 7 files changed, 108 insertions(+), 48 deletions(-)

