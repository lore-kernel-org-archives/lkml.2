Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab0DWKMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 06:12:23 -0400
Received: from getacmail.getac.com.tw ([203.66.140.6]:63223 "EHLO
	getacmail.getac.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756892Ab0DWKMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 06:12:21 -0400
X-Greylist: delayed 916 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Apr 2010 06:12:20 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: [PATCH] l4f00242t03: fix memory leaks in error handling
Date: Fri, 23 Apr 2010 17:56:53 +0800
Message-ID: <1AB93CE9C271144CA0E1E10487DA040806BC7D@MTCEXVS01.mitacad.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] l4f00242t03: fix memory leaks in error handling
Thread-Index: Acriy00BbkBL3568TYeJdlIhgs1cug==
From: <axel.lin@getac.com.tw>
To: <linux-kernel@vger.kernel.org>
Cc: <rpurdie@linux.intel.com>, <maramaopercheseimorto@gmail.com>
X-OriginalArrivalTime: 23 Apr 2010 09:56:53.0895 (UTC) FILETIME=[4D70B170:01CAE2CB]
X-MAIL: getacmail.getac.com.tw o3N9uqgk025087
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o3NACRmE014977


1. It is not necessary to free priv if kzalloc fail.
2. priv should be freed if gpio_request for pdata->reset_gpio and pdata->data_enable_gpio fail.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Richard Purdie <rpurdie@linux.intel.com>
---
 drivers/video/backlight/l4f00242t03.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/backlight/l4f00242t03.c b/drivers/video/backlight/l4f00242t03.c
index bcdb12c..05d32e3 100644
--- a/drivers/video/backlight/l4f00242t03.c
+++ b/drivers/video/backlight/l4f00242t03.c
@@ -126,7 +126,7 @@ static int __devinit l4f00242t03_probe(struct spi_device *spi)
 	if (priv == NULL) {
 		dev_err(&spi->dev, "No memory for this device.\n");
 		ret = -ENOMEM;
-		goto err;
+		return ret;
 	}
 
 	dev_set_drvdata(&spi->dev, priv);
@@ -139,7 +139,7 @@ static int __devinit l4f00242t03_probe(struct spi_device *spi)
 	if (ret) {
 		dev_err(&spi->dev,
 			"Unable to get the lcd l4f00242t03 reset gpio.\n");
-		return ret;
+		goto err;
 	}
 
 	ret = gpio_direction_output(pdata->reset_gpio, 1);
@@ -151,7 +151,7 @@ static int __devinit l4f00242t03_probe(struct spi_device *spi)
 	if (ret) {
 		dev_err(&spi->dev,
 			"Unable to get the lcd l4f00242t03 data en gpio.\n");
-		return ret;
+		goto err2;
 	}
 
 	ret = gpio_direction_output(pdata->data_enable_gpio, 0);
-- 
1.5.4.3
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
