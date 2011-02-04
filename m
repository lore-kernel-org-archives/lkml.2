Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab1BDMXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 07:23:45 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32973 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab1BDMXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 07:23:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=KuAJSQB/Nsp92dUe3Lm3S+inC+fY/Ct4I8UaMR8xtHrBRRInNzZt75RcrDVmuksiA6
         tDnPKZS5306sJgGXDkbf19lsCIcy18IxLX2x/W1fXN2tzDAqfYR5q/ARTib1MqZURy2E
         Uy4O1+tl8608H/fQGveqadX6Qy95y3up/ShCM=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH 05/20] leds: lp5521: world-writable sysfs engine* files
Date: Fri,  4 Feb 2011 15:23:26 +0300
Message-Id: <fa4b79e53e8b9cefdb931799bd34fb0d3f90884f.1296818921.git.segoon@openwall.com>
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

 drivers/leds/leds-lp5521.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 80a3ae3..c0cff64 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -534,7 +534,7 @@ static ssize_t lp5521_selftest(struct device *dev,
 }
 
 /* led class device attributes */
-static DEVICE_ATTR(led_current, S_IRUGO | S_IWUGO, show_current, store_current);
+static DEVICE_ATTR(led_current, S_IRUGO | S_IWUSR, show_current, store_current);
 static DEVICE_ATTR(max_current, S_IRUGO , show_max_current, NULL);
 
 static struct attribute *lp5521_led_attributes[] = {
@@ -548,15 +548,15 @@ static struct attribute_group lp5521_led_attribute_group = {
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
-static DEVICE_ATTR(engine1_load, S_IWUGO, NULL, store_engine1_load);
-static DEVICE_ATTR(engine2_load, S_IWUGO, NULL, store_engine2_load);
-static DEVICE_ATTR(engine3_load, S_IWUGO, NULL, store_engine3_load);
+static DEVICE_ATTR(engine1_load, S_IWUSR, NULL, store_engine1_load);
+static DEVICE_ATTR(engine2_load, S_IWUSR, NULL, store_engine2_load);
+static DEVICE_ATTR(engine3_load, S_IWUSR, NULL, store_engine3_load);
 static DEVICE_ATTR(selftest, S_IRUGO, lp5521_selftest, NULL);
 
 static struct attribute *lp5521_attributes[] = {
-- 
1.7.0.4

