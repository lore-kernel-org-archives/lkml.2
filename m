Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746Ab2KBNZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 09:25:04 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:53564 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab2KBNZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 09:25:02 -0400
From: anish kumar <anish198519851985@gmail.com>
To: rostedt@goodmis.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        akpm@linux-foundation.org, paul.gortmaker@windriver.com,
        tglx@linutronix.de, mingo@kernel.org, fweisbec@gmail.com
Cc: anish kumar <anish198519851985@gmail.com>
Subject: [PATCH] IRQ CORE: irq_work_queue function return value not used.
Date: Fri,  2 Nov 2012 22:24:36 +0900
Message-Id: <1351862676-5426-1-git-send-email-anish198519851985@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: anish kumar <anish198519851985@gmail.com>

As no one is using the return value of irq_work_queue function
it is better to just make it void.
Signed-off-by: anish kumar <anish198519851985@gmail.com>
---
 kernel/irq_work.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index 1588e3b..a85c4b3 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -79,17 +79,17 @@ static void __irq_work_queue(struct irq_work *work)
  *
  * Can be re-enqueued while the callback is still in progress.
  */
-bool irq_work_queue(struct irq_work *work)
+void irq_work_queue(struct irq_work *work)
 {
 	if (!irq_work_claim(work)) {
 		/*
 		 * Already enqueued, can't do!
 		 */
-		return false;
+		return;
 	}
 
 	__irq_work_queue(work);
-	return true;
+	return;
 }
 EXPORT_SYMBOL_GPL(irq_work_queue);
 
-- 
1.7.1

