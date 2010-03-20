Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab0CTONp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 10:13:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59013 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab0CTONg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:13:36 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: kernel-janitors@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wolfram Sang <w.sang@pengutronix.de>,
       Ryan Mallon <ryan@bluewatersys.com>,
       Anton Vorontsov <cbouatmailru@gmail.com>
Date: Sat, 20 Mar 2010 15:12:43 +0100
Message-Id: <1269094385-16114-3-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: [PATCH 02/24] power/ds2782: really clear i2c_clientdata on exit
X-SA-Exim-Version: 4.2.1 (built Sat, 01 Aug 2009 12:09:26 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Probably due to a copy & paste bug, clientdata was set again to the data
structure (which is freed immediately afterwards) when it should be NULLed.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Ryan Mallon <ryan@bluewatersys.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
---
 drivers/power/ds2782_battery.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
index da14f37..6971b85 100644
--- a/drivers/power/ds2782_battery.c
+++ b/drivers/power/ds2782_battery.c
@@ -236,7 +236,7 @@ static int ds2782_battery_remove(struct i2c_client *client)
 	idr_remove(&battery_id, info->id);
 	mutex_unlock(&battery_lock);
 
-	i2c_set_clientdata(client, info);
+	i2c_set_clientdata(client, NULL);
 
 	kfree(info);
 	return 0;
@@ -289,7 +289,7 @@ static int ds2782_battery_probe(struct i2c_client *client,
 fail_register:
 	kfree(info->battery.name);
 fail_name:
-	i2c_set_clientdata(client, info);
+	i2c_set_clientdata(client, NULL);
 	kfree(info);
 fail_info:
 	mutex_lock(&battery_lock);
-- 
1.7.0

