Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab2KCI5i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 04:57:38 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52751 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab2KCI5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 04:57:35 -0400
From: anish kumar <anish198519851985@gmail.com>
To: rostedt@goodmis.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        akpm@linux-foundation.org, paul.gortmaker@windriver.com,
        tglx@linutronix.de, mingo@kernel.org, fweisbec@gmail.com
Cc: anish kumar <anish198519851985@gmail.com>
Subject: [PATCH] IRQ CORE: irq_work_queue function return value not used.
Date: Sat,  3 Nov 2012 17:57:10 +0900
Message-Id: <1351933030-1462-1-git-send-email-anish198519851985@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: anish kumar <anish198519851985@gmail.com>

As no one is using the return value of irq_work_queue function
it is better to just make it void.

Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: anish kumar <anish198519851985@gmail.com>
---
 kernel/irq_work.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index 1588e3b..4829a31 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -79,17 +79,16 @@ static void __irq_work_queue(struct irq_work *work)
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
 }
 EXPORT_SYMBOL_GPL(irq_work_queue);
 
-- 
1.7.1

