Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab2IDIkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 04:40:55 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:25701 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658Ab2IDIkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 04:40:53 -0400
Date: Tue, 4 Sep 2012 10:40:44 +0200
Message-Id: <201209040840.q848eiPg028975@localhost.localdomain>
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [PATCH 1/2] hwmon/lm70: Allow 4wire SPI bus with LM70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing the 3wire limitation on LM70 as the component also allows
operation on 4wire SPI bus

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

diff -u linux-3.5-vanilla/drivers/hwmon/lm70.c linux-3.5/drivers/hwmon/lm70.c
--- linux-3.5-vanilla/drivers/hwmon/lm70.c	2012-07-21 22:58:29.000000000 +0200
+++ linux-3.5/drivers/hwmon/lm70.c	2012-08-25 00:35:40.000000000 +0200
@@ -143,10 +143,6 @@
 	if (spi->mode & (SPI_CPOL | SPI_CPHA))
 		return -EINVAL;
 
-	/* 3-wire link (shared SI/SO) for LM70 */
-	if (chip == LM70_CHIP_LM70 && !(spi->mode & SPI_3WIRE))
-		return -EINVAL;
-
 	/* NOTE:  we assume 8-bit words, and convert to 16 bits manually */
 
 	p_lm70 = kzalloc(sizeof *p_lm70, GFP_KERNEL);
diff -u linux-3.5-vanilla/Documentation/hwmon/lm70 linux-3.5/Documentation/hwmon/lm70
--- linux-3.5-vanilla/Documentation/hwmon/lm70	2012-07-21 22:58:29.000000000 +0200
+++ linux-3.5/Documentation/hwmon/lm70	2012-08-25 00:37:15.000000000 +0200
@@ -31,9 +31,8 @@
 with a "SPI master controller driver", see drivers/spi/spi_lm70llp.c
 and its associated documentation.
 
-The TMP121/TMP123 are very similar; main differences are 4 wire SPI inter-
-face (read only) and 13-bit temperature data (0.0625 degrees celsius reso-
-lution).
+The TMP121/TMP123 are very similar; main difference is 13-bit temperature
+data (0.0625 degrees celsius resolution).
 
 Thanks to
 ---------
