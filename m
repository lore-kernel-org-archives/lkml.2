Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab2GASU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:20:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47041 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756025Ab2GASQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:44 -0400
Message-Id: <20120701172010.504553814@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:33 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 27/48] ath9k: fix a tx rate duration calculation bug
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 76591bea9714a58d8924154068c78d702eb2cb17 upstream.

The rate pointer variable for a rate series is used in a loop before it is
initialized. This went unnoticed because it was used earlier for the RTS/CTS
rate. This bug can lead to the wrong PHY type being passed to the
duration calculation function.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index d59dd01..efb7f00 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1001,13 +1001,13 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf,
 		}
 
 		/* legacy rates */
+		rate = &sc->sbands[tx_info->band].bitrates[rates[i].idx];
 		if ((tx_info->band == IEEE80211_BAND_2GHZ) &&
 		    !(rate->flags & IEEE80211_RATE_ERP_G))
 			phy = WLAN_RC_PHY_CCK;
 		else
 			phy = WLAN_RC_PHY_OFDM;
 
-		rate = &sc->sbands[tx_info->band].bitrates[rates[i].idx];
 		info->rates[i].Rate = rate->hw_value;
 		if (rate->hw_value_short) {
 			if (rates[i].flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)


