Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662Ab1LERau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:30:50 -0500
Received: from www17.your-server.de ([213.133.104.17]:38023 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932546Ab1LERat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:30:49 -0500
Subject: [PATCH] [SCSI] bnx2fc: Use kcalloc instead of kzalloc to allocate
 array
From: Thomas Meyer <thomas@m3y3r.de>
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.329.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c 2011-11-13 11:07:46.087131212 +0100
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c 2011-11-28 20:02:42.476121413 +0100
@@ -270,15 +270,15 @@ struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_al
 		return NULL;
 	}
 
-	cmgr->free_list = kzalloc(sizeof(*cmgr->free_list) *
-				  arr_sz, GFP_KERNEL);
+	cmgr->free_list = kcalloc(arr_sz, sizeof(*cmgr->free_list),
+				  GFP_KERNEL);
 	if (!cmgr->free_list) {
 		printk(KERN_ERR PFX "failed to alloc free_list\n");
 		goto mem_err;
 	}
 
-	cmgr->free_list_lock = kzalloc(sizeof(*cmgr->free_list_lock) *
-				       arr_sz, GFP_KERNEL);
+	cmgr->free_list_lock = kcalloc(arr_sz, sizeof(*cmgr->free_list_lock),
+				       GFP_KERNEL);
 	if (!cmgr->free_list_lock) {
 		printk(KERN_ERR PFX "failed to alloc free_list_lock\n");
 		goto mem_err;
