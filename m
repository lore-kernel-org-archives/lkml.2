Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab0G1DFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 23:05:40 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51524 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab0G1DFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 23:05:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=OGXUBK7LRf3AyyNKyC5AQunUdVtC5b3KV9gdT38+nqcEGC2hq8kms+Aps0tr/TPykd
         zc+plJi8BGFnaq9tAd2jjxHLaihc+CLQGa343sFR+TMR1jtyGZZTygRMHcpD1AgXgzqm
         JGplB3gFmdZHzwYZn4pvNUzJP9uFn4Xxk26kE=
Subject: [PATCH 1/2] s6e63m0: unregister backlight device and remove sysfs
	attribute file in s6e63m0_remove
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        InKi Dae <inki.dae@samsung.com>
Content-Type: text/plain
Date: Wed, 28 Jul 2010 11:06:13 +0800
Message-Id: <1280286373.19065.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s6e63m0_probe() registered backlight device and create sysfs attribute files,
thus s6e63m0_remove() should unregister backlight device and remove sysfs
attribute files.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/backlight/s6e63m0.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/s6e63m0.c b/drivers/video/backlight/s6e63m0.c
index a3128c9..b27ccf9 100644
--- a/drivers/video/backlight/s6e63m0.c
+++ b/drivers/video/backlight/s6e63m0.c
@@ -829,6 +829,9 @@ static int __devexit s6e63m0_remove(struct spi_device *spi)
 	struct s6e63m0 *lcd = dev_get_drvdata(&spi->dev);
 
 	s6e63m0_power(lcd, FB_BLANK_POWERDOWN);
+	device_remove_file(&spi->dev, &dev_attr_gamma_table);
+	device_remove_file(&spi->dev, &dev_attr_gamma_mode);
+	backlight_device_unregister(lcd->bd);
 	lcd_device_unregister(lcd->ld);
 	kfree(lcd);
 
-- 
1.5.4.3



