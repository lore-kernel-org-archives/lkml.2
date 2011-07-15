Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab1GOSEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 14:04:55 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:59696
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753211Ab1GOSDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 14:03:14 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 018/117] Staging: hv: vmbus: Cleanup vmbus_match()
Date: Fri, 15 Jul 2011 10:46:06 -0700
Message-Id: <1310752065-27895-18-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we are using the already defined type for guids, cleanup
vmbus_match().

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 291b4e0..330cc43 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -302,8 +302,7 @@ static int vmbus_match(struct device *device, struct device_driver *driver)
 	struct hv_device *hv_dev = device_to_hv_device(device);
 
 	/* We found our driver ? */
-	if (memcmp(&hv_dev->dev_type, &drv->dev_type,
-		   sizeof(uuid_le)) == 0)
+	if (!uuid_le_cmp(hv_dev->dev_type, drv->dev_type))
 		match = 1;
 
 	return match;
-- 
1.7.4.1

