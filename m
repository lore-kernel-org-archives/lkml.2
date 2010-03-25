Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab0CYFSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 01:18:38 -0400
Received: from mail.perches.com ([173.55.12.10]:1096 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab0CYFRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 01:17:33 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH 09/13] drivers/staging/rtl8192su: Hoist assign from if
Date: Wed, 24 Mar 2010 22:17:03 -0700
Message-Id: <c45ba099fc8f31f166c4067f2eff609c8eaf422f.1269493047.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
In-Reply-To: <cover.1269493047.git.joe@perches.com>
References: <cover.1269493047.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 .../rtl8192su/ieee80211/ieee80211_softmac.c        |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c
index 9d8cb0e..76e7fb3 100644
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c
@@ -1690,7 +1690,8 @@ ieee80211_rx_auth_rq(struct ieee80211_device *ieee, struct sk_buff *skb)
 	//IEEE80211DMESG("Rx probe");
 	ieee->softmac_stats.rx_auth_rq++;
 
-	if ((status = auth_rq_parse(skb, dest))!= -1){
+	status = auth_rq_parse(skb, dest);
+	if (status!= -1) {
 		ieee80211_resp_to_auth(ieee, status, dest);
 	}
 	//DMESG("Dest is "MACSTR, MAC2STR(dest));
-- 
1.7.0.14.g7e948

