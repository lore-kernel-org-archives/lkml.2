Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964922Ab1JFNjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 09:39:04 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34206 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758374Ab1JFNiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 09:38:10 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 13/15] drbd: Turn no-disk-drain into disk-drain={yes|no}
Date: Thu,  6 Oct 2011 15:37:58 +0200
Message-Id: <1317908280-28951-14-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317908280-28951-1-git-send-email-philipp.reisner@linbit.com>
References: <1317908280-28951-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Change the --no-disk-drain drbdsetup command line option as well as
the no_disk_drain netlink packet.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |    2 +-
 include/linux/drbd_genl.h          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 1024f04..a80f064 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1181,7 +1181,7 @@ void drbd_bump_write_ordering(struct drbd_conf *mdev, enum write_ordering_e wo)
 
 	if (wo == WO_bdev_flush && !dc->disk_flushes)
 		wo = WO_drain_io;
-	if (wo == WO_drain_io && dc->no_disk_drain)
+	if (wo == WO_drain_io && !dc->disk_drain)
 		wo = WO_none;
 	rcu_read_unlock();
 	mdev->write_ordering = wo;
diff --git a/include/linux/drbd_genl.h b/include/linux/drbd_genl.h
index c5e7a99..96e5b18 100644
--- a/include/linux/drbd_genl.h
+++ b/include/linux/drbd_genl.h
@@ -126,7 +126,7 @@ GENL_struct(DRBD_NLA_DISK_CONF, 3, disk_conf,
 
 	__flg_field_def(16, GENLA_F_MANDATORY,	disk_barrier, 1)
 	__flg_field_def(17, GENLA_F_MANDATORY,	disk_flushes, 1)
-	__flg_field_def(18, GENLA_F_MANDATORY,	no_disk_drain, 0)
+	__flg_field_def(18, GENLA_F_MANDATORY,	disk_drain, 1)
 	__flg_field_def(19, GENLA_F_MANDATORY,	no_md_flush, 0)
 )
 
-- 
1.7.4.1

