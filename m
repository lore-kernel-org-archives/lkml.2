Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab0LMMbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:31:25 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:41601 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757548Ab0LMMbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:31:22 -0500
Date: Mon, 13 Dec 2010 13:31:21 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 18/20] mfd: wm831x: irq_data conversion.
Message-ID: <20101213123121.GB15575@mail.wantstofly.org>
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
 drivers/mfd/wm831x-irq.c |   37 +++++++++++++++++++------------------
 1 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
index 294183b..8f9f5a9 100644
--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -345,16 +345,16 @@ static inline struct wm831x_irq_data *irq_to_wm831x_irq(struct wm831x *wm831x,
 	return &wm831x_irqs[irq - wm831x->irq_base];
 }
 
-static void wm831x_irq_lock(unsigned int irq)
+static void wm831x_irq_lock(struct irq_data *d)
 {
-	struct wm831x *wm831x = get_irq_chip_data(irq);
+	struct wm831x *wm831x = irq_data_get_irq_chip_data(d);
 
 	mutex_lock(&wm831x->irq_lock);
 }
 
-static void wm831x_irq_sync_unlock(unsigned int irq)
+static void wm831x_irq_sync_unlock(struct irq_data *d)
 {
-	struct wm831x *wm831x = get_irq_chip_data(irq);
+	struct wm831x *wm831x = irq_data_get_irq_chip_data(d);
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(wm831x->irq_masks_cur); i++) {
@@ -371,28 +371,29 @@ static void wm831x_irq_sync_unlock(unsigned int irq)
 	mutex_unlock(&wm831x->irq_lock);
 }
 
-static void wm831x_irq_unmask(unsigned int irq)
+static void wm831x_irq_unmask(struct irq_data *d)
 {
-	struct wm831x *wm831x = get_irq_chip_data(irq);
-	struct wm831x_irq_data *irq_data = irq_to_wm831x_irq(wm831x, irq);
+	struct wm831x *wm831x = irq_data_get_irq_chip_data(d);
+	struct wm831x_irq_data *irq_data = irq_to_wm831x_irq(wm831x, d->irq);
 
 	wm831x->irq_masks_cur[irq_data->reg - 1] &= ~irq_data->mask;
 }
 
-static void wm831x_irq_mask(unsigned int irq)
+static void wm831x_irq_mask(struct irq_data *d)
 {
-	struct wm831x *wm831x = get_irq_chip_data(irq);
-	struct wm831x_irq_data *irq_data = irq_to_wm831x_irq(wm831x, irq);
+	struct wm831x *wm831x = irq_data_get_irq_chip_data(d);
+	struct wm831x_irq_data *irq_data = irq_to_wm831x_irq(wm831x, d->irq);
 
 	wm831x->irq_masks_cur[irq_data->reg - 1] |= irq_data->mask;
 }
 
-static int wm831x_irq_set_type(unsigned int irq, unsigned int type)
+static int wm831x_irq_set_type(struct irq_data *d, unsigned int type)
 {
-	struct wm831x *wm831x = get_irq_chip_data(irq);
+	struct wm831x *wm831x = irq_data_get_irq_chip_data(irq);
+	unsigned int irq;
 	int val;
 
-	irq = irq - wm831x->irq_base;
+	irq = d->irq - wm831x->irq_base;
 
 	if (irq < WM831X_IRQ_GPIO_1 || irq > WM831X_IRQ_GPIO_11) {
 		/* Ignore internal-only IRQs */
@@ -422,11 +423,11 @@ static int wm831x_irq_set_type(unsigned int irq, unsigned int type)
 
 static struct irq_chip wm831x_irq_chip = {
 	.name = "wm831x",
-	.bus_lock = wm831x_irq_lock,
-	.bus_sync_unlock = wm831x_irq_sync_unlock,
-	.mask = wm831x_irq_mask,
-	.unmask = wm831x_irq_unmask,
-	.set_type = wm831x_irq_set_type,
+	.irq_bus_lock = wm831x_irq_lock,
+	.irq_bus_sync_unlock = wm831x_irq_sync_unlock,
+	.irq_mask = wm831x_irq_mask,
+	.irq_unmask = wm831x_irq_unmask,
+	.irq_set_type = wm831x_irq_set_type,
 };
 
 /* The processing of the primary interrupt occurs in a thread so that
-- 
1.7.1

