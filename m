Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab1EIV6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:58:14 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47550
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754977Ab1EIVot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:49 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 071/206] Staging: hv: Make rndis_filter_device_remove() non static
Date: Mon,  9 May 2011 14:55:53 -0700
Message-Id: <1304978288-22999-71-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject line says it all.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/netvsc_api.h   |    1 +
 drivers/staging/hv/rndis_filter.c |    4 +---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/netvsc_api.h b/drivers/staging/hv/netvsc_api.h
index 64625e3..b385c9d 100644
--- a/drivers/staging/hv/netvsc_api.h
+++ b/drivers/staging/hv/netvsc_api.h
@@ -124,6 +124,7 @@ int rndis_filter_open(struct hv_device *dev);
 int rndis_filter_close(struct hv_device *dev);
 int rndis_filte_device_add(struct hv_device *dev,
 			void *additional_info);
+int rndis_filter_device_remove(struct hv_device *dev);
 
 
 #endif /* _NETVSC_API_H_ */
diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index 09118b8..455d440 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -84,8 +84,6 @@ struct rndis_filter_packet {
 };
 
 
-static int rndis_filter_device_remove(struct hv_device *dev);
-
 static void rndis_filter_cleanup(struct hv_driver *drv);
 
 static int rndis_filter_send(struct hv_device *dev,
@@ -803,7 +801,7 @@ int rndis_filte_device_add(struct hv_device *dev,
 	return ret;
 }
 
-static int rndis_filter_device_remove(struct hv_device *dev)
+int rndis_filter_device_remove(struct hv_device *dev)
 {
 	struct netvsc_device *net_dev = dev->ext;
 	struct rndis_device *rndis_dev = net_dev->extension;
-- 
1.7.4.1

