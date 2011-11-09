Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966142Ab1KJDth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:49:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45275 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966012Ab1KJDtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:49:33 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:08 2011
Message-Id: <20111109213207.938629080@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Richard Cochran <richard.cochran@omicron.at>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [252/264] dp83640: use proper function to free transmit time stamping packets
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Cochran <richardcochran@gmail.com>

commit f5ff7cd1a84caa9545d952a37ac872ccb73825fb upstream.

The previous commit enforces a new rule for handling the cloned packets
for transmit time stamping. These packets must not be freed using any other
function than skb_complete_tx_timestamp. This commit fixes the one and only
driver using this API.

The driver first appeared in v3.0.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/phy/dp83640.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -1067,7 +1067,7 @@ static void dp83640_txtstamp(struct phy_
 	struct dp83640_private *dp83640 = phydev->priv;
 
 	if (!dp83640->hwts_tx_en) {
-		kfree_skb(skb);
+		skb_complete_tx_timestamp(skb, NULL);
 		return;
 	}
 	skb_queue_tail(&dp83640->tx_queue, skb);


