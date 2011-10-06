Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532Ab1JFNjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 09:39:01 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34151 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab1JFNiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 09:38:10 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 14/15] drbd: Turn no-md-flushes into md-flushes={yes|no}
Date: Thu,  6 Oct 2011 15:37:59 +0200
Message-Id: <1317908280-28951-15-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317908280-28951-1-git-send-email-philipp.reisner@linbit.com>
References: <1317908280-28951-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Change the --no-md-flushes drbdsetup command line option as well as
the no_md_flush netlink packet.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c |    6 +++---
 include/linux/drbd_genl.h    |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index ca39deb..d82e3c1 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1485,10 +1485,10 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 
 	/* Reset the "barriers don't work" bits here, then force meta data to
 	 * be written, to ensure we determine if barriers are supported. */
-	if (new_disk_conf->no_md_flush)
-		set_bit(MD_NO_FUA, &mdev->flags);
-	else
+	if (new_disk_conf->md_flushes)
 		clear_bit(MD_NO_FUA, &mdev->flags);
+	else
+		set_bit(MD_NO_FUA, &mdev->flags);
 
 	/* Point of no return reached.
 	 * Devices and memory are no longer released by error cleanup below.
diff --git a/include/linux/drbd_genl.h b/include/linux/drbd_genl.h
index 96e5b18..0fd79ea 100644
--- a/include/linux/drbd_genl.h
+++ b/include/linux/drbd_genl.h
@@ -127,7 +127,7 @@ GENL_struct(DRBD_NLA_DISK_CONF, 3, disk_conf,
 	__flg_field_def(16, GENLA_F_MANDATORY,	disk_barrier, 1)
 	__flg_field_def(17, GENLA_F_MANDATORY,	disk_flushes, 1)
 	__flg_field_def(18, GENLA_F_MANDATORY,	disk_drain, 1)
-	__flg_field_def(19, GENLA_F_MANDATORY,	no_md_flush, 0)
+	__flg_field_def(19, GENLA_F_MANDATORY,	md_flushes, 1)
 )
 
 GENL_struct(DRBD_NLA_RESOURCE_OPTS, 4, res_opts,
-- 
1.7.4.1

