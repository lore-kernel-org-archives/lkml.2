Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab2JGXks (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:40:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38335 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753735Ab2JGXWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:25 -0400
Message-Id: <20121007225846.316148456@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:58 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        htbegin <hotforest@gmail.com>, "David S. Miller" <davem@davemloft.net>
Subject: [ 084/108] net: ethernet: davinci_cpdma: decrease the desc count  when cleaning up the remaining packets
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: htbegin <hotforest@gmail.com>

[ Upstream commit ffb5ba90017505a19e238e986e6d33f09e4df765 ]

chan->count is used by rx channel. If the desc count is not updated by
the clean up loop in cpdma_chan_stop, the value written to the rxfree
register in cpdma_chan_start will be incorrect.

Signed-off-by: Tao Hou <hotforest@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/ti/davinci_cpdma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/ti/davinci_cpdma.c b/drivers/net/ethernet/ti/davinci_cpdma.c
index c97d2f5..bfc3b0d 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.c
+++ b/drivers/net/ethernet/ti/davinci_cpdma.c
@@ -851,6 +851,7 @@ int cpdma_chan_stop(struct cpdma_chan *chan)
 
 		next_dma = desc_read(desc, hw_next);
 		chan->head = desc_from_phys(pool, next_dma);
+		chan->count--;
 		chan->stats.teardown_dequeue++;
 
 		/* issue callback without locks held */


