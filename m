Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab3AFRfk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 12:35:40 -0500
Received: from mail.free-electrons.com ([94.23.32.191]:38268 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119Ab3AFRfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 12:35:17 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>,
        Roland Stigge <stigge@antcom.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH 2/3] gpio: pca953x: add support for pca9505
Date: Sun,  6 Jan 2013 18:34:47 +0100
Message-Id: <1357493688-25061-3-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357493688-25061-1-git-send-email-gregory.clement@free-electrons.com>
References: <1357493688-25061-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that pca953x driver can handle GPIO expanders with more than 32
bits this patch adds the support for the pca9505 which cam with 40
GPIOs.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 drivers/gpio/gpio-pca953x.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index aa9b6b2..8bf70a2 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -46,6 +46,7 @@
 #define PCA957X_TYPE		0x2000
 
 static const struct i2c_device_id pca953x_id[] = {
+	{ "pca9505", 40 | PCA953X_TYPE | PCA_INT, },
 	{ "pca9534", 8  | PCA953X_TYPE | PCA_INT, },
 	{ "pca9535", 16 | PCA953X_TYPE | PCA_INT, },
 	{ "pca9536", 4  | PCA953X_TYPE, },
@@ -829,6 +830,7 @@ static int pca953x_remove(struct i2c_client *client)
 }
 
 static const struct of_device_id pca953x_dt_ids[] = {
+	{ .compatible = "nxp,pca9505", },
 	{ .compatible = "nxp,pca9534", },
 	{ .compatible = "nxp,pca9535", },
 	{ .compatible = "nxp,pca9536", },
-- 
1.7.9.5

