Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab0LMM3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:29:51 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:36126 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329Ab0LMM3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:29:48 -0500
Date: Mon, 13 Dec 2010 13:29:47 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 03/20] mfd: ab8500: irq_data conversion.
Message-ID: <20101213122947.GM15575@mail.wantstofly.org>
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
 drivers/mfd/ab8500-core.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index dbe1c93..0e4f17c 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -228,16 +228,16 @@ static struct abx500_ops ab8500_ops = {
 	.startup_irq_enabled = NULL,
 };
 
-static void ab8500_irq_lock(unsigned int irq)
+static void ab8500_irq_lock(struct irq_data *d)
 {
-	struct ab8500 *ab8500 = get_irq_chip_data(irq);
+	struct ab8500 *ab8500 = irq_data_get_irq_chip_data(d);
 
 	mutex_lock(&ab8500->irq_lock);
 }
 
-static void ab8500_irq_sync_unlock(unsigned int irq)
+static void ab8500_irq_sync_unlock(struct irq_data *d)
 {
-	struct ab8500 *ab8500 = get_irq_chip_data(irq);
+	struct ab8500 *ab8500 = irq_data_get_irq_chip_data(d);
 	int i;
 
 	for (i = 0; i < AB8500_NUM_IRQ_REGS; i++) {
@@ -257,20 +257,20 @@ static void ab8500_irq_sync_unlock(unsigned int irq)
 	mutex_unlock(&ab8500->irq_lock);
 }
 
-static void ab8500_irq_mask(unsigned int irq)
+static void ab8500_irq_mask(struct irq_data *d)
 {
-	struct ab8500 *ab8500 = get_irq_chip_data(irq);
-	int offset = irq - ab8500->irq_base;
+	struct ab8500 *ab8500 = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - ab8500->irq_base;
 	int index = offset / 8;
 	int mask = 1 << (offset % 8);
 
 	ab8500->mask[index] |= mask;
 }
 
-static void ab8500_irq_unmask(unsigned int irq)
+static void ab8500_irq_unmask(struct irq_data *d)
 {
-	struct ab8500 *ab8500 = get_irq_chip_data(irq);
-	int offset = irq - ab8500->irq_base;
+	struct ab8500 *ab8500 = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - ab8500->irq_base;
 	int index = offset / 8;
 	int mask = 1 << (offset % 8);
 
@@ -279,10 +279,10 @@ static void ab8500_irq_unmask(unsigned int irq)
 
 static struct irq_chip ab8500_irq_chip = {
 	.name			= "ab8500",
-	.bus_lock		= ab8500_irq_lock,
-	.bus_sync_unlock	= ab8500_irq_sync_unlock,
-	.mask			= ab8500_irq_mask,
-	.unmask			= ab8500_irq_unmask,
+	.irq_bus_lock		= ab8500_irq_lock,
+	.irq_bus_sync_unlock	= ab8500_irq_sync_unlock,
+	.irq_mask		= ab8500_irq_mask,
+	.irq_unmask		= ab8500_irq_unmask,
 };
 
 static irqreturn_t ab8500_irq(int irq, void *dev)
-- 
1.7.1

