Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab1HYPaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:30:19 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32962 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab1HYPJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:21 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 042/118] drbd: Move cmdname() out of drbd_int.h
Date: Thu, 25 Aug 2011 17:07:38 +0200
Message-Id: <1314284934-17999-43-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

There is no good reason for cmdname() to be an inline function.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |   59 +---------------------------------------
 drivers/block/drbd/drbd_main.c |   59 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 58 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 4c5d143..e2a33ce 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -221,64 +221,7 @@ enum drbd_packets {
 	P_HAND_SHAKE	      = 0xfffe	/* FIXED for the next century! */
 };
 
-static inline const char *cmdname(enum drbd_packets cmd)
-{
-	/* THINK may need to become several global tables
-	 * when we want to support more than
-	 * one PRO_VERSION */
-	static const char *cmdnames[] = {
-		[P_DATA]	        = "Data",
-		[P_DATA_REPLY]	        = "DataReply",
-		[P_RS_DATA_REPLY]	= "RSDataReply",
-		[P_BARRIER]	        = "Barrier",
-		[P_BITMAP]	        = "ReportBitMap",
-		[P_BECOME_SYNC_TARGET]  = "BecomeSyncTarget",
-		[P_BECOME_SYNC_SOURCE]  = "BecomeSyncSource",
-		[P_UNPLUG_REMOTE]	= "UnplugRemote",
-		[P_DATA_REQUEST]	= "DataRequest",
-		[P_RS_DATA_REQUEST]     = "RSDataRequest",
-		[P_SYNC_PARAM]	        = "SyncParam",
-		[P_SYNC_PARAM89]	= "SyncParam89",
-		[P_PROTOCOL]            = "ReportProtocol",
-		[P_UUIDS]	        = "ReportUUIDs",
-		[P_SIZES]	        = "ReportSizes",
-		[P_STATE]	        = "ReportState",
-		[P_SYNC_UUID]           = "ReportSyncUUID",
-		[P_AUTH_CHALLENGE]      = "AuthChallenge",
-		[P_AUTH_RESPONSE]	= "AuthResponse",
-		[P_PING]		= "Ping",
-		[P_PING_ACK]	        = "PingAck",
-		[P_RECV_ACK]	        = "RecvAck",
-		[P_WRITE_ACK]	        = "WriteAck",
-		[P_RS_WRITE_ACK]	= "RSWriteAck",
-		[P_DISCARD_ACK]	        = "DiscardAck",
-		[P_NEG_ACK]	        = "NegAck",
-		[P_NEG_DREPLY]	        = "NegDReply",
-		[P_NEG_RS_DREPLY]	= "NegRSDReply",
-		[P_BARRIER_ACK]	        = "BarrierAck",
-		[P_STATE_CHG_REQ]       = "StateChgRequest",
-		[P_STATE_CHG_REPLY]     = "StateChgReply",
-		[P_OV_REQUEST]          = "OVRequest",
-		[P_OV_REPLY]            = "OVReply",
-		[P_OV_RESULT]           = "OVResult",
-		[P_CSUM_RS_REQUEST]     = "CsumRSRequest",
-		[P_RS_IS_IN_SYNC]	= "CsumRSIsInSync",
-		[P_COMPRESSED_BITMAP]   = "CBitmap",
-		[P_DELAY_PROBE]         = "DelayProbe",
-		[P_OUT_OF_SYNC]		= "OutOfSync",
-		[P_MAX_CMD]	        = NULL,
-	};
-
-	if (cmd == P_HAND_SHAKE_M)
-		return "HandShakeM";
-	if (cmd == P_HAND_SHAKE_S)
-		return "HandShakeS";
-	if (cmd == P_HAND_SHAKE)
-		return "HandShake";
-	if (cmd >= P_MAX_CMD)
-		return "Unknown";
-	return cmdnames[cmd];
-}
+extern const char *cmdname(enum drbd_packets cmd);
 
 /* for sending/receiving the bitmap,
  * possibly in some encoding scheme */
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index a9dea6d..097b7a2 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -4101,6 +4101,65 @@ static int w_md_sync(struct drbd_conf *mdev, struct drbd_work *w, int unused)
 	return 1;
 }
 
+const char *cmdname(enum drbd_packets cmd)
+{
+	/* THINK may need to become several global tables
+	 * when we want to support more than
+	 * one PRO_VERSION */
+	static const char *cmdnames[] = {
+		[P_DATA]	        = "Data",
+		[P_DATA_REPLY]	        = "DataReply",
+		[P_RS_DATA_REPLY]	= "RSDataReply",
+		[P_BARRIER]	        = "Barrier",
+		[P_BITMAP]	        = "ReportBitMap",
+		[P_BECOME_SYNC_TARGET]  = "BecomeSyncTarget",
+		[P_BECOME_SYNC_SOURCE]  = "BecomeSyncSource",
+		[P_UNPLUG_REMOTE]	= "UnplugRemote",
+		[P_DATA_REQUEST]	= "DataRequest",
+		[P_RS_DATA_REQUEST]     = "RSDataRequest",
+		[P_SYNC_PARAM]	        = "SyncParam",
+		[P_SYNC_PARAM89]	= "SyncParam89",
+		[P_PROTOCOL]            = "ReportProtocol",
+		[P_UUIDS]	        = "ReportUUIDs",
+		[P_SIZES]	        = "ReportSizes",
+		[P_STATE]	        = "ReportState",
+		[P_SYNC_UUID]           = "ReportSyncUUID",
+		[P_AUTH_CHALLENGE]      = "AuthChallenge",
+		[P_AUTH_RESPONSE]	= "AuthResponse",
+		[P_PING]		= "Ping",
+		[P_PING_ACK]	        = "PingAck",
+		[P_RECV_ACK]	        = "RecvAck",
+		[P_WRITE_ACK]	        = "WriteAck",
+		[P_RS_WRITE_ACK]	= "RSWriteAck",
+		[P_DISCARD_ACK]	        = "DiscardAck",
+		[P_NEG_ACK]	        = "NegAck",
+		[P_NEG_DREPLY]	        = "NegDReply",
+		[P_NEG_RS_DREPLY]	= "NegRSDReply",
+		[P_BARRIER_ACK]	        = "BarrierAck",
+		[P_STATE_CHG_REQ]       = "StateChgRequest",
+		[P_STATE_CHG_REPLY]     = "StateChgReply",
+		[P_OV_REQUEST]          = "OVRequest",
+		[P_OV_REPLY]            = "OVReply",
+		[P_OV_RESULT]           = "OVResult",
+		[P_CSUM_RS_REQUEST]     = "CsumRSRequest",
+		[P_RS_IS_IN_SYNC]	= "CsumRSIsInSync",
+		[P_COMPRESSED_BITMAP]   = "CBitmap",
+		[P_DELAY_PROBE]         = "DelayProbe",
+		[P_OUT_OF_SYNC]		= "OutOfSync",
+		[P_MAX_CMD]	        = NULL,
+	};
+
+	if (cmd == P_HAND_SHAKE_M)
+		return "HandShakeM";
+	if (cmd == P_HAND_SHAKE_S)
+		return "HandShakeS";
+	if (cmd == P_HAND_SHAKE)
+		return "HandShake";
+	if (cmd >= P_MAX_CMD)
+		return "Unknown";
+	return cmdnames[cmd];
+}
+
 #ifdef CONFIG_DRBD_FAULT_INJECTION
 /* Fault insertion support including random number generator shamelessly
  * stolen from kernel/rcutorture.c */
-- 
1.7.4.1

