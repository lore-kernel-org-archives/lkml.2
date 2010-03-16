Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab0CPEJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 00:09:53 -0400
Received: from mail-yw0-f189.google.com ([209.85.211.189]:56816 "EHLO
	mail-yw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab0CPEJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 00:09:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=DqDznEN2mYbybmi09gv/qVDTiO3HOGnofo/c/SEjN3UrkBK5OPr0PalyNe0KQaKtW1
         VQhHQFlF7mG5Rwg73ubZfgCx6SVxF3WlnuE6JHqKAQeLEZa+xUUETbBdoXoCYUmTVZdi
         pEVSClRW1ozlnHxI62ymn5ox0MI1Tp64UkfFk=
From: tsg321@gmail.com
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging:cx25821: fixes coding styles issues in cx25821-gpio.c This patch is to the cx25821-gpio.c file that fixes up warning and error found by the checkpatch.pl tool Signed-off-by: sai <tsg321@gmail.com>
Date: Tue, 16 Mar 2010 09:39:38 +0530
Message-Id: <1268712578-3391-1-git-send-email-tsg321@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: sai <sai@sai-desktop.(none)>

---
 drivers/staging/cx25821/cx25821-gpio.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-gpio.c b/drivers/staging/cx25821/cx25821-gpio.c
index e8a37b4..cefa091 100644
--- a/drivers/staging/cx25821/cx25821-gpio.c
+++ b/drivers/staging/cx25821/cx25821-gpio.c
@@ -31,7 +31,7 @@ void cx25821_set_gpiopin_direction(struct cx25821_dev *dev,
 	u32 gpio_register = 0;
 	u32 value = 0;
 
-	// Check for valid pinNumber
+	/* Check for valid pinNumber */
 	if (pin_number >= 47)
 		return;
 
@@ -39,14 +39,15 @@ void cx25821_set_gpiopin_direction(struct cx25821_dev *dev,
 		bit = pin_number - 31;
 		gpio_oe_reg = GPIO_HI_OE;
 	}
-	// Here we will make sure that the GPIOs 0 and 1 are output. keep the rest as is
+	/* Here we will make sure that the GPIOs 0 and 1 are output. keep the
+	 * rest as is
+	 */
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
@@ -58,11 +59,12 @@ static void cx25821_set_gpiopin_logicvalue(struct cx25821_dev *dev,
 	u32 gpio_reg = GPIO_LO;
 	u32 value = 0;
 
-	// Check for valid pinNumber
+	/* Check for valid pinNumber */
 	if (pin_number >= 47)
 		return;
 
-	cx25821_set_gpiopin_direction(dev, pin_number, 0);	// change to output direction
+	cx25821_set_gpiopin_direction(dev, pin_number, 0); /* change to output
+							      direction */
 
 	if (pin_number > 31) {
 		bit = pin_number - 31;
@@ -71,25 +73,23 @@ static void cx25821_set_gpiopin_logicvalue(struct cx25821_dev *dev,
 
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
1.6.3.3

