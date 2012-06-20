Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab2FTBlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 21:41:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50218 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab2FTBlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 21:41:13 -0400
Message-ID: <1340156457.13830.1.camel@phoenix>
Subject: [PATCH] mfd: MFD_MAX77693 needs to select IRQ_DOMAIN
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Date: Wed, 20 Jun 2012 09:40:57 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes below build errors:

  CC      drivers/mfd/max77693-irq.o
drivers/mfd/max77693-irq.c: In function 'max77693_irq_thread':
drivers/mfd/max77693-irq.c:217:4: error: implicit declaration of function 'irq_find_mapping' [-Werror=implicit-function-declaration]
drivers/mfd/max77693-irq.c: In function 'max77693_irq_init':
drivers/mfd/max77693-irq.c:286:2: error: implicit declaration of function 'irq_domain_add_linear' [-Werror=implicit-function-declaration]
drivers/mfd/max77693-irq.c:286:9: warning: assignment makes pointer from integer without a cast [enabled by default]
cc1: some warnings being treated as errors
make[2]: *** [drivers/mfd/max77693-irq.o] Error 1
make[1]: *** [drivers/mfd] Error 2
make: *** [drivers] Error 2

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index e129c82..79f1d4b 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -427,6 +427,7 @@ config MFD_MAX77693
 	depends on I2C=y && GENERIC_HARDIRQS
 	select MFD_CORE
 	select REGMAP_I2C
+	select IRQ_DOMAIN
 	help
 	  Say yes here to support for Maxim Semiconductor MAX77693.
 	  This is a companion Power Management IC with Flash, Haptic, Charger,
-- 
1.7.9.5



