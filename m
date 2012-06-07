Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab2FGUUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 16:20:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45640 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab2FGUU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 16:20:28 -0400
From: Sam Hansen <solid.se7en@gmail.com>
To: Sam Hansen <sam@meebo-inc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        Sam Hansen <solid.se7en@gmail.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] staging: zram: conventions pr_warning -> pr_warn()
Date: Thu,  7 Jun 2012 13:20:02 -0700
Message-Id: <1339100404-18773-2-git-send-email-solid.se7en@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1339100404-18773-1-git-send-email-solid.se7en@gmail.com>
References: <1339100404-18773-1-git-send-email-solid.se7en@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Porting zram to use the pr_warn() function instead of the deprecated
pr_warning().

Signed-off-by: Sam Hansen <solid.se7en@gmail.com>
---
 drivers/staging/zram/zram_drv.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 685d612..55775ce 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -724,7 +724,7 @@ static int create_device(struct zram *zram, int device_id)
 	zram->disk = alloc_disk(1);
 	if (!zram->disk) {
 		blk_cleanup_queue(zram->queue);
-		pr_warning("Error allocating disk structure for device %d\n",
+		pr_warn("Error allocating disk structure for device %d\n",
 			device_id);
 		ret = -ENOMEM;
 		goto out;
@@ -755,7 +755,7 @@ static int create_device(struct zram *zram, int device_id)
 	ret = sysfs_create_group(&disk_to_dev(zram->disk)->kobj,
 				&zram_disk_attr_group);
 	if (ret < 0) {
-		pr_warning("Error creating sysfs group");
+		pr_warn("Error creating sysfs group");
 		goto out;
 	}
 
@@ -789,7 +789,7 @@ static int __init zram_init(void)
 	int ret, dev_id;
 
 	if (num_devices > max_num_devices) {
-		pr_warning("Invalid value for num_devices: %u\n",
+		pr_warn("Invalid value for num_devices: %u\n",
 				num_devices);
 		ret = -EINVAL;
 		goto out;
@@ -797,7 +797,7 @@ static int __init zram_init(void)
 
 	zram_major = register_blkdev(0, "zram");
 	if (zram_major <= 0) {
-		pr_warning("Unable to get major number\n");
+		pr_warn("Unable to get major number\n");
 		ret = -EBUSY;
 		goto out;
 	}
-- 
1.7.5.4

