Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933934Ab2JKCZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:25:14 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43331 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933529Ab2JKCNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:13:18 -0400
X-Sasl-enc: 6TymXY4EkCZz4aVLZTfxQWtZ9RRKdnSkOdy5RdWUsxMQ 1349921596
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tao Hou <hotforest@gmail.com>, "David S. Miller" <davem@davemloft.net>
Subject: [ 20/84] net: ethernet: davinci_cpdma: decrease the desc count when cleaning up the remaining packets
Date: Thu, 11 Oct 2012 11:03:04 +0900
Message-Id: <20121011015420.709752859@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: htbegin <hotforest@gmail.com>

[ Upstream commit ffb5ba90017505a19e238e986e6d33f09e4df765 ]

chan->count is used by rx channel. If the desc count is not updated by
the clean up loop in cpdma_chan_stop, the value written to the rxfree
register in cpdma_chan_start will be incorrect.

Signed-off-by: Tao Hou <hotforest@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/davinci_cpdma.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/davinci_cpdma.c
+++ b/drivers/net/davinci_cpdma.c
@@ -849,6 +849,7 @@ int cpdma_chan_stop(struct cpdma_chan *c
 
 		next_dma = desc_read(desc, hw_next);
 		chan->head = desc_from_phys(pool, next_dma);
+		chan->count--;
 		chan->stats.teardown_dequeue++;
 
 		/* issue callback without locks held */


