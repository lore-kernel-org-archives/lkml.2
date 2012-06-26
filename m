Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990Ab2FZB07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 21:26:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37117 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757794Ab2FZB06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 21:26:58 -0400
Message-ID: <1340674008.2942.1.camel@phoenix>
Subject: [PATCH] mfd: MFD_MAX77686 needs to select REGMAP_I2C and IRQ_DOMAIN
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Chiwoong Byun <woong.byun@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        SamuelOrtiz <sameo@linux.intel.com>
Date: Tue, 26 Jun 2012 09:26:48 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Select REGMAP_I2C to fix below build errors:

  CC      drivers/mfd/max77686.o
drivers/mfd/max77686.c:43:15: error: variable 'max77686_regmap_config' has initializer but incomplete type
drivers/mfd/max77686.c:44:2: error: unknown field 'reg_bits' specified in initializer
drivers/mfd/max77686.c:44:2: warning: excess elements in struct initializer [enabled by default]
drivers/mfd/max77686.c:44:2: warning: (near initialization for 'max77686_regmap_config') [enabled by default]
drivers/mfd/max77686.c:45:2: error: unknown field 'val_bits' specified in initializer
drivers/mfd/max77686.c:45:2: warning: excess elements in struct initializer [enabled by default]
drivers/mfd/max77686.c:45:2: warning: (near initialization for 'max77686_regmap_config') [enabled by default]
drivers/mfd/max77686.c: In function 'max77686_i2c_probe':
drivers/mfd/max77686.c:60:2: error: implicit declaration of function 'regmap_init_i2c' [-Werror=implicit-function-declaration]
drivers/mfd/max77686.c:60:19: warning: assignment makes pointer from integer without a cast [enabled by default]
cc1: some warnings being treated as errors
make[2]: *** [drivers/mfd/max77686.o] Error 1
make[1]: *** [drivers/mfd] Error 2
make: *** [drivers] Error 2

Select IRQ_DOMAIN to fix below build errors:

  CC      drivers/mfd/max77686-irq.o
drivers/mfd/max77686-irq.c: In function 'max77686_irq_thread':
drivers/mfd/max77686-irq.c:213:4: error: implicit declaration of function 'irq_find_mapping' [-Werror=implicit-function-declaration]
drivers/mfd/max77686-irq.c: In function 'max77686_irq_init':
drivers/mfd/max77686-irq.c:282:2: error: implicit declaration of function 'irq_domain_add_linear' [-Werror=implicit-function-declaration]
drivers/mfd/max77686-irq.c:282:9: warning: assignment makes pointer from integer without a cast [enabled by default]
cc1: some warnings being treated as errors
make[2]: *** [drivers/mfd/max77686-irq.o] Error 1
make[1]: *** [drivers/mfd] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 3b59661..a7d0c85 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -426,6 +426,8 @@ config MFD_MAX77686
 	bool "Maxim Semiconductor MAX77686 PMIC Support"
 	depends on I2C=y && GENERIC_HARDIRQS
 	select MFD_CORE
+	select REGMAP_I2C
+	select IRQ_DOMAIN
 	help
 	  Say yes here to support for Maxim Semiconductor MAX77686.
 	  This is a Power Management IC with RTC on chip.
-- 
1.7.9.5



