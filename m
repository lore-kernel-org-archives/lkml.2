Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab0LHA7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:59:14 -0500
Received: from kroah.org ([198.145.64.141]:48332 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756789Ab0LHA7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:07 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:22 2010
Message-Id: <20101208005722.589317825@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:56:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Bj=C3=B6rn=20Smedman?= <bjorn.smedman@venatech.se>,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [012/289] ath9k: built-in rate control A-MPDU fix
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: =?UTF-8?q?Bj=C3=B6rn=20Smedman?= <bjorn.smedman@venatech.se>

commit a8909cfb1832ac623142898df2a9374722cfe68f upstream.

This patch attempts to ensure that ath9k's built-in rate control algorithm
does not rely on the value of the ampdu_len and ampdu_ack_len tx status
fields unless the IEEE80211_TX_STAT_AMPDU flag is set.

This patch has not been tested.

Signed-off-by: Björn Smedman <bjorn.smedman@venatech.se>
Acked-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/rc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1359,6 +1359,12 @@ static void ath_tx_status(void *priv, st
 	if (tx_info->flags & IEEE80211_TX_STAT_TX_FILTERED)
 		return;
 
+	if (!(tx_info->flags & IEEE80211_TX_STAT_AMPDU)) {
+		tx_info->status.ampdu_ack_len =
+			(tx_info->flags & IEEE80211_TX_STAT_ACK ? 1 : 0);
+		tx_info->status.ampdu_len = 1;
+	}
+
 	/*
 	 * If an underrun error is seen assume it as an excessive retry only
 	 * if max frame trigger level has been reached (2 KB for singel stream,


