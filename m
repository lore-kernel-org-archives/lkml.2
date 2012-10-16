Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab2JPNYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 09:24:17 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:51370 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751266Ab2JPNYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 09:24:16 -0400
From: Roland Stigge <stigge@antcom.de>
To: maxime.ripard@free-electrons.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] gpio-74x164: Fix buffer allocation size
Date: Tue, 16 Oct 2012 15:24:01 +0200
Message-Id: <1350393841-29698-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new registers handling in the gpio-74x164 driver allocates chip->registers
* 8 bytes where only one byte per register is necessary. This patch fixes this.

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 drivers/gpio/gpio-74x164.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/drivers/gpio/gpio-74x164.c
+++ linux-2.6/drivers/gpio/gpio-74x164.c
@@ -153,7 +153,7 @@ static int __devinit gen_74x164_probe(st
 	}
 
 	chip->gpio_chip.ngpio = GEN_74X164_NUMBER_GPIOS * chip->registers;
-	chip->buffer = devm_kzalloc(&spi->dev, chip->gpio_chip.ngpio, GFP_KERNEL);
+	chip->buffer = devm_kzalloc(&spi->dev, chip->registers, GFP_KERNEL);
 	if (!chip->buffer) {
 		ret = -ENOMEM;
 		goto exit_destroy;
