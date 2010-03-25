Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab0CYFSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 01:18:42 -0400
Received: from mail.perches.com ([173.55.12.10]:1096 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608Ab0CYFRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 01:17:32 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH 08/13] drivers/staging/rtl8192e: Hoist assign from if
Date: Wed, 24 Mar 2010 22:17:02 -0700
Message-Id: <424b1a80990a872003a7758ef066bbc956eb849e.1269493047.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
In-Reply-To: <cover.1269493047.git.joe@perches.com>
References: <cover.1269493047.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 .../staging/rtl8192e/ieee80211/ieee80211_softmac.c |    3 ++-
 drivers/staging/rtl8192e/r8192E_core.c             |    6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
index ea96c49..f6dfa99 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
@@ -1933,7 +1933,8 @@ ieee80211_rx_auth_rq(struct ieee80211_device *ieee, struct sk_buff *skb)
 	//IEEE80211DMESG("Rx probe");
 	ieee->softmac_stats.rx_auth_rq++;
 
-	if ((status = auth_rq_parse(skb, dest))!= -1){
+	status = auth_rq_parse(skb, dest);
+	if (status!= -1) {
 		ieee80211_resp_to_auth(ieee, status, dest);
 	}
 	//DMESG("Dest is "MACSTR, MAC2STR(dest));
diff --git a/drivers/staging/rtl8192e/r8192E_core.c b/drivers/staging/rtl8192e/r8192E_core.c
index 886105d..1f37978 100644
--- a/drivers/staging/rtl8192e/r8192E_core.c
+++ b/drivers/staging/rtl8192e/r8192E_core.c
@@ -1863,13 +1863,15 @@ static short rtl8192_pci_initdescring(struct net_device *dev)
 
     /* general process for other queue */
     for (i = 0; i < MAX_TX_QUEUE_COUNT; i++) {
-        if ((ret = rtl8192_alloc_tx_desc_ring(dev, i, priv->txringcount)))
+        ret = rtl8192_alloc_tx_desc_ring(dev, i, priv->txringcount);
+        if (ret)
             goto err_free_rings;
     }
 
 #if 0
     /* specific process for hardware beacon process */
-    if ((ret = rtl8192_alloc_tx_desc_ring(dev, MAX_TX_QUEUE_COUNT - 1, 2)))
+    ret = rtl8192_alloc_tx_desc_ring(dev, MAX_TX_QUEUE_COUNT - 1, 2);
+    if (ret)
         goto err_free_rings;
 #endif
 
-- 
1.7.0.14.g7e948

