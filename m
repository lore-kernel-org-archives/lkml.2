Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab1EMV1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 17:27:07 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:44400 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757986Ab1EMV1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 17:27:05 -0400
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>
Subject: [RFC/PATCH 04/13] net: wl12xx: care for optional operations
Date: Sat, 14 May 2011 00:26:21 +0300
Message-Id: <1305321990-22041-5-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.4.1.343.ga91df
In-Reply-To: <1305321990-22041-1-git-send-email-balbi@ti.com>
References: <1305321990-22041-1-git-send-email-balbi@ti.com>
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

->init and ->reset are optional - at least
sdio.c doesn't implement them - so allow those
pointers to be NULL.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/net/wireless/wl12xx/io.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/io.c b/drivers/net/wireless/wl12xx/io.c
index d557f73..57bc646 100644
--- a/drivers/net/wireless/wl12xx/io.c
+++ b/drivers/net/wireless/wl12xx/io.c
@@ -117,12 +117,14 @@ EXPORT_SYMBOL_GPL(wl1271_set_partition);
 
 void wl1271_io_reset(struct wl1271 *wl)
 {
-	wl->if_ops->reset(wl);
+	if (wl->if_ops->reset)
+		wl->if_ops->reset(wl);
 }
 
 void wl1271_io_init(struct wl1271 *wl)
 {
-	wl->if_ops->init(wl);
+	if (wl->if_ops->init)
+		wl->if_ops->init(wl);
 }
 
 void wl1271_top_reg_write(struct wl1271 *wl, int addr, u16 val)
-- 
1.7.4.1.343.ga91df

