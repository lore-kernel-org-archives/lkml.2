Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab1GORaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:30:08 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:37205
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754026Ab1GOR37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:29:59 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 032/117] Staging: hv: netvsc: Get rid of the empty function netvsc_initialize()
Date: Fri, 15 Jul 2011 10:46:20 -0700
Message-Id: <1310752065-27895-32-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, get rid of the empty function netvsc_initialize().

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hyperv_net.h |    1 -
 drivers/staging/hv/netvsc.c     |    9 ---------
 drivers/staging/hv/netvsc_drv.c |    3 ---
 3 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/hv/hyperv_net.h b/drivers/staging/hv/hyperv_net.h
index 27f987b..5782fea 100644
--- a/drivers/staging/hv/hyperv_net.h
+++ b/drivers/staging/hv/hyperv_net.h
@@ -96,7 +96,6 @@ void netvsc_linkstatus_callback(struct hv_device *device_obj,
 				unsigned int status);
 int netvsc_recv_callback(struct hv_device *device_obj,
 			struct hv_netvsc_packet *packet);
-int netvsc_initialize(struct hv_driver *drv);
 int rndis_filter_open(struct hv_device *dev);
 int rndis_filter_close(struct hv_device *dev);
 int rndis_filter_device_add(struct hv_device *dev,
diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index d085018..cb02eed 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -989,12 +989,3 @@ cleanup:
 
 	return ret;
 }
-
-/*
- * netvsc_initialize - Main entry point
- */
-int netvsc_initialize(struct hv_driver *drv)
-{
-
-	return 0;
-}
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index dd66073..11c03ae 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -451,9 +451,6 @@ static int __init netvsc_drv_init(void)
 
 	pr_info("initializing....");
 
-	/* Callback to client driver to complete the initialization */
-	netvsc_initialize(drv);
-
 	drv->driver.name = driver_name;
 
 	/* The driver belongs to vmbus */
-- 
1.7.4.1

