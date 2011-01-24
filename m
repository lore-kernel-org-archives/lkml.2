Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab1AXKpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 05:45:06 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60490 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab1AXKpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 05:45:00 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] mfd: Remove obsolete cleanup for clientdata
Date: Mon, 24 Jan 2011 11:44:27 +0100
Message-Id: <1295865880-27672-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few new i2c-drivers came into the kernel which clear the clientdata-pointer
on exit or error. This is obsolete meanwhile, the core will do it.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/wl1273-core.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/wl1273-core.c b/drivers/mfd/wl1273-core.c
index d2ecc24..6bb5136 100644
--- a/drivers/mfd/wl1273-core.c
+++ b/drivers/mfd/wl1273-core.c
@@ -38,7 +38,6 @@ static int wl1273_core_remove(struct i2c_client *client)
 	dev_dbg(&client->dev, "%s\n", __func__);
 
 	mfd_remove_devices(&client->dev);
-	i2c_set_clientdata(client, NULL);
 	kfree(core);
 
 	return 0;
@@ -104,7 +103,6 @@ static int __devinit wl1273_core_probe(struct i2c_client *client,
 	return 0;
 
 err:
-	i2c_set_clientdata(client, NULL);
 	pdata->free_resources();
 	kfree(core);
 
-- 
1.7.2.3

