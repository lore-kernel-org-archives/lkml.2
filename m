Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab0LFWJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:09:15 -0500
Received: from mail.perches.com ([173.55.12.10]:2335 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203Ab0LFWFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:05:22 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/29] drivers/base: Update WARN uses
Date: Mon,  6 Dec 2010 14:04:57 -0800
Message-Id: <4f79112324142c4c337c1bd8c375c9e20cf22599.1291670105.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1291670104.git.joe@perches.com>
References: <cover.1291670104.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coalesce long formats.
Align arguments.
Add missing newlines.
Remove KERN_<level>.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/base/class.c  |    4 ++--
 drivers/base/core.c   |    5 ++---
 drivers/base/memory.c |    4 ++--
 drivers/base/sys.c    |   10 ++++------
 4 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 4f1df2e..ac3a2a6 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -369,7 +369,7 @@ int class_for_each_device(struct class *class, struct device *start,
 	if (!class)
 		return -EINVAL;
 	if (!class->p) {
-		WARN(1, "%s called for class '%s' before it was initialized",
+		WARN(1, "%s called for class '%s' before it was initialized\n",
 		     __func__, class->name);
 		return -EINVAL;
 	}
@@ -416,7 +416,7 @@ struct device *class_find_device(struct class *class, struct device *start,
 	if (!class)
 		return NULL;
 	if (!class->p) {
-		WARN(1, "%s called for class '%s' before it was initialized",
+		WARN(1, "%s called for class '%s' before it was initialized\n",
 		     __func__, class->name);
 		return NULL;
 	}
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 610d967..4ae8630 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -138,9 +138,8 @@ static void device_release(struct kobject *kobj)
 	else if (dev->class && dev->class->dev_release)
 		dev->class->dev_release(dev);
 	else
-		WARN(1, KERN_ERR "Device '%s' does not have a release() "
-			"function, it is broken and must be fixed.\n",
-			dev_name(dev));
+		WARN(1, "Device '%s' does not have a release() function, it is broken and must be fixed\n",
+		     dev_name(dev));
 	kfree(p);
 }
 
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index cafeaaf..9acb048 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -229,8 +229,8 @@ memory_block_action(struct memory_block *mem, unsigned long action)
 			}
 			break;
 		default:
-			WARN(1, KERN_WARNING "%s(%p, %ld) unknown action: %ld\n",
-					__func__, mem, action, action);
+			WARN(1, "%s(%p, %ld) unknown action: %ld\n",
+			     __func__, mem, action, action);
 			ret = -EINVAL;
 	}
 
diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 1667aaf..5552d63 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -181,16 +181,14 @@ int sysdev_driver_register(struct sysdev_class *cls, struct sysdev_driver *drv)
 	int err = 0;
 
 	if (!cls) {
-		WARN(1, KERN_WARNING "sysdev: invalid class passed to "
-			"sysdev_driver_register!\n");
+		WARN(1, "sysdev: invalid class passed to sysdev_driver_register!\n");
 		return -EINVAL;
 	}
 
 	/* Check whether this driver has already been added to a class. */
 	if (drv->entry.next && !list_empty(&drv->entry))
-		WARN(1, KERN_WARNING "sysdev: class %s: driver (%p) has already"
-			" been registered to a class, something is wrong, but "
-			"will forge on!\n", cls->name, drv);
+		WARN(1, "sysdev: class %s: driver (%p) has already been registered to a class, something is wrong, but will forge on!\n",
+		     cls->name, drv);
 
 	mutex_lock(&sysdev_drivers_lock);
 	if (cls && kset_get(&cls->kset)) {
@@ -204,7 +202,7 @@ int sysdev_driver_register(struct sysdev_class *cls, struct sysdev_driver *drv)
 		}
 	} else {
 		err = -EINVAL;
-		WARN(1, KERN_ERR "%s: invalid device class\n", __func__);
+		WARN(1, "%s: invalid device class\n", __func__);
 	}
 	mutex_unlock(&sysdev_drivers_lock);
 	return err;
-- 
1.7.3.2.245.g03276.dirty

