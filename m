Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab2HMR4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 13:56:07 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:53418
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750861Ab2HMR4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 13:56:05 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com, ben@decadent.org.uk
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 01/18] Drivers: hv: vmbus: Use the standard format string to format GUIDs
Date: Mon, 13 Aug 2012 10:06:50 -0700
Message-Id: <1344877627-21779-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1344877584-21738-1-git-send-email-kys@microsoft.com>
References: <1344877584-21738-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Format GUIDS as per MSFT standard. This makes interacting with MSFT
tool stack easier.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Olaf Hering <olaf@aepfle.de>
Reviewed-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hv/vmbus_drv.c |   38 ++------------------------------------
 1 files changed, 2 insertions(+), 36 deletions(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 4748086..b76e8b3 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -146,43 +146,9 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
 	get_channel_info(hv_dev, device_info);
 
 	if (!strcmp(dev_attr->attr.name, "class_id")) {
-		ret = sprintf(buf, "{%02x%02x%02x%02x-%02x%02x-%02x%02x-"
-			       "%02x%02x%02x%02x%02x%02x%02x%02x}\n",
-			       device_info->chn_type.b[3],
-			       device_info->chn_type.b[2],
-			       device_info->chn_type.b[1],
-			       device_info->chn_type.b[0],
-			       device_info->chn_type.b[5],
-			       device_info->chn_type.b[4],
-			       device_info->chn_type.b[7],
-			       device_info->chn_type.b[6],
-			       device_info->chn_type.b[8],
-			       device_info->chn_type.b[9],
-			       device_info->chn_type.b[10],
-			       device_info->chn_type.b[11],
-			       device_info->chn_type.b[12],
-			       device_info->chn_type.b[13],
-			       device_info->chn_type.b[14],
-			       device_info->chn_type.b[15]);
+		ret = sprintf(buf, "{%pUl}\n", device_info->chn_type.b);
 	} else if (!strcmp(dev_attr->attr.name, "device_id")) {
-		ret = sprintf(buf, "{%02x%02x%02x%02x-%02x%02x-%02x%02x-"
-			       "%02x%02x%02x%02x%02x%02x%02x%02x}\n",
-			       device_info->chn_instance.b[3],
-			       device_info->chn_instance.b[2],
-			       device_info->chn_instance.b[1],
-			       device_info->chn_instance.b[0],
-			       device_info->chn_instance.b[5],
-			       device_info->chn_instance.b[4],
-			       device_info->chn_instance.b[7],
-			       device_info->chn_instance.b[6],
-			       device_info->chn_instance.b[8],
-			       device_info->chn_instance.b[9],
-			       device_info->chn_instance.b[10],
-			       device_info->chn_instance.b[11],
-			       device_info->chn_instance.b[12],
-			       device_info->chn_instance.b[13],
-			       device_info->chn_instance.b[14],
-			       device_info->chn_instance.b[15]);
+		ret = sprintf(buf, "{%pUl}\n", device_info->chn_instance.b);
 	} else if (!strcmp(dev_attr->attr.name, "modalias")) {
 		print_alias_name(hv_dev, alias_name);
 		ret = sprintf(buf, "vmbus:%s\n", alias_name);
-- 
1.7.4.1

