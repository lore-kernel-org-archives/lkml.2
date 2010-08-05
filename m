Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760187Ab0HEPiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:38:24 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:40660 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541Ab0HEPiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:38:22 -0400
Subject: [PATCH] driver core: device_rename's new_name can be const
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 17:38:18 +0200
Message-ID: <1281022698.4058.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new_name argument to device_rename() can be
const as kobject_rename's new_name argument is.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
I have a patch that I would like to push into the wireless tree for .37
that relies on this to not generate a compiler warning, it would be nice
if this could get into .36 but I don't know if that's possible now.

 drivers/base/core.c    |    2 +-
 include/linux/device.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- wireless-testing.orig/drivers/base/core.c	2010-08-05 17:34:14.000000000 +0200
+++ wireless-testing/drivers/base/core.c	2010-08-05 17:34:20.000000000 +0200
@@ -1599,7 +1599,7 @@ EXPORT_SYMBOL_GPL(device_destroy);
  * on the same device to ensure that new_name is valid and
  * won't conflict with other devices.
  */
-int device_rename(struct device *dev, char *new_name)
+int device_rename(struct device *dev, const char *new_name)
 {
 	char *old_class_name = NULL;
 	char *new_class_name = NULL;
--- wireless-testing.orig/include/linux/device.h	2010-08-05 17:34:01.000000000 +0200
+++ wireless-testing/include/linux/device.h	2010-08-05 17:34:09.000000000 +0200
@@ -551,7 +551,7 @@ extern int device_for_each_child(struct
 		     int (*fn)(struct device *dev, void *data));
 extern struct device *device_find_child(struct device *dev, void *data,
 				int (*match)(struct device *dev, void *data));
-extern int device_rename(struct device *dev, char *new_name);
+extern int device_rename(struct device *dev, const char *new_name);
 extern int device_move(struct device *dev, struct device *new_parent,
 		       enum dpm_order dpm_order);
 extern const char *device_get_devnode(struct device *dev,


