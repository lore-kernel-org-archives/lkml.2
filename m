Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab1HaE6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 00:58:31 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58512 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab1HaE63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 00:58:29 -0400
Subject: [PATCH v2] hwmon: (pmbus) Fix the logic of checking if no id is
 matched
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 12:58:19 +0800
Message-ID: <1314766699.3960.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If no id is matched, the mid pointer is not NULL in current implementation.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
v2:
It seems we don't need to check strlen(mid->name) here.
If there is a match, strlen(mid->name) is always not 0.
If ther is no match, comparing variable i with ARRAY_SIZE(ucd9000_id)
or ARRAY_SIZE(ucd9200_id) is enough. 

 drivers/hwmon/pmbus/ucd9000.c |    3 +--
 drivers/hwmon/pmbus/ucd9200.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/pmbus/ucd9000.c b/drivers/hwmon/pmbus/ucd9000.c
index 285bb15..a2d4a72 100644
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
+	if (i == ARRAY_SIZE(ucd9000_id)) {
 		dev_err(&client->dev, "Unsupported device\n");
 		return -ENODEV;
 	}
diff --git a/drivers/hwmon/pmbus/ucd9200.c b/drivers/hwmon/pmbus/ucd9200.c
index 786f6cd..a72e55e 100644
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
+	if (i == ARRAY_SIZE(ucd9200_id)) {
 		dev_err(&client->dev, "Unsupported device\n");
 		return -ENODEV;
 	}
-- 
1.7.4.1



