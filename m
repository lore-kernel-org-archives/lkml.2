Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab0CURtY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 13:49:24 -0400
Received: from smtp1.rdslink.ro ([81.196.12.70]:41837 "EHLO smtp.rdslink.ro"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751020Ab0CURtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 13:49:22 -0400
X-Mail-Scanner: Scanned by qSheff-II-2.1-r3 (http://www.enderunix.org/qsheff/)
Subject: 0003-Staging-cx25821-fix-coding-style-issues-in-cx25821-g.patch
From: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>
To: gregkh@suse.de, mchehab@redhat.com, palash.bandyopadhyay@conexant.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Sun, 21 Mar 2010 19:49:09 +0200
Message-ID: <1269193749.6971.4.camel@tuxtm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From fae275cf48fd318cbd88e59e90f119c3f75dab72 Mon Sep 17 00:00:00 2001
From: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>
Date: Sun, 21 Mar 2010 19:44:01 +0200
Subject: [PATCH 3/3] Staging: cx25821: fix coding style issues in cx25821-gpio.c
 This is a patch to cx25821-gpio.c file that fixes up warnings and errors found by the checkpatch.pl tool
 Signed-off-by: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>

---
 drivers/staging/cx25821/cx25821-gpio.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-gpio.c b/drivers/staging/cx25821/cx25821-gpio.c
index e8a37b4..2f154b3 100644
--- a/drivers/staging/cx25821/cx25821-gpio.c
+++ b/drivers/staging/cx25821/cx25821-gpio.c
@@ -31,7 +31,7 @@ void cx25821_set_gpiopin_direction(struct cx25821_dev *dev,
 	u32 gpio_register = 0;
 	u32 value = 0;
 
-	// Check for valid pinNumber
+	/* Check for valid pinNumber */
 	if (pin_number >= 47)
 		return;
 
@@ -39,14 +39,14 @@ void cx25821_set_gpiopin_direction(struct cx25821_dev *dev,
 		bit = pin_number - 31;
 		gpio_oe_reg = GPIO_HI_OE;
 	}
-	// Here we will make sure that the GPIOs 0 and 1 are output. keep the rest as is
+	/* Here we will make sure that the GPIOs 0 and 1 are output. keep the
+	 * rest as is */
 	gpio_register = cx_read(gpio_oe_reg);
 
-	if (pin_logic_value == 1) {
+	if (pin_logic_value == 1)
 		value = gpio_register | Set_GPIO_Bit(bit);
-	} else {
+	else
 		value = gpio_register & Clear_GPIO_Bit(bit);
-	}
 
 	cx_write(gpio_oe_reg, value);
 }
@@ -58,11 +58,12 @@ static void cx25821_set_gpiopin_logicvalue(struct cx25821_dev *dev,
 	u32 gpio_reg = GPIO_LO;
 	u32 value = 0;
 
-	// Check for valid pinNumber
+	/* Check for valid pinNumber */
 	if (pin_number >= 47)
 		return;
 
-	cx25821_set_gpiopin_direction(dev, pin_number, 0);	// change to output direction
+	/* change to output direction */
+	cx25821_set_gpiopin_direction(dev, pin_number, 0);
 
 	if (pin_number > 31) {
 		bit = pin_number - 31;
@@ -71,25 +72,23 @@ static void cx25821_set_gpiopin_logicvalue(struct cx25821_dev *dev,
 
 	value = cx_read(gpio_reg);
 
-	if (pin_logic_value == 0) {
+	if (pin_logic_value == 0)
 		value &= Clear_GPIO_Bit(bit);
-	} else {
+	else
 		value |= Set_GPIO_Bit(bit);
-	}
 
 	cx_write(gpio_reg, value);
 }
 
 void cx25821_gpio_init(struct cx25821_dev *dev)
 {
-	if (dev == NULL) {
+	if (dev == NULL)
 		return;
-	}
 
 	switch (dev->board) {
 	case CX25821_BOARD_CONEXANT_ATHENA10:
 	default:
-		//set GPIO 5 to select the path for Medusa/Athena
+		/* set GPIO 5 to select the path for Medusa/Athena */
 		cx25821_set_gpiopin_logicvalue(dev, 5, 1);
 		mdelay(20);
 		break;
-- 
1.7.0



