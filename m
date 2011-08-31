Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab1HaDoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 23:44:44 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46958 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab1HaDon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 23:44:43 -0400
Subject: [PATCH] hwmon: (pmbus) Fix the logic of checking if no id is
 matched
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 11:44:32 +0800
Message-ID: <1314762272.3189.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If no id is matched, the mid pointer is not NULL in current implementation.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/hwmon/pmbus/ucd9000.c |    3 +--
 drivers/hwmon/pmbus/ucd9200.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/pmbus/ucd9000.c b/drivers/hwmon/pmbus/ucd9000.c
index 285bb15..4aa8701 100644
--- a/drivers/hwmon/pmbus/ucd9000.c
+++ b/drivers/hwmon/pmbus/ucd9000.c
@@ -141,13 +141,12 @@ static int ucd9000_probe(struct i2c_client *client,
 	block_buffer[ret] = '\0';
 	dev_info(&client->dev, "Device ID %s\n", block_buffer);
 
-	mid = NULL;
 	for (i = 0; i < ARRAY_SIZE(ucd9000_id); i++) {
 		mid = &ucd9000_id[i];
 		if (!strncasecmp(mid->name, block_buffer, strlen(mid->name)))
 			break;
 	}
-	if (!mid || !strlen(mid->name)) {
+	if ((i == ARRAY_SIZE(ucd9000_id)) || !strlen(mid->name)) {
 		dev_err(&client->dev, "Unsupported device\n");
 		return -ENODEV;
 	}
diff --git a/drivers/hwmon/pmbus/ucd9200.c b/drivers/hwmon/pmbus/ucd9200.c
index 786f6cd..826cc8f 100644
--- a/drivers/hwmon/pmbus/ucd9200.c
+++ b/drivers/hwmon/pmbus/ucd9200.c
@@ -68,13 +68,12 @@ static int ucd9200_probe(struct i2c_client *client,
 	block_buffer[ret] = '\0';
 	dev_info(&client->dev, "Device ID %s\n", block_buffer);
 
-	mid = NULL;
 	for (i = 0; i < ARRAY_SIZE(ucd9200_id); i++) {
 		mid = &ucd9200_id[i];
 		if (!strncasecmp(mid->name, block_buffer, strlen(mid->name)))
 			break;
 	}
-	if (!mid || !strlen(mid->name)) {
+	if ((i == ARRAY_SIZE(ucd9200_id)) || !strlen(mid->name)) {
 		dev_err(&client->dev, "Unsupported device\n");
 		return -ENODEV;
 	}
-- 
1.7.4.1



