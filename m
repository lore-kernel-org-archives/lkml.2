Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab1CRADG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 20:03:06 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62156 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755716Ab1CRADE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 20:03:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=RmgdAfkWC9A0IbBGCFUIAjLcq4e2wQnml3/JImpqhTxNsWG9IenAp4Mo265LGvN6N8
         dv+sUpuNl6AK5iQqU/xbaJKGuNR9F4bZRwyOCUw0l5xhRLmk2bjLOJpEu72riM/RkL73
         kkeJ3I5X3GFS5VSnoYUjPruYm8S8RMjlaRyeE=
Subject: [PATCH v2] rtc: rtc-ds1390/rtc-ds3234/rtc-m41t94: eliminate
 compile warning
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dennis Aberilla <denzzzhome@yahoo.com>,
        Dennis Aberilla <denzzzhome@yahoo.com>, Mark Jackson <mpfj@mimc.co.uk>,
        "Kim B. Heino" <Kim.Heino@bluegiga.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Mar 2011 08:02:55 +0800
Message-ID: <1300406575.2241.5.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These drivers are registered as spi drivers,
thus use spi_get_drvdata instead of platform_get_drvdata.

This patch eliminates the following compile warning:
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
index 26a86d2..b038d2c 100644
--- a/drivers/rtc/rtc-ds1390.c
+++ b/drivers/rtc/rtc-ds1390.c
@@ -158,7 +158,7 @@ static int __devinit ds1390_probe(struct spi_device *spi)
 
 static int __devexit ds1390_remove(struct spi_device *spi)
 {
-	struct ds1390 *chip = platform_get_drvdata(spi);
+	struct ds1390 *chip = spi_get_drvdata(spi);
 
 	rtc_device_unregister(chip->rtc);
 	kfree(chip);
diff --git a/drivers/rtc/rtc-ds3234.c b/drivers/rtc/rtc-ds3234.c
index a774ca3..bbd2622 100644
--- a/drivers/rtc/rtc-ds3234.c
+++ b/drivers/rtc/rtc-ds3234.c
@@ -158,7 +158,7 @@ static int __devinit ds3234_probe(struct spi_device *spi)
 
 static int __devexit ds3234_remove(struct spi_device *spi)
 {
-	struct rtc_device *rtc = platform_get_drvdata(spi);
+	struct rtc_device *rtc = spi_get_drvdata(spi);
 
 	rtc_device_unregister(rtc);
 	return 0;
diff --git a/drivers/rtc/rtc-m41t94.c b/drivers/rtc/rtc-m41t94.c
index c8c97a4..e259ed7 100644
--- a/drivers/rtc/rtc-m41t94.c
+++ b/drivers/rtc/rtc-m41t94.c
@@ -136,7 +136,7 @@ static int __devinit m41t94_probe(struct spi_device *spi)
 
 static int __devexit m41t94_remove(struct spi_device *spi)
 {
-	struct rtc_device *rtc = platform_get_drvdata(spi);
+	struct rtc_device *rtc = spi_get_drvdata(spi);
 
 	if (rtc)
 		rtc_device_unregister(rtc);
-- 
1.7.1



