Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab2AWVIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 16:08:07 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51426 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab2AWVIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 16:08:05 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org, Milton Miller <miltonm@bga.com>,
        benh@kernel.crashing.org, Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFCv2 02/14] dt: Make irqdomain less verbose
Date: Mon, 23 Jan 2012 14:07:38 -0700
Message-Id: <1327352870-14687-3-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327352870-14687-1-git-send-email-grant.likely@secretlab.ca>
References: <1327352870-14687-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It printk's too much.  Drop some output.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/irqdomain.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 1f9e265..cc2cd43 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -170,13 +170,11 @@ void irq_domain_generate_simple(const struct of_device_id *match,
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

