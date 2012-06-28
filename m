Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab2F1NNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 09:13:33 -0400
Received: from mail-gg0-f202.google.com ([209.85.161.202]:55506 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769Ab2F1NNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 09:13:30 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, Yufeng Shen <miletus@chromium.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Benson Leung <bleung@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 15/23 v6] Input: atmel_mxt_ts - add sysfs entries to read fw and hw version
Date: Thu, 28 Jun 2012 21:08:16 +0800
Message-Id: <1340888904-15620-16-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1340888904-15620-1-git-send-email-djkurtz@chromium.org>
References: <1340888904-15620-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make firmware and hardware version strings available to userspace.
This is useful, for example, to allow a userspace program to implement
a firwmare update policy.

Change-Id: I1eddb4bbf5f3f9ae6947a8528598973ddead18cf
Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 7a839d1..f2c1fbe 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -882,6 +882,26 @@ static void mxt_calc_resolution(struct mxt_data *data)
 	}
 }
 
+/* Firmware Version is returned as Major.Minor.Build */
+static ssize_t mxt_fw_version_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct mxt_data *data = dev_get_drvdata(dev);
+	struct mxt_info *info = &data->info;
+	return scnprintf(buf, PAGE_SIZE, "%u.%u.%02X\n",
+			 info->version >> 4, info->version & 0xf, info->build);
+}
+
+/* Hardware Version is returned as FamilyID.VariantID */
+static ssize_t mxt_hw_version_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct mxt_data *data = dev_get_drvdata(dev);
+	struct mxt_info *info = &data->info;
+	return scnprintf(buf, PAGE_SIZE, "%u.%u\n",
+			 info->family_id, info->variant_id);
+}
+
 static ssize_t mxt_show_instance(char *buf, int count,
 				 struct mxt_object *object, int instance,
 				 const u8 *val)
@@ -1047,10 +1067,14 @@ static ssize_t mxt_update_fw_store(struct device *dev,
 	return count;
 }
 
+static DEVICE_ATTR(fw_version, S_IRUGO, mxt_fw_version_show, NULL);
+static DEVICE_ATTR(hw_version, S_IRUGO, mxt_hw_version_show, NULL);
 static DEVICE_ATTR(object, S_IRUGO, mxt_object_show, NULL);
 static DEVICE_ATTR(update_fw, S_IWUSR, NULL, mxt_update_fw_store);
 
 static struct attribute *mxt_attrs[] = {
+	&dev_attr_fw_version.attr,
+	&dev_attr_hw_version.attr,
 	&dev_attr_object.attr,
 	&dev_attr_update_fw.attr,
 	NULL
-- 
1.7.7.3

