Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab2DRNkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:40:43 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:54105 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753340Ab2DRNkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 09:40:39 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: <linux-kernel@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] irqdomain: print a warning if domains contain IRQ 0
Date: Wed, 18 Apr 2012 15:40:20 +0200
Message-ID: <1334756420-12019-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Some of the clients using IRQ domains from the ARM VIC
(arch/arm/common/vic.c) don't know that their (hardware) IRQ 0
is silently ignored by the IRQ core, they will just notice
that they're not getting this IRQ anymore. So print a warning
if a domain contains IRQ 0 (NO_IRQ) so we get some noise about
it atleast.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 kernel/irq/irqdomain.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 0e0ba5f..1444454 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -136,8 +136,10 @@ struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
 		int hwirq = first_hwirq + i;
 
 		/* IRQ0 gets ignored */
-		if (!irq)
+		if (!irq) {
+			pr_warn("trying to register IRQ 0 (NO_IRQ) in an irq  domain\n");
 			continue;
+		}
 
 		/* Legacy flags are left to default at this point,
 		 * one can then use irq_create_mapping() to
-- 
1.7.9.2

