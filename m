Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab2AUSEo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 13:04:44 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:39172 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751250Ab2AUSEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 13:04:24 -0500
Message-ID: <4F1B0BDB.7030204@xenotime.net>
Date: Sat, 21 Jan 2012 11:02:51 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 6/14] kernel-doc: fix new warnings in device.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix new kernel-doc warnings:

Warning(include/linux/device.h:299): No description found for parameter 'name'
Warning(include/linux/device.h:299): No description found for parameter 'subsys'
Warning(include/linux/device.h:299): No description found for parameter 'node'
Warning(include/linux/device.h:299): No description found for parameter 'add_dev'
Warning(include/linux/device.h:299): No description found for parameter 'remove_dev'
Warning(include/linux/device.h:685): No description found for parameter 'id'
Warning(include/linux/device.h:1009): No description found for parameter '__driver'
Warning(include/linux/device.h:1009): No description found for parameter '__register'
Warning(include/linux/device.h:1009): No description found for parameter '__unregister'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/device.h |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- lnx-33-rc1.orig/include/linux/device.h
+++ lnx-33-rc1/include/linux/device.h
@@ -279,11 +279,11 @@ struct device *driver_find_device(struct
 
 /**
  * struct subsys_interface - interfaces to device functions
- * @name        name of the device function
- * @subsystem   subsytem of the devices to attach to
- * @node        the list of functions registered at the subsystem
- * @add         device hookup to device function handler
- * @remove      device hookup to device function handler
+ * @name:       name of the device function
+ * @subsys:     subsytem of the devices to attach to
+ * @node:       the list of functions registered at the subsystem
+ * @add_dev:    device hookup to device function handler
+ * @remove_dev: device hookup to device function handler
  *
  * Simple interfaces attached to a subsystem. Multiple interfaces can
  * attach to a subsystem and its devices. Unlike drivers, they do not
@@ -612,6 +612,7 @@ struct device_dma_parameters {
  * @archdata:	For arch-specific additions.
  * @of_node:	Associated device tree node.
  * @devt:	For creating the sysfs "dev".
+ * @id:		device instance
  * @devres_lock: Spinlock to protect the resource of the device.
  * @devres_head: The resources list of the device.
  * @knode_class: The node used to add the device to the class list.
@@ -1003,6 +1004,10 @@ extern long sysfs_deprecated;
  * Each module may only use this macro once, and calling it replaces
  * module_init() and module_exit().
  *
+ * @__driver: driver name
+ * @__register: register function for this driver type
+ * @__unregister: unregister function for this driver type
+ *
  * Use this macro to construct bus specific macros for registering
  * drivers, and do not use it on its own.
  */
