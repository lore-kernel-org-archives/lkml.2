Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462Ab2FGESc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:18:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63306 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932434Ab2FGES0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:18:26 -0400
Message-Id: <20120607040342.171148098@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:16 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stephan Gatzka <stephan@gatzka.org>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 40/82] fec_mpc52xx: fix timestamp filtering
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gatzka <stephan@gatzka.org>

commit 9ca3cc6f3026946ba655e863ca2096339e667639 upstream.

skb_defer_rx_timestamp was called with a freshly allocated skb but must
be called with rskb instead.

Signed-off-by: Stephan Gatzka <stephan@gatzka.org>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/freescale/fec_mpc52xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/freescale/fec_mpc52xx.c
+++ b/drivers/net/ethernet/freescale/fec_mpc52xx.c
@@ -437,7 +437,7 @@ static irqreturn_t mpc52xx_fec_rx_interr
 		length = status & BCOM_FEC_RX_BD_LEN_MASK;
 		skb_put(rskb, length - 4);	/* length without CRC32 */
 		rskb->protocol = eth_type_trans(rskb, dev);
-		if (!skb_defer_rx_timestamp(skb))
+		if (!skb_defer_rx_timestamp(rskb))
 			netif_rx(rskb);
 
 		spin_lock(&priv->lock);


