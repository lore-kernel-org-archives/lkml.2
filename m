Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab1IELve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:51:34 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59856 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab1IELpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:45:54 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 14/54] drbd: drbd_gen_and_send_sync_uuid(): Return void: the result is never used
Date: Mon,  5 Sep 2011 13:45:05 +0200
Message-Id: <1315223145-20640-15-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
References: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    2 +-
 drivers/block/drbd/drbd_main.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index c8fd6cc..a375133 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1167,7 +1167,7 @@ extern int drbd_send_all(struct drbd_tconn *, struct socket *, void *, size_t,
 extern int drbd_send_protocol(struct drbd_tconn *tconn);
 extern int drbd_send_uuids(struct drbd_conf *mdev);
 extern int drbd_send_uuids_skip_initial_sync(struct drbd_conf *mdev);
-extern int drbd_gen_and_send_sync_uuid(struct drbd_conf *mdev);
+extern void drbd_gen_and_send_sync_uuid(struct drbd_conf *mdev);
 extern int drbd_send_sizes(struct drbd_conf *mdev, int trigger_reply, enum dds_flags flags);
 extern int _conn_send_state_req(struct drbd_tconn *, int vnr, enum drbd_packet cmd,
 				union drbd_state, union drbd_state);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 774b3ed..ad3e2d0 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -917,7 +917,7 @@ void drbd_print_uuids(struct drbd_conf *mdev, const char *text)
 	}
 }
 
-int drbd_gen_and_send_sync_uuid(struct drbd_conf *mdev)
+void drbd_gen_and_send_sync_uuid(struct drbd_conf *mdev)
 {
 	struct p_rs_uuid p;
 	u64 uuid;
@@ -930,7 +930,7 @@ int drbd_gen_and_send_sync_uuid(struct drbd_conf *mdev)
 	drbd_md_sync(mdev);
 	p.uuid = cpu_to_be64(uuid);
 
-	return !drbd_send_cmd(mdev, &mdev->tconn->data, P_SYNC_UUID, &p.head, sizeof(p));
+	drbd_send_cmd(mdev, &mdev->tconn->data, P_SYNC_UUID, &p.head, sizeof(p));
 }
 
 int drbd_send_sizes(struct drbd_conf *mdev, int trigger_reply, enum dds_flags flags)
-- 
1.7.4.1

