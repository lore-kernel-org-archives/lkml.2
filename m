Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758541Ab1JFNjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 09:39:05 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34192 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758369Ab1JFNiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 09:38:10 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 12/15] drbd: Turn no-disk-flushes into disk-flushes={yes|no}
Date: Thu,  6 Oct 2011 15:37:57 +0200
Message-Id: <1317908280-28951-13-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317908280-28951-1-git-send-email-philipp.reisner@linbit.com>
References: <1317908280-28951-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Change the --no-disk-flushes drbdsetup command line option as well as
the no_disk_flush netlink packet.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |    2 +-
 include/linux/drbd_genl.h          |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 73f605b..1024f04 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1179,7 +1179,7 @@ void drbd_bump_write_ordering(struct drbd_conf *mdev, enum write_ordering_e wo)
 	rcu_read_lock();
 	dc = rcu_dereference(mdev->ldev->disk_conf);
 
-	if (wo == WO_bdev_flush && dc->no_disk_flush)
+	if (wo == WO_bdev_flush && !dc->disk_flushes)
 		wo = WO_drain_io;
 	if (wo == WO_drain_io && dc->no_disk_drain)
 		wo = WO_none;
diff --git a/include/linux/drbd_genl.h b/include/linux/drbd_genl.h
index 529627b..c5e7a99 100644
--- a/include/linux/drbd_genl.h
+++ b/include/linux/drbd_genl.h
@@ -124,8 +124,8 @@ GENL_struct(DRBD_NLA_DISK_CONF, 3, disk_conf,
 	__u32_field_def(14,	GENLA_F_MANDATORY,	c_max_rate, DRBD_C_MAX_RATE_DEF)
 	__u32_field_def(15,	GENLA_F_MANDATORY,	c_min_rate, DRBD_C_MIN_RATE_DEF)
 
-	__flg_field_def(16, GENLA_F_MANDATORY,	no_disk_barrier, 0)
-	__flg_field_def(17, GENLA_F_MANDATORY,	no_disk_flush, 0)
+	__flg_field_def(16, GENLA_F_MANDATORY,	disk_barrier, 1)
+	__flg_field_def(17, GENLA_F_MANDATORY,	disk_flushes, 1)
 	__flg_field_def(18, GENLA_F_MANDATORY,	no_disk_drain, 0)
 	__flg_field_def(19, GENLA_F_MANDATORY,	no_md_flush, 0)
 )
-- 
1.7.4.1

