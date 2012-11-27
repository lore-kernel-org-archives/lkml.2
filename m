Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab2K0AVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 19:21:09 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:49232 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751789Ab2K0AVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 19:21:08 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] irqdomain: stop screaming about preallocated irqdescs
Date: Tue, 27 Nov 2012 01:20:32 +0100
Message-ID: <1353975632-1327-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

In the simple irqdomain: don't shout warnings to the user,
there is no point. An informational print is sufficient.

Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 kernel/irq/irqdomain.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 4e69e24..96f3a1d 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -177,8 +177,8 @@ struct irq_domain *irq_domain_add_simple(struct device_node *of_node,
 			irq_base = irq_alloc_descs(first_irq, first_irq, size,
 						   of_node_to_nid(of_node));
 			if (irq_base < 0) {
-				WARN(1, "Cannot allocate irq_descs @ IRQ%d, assuming pre-allocated\n",
-				     first_irq);
+				pr_info("Cannot allocate irq_descs @ IRQ%d, assuming pre-allocated\n",
+					first_irq);
 				irq_base = first_irq;
 			}
 		} else
-- 
1.7.11.3

