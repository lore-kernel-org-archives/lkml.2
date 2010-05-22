Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020Ab0EVTB5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 15:01:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52731 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755817Ab0EVTB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 15:01:56 -0400
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lin Ming <ming.m.lin@intel.com>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>
Subject: [PATCH 2/2] x86, mce: Make MCE tracepoint persistent event
Date: Sat, 22 May 2010 21:00:06 +0200
Message-Id: <1274554806-28216-3-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1274554806-28216-1-git-send-email-bp@alien8.de>
References: <1274554806-28216-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not-yet-signed-off-by: Borislav Petkov <bp@alien8.de>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    4 ++++
 include/trace/events/mce.h       |    1 +
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 8a6f0af..5f40726 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1668,6 +1668,10 @@ int __init mcheck_init(void)
 
 	mcheck_intel_therm_init();
 
+#ifdef CONFIG_EVENT_TRACING
+	event_mce_record.type = EVENT_PERSISTENT;
+#endif
+
 	return 0;
 }
 
diff --git a/include/trace/events/mce.h b/include/trace/events/mce.h
index 7eee778..b1ad772 100644
--- a/include/trace/events/mce.h
+++ b/include/trace/events/mce.h
@@ -5,6 +5,7 @@
 #define _TRACE_MCE_H
 
 #include <linux/ktime.h>
+#include <linux/ftrace_event.h>
 #include <linux/tracepoint.h>
 #include <asm/mce.h>
 
-- 
1.7.1

