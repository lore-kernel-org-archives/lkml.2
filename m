Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623Ab2CGTAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:00:11 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:40764
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756576Ab2CGTAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:00:07 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, kys@microsoft.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Cc: Olaf Hering <olaf@aepfle.de>
Subject: [PATCH] net/hyperv: Advertise hv_netvsc instead of netvsc as driver name
Date: Wed,  7 Mar 2012 11:05:31 -0800
Message-Id: <1331147131-6660-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olaf Hering <olaf@aepfle.de>

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 0ae7a1a..53d1ee5 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -40,6 +40,8 @@
 
 #include "hyperv_net.h"
 
+#define MODULE_NAME "hv_netvsc"
+
 struct net_device_context {
 	/* point back to our device context */
 	struct hv_device *device_ctx;
@@ -310,7 +312,7 @@ int netvsc_recv_callback(struct hv_device *device_obj,
 static void netvsc_get_drvinfo(struct net_device *net,
 			       struct ethtool_drvinfo *info)
 {
-	strcpy(info->driver, "hv_netvsc");
+	strcpy(info->driver, MODULE_NAME);
 	strcpy(info->version, HV_DRV_VERSION);
 	strcpy(info->fw_version, "N/A");
 }
@@ -482,7 +484,7 @@ MODULE_DEVICE_TABLE(vmbus, id_table);
 
 /* The one and only one */
 static struct  hv_driver netvsc_drv = {
-	.name = "netvsc",
+	.name = MODULE_NAME,
 	.id_table = id_table,
 	.probe = netvsc_probe,
 	.remove = netvsc_remove,
-- 
1.7.4.1

