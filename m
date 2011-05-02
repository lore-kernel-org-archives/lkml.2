Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab1EBPMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 11:12:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:65136 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab1EBPMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 11:12:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MhAncYjSqcZJQ/V9J4WtV+XgpnWRDcvl/7w24yry5Kag/iko54zxuQkscRpgB3c1k9
         AIYfX0h6vHEip319LpkTauZCiPKSrsfPrk5guqP6lat3FtZ3YemHhm7DQWjMGSmbPfsb
         CIzOx4Xz/EnKZV5jJCP42/FAm9clnRJEMeOEc=
From: wanlong.gao@gmail.com
To: gregkh@suse.de, rdunlap@xenotime.net, linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org, Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH 1/2] KernelDoc:Add the device driver-model structures to kerneldoc
Date: Mon,  2 May 2011 23:04:40 +0800
Message-Id: <1304348681-24950-2-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304348681-24950-1-git-send-email-wanlong.gao@gmail.com>
References: <1304348681-24950-1-git-send-email-wanlong.gao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

Add the comment the structure bus_type, device_driver, device,
class for generating the driver-model kerneldoc.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 Documentation/DocBook/device-drivers.tmpl |    6 +-
 include/linux/device.h                    |  104 ++++++++++++++++++++++++++++-
 2 files changed, 104 insertions(+), 6 deletions(-)

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index 36f63d4..5e482e0 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -96,10 +96,10 @@ X!Iinclude/linux/kobject.h
 
   <chapter id="devdrivers">
      <title>Device drivers infrastructure</title>
+     <sect1><title>The Basic Device Driver-Model Structure </title>
+!Iinclude/linux/device.h
+     </sect1>
      <sect1><title>Device Drivers Base</title>
-<!--
-X!Iinclude/linux/device.h
--->
 !Edrivers/base/driver.c
 !Edrivers/base/core.c
 !Edrivers/base/class.c
diff --git a/include/linux/device.h b/include/linux/device.h
index ab8dfc0..5258d5d 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -47,6 +47,23 @@ extern int __must_check bus_create_file(struct bus_type *,
 					struct bus_attribute *);
 extern void bus_remove_file(struct bus_type *, struct bus_attribute *);
 
