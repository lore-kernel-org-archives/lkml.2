Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab1JJWW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 18:22:57 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:41513 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753340Ab1JJWWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 18:22:55 -0400
X-Authenticated: #1242716
X-Provags-ID: V01U2FsdGVkX194zXFSAE94yTFelGzGyX7leFDwIzIAJGbw04bZsK
	sEgmWLXU7ZYLM6
Message-ID: <4E93703C.9050307@gmx.de>
Date: Tue, 11 Oct 2011 00:22:52 +0200
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Firefox/7.0.1 SeaMonkey/2.4.1
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org
Subject: [Patch 2/2] gpio-pca953x: fix gpio_base and add verbosity
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inspired by the gpio-pcf857x driver, this patch will output information
about the instantiated gpio-chip, including gpio start and end, chip
type and if irq is used.

Signed-off-by: Hartmut Knaack <knaack.h@gmx.de>
-------------------------------------------------------------
diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index ae479fd..4bdb88e 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -683,6 +683,12 @@ static int __devinit pca953x_probe(struct
i2c_client *client,
     if (ret)
         goto out_failed;
 
+    dev_info(&client->dev, "gpios %d..%d added on a %s%s\n",
+         chip->gpio_chip.base,
+         chip->gpio_chip.base + chip->gpio_chip.ngpio - 1,
+         client->name,
+         client->irq ? " (irq ignored)" : "");
+   
     ret = gpiochip_add(&chip->gpio_chip);
     if (ret)
         goto out_failed_irq;

