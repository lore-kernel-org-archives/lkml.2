Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760596Ab0G3TQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:16:31 -0400
Received: from kroah.org ([198.145.64.141]:46258 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204Ab0G3RR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:17:59 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:01 2010
Message-Id: <20100730171501.556536249@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:14:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Stuge <peter@stuge.se>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Kristoffer Ericson <kristoffer.ericson@gmail.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [021/165] ath9k: re-enable ps by default for new single chip families
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 14acdde6e527950f66c084dbf19bad6fbfcaeedc upstream.

The newer single chip hardware family of chipsets have not been
experiencing issues with power saving set by default with recent
fixes merged (even into stable). The remaining issues are only
reported with AR5416 and since enabling PS by default can increase
power savings considerably best to take advantage of that feature
as this has been tested properly.

For more details on this issue see the bug report:

http://bugzilla.kernel.org/show_bug.cgi?id=14267

We leave AR5416 with PS disabled by default, that seems to require
some more work.

Cc: Peter Stuge <peter@stuge.se>
Cc: Justin P. Mattock  <justinmattock@gmail.com>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/net/wireless/ath/ath9k/main.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1538,6 +1538,8 @@ bad_no_ah:
 
 void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 {
+	struct ath_hw *ah = sc->sc_ah;
+
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		IEEE80211_HW_SIGNAL_DBM |
@@ -1558,7 +1560,10 @@ void ath_set_hw_capab(struct ath_softc *
 		BIT(NL80211_IFTYPE_ADHOC) |
 		BIT(NL80211_IFTYPE_MESH_POINT);
 
-	hw->wiphy->ps_default = false;
+	if (AR_SREV_5416(ah))
+		hw->wiphy->ps_default = false;
+	else
+		hw->wiphy->ps_default = true;
 
 	hw->queues = 4;
 	hw->max_rates = 4;


