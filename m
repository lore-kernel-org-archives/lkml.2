Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab2BTRbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 12:31:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705Ab2BTRbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 12:31:07 -0500
Date: Mon, 20 Feb 2012 18:30:59 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] genirq: Fix incorrect check for forced IRQ thread handler
Message-ID: <20120220173058.GA9313@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do not want a bitwise AND between boolean operands

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 kernel/irq/manage.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index a9a9dbe..c0730ad 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -773,7 +773,7 @@ static int irq_thread(void *data)
 			struct irqaction *action);
 	int wake;
 
-	if (force_irqthreads & test_bit(IRQTF_FORCED_THREAD,
+	if (force_irqthreads && test_bit(IRQTF_FORCED_THREAD,
 					&action->thread_flags))
 		handler_fn = irq_forced_thread_fn;
 	else
-- 
1.7.7.6

