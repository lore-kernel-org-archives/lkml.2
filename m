Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab1EWQNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 12:13:19 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:45647
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756296Ab1EWQNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 12:13:16 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 5/6] staging: hv: fix typo in name rndis_filte_device_add()
Date: Mon, 23 May 2011 09:03:49 -0700
Message-Id: <1306166630-17336-5-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1306166630-17336-1-git-send-email-haiyangz@microsoft.com>
References: <1306166630-17336-1-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rename rndis_filte_device_add to rndis_filter_device_add

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/hyperv_net.h   |    2 +-
 drivers/staging/hv/netvsc_drv.c   |    2 +-
 drivers/staging/hv/rndis_filter.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/hyperv_net.h b/drivers/staging/hv/hyperv_net.h
index 6226dd3..cf762bd 100644
--- a/drivers/staging/hv/hyperv_net.h
+++ b/drivers/staging/hv/hyperv_net.h
@@ -99,7 +99,7 @@ int netvsc_recv_callback(struct hv_device *device_obj,
 int netvsc_initialize(struct hv_driver *drv);
 int rndis_filter_open(struct hv_device *dev);
 int rndis_filter_close(struct hv_device *dev);
-int rndis_filte_device_add(struct hv_device *dev,
+int rndis_filter_device_add(struct hv_device *dev,
 			void *additional_info);
 void rndis_filter_device_remove(struct hv_device *dev);
 int rndis_filter_receive(struct hv_device *dev,
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 6a2f17d..f510959 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -352,7 +352,7 @@ static int netvsc_probe(struct hv_device *dev)
 
 	/* Notify the netvsc driver of the new device */
 	device_info.ring_size = ring_size;
-	ret = rndis_filte_device_add(dev, &device_info);
+	ret = rndis_filter_device_add(dev, &device_info);
 	if (ret != 0) {
 		free_netdev(net);
 		dev_set_drvdata(&dev->device, NULL);
diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index 572cec6..b142aae 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -681,7 +681,7 @@ static int rndis_filter_close_device(struct rndis_device *dev)
 	return ret;
 }
 
-int rndis_filte_device_add(struct hv_device *dev,
+int rndis_filter_device_add(struct hv_device *dev,
 				  void *additional_info)
 {
 	int ret;
-- 
1.6.3.2

