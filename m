Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab3AGAS6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 19:18:58 -0500
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:53908 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751454Ab3AGASz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 19:18:55 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] irqdomain: document the simple domain first_irq
Date: Mon, 7 Jan 2013 01:18:32 +0100
Message-ID: <1357517912-26053-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The first_irq needs to be zero to get a linear domain and that
comes with special semantics. We want to simplify this going
forward but some documentation never hurts.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 kernel/irq/irqdomain.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 96f3a1d..059a280 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -143,7 +143,10 @@ static unsigned int irq_domain_legacy_revmap(struct irq_domain *domain,
  * irq_domain_add_simple() - Allocate and register a simple irq_domain.
  * @of_node: pointer to interrupt controller's device tree node.
  * @size: total number of irqs in mapping
- * @first_irq: first number of irq block assigned to the domain
+ * @first_irq: first number of irq block assigned to the domain,
+ *	pass zero to assign irqs on-the-fly. This will result in a
+ *	linear IRQ domain so it is important to use irq_create_mapping()
+ *	for each used IRQ, especially when SPARSE_IRQ is enabled.
  * @ops: map/unmap domain callbacks
  * @host_data: Controller private data pointer
  *
-- 
1.7.11.3

