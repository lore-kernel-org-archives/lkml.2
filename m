Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab1GORt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:49:29 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:33234
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754041Ab1GOR37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:29:59 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 036/117] Staging: hv: vmbus: Make class_id attribute a human readable string
Date: Fri, 15 Jul 2011 10:46:24 -0700
Message-Id: <1310752065-27895-36-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have a human readable device_type, use that and get rid of the
guid based device type.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   20 ++------------------
 1 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 9a0df2c..67415ab 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -113,24 +113,8 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
 	get_channel_info(hv_dev, &device_info);
 
 	if (!strcmp(dev_attr->attr.name, "class_id")) {
-		return sprintf(buf, "{%02x%02x%02x%02x-%02x%02x-%02x%02x-"
-			       "%02x%02x%02x%02x%02x%02x%02x%02x}\n",
-			       device_info.chn_type.b[3],
-			       device_info.chn_type.b[2],
-			       device_info.chn_type.b[1],
-			       device_info.chn_type.b[0],
-			       device_info.chn_type.b[5],
-			       device_info.chn_type.b[4],
-			       device_info.chn_type.b[7],
-			       device_info.chn_type.b[6],
-			       device_info.chn_type.b[8],
-			       device_info.chn_type.b[9],
-			       device_info.chn_type.b[10],
-			       device_info.chn_type.b[11],
-			       device_info.chn_type.b[12],
-			       device_info.chn_type.b[13],
-			       device_info.chn_type.b[14],
-			       device_info.chn_type.b[15]);
+		return sprintf(buf, "%s\n",
+				hv_get_devtype_name(&device_info.chn_type));
 	} else if (!strcmp(dev_attr->attr.name, "device_id")) {
 		return sprintf(buf, "{%02x%02x%02x%02x-%02x%02x-%02x%02x-"
 			       "%02x%02x%02x%02x%02x%02x%02x%02x}\n",
-- 
1.7.4.1

