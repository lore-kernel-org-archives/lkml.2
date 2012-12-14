Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab2LNQUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:20:17 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:43714 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212Ab2LNQUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:20:11 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org,
        Alexandre Torgue <alexandre.torgue@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 15/21] gpio: ab8500: Add support for the ab8540
Date: Fri, 14 Dec 2012 16:19:33 +0000
Message-Id: <1355501979-1157-16-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
References: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Torgue <alexandre.torgue@stericsson.com>

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Alexandre Torgue <alexandre.torgue@stericsson.com>
Reviewed-by: Maxime COQUELIN <maxime.coquelin@stericsson.com>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Mattias WALLIN <mattias.wallin@stericsson.com>
---
 drivers/gpio/gpio-ab8500.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-ab8500.c b/drivers/gpio/gpio-ab8500.c
index ab6ceac..757ae34 100644
--- a/drivers/gpio/gpio-ab8500.c
+++ b/drivers/gpio/gpio-ab8500.c
@@ -78,6 +78,7 @@
 #define AB8500_NUM_GPIO		42
 #define AB9540_NUM_GPIO		54
 #define AB8505_NUM_GPIO		53
+#define AB8540_NUM_GPIO		56
 #define AB8500_NUM_VIR_GPIO_IRQ	16
 
 enum ab8500_gpio_action {
@@ -146,6 +147,15 @@ static struct ab8500_gpio_irq_cluster ab8505_irq_clusters[] = {
 	{.start = 51, .end = 52},
 };
 
+/*
+ * For AB8540 Only some GPIOs are interrupt capable:
+ *	GPIO51 to GPIO54
+ */
+static struct ab8500_gpio_irq_cluster ab8540_irq_clusters[] = {
+	{.start = 50,  .end = 53}, /* GPIO numbers start from 1 */
+};
+
+
 /**
  * to_ab8500_gpio() - get the pointer to ab8500_gpio
  * @chip:	Member of the structure ab8500_gpio
@@ -483,7 +493,14 @@ static int __devinit ab8500_gpio_probe(struct platform_device *pdev)
 	ab8500_gpio->irq_base = pdata->irq_base;
 
 	/* Configure GPIO Settings for specific AB devices */
-	if (is_ab9540(parent)) {
+	if (is_ab8540(parent)) {
+		ab8500_gpio->chip.ngpio = AB8540_NUM_GPIO;
+		ab8500_gpio->irq_cluster = ab8540_irq_clusters;
+		ab8500_gpio->irq_cluster_size =
+			ARRAY_SIZE(ab8540_irq_clusters);
+		last_gpio_sel_reg = AB9540_GPIO_SEL7_REG;
+		altfun_reg_index = AB9540_ALTFUN_REG_INDEX;
+	} else if (is_ab9540(parent)) {
 		ab8500_gpio->chip.ngpio = AB9540_NUM_GPIO;
 		ab8500_gpio->irq_cluster = ab9540_irq_clusters;
 		ab8500_gpio->irq_cluster_size =
-- 
1.7.9.5

