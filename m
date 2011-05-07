Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab1EGLrL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 07:47:11 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34061 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab1EGLrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 07:47:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=oFLsrTfSXjsCbBkhsAwlyX+f3YeLLmLp8x4HuHlW1B5oQ4VVMDo+lQXmxACn2iIEHN
         l2ePZv4Xdk34VZuL8v3I0Sw8GGFrDB1nbBTMluFgRBvZiB9HM0UqeTf4cN5qEIYpIyfR
         CZ5MYvKxVqPBmrMeWSZKIWWNhr8nEqGXuwTBY=
Message-ID: <4DC53134.8070706@gmail.com>
Date: Sat, 07 May 2011 12:47:00 +0100
From: Maxim Osipov <maxim.osipov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
CC: Maxim Osipov <maxim.osipov@gmail.com>
Subject: [PATCH] AT91: Add external RTC for Flexibity board
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch enables external RTC support on AT91 Flexibity board.

Kind regards,
Maxim


Signed-off-by: Maxim Osipov <maxim.osipov@gmail.com>
---
 arch/arm/mach-at91/board-flexibity.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-at91/board-flexibity.c b/arch/arm/mach-at91/board-flexibity.c
index c8a62dc..4fdc96c 100644
--- a/arch/arm/mach-at91/board-flexibity.c
+++ b/arch/arm/mach-at91/board-flexibity.c
@@ -1,7 +1,7 @@
 /*
  * linux/arch/arm/mach-at91/board-flexibity.c
  *
- *  Copyright (C) 2010 Flexibity
+ *  Copyright (C) 2010-2011 Flexibity
  *  Copyright (C) 2005 SAN People
  *  Copyright (C) 2006 Atmel
  *
@@ -65,6 +65,13 @@ static struct at91_udc_data __initdata flexibity_udc_data = {
 	.pullup_pin	= 0,		/* pull-up driven by UDC */
 };
 
+/* I2C devices */
+static struct i2c_board_info __initdata flexibity_i2c_devices[] = {
+	{
+		I2C_BOARD_INFO("ds1307", 0x68),
+	},
+};
+
 /* SPI devices */
 static struct spi_board_info flexibity_spi_devices[] = {
 	{	/* DataFlash chip */
@@ -143,6 +150,9 @@ static void __init flexibity_board_init(void)
 	at91_add_device_usbh(&flexibity_usbh_data);
 	/* USB Device */
 	at91_add_device_udc(&flexibity_udc_data);
+	/* I2C */
+	at91_add_device_i2c(flexibity_i2c_devices,
+		ARRAY_SIZE(flexibity_i2c_devices));
 	/* SPI */
 	at91_add_device_spi(flexibity_spi_devices,
 		ARRAY_SIZE(flexibity_spi_devices));
-- 
1.7.4.1

