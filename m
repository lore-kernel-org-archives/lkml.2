Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab2AXSfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 13:35:41 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59208 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756192Ab2AXSfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 13:35:38 -0500
Date: Tue, 24 Jan 2012 13:35:37 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] Eliminate get_driver() and put_driver()
Message-ID: <Pine.LNX.4.44L0.1201241323290.1200-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that there are no users of get_driver() or put_driver(), this
patch (as1513) removes those routines completely.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>

---

 drivers/base/driver.c  |   28 ----------------------------
 include/linux/device.h |    2 --
 2 files changed, 30 deletions(-)

Index: usb-3.3/drivers/base/driver.c
===================================================================
--- usb-3.3.orig/drivers/base/driver.c
+++ usb-3.3/drivers/base/driver.c
@@ -153,34 +153,6 @@ int driver_add_kobj(struct device_driver
 }
 EXPORT_SYMBOL_GPL(driver_add_kobj);
 
-/**
- * get_driver - increment driver reference count.
- * @drv: driver.
- */
-struct device_driver *get_driver(struct device_driver *drv)
-{
-	if (drv) {
-		struct driver_private *priv;
-		struct kobject *kobj;
-
-		kobj = kobject_get(&drv->p->kobj);
-		priv = to_driver(kobj);
-		return priv->driver;
-	}
-	return NULL;
-}
-EXPORT_SYMBOL_GPL(get_driver);
-
-/**
- * put_driver - decrement driver's refcount.
- * @drv: driver.
- */
-void put_driver(struct device_driver *drv)
-{
-	kobject_put(&drv->p->kobj);
-}
-EXPORT_SYMBOL_GPL(put_driver);
-
 static int driver_add_groups(struct device_driver *drv,
 			     const struct attribute_group **groups)
 {
Index: usb-3.3/include/linux/device.h
===================================================================
--- usb-3.3.orig/include/linux/device.h
+++ usb-3.3/include/linux/device.h
@@ -238,8 +238,6 @@ struct device_driver {
 extern int __must_check driver_register(struct device_driver *drv);
 extern void driver_unregister(struct device_driver *drv);
 
-extern struct device_driver *get_driver(struct device_driver *drv);
-extern void put_driver(struct device_driver *drv);
 extern struct device_driver *driver_find(const char *name,
 					 struct bus_type *bus);
 extern int driver_probe_done(void);

