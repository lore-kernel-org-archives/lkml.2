Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab0KZJkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 04:40:11 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50839 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab0KZJkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 04:40:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-tuid:x-uid:x-length
         :organization:to:cc:content-type:content-transfer-encoding
         :message-id;
        b=hch3XhGiziG19J0ifpeD1hWo05tE/b/nMnrFFsx7Fi9KBb++oNcMmYs4OvcSSaxZHK
         ldsiBaLKflit98x+hK249E8MwOkHThx+0dzxbJxELk8uT0zEAxpp01IXJ4w874jyCT+u
         NtCSKEaGgHFn+NgR8SqNRq/qKch7xWNzlNsyQ=
From: Florian Fainelli <florian@openwrt.org>
Date: Fri, 26 Nov 2010 10:39:54 +0100
Subject: [PATCH 1/2] rdc321x-gpio: fix null pointer dereference while accessing platform_data
MIME-Version: 1.0
X-TUID: 7559ef157b0bfeb6
X-Length: 1633
Organization: OpenWrt
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011261039.54817.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rdc321x-gpio currently fetches its driver specific data by using the platform_
device->platform_data pointer, this is wrong because the mfd device which
registers our platform_device has been added using mfd_add_device() which sets
the platform_device->driver_data pointer instead.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
CC: stable@kernel.org
---
This patch should be applied for the next 2.6.36 stable release.

diff --git a/drivers/gpio/rdc321x-gpio.c b/drivers/gpio/rdc321x-gpio.c
index 2762698..897e057 100644
--- a/drivers/gpio/rdc321x-gpio.c
+++ b/drivers/gpio/rdc321x-gpio.c
@@ -135,7 +135,7 @@ static int __devinit rdc321x_gpio_probe(struct platform_device *pdev)
 	struct rdc321x_gpio *rdc321x_gpio_dev;
 	struct rdc321x_gpio_pdata *pdata;
 
-	pdata = pdev->dev.platform_data;
+	pdata = platform_get_drvdata(pdev);
 	if (!pdata) {
 		dev_err(&pdev->dev, "no platform data supplied\n");
 		return -ENODEV;
