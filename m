Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933971Ab1IIMqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 08:46:54 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:23785 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933958Ab1IIMqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 08:46:52 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFPjDQQEWgH
X-RZG-CLASS-ID: mo00
Date: Fri, 9 Sep 2011 14:46:49 +0200
From: Olaf Hering <olaf@aepfle.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: [PATCH] Staging: hv: netvsc: advertise hv_netvsc instead of netvsc
 as driver name
Message-ID: <20110909124649.GB23598@aepfle.de>
References: <20110908162650.GA10699@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110908162650.GA10699@aepfle.de>
User-Agent: Mutt/1.5.21.rev5535 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Olaf Hering <olaf@aepfle.de>

--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -41,6 +41,8 @@
 #include "hyperv.h"
 #include "hyperv_net.h"
 
+#define MODULE_NAME "hv_netvsc"
+
 struct net_device_context {
 	/* point back to our device context */
 	struct hv_device *device_ctx;
@@ -291,7 +293,7 @@ int netvsc_recv_callback(struct hv_devic
 static void netvsc_get_drvinfo(struct net_device *net,
 			       struct ethtool_drvinfo *info)
 {
-	strcpy(info->driver, "hv_netvsc");
+	strcpy(info->driver, MODULE_NAME);
 	strcpy(info->version, HV_DRV_VERSION);
 	strcpy(info->fw_version, "N/A");
 }
@@ -420,7 +422,7 @@ MODULE_DEVICE_TABLE(vmbus, id_table);
 
 /* The one and only one */
 static struct  hv_driver netvsc_drv = {
-	.name = "netvsc",
+	.name = MODULE_NAME,
 	.id_table = id_table,
 	.probe = netvsc_probe,
 	.remove = netvsc_remove,
