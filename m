Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535Ab0LTMCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 07:02:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:39209 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757457Ab0LTMCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 07:02:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,201,1291622400"; 
   d="scan'208";a="638286713"
Date: Mon, 20 Dec 2010 13:01:30 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@ericsson.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: [PATCH] mfd: Use dummy_irq_chip for tc3589x
Message-ID: <20101220120128.GD11095@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This also converts tc3589x to the new irq API.

Cc: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---

Linus, this should go through your ux500-core branch as this is where the
tc3589x rename happens.

---
 drivers/mfd/tc3589x.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
index 32291fe..112efd3 100644
--- a/drivers/mfd/tc3589x.c
+++ b/drivers/mfd/tc3589x.c
@@ -170,17 +170,6 @@ again:
 	return IRQ_HANDLED;
 }
 
-static void tc3589x_irq_dummy(unsigned int irq)
-{
-	/* No mask/unmask at this level */
-}
-
-static struct irq_chip tc3589x_irq_chip = {
-	.name	= "tc3589x",
-	.mask	= tc3589x_irq_dummy,
-	.unmask	= tc3589x_irq_dummy,
-};
-
 static int tc3589x_irq_init(struct tc3589x *tc3589x)
 {
 	int base = tc3589x->irq_base;
@@ -188,7 +177,7 @@ static int tc3589x_irq_init(struct tc3589x *tc3589x)
 
 	for (irq = base; irq < base + TC3589x_NR_INTERNAL_IRQS; irq++) {
 		set_irq_chip_data(irq, tc3589x);
-		set_irq_chip_and_handler(irq, &tc3589x_irq_chip,
+		set_irq_chip_and_handler(irq, &dummy_irq_chip,
 					 handle_edge_irq);
 		set_irq_nested_thread(irq, 1);
 #ifdef CONFIG_ARM
-- 
1.7.2.3

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
