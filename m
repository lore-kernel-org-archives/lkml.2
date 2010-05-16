Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab0EPKC3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 06:02:29 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:34253 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab0EPKC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 06:02:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-tuid:x-uid:x-length:to
         :reply-to:content-type:content-transfer-encoding:message-id;
        b=L9nHj0jCg38sX5ljvAxTp2X7nVOa7OAKybKqYV51imjZG17IY2qXUOXDBsYNMKMoXU
         5SQiD/bkaBft6ipqzmZgAynOfHGfJUiCSOgLUyzmMF5Hrcl3wnC8YCHcksJV9dCVrOxG
         S4TdE+/Nrxr6fpUAufpZLJ4m7DuTcJBY047oI=
From: Florian Fainelli <florian@openwrt.org>
Date: Sun, 16 May 2010 12:02:18 +0200
Subject: [PATCH] GPIO: rdc321x fix inverted gpio data out registers
MIME-Version: 1.0
X-TUID: acb6245bc277ea58
X-Length: 1409
To: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Reply-To: Florian Fainelli <florian@openwrt.org>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005161202.21614.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rdc_gpio_set_value_impl has the gpio data registers 1 and 2 inverted, fix this.

Signed-off-by: Bernhard Loos <bernhardloos@gmail.com>
Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
diff --git a/drivers/gpio/rdc321x-gpio.c b/drivers/gpio/rdc321x-gpio.c
index 22f31dc..2762698 100644
--- a/drivers/gpio/rdc321x-gpio.c
+++ b/drivers/gpio/rdc321x-gpio.c
@@ -73,7 +73,7 @@ static void rdc_gpio_set_value_impl(struct gpio_chip *chip,
 		gpch->data_reg[reg] &= ~(1 << (gpio & 0x1f));
 
 	pci_write_config_dword(gpch->sb_pdev,
-			reg ? gpch->reg1_data_base : gpch->reg2_data_base,
+			reg ? gpch->reg2_data_base : gpch->reg1_data_base,
 			gpch->data_reg[reg]);
 }
 
