Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161726Ab2GLWjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:39:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54985 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161712Ab2GLWjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:39:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 062/187] ath9k: fix a tx rate duration calculation bug
Date: Thu, 12 Jul 2012 15:33:38 -0700
Message-Id: <20120712191528.148941874@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 76591bea9714a58d8924154068c78d702eb2cb17 upstream.

The rate pointer variable for a rate series is used in a loop before it is
initialized. This went unnoticed because it was used earlier for the RTS/CTS
rate. This bug can lead to the wrong PHY type being passed to the
duration calculation function.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1001,13 +1001,13 @@ static void ath_buf_set_rate(struct ath_
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


