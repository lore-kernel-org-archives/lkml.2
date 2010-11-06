Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab0KFJHi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 05:07:38 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:38020 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab0KFJHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 05:07:00 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org
Subject: [PATCH] IDE: ide-floppy, remove unnecessary NULL check
Date: Sat,  6 Nov 2010 10:06:51 +0100
Message-Id: <1289034412-24278-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1289034412-24278-1-git-send-email-jslaby@suse.cz>
References: <1289034412-24278-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse founf that rq in ide_floppy_callback cannot be NULL, because it
is dereferenced all around. So remove the superfluous check.

This appeared after blk_* macors removal.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-ide@vger.kernel.org
---
 drivers/ide/ide-floppy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 5406b6e..536ff68 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -73,7 +73,7 @@ static int ide_floppy_callback(ide_drive_t *drive, int dsc)
 		drive->failed_pc = NULL;
 
 	if (pc->c[0] == GPCMD_READ_10 || pc->c[0] == GPCMD_WRITE_10 ||
-	    (rq && rq->cmd_type == REQ_TYPE_BLOCK_PC))
+	    rq->cmd_type == REQ_TYPE_BLOCK_PC)
 		uptodate = 1; /* FIXME */
 	else if (pc->c[0] == GPCMD_REQUEST_SENSE) {
 
-- 
1.7.3.1


