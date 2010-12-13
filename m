Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab0LMMbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:31:19 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:41593 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757518Ab0LMMbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:31:17 -0500
Date: Mon, 13 Dec 2010 13:31:15 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Tony Lindgren <tony@atomide.com>
Cc: Samuel Ortiz <sameo@openedhand.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 16/20] mfd: twl4030: irq_data conversion.
Message-ID: <20101213123115.GZ15575@mail.wantstofly.org>
References: <cover.1292241952.git.buytenh@wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1292241952.git.buytenh@wantstofly.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>
---
 drivers/mfd/twl4030-irq.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index 5d3a147..e0e98ad 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -599,38 +599,38 @@ static void twl4030_sih_do_edge(struct work_struct *work)
  * completion, potentially including some re-ordering, of these requests.
  */
 
-static void twl4030_sih_mask(unsigned irq)
+static void twl4030_sih_mask(struct irq_data *d)
 {
-	struct sih_agent *sih = get_irq_chip_data(irq);
+	struct sih_agent *sih = irq_data_get_irq_chip_data(d);
 	unsigned long flags;
 
 	spin_lock_irqsave(&sih_agent_lock, flags);
-	sih->imr |= BIT(irq - sih->irq_base);
+	sih->imr |= BIT(d->irq - sih->irq_base);
 	sih->imr_change_pending = true;
 	queue_work(wq, &sih->mask_work);
 	spin_unlock_irqrestore(&sih_agent_lock, flags);
 }
 
-static void twl4030_sih_unmask(unsigned irq)
+static void twl4030_sih_unmask(struct irq_data *d)
 {
-	struct sih_agent *sih = get_irq_chip_data(irq);
+	struct sih_agent *sih = irq_data_get_irq_chip_data(d);
 	unsigned long flags;
 
 	spin_lock_irqsave(&sih_agent_lock, flags);
-	sih->imr &= ~BIT(irq - sih->irq_base);
+	sih->imr &= ~BIT(d->irq - sih->irq_base);
 	sih->imr_change_pending = true;
 	queue_work(wq, &sih->mask_work);
 	spin_unlock_irqrestore(&sih_agent_lock, flags);
 }
 
-static int twl4030_sih_set_type(unsigned irq, unsigned trigger)
+static int twl4030_sih_set_type(struct irq_data *d, unsigned trigger)
 {
-	struct sih_agent *sih = get_irq_chip_data(irq);
-	struct irq_desc *desc = irq_to_desc(irq);
+	struct sih_agent *sih = irq_data_get_irq_chip_data(d);
+	struct irq_desc *desc = irq_to_desc(d->irq);
 	unsigned long flags;
 
 	if (!desc) {
-		pr_err("twl4030: Invalid IRQ: %d\n", irq);
+		pr_err("twl4030: Invalid IRQ: %d\n", d->irq);
 		return -EINVAL;
 	}
 
@@ -641,7 +641,7 @@ static int twl4030_sih_set_type(unsigned irq, unsigned trigger)
 	if ((desc->status & IRQ_TYPE_SENSE_MASK) != trigger) {
 		desc->status &= ~IRQ_TYPE_SENSE_MASK;
 		desc->status |= trigger;
-		sih->edge_change |= BIT(irq - sih->irq_base);
+		sih->edge_change |= BIT(d->irq - sih->irq_base);
 		queue_work(wq, &sih->edge_work);
 	}
 	spin_unlock_irqrestore(&sih_agent_lock, flags);
@@ -650,9 +650,9 @@ static int twl4030_sih_set_type(unsigned irq, unsigned trigger)
 
 static struct irq_chip twl4030_sih_irq_chip = {
 	.name		= "twl4030",
-	.mask		= twl4030_sih_mask,
-	.unmask		= twl4030_sih_unmask,
-	.set_type	= twl4030_sih_set_type,
+	.irq_mask	= twl4030_sih_mask,
+	.irq_unmask	= twl4030_sih_unmask,
+	.irq_set_type	= twl4030_sih_set_type,
 };
 
 /*----------------------------------------------------------------------*/
-- 
1.7.1

