Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab0CWAcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 20:32:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:45256 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755976Ab0CWAcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 20:32:15 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 12/18] timer: Provide config option for enabling timer tracepoints
Date: Tue, 23 Mar 2010 01:32:14 +0100
Message-Id: <1269304340-25372-13-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269304340-25372-1-git-send-email-jack@suse.cz>
References: <1269304340-25372-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/trace/events/timer.h |    2 ++
 kernel/trace/Kconfig         |    9 +++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index 9496b96..2737598 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -1,5 +1,7 @@
 #undef TRACE_SYSTEM
+#undef TRACE_CONFIG
 #define TRACE_SYSTEM timer
+#define TRACE_CONFIG CONFIG_TIMER_TRACER
 
 #if !defined(_TRACE_TIMER_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_TIMER_H
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index a9d7e33..787f52e 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -421,6 +421,15 @@ config MODULE_TRACER
 
 	  If unsure, say N
 
+config TIMER_TRACER
+	bool "Trace timer actions"
+	select GENERIC_TRACER
+	help
+	  Provide trace points for timer initialization, starting, expiring,
+	  and canceling.
+
+	  If unsure, say N
+
 config WORKQUEUE_TRACER
 	bool "Trace workqueues"
 	select GENERIC_TRACER
-- 
1.6.4.2

