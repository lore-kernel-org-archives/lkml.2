Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab2DVJPx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 05:15:53 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:38669 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab2DVJPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 05:15:51 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Chirag Kantharia <chirag.kantharia@hp.com>
Cc: kernel-janitors@vger.kernel.org, iss_storagedev@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/block/cpqarray.c: add missing cmd_free
Date: Sun, 22 Apr 2012 11:15:12 +0200
Message-Id: <1335086112-10528-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Call cmd_free(h, c, 0); before leaving the function as done on all other
exit paths.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/block/cpqarray.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index 9125bbe..db6f15d 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -1334,6 +1334,7 @@ static int ida_ctlr_ioctl(ctlr_info_t *h, int dsk, ida_ioctl_t *io)
 	case READ_FLASH_ROM:
 		if (copy_to_user(io->sg[0].addr, p, io->sg[0].size)) {
 			kfree(p);
+			cmd_free(h, c, 0);
 			return -EFAULT;
 		}
 		/* fall through and free p */

