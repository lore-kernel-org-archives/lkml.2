Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab0D1Tek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 15:34:40 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61044 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab0D1Tej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 15:34:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=ZCGBlBSJI1I0wX0Kgy7nI+WohwyrBt+F5r0LAKm6Rs1er9uU79bG1bv4FzRYxMq3xE
         oqcBfsqrlKgGzVffUl5Fb3YNgnXucvcuafxFBFQmrK9eyjzXeHFil7pai8P4iphJ4uQE
         3LfPV4JFnNle+WpEmUCB/rs5drPlutXMWJPmI=
From: John Kacur <jkacur@redhat.com>
To: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: rt-users <linux-rt-users@vger.kernel.org>, John Kacur <jkacur@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Clark Williams <williams@redhat.com>
Subject: [PATCH] rt: Remove irrelevant CONFIGS from reminder block.
Date: Wed, 28 Apr 2010 21:34:27 +0200
Message-Id: <1272483267-10900-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- remove CONFIGS that do not have an impact to -rt from the reminder block.
- reformat DEBUG_COUNT so that it is more easily human readable.
- correct CONFIG_FTRACE to CONFIG_FUNCTION_TRACER.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 init/main.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/init/main.c b/init/main.c
index 592c16a..622fe30 100644
--- a/init/main.c
+++ b/init/main.c
@@ -908,7 +908,15 @@ static int __init kernel_init(void * unused)
 	WARN_ON(irqs_disabled());
 #endif
 
-#define DEBUG_COUNT (defined(CONFIG_DEBUG_RT_MUTEXES) + defined(CONFIG_IRQSOFF_TRACER) + defined(CONFIG_PREEMPT_TRACER) + defined(CONFIG_STACK_TRACER) + defined(CONFIG_INTERRUPT_OFF_HIST) + defined(CONFIG_PREEMPT_OFF_HIST) + defined(CONFIG_WAKEUP_LATENCY_HIST) + defined(CONFIG_DEBUG_SLAB) + defined(CONFIG_DEBUG_PAGEALLOC) + defined(CONFIG_LOCKDEP) + (defined(CONFIG_FTRACE) - defined(CONFIG_FTRACE_MCOUNT_RECORD)))
+#define DEBUG_COUNT	(defined(CONFIG_DEBUG_RT_MUTEXES) +	\
+			defined(CONFIG_IRQSOFF_TRACER) +	\
+			defined(CONFIG_PREEMPT_TRACER) +	\
+			defined(CONFIG_FUNCTION_TRACER) +	\
+			defined(CONFIG_INTERRUPT_OFF_HIST) +	\
+			defined(CONFIG_PREEMPT_OFF_HIST) +	\
+			defined(CONFIG_DEBUG_SLAB) +		\
+			defined(CONFIG_PREEMPT_OFF_HIST) +	\
+			defined(CONFIG_LOCKDEP))
 
 #if DEBUG_COUNT > 0
 	printk(KERN_ERR "*****************************************************************************\n");
@@ -928,11 +936,8 @@ static int __init kernel_init(void * unused)
 #ifdef CONFIG_PREEMPT_TRACER
 	printk(KERN_ERR "*        CONFIG_PREEMPT_TRACER                                              *\n");
 #endif
-#ifdef CONFIG_STACK_TRACER
-	printk(KERN_ERR "*        CONFIG_STACK_TRACER                                                *\n");
-#endif
 #if defined(CONFIG_FTRACE) && !defined(CONFIG_FTRACE_MCOUNT_RECORD)
-	printk(KERN_ERR "*        CONFIG_FTRACE                                                      *\n");
+	printk(KERN_ERR "*        CONFIG_FUNCTION_TRACER                                              *\n");
 #endif
 #ifdef CONFIG_INTERRUPT_OFF_HIST
 	printk(KERN_ERR "*        CONFIG_INTERRUPT_OFF_HIST                                          *\n");
@@ -940,9 +945,6 @@ static int __init kernel_init(void * unused)
 #ifdef CONFIG_PREEMPT_OFF_HIST
 	printk(KERN_ERR "*        CONFIG_PREEMPT_OFF_HIST                                            *\n");
 #endif
-#ifdef CONFIG_WAKEUP_LATENCY_HIST
-	printk(KERN_ERR "*        CONFIG_WAKEUP_LATENCY_HIST                                         *\n");
-#endif
 #ifdef CONFIG_DEBUG_SLAB
 	printk(KERN_ERR "*        CONFIG_DEBUG_SLAB                                                  *\n");
 #endif
-- 
1.6.6.1

