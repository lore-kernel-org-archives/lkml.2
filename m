Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab0CXRfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:35:44 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46770 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677Ab0CXRfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:35:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=a7zuGr34JZgIdDYzkSswMEx9qyPUQvhJR+HzNc085mV0K4DVwLHpJB9t3i4mexbxoP
         zOJ/3CbXfgzk780J33d/3LppXb/t87mcUm6MGKaR3Tug5VN+cTQrPZ4G55PAQnSnrs1k
         be69jKnaSst6H/JqdPeUWyF1qy3cak2ibWgdE=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       John Kacur <jkacur@redhat.com>, Clark Williams <williams@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/2] rt: Remove CONFIG_STACK_TRACER from DEBUG_COUNT
Date: Wed, 24 Mar 2010 18:35:07 +0100
Message-Id: <1269452107-28655-3-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1269452107-28655-1-git-send-email-jkacur@redhat.com>
References: <1269452107-28655-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove CONFIG_STACK_TRACER from DEBUG_COUNT so that reminder messages
are printed correctly, and don't leave an empty reminder block for example.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 init/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/main.c b/init/main.c
index aa48b7b..17fd973 100644
--- a/init/main.c
+++ b/init/main.c
@@ -908,7 +908,7 @@ static int __init kernel_init(void * unused)
 	WARN_ON(irqs_disabled());
 #endif
 
-#define DEBUG_COUNT (defined(CONFIG_DEBUG_RT_MUTEXES) + defined(CONFIG_IRQSOFF_TRACER) + defined(CONFIG_PREEMPT_TRACER) + defined(CONFIG_STACK_TRACER) + defined(CONFIG_INTERRUPT_OFF_HIST) + defined(CONFIG_PREEMPT_OFF_HIST) + defined(CONFIG_WAKEUP_LATENCY_HIST) + defined(CONFIG_DEBUG_SLAB) + defined(CONFIG_DEBUG_PAGEALLOC) + defined(CONFIG_LOCKDEP) + (defined(CONFIG_FTRACE) - defined(CONFIG_FTRACE_MCOUNT_RECORD)))
+#define DEBUG_COUNT (defined(CONFIG_DEBUG_RT_MUTEXES) + defined(CONFIG_IRQSOFF_TRACER) + defined(CONFIG_PREEMPT_TRACER) + defined(CONFIG_INTERRUPT_OFF_HIST) + defined(CONFIG_PREEMPT_OFF_HIST) + defined(CONFIG_WAKEUP_LATENCY_HIST) + defined(CONFIG_DEBUG_SLAB) + defined(CONFIG_DEBUG_PAGEALLOC) + defined(CONFIG_LOCKDEP) + (defined(CONFIG_FTRACE) - defined(CONFIG_FTRACE_MCOUNT_RECORD)))
 
 #if DEBUG_COUNT > 0
 	printk(KERN_ERR "*****************************************************************************\n");
-- 
1.6.6.1

