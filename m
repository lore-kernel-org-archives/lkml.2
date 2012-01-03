Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab2ACWfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:35:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39432 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755087Ab2ACWfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:35:43 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:33 2012
Message-Id: <20120103223033.713007680@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:29:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Paul Stewart <pstew@google.com>,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [28/67] ath9k: fix max phy rate at rate control init
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

commit 10636bc2d60942254bda149827b922c41f4cb4af upstream.

The stations always chooses 1Mbps for all trasmitting frames,
whenever the AP is configured to lock the supported rates.
As the max phy rate is always set with the 4th from highest phy rate,
this assumption might be wrong if we have less than that. Fix that.

Cc: Paul Stewart <pstew@google.com>
Reported-by: Ajay Gummalla <agummalla@google.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/rc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1252,7 +1252,9 @@ static void ath_rc_init(struct ath_softc
 
 	ath_rc_priv->max_valid_rate = k;
 	ath_rc_sort_validrates(rate_table, ath_rc_priv);
-	ath_rc_priv->rate_max_phy = ath_rc_priv->valid_rate_index[k-4];
+	ath_rc_priv->rate_max_phy = (k > 4) ?
+					ath_rc_priv->valid_rate_index[k-4] :
+					ath_rc_priv->valid_rate_index[k-1];
 	ath_rc_priv->rate_table = rate_table;
 
 	ath_dbg(common, ATH_DBG_CONFIG,


