Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab1K3CQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:16:06 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:35650 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756637Ab1K3CQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:16:01 -0500
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/28] block_dev: Use current logging style
Date: Tue, 29 Nov 2011 18:14:06 -0800
Message-Id: <e3a99bbe4b6944436d22ca256910c65041cabd7e.1322609672.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1322609672.git.joe@perches.com>
References: <cover.1322609672.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add and use pr_fmt and pr_<level>
Coalesce formats.

No change in output as pr_fmt is #define pr_fmt(fmt) fmt

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/block_dev.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 3154fbe..20aa631 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -5,6 +5,8 @@
  *  Copyright (C) 2001  Andrea Arcangeli <andrea@suse.de> SuSE
  */
 
+#define pr_fmt(fmt) fmt
+
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/fcntl.h>
@@ -965,8 +967,8 @@ static void flush_disk(struct block_device *bdev, bool kill_dirty)
 
 		if (bdev->bd_disk)
 			disk_name(bdev->bd_disk, 0, name);
-		printk(KERN_WARNING "VFS: busy inodes on changed media or "
-		       "resized disk %s\n", name);
+		pr_warn("VFS: busy inodes on changed media or resized disk %s\n",
+			name);
 	}
 
 	if (!bdev->bd_disk)
@@ -993,9 +995,8 @@ void check_disk_size_change(struct gendisk *disk, struct block_device *bdev)
 		char name[BDEVNAME_SIZE];
 
 		disk_name(disk, 0, name);
-		printk(KERN_INFO
-		       "%s: detected capacity change from %lld to %lld\n",
-		       name, bdev_size, disk_size);
+		pr_info("%s: detected capacity change from %lld to %lld\n",
+			name, bdev_size, disk_size);
 		i_size_write(bdev->bd_inode, disk_size);
 		flush_disk(bdev, false);
 	}
-- 
1.7.6.405.gc1be0

