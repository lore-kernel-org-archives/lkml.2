Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab1BDMXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 07:23:48 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56755 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab1BDMXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 07:23:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=ar5qjybN9vT56Qk42f+bOjLO59bUCNKTGbb0fO0gaPW+F3BYuGwWKj4eNEKn8K9bZf
         vNvVccVgu3YCfMlwyZUR8uTmy2TlAr6cVSxGb9rFerjaplRIcopThld7j7xJxfVOfx7K
         2IT8W2pPOdQfD/StXKlwMJWmTqsQKHtOe6oS8=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH 06/20] leds: lp5523: world-writable engine* sysfs files
Date: Fri,  4 Feb 2011 15:23:30 +0300
Message-Id: <e95a0faee84881dd2038722f2dbf102842fff8eb.1296818921.git.segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1296818921.git.segoon@openwall.com>
References: <cover.1296818921.git.segoon@openwall.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't allow everybody to change LED settings.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested only.

 drivers/leds/leds-lp5523.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index d0c4068..e19fed2 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -713,7 +713,7 @@ static ssize_t store_current(struct device *dev,
 }
 
 /* led class device attributes */
-static DEVICE_ATTR(led_current, S_IRUGO | S_IWUGO, show_current, store_current);
+static DEVICE_ATTR(led_current, S_IRUGO | S_IWUSR, show_current, store_current);
 static DEVICE_ATTR(max_current, S_IRUGO , show_max_current, NULL);
 
 static struct attribute *lp5523_led_attributes[] = {
@@ -727,21 +727,21 @@ static struct attribute_group lp5523_led_attribute_group = {
 };
 
 /* device attributes */
-static DEVICE_ATTR(engine1_mode, S_IRUGO | S_IWUGO,
+static DEVICE_ATTR(engine1_mode, S_IRUGO | S_IWUSR,
 		   show_engine1_mode, store_engine1_mode);
-static DEVICE_ATTR(engine2_mode, S_IRUGO | S_IWUGO,
+static DEVICE_ATTR(engine2_mode, S_IRUGO | S_IWUSR,
 		   show_engine2_mode, store_engine2_mode);
-static DEVICE_ATTR(engine3_mode, S_IRUGO | S_IWUGO,
+static DEVICE_ATTR(engine3_mode, S_IRUGO | S_IWUSR,
 		   show_engine3_mode, store_engine3_mode);
-static DEVICE_ATTR(engine1_leds, S_IRUGO | S_IWUGO,
+static DEVICE_ATTR(engine1_leds, S_IRUGO | S_IWUSR,
 		   show_engine1_leds, store_engine1_leds);
-static DEVICE_ATTR(engine2_leds, S_IRUGO | S_IWUGO,
+static DEVICE_ATTR(engine2_leds, S_IRUGO | S_IWUSR,
 		   show_engine2_leds, store_engine2_leds);
-static DEVICE_ATTR(engine3_leds, S_IRUGO | S_IWUGO,
+static DEVICE_ATTR(engine3_leds, S_IRUGO | S_IWUSR,
 		   show_engine3_leds, store_engine3_leds);
-static DEVICE_ATTR(engine1_load, S_IWUGO, NULL, store_engine1_load);
-static DEVICE_ATTR(engine2_load, S_IWUGO, NULL, store_engine2_load);
-static DEVICE_ATTR(engine3_load, S_IWUGO, NULL, store_engine3_load);
+static DEVICE_ATTR(engine1_load, S_IWUSR, NULL, store_engine1_load);
+static DEVICE_ATTR(engine2_load, S_IWUSR, NULL, store_engine2_load);
+static DEVICE_ATTR(engine3_load, S_IWUSR, NULL, store_engine3_load);
 static DEVICE_ATTR(selftest, S_IRUGO, lp5523_selftest, NULL);
 
 static struct attribute *lp5523_attributes[] = {
-- 
1.7.0.4

