Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab1EBRf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 13:35:29 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45584 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab1EBRf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 13:35:28 -0400
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/4] perf: Start the restructuring
Date: Mon,  2 May 2011 19:34:48 +0200
Message-Id: <1304357691-14354-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1304357691-14354-1-git-send-email-bp@amd64.org>
References: <1304357691-14354-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

mv kernel/perf_event.c -> kernel/events/core.c. From there, all further
sensible splitting can happen. The idea is that due to perf_event.c
becoming pretty sizable and with the advent of the marriage with ftrace,
splitting functionality into its logical parts should help speeding up
the unification and managing the complexity of the subsystem.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 kernel/Makefile                        |    5 +++--
 kernel/events/Makefile                 |    5 +++++
 kernel/{perf_event.c => events/core.c} |    0
 3 files changed, 8 insertions(+), 2 deletions(-)
 create mode 100644 kernel/events/Makefile
 rename kernel/{perf_event.c => events/core.c} (100%)

diff --git a/kernel/Makefile b/kernel/Makefile
index 85cbfb3..7981530 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -21,7 +21,6 @@ CFLAGS_REMOVE_mutex-debug.o = -pg
 CFLAGS_REMOVE_rtmutex-debug.o = -pg
 CFLAGS_REMOVE_cgroup-debug.o = -pg
 CFLAGS_REMOVE_sched_clock.o = -pg
-CFLAGS_REMOVE_perf_event.o = -pg
 CFLAGS_REMOVE_irq_work.o = -pg
 endif
 
@@ -103,7 +102,9 @@ obj-$(CONFIG_RING_BUFFER) += trace/
 obj-$(CONFIG_TRACEPOINTS) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
 obj-$(CONFIG_IRQ_WORK) += irq_work.o
-obj-$(CONFIG_PERF_EVENTS) += perf_event.o
+
+obj-$(CONFIG_PERF_EVENTS) += events/
+
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
 obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
diff --git a/kernel/events/Makefile b/kernel/events/Makefile
new file mode 100644
index 0000000..26c00e4
--- /dev/null
+++ b/kernel/events/Makefile
@@ -0,0 +1,5 @@
+ifdef CONFIG_FUNCTION_TRACER
+CFLAGS_REMOVE_core.o = -pg
+endif
+
+obj-y += core.o
diff --git a/kernel/perf_event.c b/kernel/events/core.c
similarity index 100%
rename from kernel/perf_event.c
rename to kernel/events/core.c
-- 
1.7.4.rc2

