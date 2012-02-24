Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab2BXSqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 13:46:21 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39655 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab2BXSqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 13:46:20 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>, NeilBrown <neilb@suse.de>,
        Richard Purdie <rpurdie@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] leds: tca6507: Remove obsolete cleanup for clientdata
Date: Fri, 24 Feb 2012 19:46:08 +0100
Message-Id: <1330109168-11929-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.5
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
Cc: NeilBrown <neilb@suse.de>
Cc: Richard Purdie <rpurdie@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/leds/leds-tca6507.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-tca6507.c b/drivers/leds/leds-tca6507.c
index 133f89f..2fc327e 100644
--- a/drivers/leds/leds-tca6507.c
+++ b/drivers/leds/leds-tca6507.c
@@ -728,7 +728,6 @@ exit:
 		if (tca->leds[i].led_cdev.name)
 			led_classdev_unregister(&tca->leds[i].led_cdev);
 	cancel_work_sync(&tca->work);
-	i2c_set_clientdata(client, NULL);
 	kfree(tca);
 	return err;
 }
@@ -745,7 +744,6 @@ static int __devexit tca6507_remove(struct i2c_client *client)
 	}
 	tca6507_remove_gpio(tca);
 	cancel_work_sync(&tca->work);
-	i2c_set_clientdata(client, NULL);
 	kfree(tca);
 
 	return 0;
-- 
1.7.2.5

