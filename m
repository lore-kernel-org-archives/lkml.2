Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521Ab1I1Wnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:43:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54204 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932469Ab1I1Wn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:43:28 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:37 2011
Message-Id: <20110928220137.759518202@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        George <george0505@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [118/244] rtlwifi: rtl8192su: Fix problem connecting to HT-enabled AP
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: George <george0505@realtek.com>

commit 3401dc6eba788ebc7c14ce51018d775b1c263399 upstream.

The driver fails to connect to 802.11n-enabled APs. The patch fixes
Bug #42262.

Signed-off-by: George <george0505@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -549,15 +549,16 @@ void rtl92cu_tx_fill_desc(struct ieee802
 			       (tcb_desc->rts_use_shortpreamble ? 1 : 0)
 			       : (tcb_desc->rts_use_shortgi ? 1 : 0)));
 	if (mac->bw_40) {
-		if (tcb_desc->packet_bw) {
+		if (rate_flag & IEEE80211_TX_RC_DUP_DATA) {
 			SET_TX_DESC_DATA_BW(txdesc, 1);
 			SET_TX_DESC_DATA_SC(txdesc, 3);
+		} else if(rate_flag & IEEE80211_TX_RC_40_MHZ_WIDTH){
+			SET_TX_DESC_DATA_BW(txdesc, 1);
+			SET_TX_DESC_DATA_SC(txdesc, mac->cur_40_prime_sc);
 		} else {
 			SET_TX_DESC_DATA_BW(txdesc, 0);
-				if (rate_flag & IEEE80211_TX_RC_DUP_DATA)
-					SET_TX_DESC_DATA_SC(txdesc,
-							  mac->cur_40_prime_sc);
-			}
+			SET_TX_DESC_DATA_SC(txdesc, 0);
+		}
 	} else {
 		SET_TX_DESC_DATA_BW(txdesc, 0);
 		SET_TX_DESC_DATA_SC(txdesc, 0);


