Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306Ab1EMV1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 17:27:31 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:53525 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759107Ab1EMV11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 17:27:27 -0400
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>
Subject: [RFC/PATCH 03/13] net: wl12xx: remove some unnecessary prints
Date: Sat, 14 May 2011 00:26:20 +0300
Message-Id: <1305321990-22041-4-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.4.1.343.ga91df
In-Reply-To: <1305321990-22041-1-git-send-email-balbi@ti.com>
References: <1305321990-22041-1-git-send-email-balbi@ti.com>
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those have little value. Remove those to make
the driver less noisy.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/net/wireless/wl12xx/sdio.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index fe775d3..0832b80 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -287,8 +287,6 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	/* Tell PM core that we don't need the card to be powered now */
 	pm_runtime_put_noidle(&func->dev);
 
-	wl1271_notice("initialized");
-
 	return 0;
 
 err3:
@@ -347,23 +345,12 @@ static struct sdio_driver wl1271_sdio_driver = {
 
 static int __init wl1271_init(void)
 {
-	int ret;
-
-	ret = sdio_register_driver(&wl1271_sdio_driver);
-	if (ret < 0) {
-		wl1271_error("failed to register sdio driver: %d", ret);
-		goto out;
-	}
-
-out:
-	return ret;
+	return sdio_register_driver(&wl1271_sdio_driver);
 }
 
 static void __exit wl1271_exit(void)
 {
 	sdio_unregister_driver(&wl1271_sdio_driver);
-
-	wl1271_notice("unloaded");
 }
 
 module_init(wl1271_init);
-- 
1.7.4.1.343.ga91df

