Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab1GHFPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:15:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218Ab1GHFCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:02:55 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:57 2011
Message-Id: <20110708001657.257533921@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sachin Sanap <ssanap@marvell.com>, Zhangfei Gao <zgao6@marvell.com>,
        Philip Rakity <prakity@marvell.com>,
        Richard Cochran <richard.cochran@omicron.at>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [047/107] pxa168_eth: fix race in transmit path.
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Richard Cochran <richardcochran@gmail.com>

commit 384420409d9b5d4443940abace49363d26135412 upstream.

Because the socket buffer is freed in the completion interrupt, it is not
safe to access it after submitting it to the hardware.

Cc: Sachin Sanap <ssanap@marvell.com>
Cc: Zhangfei Gao <zgao6@marvell.com>
Cc: Philip Rakity <prakity@marvell.com>
Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/pxa168_eth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/pxa168_eth.c
+++ b/drivers/net/pxa168_eth.c
@@ -1273,7 +1273,7 @@ static int pxa168_eth_start_xmit(struct
 	wmb();
 	wrl(pep, SDMA_CMD, SDMA_CMD_TXDH | SDMA_CMD_ERD);
 
-	stats->tx_bytes += skb->len;
+	stats->tx_bytes += length;
 	stats->tx_packets++;
 	dev->trans_start = jiffies;
 	if (pep->tx_ring_size - pep->tx_desc_count <= 1) {


