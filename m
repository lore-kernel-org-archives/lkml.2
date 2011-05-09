Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab1EIV6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:58:10 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54253
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754979Ab1EIVot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:49 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 072/206] Staging: hv: Get rid of rndis_filter_cleanup()
Date: Mon,  9 May 2011 14:55:54 -0700
Message-Id: <1304978288-22999-72-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rndis_filter_cleanup() is an empty function; get rid of it.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/rndis_filter.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index 455d440..b0c888e 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -84,8 +84,6 @@ struct rndis_filter_packet {
 };
 
 
-static void rndis_filter_cleanup(struct hv_driver *drv);
-
 static int rndis_filter_send(struct hv_device *dev,
 			     struct hv_netvsc_packet *pkt);
 
@@ -621,7 +619,6 @@ int rndis_filter_init(struct netvsc_driver *drv)
 	/* Override */
 	drv->base.dev_add = rndis_filte_device_add;
 	drv->base.dev_rm = rndis_filter_device_remove;
-	drv->base.cleanup = rndis_filter_cleanup;
 	drv->send = rndis_filter_send;
 	drv->recv_cb = rndis_filter_receive;
 
@@ -818,9 +815,6 @@ int rndis_filter_device_remove(struct hv_device *dev)
 	return 0;
 }
 
-static void rndis_filter_cleanup(struct hv_driver *drv)
-{
-}
 
 int rndis_filter_open(struct hv_device *dev)
 {
-- 
1.7.4.1

