Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab1JLMbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:31:24 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33912 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab1JLM1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:27:39 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 04/13] drbd: spelling fix: too small
Date: Wed, 12 Oct 2011 14:27:26 +0200
Message-Id: <1318422455-17539-5-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318422455-17539-1-git-send-email-philipp.reisner@linbit.com>
References: <1318422455-17539-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

It is not "to small", but "too small".

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c |    8 ++++----
 include/linux/drbd.h         |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index ab58651..261b512 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1400,7 +1400,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		dev_err(DEV, "max capacity %llu smaller than disk size %llu\n",
 			(unsigned long long) drbd_get_max_capacity(nbc),
 			(unsigned long long) new_disk_conf->disk_size);
-		retcode = ERR_DISK_TO_SMALL;
+		retcode = ERR_DISK_TOO_SMALL;
 		goto fail;
 	}
 
@@ -1414,7 +1414,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (drbd_get_capacity(nbc->md_bdev) < min_md_device_sectors) {
-		retcode = ERR_MD_DISK_TO_SMALL;
+		retcode = ERR_MD_DISK_TOO_SMALL;
 		dev_warn(DEV, "refusing attach: md-device too small, "
 		     "at least %llu sectors needed for this meta-disk type\n",
 		     (unsigned long long) min_md_device_sectors);
@@ -1425,7 +1425,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	 * (we may currently be R_PRIMARY with no local disk...) */
 	if (drbd_get_max_capacity(nbc) <
 	    drbd_get_capacity(mdev->this_bdev)) {
-		retcode = ERR_DISK_TO_SMALL;
+		retcode = ERR_DISK_TOO_SMALL;
 		goto fail;
 	}
 
@@ -1487,7 +1487,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	if (drbd_md_test_flag(nbc, MDF_CONSISTENT) &&
 	    drbd_new_dev_size(mdev, nbc, nbc->disk_conf->disk_size, 0) < nbc->md.la_size_sect) {
 		dev_warn(DEV, "refusing to truncate a consistent device\n");
-		retcode = ERR_DISK_TO_SMALL;
+		retcode = ERR_DISK_TOO_SMALL;
 		goto force_diskless_dec;
 	}
 
diff --git a/include/linux/drbd.h b/include/linux/drbd.h
index 679e811..fedda00 100644
--- a/include/linux/drbd.h
+++ b/include/linux/drbd.h
@@ -112,8 +112,8 @@ enum drbd_ret_code {
 	ERR_OPEN_MD_DISK	= 105,
 	ERR_DISK_NOT_BDEV	= 107,
 	ERR_MD_NOT_BDEV		= 108,
-	ERR_DISK_TO_SMALL	= 111,
-	ERR_MD_DISK_TO_SMALL	= 112,
+	ERR_DISK_TOO_SMALL	= 111,
+	ERR_MD_DISK_TOO_SMALL	= 112,
 	ERR_BDCLAIM_DISK	= 114,
 	ERR_BDCLAIM_MD_DISK	= 115,
 	ERR_MD_IDX_INVALID	= 116,
-- 
1.7.4.1

