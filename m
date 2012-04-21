Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab2DUWsQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 18:48:16 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42556 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab2DUWsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 18:48:14 -0400
From: Eldad Zack <eldad@fogrefinery.com>
To: Brett Rudley <brudley@broadcom.com>, Roland Vossen <rvossen@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>, Kan Yan <kanyan@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eldad Zack <eldad@fogrefinery.com>
Subject: [PATCH] [brcmsmac] "INTERMEDIATE but not AMPDU" only when tracing
Date: Sun, 22 Apr 2012 00:48:04 +0200
Message-Id: <1335048484-5925-1-git-send-email-eldad@fogrefinery.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I keep getting the following messages on the log buffer:
[ 2167.097507] ieee80211 phy0: brcms_c_dotxstatus: INTERMEDIATE but not AMPDU
[ 2281.331305] ieee80211 phy0: brcms_c_dotxstatus: INTERMEDIATE but not AMPDU
[ 2281.332539] ieee80211 phy0: brcms_c_dotxstatus: INTERMEDIATE but not AMPDU
[ 2329.876605] ieee80211 phy0: brcms_c_dotxstatus: INTERMEDIATE but not AMPDU
[ 2329.877354] ieee80211 phy0: brcms_c_dotxstatus: INTERMEDIATE but not AMPDU
[ 2462.280756] ieee80211 phy0: brcms_c_dotxstatus: INTERMEDIATE but not AMPDU
[ 2615.651689] ieee80211 phy0: brcms_c_dotxstatus: INTERMEDIATE but not AMPDU

>From the code comment I understand that this something that can - and does, quite frequently - happen.
This patch demotes the message to the trace level.

Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 231ddf4..2fc5956 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -847,8 +847,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 	 */
 	if (!(txs->status & TX_STATUS_AMPDU)
 	    && (txs->status & TX_STATUS_INTERMEDIATE)) {
-		wiphy_err(wlc->wiphy, "%s: INTERMEDIATE but not AMPDU\n",
-			  __func__);
+		BCMMSG(wlc->wiphy, "INTERMEDIATE but not AMPDU\n");
 		return false;
 	}
 
-- 
1.7.9.5

