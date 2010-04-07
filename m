Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175Ab0DGSkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 14:40:55 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:51682 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757004Ab0DGSkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 14:40:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=K4Yy3+4ry7cADTbPHsnRL0g4Bav1NWwCG2oe6U5LC020GgeoNDgo2qrvqXLCuNCIHD
         FT4vgjLb6YpWoEMx52fbRFEw6aQs5mCkuarahjCfiWPBR8Q+TmhThQmB4cdpz8vX+tWy
         EJqpAOIViTCKI9eo5HWy4jEDcot250nTO5MMg=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>,
       rt-users <linux-rt-users@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH] rt: This fixes the boot-up messages related to CONFIG_STACK_TRACER
Date: Wed,  7 Apr 2010 20:40:40 +0200
Message-Id: <1270665640-8520-2-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1270665640-8520-1-git-send-email-jkacur@redhat.com>
References: <1270665640-8520-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Summary:
- No warning is necessary for CONFIG_STACK_TRACER because it is not enabled by
default anymore.
- The reason it was put back was to fix a problem where there was an
empty REMINDER message about debug options that cause overhead. This is
properly fixed by removing CONFIG_STACK_TRACER from the DEBUG_COUNT

Revert "rt: trivial fix to REMINDER block in init/main.c"

This reverts commit 3e39399ef4a742d994570488994be93ef17d4ef5.

CONFIG_STACK_TRACER really should not be in the reminder block.
By default it is not enabled, and has negligible impact.

Signed-off-by: John Kacur <jkacur@redhat.com>

rt: Remove CONFIG_STACK_TRACER from DEBUG_COUNT

Remove CONFIG_STACK_TRACER from DEBUG_COUNT so that reminder messages
are printed correctly, and don't leave an empty reminder block for example.

Signed-off-by: John Kacur <jkacur@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
---
 init/main.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/init/main.c b/init/main.c
index 592c16a..f26cb63 100644
--- a/init/main.c
+++ b/init/main.c
@@ -908,7 +908,7 @@ static int __init kernel_init(void * unused)
 	WARN_ON(irqs_disabled());
 #endif
 
-#define DEBUG_COUNT (defined(CONFIG_DEBUG_RT_MUTEXES) + defined(CONFIG_IRQSOFF_TRACER) + defined(CONFIG_PREEMPT_TRACER) + defined(CONFIG_STACK_TRACER) + defined(CONFIG_INTERRUPT_OFF_HIST) + defined(CONFIG_PREEMPT_OFF_HIST) + defined(CONFIG_WAKEUP_LATENCY_HIST) + defined(CONFIG_DEBUG_SLAB) + defined(CONFIG_DEBUG_PAGEALLOC) + defined(CONFIG_LOCKDEP) + (defined(CONFIG_FTRACE) - defined(CONFIG_FTRACE_MCOUNT_RECORD)))
+#define DEBUG_COUNT (defined(CONFIG_DEBUG_RT_MUTEXES) + defined(CONFIG_IRQSOFF_TRACER) + defined(CONFIG_PREEMPT_TRACER) + defined(CONFIG_INTERRUPT_OFF_HIST) + defined(CONFIG_PREEMPT_OFF_HIST) + defined(CONFIG_WAKEUP_LATENCY_HIST) + defined(CONFIG_DEBUG_SLAB) + defined(CONFIG_DEBUG_PAGEALLOC) + defined(CONFIG_LOCKDEP) + (defined(CONFIG_FTRACE) - defined(CONFIG_FTRACE_MCOUNT_RECORD)))
 
 #if DEBUG_COUNT > 0
 	printk(KERN_ERR "*****************************************************************************\n");
@@ -928,9 +928,6 @@ static int __init kernel_init(void * unused)
 #ifdef CONFIG_PREEMPT_TRACER
 	printk(KERN_ERR "*        CONFIG_PREEMPT_TRACER                                              *\n");
 #endif
-#ifdef CONFIG_STACK_TRACER
-	printk(KERN_ERR "*        CONFIG_STACK_TRACER                                                *\n");
-#endif
 #if defined(CONFIG_FTRACE) && !defined(CONFIG_FTRACE_MCOUNT_RECORD)
 	printk(KERN_ERR "*        CONFIG_FTRACE                                                      *\n");
 #endif
-- 
1.6.6.1

