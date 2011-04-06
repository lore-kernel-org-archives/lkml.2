Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab1DFLMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 07:12:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52680 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360Ab1DFLLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:11:14 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, tglx@linutronix.de, cbouatmailru@gmail.com,
        grant.likely@secretlab.ca, arnd@arndb.de, nico@fluxnic.net,
        Jamie Iles <jamie@jamieiles.com>
Subject: [RFC PATCH 2/7] basic_mmio_gpio: convert to platform_{get,set}_drvdata()
Date: Wed,  6 Apr 2011 12:10:58 +0100
Message-Id: <1302088263-12714-3-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1302088263-12714-1-git-send-email-jamie@jamieiles.com>
References: <1302088263-12714-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the platform drvdata helpers rather than working on the struct
device itself.

Signed-off-by: Jamie Iles <jamie@jamieiles.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/gpio/basic_mmio_gpio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/basic_mmio_gpio.c
index 26f84e2..e6cce48 100644
--- a/drivers/gpio/basic_mmio_gpio.c
+++ b/drivers/gpio/basic_mmio_gpio.c
@@ -296,7 +296,7 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
 	else
 		bgc->gc.base = -1;
 
-	dev_set_drvdata(dev, bgc);
+	platform_set_drvdata(pdev, bgc);
 
 	ret = gpiochip_add(&bgc->gc);
 	if (ret)
@@ -307,7 +307,7 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
 
 static int __devexit bgpio_remove(struct platform_device *pdev)
 {
-	struct bgpio_chip *bgc = dev_get_drvdata(&pdev->dev);
+	struct bgpio_chip *bgc = platform_get_drvdata(pdev);
 
 	return gpiochip_remove(&bgc->gc);
 }
-- 
1.7.4

