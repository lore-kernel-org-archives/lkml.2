Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab0LMMbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:31:42 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:41610 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab0LMMb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:31:27 -0500
Date: Mon, 13 Dec 2010 13:31:26 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 20/20] mfd: wm8994: irq_data conversion.
Message-ID: <20101213123126.GD15575@mail.wantstofly.org>
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
 drivers/mfd/wm8994-irq.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/wm8994-irq.c b/drivers/mfd/wm8994-irq.c
index 8400eb1..e119a4f 100644
--- a/drivers/mfd/wm8994-irq.c
+++ b/drivers/mfd/wm8994-irq.c
@@ -156,16 +156,16 @@ static inline struct wm8994_irq_data *irq_to_wm8994_irq(struct wm8994 *wm8994,
 	return &wm8994_irqs[irq - wm8994->irq_base];
 }
 
-static void wm8994_irq_lock(unsigned int irq)
+static void wm8994_irq_lock(struct irq_data *d)
 {
-	struct wm8994 *wm8994 = get_irq_chip_data(irq);
+	struct wm8994 *wm8994 = irq_data_get_irq_chip_data(d);
 
 	mutex_lock(&wm8994->irq_lock);
 }
 
-static void wm8994_irq_sync_unlock(unsigned int irq)
+static void wm8994_irq_sync_unlock(struct irq_data *d)
 {
-	struct wm8994 *wm8994 = get_irq_chip_data(irq);
+	struct wm8994 *wm8994 = irq_data_get_irq_chip_data(d);
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(wm8994->irq_masks_cur); i++) {
@@ -182,28 +182,28 @@ static void wm8994_irq_sync_unlock(unsigned int irq)
 	mutex_unlock(&wm8994->irq_lock);
 }
 
-static void wm8994_irq_unmask(unsigned int irq)
+static void wm8994_irq_unmask(struct irq_data *d)
 {
-	struct wm8994 *wm8994 = get_irq_chip_data(irq);
-	struct wm8994_irq_data *irq_data = irq_to_wm8994_irq(wm8994, irq);
+	struct wm8994 *wm8994 = irq_data_get_irq_chip_data(d);
+	struct wm8994_irq_data *irq_data = irq_to_wm8994_irq(wm8994, d->irq);
 
 	wm8994->irq_masks_cur[irq_data->reg - 1] &= ~irq_data->mask;
 }
 
-static void wm8994_irq_mask(unsigned int irq)
+static void wm8994_irq_mask(struct irq_data *d)
 {
-	struct wm8994 *wm8994 = get_irq_chip_data(irq);
-	struct wm8994_irq_data *irq_data = irq_to_wm8994_irq(wm8994, irq);
+	struct wm8994 *wm8994 = irq_data_get_irq_chip_data(d);
+	struct wm8994_irq_data *irq_data = irq_to_wm8994_irq(wm8994, d->irq);
 
 	wm8994->irq_masks_cur[irq_data->reg - 1] |= irq_data->mask;
 }
 
 static struct irq_chip wm8994_irq_chip = {
 	.name = "wm8994",
-	.bus_lock = wm8994_irq_lock,
-	.bus_sync_unlock = wm8994_irq_sync_unlock,
-	.mask = wm8994_irq_mask,
-	.unmask = wm8994_irq_unmask,
+	.irq_bus_lock = wm8994_irq_lock,
+	.irq_bus_sync_unlock = wm8994_irq_sync_unlock,
+	.irq_mask = wm8994_irq_mask,
+	.irq_unmask = wm8994_irq_unmask,
 };
 
 /* The processing of the primary interrupt occurs in a thread so that
-- 
1.7.1
