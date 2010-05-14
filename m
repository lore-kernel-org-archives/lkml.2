Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab0ENQZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:25:11 -0400
Received: from atlas.linux2go.dk ([88.198.22.52]:35375 "EHLO atlas.linux2go.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab0ENQZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:25:09 -0400
X-Greylist: delayed 462 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 May 2010 12:25:09 EDT
Message-Id: <f0020ee67542b6b535372d6a7b217d71a2c7293b.1273825543.git.soren@linux2go.dk>
In-Reply-To: <cover.1273825543.git.soren@linux2go.dk>
References: <cover.1273825543.git.soren@linux2go.dk>
From: Soren Hansen <soren@linux2go.dk>
To: linux-kernel@vger.kernel.org
Date: Fri, 14 May 2010 18:10:48 +0200
Subject: [PATCH 2/2] Make the Xen block device prefix configurable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a config option to tweak the Xen block device prefix.

Signed-off-by: Soren Hansen <soren@linux2go.dk>
Tested-By: Major Hayden <major.hayden@rackspace.com>
---
 drivers/block/Kconfig        |   10 ++++++++++
 drivers/block/xen-blkfront.c |    2 +-
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 1d886e0..89c1887 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -467,6 +467,16 @@ config XEN_BLKDEV_FRONTEND
 	  block device driver.  It communicates with a back-end driver
 	  in another domain which drives the actual block device.
 
+config XEN_BLKDEV_NAME
+	string "Base name for Xen block devices"
+	depends on XEN_BLKDEV_FRONTEND
+	default "xvd"
+	help
+	  Use this as the base name for Xen block devices. This is
+	  traditionally "xvd", but if you're trying to boot a system
+	  that expects to find its root device on /dev/sda, you can
+	  use this setting to accomodate that.
+
 config VIRTIO_BLK
 	tristate "Virtio block driver (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && VIRTIO
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index b8578bb..a8fd8fd 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -117,7 +117,7 @@ static DEFINE_SPINLOCK(blkif_io_lock);
 #define VDEV_IS_EXTENDED(dev) ((dev)&(EXTENDED))
 #define BLKIF_MINOR_EXT(dev) ((dev)&(~EXTENDED))
 
-#define DEV_NAME	"xvd"	/* name in /dev */
+#define DEV_NAME CONFIG_XEN_BLKDEV_NAME /* name in /dev */
 
 static int get_id_from_freelist(struct blkfront_info *info)
 {
-- 
1.7.0.4

