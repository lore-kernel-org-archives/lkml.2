Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933066Ab2HPQX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:23:29 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:16704 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932992Ab2HPQWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:22:34 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        JEns Axboe <axboe@kernel.dk>
Subject: [PATCH 5/6] xen/blkback: Fix compile warning
Date: Thu, 16 Aug 2012 12:12:37 -0400
Message-Id: <1345133558-23341-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345133558-23341-1-git-send-email-konrad.wilk@oracle.com>
References: <1345133558-23341-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/block/xen-blkback/xenbus.c:260:5: warning: symbol 'xenvbd_sysfs_addif' was not declared. Should it be static?
drivers/block/xen-blkback/xenbus.c:284:6: warning: symbol 'xenvbd_sysfs_delif' was not declared. Should it be static?

CC: JEns Axboe <axboe@kernel.dk>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkback/xenbus.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 4f66171..d0fed55 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -196,7 +196,7 @@ static void xen_blkif_disconnect(struct xen_blkif *blkif)
 	}
 }
 
-void xen_blkif_free(struct xen_blkif *blkif)
+static void xen_blkif_free(struct xen_blkif *blkif)
 {
 	if (!atomic_dec_and_test(&blkif->refcnt))
 		BUG();
@@ -257,7 +257,7 @@ static struct attribute_group xen_vbdstat_group = {
 VBD_SHOW(physical_device, "%x:%x\n", be->major, be->minor);
 VBD_SHOW(mode, "%s\n", be->mode);
 
-int xenvbd_sysfs_addif(struct xenbus_device *dev)
+static int xenvbd_sysfs_addif(struct xenbus_device *dev)
 {
 	int error;
 
@@ -281,7 +281,7 @@ fail1:	device_remove_file(&dev->dev, &dev_attr_physical_device);
 	return error;
 }
 
-void xenvbd_sysfs_delif(struct xenbus_device *dev)
+static void xenvbd_sysfs_delif(struct xenbus_device *dev)
 {
 	sysfs_remove_group(&dev->dev.kobj, &xen_vbdstat_group);
 	device_remove_file(&dev->dev, &dev_attr_mode);
-- 
1.7.7.6

