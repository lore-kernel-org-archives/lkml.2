Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab2CQHhj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 03:37:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54145 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab2CQHhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 03:37:36 -0400
Message-ID: <1331969851.30866.3.camel@phoenix>
Subject: [PATCH 2/2] power_supply: ds2781: Use DS2781_PARAM_EEPROM_SIZE and
 DS2781_USER_EEPROM_SIZE
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Renata Sayakhova <rsayakhova@gmail.com>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Date: Sat, 17 Mar 2012 15:37:31 +0800
In-Reply-To: <1331969590.30866.0.camel@phoenix>
References: <1331969590.30866.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we have defined DS2781_PARAM_EEPROM_SIZE and DS2781_USER_EEPROM_SIZE,
use them to simplify the code.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/power/ds2781_battery.c |   20 ++++++--------------
 1 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/power/ds2781_battery.c b/drivers/power/ds2781_battery.c
index ca0d653..975684a 100644
--- a/drivers/power/ds2781_battery.c
+++ b/drivers/power/ds2781_battery.c
@@ -643,9 +643,7 @@ static ssize_t ds2781_read_param_eeprom_bin(struct file *filp,
 	struct power_supply *psy = to_power_supply(dev);
 	struct ds2781_device_info *dev_info = to_ds2781_device_info(psy);
 
-	count = min_t(loff_t, count,
-		DS2781_EEPROM_BLOCK1_END -
-		DS2781_EEPROM_BLOCK1_START + 1 - off);
+	count = min_t(loff_t, count, DS2781_PARAM_EEPROM_SIZE - off);
 
 	return ds2781_read_block(dev_info, buf,
 				DS2781_EEPROM_BLOCK1_START + off, count);
@@ -661,9 +659,7 @@ static ssize_t ds2781_write_param_eeprom_bin(struct file *filp,
 	struct ds2781_device_info *dev_info = to_ds2781_device_info(psy);
 	int ret;
 
-	count = min_t(loff_t, count,
-		DS2781_EEPROM_BLOCK1_END -
-		DS2781_EEPROM_BLOCK1_START + 1 - off);
+	count = min_t(loff_t, count, DS2781_PARAM_EEPROM_SIZE - off);
 
 	ret = ds2781_write(dev_info, buf,
 				DS2781_EEPROM_BLOCK1_START + off, count);
@@ -682,7 +678,7 @@ static struct bin_attribute ds2781_param_eeprom_bin_attr = {
 		.name = "param_eeprom",
 		.mode = S_IRUGO | S_IWUSR,
 	},
-	.size = DS2781_EEPROM_BLOCK1_END - DS2781_EEPROM_BLOCK1_START + 1,
+	.size = DS2781_PARAM_EEPROM_SIZE,
 	.read = ds2781_read_param_eeprom_bin,
 	.write = ds2781_write_param_eeprom_bin,
 };
@@ -696,9 +692,7 @@ static ssize_t ds2781_read_user_eeprom_bin(struct file *filp,
 	struct power_supply *psy = to_power_supply(dev);
 	struct ds2781_device_info *dev_info = to_ds2781_device_info(psy);
 
-	count = min_t(loff_t, count,
-		DS2781_EEPROM_BLOCK0_END -
-		DS2781_EEPROM_BLOCK0_START + 1 - off);
+	count = min_t(loff_t, count, DS2781_USER_EEPROM_SIZE - off);
 
 	return ds2781_read_block(dev_info, buf,
 				DS2781_EEPROM_BLOCK0_START + off, count);
@@ -715,9 +709,7 @@ static ssize_t ds2781_write_user_eeprom_bin(struct file *filp,
 	struct ds2781_device_info *dev_info = to_ds2781_device_info(psy);
 	int ret;
 
-	count = min_t(loff_t, count,
-		DS2781_EEPROM_BLOCK0_END -
-		DS2781_EEPROM_BLOCK0_START + 1 - off);
+	count = min_t(loff_t, count, DS2781_USER_EEPROM_SIZE - off);
 
 	ret = ds2781_write(dev_info, buf,
 				DS2781_EEPROM_BLOCK0_START + off, count);
@@ -736,7 +728,7 @@ static struct bin_attribute ds2781_user_eeprom_bin_attr = {
 		.name = "user_eeprom",
 		.mode = S_IRUGO | S_IWUSR,
 	},
-	.size = DS2781_EEPROM_BLOCK0_END - DS2781_EEPROM_BLOCK0_START + 1,
+	.size = DS2781_USER_EEPROM_SIZE,
 	.read = ds2781_read_user_eeprom_bin,
 	.write = ds2781_write_user_eeprom_bin,
 };
-- 
1.7.5.4



