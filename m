Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab0CWAco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 20:32:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:45258 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979Ab0CWAcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 20:32:15 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-acpi@vger.kernel.org
Subject: [PATCH 13/18] acpi: Provide config option to enable power tracepoints
Date: Tue, 23 Mar 2010 01:32:15 +0100
Message-Id: <1269304340-25372-14-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269304340-25372-1-git-send-email-jack@suse.cz>
References: <1269304340-25372-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: linux-acpi@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/trace/events/power.h |    2 ++
 kernel/trace/Kconfig         |    9 +++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index c4efe9b..6d84fc1 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -1,5 +1,7 @@
 #undef TRACE_SYSTEM
+#undef TRACE_CONFIG
 #define TRACE_SYSTEM power
+#define TRACE_CONFIG CONFIG_POWER_TRACER
 
 #if !defined(_TRACE_POWER_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_POWER_H
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 787f52e..a48ff49 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -430,6 +430,15 @@ config TIMER_TRACER
 
 	  If unsure, say N
 
+config POWER_TRACER
+	bool "Trace power events"
+	select GENERIC_TRACER
+	help
+	  Provide trace points for events like changing CPU frequency,
+	  turning CPUs on / off.
+
+	  If unsure, say N
+
 config WORKQUEUE_TRACER
 	bool "Trace workqueues"
 	select GENERIC_TRACER
-- 
1.6.4.2

