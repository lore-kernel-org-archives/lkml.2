Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab1CQNsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 09:48:03 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:58299 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab1CQNsB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 09:48:01 -0400
Date: Thu, 17 Mar 2011 14:47:56 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alessandro Zummo <a.zummo@towertech.it>
cc: rtc-linux@googlegroups.com, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net
Subject: [PATCH] rtc-{ds1390,ds3234,m41t94}: Use spi_get_drvdata() for SPI
 devices
Message-ID: <alpine.DEB.2.00.1103171446130.23741@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recently increased type checking in platform_get_drvdata() reveals a few
offenders:

drivers/rtc/rtc-ds1390.c:161: warning: passing argument 1 of ¡platform_get_drvdata¢ from incompatible pointer type
drivers/rtc/rtc-ds3234.c:161: warning: passing argument 1 of ¡platform_get_drvdata¢ from incompatible pointer type
drivers/rtc/rtc-m41t94.c:139: warning: passing argument 1 of ¡platform_get_drvdata¢ from incompatible pointer type

Use spi_get_drvdata() instead of platform_get_drvdata().

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
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
1.7.0.4


Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
