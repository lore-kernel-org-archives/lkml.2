Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab0CWAcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 20:32:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:45255 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911Ab0CWAcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 20:32:14 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 08/18] lockdep: Provide config option for enabling lock tracepoints
Date: Tue, 23 Mar 2010 01:32:10 +0100
Message-Id: <1269304340-25372-9-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269304340-25372-1-git-send-email-jack@suse.cz>
References: <1269304340-25372-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/trace/events/lock.h |    2 ++
 kernel/trace/Kconfig        |    9 +++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
index 5c1dcfc..a1836e5 100644
--- a/include/trace/events/lock.h
+++ b/include/trace/events/lock.h
@@ -1,5 +1,7 @@
 #undef TRACE_SYSTEM
+#undef TRACE_CONFIG
 #define TRACE_SYSTEM lock
+#define TRACE_CONFIG CONFIG_LOCK_TRACER
 
 #if !defined(_TRACE_LOCK_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_LOCK_H
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index e696314..ac63423 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -402,6 +402,15 @@ config KMEMTRACE
 
 	  If unsure, say N.
 
+config LOCK_TRACER
+	bool "Trace lock operations"
+	depends on LOCKDEP
+	select GENERIC_TRACER
+	help
+	  Provide trace points for acquisition and release of locks.
+
+	  If unsure, say N
+
 config WORKQUEUE_TRACER
 	bool "Trace workqueues"
 	select GENERIC_TRACER
-- 
1.6.4.2

