Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965064Ab2J3RcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:32:25 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:34308 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964876Ab2J3RcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:32:16 -0400
Date: Tue, 30 Oct 2012 10:19:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: [PATCH tip/core/rcu 0/5] Idle changes for 3.8
Message-ID: <20121030171906.GA27431@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103017-7408-0000-0000-000009C5C675
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch series contains changes to RCU's interaction with idle.
The individual patches are as follows:

1.	Remove a layer of indirection to rcu_user_hooks_switch().
	(Courtesy of Frederic Weisbecker.)
2.	Update RCU_FAST_NO_HZ help text to remove the warning about
	running on large systems.
3.	Add "rcu_expedited" boot and sysfs parameters that cause the
	kernel to substitute expedited primitives for the normal
	grace period primitives.  (Courtesy of Antti P Miettinen.)
4.	Fix a precedence error in cpu_needs_another_gp() that
	surprisingly had no effect -- but clarity is good.
5.	Fix grammar issue in RCU_USER_QS help text.  (Courtesy of
	Paul Gortmaker.)

							Thanx, Paul

 b/arch/um/drivers/mconsole_kern.c |    2 +-
 b/include/linux/rcupdate.h        |    2 ++
 b/include/linux/sched.h           |    8 --------
 b/init/Kconfig                    |   15 +++++++--------
 b/kernel/ksysfs.c                 |   18 ++++++++++++++++++
 b/kernel/rcu.h                    |    2 ++
 b/kernel/rcupdate.c               |    3 +++
 b/kernel/rcutiny_plugin.h         |    5 ++++-
 b/kernel/rcutree.c                |   12 +++++++++---
 b/kernel/rcutree_plugin.h         |    7 +++++--
 b/kernel/sched/core.c             |    2 +-
 b/kernel/srcu.c                   |    8 +++++++-
 init/Kconfig                      |    6 +++---
 kernel/rcutree.c                  |    2 +-
 14 files changed, 63 insertions(+), 29 deletions(-)

