Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746Ab1FPUL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:11:56 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:52213
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758712Ab1FPUCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:02:00 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 44/77] Staging: hv: vmbus: Get rid of the function dump_gpadl_body()
Date: Thu, 16 Jun 2011 13:17:17 -0700
Message-Id: <1308255470-3826-44-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308255470-3826-1-git-send-email-kys@microsoft.com>
References: <1308255393-3785-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the function dump_gpadl_body() since it adds no value and actually is 
in the data path.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/channel.c |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 455f47a..4f158f8 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -239,24 +239,6 @@ errorout:
 }
 EXPORT_SYMBOL_GPL(vmbus_open);
 
-/*
- * dump_gpadl_body - Dump the gpadl body message to the console for
- * debugging purposes.
- */
-static void dump_gpadl_body(struct vmbus_channel_gpadl_body *gpadl, u32 len)
-{
-	int i;
-	int pfncount;
-
-	pfncount = (len - sizeof(struct vmbus_channel_gpadl_body)) /
-		   sizeof(u64);
-
-	DPRINT_DBG(VMBUS, "gpadl body - len %d pfn count %d", len, pfncount);
-
-	for (i = 0; i < pfncount; i++)
-		DPRINT_DBG(VMBUS, "gpadl body  - %d) pfn %llu",
-			   i, gpadl->pfn[i]);
-}
 
 /*
  * dump_gpadl_header - Dump the gpadl header message to the console for
@@ -485,8 +467,6 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 				CHANNELMSG_GPADL_BODY;
 			gpadl_body->gpadl = next_gpadl_handle;
 
-			dump_gpadl_body(gpadl_body, submsginfo->msgsize -
-				      sizeof(*submsginfo));
 			ret = vmbus_post_msg(gpadl_body,
 					       submsginfo->msgsize -
 					       sizeof(*submsginfo));
-- 
1.7.4.1

