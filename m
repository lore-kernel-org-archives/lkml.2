Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab2BXSq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 13:46:57 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39660 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757Ab2BXSqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 13:46:38 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>, Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH RESEND] misc: fsa9480: Remove obsolete cleanup for clientdata
Date: Fri, 24 Feb 2012 19:46:32 +0100
Message-Id: <1330109192-12095-1-git-send-email-w.sang@pengutronix.de>
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
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
---
 drivers/misc/fsa9480.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/fsa9480.c b/drivers/misc/fsa9480.c
index f6586d5..cf8ad87 100644
--- a/drivers/misc/fsa9480.c
+++ b/drivers/misc/fsa9480.c
@@ -458,7 +458,6 @@ fail2:
 	if (client->irq)
 		free_irq(client->irq, usbsw);
 fail1:
-	i2c_set_clientdata(client, NULL);
 	kfree(usbsw);
 	return ret;
 }
@@ -468,7 +467,6 @@ static int __devexit fsa9480_remove(struct i2c_client *client)
 	struct fsa9480_usbsw *usbsw = i2c_get_clientdata(client);
 	if (client->irq)
 		free_irq(client->irq, usbsw);
-	i2c_set_clientdata(client, NULL);
 
 	sysfs_remove_group(&client->dev.kobj, &fsa9480_group);
 	device_init_wakeup(&client->dev, 0);
-- 
1.7.2.5

