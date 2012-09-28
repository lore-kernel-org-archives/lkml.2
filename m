Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423405Ab2I1Vgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:36:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54885 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423392Ab2I1Vge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:36:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 10/12] gpio: pcf857x: select IRQ_DOMAIN
Date: Fri, 28 Sep 2012 23:36:15 +0200
Message-Id: <1348868177-21205-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1348868177-21205-1-git-send-email-arnd@arndb.de>
References: <1348868177-21205-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:0AFnaFh9R4869fcsUTqmDbprJF8gSeixhmWYyYSsQ17
 xRU55GeYZzjQl/IJSA5I87wlCO2WFjqKphdSGe8v/rvDo4HuOy
 4YBMGCvHCxLu/Nh65fg00h1fk0xBdBTFH0KVsE/Ugc4TxA5Vgk
 SKJTVKzTt/OSeeffO81X7KdrM6eNzlw9hNfbPgzWc6aN7n7+ZR
 QcdX2m8n2C1rwnA0T8+ewAQb438lHl8eojYhPY0btEAuAaqVUT
 MQXEiEFD8pbHR0TVqklF9IjQGycLL6ajLMIVfvtLyd2z7bC7HF
 YhGe1NdIt1usI2qpOw0wZ03QXquFfNMe9G/UCovHYG0FxqqZEn
 cvJio5j5oPQBs1i1pg2seWlzwj47p+tbtHqYz+Ae5Kuyu4qV+U
 GZoY/Ilw7XGYQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 6e20a0a4 "gpio: pcf857x: enable gpio_to_irq() support"
added IRQ domain support to the pcf857x driver, but some configurations
(e.g. davinci_all_defconfig) don't already enable CONFIG_IRQ_DOMAIN.

Always selecting it from the Kconfig in this case is what other
such drivers do as well, and avoids these build errors:

Without this patch, building davinci_all_defconfig results in:

drivers/gpio/gpio-pcf857x.c: In function 'pcf857x_to_irq':
drivers/gpio/gpio-pcf857x.c:167:2: error: implicit declaration of function 'irq_create_mapping'
drivers/gpio/gpio-pcf857x.c: In function 'pcf857x_irq_demux_work':
drivers/gpio/gpio-pcf857x.c:183:3: error: implicit declaration of function 'irq_find_mapping'
drivers/gpio/gpio-pcf857x.c: In function 'pcf857x_irq_domain_cleanup':
drivers/gpio/gpio-pcf857x.c:218:3: error: implicit declaration of function 'irq_domain_remove'
drivers/gpio/gpio-pcf857x.c: In function 'pcf857x_irq_domain_init':
drivers/gpio/gpio-pcf857x.c:230:2: error: implicit declaration of function 'irq_domain_add_linear'

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 0c05532..d055cee 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -336,6 +336,7 @@ config GPIO_PCA953X_IRQ
 config GPIO_PCF857X
 	tristate "PCF857x, PCA{85,96}7x, and MAX732[89] I2C GPIO expanders"
 	depends on I2C
+	select IRQ_DOMAIN
 	help
 	  Say yes here to provide access to most "quasi-bidirectional" I2C
 	  GPIO expanders used for additional digital outputs or inputs.
-- 
1.7.10

