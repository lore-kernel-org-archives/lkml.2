Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab0LMMb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:31:28 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:41606 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab0LMMbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:31:24 -0500
Date: Mon, 13 Dec 2010 13:31:23 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 19/20] mfd: wm8350: irq_data conversion.
Message-ID: <20101213123123.GC15575@mail.wantstofly.org>
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
 drivers/mfd/wm8350-irq.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/wm8350-irq.c b/drivers/mfd/wm8350-irq.c
index f56c9ad..442cda6 100644
--- a/drivers/mfd/wm8350-irq.c
+++ b/drivers/mfd/wm8350-irq.c
@@ -417,16 +417,16 @@ static irqreturn_t wm8350_irq(int irq, void *irq_data)
 	return IRQ_HANDLED;
 }
 
-static void wm8350_irq_lock(unsigned int irq)
+static void wm8350_irq_lock(struct irq_data *d)
 {
-	struct wm8350 *wm8350 = get_irq_chip_data(irq);
+	struct wm8350 *wm8350 = irq_data_get_irq_chip_data(d);
 
 	mutex_lock(&wm8350->irq_lock);
 }
 
-static void wm8350_irq_sync_unlock(unsigned int irq)
+static void wm8350_irq_sync_unlock(struct irq_data *d)
 {
-	struct wm8350 *wm8350 = get_irq_chip_data(irq);
+	struct wm8350 *wm8350 = irq_data_get_irq_chip_data(d);
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(wm8350->irq_masks); i++) {
@@ -442,28 +442,28 @@ static void wm8350_irq_sync_unlock(unsigned int irq)
 	mutex_unlock(&wm8350->irq_lock);
 }
 
-static void wm8350_irq_enable(unsigned int irq)
+static void wm8350_irq_enable(struct irq_data *d)
 {
-	struct wm8350 *wm8350 = get_irq_chip_data(irq);
-	struct wm8350_irq_data *irq_data = irq_to_wm8350_irq(wm8350, irq);
+	struct wm8350 *wm8350 = irq_data_get_irq_chip_data(d);
+	struct wm8350_irq_data *irq_data = irq_to_wm8350_irq(wm8350, d->irq);
 
 	wm8350->irq_masks[irq_data->reg] &= ~irq_data->mask;
 }
 
-static void wm8350_irq_disable(unsigned int irq)
+static void wm8350_irq_disable(struct irq_data *d)
 {
-	struct wm8350 *wm8350 = get_irq_chip_data(irq);
-	struct wm8350_irq_data *irq_data = irq_to_wm8350_irq(wm8350, irq);
+	struct wm8350 *wm8350 = irq_data_get_irq_chip_data(d);
+	struct wm8350_irq_data *irq_data = irq_to_wm8350_irq(wm8350, d->irq);
 
 	wm8350->irq_masks[irq_data->reg] |= irq_data->mask;
 }
 
 static struct irq_chip wm8350_irq_chip = {
 	.name = "wm8350",
-	.bus_lock = wm8350_irq_lock,
-	.bus_sync_unlock = wm8350_irq_sync_unlock,
-	.disable = wm8350_irq_disable,
-	.enable = wm8350_irq_enable,
+	.irq_bus_lock = wm8350_irq_lock,
+	.irq_bus_sync_unlock = wm8350_irq_sync_unlock,
+	.irq_disable = wm8350_irq_disable,
+	.irq_enable = wm8350_irq_enable,
 };
 
 int wm8350_irq_init(struct wm8350 *wm8350, int irq,
-- 
1.7.1

