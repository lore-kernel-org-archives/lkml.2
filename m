Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab2ECRPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 13:15:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53810 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752313Ab2ECRPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 13:15:23 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/3] gpiolib: Convert to devres_release()
Date: Thu,  3 May 2012 18:15:14 +0100
Message-Id: <1336065314-11696-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336065314-11696-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1336065314-11696-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/gpio/devres.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpio/devres.c b/drivers/gpio/devres.c
index d21a9ff..9e9947c 100644
--- a/drivers/gpio/devres.c
+++ b/drivers/gpio/devres.c
@@ -112,8 +112,7 @@ int devm_gpio_request_one(struct device *dev, unsigned gpio,
 void devm_gpio_free(struct device *dev, unsigned int gpio)
 {
 
-	WARN_ON(devres_destroy(dev, devm_gpio_release, devm_gpio_match,
+	WARN_ON(devres_release(dev, devm_gpio_release, devm_gpio_match,
 		&gpio));
-	gpio_free(gpio);
 }
 EXPORT_SYMBOL(devm_gpio_free);
-- 
1.7.10

