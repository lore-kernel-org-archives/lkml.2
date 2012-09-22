Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab2IVJHL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 05:07:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49346 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab2IVJHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 05:07:09 -0400
Message-ID: <505D7FBF.1080505@gmail.com>
Date: Sat, 22 Sep 2012 17:07:11 +0800
From: Zhao Hongjiang <zhaohongjiang37@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: axboe@kernel.dk
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] block: change return values from -EACCES to -EPERM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhao Hongjiang <zhaohongjiang@huawei.com>

Change return value from -EACCES to -EPERM when the permission check fails.

Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
---

This patch is based on linux-next tree http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git

---
 block/compat_ioctl.c |    2 +-
 block/ioctl.c        |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index 7c668c8..a21bf98 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -725,7 +725,7 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	case BLKRASET: /* compatible, but no compat_ptr (!) */
 	case BLKFRASET:
 		if (!capable(CAP_SYS_ADMIN))
-			return -EACCES;
+			return -EPERM;
 		bdi = blk_get_backing_dev_info(bdev);
 		if (bdi == NULL)
 			return -ENOTTY;
diff --git a/block/ioctl.c b/block/ioctl.c
index a31d91d..b7d6f07 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -21,7 +21,7 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 	int partno;

 	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
+		return -EPERM;
 	if (copy_from_user(&a, arg, sizeof(struct blkpg_ioctl_arg)))
 		return -EFAULT;
 	if (copy_from_user(&p, a.data, sizeof(struct blkpg_partition)))
@@ -158,7 +158,7 @@ static int blkdev_reread_part(struct block_device *bdev)
 	if (!disk_part_scan_enabled(disk) || bdev != bdev->bd_contains)
 		return -EINVAL;
 	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
+		return -EPERM;
 	if (!mutex_trylock(&bdev->bd_mutex))
 		return -EBUSY;
 	res = rescan_partitions(disk, bdev);
@@ -282,7 +282,7 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	switch(cmd) {
 	case BLKFLSBUF:
 		if (!capable(CAP_SYS_ADMIN))
-			return -EACCES;
+			return -EPERM;

 		ret = __blkdev_driver_ioctl(bdev, mode, cmd, arg);
 		if (!is_unrecognized_ioctl(ret))
@@ -297,7 +297,7 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 		if (!is_unrecognized_ioctl(ret))
 			return ret;
 		if (!capable(CAP_SYS_ADMIN))
-			return -EACCES;
+			return -EPERM;
 		if (get_user(n, (int __user *)(arg)))
 			return -EFAULT;
 		set_device_ro(bdev, n);
@@ -381,7 +381,7 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	case BLKRASET:
 	case BLKFRASET:
 		if(!capable(CAP_SYS_ADMIN))
-			return -EACCES;
+			return -EPERM;
 		bdi = blk_get_backing_dev_info(bdev);
 		if (bdi == NULL)
 			return -ENOTTY;
@@ -390,7 +390,7 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	case BLKBSZSET:
 		/* set the logical block size */
 		if (!capable(CAP_SYS_ADMIN))
-			return -EACCES;
+			return -EPERM;
 		if (!arg)
 			return -EINVAL;
 		if (get_user(n, (int __user *) arg))
-- 1.7.1
