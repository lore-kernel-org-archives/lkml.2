Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab1FPUF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:05:57 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:42535
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932340Ab1FPUCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:02:03 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 66/77] Staging: hv: netvsc: Cleanup error return values in netvsc_send()
Date: Thu, 16 Jun 2011 13:17:39 -0700
Message-Id: <1308255470-3826-66-git-send-email-kys@microsoft.com>
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
 drivers/staging/hv/netvsc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 1bca667..e3a2891 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -409,7 +409,7 @@ int netvsc_device_remove(struct hv_device *device)
 	net_device = release_outbound_net_device(device);
 	if (!net_device) {
 		dev_err(&device->device, "No net device present!!");
-		return -1;
+		return -ENODEV;
 	}
 
 	/* Wait for all send completions */
@@ -499,7 +499,7 @@ int netvsc_send(struct hv_device *device,
 	if (!net_device) {
 		dev_err(&device->device, "net device (%p) shutting down..."
 			   "ignoring outbound packets", net_device);
-		return -2;
+		return -ENODEV;
 	}
 
 	sendMessage.hdr.msg_type = NVSP_MSG1_TYPE_SEND_RNDIS_PKT;
-- 
1.7.4.1

