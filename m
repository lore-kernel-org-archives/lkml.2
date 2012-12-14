Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab2LNQWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:22:41 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:50926 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253Ab2LNQUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:20:08 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Michel JAOUEN <michel.jaouen@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 13/21] gpio: ab8500: Use most recent run-time platform checker
Date: Fri, 14 Dec 2012 16:19:31 +0000
Message-Id: <1355501979-1157-14-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
References: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michel JAOUEN <michel.jaouen@stericsson.com>

Use is_ab9540() instead of cpu_is_u9540() when checking platform.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Michel JAOUEN <michel.jaouen@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/gpio/gpio-ab8500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-ab8500.c b/drivers/gpio/gpio-ab8500.c
index ef75984..200c605 100644
--- a/drivers/gpio/gpio-ab8500.c
+++ b/drivers/gpio/gpio-ab8500.c
@@ -483,7 +483,7 @@ static int __devinit ab8500_gpio_probe(struct platform_device *pdev)
 	ab8500_gpio->irq_base = pdata->irq_base;
 
 	/* Configure GPIO Settings for specific AB devices */
-	if (cpu_is_u9540()) {
+	if (is_ab9540(parent)) {
 		ab8500_gpio->chip.ngpio = AB9540_NUM_GPIO;
 		ab8500_gpio->irq_cluster = ab9540_irq_clusters;
 		ab8500_gpio->irq_cluster_size =
-- 
1.7.9.5

