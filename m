Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab2H2Bff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 21:35:35 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57998 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab2H2Bfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 21:35:33 -0400
Message-ID: <1346204124.13176.0.camel@phoenix>
Subject: [PATCH 1/2] gpio: mc9s08dz60: Fix build error if I2C=m
From: Axel Lin <axel.lin@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Wu Guoxing <b39297@freescale.com>, Sascha Hauer <s.hauer@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-kernel@vger.kernel.org
Date: Wed, 29 Aug 2012 09:35:24 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make GPIO_MC9S08DZ60 depend on I2C=y, this fixes below build error:

  LD      init/built-in.o
drivers/built-in.o: In function `mc9s08dz60_get_value':
clk-fixed-factor.c:(.text+0x7214): undefined reference to `i2c_smbus_read_byte_data'
drivers/built-in.o: In function `mc9s08dz60_set':
clk-fixed-factor.c:(.text+0x727c): undefined reference to `i2c_smbus_read_byte_data'
clk-fixed-factor.c:(.text+0x72bc): undefined reference to `i2c_smbus_write_byte_data'
drivers/built-in.o: In function `mc9s08dz60_i2c_driver_init':
clk-fixed-factor.c:(.init.text+0x290): undefined reference to `i2c_register_driver'
drivers/built-in.o: In function `mc9s08dz60_i2c_driver_exit':
clk-fixed-factor.c:(.exit.text+0x2c): undefined reference to `i2c_del_driver'
make: *** [vmlinux] Error 1

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpio/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index b16c8a7..ba7926f5 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -294,7 +294,7 @@ config GPIO_MAX732X_IRQ
 
 config GPIO_MC9S08DZ60
 	bool "MX35 3DS BOARD MC9S08DZ60 GPIO functions"
-	depends on I2C && MACH_MX35_3DS
+	depends on I2C=y && MACH_MX35_3DS
 	help
 	  Select this to enable the MC9S08DZ60 GPIO driver
 
-- 
1.7.9.5



