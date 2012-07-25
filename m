Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab2GYRxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:53:42 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:37703
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751345Ab2GYRxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:53:40 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [PATCH net-next,1/2] hyperv: Add a check for ring_size value
Date: Wed, 25 Jul 2012 11:08:41 -0700
Message-Id: <1343239722-21328-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It prevents ring_size being set to a too small value.

Reported-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 8e23c08..8c5a1c4 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -47,7 +47,7 @@ struct net_device_context {
 	struct work_struct work;
 };
 
-
+#define RING_SIZE_MIN 64
 static int ring_size = 128;
 module_param(ring_size, int, S_IRUGO);
 MODULE_PARM_DESC(ring_size, "Ring buffer size (# of pages)");
@@ -518,6 +518,11 @@ static void __exit netvsc_drv_exit(void)
 
 static int __init netvsc_drv_init(void)
 {
+	if (ring_size < RING_SIZE_MIN) {
+		ring_size = RING_SIZE_MIN;
+		pr_info("Increased ring_size to %d (min allowed)\n",
+			ring_size);
+	}
 	return vmbus_driver_register(&netvsc_drv);
 }
 
-- 
1.7.4.1

