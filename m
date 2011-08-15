Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab1HOPyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:54:31 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51689 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab1HOPy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:54:29 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: [PATCH 32/32] nohz/cpuset: Disable under some configs
Date: Mon, 15 Aug 2011 17:52:29 +0200
Message-Id: <1313423549-27093-33-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This shows the various things that are not yet handled by
the nohz cpusets: perf events, irq work, irq time accounting.

But there are further things that have yet to be handled:
sched clock tick, runqueue clock, sched_class::task_tick(),
rq clock, cpu load, complete handling of cputimes, ...

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul E . McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
---
 init/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 7a144ad..6b6adde 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -626,7 +626,7 @@ config PROC_PID_CPUSET
 
 config CPUSETS_NO_HZ
        bool "Tickless cpusets"
-       depends on CPUSETS && HAVE_CPUSETS_NO_HZ && NO_HZ && HIGH_RES_TIMERS
+       depends on CPUSETS && HAVE_CPUSETS_NO_HZ && NO_HZ && HIGH_RES_TIMERS && !PERF_EVENTS && !PROFILING && !IRQ_WORK && !IRQ_TIME_ACCOUNTING
        help
          This options let you apply a nohz property to a cpuset such
 	 that the periodic timer tick tries to be avoided when possible on
-- 
1.7.5.4

