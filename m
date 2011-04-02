Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab1DBLj4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 07:39:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306Ab1DBLjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 07:39:55 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Xiaotian Feng <dfeng@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] genirq: fix cpumask leak in __setup_irq()
Date: Sat,  2 Apr 2011 19:39:35 +0800
Message-Id: <1301744375-6812-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The allocated cpumask should be freed in __setup_irq().

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 12a80fd..07c1611 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1051,6 +1051,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	register_irq_proc(irq, desc);
 	new->dir = NULL;
 	register_handler_proc(irq, new);
+	free_cpumask_var(mask);
 
 	return 0;
 
-- 
1.7.1

