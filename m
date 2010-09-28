Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab0I1VTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 17:19:00 -0400
Received: from mailout17.yourhostingaccount.com ([65.254.253.141]:55674 "EHLO
	mailout17.yourhostingaccount.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752644Ab0I1VS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 17:18:59 -0400
X-Greylist: delayed 2031 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Sep 2010 17:18:59 EDT
X-EN-OrigOutIP: 10.1.18.6
X-EN-IMPSID: CLkw1f00D07rVmq0000000
From: Sinan Akman <sinan@writeme.com>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, avorontsov@ru.mvista.com, sinan@writeme.com,
        dbrownell@users.sourceforge.net
Subject: [PATCH] spi: Add OF-style registration and binding
Date: Tue, 28 Sep 2010 16:47:28 -0400
Message-Id: <1285706848-9281-1-git-send-email-sinan@writeme.com>
X-Mailer: git-send-email 1.6.2.5
X-EN-UserInfo: 9579962fb128fd4edc0e15f211ef4629:b3dd9e212e2067e834de66fc17565494
X-EN-AuthUser: remote@bootbits.com
X-EN-OrigIP: 174.91.219.242
X-EN-OrigHost: bas1-montreal43-2925255666.dsl.bell.ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the OF hook to the spi core so that devices
can automatically be registered based on device tree data.

Signed-off-by: Sinan Akman <sinan@writeme.com>
---
 drivers/spi/spi.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 0bcf4c1..b5a78a1 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/cache.h>
 #include <linux/mutex.h>
+#include <linux/of_device.h>
 #include <linux/slab.h>
 #include <linux/mod_devicetable.h>
 #include <linux/spi/spi.h>
@@ -86,6 +87,10 @@ static int spi_match_device(struct device *dev, struct device_driver *drv)
 	const struct spi_device	*spi = to_spi_device(dev);
 	const struct spi_driver	*sdrv = to_spi_driver(drv);
 
+	/* Attempt an OF style match */
+	if (of_driver_match_device(dev, drv))
+		return 1;
+
 	if (sdrv->id_table)
 		return !!spi_match_id(sdrv->id_table, spi);
 
-- 
1.6.2.5

