Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab0HQMNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 08:13:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35695 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751971Ab0HQMNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 08:13:44 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] mfd: Move PCF50633 IRQ protoypes where the definitions can see them
Date: Tue, 17 Aug 2010 13:13:36 +0100
Message-Id: <1282047217-9875-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed warnings about unprototyped global functions.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/pcf50633-core.c       |    7 -------
 include/linux/mfd/pcf50633/core.h |    7 +++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 23e5855..6d4233f 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -25,13 +25,6 @@
 
 #include <linux/mfd/pcf50633/core.h>
 
-int pcf50633_irq_init(struct pcf50633 *pcf, int irq);
-void pcf50633_irq_free(struct pcf50633 *pcf);
-#ifdef CONFIG_PM
-int pcf50633_irq_suspend(struct pcf50633 *pcf);
-int pcf50633_irq_resume(struct pcf50633 *pcf);
-#endif
-
 static int __pcf50633_read(struct pcf50633 *pcf, u8 reg, int num, u8 *data)
 {
 	int ret;
diff --git a/include/linux/mfd/pcf50633/core.h b/include/linux/mfd/pcf50633/core.h
index ad411a7..50d4a04 100644
--- a/include/linux/mfd/pcf50633/core.h
+++ b/include/linux/mfd/pcf50633/core.h
@@ -227,4 +227,11 @@ static inline struct pcf50633 *dev_to_pcf50633(struct device *dev)
 	return dev_get_drvdata(dev);
 }
 
+int pcf50633_irq_init(struct pcf50633 *pcf, int irq);
+void pcf50633_irq_free(struct pcf50633 *pcf);
+#ifdef CONFIG_PM
+int pcf50633_irq_suspend(struct pcf50633 *pcf);
+int pcf50633_irq_resume(struct pcf50633 *pcf);
+#endif
+
 #endif
-- 
1.7.1

