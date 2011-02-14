Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680Ab1BNSlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:41:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:38337 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050Ab1BNSlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:41:06 -0500
Date: Mon, 14 Feb 2011 18:40:29 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com, hpa@zytor.com,
        mingo@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, jdike@addtoit.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        tglx@linutronix.de
In-Reply-To: <20110206224515.224027758@linutronix.de>
References: <20110206224515.224027758@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:um/irq] um: Convert irq_chips to new functions
Message-ID: <tip-1d119aa06fb2b2608151a162f15c480d46694b65@git.kernel.org>
Git-Commit-ID: 1d119aa06fb2b2608151a162f15c480d46694b65
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Feb 2011 18:40:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1d119aa06fb2b2608151a162f15c480d46694b65
Gitweb:     http://git.kernel.org/tip/1d119aa06fb2b2608151a162f15c480d46694b65
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 6 Feb 2011 22:45:34 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 14 Feb 2011 19:37:39 +0100

um: Convert irq_chips to new functions

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <20110206224515.224027758@linutronix.de>
---
 arch/um/kernel/irq.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/um/kernel/irq.c b/arch/um/kernel/irq.c
index c916748..f771b85 100644
--- a/arch/um/kernel/irq.c
+++ b/arch/um/kernel/irq.c
@@ -360,10 +360,10 @@ EXPORT_SYMBOL(um_request_irq);
 EXPORT_SYMBOL(reactivate_fd);
 
 /*
- * irq_chip must define (startup || enable) &&
- * (shutdown || disable) && end
+ * irq_chip must define at least enable/disable and ack when
+ * the edge handler is used.
  */
-static void dummy(unsigned int irq)
+static void dummy(struct irq_data *d)
 {
 }
 
@@ -371,18 +371,17 @@ static void dummy(unsigned int irq)
 static struct irq_chip normal_irq_type = {
 	.name = "SIGIO",
 	.release = free_irq_by_irq_and_dev,
-	.disable = dummy,
-	.enable = dummy,
-	.ack = dummy,
+	.irq_disable = dummy,
+	.irq_enable = dummy,
+	.irq_ack = dummy,
 };
 
 static struct irq_chip SIGVTALRM_irq_type = {
 	.name = "SIGVTALRM",
 	.release = free_irq_by_irq_and_dev,
-	.shutdown = dummy, /* never called */
-	.disable = dummy,
-	.enable = dummy,
-	.ack = dummy,
+	.irq_disable = dummy,
+	.irq_enable = dummy,
+	.irq_ack = dummy,
 };
 
 void __init init_IRQ(void)
