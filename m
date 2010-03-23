Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab0CWAdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 20:33:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40689 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755996Ab0CWAcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 20:32:15 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, kvm@vger.kernel.org
Subject: [PATCH 17/18] kvm: Provide config option for enabling KVM trace events
Date: Tue, 23 Mar 2010 01:32:19 +0100
Message-Id: <1269304340-25372-18-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269304340-25372-1-git-send-email-jack@suse.cz>
References: <1269304340-25372-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: kvm@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/trace/events/kvm.h |    2 ++
 kernel/trace/Kconfig       |    9 +++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index b17d49d..c85908c 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -1,6 +1,8 @@
 #if !defined(_TRACE_KVM_MAIN_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_KVM_MAIN_H
 
+#undef TRACE_CONFIG
+#define TRACE_CONFIG CONFIG_KVM_TRACER
 #include <linux/tracepoint.h>
 
 #undef TRACE_SYSTEM
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 88b556c..abcd529 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -517,6 +517,15 @@ config NAPI_TRACER
 
 	  If unsure, say N.
 
+config KVM_TRACER
+	bool "KVM tracing"
+	depends on KVM
+	select GENERIC_TRACER
+	help
+	  Trace lots of various events inside KVM.
+
+	  If unsure, say N.
+
 config KPROBE_EVENT
 	depends on KPROBES
 	depends on HAVE_REGS_AND_STACK_ACCESS_API
-- 
1.6.4.2

