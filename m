Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242Ab0D3TIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:08:53 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:54558 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934274Ab0D3TI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 15:08:26 -0400
X-Greylist: delayed 3582 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Apr 2010 15:08:26 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=olAXveFj2S3M0AfbooiKqb0fU7taN1tjosYo++y2CrA3i9z+Bc0sumQ07zhLnT7HzR
         RabrA6I6BQyTnCNFKdj3G91gR+mrfO1/Uo+e8JbDMNxPDfq4/w6qUWp/TXO9VReiqDAC
         sKAGd/hgvSzDP3hPudm83SuIfBb8xRQ3TTzpE=
Date: Thu, 29 Apr 2010 20:39:22 +0200 (CEST)
From: John Kacur <jkacur@gmail.com>
X-X-Sender: jkacur@localhost
To: Thomas Gleixner <tglx@linutronix.de>
cc: lkml <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: [PATCH] rt: Remove irrelevant CONFIGS from reminder block.
In-Reply-To: <1272483267-10900-1-git-send-email-jkacur@redhat.com>
Message-ID: <alpine.LFD.2.00.1004292037080.12420@localhost>
References: <1272483267-10900-1-git-send-email-jkacur@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas: this should fix the accounting for the FUNCTION_TRACER that was 
incorrect in the previous version of the patch.

Thanks

>From 93805bbedd83bf34466e738a6addccb44735ed20 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Wed, 28 Apr 2010 21:25:14 +0200
Subject: [PATCH] rt: Remove irrelevant CONFIGS from reminder block.
Cc: Thomas Gleixner <tglx@linutronix.de>,
    Steven Rostedt <rostedt@goodmis.org>,
    Clark Williams <williams@redhat.com>

- remove CONFIGS that do not have an impact to -rt from the reminder block.
- reformat DEBUG_COUNT so that it is more easily human readable.
- correct CONFIG_FTRACE to CONFIG_FUNCTION_TRACER.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 init/main.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/init/main.c b/init/main.c
index 592c16a..d4b3bf5 100644
--- a/init/main.c
+++ b/init/main.c
@@ -908,7 +908,17 @@ static int __init kernel_init(void * unused)
 	WARN_ON(irqs_disabled());
 #endif
 
-#define DEBUG_COUNT (defined(CONFIG_DEBUG_RT_MUTEXES) + defined(CONFIG_IRQSOFF_TRACER) + defined(CONFIG_PREEMPT_TRACER) + defined(CONFIG_STACK_TRACER) + defined(CONFIG_INTERRUPT_OFF_HIST) + defined(CONFIG_PREEMPT_OFF_HIST) + defined(CONFIG_WAKEUP_LATENCY_HIST) + defined(CONFIG_DEBUG_SLAB) + defined(CONFIG_DEBUG_PAGEALLOC) + defined(CONFIG_LOCKDEP) + (defined(CONFIG_FTRACE) - defined(CONFIG_FTRACE_MCOUNT_RECORD)))
+#define DEBUG_COUNT	(				\
+		defined(CONFIG_DEBUG_RT_MUTEXES) +	\
+		defined(CONFIG_IRQSOFF_TRACER) +	\
+		defined(CONFIG_PREEMPT_TRACER) +	\
+		defined(CONFIG_INTERRUPT_OFF_HIST) +	\
+		defined(CONFIG_PREEMPT_OFF_HIST) +	\
+		defined(CONFIG_DEBUG_SLAB) +		\
+		defined(CONFIG_PREEMPT_OFF_HIST) +	\
+		defined(CONFIG_LOCKDEP) +		\
+		(defined(CONFIG_FUNCTION_TRACER) -	\
+		 defined(CONFIG_FTRACE_MCOUNT_RECORD)))
 
 #if DEBUG_COUNT > 0
 	printk(KERN_ERR "*****************************************************************************\n");
@@ -928,11 +938,8 @@ static int __init kernel_init(void * unused)
 #ifdef CONFIG_PREEMPT_TRACER
 	printk(KERN_ERR "*        CONFIG_PREEMPT_TRACER                                              *\n");
 #endif
-#ifdef CONFIG_STACK_TRACER
-	printk(KERN_ERR "*        CONFIG_STACK_TRACER                                                *\n");
-#endif
-#if defined(CONFIG_FTRACE) && !defined(CONFIG_FTRACE_MCOUNT_RECORD)
-	printk(KERN_ERR "*        CONFIG_FTRACE                                                      *\n");
+#if defined(CONFIG_FUNCTION_TRACER) && !defined(CONFIG_FTRACE_MCOUNT_RECORD)
+	printk(KERN_ERR "*        CONFIG_FUNCTION_TRACER                                              *\n");
 #endif
 #ifdef CONFIG_INTERRUPT_OFF_HIST
 	printk(KERN_ERR "*        CONFIG_INTERRUPT_OFF_HIST                                          *\n");
@@ -940,9 +947,6 @@ static int __init kernel_init(void * unused)
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


