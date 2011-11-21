Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab1KUR52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 12:57:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44239 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753688Ab1KUR51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 12:57:27 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        David Jander <david@protonic.nl>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] gpio: pca953x: Staticise pca953x_get_altdata()
Date: Mon, 21 Nov 2011 17:57:25 +0000
Message-Id: <1321898245-5231-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not used outside of the driver so doesn't need to be exported, and
sparse notices this and complains about it.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/gpio/gpio-pca953x.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 147df8a..d3f3e8f 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -546,7 +546,7 @@ static void pca953x_irq_teardown(struct pca953x_chip *chip)
  * Translate OpenFirmware node properties into platform_data
  * WARNING: This is DEPRECATED and will be removed eventually!
  */
-void
+static void
 pca953x_get_alt_pdata(struct i2c_client *client, int *gpio_base, int *invert)
 {
 	struct device_node *node;
@@ -574,7 +574,7 @@ pca953x_get_alt_pdata(struct i2c_client *client, int *gpio_base, int *invert)
 		*invert = *val;
 }
 #else
-void
+static void
 pca953x_get_alt_pdata(struct i2c_client *client, int *gpio_base, int *invert)
 {
 	*gpio_base = -1;
-- 
1.7.7.3

