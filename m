Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab1EBPmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 11:42:11 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:32950 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab1EBPmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 11:42:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=EJ5M2CbKRVBY6yPoqX0w3DUOqYgUu9iyM3BqtIAgozunzeITg6FVtI2IodWbZe54nT
         CgEs9MpoqfoOsLI/0JjFzPmqJj4uQjHUFJV2iLd1sgxuEK/u9SRaPTWoKvkypnr/s3cj
         Wccui9hOIob8cMdFTtrnjup57aqIT4jt+S5jQ=
Subject: Re: [PATCH 1/2] KernelDoc:Add the device driver-model structures
 to kerneldoc
From: "wanlong.gao" <wanlong.gao@gmail.com>
Reply-To: wanlong.gao@gmail.com
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
In-Reply-To: <20110502082609.77b23473.rdunlap@xenotime.net>
References: <1304348681-24950-1-git-send-email-wanlong.gao@gmail.com>
	 <1304348681-24950-2-git-send-email-wanlong.gao@gmail.com>
	 <20110502082609.77b23473.rdunlap@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Linux kernel
Date: Mon, 02 May 2011 23:41:53 +0800
Message-ID: <1304350913.1777.5.camel@Tux>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2011-05-02一的 08:26 -0700，Randy Dunlap写道：
> On Mon,  2 May 2011 23:04:40 +0800 wanlong.gao@gmail.com wrote:
> 
> > From: Wanlong Gao <wanlong.gao@gmail.com>
> > 
> > Add the comment the structure bus_type, device_driver, device,
> > class for generating the driver-model kerneldoc.
> 
> Warning: trailing whitespace in lines 66,478,498,499 of include/linux/device.h
> 
> Other than that:
> 
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>
> 
> Thanks.
> 
> Greg, do you want to merge this or should I?
> 
Randy:
	Sorry for the writespace.


>From eea23d68008c2ca8a944b303a835e32c2b81834c Mon Sep 17 00:00:00 2001
From: Wanlong Gao <wanlong.gao@gmail.com>
Date: Mon, 2 May 2011 23:34:02 +0800
Subject: [PATCH] KernelDoc:Add the device driver-model structures to
kerneldoc

Add the comment the structure bus_type, device_driver, device,
class for generating the driver-model kerneldoc.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 Documentation/DocBook/device-drivers.tmpl |    6 +-
 include/linux/device.h                    |  104
++++++++++++++++++++++++++++-
 2 files changed, 104 insertions(+), 6 deletions(-)

diff --git a/Documentation/DocBook/device-drivers.tmpl
b/Documentation/DocBook/device-drivers.tmpl
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
index ab8dfc0..aa1bd07 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -47,6 +47,23 @@ extern int __must_check bus_create_file(struct
bus_type *,
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
@@ -119,6 +136,23 @@ extern int bus_unregister_notifier(struct bus_type
*bus,
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
@@ -185,8 +219,24 @@ struct device *driver_find_device(struct
device_driver *drv,
 				  struct device *start, void *data,
 				  int (*match)(struct device *dev, void *data));
 
-/*
- * device classes
+/**
+ * struct class - device classes
+ * @name:	Name of the class
+ * @owner:	Class' owner
+ * @class_attrs:The attributes of the class
+ * @dev_attrs:	The default attributes of the device belongs to the
class
+ * @dev_bin_attrs:The default binary attributes of the device belongs
to the class
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
+ * @kobj:	A top-level, abstract class from which other classes are
derived.
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
+ * @pwr_domain:	Provide callbacks that are executed during system
suspend,
+ * 		hibernation, system resume and during runtime PM transitions
+ * 		along with subsystem-level and driver-level callbacks.
+ * @numa_node:	NUMA node this device is close to.
+ * @dma_mask:	Dma mask (if dma'ble device).
+ * @coherent_dma_mask:Like dma_mask, but for alloc_coherent mapping as
not all
+ * 		hardware supports 64 bit addresses for consistent allocations
+ * 		such description.
+ * @dma_parms:	A low level driver may set these to teach IOMMU code
about
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
  * get_device - atomically increment the reference count for the
device.
  *
  */
-- 
1.7.4.1


