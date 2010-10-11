Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab0JKJ1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 05:27:47 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:45365 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753483Ab0JKJ1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 05:27:45 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linville@tuxdriver.com
Cc: johannes.berg@intel.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 1/1] WIRELESS: at76c50x, remove unneeded NULL check
Date: Mon, 11 Oct 2010 11:27:32 +0200
Message-Id: <1286789252-14031-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found that urb cannot be NULL in at76_rx_tasklet because it is
dereferenced earlier, so remove the unneeded check.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/wireless/at76c50x-usb.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index 91c5f73..1476314 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -1525,8 +1525,7 @@ static void at76_rx_tasklet(unsigned long param)
 
 	if (priv->device_unplugged) {
 		at76_dbg(DBG_DEVSTART, "device unplugged");
-		if (urb)
-			at76_dbg(DBG_DEVSTART, "urb status %d", urb->status);
+		at76_dbg(DBG_DEVSTART, "urb status %d", urb->status);
 		return;
 	}
 
-- 
1.7.3.1


