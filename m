Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab1HYKyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 06:54:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46192 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab1HYKyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 06:54:20 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Minkyu Kang <mk7.kang@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] misc: Remove obsolete cleanup for clientdata
Date: Thu, 25 Aug 2011 12:54:04 +0200
Message-Id: <1314269645-18607-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.5.4
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few new i2c-drivers came into the kernel which clear the clientdata-pointer
on exit or error. This is obsolete meanwhile, the core will do it.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Minkyu Kang <mk7.kang@samsung.com>
Cc: Donggeun Kim <dg77.kim@samsung.com>
---
 drivers/misc/fsa9480.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/fsa9480.c b/drivers/misc/fsa9480.c
index 5325a7e..22e22ad 100644
--- a/drivers/misc/fsa9480.c
+++ b/drivers/misc/fsa9480.c
@@ -457,7 +457,6 @@ fail2:
 	if (client->irq)
 		free_irq(client->irq, NULL);
 fail1:
-	i2c_set_clientdata(client, NULL);
 	kfree(usbsw);
 	return ret;
 }
@@ -467,7 +466,6 @@ static int __devexit fsa9480_remove(struct i2c_client *client)
 	struct fsa9480_usbsw *usbsw = i2c_get_clientdata(client);
 	if (client->irq)
 		free_irq(client->irq, NULL);
-	i2c_set_clientdata(client, NULL);
 
 	sysfs_remove_group(&client->dev.kobj, &fsa9480_group);
 	device_init_wakeup(&client->dev, 0);
-- 
1.7.5.4

