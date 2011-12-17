Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab1LQU6Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 15:58:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35976 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230Ab1LQU6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 15:58:22 -0500
Date: Sat, 17 Dec 2011 21:56:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20111217205636.GA4069@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

 Thanks,

	Ingo

------------------>
Peter Zijlstra (2):
      MAINTAINERS: Update tip.git related git trees
      sched: Fix select_idle_sibling() regression in selecting an idle SMT sibling


 MAINTAINERS         |   13 +++++++++----
 kernel/sched_fair.c |   14 ++++++++------
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4475602..9706a21 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3118,6 +3118,7 @@ F:	include/linux/hid*
 
 HIGH-RESOLUTION TIMERS, CLOCKEVENTS, DYNTICKS
 M:	Thomas Gleixner <tglx@linutronix.de>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
 S:	Maintained
 F:	Documentation/timers/
 F:	kernel/hrtimer.c
@@ -3627,7 +3628,7 @@ F:	net/irda/
 IRQ SUBSYSTEM
 M:	Thomas Gleixner <tglx@linutronix.de>
 S:	Maintained
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq/core
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/core
 F:	kernel/irq/
 
 ISAPNP
@@ -4115,7 +4116,7 @@ F:	drivers/hwmon/lm90.c
 LOCKDEP AND LOCKSTAT
 M:	Peter Zijlstra <peterz@infradead.org>
 M:	Ingo Molnar <mingo@redhat.com>
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-lockdep.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core/locking
 S:	Maintained
 F:	Documentation/lockdep*.txt
 F:	Documentation/lockstat.txt
@@ -5102,6 +5103,7 @@ M:	Peter Zijlstra <a.p.zijlstra@chello.nl>
 M:	Paul Mackerras <paulus@samba.org>
 M:	Ingo Molnar <mingo@elte.hu>
 M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf/core
 S:	Supported
 F:	kernel/events/*
 F:	include/linux/perf_event.h
@@ -5181,6 +5183,7 @@ F:	drivers/scsi/pm8001/
 
 POSIX CLOCKS and TIMERS
 M:	Thomas Gleixner <tglx@linutronix.de>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
 S:	Supported
 F:	fs/timerfd.c
 F:	include/linux/timer*
@@ -5696,6 +5699,7 @@ F:	drivers/dma/dw_dmac.c
 TIMEKEEPING, NTP
 M:	John Stultz <johnstul@us.ibm.com>
 M:	Thomas Gleixner <tglx@linutronix.de>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
 S:	Supported
 F:	include/linux/clocksource.h
 F:	include/linux/time.h
@@ -5720,6 +5724,7 @@ F:	drivers/watchdog/sc1200wdt.c
 SCHEDULER
 M:	Ingo Molnar <mingo@elte.hu>
 M:	Peter Zijlstra <peterz@infradead.org>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched/core
 S:	Maintained
 F:	kernel/sched*
 F:	include/linux/sched.h
@@ -6647,7 +6652,7 @@ TRACING
 M:	Steven Rostedt <rostedt@goodmis.org>
 M:	Frederic Weisbecker <fweisbec@gmail.com>
 M:	Ingo Molnar <mingo@redhat.com>
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf/core
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf/core
 S:	Maintained
 F:	Documentation/trace/ftrace.txt
 F:	arch/*/*/*/ftrace.h
@@ -7397,7 +7402,7 @@ M:	Thomas Gleixner <tglx@linutronix.de>
 M:	Ingo Molnar <mingo@redhat.com>
 M:	"H. Peter Anvin" <hpa@zytor.com>
 M:	x86@kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/core
 S:	Maintained
 F:	Documentation/x86/
 F:	arch/x86/
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a78ed27..8a39fa3 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2352,13 +2352,11 @@ again:
 		if (!smt && (sd->flags & SD_SHARE_CPUPOWER))
 			continue;
 
-		if (!(sd->flags & SD_SHARE_PKG_RESOURCES)) {
-			if (!smt) {
-				smt = 1;
-				goto again;
-			}
+		if (smt && !(sd->flags & SD_SHARE_CPUPOWER))
+			break;
+
+		if (!(sd->flags & SD_SHARE_PKG_RESOURCES))
 			break;
-		}
 
 		sg = sd->groups;
 		do {
@@ -2378,6 +2376,10 @@ next:
 			sg = sg->next;
 		} while (sg != sd->groups);
 	}
+	if (!smt) {
+		smt = 1;
+		goto again;
+	}
 done:
 	rcu_read_unlock();
 
