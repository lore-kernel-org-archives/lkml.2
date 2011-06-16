Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab1FPMP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 08:15:57 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:55431 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757731Ab1FPMPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 08:15:48 -0400
Date: Thu, 16 Jun 2011 14:06:37 +0200
From: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>
To: "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        christian.dietrich@informatik.uni-erlangen.de
Subject: [PATCH 01/11] drivers/ide: use printk_ratelimited() instead of
 printk_ratelimit()
Message-ID: <0a1488254bd51475a90133c0fc41a4d34b533ef4.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
References: <cover.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since printk_ratelimit() shouldn't be used anymore (see comment in
include/linux/printk.h), replace it with printk_ratelimited().

Signed-off-by: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>
---
 drivers/ide/ide-atapi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 6f218e01..1b04f45 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -8,6 +8,7 @@
 #include <linux/ide.h>
 #include <linux/scatterlist.h>
 #include <linux/gfp.h>
+#include <linux/ratelimit.h>
 
 #include <scsi/scsi.h>
 
@@ -200,8 +201,7 @@ void ide_prep_sense(ide_drive_t *drive, struct request *rq)
 	err = blk_rq_map_kern(drive->queue, sense_rq, sense, sense_len,
 			      GFP_NOIO);
 	if (unlikely(err)) {
-		if (printk_ratelimit())
-			printk(KERN_WARNING PFX "%s: failed to map sense "
+		printk_ratelimited(KERN_WARNING PFX "%s: failed to map sense "
 					    "buffer\n", drive->name);
 		return;
 	}
-- 
1.7.4.1

