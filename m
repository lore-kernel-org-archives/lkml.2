Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab1IGQRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:17:54 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:36674 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab1IGQRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:17:52 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Paul Clements <Paul.Clements@steeleye.com>
Subject: [PATCH 1/3] nbd: remove unused flags fields
Date: Wed,  7 Sep 2011 16:41:41 +0200
Message-Id: <1315406503-7883-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1315406503-7883-1-git-send-email-pbonzini@redhat.com>
References: <1315406503-7883-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The flags field is never written right now.  Before putting it
to new use in the next patches, clean up the uses.

Cc: Paul Clements <Paul.Clements@steeleye.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/block/nbd.c |   11 +++--------
 include/linux/nbd.h |    4 ----
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index f533f33..be23aec 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -453,15 +453,10 @@ static void nbd_handle_req(struct nbd_device *lo, struct request *req)
 	if (req->cmd_type != REQ_TYPE_FS)
 		goto error_out;
 
-	nbd_cmd(req) = NBD_CMD_READ;
-	if (rq_data_dir(req) == WRITE) {
+	if (rq_data_dir(req) == WRITE)
 		nbd_cmd(req) = NBD_CMD_WRITE;
-		if (lo->flags & NBD_READ_ONLY) {
-			printk(KERN_ERR "%s: Write on read-only\n",
-					lo->disk->disk_name);
-			goto error_out;
-		}
-	}
+	else
+		nbd_cmd(req) = NBD_CMD_READ;
 
 	req->errors = 0;
 
diff --git a/include/linux/nbd.h b/include/linux/nbd.h
index d146ca1..0582054 100644
--- a/include/linux/nbd.h
+++ b/include/linux/nbd.h
@@ -42,10 +42,6 @@ enum {
 #include <linux/wait.h>
 #include <linux/mutex.h>
 
-/* values for flags field */
-#define NBD_READ_ONLY 0x0001
-#define NBD_WRITE_NOCHK 0x0002
-
 struct request;
 
 struct nbd_device {
-- 
1.7.6


