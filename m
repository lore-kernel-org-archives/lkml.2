Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212Ab2K0HPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 02:15:36 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58965 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758065Ab2K0HP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 02:15:29 -0500
Message-ID: <1354000517.20368.0.camel@phoenix>
Subject: [PATCH] mfd: tps65090: MFD_TPS65090 needs to select REGMAP_IRQ
From: Axel Lin <axel.lin@ingics.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, linux-kernel@vger.kernel.org
Date: Tue, 27 Nov 2012 15:15:17 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes below build error:

drivers/built-in.o: In function `tps65090_i2c_probe':
drivers/mfd/tps65090.c:180: undefined reference to `regmap_add_irq_chip'
drivers/mfd/tps65090.c:190: undefined reference to `regmap_irq_chip_get_base'
drivers/mfd/tps65090.c:203: undefined reference to `regmap_del_irq_chip'
drivers/built-in.o: In function `tps65090_i2c_remove':
drivers/mfd/tps65090.c:213: undefined reference to `regmap_del_irq_chip'
make: *** [vmlinux] Error 1

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/mfd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index a8fef75..09d43a9 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1015,6 +1015,7 @@ config MFD_TPS65090
 	depends on I2C=y && GENERIC_HARDIRQS
 	select MFD_CORE
 	select REGMAP_I2C
+	select REGMAP_IRQ
 	help
 	  If you say yes here you get support for the TPS65090 series of
 	  Power Management chips.
-- 
1.7.9.5



