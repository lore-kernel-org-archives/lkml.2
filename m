Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab1GDOek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 10:34:40 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39133 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab1GDOeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 10:34:37 -0400
Subject: [PATCH] backlight: ams369fg06: unregister backlight device when
 unload the module
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jingoo Han <jg1.han@samsung.com>, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Jul 2011 22:34:30 +0800
Message-ID: <1309790070.5041.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/backlight/ams369fg06.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/ams369fg06.c b/drivers/video/backlight/ams369fg06.c
index d1d8237..6462d05 100644
--- a/drivers/video/backlight/ams369fg06.c
+++ b/drivers/video/backlight/ams369fg06.c
@@ -553,6 +553,7 @@ static int __devexit ams369fg06_remove(struct spi_device *spi)
 	struct ams369fg06 *lcd = dev_get_drvdata(&spi->dev);
 
 	ams369fg06_power(lcd, FB_BLANK_POWERDOWN);
+	backlight_device_unregister(lcd->bd);
 	lcd_device_unregister(lcd->ld);
 	kfree(lcd);
 
-- 
1.7.4.1



