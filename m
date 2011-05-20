Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935041Ab1ETAM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:12:29 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:60673 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935004Ab1ETAMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:12:18 -0400
X-Sasl-enc: DUoKeZ+SVcN708FvJZjLBobDfgw93SLI2qn0p4xgXDUH 1305850337
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Wanlong Gao <wanlong.gao@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 39/44] driver core: remove the driver-model structures from the documentation
Date: Thu, 19 May 2011 17:10:57 -0700
Message-Id: <1305850262-9575-39-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

Remove the struct bus_type, class, device, device_driver from the
driver-model docs. With another patch add them to device.h, since
they are out of date. That will keep things up to date and provide
a better way to document this stuff.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
Acked-by: Harry Wei <harryxiyou@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/driver-model/bus.txt    |   19 +-------
 Documentation/driver-model/class.txt  |   17 +------
 Documentation/driver-model/device.txt |   91 +--------------------------------
 Documentation/driver-model/driver.txt |   18 +------
 4 files changed, 4 insertions(+), 141 deletions(-)

diff --git a/Documentation/driver-model/bus.txt b/Documentation/driver-model/bus.txt
index 5001b75..6754b2d 100644
--- a/Documentation/driver-model/bus.txt
+++ b/Documentation/driver-model/bus.txt
@@ -3,24 +3,7 @@ Bus Types
 
 Definition
 ~~~~~~~~~~
-
-struct bus_type {
-	char			* name;
-
-	struct subsystem	subsys;
-	struct kset		drivers;
-	struct kset		devices;
-
-	struct bus_attribute	* bus_attrs;
-	struct device_attribute	* dev_attrs;
-	struct driver_attribute	* drv_attrs;
-
-	int		(*match)(struct device * dev, struct device_driver * drv);
-	int		(*hotplug) (struct device *dev, char **envp, 
-				    int num_envp, char *buffer, int buffer_size);
-	int		(*suspend)(struct device * dev, pm_message_t state);
-	int		(*resume)(struct device * dev);
-};
+See the kerneldoc for the struct bus_type.
 
 int bus_register(struct bus_type * bus);
 
diff --git a/Documentation/driver-model/class.txt b/Documentation/driver-model/class.txt
index 548505f..1fefc48 100644
--- a/Documentation/driver-model/class.txt
+++ b/Documentation/driver-model/class.txt
@@ -27,22 +27,7 @@ The device class structure looks like:
 typedef int (*devclass_add)(struct device *);
 typedef void (*devclass_remove)(struct device *);
 
-struct device_class {
-	char			* name;
-	rwlock_t		lock;
-	u32			devnum;
-	struct list_head	node;
-
-	struct list_head	drivers;
-	struct list_head	intf_list;
-
-	struct driver_dir_entry	dir;
-	struct driver_dir_entry	device_dir;
-	struct driver_dir_entry	driver_dir;
-
-	devclass_add		add_device;
-	devclass_remove		remove_device;
-};
+See the kerneldoc for the struct class.
 
 A typical device class definition would look like: 
 
diff --git a/Documentation/driver-model/device.txt b/Documentation/driver-model/device.txt
index a124f31..b2ff426 100644
--- a/Documentation/driver-model/device.txt
+++ b/Documentation/driver-model/device.txt
@@ -2,96 +2,7 @@
 The Basic Device Structure
 ~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-struct device {
-        struct list_head g_list;
-        struct list_head node;
-        struct list_head bus_list;
-        struct list_head driver_list;
-        struct list_head intf_list;
-        struct list_head children;
-        struct device   * parent;
-
-        char    name[DEVICE_NAME_SIZE];
-        char    bus_id[BUS_ID_SIZE];
-
-        spinlock_t      lock;
-        atomic_t        refcount;
-
-        struct bus_type * bus;
-        struct driver_dir_entry dir;
-
-	u32		class_num;
-
-        struct device_driver *driver;
-        void            *driver_data;
-        void            *platform_data;
-
-        u32             current_state;
-        unsigned char *saved_state;
-
-        void    (*release)(struct device * dev);
-};
-
-Fields 
-~~~~~~
-g_list:	Node in the global device list.
-
-node:	Node in device's parent's children list.
-
-bus_list: Node in device's bus's devices list.
-
-driver_list:   Node in device's driver's devices list.
-
-intf_list:     List of intf_data. There is one structure allocated for
-	       each interface that the device supports.
-
-children:      List of child devices.
-
-parent:        *** FIXME ***
-
-name:	       ASCII description of device. 
-	       Example: " 3Com Corporation 3c905 100BaseTX [Boomerang]"
-
-bus_id:	       ASCII representation of device's bus position. This 
-	       field should be a name unique across all devices on the
-	       bus type the device belongs to. 
-
-	       Example: PCI bus_ids are in the form of
-	       <bus number>:<slot number>.<function number> 
-	       This name is unique across all PCI devices in the system.
-
-lock:	       Spinlock for the device. 
-
-refcount:      Reference count on the device.
-
-bus:	       Pointer to struct bus_type that device belongs to.
-
-dir:	       Device's sysfs directory.
-
-class_num:     Class-enumerated value of the device.
-
-driver:	       Pointer to struct device_driver that controls the device.
-
-driver_data:   Driver-specific data.
-
-platform_data: Platform data specific to the device.
-
-	       Example:  for devices on custom boards, as typical of embedded
-	       and SOC based hardware, Linux often uses platform_data to point
-	       to board-specific structures describing devices and how they
-	       are wired.  That can include what ports are available, chip
-	       variants, which GPIO pins act in what additional roles, and so
-	       on.  This shrinks the "Board Support Packages" (BSPs) and
-	       minimizes board-specific #ifdefs in drivers.
-
-current_state: Current power state of the device.
-
-saved_state:   Pointer to saved state of the device. This is usable by
-	       the device driver controlling the device.
-
-release:       Callback to free the device after all references have 
-	       gone away. This should be set by the allocator of the 
-	       device (i.e. the bus driver that discovered the device).
+See the kerneldoc for the struct device.
 
 
 Programming Interface
diff --git a/Documentation/driver-model/driver.txt b/Documentation/driver-model/driver.txt
index d2cd6fb..4421135 100644
--- a/Documentation/driver-model/driver.txt
+++ b/Documentation/driver-model/driver.txt
@@ -1,23 +1,7 @@
 
 Device Drivers
 
-struct device_driver {
-        char                    * name;
-        struct bus_type         * bus;
-
-        struct completion	unloaded;
-        struct kobject		kobj;
-        list_t                  devices;
-
-        struct module		*owner;
-
-        int     (*probe)        (struct device * dev);
-        int     (*remove)       (struct device * dev);
-
-        int     (*suspend)      (struct device * dev, pm_message_t state);
-        int     (*resume)       (struct device * dev);
-};
-
+See the kerneldoc for the struct device_driver.
 
 
 Allocation
-- 
1.7.4.2

