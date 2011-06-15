Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab1FPHAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:00:37 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:42066 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755318Ab1FPHAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:32 -0400
X-Sasl-enc: YaiK4bepspnrR07znXBq+xR361sFUDehoy8A9pA9IoHs 1308207632
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:31 2011
Message-Id: <20110616000231.145802733@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [22/89] iwl4965: fix 5GHz operation
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit aac11c1b351413aa3412e258e2b2dcba31777209 upstream.

rx_status.band is used uninitialized, what disallow to work on 5GHz .

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlegacy/iwl-4965-lib.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
@@ -628,11 +628,11 @@ void iwl4965_rx_reply_rx(struct iwl_priv
 
 	/* rx_status carries information about the packet to mac80211 */
 	rx_status.mactime = le64_to_cpu(phy_res->timestamp);
+	rx_status.band = (phy_res->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
+				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
 	rx_status.freq =
 		ieee80211_channel_to_frequency(le16_to_cpu(phy_res->channel),
 							rx_status.band);
-	rx_status.band = (phy_res->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
-				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
 	rx_status.rate_idx =
 		iwl4965_hwrate_to_mac80211_idx(rate_n_flags, rx_status.band);
 	rx_status.flag = 0;


