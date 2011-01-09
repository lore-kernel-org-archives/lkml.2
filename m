Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab1AIVNd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 16:13:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:53835 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884Ab1AIVNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 16:13:22 -0500
Date: Sun, 9 Jan 2011 21:12:04 GMT
From: tip-bot for Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        mathieu.desnoyers@efficios.com, rostedt@goodmis.org,
        arjan@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, arjan@linux.intel.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20101028153117.GA4051@Krystal>
References: <20101028153117.GA4051@Krystal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing: Fix TRACE_EVENT power tracepoint creation
Message-ID: <tip-870915e047a2da695be118d32dd5a900f0c3e933@git.kernel.org>
Git-Commit-ID: 870915e047a2da695be118d32dd5a900f0c3e933
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 09 Jan 2011 21:12:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  870915e047a2da695be118d32dd5a900f0c3e933
Gitweb:     http://git.kernel.org/tip/870915e047a2da695be118d32dd5a900f0c3e933
Author:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
AuthorDate: Thu, 28 Oct 2010 11:31:17 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 7 Jan 2011 23:26:29 -0500

tracing: Fix TRACE_EVENT power tracepoint creation

DEFINE_TRACE should also exist when CONFIG_EVENT_TRACING=n. Otherwise, setting
only TRACEPOINTS=y is broken.

Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
LKML-Reference: <20101028153117.GA4051@Krystal>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/Makefile       |    1 +
 kernel/trace/Makefile |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index 0b5ff08..e0f2831 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -100,6 +100,7 @@ obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_X86_DS) += trace/
 obj-$(CONFIG_RING_BUFFER) += trace/
+obj-$(CONFIG_TRACEPOINTS) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
 obj-$(CONFIG_IRQ_WORK) += irq_work.o
 obj-$(CONFIG_PERF_EVENTS) += perf_event.o
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 53f3381..761c510 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -52,7 +52,7 @@ obj-$(CONFIG_EVENT_TRACING) += trace_event_perf.o
 endif
 obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
 obj-$(CONFIG_KPROBE_EVENT) += trace_kprobe.o
-obj-$(CONFIG_EVENT_TRACING) += power-traces.o
+obj-$(CONFIG_TRACEPOINTS) += power-traces.o
 ifeq ($(CONFIG_TRACING),y)
 obj-$(CONFIG_KGDB_KDB) += trace_kdb.o
 endif
