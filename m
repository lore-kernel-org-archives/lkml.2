Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760019Ab2BNLDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:03:50 -0500
Received: from skyrme.org ([193.175.80.135]:34710 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123Ab2BNLDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:03:33 -0500
Date: 14 Feb 2012 10:34:26 +0000
Message-Id: <1329215672-15706-2-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: sameo@linux.intel.com
Cc: dmitry.torokhov@gmail.com, kernel@pengutronix.de,
        u.kleine-koenig@pengutronix.de, philippe.retornaz@epfl.ch,
        michael.thalmeier@hale.at, linux-kernel@vger.kernel.org,
        "Oskar Schirmer" <oskar@scara.com>
Subject: [PATCH 1/7] mfd: move mc13xxx global declarations to header file
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1329215672-15706-1-git-send-email-oskar@scara.com>
References: <1329215672-15706-1-git-send-email-oskar@scara.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation to split SPI specific stuff from mc13xxx-core.c
into a separate file, move non local stuff into the mc13xxx
header file.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
---
 drivers/mfd/mc13xxx-core.c  |   18 -----------
 include/linux/mfd/mc13xxx.h |   66 ++++++++++++++++++++++++++----------------
 2 files changed, 41 insertions(+), 43 deletions(-)

diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index 7122386..94840c1 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -22,18 +22,6 @@
 #include <linux/of_device.h>
 #include <linux/of_gpio.h>
 
-struct mc13xxx {
-	struct spi_device *spidev;
-	struct mutex lock;
-	int irq;
-	int flags;
-
-	irq_handler_t irqhandler[MC13XXX_NUM_IRQ];
-	void *irqdata[MC13XXX_NUM_IRQ];
-
-	int adcflags;
-};
-
 #define MC13XXX_IRQSTAT0	0
 #define MC13XXX_IRQSTAT0_ADCDONEI	(1 << 0)
 #define MC13XXX_IRQSTAT0_ADCBISDONEI	(1 << 1)
@@ -475,12 +463,6 @@ static irqreturn_t mc13xxx_irq_thread(int irq, void *data)
 	return IRQ_RETVAL(handled);
 }
 
-enum mc13xxx_id {
-	MC13XXX_ID_MC13783,
-	MC13XXX_ID_MC13892,
-	MC13XXX_ID_INVALID,
-};
-
 static const char *mc13xxx_chipname[] = {
 	[MC13XXX_ID_MC13783] = "mc13783",
 	[MC13XXX_ID_MC13892] = "mc13892",
diff --git a/include/linux/mfd/mc13xxx.h b/include/linux/mfd/mc13xxx.h
index b86ee45..df6654a 100644
--- a/include/linux/mfd/mc13xxx.h
+++ b/include/linux/mfd/mc13xxx.h
@@ -11,7 +11,47 @@
 
 #include <linux/interrupt.h>
 
-struct mc13xxx;
+#define MC13XXX_IRQ_ADCDONE	0
+#define MC13XXX_IRQ_ADCBISDONE	1
+#define MC13XXX_IRQ_TS		2
+#define MC13XXX_IRQ_CHGDET	6
+#define MC13XXX_IRQ_CHGREV	8
+#define MC13XXX_IRQ_CHGSHORT	9
+#define MC13XXX_IRQ_CCCV	10
+#define MC13XXX_IRQ_CHGCURR	11
+#define MC13XXX_IRQ_BPON	12
+#define MC13XXX_IRQ_LOBATL	13
+#define MC13XXX_IRQ_LOBATH	14
+#define MC13XXX_IRQ_1HZ		24
+#define MC13XXX_IRQ_TODA	25
+#define MC13XXX_IRQ_SYSRST	30
+#define MC13XXX_IRQ_RTCRST	31
+#define MC13XXX_IRQ_PC		32
+#define MC13XXX_IRQ_WARM	33
+#define MC13XXX_IRQ_MEMHLD	34
+#define MC13XXX_IRQ_THWARNL	36
+#define MC13XXX_IRQ_THWARNH	37
+#define MC13XXX_IRQ_CLK		38
+
+#define MC13XXX_NUM_IRQ		46
+
+enum mc13xxx_id {
+	MC13XXX_ID_MC13783,
+	MC13XXX_ID_MC13892,
+	MC13XXX_ID_INVALID,
+};
+
+struct mc13xxx {
+	struct spi_device *spidev;
+	struct mutex lock;
+	int irq;
+	int flags;
+
+	irq_handler_t irqhandler[MC13XXX_NUM_IRQ];
+	void *irqdata[MC13XXX_NUM_IRQ];
+
+	int adcflags;
+};
 
 void mc13xxx_lock(struct mc13xxx *mc13xxx);
 void mc13xxx_unlock(struct mc13xxx *mc13xxx);
@@ -40,30 +80,6 @@ int mc13xxx_get_flags(struct mc13xxx *mc13xxx);
 int mc13xxx_adc_do_conversion(struct mc13xxx *mc13xxx,
 		unsigned int mode, unsigned int channel, unsigned int *sample);
 
-#define MC13XXX_IRQ_ADCDONE	0
-#define MC13XXX_IRQ_ADCBISDONE	1
-#define MC13XXX_IRQ_TS		2
-#define MC13XXX_IRQ_CHGDET	6
-#define MC13XXX_IRQ_CHGREV	8
-#define MC13XXX_IRQ_CHGSHORT	9
-#define MC13XXX_IRQ_CCCV	10
-#define MC13XXX_IRQ_CHGCURR	11
-#define MC13XXX_IRQ_BPON	12
-#define MC13XXX_IRQ_LOBATL	13
-#define MC13XXX_IRQ_LOBATH	14
-#define MC13XXX_IRQ_1HZ		24
-#define MC13XXX_IRQ_TODA	25
-#define MC13XXX_IRQ_SYSRST	30
-#define MC13XXX_IRQ_RTCRST	31
-#define MC13XXX_IRQ_PC		32
-#define MC13XXX_IRQ_WARM	33
-#define MC13XXX_IRQ_MEMHLD	34
-#define MC13XXX_IRQ_THWARNL	36
-#define MC13XXX_IRQ_THWARNH	37
-#define MC13XXX_IRQ_CLK		38
-
-#define MC13XXX_NUM_IRQ		46
-
 struct regulator_init_data;
 
 struct mc13xxx_regulator_init_data {
-- 
1.7.5.4

