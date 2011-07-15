Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab1GORtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:49:21 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:37226
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754053Ab1GOR37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:29:59 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 042/117] Staging: hv: vmbus: Get rid of the function dump_gpadl_body()
Date: Fri, 15 Jul 2011 10:46:30 -0700
Message-Id: <1310752065-27895-42-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the function dump_gpadl_body() since it adds no value and actually is
in the data path.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/channel.c |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 222adcc..2d5bfac 100644
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

