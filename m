Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab1AFCQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 21:16:12 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37294 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481Ab1AFCQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 21:16:11 -0500
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>
Subject: [PATCH 03/12] timers: Fixup allmodconfig build issue
Date: Wed,  5 Jan 2011 18:15:50 -0800
Message-Id: <1294280159-2513-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1294280159-2513-1-git-send-email-john.stultz@linaro.org>
References: <1294280159-2513-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds missed EXPORT_SYMBOL lines that cause the following build
failures with allmodconfig:
ERROR: "timerqueue_add" [drivers/rtc/rtc-core.ko] undefined!
ERROR: "timerqueue_getnext" [drivers/rtc/rtc-core.ko] undefined!
ERROR: "timerqueue_del" [drivers/rtc/rtc-core.ko] undefined!

Reported-by: Ingo Molnar <mingo@elte.hu>
Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 lib/timerqueue.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/lib/timerqueue.c b/lib/timerqueue.c
index f46de84..444b093 100644
--- a/lib/timerqueue.c
+++ b/lib/timerqueue.c
@@ -24,6 +24,7 @@
 
 #include <linux/timerqueue.h>
 #include <linux/rbtree.h>
+#include <linux/module.h>
 
 /**
  * timerqueue_add - Adds timer to timerqueue.
@@ -57,6 +58,7 @@ void timerqueue_add(struct timerqueue_head *head, struct timerqueue_node *node)
 	if (!head->next || node->expires.tv64 < head->next->expires.tv64)
 		head->next = node;
 }
+EXPORT_SYMBOL_GPL(timerqueue_add);
 
 /**
  * timerqueue_del - Removes a timer from the timerqueue.
@@ -80,7 +82,7 @@ void timerqueue_del(struct timerqueue_head *head, struct timerqueue_node *node)
 	rb_erase(&node->node, &head->head);
 	RB_CLEAR_NODE(&node->node);
 }
-
+EXPORT_SYMBOL_GPL(timerqueue_del);
 
 /**
  * timerqueue_getnext - Returns the timer with the earlies expiration time
@@ -94,7 +96,7 @@ struct timerqueue_node *timerqueue_getnext(struct timerqueue_head *head)
 {
 	return head->next;
 }
-
+EXPORT_SYMBOL_GPL(timerqueue_getnext);
 
 /**
  * timerqueue_iterate_next - Returns the timer after the provided timer
@@ -116,3 +118,4 @@ struct timerqueue_node *timerqueue_iterate_next(struct timerqueue_node *node)
 		return NULL;
 	return container_of(next, struct timerqueue_node, node);
 }
+EXPORT_SYMBOL_GPL(timerqueue_iterate_next);
-- 
1.7.3.2.146.gca209

