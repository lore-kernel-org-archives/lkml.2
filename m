Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab2KHCpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 21:45:31 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48126 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab2KHCpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 21:45:30 -0500
Message-ID: <1352342724.19098.2.camel@phoenix>
Subject: [PATCH 1/2] gpio: tegra: Staticize non-exported symbols
From: Axel Lin <axel.lin@ingics.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Date: Thu, 08 Nov 2012 10:45:24 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both tegra_gpio_request() and tegra_gpio_free() are not referenced outside of
this file, make them static.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/gpio/gpio-tegra.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index c7c175a..d5c01f0 100644
--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -117,12 +117,12 @@ static void tegra_gpio_disable(int gpio)
 }
 EXPORT_SYMBOL_GPL(tegra_gpio_disable);
 
-int tegra_gpio_request(struct gpio_chip *chip, unsigned offset)
+static int tegra_gpio_request(struct gpio_chip *chip, unsigned offset)
 {
 	return pinctrl_request_gpio(offset);
 }
 
-void tegra_gpio_free(struct gpio_chip *chip, unsigned offset)
+static void tegra_gpio_free(struct gpio_chip *chip, unsigned offset)
 {
 	pinctrl_free_gpio(offset);
 	tegra_gpio_disable(offset);
-- 
1.7.9.5



