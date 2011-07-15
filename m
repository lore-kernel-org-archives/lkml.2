Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab1GORnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:43:40 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:33296
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754119Ab1GORaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:30:05 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 064/117] Staging: hv: netvsc: Cleanup error return values in netvsc_send()
Date: Fri, 15 Jul 2011 10:46:52 -0700
Message-Id: <1310752065-27895-64-git-send-email-kys@microsoft.com>
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
 drivers/staging/hv/netvsc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 9cc126b..f7f4957 100644
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

