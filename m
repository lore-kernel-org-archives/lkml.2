Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab0GEJLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 05:11:30 -0400
Received: from sh.osrg.net ([192.16.179.4]:38192 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab0GEJL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 05:11:29 -0400
Date: Mon, 5 Jul 2010 18:11:25 +0900
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] block: remove unused REQ_TYPE_LINUX_BLOCK
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100705181100B.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 05 Jul 2010 18:11:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You prefer to keep this for future possible users?

This can be applied to block's for-2.6.36.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] block: remove unused REQ_TYPE_LINUX_BLOCK

Nobody uses REQ_TYPE_LINUX_BLOCK (and its REQ_LB_OP_*).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/linux/blkdev.h |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3a2c5d9..baf5258 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -60,7 +60,6 @@ enum rq_cmd_type_bits {
 	REQ_TYPE_PM_RESUME,		/* resume request */
 	REQ_TYPE_PM_SHUTDOWN,		/* shutdown request */
 	REQ_TYPE_SPECIAL,		/* driver defined type */
-	REQ_TYPE_LINUX_BLOCK,		/* generic block layer message */
 	/*
 	 * for ATA/ATAPI devices. this really doesn't belong here, ide should
 	 * use REQ_TYPE_SPECIAL and use rq->cmd[0] with the range of driver
@@ -70,20 +69,6 @@ enum rq_cmd_type_bits {
 	REQ_TYPE_ATA_PC,
 };
 
-/*
- * For request of type REQ_TYPE_LINUX_BLOCK, rq->cmd[0] is the opcode being
- * sent down (similar to how REQ_TYPE_BLOCK_PC means that ->cmd[] holds a
- * SCSI cdb.
- *
- * 0x00 -> 0x3f are driver private, to be used for whatever purpose they need,
- * typically to differentiate REQ_TYPE_SPECIAL requests.
- *
- */
-enum {
-	REQ_LB_OP_EJECT	= 0x40,		/* eject request */
-	REQ_LB_OP_FLUSH = 0x41,		/* flush request */
-};
-
 #define BLK_MAX_CDB	16
 
 /*
-- 
1.6.5

