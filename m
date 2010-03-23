Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab0CWAdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 20:33:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40692 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756039Ab0CWAcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 20:32:16 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, "David S. Miller" <davem@davemloft.net>,
       netdev@vger.kernel.org
Subject: [PATCH 15/18] net: Provide config option for enabling NAPI tracing
Date: Tue, 23 Mar 2010 01:32:17 +0100
Message-Id: <1269304340-25372-16-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269304340-25372-1-git-send-email-jack@suse.cz>
References: <1269304340-25372-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: "David S. Miller" <davem@davemloft.net>
CC: netdev@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/trace/events/napi.h |    2 ++
 kernel/trace/Kconfig        |    9 +++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/napi.h b/include/trace/events/napi.h
index a8989c4..70cb4dd 100644
--- a/include/trace/events/napi.h
+++ b/include/trace/events/napi.h
@@ -2,6 +2,8 @@
 #define _TRACE_NAPI_H_
 
 #include <linux/netdevice.h>
+#undef TRACE_CONFIG
+#define TRACE_CONFIG CONFIG_NAPI_TRACER
 #include <linux/tracepoint.h>
 
 DECLARE_TRACE(napi_poll,
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index a02d577..88b556c 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -508,6 +508,15 @@ config SKB_TRACER
 
 	  If unsure, say N.
 
+config NAPI_TRACER
+	bool "NAPI tracing"
+	depends on NET
+	select GENERIC_TRACER
+	help
+	  Provide tracing for NAPI functions.
+
+	  If unsure, say N.
+
 config KPROBE_EVENT
 	depends on KPROBES
 	depends on HAVE_REGS_AND_STACK_ACCESS_API
-- 
1.6.4.2

