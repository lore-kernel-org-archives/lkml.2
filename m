Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678Ab1FPUKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:10:38 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:42467
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758717Ab1FPUCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:02:00 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 45/77] Staging: hv: vmbus: Get rid of the function dump_gpadl_header()
Date: Thu, 16 Jun 2011 13:17:18 -0700
Message-Id: <1308255470-3826-45-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308255470-3826-1-git-send-email-kys@microsoft.com>
References: <1308255393-3785-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the function dump_gpadl_header() as this adds no value.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/channel.c |   28 ----------------------------
 1 files changed, 0 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 4f158f8..6a780f2 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -239,33 +239,6 @@ errorout:
 }
 EXPORT_SYMBOL_GPL(vmbus_open);
 
-
-/*
- * dump_gpadl_header - Dump the gpadl header message to the console for
- * debugging purposes.
- */
-static void dump_gpadl_header(struct vmbus_channel_gpadl_header *gpadl)
-{
-	int i, j;
-	int pagecount;
-
-	DPRINT_DBG(VMBUS,
-		   "gpadl header - relid %d, range count %d, range buflen %d",
-		   gpadl->child_relid, gpadl->rangecount, gpadl->range_buflen);
-	for (i = 0; i < gpadl->rangecount; i++) {
-		pagecount = gpadl->range[i].byte_count >> PAGE_SHIFT;
-		pagecount = (pagecount > 26) ? 26 : pagecount;
-
-		DPRINT_DBG(VMBUS, "gpadl range %d - len %d offset %d "
-			   "page count %d", i, gpadl->range[i].byte_count,
-			   gpadl->range[i].byte_offset, pagecount);
-
-		for (j = 0; j < pagecount; j++)
-			DPRINT_DBG(VMBUS, "%d) pfn %llu", j,
-				   gpadl->range[i].pfn_array[j]);
-	}
-}
-
 /*
  * create_gpadl_header - Creates a gpadl for the specified buffer
  */
@@ -443,7 +416,6 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 	gpadlmsg->child_relid = channel->offermsg.child_relid;
 	gpadlmsg->gpadl = next_gpadl_handle;
 
-	dump_gpadl_header(gpadlmsg);
 
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 	list_add_tail(&msginfo->msglistentry,
-- 
1.7.4.1

