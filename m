Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649Ab1FPUHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:07:55 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:52274
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932322Ab1FPUCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:02:01 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 64/77] Staging: hv: netvsc: Cleanup error return values in netvsc_init_recv_buf()
Date: Thu, 16 Jun 2011 13:17:37 -0700
Message-Id: <1308255470-3826-64-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308255470-3826-1-git-send-email-kys@microsoft.com>
References: <1308255393-3785-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use standard Linux error codes.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/netvsc.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 14c2203..b640e08 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -207,7 +207,7 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 	if (!net_device) {
 		dev_err(&device->device, "unable to get net device..."
 			   "device being destroyed?");
-		return -1;
+		return -ENODEV;
 	}
 
 	net_device->recv_buf =
@@ -216,7 +216,7 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 	if (!net_device->recv_buf) {
 		dev_err(&device->device, "unable to allocate receive "
 			"buffer of size %d", net_device->recv_buf_size);
-		ret = -1;
+		ret = -ENOMEM;
 		goto cleanup;
 	}
 
@@ -269,7 +269,7 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 			   "initialzation with NetVsp - status %d",
 			   init_packet->msg.v1_msg.
 			   send_recv_buf_complete.status);
-		ret = -1;
+		ret = -EINVAL;
 		goto cleanup;
 	}
 
@@ -281,7 +281,7 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 	net_device->recv_section = kmalloc(net_device->recv_section_cnt
 		* sizeof(struct nvsp_1_receive_buffer_section), GFP_KERNEL);
 	if (net_device->recv_section == NULL) {
-		ret = -1;
+		ret = -EINVAL;
 		goto cleanup;
 	}
 
@@ -297,7 +297,7 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 	 */
 	if (net_device->recv_section_cnt != 1 ||
 	    net_device->recv_section->offset != 0) {
-		ret = -1;
+		ret = -EINVAL;
 		goto cleanup;
 	}
 
-- 
1.7.4.1

