Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab2KHCrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 21:47:09 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:41032 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab2KHCrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 21:47:07 -0500
Message-ID: <1352342822.19098.4.camel@phoenix>
Subject: [PATCH 2/2] gpio: tegra: Drop exporting static functions
From: Axel Lin <axel.lin@ingics.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Date: Thu, 08 Nov 2012 10:47:02 +0800
In-Reply-To: <1352342724.19098.2.camel@phoenix>
References: <1352342724.19098.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both tegra_gpio_enable() and tegra_gpio_disable() are static functions, it does
not make sense to export them.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/gpio/gpio-tegra.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index d5c01f0..f6cf98f 100644
--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -109,13 +109,11 @@ static void tegra_gpio_enable(int gpio)
 {
 	tegra_gpio_mask_write(GPIO_MSK_CNF(gpio), gpio, 1);
 }
-EXPORT_SYMBOL_GPL(tegra_gpio_enable);
 
 static void tegra_gpio_disable(int gpio)
 {
 	tegra_gpio_mask_write(GPIO_MSK_CNF(gpio), gpio, 0);
 }
-EXPORT_SYMBOL_GPL(tegra_gpio_disable);
 
 static int tegra_gpio_request(struct gpio_chip *chip, unsigned offset)
 {
-- 
1.7.9.5



