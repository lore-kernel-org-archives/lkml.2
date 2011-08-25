Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab1HYPXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:23:21 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34368 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab1HYPJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:41 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 067/118] drbd: Moving state related macros to drbd_state.h
Date: Thu, 25 Aug 2011 17:08:03 +0200
Message-Id: <1314284934-17999-68-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h |   52 -----------------------------------------
 1 files changed, 0 insertions(+), 52 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index c625f59..df24541 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1603,58 +1603,6 @@ void drbd_bcast_ee(struct drbd_conf *, const char *, const int, const char *,
 		   const char *, const struct drbd_peer_request *);
 
 
-/**
- * DOC: DRBD State macros
- *
- * These macros are used to express state changes in easily readable form.
- *
- * The NS macros expand to a mask and a value, that can be bit ored onto the
- * current state as soon as the spinlock (req_lock) was taken.
- *
- * The _NS macros are used for state functions that get called with the
- * spinlock. These macros expand directly to the new state value.
- *
- * Besides the basic forms NS() and _NS() additional _?NS[23] are defined
- * to express state changes that affect more than one aspect of the state.
- *
- * E.g. NS2(conn, C_CONNECTED, peer, R_SECONDARY)
- * Means that the network connection was established and that the peer
- * is in secondary role.
- */
-#define role_MASK R_MASK
-#define peer_MASK R_MASK
-#define disk_MASK D_MASK
-#define pdsk_MASK D_MASK
-#define conn_MASK C_MASK
-#define susp_MASK 1
-#define user_isp_MASK 1
-#define aftr_isp_MASK 1
-#define susp_nod_MASK 1
-#define susp_fen_MASK 1
-
-#define NS(T, S) \
-	({ union drbd_state mask; mask.i = 0; mask.T = T##_MASK; mask; }), \
-	({ union drbd_state val; val.i = 0; val.T = (S); val; })
-#define NS2(T1, S1, T2, S2) \
-	({ union drbd_state mask; mask.i = 0; mask.T1 = T1##_MASK; \
-	  mask.T2 = T2##_MASK; mask; }), \
-	({ union drbd_state val; val.i = 0; val.T1 = (S1); \
-	  val.T2 = (S2); val; })
-#define NS3(T1, S1, T2, S2, T3, S3) \
-	({ union drbd_state mask; mask.i = 0; mask.T1 = T1##_MASK; \
-	  mask.T2 = T2##_MASK; mask.T3 = T3##_MASK; mask; }), \
-	({ union drbd_state val;  val.i = 0; val.T1 = (S1); \
-	  val.T2 = (S2); val.T3 = (S3); val; })
-
-#define _NS(D, T, S) \
-	D, ({ union drbd_state __ns; __ns.i = D->state.i; __ns.T = (S); __ns; })
-#define _NS2(D, T1, S1, T2, S2) \
-	D, ({ union drbd_state __ns; __ns.i = D->state.i; __ns.T1 = (S1); \
-	__ns.T2 = (S2); __ns; })
-#define _NS3(D, T1, S1, T2, S2, T3, S3) \
-	D, ({ union drbd_state __ns; __ns.i = D->state.i; __ns.T1 = (S1); \
-	__ns.T2 = (S2); __ns.T3 = (S3); __ns; })
-
 /*
  * inline helper functions
  *************************/
-- 
1.7.4.1

