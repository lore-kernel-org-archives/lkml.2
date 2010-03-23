Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab0CWAdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 20:33:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756006Ab0CWAcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 20:32:15 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>
Subject: [PATCH 18/18] Create config option for enabling IRQ tracepoints
Date: Tue, 23 Mar 2010 01:32:20 +0100
Message-Id: <1269304340-25372-19-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269304340-25372-1-git-send-email-jack@suse.cz>
References: <1269304340-25372-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/trace/events/irq.h |    2 ++
 kernel/trace/Kconfig       |    6 ++++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index 0e4cfb6..dd9cdb7 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -1,5 +1,7 @@
 #undef TRACE_SYSTEM
+#undef TRACE_CONFIG
 #define TRACE_SYSTEM irq
+#define TRACE_CONFIG CONFIG_IRQ_TRACER
 
 #if !defined(_TRACE_IRQ_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_IRQ_H
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index abcd529..7893ea4 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -152,6 +152,10 @@ config FUNCTION_GRAPH_TRACER
 	  address on the current task structure into a stack of calls.
 
 
+# Config option to determine whether IRQ tracepoins should be compiled
+config IRQ_TRACER
+       bool
+
 config IRQSOFF_TRACER
 	bool "Interrupts-off Latency Tracer"
 	default n
@@ -161,6 +165,7 @@ config IRQSOFF_TRACER
 	select GENERIC_TRACER
 	select TRACER_MAX_TRACE
 	select RING_BUFFER_ALLOW_SWAP
+	select IRQ_TRACER
 	help
 	  This option measures the time spent in irqs-off critical
 	  sections, with microsecond accuracy.
@@ -183,6 +188,7 @@ config PREEMPT_TRACER
 	select GENERIC_TRACER
 	select TRACER_MAX_TRACE
 	select RING_BUFFER_ALLOW_SWAP
+	select IRQ_TRACER
 	help
 	  This option measures the time spent in preemption-off critical
 	  sections, with microsecond accuracy.
-- 
1.6.4.2

