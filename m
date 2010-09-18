Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab0IRTWo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:22:44 -0400
Received: from kroah.org ([198.145.64.141]:43759 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757118Ab0IRTQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:16:04 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:05 2010
Message-Id: <20100918191305.573013202@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:13:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "John W. Linville" <linville@tuxdriver.com>,
        Bob Copeland <me@bobcopeland.com>
Subject: [096/129] ath5k: check return value of ieee80211_get_tx_rate
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John W. Linville <linville@tuxdriver.com>

commit d8e1ba76d619dbc0be8fbeee4e6c683b5c812d3a upstream.

This avoids a NULL pointer dereference as reported here:

	https://bugzilla.redhat.com/show_bug.cgi?id=625889

When the WARN condition is hit in ieee80211_get_tx_rate, it will return
NULL.  So, we need to check the return value and avoid dereferencing it
in that case.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Acked-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath5k/base.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1318,6 +1318,10 @@ ath5k_txbuf_setup(struct ath5k_softc *sc
 			PCI_DMA_TODEVICE);
 
 	rate = ieee80211_get_tx_rate(sc->hw, info);
+	if (!rate) {
+		ret = -EINVAL;
+		goto err_unmap;
+	}
 
 	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
 		flags |= AR5K_TXDESC_NOACK;


