Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454Ab2LCOmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:42:04 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43920 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755498Ab2LCOgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:55 -0500
Message-Id: <20121203143152.758696735@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:23 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Arend van Spriel <arend@broadcom.com>,
        Pieter-Paul Giesberts <pieterpg@broadcom.com>,
        Alwin Beukers <alwin@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 37/89] brcm80211: smac: only print block-ack timeout message at trace level
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arend van Spriel <arend@broadcom.com>

commit 2b0a53d51b5f263bb581bbdb40ebb9f7e09609b1 upstream.

In regular use block-ack timeouts can happen so it does not make
sense to fill the log with these messages.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
index 9265226..30b5887 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
@@ -1070,9 +1070,9 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 				    IEEE80211_TX_STAT_AMPDU_NO_BACK;
 				skb_pull(p, D11_PHY_HDR_LEN);
 				skb_pull(p, D11_TXH_LEN);
-				wiphy_err(wiphy, "%s: BA Timeout, seq %d, in_"
-					"transit %d\n", "AMPDU status", seq,
-					ini->tx_in_transit);
+				BCMMSG(wiphy,
+				       "BA Timeout, seq %d, in_transit %d\n",
+				       seq, ini->tx_in_transit);
 				ieee80211_tx_status_irqsafe(wlc->pub->ieee_hw,
 							    p);
 			}


