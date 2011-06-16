Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827Ab1FPUNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:13:43 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:42437
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758698Ab1FPUB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:01:59 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 36/77] Staging: hv: vmbus: Cleanup the code displaying class_id
Date: Thu, 16 Jun 2011 13:17:09 -0700
Message-Id: <1308255470-3826-36-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308255470-3826-1-git-send-email-kys@microsoft.com>
References: <1308255393-3785-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have a human readable device_type, use that and get rid of the
guid based device type.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   19 +------------------
 1 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 0e1a13c..6ec6ef3 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -113,24 +113,7 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
 	get_channel_info(hv_dev, &device_info);
 
 	if (!strcmp(dev_attr->attr.name, "class_id")) {
-		return sprintf(buf, "{%02x%02x%02x%02x-%02x%02x-%02x%02x-"
-			       "%02x%02x%02x%02x%02x%02x%02x%02x}\n",
-			       device_info.chn_type.data[3],
-			       device_info.chn_type.data[2],
-			       device_info.chn_type.data[1],
-			       device_info.chn_type.data[0],
-			       device_info.chn_type.data[5],
-			       device_info.chn_type.data[4],
-			       device_info.chn_type.data[7],
-			       device_info.chn_type.data[6],
-			       device_info.chn_type.data[8],
-			       device_info.chn_type.data[9],
-			       device_info.chn_type.data[10],
-			       device_info.chn_type.data[11],
-			       device_info.chn_type.data[12],
-			       device_info.chn_type.data[13],
-			       device_info.chn_type.data[14],
-			       device_info.chn_type.data[15]);
+		return sprintf(buf, "%s\n", hv_dev->device_type);
 	} else if (!strcmp(dev_attr->attr.name, "device_id")) {
 		return sprintf(buf, "{%02x%02x%02x%02x-%02x%02x-%02x%02x-"
 			       "%02x%02x%02x%02x%02x%02x%02x%02x}\n",
-- 
1.7.4.1

