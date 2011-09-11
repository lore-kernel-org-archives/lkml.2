Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158Ab1IKMAK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 08:00:10 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:42699 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760091Ab1IKMAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 08:00:03 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 08/28] m68k/irq: Rename setup_irq() to m68k_setup_irq() and make it static
Date: Sun, 11 Sep 2011 13:59:34 +0200
Message-Id: <1315742394-16036-9-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
References: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has nothing to do with the standard one in <linux/irq.h>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/m68k/kernel/ints.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/kernel/ints.c b/arch/m68k/kernel/ints.c
index 404d832..e68a3bd 100644
--- a/arch/m68k/kernel/ints.c
+++ b/arch/m68k/kernel/ints.c
@@ -176,7 +176,7 @@ struct irq_data *new_irq_node(void)
 	return NULL;
 }
 
-int setup_irq(unsigned int irq, struct irq_data *node)
+static int m68k_setup_irq(unsigned int irq, struct irq_data *node)
 {
 	struct irq_chip *contr;
 	struct irq_data **prev;
@@ -232,7 +232,7 @@ int request_irq(unsigned int irq,
 	node->dev_id  = dev_id;
 	node->devname = devname;
 
-	res = setup_irq(irq, node);
+	res = m68k_setup_irq(irq, node);
 	if (res)
 		node->handler = NULL;
 
-- 
1.7.0.4

