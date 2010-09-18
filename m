Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab0IRTfc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:35:32 -0400
Received: from kroah.org ([198.145.64.141]:43306 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755970Ab0IRTPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:02 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:00 2010
Message-Id: <20100918191300.106219585@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vivek Natarajan <vnatarajan@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [033/129] ath9k_htc: Fix disconnect issue in HT40 mode.
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vivek Natarajan <vnatarajan@atheros.com>

commit 71ba186c123630ddab17667ec9ecf7e2ef211295 upstream.

Some APs advertise that they may be HT40 capable in the capabilites
but the current operating channel configuration may be only HT20.
This causes disconnection as ath9k_htc sets WLAN_RC_40_FLAG despite
the AP operating in HT20 mode.
Hence set this flag only if the current channel configuration
is HT40 enabled.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -370,7 +370,8 @@ static int ath9k_htc_init_rate(struct at
 		priv->tgt_rate.rates.ht_rates.rs_nrates = j;
 
 		caps = WLAN_RC_HT_FLAG;
-		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
+		if ((sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
+		    (conf_is_ht40(&priv->hw->conf)))
 			caps |= WLAN_RC_40_FLAG;
 		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40)
 			caps |= WLAN_RC_SGI_FLAG;


