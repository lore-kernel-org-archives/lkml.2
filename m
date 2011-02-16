Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073Ab1BPAtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:49:20 -0500
Received: from kroah.org ([198.145.64.141]:45634 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933040Ab1BPAtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:49:14 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:06 2011
Message-Id: <20110216002106.448146942@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:20:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Easwar Krishnan <easwar.krishnan@atheros.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 073/176] cfg80211: pass the reg hint initiator to helpers
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 7ca43d03b1291481bdf894bbaec5d580e7684e7d upstream.

This is required later.

Cc: Easwar Krishnan <easwar.krishnan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/wireless/reg.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -723,7 +723,9 @@ EXPORT_SYMBOL(freq_reg_info);
  * on the wiphy with the target_bw specified. Then we can simply use
  * that below for the desired_bw_khz below.
  */
-static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
+static void handle_channel(struct wiphy *wiphy,
+			   enum nl80211_reg_initiator initiator,
+			   enum ieee80211_band band,
 			   unsigned int chan_idx)
 {
 	int r;
@@ -787,7 +789,9 @@ static void handle_channel(struct wiphy
 		chan->max_power = (int) MBM_TO_DBM(power_rule->max_eirp);
 }
 
-static void handle_band(struct wiphy *wiphy, enum ieee80211_band band)
+static void handle_band(struct wiphy *wiphy,
+			enum ieee80211_band band,
+			enum nl80211_reg_initiator initiator)
 {
 	unsigned int i;
 	struct ieee80211_supported_band *sband;
@@ -796,7 +800,7 @@ static void handle_band(struct wiphy *wi
 	sband = wiphy->bands[band];
 
 	for (i = 0; i < sband->n_channels; i++)
-		handle_channel(wiphy, band, i);
+		handle_channel(wiphy, initiator, band, i);
 }
 
 static bool ignore_reg_update(struct wiphy *wiphy,
@@ -1033,7 +1037,7 @@ void wiphy_update_regulatory(struct wiph
 		goto out;
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		if (wiphy->bands[band])
-			handle_band(wiphy, band);
+			handle_band(wiphy, band, initiator);
 	}
 out:
 	reg_process_beacons(wiphy);


