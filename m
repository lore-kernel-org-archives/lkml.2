Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab1GORb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:31:56 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:37414
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754280Ab1GORaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:30:12 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 116/117] Staging: hv: vmbus: Add code to display modalias attribute
Date: Fri, 15 Jul 2011 10:47:44 -0700
Message-Id: <1310752065-27895-116-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add code to display modalias attribute.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index f271e8d..433be51 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -113,6 +113,14 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
 	if (!strcmp(dev_attr->attr.name, "class_id")) {
 		return sprintf(buf, "%s\n",
 				hv_get_devtype_name(&device_info.chn_type));
+	} else if (!strcmp(dev_attr->attr.name, "modalias")) {
+		int i;
+		char alias_name[((sizeof(struct hv_vmbus_device_id) + 1)) * 2];
+
+		for (i = 0; i < (sizeof(struct hv_vmbus_device_id) * 2); i += 2)
+			sprintf(&alias_name[i], "%02x",
+				hv_dev->dev_type.b[i/2]);
+		return sprintf("vmbus:%s\n", alias_name);
 	} else if (!strcmp(dev_attr->attr.name, "state")) {
 		return sprintf(buf, "%d\n", device_info.chn_state);
 	} else if (!strcmp(dev_attr->attr.name, "id")) {
@@ -167,6 +175,7 @@ static struct device_attribute vmbus_device_attrs[] = {
 	__ATTR(id, S_IRUGO, vmbus_show_device_attr, NULL),
 	__ATTR(state, S_IRUGO, vmbus_show_device_attr, NULL),
 	__ATTR(class_id, S_IRUGO, vmbus_show_device_attr, NULL),
+	__ATTR(modalias, S_IRUGO, vmbus_show_device_attr, NULL),
 	__ATTR(monitor_id, S_IRUGO, vmbus_show_device_attr, NULL),
 
 	__ATTR(server_monitor_pending, S_IRUGO, vmbus_show_device_attr, NULL),
-- 
1.7.4.1

