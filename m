Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab2GJFRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 01:17:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36835 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab2GJFRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 01:17:03 -0400
From: Gerard Snitselaar <dev@snitselaar.org>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        Jerry Snitselaar <dev@snitselaar.org>
Subject: [PATCH] gpio/gpio-tps65910: gpio_chip.of_node referenced without CONFIG_OF_GPIO defined
Date: Mon,  9 Jul 2012 22:16:34 -0700
Message-Id: <1341897394-7003-1-git-send-email-dev@snitselaar.org>
X-Mailer: git-send-email 1.7.11.1.165.g299666c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jerry Snitselaar <dev@snitselaar.org>

commit 626f9914 added code to initialize gpio_chip.of_node, but if
CONFIG_OF_GPIO is not defined gps-tps65910 fails to build with an
error complaining gpio_chip has no member of_node. I ran into this
while doing a allyesconfig build on linux-next.

Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>
---
 drivers/gpio/gpio-tps65910.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpio/gpio-tps65910.c b/drivers/gpio/gpio-tps65910.c
index 0749f96..11f29c8 100644
--- a/drivers/gpio/gpio-tps65910.c
+++ b/drivers/gpio/gpio-tps65910.c
@@ -149,7 +149,9 @@ static int __devinit tps65910_gpio_probe(struct platform_device *pdev)
 	tps65910_gpio->gpio_chip.set	= tps65910_gpio_set;
 	tps65910_gpio->gpio_chip.get	= tps65910_gpio_get;
 	tps65910_gpio->gpio_chip.dev = &pdev->dev;
+#ifdef CONFIG_OF_GPIO
 	tps65910_gpio->gpio_chip.of_node = tps65910->dev->of_node;
+#endif
 	if (pdata && pdata->gpio_base)
 		tps65910_gpio->gpio_chip.base = pdata->gpio_base;
 	else
-- 
1.7.11.1.165.g299666c

