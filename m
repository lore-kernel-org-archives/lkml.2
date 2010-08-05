Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760910Ab0HEW3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:29:20 -0400
Received: from kroah.org ([198.145.64.141]:37874 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934598Ab0HEWZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:25:14 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Johannes Berg <johannes.berg@intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 28/28] driver core: device_rename's new_name can be const
Date: Thu,  5 Aug 2010 15:24:18 -0700
Message-Id: <1281047058-23716-28-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213314.GB13744@kroah.com>
References: <20100805213314.GB13744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>

The new_name argument to device_rename() can be
const as kobject_rename's new_name argument is.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c    |    2 +-
 include/linux/device.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index f8e7272..d1b2c9a 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1599,7 +1599,7 @@ EXPORT_SYMBOL_GPL(device_destroy);
  * on the same device to ensure that new_name is valid and
  * won't conflict with other devices.
  */
-int device_rename(struct device *dev, char *new_name)
+int device_rename(struct device *dev, const char *new_name)
 {
 	char *old_class_name = NULL;
 	char *new_class_name = NULL;
diff --git a/include/linux/device.h b/include/linux/device.h
index 0ca24e9..516feca 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -552,7 +552,7 @@ extern int device_for_each_child(struct device *dev, void *data,
 		     int (*fn)(struct device *dev, void *data));
 extern struct device *device_find_child(struct device *dev, void *data,
 				int (*match)(struct device *dev, void *data));
-extern int device_rename(struct device *dev, char *new_name);
+extern int device_rename(struct device *dev, const char *new_name);
 extern int device_move(struct device *dev, struct device *new_parent,
 		       enum dpm_order dpm_order);
 extern const char *device_get_devnode(struct device *dev,
-- 
1.7.2

