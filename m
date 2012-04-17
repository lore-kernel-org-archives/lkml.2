Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab2DQUhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 16:37:35 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47837 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab2DQUhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 16:37:31 -0400
From: Richard Weinberger <richard@nod.at>
To: user-mode-linux-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 4/4] irq: Remove irq_chip->release()
Date: Tue, 17 Apr 2012 22:37:16 +0200
Message-Id: <1334695036-19977-4-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1334695036-19977-1-git-send-email-richard@nod.at>
References: <1334695036-19977-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As it's only user (UML) does no longer need it we can get
rid of it.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 include/linux/irq.h |    5 -----
 kernel/irq/manage.c |    6 ------
 2 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 7810406..76c5eb4 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -328,11 +328,6 @@ struct irq_chip {
 	void		(*irq_print_chip)(struct irq_data *data, struct seq_file *p);
 
 	unsigned long	flags;
-
-	/* Currently used only by UML, might disappear one day.*/
-#ifdef CONFIG_IRQ_RELEASE_METHOD
-	void		(*release)(unsigned int irq, void *dev_id);
-#endif
 };
 
 /*
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 89a3ea8..9b7f68a 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1204,12 +1204,6 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 	/* Found it - now remove it from the list of entries: */
 	*action_ptr = action->next;
 
-	/* Currently used only by UML, might disappear one day: */
-#ifdef CONFIG_IRQ_RELEASE_METHOD
-	if (desc->irq_data.chip->release)
-		desc->irq_data.chip->release(irq, dev_id);
-#endif
-
 	/* If this was the last handler, shut down the IRQ line: */
 	if (!desc->action)
 		irq_shutdown(desc);
-- 
1.7.7.3

