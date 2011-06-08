Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab1FHTsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:48:17 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:60469 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab1FHTsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:48:15 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Nikolaus Voss <n.voss@weinmann.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Grant Likely <grant.likely@secretlab.ca>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] spi/rtc-m41t93: Use spi_get_drvdata() for SPI devices
Date: Wed,  8 Jun 2011 21:48:03 +0200
Message-Id: <1307562483-4883-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One new offender detected by the recently increased type checking in
platform_get_drvdata():

drivers/rtc/rtc-m41t93.c: In function ‘m41t93_remove’:
drivers/rtc/rtc-m41t93.c:192: warning: passing argument 1 of ‘platform_get_drvdata’ from incompatible pointer type

Use spi_get_drvdata() instead of platform_get_drvdata(), cfr. commit
42fea15d6dc410e62dac6a764142045280624a5b ("spi/rtc-{ds1390,ds3234,m41t94}:
Use spi_get_drvdata() for SPI devices")

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/rtc/rtc-m41t93.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-m41t93.c b/drivers/rtc/rtc-m41t93.c
index 1a84b3e..7317d3b 100644
--- a/drivers/rtc/rtc-m41t93.c
+++ b/drivers/rtc/rtc-m41t93.c
@@ -189,7 +189,7 @@ static int __devinit m41t93_probe(struct spi_device *spi)
 
 static int __devexit m41t93_remove(struct spi_device *spi)
 {
-	struct rtc_device *rtc = platform_get_drvdata(spi);
+	struct rtc_device *rtc = spi_get_drvdata(spi);
 
 	if (rtc)
 		rtc_device_unregister(rtc);
-- 
1.7.0.4

