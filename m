Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717Ab2DVMCV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 08:02:21 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59313 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab2DVMCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 08:02:20 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/staging/rtl8192u/ieee80211/ieee80211_module.c: add missing free_netdev
Date: Sun, 22 Apr 2012 14:02:13 +0200
Message-Id: <1335096133-16951-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Free dev on failure as done elsewhere in the function.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/staging/rtl8192u/ieee80211/ieee80211_module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
index e3d47bc..82d4bf6 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
@@ -161,7 +161,7 @@ struct net_device *alloc_ieee80211(int sizeof_priv)
 	if (ieee->pHTInfo == NULL)
 	{
 		IEEE80211_DEBUG(IEEE80211_DL_ERR, "can't alloc memory for HTInfo\n");
-		return NULL;
+		goto failed;
 	}
 	HTUpdateDefaultSetting(ieee);
 	HTInitializeHTInfo(ieee); //may move to other place.

