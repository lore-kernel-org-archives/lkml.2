Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab1HYKyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 06:54:25 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46195 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab1HYKyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 06:54:22 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>, Richard Purdie <rpurdie@rpsys.net>,
        Paul Mundt <lethal@linux-sh.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video/backlight: Remove obsolete cleanup for clientdata
Date: Thu, 25 Aug 2011 12:54:12 +0200
Message-Id: <1314269652-18702-1-git-send-email-w.sang@pengutronix.de>
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
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/video/backlight/adp8870_bl.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/adp8870_bl.c b/drivers/video/backlight/adp8870_bl.c
index 05a8832..71d90f4 100644
--- a/drivers/video/backlight/adp8870_bl.c
+++ b/drivers/video/backlight/adp8870_bl.c
@@ -932,7 +932,6 @@ out:
 out1:
 	backlight_device_unregister(bl);
 out2:
-	i2c_set_clientdata(client, NULL);
 	kfree(data);
 
 	return ret;
@@ -952,7 +951,6 @@ static int __devexit adp8870_remove(struct i2c_client *client)
 			&adp8870_bl_attr_group);
 
 	backlight_device_unregister(data->bl);
-	i2c_set_clientdata(client, NULL);
 	kfree(data);
 
 	return 0;
-- 
1.7.5.4

