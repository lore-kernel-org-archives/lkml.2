Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab0HCCIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 22:08:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33477 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab0HCCIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 22:08:36 -0400
From: Tao Ma <tao.ma@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, linux-ide@vger.kernel.org, Tao Ma <tao.ma@oracle.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH v2] ide: Use kzalloc in idedisk_prep_fn.
Date: Tue,  3 Aug 2010 10:06:32 +0800
Message-Id: <1280801192-14419-1-git-send-email-tao.ma@oracle.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20100803010903I.fujita.tomonori@lab.ntt.co.jp>
References: <20100803010903I.fujita.tomonori@lab.ntt.co.jp>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C577A16.012D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> This change conflicts with the change in linux-next (came from Jens'
> tree).
Thanks for pointing it out. Here is the updated one.

Regards,
Tao

>From 5b8ae2eb7e3ecb54ea8db3b296727106148f17b3 Mon Sep 17 00:00:00 2001
From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 3 Aug 2010 08:18:27 +0800
Subject: [PATCH v2] ide: Use kzalloc in idedisk_prep_fn.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
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
1.7.1.571.gba4d01

