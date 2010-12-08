Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab0LHA7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:59:34 -0500
Received: from kroah.org ([198.145.64.141]:48505 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756873Ab0LHA7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:30 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:24 2010
Message-Id: <20101208005724.860476642@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:56:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rajkumar Manoharan <rmanoharan@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [035/289] ath9k_htc: Avoid setting QoS control for non-QoS frames
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rajkumar Manoharan <rmanoharan@atheros.com>

commit 3bf30b56c4f0a1c4fae34050b7db4527c92891e8 upstream.

Setting tid information in the TX header is required only for QoS
frames. Not handling this case causes severe data loss with some APs.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -121,7 +121,7 @@ int ath9k_htc_tx_start(struct ath9k_htc_
 			tx_hdr.data_type = ATH9K_HTC_NORMAL;
 		}
 
-		if (ieee80211_is_data(fc)) {
+		if (ieee80211_is_data_qos(fc)) {
 			qc = ieee80211_get_qos_ctl(hdr);
 			tx_hdr.tidno = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
 		}


