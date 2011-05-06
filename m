Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373Ab1EFArI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:47:08 -0400
Received: from kroah.org ([198.145.64.141]:37036 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932329Ab1EFAZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:27 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:14 2011
Message-Id: <20110506002214.124823285@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Pavel Roskin <proski@gnu.org>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Ivo van Doorn <IvDoorn@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [091/143] rt2x00: use correct headroom for transmission
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Pavel Roskin <proski@gnu.org>

commit b59a52f12e483b79e7d32da7ec30dcf3b2e0210b upstream.

Use rt2x00dev->ops->extra_tx_headroom, not rt2x00dev->hw->extra_tx_headroom
in the tx code, as the later may include other headroom not to be used in
the chipset driver.

Signed-off-by: Pavel Roskin <proski@gnu.org>
Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -103,7 +103,7 @@ void rt2x00queue_map_txskb(struct rt2x00
 	 * is also mapped to the DMA so it can be used for transfering
 	 * additional descriptor information to the hardware.
 	 */
-	skb_push(skb, rt2x00dev->hw->extra_tx_headroom);
+	skb_push(skb, rt2x00dev->ops->extra_tx_headroom);
 
 	skbdesc->skb_dma =
 	    dma_map_single(rt2x00dev->dev, skb->data, skb->len, DMA_TO_DEVICE);
@@ -111,7 +111,7 @@ void rt2x00queue_map_txskb(struct rt2x00
 	/*
 	 * Restore data pointer to original location again.
 	 */
-	skb_pull(skb, rt2x00dev->hw->extra_tx_headroom);
+	skb_pull(skb, rt2x00dev->ops->extra_tx_headroom);
 
 	skbdesc->flags |= SKBDESC_DMA_MAPPED_TX;
 }
@@ -133,7 +133,7 @@ void rt2x00queue_unmap_skb(struct rt2x00
 		 * by the driver, but it was actually mapped to DMA.
 		 */
 		dma_unmap_single(rt2x00dev->dev, skbdesc->skb_dma,
-				 skb->len + rt2x00dev->hw->extra_tx_headroom,
+				 skb->len + rt2x00dev->ops->extra_tx_headroom,
 				 DMA_TO_DEVICE);
 		skbdesc->flags &= ~SKBDESC_DMA_MAPPED_TX;
 	}


