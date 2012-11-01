Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351Ab2KAKW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 06:22:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58241 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758678Ab2KAKW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 06:22:27 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Jamie Lentin <jm@lentin.co.uk>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] gpio: adnp: Depend on OF_GPIO instead of OF
Date: Thu,  1 Nov 2012 11:22:11 +0100
Message-Id: <1351765331-30617-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.0
X-Provags-ID: V02:K0:yPSJsjqOXjltwz+Du4of2H5CbQp970NOmtrtoq6QIkv
 sUlBha4inBJURDJqqinLBTM7I2zX741FWD+uUIY+IRkL6RFAfk
 CNT5pb0oKqTf5KcLlbQHHSPEl4gJwgcGQPq35NSM2z62X6DIkG
 gcClsB/sHTgoO5V+xjFqnM8CHV8NX3h90PmqWvozDa8mpcE4Iy
 uU7vhZutT68cRLc58URNWn+k8dLFZ83B6LwD+6GMKSmF5190Sp
 HQ36nAoZbWk+NmiUyBH42IWwZ52zpVudSTCZVa18dkVu3seQUf
 H6GqwqP5SgFlYVPynMsv1//na8O7aUUvmvhyXRqtBsJQuolloY
 6bPAbSFaJVLRYjnOej7n5lVvrtZrQlMk7kkgQM3bTcdC5YTyYM
 SylXbactG7A5h2+Mvmqob22rThLVogBKi3t5ixfoMf3Aofa6cz
 lcb10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver accesses the of_node field of struct gpio_chip, which is only
available if OF_GPIO is selected. This solves a build issue on SPARC
which conflicts with OF_GPIO and therefore does not provide this field.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/gpio/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index d055cee..c856f9e 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -466,7 +466,7 @@ config GPIO_ADP5588_IRQ
 
 config GPIO_ADNP
 	tristate "Avionic Design N-bit GPIO expander"
-	depends on I2C && OF
+	depends on I2C && OF_GPIO
 	help
 	  This option enables support for N GPIOs found on Avionic Design
 	  I2C GPIO expanders. The register space will be extended by powers
-- 
1.8.0

