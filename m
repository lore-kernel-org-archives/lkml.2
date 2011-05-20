Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935570Ab1ETJov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 05:44:51 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61109 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935549Ab1ETJos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 05:44:48 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 3/4] gpio: gpio-mxs: remove gpio port definition and registration
Date: Fri, 20 May 2011 17:51:28 +0800
Message-Id: <1305885089-27343-4-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305885089-27343-1-git-send-email-shawn.guo@linaro.org>
References: <1305885089-27343-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to ease the review.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/gpio/gpio-mxs.c |   40 ----------------------------------------
 1 files changed, 0 insertions(+), 40 deletions(-)

diff --git a/drivers/gpio/gpio-mxs.c b/drivers/gpio/gpio-mxs.c
index 260d7ed..6a59bf2 100644
--- a/drivers/gpio/gpio-mxs.c
+++ b/drivers/gpio/gpio-mxs.c
@@ -295,43 +295,3 @@ int __init mxs_gpio_init(struct mxs_gpio_port *port, int cnt)
 
 	return 0;
 }
-
-#define MX23_GPIO_BASE	MX23_IO_ADDRESS(MX23_PINCTRL_BASE_ADDR)
-#define MX28_GPIO_BASE	MX28_IO_ADDRESS(MX28_PINCTRL_BASE_ADDR)
-
-#define DEFINE_MXS_GPIO_PORT(_base, _irq, _id)				\
-	{								\
-		.chip.label = "gpio-" #_id,				\
-		.id = _id,						\
-		.irq = _irq,						\
-		.base = _base,						\
-		.virtual_irq_start = MXS_GPIO_IRQ_START + (_id) * 32,	\
-	}
-
-#ifdef CONFIG_SOC_IMX23
-static struct mxs_gpio_port mx23_gpio_ports[] = {
-	DEFINE_MXS_GPIO_PORT(MX23_GPIO_BASE, MX23_INT_GPIO0, 0),
-	DEFINE_MXS_GPIO_PORT(MX23_GPIO_BASE, MX23_INT_GPIO1, 1),
-	DEFINE_MXS_GPIO_PORT(MX23_GPIO_BASE, MX23_INT_GPIO2, 2),
-};
-
-int __init mx23_register_gpios(void)
-{
-	return mxs_gpio_init(mx23_gpio_ports, ARRAY_SIZE(mx23_gpio_ports));
-}
-#endif
-
-#ifdef CONFIG_SOC_IMX28
-static struct mxs_gpio_port mx28_gpio_ports[] = {
-	DEFINE_MXS_GPIO_PORT(MX28_GPIO_BASE, MX28_INT_GPIO0, 0),
-	DEFINE_MXS_GPIO_PORT(MX28_GPIO_BASE, MX28_INT_GPIO1, 1),
-	DEFINE_MXS_GPIO_PORT(MX28_GPIO_BASE, MX28_INT_GPIO2, 2),
-	DEFINE_MXS_GPIO_PORT(MX28_GPIO_BASE, MX28_INT_GPIO3, 3),
-	DEFINE_MXS_GPIO_PORT(MX28_GPIO_BASE, MX28_INT_GPIO4, 4),
-};
-
-int __init mx28_register_gpios(void)
-{
-	return mxs_gpio_init(mx28_gpio_ports, ARRAY_SIZE(mx28_gpio_ports));
-}
-#endif
-- 
1.7.4.1

