Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933983Ab2FHIye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 04:54:34 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:37678 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933075Ab2FHIya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 04:54:30 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, t-kristo@ti.com,
        Randy Dunlap <rdunlap@xenotime.net>, peter.ujfalusi@ti.com
Subject: [PATCH v2] MFD: twl6040: Update Kconfig to avoid build breakage
Date: Fri,  8 Jun 2012 11:54:21 +0300
Message-Id: <1339145661-25333-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

twl6040 needs CONFIG_IRQ_DOMAIN to compile, without this we have:
drivers/mfd/twl6040-irq.c: In function 'twl6040_irq_init':
drivers/mfd/twl6040-irq.c:164:2: error: implicit declaration of function 'irq_domain_add_legacy'
drivers/mfd/twl6040-irq.c:165:11: error: 'irq_domain_simple_ops' undeclared (first use in this function)
drivers/mfd/twl6040-irq.c:165:11: note: each undeclared identifier is reported only once for each function it appears in

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index e129c82..92144ed 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -286,6 +286,7 @@ config TWL6040_CORE
 	depends on I2C=y && GENERIC_HARDIRQS
 	select MFD_CORE
 	select REGMAP_I2C
+	select IRQ_DOMAIN
 	default n
 	help
 	  Say yes here if you want support for Texas Instruments TWL6040 audio
-- 
1.7.8.6

