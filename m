Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab2HRV0W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 17:26:22 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:61443 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752536Ab2HRV0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 17:26:20 -0400
X-IronPort-AV: E=Sophos;i="4.77,791,1336341600"; 
   d="scan'208";a="170194853"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: kernel-janitors@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] drivers/net/wireless/ipw2x00/ipw2100.c: introduce missing initialization
Date: Sat, 18 Aug 2012 23:25:55 +0200
Message-Id: <1345325159-7365-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The result of one call to a function is tested, and then at the second call
to the same function, the previous result, and not the current result, is
tested again.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression ret;
identifier f;
statement S1,S2;
@@

*ret = f(...);
if (\(ret != 0\|ret < 0\|ret == NULL\)) S1
... when any
*f(...);
if (\(ret != 0\|ret < 0\|ret == NULL\)) S2
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/net/wireless/ipw2x00/ipw2100.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index 8a34202..2f3f6f2 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -2042,7 +2042,8 @@ static void isr_indicate_associated(struct ipw2100_priv *priv, u32 status)
 		return;
 	}
 	len = ETH_ALEN;
-	ipw2100_get_ordinal(priv, IPW_ORD_STAT_ASSN_AP_BSSID, &bssid, &len);
+	ret = ipw2100_get_ordinal(priv, IPW_ORD_STAT_ASSN_AP_BSSID, &bssid,
+				  &len);
 	if (ret) {
 		IPW_DEBUG_INFO("failed querying ordinals at line %d\n",
 			       __LINE__);

