Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab2LENUD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 08:20:03 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:35101 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab2LENUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 08:20:01 -0500
Message-ID: <1354713588.14255.1.camel@phoenix>
Subject: [PATCH] mfd: tps80031: MFD_TPS80031 needs to select REGMAP_IRQ
From: Axel Lin <axel.lin@ingics.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, linux-kernel@vger.kernel.org
Date: Wed, 05 Dec 2012 21:19:48 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver uses regmap_irq APIs, thus need to select REGMAP_IRQ.
IRQ_DOMAIN will be selected if select REGMAP_IRQ, thus remove it here.

This fixes below build errors:

drivers/built-in.o: In function `tps80031_remove':
drivers/mfd/tps80031.c:534: undefined reference to `regmap_del_irq_chip'
drivers/built-in.o: In function `tps80031_irq_init':
drivers/mfd/tps80031.c:305: undefined reference to `regmap_add_irq_chip'
drivers/built-in.o: In function `tps80031_probe':
drivers/mfd/tps80031.c:496: undefined reference to `regmap_irq_get_domain'
drivers/mfd/tps80031.c:512: undefined reference to `regmap_del_irq_chip'
make: *** [vmlinux] Error 1

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/mfd/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 09d43a9..1c0abd4 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -269,7 +269,7 @@ config MFD_TPS80031
 	depends on I2C=y && GENERIC_HARDIRQS
 	select MFD_CORE
 	select REGMAP_I2C
-	select IRQ_DOMAIN
+	select REGMAP_IRQ
 	help
 	  If you say yes here you get support for the Texas Instruments
 	  TPS80031/ TPS80032 Fully Integrated Power Management with Power
-- 
1.7.9.5



