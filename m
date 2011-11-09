Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964791Ab1KJEnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:43:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43281 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935758Ab1KJDea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:34:30 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:25 2011
Message-Id: <20111109212725.728673269@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:29:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Richard Cochran <richard.cochran@omicron.at>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [250/262] dp83640: use proper function to free transmit time stamping packets
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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


