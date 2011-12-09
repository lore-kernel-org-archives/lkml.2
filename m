Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab1LIOU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:20:57 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:33280 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab1LIOU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:20:56 -0500
X-SpamScore: 3
X-BigFish: VPS3(zzc8kzz1202hzz8275bhz2dh2a8h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: [PATCH 04/06] GPIO: Moved some defines to a header file v1
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: <grant@secretlab.ca>
CC: <jic23@cam.ac.uk>, <linux-kernel@vger.kernel.org>,
        Dajun <dajun.chen@diasemi.com>, <paul.liu@linaro.org>,
        <linaro-dev@lists.linaro.org>, <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 9 Dec 2011 19:47:31 +0530
Message-ID: <1323440251.23171.72.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LED module has dependency on some gpio macros therefore they are moved to a 
header file.

This patch is functionally tested on Samsung SMDKV6410.

Signed-off-by: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
 drivers/gpio/gpio-da9052.c      |   26 ++-------------------
 include/linux/mfd/da9052/gpio.h |   46 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 23 deletions(-)
 create mode 100644 include/linux/mfd/da9052/gpio.h

diff --git a/drivers/gpio/gpio-da9052.c b/drivers/gpio/gpio-da9052.c
index 038f5eb..662f92e 100644
--- a/drivers/gpio/gpio-da9052.c
+++ b/drivers/gpio/gpio-da9052.c
@@ -24,26 +24,6 @@
 #include <linux/mfd/da9052/pdata.h>
 #include <linux/mfd/da9052/gpio.h>
 
-#define DA9052_INPUT				1
-#define DA9052_OUTPUT_OPENDRAIN		2
-#define DA9052_OUTPUT_PUSHPULL			3
-
-#define DA9052_SUPPLY_VDD_IO1			0
-
-#define DA9052_DEBOUNCING_OFF			0
-#define DA9052_DEBOUNCING_ON			1
-
-#define DA9052_OUTPUT_LOWLEVEL			0
-
-#define DA9052_ACTIVE_LOW			0
-#define DA9052_ACTIVE_HIGH			1
-
-#define DA9052_GPIO_MAX_PORTS_PER_REGISTER	8
-#define DA9052_GPIO_SHIFT_COUNT(no)		(no%8)
-#define DA9052_GPIO_MASK_UPPER_NIBBLE		0xF0
-#define DA9052_GPIO_MASK_LOWER_NIBBLE		0x0F
-#define DA9052_GPIO_NIBBLE_SHIFT		4
-
 struct da9052_gpio {
 	struct da9052 *da9052;
 	struct gpio_chip gp;
@@ -201,9 +181,9 @@ static struct gpio_chip reference_gp __devinitdata = {
 	.direction_input = da9052_gpio_direction_input,
 	.direction_output = da9052_gpio_direction_output,
 	.to_irq = da9052_gpio_to_irq,
-	.can_sleep = 1;
-	.ngpio = 16;
-	.base = -1;
+	.can_sleep = 1,
+	.ngpio = 16,
+	.base = -1,
 };
 
 static int __devinit da9052_gpio_probe(struct platform_device *pdev)
diff --git a/include/linux/mfd/da9052/gpio.h b/include/linux/mfd/da9052/gpio.h
new file mode 100644
index 0000000..8c8eda0
--- /dev/null
+++ b/include/linux/mfd/da9052/gpio.h
@@ -0,0 +1,46 @@
+/*
+ * GPIO module declarations for DA9052 PMICs.
+ *
+ * Copyright(c) 2011 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#ifndef __LINUX_MFD_DA9052_GPIO_H
+#define __LINUX_MFD_DA9052_GPIO_H
+
+#define DA9052_INPUT				1
+#define DA9052_OUTPUT_OPENDRAIN		2
+#define DA9052_OUTPUT_PUSHPULL			3
+
+#define DA9052_SUPPLY_VDD_IO1			0
+
+#define DA9052_DEBOUNCING_OFF			0
+#define DA9052_DEBOUNCING_ON			1
+
+#define DA9052_OUTPUT_LOWLEVEL			0
+
+#define DA9052_ACTIVE_LOW			0
+#define DA9052_ACTIVE_HIGH			1
+
+#define DA9052_GPIO_MAX_PORTS_PER_REGISTER	8
+#define DA9052_GPIO_SHIFT_COUNT(no)		(no%8)
+#define DA9052_GPIO_MASK_UPPER_NIBBLE		0xF0
+#define DA9052_GPIO_MASK_LOWER_NIBBLE		0x0F
+#define DA9052_GPIO_NIBBLE_SHIFT		4
+#define DA9052_IRQ_GPI0			16
+
+#endif /* __LINUX_MFD_DA9052_GPIO_H */
-- 
1.7.1


