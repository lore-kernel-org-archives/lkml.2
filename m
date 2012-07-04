Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab2GDPLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 11:11:20 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7535 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab2GDPLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 11:11:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 04 Jul 2012 08:11:15 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <grant.likely@secretlab.ca>, <linus.walleij@stericsson.com>
CC: <linux-kernel@vger.kernel.org>, <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] gpio: tps65910: initialize of_node of gpio_chip
Date: Wed, 4 Jul 2012 20:36:45 +0530
Message-ID: <1341414405-6401-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize the gpio chip's of_node to the device's node
to work with DT based system.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/gpio/gpio-tps65910.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-tps65910.c b/drivers/gpio/gpio-tps65910.c
index c1ad288..0749f96 100644
--- a/drivers/gpio/gpio-tps65910.c
+++ b/drivers/gpio/gpio-tps65910.c
@@ -149,6 +149,7 @@ static int __devinit tps65910_gpio_probe(struct platform_device *pdev)
 	tps65910_gpio->gpio_chip.set	= tps65910_gpio_set;
 	tps65910_gpio->gpio_chip.get	= tps65910_gpio_get;
 	tps65910_gpio->gpio_chip.dev = &pdev->dev;
+	tps65910_gpio->gpio_chip.of_node = tps65910->dev->of_node;
 	if (pdata && pdata->gpio_base)
 		tps65910_gpio->gpio_chip.base = pdata->gpio_base;
 	else
-- 
1.7.1.1

