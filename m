Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab2BAFUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 00:20:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36491 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab2BAFUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 00:20:04 -0500
From: Geunsik Lim <geunsik.lim@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix logical and operator at interrupt handler thread
Date: Wed,  1 Feb 2012 14:19:54 +0900
Message-Id: <1328073594-16673-1-git-send-email-geunsik.lim@gmail.com>
X-Mailer: git-send-email 1.7.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geunsik Lim <geunsik.lim@samsung.com>

'&' is a bitwise operation. (e.g: a & b )
Use '&&' and-operator instead of '&' bitwise operator.

Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
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
1.7.8.1

