Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab2FRJVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 05:21:06 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:46201 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751836Ab2FRJVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 05:21:04 -0400
From: Roland Stigge <stigge@antcom.de>
To: cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rmk+kernel@arm.linux.org.uk, ulf.hansson@stericsson.com,
        linus.walleij@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, aletes.xgr@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] spi: spi-pl022: Adjust probe() to of_get_named_gpio() returning -EPROBE_DEFER
Date: Mon, 18 Jun 2012 11:20:19 +0200
Message-Id: <1340011219-31657-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch to gpiolib-of.c providing -EPROBE_DEFER as a hint to defer
of_get_named_gpio*() to a later probe() breaks spi-pl022.c.

This patch adjusts to this change, using -EPROBE_DEFER as indication to defer.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
Applies to 3.5-rc3

Should this patch be joined with gpiolib-of's patch to of_get_named_gpio()? Or
should they just be issued as a series?

 drivers/spi/spi-pl022.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/drivers/spi/spi-pl022.c
+++ linux-2.6/drivers/spi/spi-pl022.c
@@ -2075,7 +2075,7 @@ pl022_probe(struct amba_device *adev, co
 	for (i = 0; i < num_cs; i++) {
 		int cs_gpio = of_get_named_gpio(np, "cs-gpios", i);
 
-		if (cs_gpio == -ENODEV) {
+		if (cs_gpio == -EPROBE_DEFER) {
 			status = -EPROBE_DEFER;
 			goto err_no_gpio;
 		}
