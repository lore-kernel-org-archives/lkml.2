Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab2LJLPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:15:24 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56213 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab2LJLPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:15:22 -0500
From: AnilKumar Ch <anilkumar@ti.com>
To: <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, AnilKumar Ch <anilkumar@ti.com>
Subject: [PATCH] mfd: tps65910: Select REGMAP_IRQ in Kconfig to fix build error
Date: Mon, 10 Dec 2012 16:44:56 +0530
Message-ID: <1355138096-7702-1-git-send-email-anilkumar@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TPS65910 mfd driver uses functions that are only avaiable when
REGMAP_IRQ is enabled. So "select REGMAP_IRQ" is added to mfd
Kconfig to fix below build error:

drivers/built-in.o: In function `tps65910_irq_exit':
/media/anil/kernel/drivers/mfd/tps65910.c:265: undefined reference to `regmap_del_irq_chip'
drivers/built-in.o: In function `tps65910_irq_init':
/media/anil/kernel/drivers/mfd/tps65910.c:254: undefined reference to `regmap_add_irq_chip'
drivers/built-in.o: In function `tps65910_i2c_probe':
/media/anil/kernel/drivers/mfd/tps65910.c:509: undefined reference to `regmap_irq_get_domain'
make: *** [vmlinux] Error 1

Signed-off-by: AnilKumar Ch <anilkumar@ti.com>
---
 drivers/mfd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 1c0abd4..01413a2 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -237,6 +237,7 @@ config MFD_TPS65910
 	depends on I2C=y && GPIOLIB
 	select MFD_CORE
 	select REGMAP_I2C
+	select REGMAP_IRQ
 	select IRQ_DOMAIN
 	help
 	  if you say yes here you get support for the TPS65910 series of
-- 
1.7.9.5

