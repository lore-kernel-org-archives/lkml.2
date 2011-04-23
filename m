Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab1DWQ27 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 12:28:59 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:35013 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab1DWQ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 12:28:55 -0400
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 01/18] perf: Start the restructuring
Date: Sat, 23 Apr 2011 18:28:03 +0200
Message-Id: <1303576100-425-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1303576100-425-1-git-send-email-bp@amd64.org>
References: <1303576100-425-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

mv kernel/perf_event.c -> kernel/events/core.c. From there, all further
sensible splitting can happen.

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

