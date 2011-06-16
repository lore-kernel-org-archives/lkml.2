Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab1FPUHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:07:50 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:42543
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932325Ab1FPUCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:02:01 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 68/77] Staging: hv: netvsc: Cleanup error codes in rndis_filter_receive()
Date: Thu, 16 Jun 2011 13:17:41 -0700
Message-Id: <1308255470-3826-68-git-send-email-kys@microsoft.com>
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
 drivers/staging/hv/rndis_filter.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index dbb5201..8e1ef00 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -358,14 +358,14 @@ int rndis_filter_receive(struct hv_device *dev,
 	if (!net_dev->extension) {
 		dev_err(&dev->device, "got rndis message but no rndis device - "
 			  "dropping this message!\n");
-		return -1;
+		return -ENODEV;
 	}
 
 	rndis_dev = (struct rndis_device *)net_dev->extension;
 	if (rndis_dev->state == RNDIS_DEV_UNINITIALIZED) {
 		dev_err(&dev->device, "got rndis message but rndis device "
 			   "uninitialized...dropping this message!\n");
-		return -1;
+		return -ENODEV;
 	}
 
 	rndis_hdr = (struct rndis_message *)kmap_atomic(
-- 
1.7.4.1

