Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab1IGQqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:46:25 -0400
Received: from mail09.linbit.com ([212.69.161.110]:48580 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab1IGQqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:46:00 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 12/14] drbd: Remove useless error messages
Date: Wed,  7 Sep 2011 16:17:39 +0200
Message-Id: <1315405061-1473-13-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315405061-1473-1-git-send-email-philipp.reisner@linbit.com>
References: <1315405061-1473-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

These messages can only trigger in case there is a pretty obvious
internal programming error.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index a4b24f9..227cddc 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2183,8 +2183,7 @@ static int receive_DataRequest(struct drbd_conf *mdev, enum drbd_packet cmd,
 			drbd_send_ack_ex(mdev, P_OV_RESULT, sector, size, ID_IN_SYNC);
 			break;
 		default:
-			dev_err(DEV, "unexpected command (%s) in receive_DataRequest\n",
-				cmdname(cmd));
+			BUG();
 		}
 		if (verb && __ratelimit(&drbd_ratelimit_state))
 			dev_err(DEV, "Can not satisfy peer's read request, "
@@ -2270,10 +2269,7 @@ static int receive_DataRequest(struct drbd_conf *mdev, enum drbd_packet cmd,
 		break;
 
 	default:
-		dev_err(DEV, "unexpected command (%s) in receive_DataRequest\n",
-		    cmdname(cmd));
-		fault_type = DRBD_FAULT_MAX;
-		goto out_free_e;
+		BUG();
 	}
 
 	/* Throttle, drbd_rs_begin_io and submit should become asynchronous
-- 
1.7.4.1

