Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab2AXUS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 15:18:29 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:36661
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756481Ab2AXUS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 15:18:28 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, kys@microsoft.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: [PATCH] net/hyperv: fix possible memory leak in do_set_multicast()
Date: Tue, 24 Jan 2012 12:21:28 -0800
Message-Id: <1327436488-24114-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

do_set_multicast() may not free the memory malloc in
netvsc_set_multicast_list().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

---
 drivers/net/hyperv/netvsc_drv.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 462d05f..1a1ca6c 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -68,11 +68,11 @@ static void do_set_multicast(struct work_struct *w)
 
 	nvdev = hv_get_drvdata(ndevctx->device_ctx);
 	if (nvdev == NULL)
-		return;
+		goto out;
 
 	rdev = nvdev->extension;
 	if (rdev == NULL)
-		return;
+		goto out;
 
 	if (net->flags & IFF_PROMISC)
 		rndis_filter_set_packet_filter(rdev,
@@ -83,6 +83,7 @@ static void do_set_multicast(struct work_struct *w)
 			NDIS_PACKET_TYPE_ALL_MULTICAST |
 			NDIS_PACKET_TYPE_DIRECTED);
 
+out:
 	kfree(w);
 }
 
-- 
1.7.4.1

