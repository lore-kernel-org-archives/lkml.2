Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab1JNV57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 17:57:59 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60886 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757002Ab1JNV54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 17:57:56 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 10/11] drbd: Be consistent in reporting incompatibilities in P_PROTOCOL settings
Date: Fri, 14 Oct 2011 23:57:51 +0200
Message-Id: <1318629472-11110-11-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318629472-11110-1-git-send-email-philipp.reisner@linbit.com>
References: <1318629472-11110-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Refer to the settings by the names which drbdsetup and drbd.conf are using.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 06bbf0f..aa674bf 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3093,37 +3093,37 @@ static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
 		nc = rcu_dereference(tconn->net_conf);
 
 		if (p_proto != nc->wire_protocol) {
-			conn_err(tconn, "incompatible communication protocols\n");
+			conn_err(tconn, "incompatible %s settings\n", "protocol");
 			goto disconnect_rcu_unlock;
 		}
 
 		if (convert_after_sb(p_after_sb_0p) != nc->after_sb_0p) {
-			conn_err(tconn, "incompatible after-sb-0pri settings\n");
+			conn_err(tconn, "incompatible %s settings\n", "after-sb-0pri");
 			goto disconnect_rcu_unlock;
 		}
 
 		if (convert_after_sb(p_after_sb_1p) != nc->after_sb_1p) {
-			conn_err(tconn, "incompatible after-sb-1pri settings\n");
+			conn_err(tconn, "incompatible %s settings\n", "after-sb-1pri");
 			goto disconnect_rcu_unlock;
 		}
 
 		if (convert_after_sb(p_after_sb_2p) != nc->after_sb_2p) {
-			conn_err(tconn, "incompatible after-sb-2pri settings\n");
+			conn_err(tconn, "incompatible %s settings\n", "after-sb-2pri");
 			goto disconnect_rcu_unlock;
 		}
 
 		if (p_discard_my_data && nc->discard_my_data) {
-			conn_err(tconn, "both sides have the 'discard_my_data' flag set\n");
+			conn_err(tconn, "incompatible %s settings\n", "discard-my-data");
 			goto disconnect_rcu_unlock;
 		}
 
 		if (p_two_primaries != nc->two_primaries) {
-			conn_err(tconn, "incompatible setting of the two-primaries options\n");
+			conn_err(tconn, "incompatible %s settings\n", "allow-two-primaries");
 			goto disconnect_rcu_unlock;
 		}
 
 		if (strcmp(integrity_alg, nc->integrity_alg)) {
-			conn_err(tconn, "incompatible setting of the data-integrity-alg\n");
+			conn_err(tconn, "incompatible %s settings\n", "data-integrity-alg");
 			goto disconnect_rcu_unlock;
 		}
 
-- 
1.7.4.1

