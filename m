Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab0KAHCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 03:02:05 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44769 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab0KAHCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 03:02:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=B8KDtyUpEutRQ10nQ0FocZda/HgexSmfBC6g8xR/BQCf0thfjxgK3QBBlZsD3vnzcF
         +/aWhoFxZnyEi7qUISZOk045xJMurpCClgGOeoi+JmruDMZXlev/sGwhIIW2XLEqOFZn
         TZ1IcjIVz5yDmLbgKxeqgwXkJKD71eLezqSlk=
Subject: [PATCH] gpio: 74x164 cleanups
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Miguel Gaio <miguel.gaio@efixo.com>, Juhos Gabor <juhosg@openwrt.org>,
        Florian Fainelli <florian@openwrt.org>
Content-Type: text/plain
Date: Mon, 01 Nov 2010 15:05:02 +0800
Message-Id: <1288595102.8657.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the coding style for gen_74x164_probe
and adds __devexit annotation for gen_74x164_remove.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpio/74x164.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/74x164.c b/drivers/gpio/74x164.c
index d91ff4c..afefd01 100644
--- a/drivers/gpio/74x164.c
+++ b/drivers/gpio/74x164.c
@@ -104,8 +104,8 @@ static int __devinit gen_74x164_probe(struct spi_device *spi)
 
 	chip->spi = spi;
 
-	chip->gpio_chip.label = GEN_74X164_DRIVER_NAME,
-		chip->gpio_chip.direction_output = gen_74x164_direction_output;
+	chip->gpio_chip.label = GEN_74X164_DRIVER_NAME;
+	chip->gpio_chip.direction_output = gen_74x164_direction_output;
 	chip->gpio_chip.get = gen_74x164_get_value;
 	chip->gpio_chip.set = gen_74x164_set_value;
 	chip->gpio_chip.base = pdata->base;
@@ -133,7 +133,7 @@ exit_destroy:
 	return ret;
 }
 
-static int gen_74x164_remove(struct spi_device *spi)
+static int __devexit gen_74x164_remove(struct spi_device *spi)
 {
 	struct gen_74x164_chip *chip;
 	int ret;
-- 
1.7.2



