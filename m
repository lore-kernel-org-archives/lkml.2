Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592Ab1JCU6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 16:58:42 -0400
Received: from mail09.linbit.com ([212.69.161.110]:41574 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726Ab1JCU6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 16:58:35 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 03/10] drbd: cmdname() enum to string convertion was missing a few constants
Date: Mon,  3 Oct 2011 22:58:26 +0200
Message-Id: <1317675513-12745-4-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317675513-12745-1-git-send-email-philipp.reisner@linbit.com>
References: <1317675513-12745-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index a0d81de..96add4e 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -3243,8 +3243,17 @@ const char *cmdname(enum drbd_packet cmd)
 		[P_DELAY_PROBE]         = "DelayProbe",
 		[P_OUT_OF_SYNC]		= "OutOfSync",
 		[P_RETRY_WRITE]		= "RetryWrite",
+		[P_RS_CANCEL]		= "RSCancel",
+		[P_CONN_ST_CHG_REQ]	= "conn_st_chg_req",
+		[P_CONN_ST_CHG_REPLY]	= "conn_st_chg_reply",
+
+		/* enum drbd_packet, but not commands - obsoleted flags:
+		 *	P_MAY_IGNORE
+		 *	P_MAX_OPT_CMD
+		 */
 	};
 
+	/* too big for the array: 0xfffX */
 	if (cmd == P_INITIAL_META)
 		return "InitialMeta";
 	if (cmd == P_INITIAL_DATA)
-- 
1.7.4.1

