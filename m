Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509Ab2K0JEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 04:04:07 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38553 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758349Ab2K0JEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 04:04:01 -0500
Date: Tue, 27 Nov 2012 01:03:56 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric =?iso-8859-1?Q?B=E9nard?= <ebenard@eukrea.com>
Subject: [PATCH v2] ARM: eukrea_mbimx27-baseboard - use stock
 get_pendown_state() in ads7846
Message-ID: <20121127090356.GA25658@core.coreip.homeip.net>
References: <20121124082529.GA7687@core.coreip.homeip.net>
 <20121127074209.GL10369@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121127074209.GL10369@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default implementation matches exactly our custom one so we can switch
to using the default one. As a bonus the driver will take care of setting
GPIO line for us.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

Adjusted to use IMX_GPIO_NR() macro.

 arch/arm/mach-imx/eukrea_mbimx27-baseboard.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/arch/arm/mach-imx/eukrea_mbimx27-baseboard.c b/arch/arm/mach-imx/eukrea_mbimx27-baseboard.c
index 98aef57..f361143 100644
--- a/arch/arm/mach-imx/eukrea_mbimx27-baseboard.c
+++ b/arch/arm/mach-imx/eukrea_mbimx27-baseboard.c
@@ -238,24 +238,8 @@ static const struct imxuart_platform_data uart_pdata __initconst = {
 	.flags = IMXUART_HAVE_RTSCTS,
 };
 
-#define ADS7846_PENDOWN (GPIO_PORTD | 25)
-
-static void __maybe_unused ads7846_dev_init(void)
-{
-	if (gpio_request(ADS7846_PENDOWN, "ADS7846 pendown") < 0) {
-		printk(KERN_ERR "can't get ads7846 pen down GPIO\n");
-		return;
-	}
-	gpio_direction_input(ADS7846_PENDOWN);
-}
-
-static int ads7846_get_pendown_state(void)
-{
-	return !gpio_get_value(ADS7846_PENDOWN);
-}
-
 static struct ads7846_platform_data ads7846_config __initdata = {
-	.get_pendown_state	= ads7846_get_pendown_state,
+	.gpio_pendown		= IMX_GPIO_NR(4, 25),
 	.keep_vref_on		= 1,
 };
 
@@ -323,7 +307,6 @@ void __init eukrea_mbimx27_baseboard_init(void)
 	|| defined(CONFIG_TOUCHSCREEN_ADS7846_MODULE)
 	/* ADS7846 Touchscreen controller init */
 	mxc_gpio_mode(GPIO_PORTD | 25 | GPIO_GPIO | GPIO_IN);
-	ads7846_dev_init();
 #endif
 
 	/* SPI_CS0 init */
