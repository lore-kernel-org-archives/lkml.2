Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750967Ab0HSEFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 00:05:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40281 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab0HSEFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 00:05:05 -0400
From: Tao Ma <tao.ma@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Tao Ma <tao.ma@oracle.com>, Jiri Kosina <trivial@kernel.org>
Subject: [PATCH] trivial: Use kzalloc in idedisk_prep_fn.
Date: Thu, 19 Aug 2010 12:02:21 +0800
Message-Id: <1282190541-12154-1-git-send-email-tao.ma@oracle.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Jiri Kosina <trivial@kernel.org>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 drivers/ide/ide-disk.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 7433e07..471bb0d 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -435,12 +435,11 @@ static int idedisk_prep_fn(struct request_queue *q, struct request *rq)
 	if (!(rq->cmd_flags & REQ_FLUSH))
 		return BLKPREP_OK;
 
-	cmd = kmalloc(sizeof(*cmd), GFP_ATOMIC);
+	cmd = kzalloc(sizeof(*cmd), GFP_ATOMIC);
 
 	/* FIXME: map struct ide_taskfile on rq->cmd[] */
 	BUG_ON(cmd == NULL);
 
-	memset(cmd, 0, sizeof(*cmd));
 	if (ata_id_flush_ext_enabled(drive->id) &&
 	    (drive->capacity64 >= (1UL << 28)))
 		cmd->tf.command = ATA_CMD_FLUSH_EXT;
-- 
1.7.1.GIT

