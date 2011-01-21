Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab1AUPHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:07:23 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58420 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab1AUPHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:07:20 -0500
From: Borislav Petkov <bp@amd64.org>
To: <peterz@infradead.org>, <mingo@elte.hu>
Cc: <tony.luck@intel.com>, <acme@infradead.org>, <rostedt@goodmis.org>,
        <fweisbec@gmail.com>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 01/12] perf: Start the massive restructuring
Date: Fri, 21 Jan 2011 16:09:24 +0100
Message-Id: <1295622575-18607-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1295622575-18607-1-git-send-email-bp@amd64.org>
References: <1295622575-18607-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

mv kernel/perf_event.c -> kernel/events/core.c. From there, all other
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
index 0b5ff08..e9d9deb 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -21,7 +21,6 @@ CFLAGS_REMOVE_mutex-debug.o = -pg
 CFLAGS_REMOVE_rtmutex-debug.o = -pg
 CFLAGS_REMOVE_cgroup-debug.o = -pg
 CFLAGS_REMOVE_sched_clock.o = -pg
-CFLAGS_REMOVE_perf_event.o = -pg
 CFLAGS_REMOVE_irq_work.o = -pg
 endif
 
@@ -102,7 +101,9 @@ obj-$(CONFIG_X86_DS) += trace/
 obj-$(CONFIG_RING_BUFFER) += trace/
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

