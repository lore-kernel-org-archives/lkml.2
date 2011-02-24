Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab1BXBZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 20:25:37 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48882 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab1BXBZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 20:25:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Z6hBLtjHZMLhKegr7+yF0Pgo9UU6msLnQKYzknUSflEIyYqNot3jZAgyatM/B5JhL3
         pr4o2/U/mdSfx0NK8iPhs0ACUbixvDt0tOe9RmA5JFcUP10L4uZSTuknHtsEe5VsC3kt
         guawV92krVLK8vuafQM06E2My/matd1pMHhOA=
Subject: [PATCH] rtc: rtc-ds1390/rtc-ds3234/rtc-m41t94: eliminate compile
	warning
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Jackson <mpfj@mimc.co.uk>, Dennis Aberilla <denzzzhome@yahoo.com>,
        "Kim B. Heino" <Kim.Heino@bluegiga.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com
Content-Type: text/plain
Date: Thu, 24 Feb 2011 09:28:50 +0800
Message-Id: <1298510930.19027.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate the following compile warning:
drivers/rtc/rtc-ds1390.c: In function 'ds1390_remove':
drivers/rtc/rtc-ds1390.c:161: warning: passing argument 1 of 'platform_get_drvdata' from incompatible pointer type
drivers/rtc/rtc-ds3234.c: In function 'ds3234_remove':
drivers/rtc/rtc-ds3234.c:161: warning: passing argument 1 of 'platform_get_drvdata' from incompatible pointer type
drivers/rtc/rtc-m41t94.c: In function 'm41t94_remove':
drivers/rtc/rtc-m41t94.c:139: warning: passing argument 1 of 'platform_get_drvdata' from incompatible pointer type

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Mark Jackson <mpfj@mimc.co.uk>
Cc: Dennis Aberilla <denzzzhome@yahoo.com>
Cc: Kim B. Heino <Kim.Heino@bluegiga.com>
---
 drivers/rtc/rtc-ds1390.c |    2 +-
 drivers/rtc/rtc-ds3234.c |    2 +-
 drivers/rtc/rtc-m41t94.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-ds1390.c b/drivers/rtc/rtc-ds1390.c
index 26a86d2..4832248 100644
--- a/drivers/rtc/rtc-ds1390.c
+++ b/drivers/rtc/rtc-ds1390.c
@@ -158,7 +158,7 @@ static int __devinit ds1390_probe(struct spi_device *spi)
 
 static int __devexit ds1390_remove(struct spi_device *spi)
 {
-	struct ds1390 *chip = platform_get_drvdata(spi);
+	struct ds1390 *chip = dev_get_drvdata(&spi->dev);
 
 	rtc_device_unregister(chip->rtc);
 	kfree(chip);
diff --git a/drivers/rtc/rtc-ds3234.c b/drivers/rtc/rtc-ds3234.c
index a774ca3..07a558e 100644
--- a/drivers/rtc/rtc-ds3234.c
+++ b/drivers/rtc/rtc-ds3234.c
@@ -158,7 +158,7 @@ static int __devinit ds3234_probe(struct spi_device *spi)
 
 static int __devexit ds3234_remove(struct spi_device *spi)
 {
-	struct rtc_device *rtc = platform_get_drvdata(spi);
+	struct rtc_device *rtc = dev_get_drvdata(&spi->dev);
 
 	rtc_device_unregister(rtc);
 	return 0;
diff --git a/drivers/rtc/rtc-m41t94.c b/drivers/rtc/rtc-m41t94.c
index c8c97a4..21e6091 100644
--- a/drivers/rtc/rtc-m41t94.c
+++ b/drivers/rtc/rtc-m41t94.c
@@ -136,7 +136,7 @@ static int __devinit m41t94_probe(struct spi_device *spi)
 
 static int __devexit m41t94_remove(struct spi_device *spi)
 {
-	struct rtc_device *rtc = platform_get_drvdata(spi);
+	struct rtc_device *rtc = dev_get_drvdata(&spi->dev);
 
 	if (rtc)
 		rtc_device_unregister(rtc);
-- 
1.7.2



