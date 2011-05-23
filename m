Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab1EWPuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 11:50:40 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:41264
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754837Ab1EWPuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 11:50:39 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 1/6] staging: hv: remove unnecessary code in netvsc_probe().
Date: Mon, 23 May 2011 09:03:45 -0700
Message-Id: <1306166630-17336-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

netif_carrier_off() was called earlier in this function, and there is
no other thread access this device yet. The status checking code is not
necessary here.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/netvsc_drv.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 7b9c229..456d3df 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -364,17 +364,7 @@ static int netvsc_probe(struct hv_device *dev)
 		return ret;
 	}
 
-	/*
-	 * If carrier is still off ie we did not get a link status callback,
-	 * update it if necessary
-	 */
-	/*
-	 * FIXME: We should use a atomic or test/set instead to avoid getting
-	 * out of sync with the device's link status
-	 */
-	if (!netif_carrier_ok(net))
-		if (!device_info.link_state)
-			netif_carrier_on(net);
+	netif_carrier_on(net);
 
 	memcpy(net->dev_addr, device_info.mac_adr, ETH_ALEN);
 
-- 
1.6.3.2

