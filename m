Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab1GORoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:44:18 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:33289
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754117Ab1GORaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:30:04 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 063/117] Staging: hv: netvsc: Cleanup error returns in netvsc_connect_vsp()
Date: Fri, 15 Jul 2011 10:46:51 -0700
Message-Id: <1310752065-27895-63-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use standard Linux error codes.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/netvsc.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 5703fd7..9cc126b 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -323,7 +323,7 @@ static int netvsc_connect_vsp(struct hv_device *device)
 	if (!net_device) {
 		dev_err(&device->device, "unable to get net device..."
 			   "device being destroyed?");
-		return -1;
+		return -ENODEV;
 	}
 
 	init_packet = &net_device->channel_init_pkt;
@@ -354,13 +354,13 @@ static int netvsc_connect_vsp(struct hv_device *device)
 
 	if (init_packet->msg.init_msg.init_complete.status !=
 	    NVSP_STAT_SUCCESS) {
-		ret = -1;
+		ret = -EINVAL;
 		goto cleanup;
 	}
 
 	if (init_packet->msg.init_msg.init_complete.
 	    negotiated_protocol_ver != NVSP_PROTOCOL_VERSION_1) {
-		ret = -1;
+		ret = -EPROTO;
 		goto cleanup;
 	}
 	/* Send the ndis version */
@@ -381,10 +381,8 @@ static int netvsc_connect_vsp(struct hv_device *device)
 				sizeof(struct nvsp_message),
 				(unsigned long)init_packet,
 				VM_PKT_DATA_INBAND, 0);
-	if (ret != 0) {
-		ret = -1;
+	if (ret != 0)
 		goto cleanup;
-	}
 
 	/* Post the big receive buffer to NetVSP */
 	ret = netvsc_init_recv_buf(device);
-- 
1.7.4.1