+/**
+ * struct bus_type - The bus type of the device .
+ *
+ * @name:	The name of the bus
+ * @bus_attrs:	The attributes of the bus
+ * @dev_attrs:	The default attributes of the devices on the bus
+ * @drv_attrs:	The default attributes of the device drivers on the bus
+ * @match:	Attaching drivers to devices
+ * @uevent:	Add the environment variable for device plug
+ * @probe:	Probe the device
+ * @remove:	Remove the device
+ * @shutdown:	Shutdown method
+ * @suspend:	Suspend method
+ * @resume:	Resume method
+ * @pm:		Device power management operations
+ * @p:		The private data the subsystem
+ */ 
 struct bus_type {
 	const char		*name;
 	struct bus_attribute	*bus_attrs;
@@ -119,6 +136,23 @@ extern int bus_unregister_notifier(struct bus_type *bus,
 extern struct kset *bus_get_kset(struct bus_type *bus);
 extern struct klist *bus_get_device_klist(struct bus_type *bus);
 
+/**
+ * struct device_driver - The basic device driver structure
+ * @name:	Name of the device driver
+ * @bus:	The bus the device driver belongs to
+ * @owner:	The driver's owner
+ * @mod_name:	Used for built-in modules
+ * @suppress_bind_attrs:Disables bind/unbind via sysfs
+ * @of_match_table:Id table for matching the driver to device
+ * @probe:	Called to bound a driver to the device
+ * @remove:	Called to unbind a driver from a device
+ * @shutdown:	Called when shutdown
+ * @suspend:	Called to put the device in a low power state
+ * @resume:	Used to bring a device from a low power state
+ * @groups:	Driver's attribute groups
+ * @pm:		Device's power management operations
+ * @p:		Driver's private data
+ */
 struct device_driver {
 	const char		*name;
 	struct bus_type		*bus;
@@ -185,8 +219,24 @@ struct device *driver_find_device(struct device_driver *drv,
 				  struct device *start, void *data,
 				  int (*match)(struct device *dev, void *data));
 
-/*
- * device classes
+/**
+ * struct class - device classes
+ * @name:	Name of the class
+ * @owner:	Class' owner
+ * @class_attrs:The attributes of the class
+ * @dev_attrs:	The default attributes of the device belongs to the class
+ * @dev_bin_attrs:The default binary attributes of the device belongs to the class
+ * @dev_kobj:	Kobject of the class
+ * @dev_uevent:	Used to plug
+ * @devnode:	Callback to provide the devtmpfs
+ * @class_release:Called to release the class
+ * @dev_release:Called to release the device
+ * @suspend:	Used to put the device to a low power state
+ * @resume:	Used to bring the device from a low power state
+ * @ns_type:	Callbacks so sysfs can detemine namespaces
+ * @namespace:	Namespace of the device
+ * @pm:		The default device power management operations
+ * @p:		The private data of the subsystem
  */
 struct class {
 	const char		*name;
@@ -401,6 +451,54 @@ struct device_dma_parameters {
 	unsigned long segment_boundary_mask;
 };
 
+/**
+ * struct device - The basic device structure.
+ * @parent:	Parent of the device.
+ * @p:		Hold the private to the driver core portions of the device.
+ * 		See the comment of the struct device_private for detail.
+ * @kobj:	A top-level, abstract class from which other classes are derived.
+ * @init_name:	Initial name of the device.
+ * @type:	The type of device.
+ * 		This identifies the device type and carries type-specific
+ * 		information.
+ * @mutex:	Mutex to synchronize calls to its driver.
+ * @bus:	Type of bus device is on.
+ * @driver:	Which driver has allocated this
+ * @platform_data:Platform data specific to the device.
+ * 		Example..For devices on custom boards, as typical of embedded
+ * 		and SOC based hardware, Linux often uses platform_data to point
+ * 		to board-specific structures describing devices and how they
+ * 		are wired.  That can include what ports are available, chip
+ * 		variants, which GPIO pins act in what additional roles, and so
+ * 		on.  This shrinks the "Board Support Packages" (BSPs) and
+ * 		minimizes board-specific #ifdefs in drivers.
+ * @power:	For device power management.
+ * 		See the Documentation/power/devices.txt for details.
+ * @pwr_domain:	Provide callbacks that are executed during system suspend,
+ * 		hibernation, system resume and during runtime PM transitions 
+ * 		along with subsystem-level and driver-level callbacks.
+ * @numa_node:	NUMA node this device is close to.
+ * @dma_mask:	Dma mask (if dma'ble device).
+ * @coherent_dma_mask:Like dma_mask, but for alloc_coherent mapping as not all
+ * 		hardware supports 64 bit addresses for consistent allocations
+ * 		such description.
+ * @dma_parms:	A low level driver may set these to teach IOMMU code about
+ * 		segment limitations.
+ * @dma_pools:	Dma pools (if dma'ble device) .
+ * @dma_mem:	Internal for coherent mem override.
+ * @archdata:	For arch specific additions.
+ * @of_node:	Associated device tree node.
+ * @of_match:	Matching of_device_id from driver.
+ * @devt:	For creating the sysfs "dev".
+ * @devres_lock:Spinlock to protect the resource of the device.
+ * @devres_head:The resources list of the device.
+ * @knode_class:The node used to add the device to the class list.
+ * @class:	The class of the device.
+ * @groups:	Optional attribute groups.
+ * @release:	Callback to free the device after all references have 
+ * 		gone away. This should be set by the allocator of the 
+ * 		device (i.e. the bus driver that discovered the device).
+ */
 struct device {
 	struct device		*parent;
 
@@ -611,7 +709,7 @@ extern int (*platform_notify)(struct device *dev);
 extern int (*platform_notify_remove)(struct device *dev);
 
 
-/**
+/*
  * get_device - atomically increment the reference count for the device.
  *
  */
-- 
1.7.4.1

