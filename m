Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab1LLVDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 16:03:08 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64085 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab1LLVDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 16:03:03 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] dt: Make irqdomain less verbose
Date: Mon, 12 Dec 2011 14:02:49 -0700
Message-Id: <1323723769-26594-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It printk's too much.  Drop some output.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>
---

Thomas, this one is trivial.  I'll take it through the DT tree if you
don't object.

 kernel/irq/irqdomain.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 200ce83..9e3964d 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -172,13 +172,11 @@ void irq_domain_generate_simple(const struct of_device_id *match,
 				u64 phys_base, unsigned int irq_start)
 {
 	struct device_node *node;
-	pr_info("looking for phys_base=%llx, irq_start=%i\n",
+	pr_debug("looking for phys_base=%llx, irq_start=%i\n",
 		(unsigned long long) phys_base, (int) irq_start);
 	node = of_find_matching_node_by_address(NULL, match, phys_base);
 	if (node)
 		irq_domain_add_simple(node, irq_start);
-	else
-		pr_info("no node found\n");
 }
 EXPORT_SYMBOL_GPL(irq_domain_generate_simple);
 #endif /* CONFIG_OF_IRQ */
-- 
1.7.5.4

