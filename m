Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab1AJGSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 01:18:32 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46831 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab1AJGSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 01:18:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=n+S5TGSB+j5ksrJMqWx+m0SD1STqdv9qI857B1VD/UgKVS0yQKCBGtFYnr3iXWkQGK
         SyfFuIMBj5S95T6PaW66ozSBDm6v1IgBUDWglKfa3g74BsLnh283APvfiSUPWbwLsfK7
         RX0PmJqQySfXDOsltn5R5Ygd3IIkAiuIwTaUI=
Date: Mon, 10 Jan 2011 08:18:25 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] headers: kobject.h redux
Message-ID: <20110110061825.GB19138@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove kobject.h from files which don't need it, notably,
sched.h and fs.h.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/arm/plat-s3c24xx/cpu-freq.c           |    1 -
 arch/powerpc/platforms/pseries/eeh_sysfs.c |    1 -
 drivers/char/snsc.h                        |    1 -
 drivers/net/bonding/bonding.h              |    1 -
 drivers/pci/hotplug/acpiphp.h              |    1 -
 drivers/pci/hotplug/rpaphp_slot.c          |    1 -
 drivers/s390/char/tape_class.h             |    1 -
 drivers/sh/clk/core.c                      |    1 -
 drivers/usb/musb/musb_debugfs.c            |    1 -
 fs/gfs2/incore.h                           |    1 +
 fs/nilfs2/super.c                          |    1 -
 fs/sysfs/inode.c                           |    1 +
 fs/sysfs/sysfs.h                           |    1 +
 include/linux/firmware-map.h               |    1 -
 include/linux/fs.h                         |    2 +-
 include/linux/sched.h                      |    1 -
 include/linux/sunrpc/cache.h               |    1 +
 security/apparmor/include/match.h          |    1 +
 18 files changed, 6 insertions(+), 13 deletions(-)

--- a/arch/arm/plat-s3c24xx/cpu-freq.c
+++ b/arch/arm/plat-s3c24xx/cpu-freq.c
@@ -21,7 +21,6 @@
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/sysdev.h>
-#include <linux/kobject.h>
 #include <linux/sysfs.h>
 #include <linux/slab.h>
 
--- a/arch/powerpc/platforms/pseries/eeh_sysfs.c
+++ b/arch/powerpc/platforms/pseries/eeh_sysfs.c
@@ -25,7 +25,6 @@
 #include <linux/pci.h>
 #include <asm/ppc-pci.h>
 #include <asm/pci-bridge.h>
-#include <linux/kobject.h>
 
 /**
  * EEH_SHOW_ATTR -- create sysfs entry for eeh statistic
--- a/drivers/char/snsc.h
+++ b/drivers/char/snsc.h
@@ -19,7 +19,6 @@
 #include <linux/types.h>
 #include <linux/spinlock.h>
 #include <linux/wait.h>
-#include <linux/kobject.h>
 #include <linux/fs.h>
 #include <linux/cdev.h>
 #include <linux/semaphore.h>
--- a/drivers/net/bonding/bonding.h
+++ b/drivers/net/bonding/bonding.h
@@ -18,7 +18,6 @@
 #include <linux/timer.h>
 #include <linux/proc_fs.h>
 #include <linux/if_bonding.h>
-#include <linux/kobject.h>
 #include <linux/cpumask.h>
 #include <linux/in6.h>
 #include "bond_3ad.h"
--- a/drivers/pci/hotplug/acpiphp.h
+++ b/drivers/pci/hotplug/acpiphp.h
@@ -36,7 +36,6 @@
 #define _ACPIPHP_H
 
 #include <linux/acpi.h>
-#include <linux/kobject.h>
 #include <linux/mutex.h>
 #include <linux/pci_hotplug.h>
 
--- a/drivers/pci/hotplug/rpaphp_slot.c
+++ b/drivers/pci/hotplug/rpaphp_slot.c
@@ -24,7 +24,6 @@
  */
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/kobject.h>
 #include <linux/sysfs.h>
 #include <linux/pci.h>
 #include <linux/string.h>
--- a/drivers/s390/char/tape_class.h
+++ b/drivers/s390/char/tape_class.h
@@ -14,7 +14,6 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/major.h>
-#include <linux/kobject.h>
 #include <linux/kobj_map.h>
 #include <linux/cdev.h>
 
--- a/drivers/sh/clk/core.c
+++ b/drivers/sh/clk/core.c
@@ -21,7 +21,6 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
-#include <linux/kobject.h>
 #include <linux/sysdev.h>
 #include <linux/seq_file.h>
 #include <linux/err.h>
--- a/drivers/usb/musb/musb_debugfs.c
+++ b/drivers/usb/musb/musb_debugfs.c
@@ -36,7 +36,6 @@
 #include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/list.h>
-#include <linux/kobject.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/debugfs.h>
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -11,6 +11,7 @@
 #define __INCORE_DOT_H__
 
 #include <linux/fs.h>
+#include <linux/kobject.h>
 #include <linux/workqueue.h>
 #include <linux/dlm.h>
 #include <linux/buffer_head.h>
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -47,7 +47,6 @@
 #include <linux/crc32.h>
 #include <linux/vfs.h>
 #include <linux/writeback.h>
-#include <linux/kobject.h>
 #include <linux/seq_file.h>
 #include <linux/mount.h>
 #include "nilfs.h"
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -19,6 +19,7 @@
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/sysfs.h>
 #include <linux/xattr.h>
 #include <linux/security.h>
 #include "sysfs.h"
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -9,6 +9,7 @@
  */
 
 #include <linux/lockdep.h>
+#include <linux/kobject_ns.h>
 #include <linux/fs.h>
 
 struct sysfs_open_dirent;
--- a/include/linux/firmware-map.h
+++ b/include/linux/firmware-map.h
@@ -17,7 +17,6 @@
 #define _LINUX_FIRMWARE_MAP_H
 
 #include <linux/list.h>
-#include <linux/kobject.h>
 
 /*
  * provide a dummy interface if CONFIG_FIRMWARE_MEMMAP is disabled
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -382,7 +382,6 @@ struct inodes_stat_t {
 #include <linux/path.h>
 #include <linux/stat.h>
 #include <linux/cache.h>
-#include <linux/kobject.h>
 #include <linux/list.h>
 #include <linux/radix-tree.h>
 #include <linux/prio_tree.h>
@@ -402,6 +401,7 @@ struct hd_geometry;
 struct iovec;
 struct nameidata;
 struct kiocb;
+struct kobject;
 struct pipe_inode_info;
 struct poll_table_struct;
 struct kstatfs;
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -87,7 +87,6 @@ struct sched_param {
 #include <linux/timer.h>
 #include <linux/hrtimer.h>
 #include <linux/task_io_accounting.h>
-#include <linux/kobject.h>
 #include <linux/latencytop.h>
 #include <linux/cred.h>
 
--- a/include/linux/sunrpc/cache.h
+++ b/include/linux/sunrpc/cache.h
@@ -13,6 +13,7 @@
 #ifndef _LINUX_SUNRPC_CACHE_H_
 #define _LINUX_SUNRPC_CACHE_H_
 
+#include <linux/kref.h>
 #include <linux/slab.h>
 #include <asm/atomic.h>
 #include <linux/proc_fs.h>
--- a/security/apparmor/include/match.h
+++ b/security/apparmor/include/match.h
@@ -15,6 +15,7 @@
 #ifndef __AA_MATCH_H
 #define __AA_MATCH_H
 
+#include <linux/kref.h>
 #include <linux/workqueue.h>
 
 #define DFA_NOMATCH			0
