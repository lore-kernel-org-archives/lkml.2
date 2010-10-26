Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933424Ab0JZSBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 14:01:13 -0400
Received: from pecan.exetel.com.au ([220.233.0.17]:48958 "EHLO
	smtp.po.exetel.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933313Ab0JZSAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 14:00:05 -0400
X-Greylist: delayed 1108 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Oct 2010 14:00:05 EDT
From: "Alex Dubov" <oakad@yahoo.com>
To: "LKML" <linux-kernel@vger.kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
        "Maxim Levitsky" <maximlevitsky@gmail.com>,
        Alex Dubov <oakad@yahoo.com>
Subject: [PATCH 2/4] memstick: remove mspro_block_mutex
Date: Wed, 27 Oct 2010 04:41:09 +1100
Message-Id: <1288114871-805-3-git-send-email-oakad@yahoo.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1288114871-805-2-git-send-email-oakad@yahoo.com>
References: <1288114871-805-1-git-send-email-oakad@yahoo.com>
 <1288114871-805-2-git-send-email-oakad@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Dubov <oakad@yahoo.com>

mspro_block_mutex is identical in scope to mspro_block_disk_lock and therefore
unnecessary.

Signed-off-by: Alex Dubov <oakad@yahoo.com>
---
 drivers/memstick/core/mspro_block.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index a167938..b11b2b8 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -23,7 +23,6 @@
 
 #define DRIVER_NAME "mspro_block"
 
-static DEFINE_MUTEX(mspro_block_mutex);
 static int major;
 module_param(major, int, 0644);
 
@@ -181,7 +180,6 @@ static int mspro_block_bd_open(struct block_device *bdev, fmode_t mode)
 	struct mspro_block_data *msb = disk->private_data;
 	int rc = -ENXIO;
 
-	mutex_lock(&mspro_block_mutex);
 	mutex_lock(&mspro_block_disk_lock);
 
 	if (msb && msb->card) {
@@ -193,7 +191,6 @@ static int mspro_block_bd_open(struct block_device *bdev, fmode_t mode)
 	}
 
 	mutex_unlock(&mspro_block_disk_lock);
-	mutex_unlock(&mspro_block_mutex);
 
 	return rc;
 }
@@ -225,11 +222,7 @@ static int mspro_block_disk_release(struct gendisk *disk)
 
 static int mspro_block_bd_release(struct gendisk *disk, fmode_t mode)
 {
-	int ret;
-	mutex_lock(&mspro_block_mutex);
-	ret = mspro_block_disk_release(disk);
-	mutex_unlock(&mspro_block_mutex);
-	return ret;
+	return mspro_block_disk_release(disk);
 }
 
 static int mspro_block_bd_getgeo(struct block_device *bdev,
-- 
1.6.5.1

