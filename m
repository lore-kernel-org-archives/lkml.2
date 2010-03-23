Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab0CWAc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 20:32:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40681 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755906Ab0CWAcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 20:32:14 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>
Subject: [PATCH 09/18] module: Provide config option to enable tracing of module load / unload
Date: Tue, 23 Mar 2010 01:32:11 +0100
Message-Id: <1269304340-25372-10-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269304340-25372-1-git-send-email-jack@suse.cz>
References: <1269304340-25372-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/trace/events/module.h |    2 ++
 kernel/trace/Kconfig          |   10 ++++++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/module.h b/include/trace/events/module.h
index 4b0f48b..edaa505 100644
--- a/include/trace/events/module.h
+++ b/include/trace/events/module.h
@@ -1,5 +1,7 @@
 #undef TRACE_SYSTEM
+#undef TRACE_CONFIG
 #define TRACE_SYSTEM module
+#define TRACE_CONFIG CONFIG_MODULE_TRACER
 
 #if !defined(_TRACE_MODULE_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_MODULE_H
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index ac63423..a9d7e33 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -411,6 +411,16 @@ config LOCK_TRACER
 
 	  If unsure, say N
 
+config MODULE_TRACER
+	bool "Trace module loading and unloading"
+	depends on MODULES
+	select GENERIC_TRACER
+	help
+	  Provide trace point for module loading, unloading, freeing,
+	  etc.
+
+	  If unsure, say N
+
 config WORKQUEUE_TRACER
 	bool "Trace workqueues"
 	select GENERIC_TRACER
-- 
1.6.4.2

