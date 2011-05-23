Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab1EWPuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 11:50:11 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:56429
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755465Ab1EWPuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 11:50:09 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 6/6] staging: hv: removed commented out code from rndis_filter_receive()
Date: Mon, 23 May 2011 09:03:50 -0700
Message-Id: <1306166630-17336-6-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1306166630-17336-1-git-send-email-haiyangz@microsoft.com>
References: <1306166630-17336-1-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/rndis_filter.c |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index b142aae..5a5bf64 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -372,24 +372,6 @@ int rndis_filter_receive(struct hv_device *dev,
 			pkt->page_buf[0].offset);
 
 	/* Make sure we got a valid rndis message */
-	/*
-	 * FIXME: There seems to be a bug in set completion msg where its
-	 * MessageLength is 16 bytes but the ByteCount field in the xfer page
-	 * range shows 52 bytes
-	 * */
-#if 0
-	if (pkt->total_data_buflen != rndis_hdr->msg_len) {
-		kunmap_atomic(rndis_hdr - pkt->page_buf[0].offset,
-			      KM_IRQ0);
-
-		dev_err(&dev->device, "invalid rndis message? (expected %u "
-			   "bytes got %u)...dropping this message!\n",
-			   rndis_hdr->msg_len,
-			   pkt->total_data_buflen);
-		return -1;
-	}
-#endif
-
 	if ((rndis_hdr->ndis_msg_type != REMOTE_NDIS_PACKET_MSG) &&
 	    (rndis_hdr->msg_len > sizeof(struct rndis_message))) {
 		dev_err(&dev->device, "incoming rndis message buffer overflow "
-- 
1.6.3.2

