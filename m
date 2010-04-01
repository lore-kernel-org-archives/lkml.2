Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab0DAK2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 06:28:55 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37932 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab0DAK2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 06:28:49 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>,
       Ryan Mallon <ryan@bluewatersys.com>, Hans Verkuil <hverkuil@xs4all.nl>,
       Anton Vorontsov <cbouatmailru@gmail.com>,
       Jean Delvare <khali@linux-fr.org>
Date: Thu,  1 Apr 2010 12:27:44 +0200
Message-Id: <1270117664-29099-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.0
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: [PATCH] power/ds2782: fix clientdata on removal
X-SA-Exim-Version: 4.2.1 (built Sat, 01 Aug 2009 12:09:26 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Probably due to a copy & paste bug, clientdata was set again to the data
structure (which is freed immediately afterwards) when it should be
NULLed. Just remove the calls as the i2c-core does this automatically
now.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Ryan Mallon <ryan@bluewatersys.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>
---

Anton: If it is okay with you, I think this should go via the I2C-tree to
ensure it comes after the needed modification of the i2c-core.

 drivers/power/ds2782_battery.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
index da14f37..305d463 100644
--- a/drivers/power/ds2782_battery.c
+++ b/drivers/power/ds2782_battery.c
@@ -236,8 +236,6 @@ static int ds2782_battery_remove(struct i2c_client *client)
 	idr_remove(&battery_id, info->id);
 	mutex_unlock(&battery_lock);
 
-	i2c_set_clientdata(client, info);
-
 	kfree(info);
 	return 0;
 }
@@ -289,7 +287,6 @@ static int ds2782_battery_probe(struct i2c_client *client,
 fail_register:
 	kfree(info->battery.name);
 fail_name:
-	i2c_set_clientdata(client, info);
 	kfree(info);
 fail_info:
 	mutex_lock(&battery_lock);
-- 
1.7.0

