Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab0C3XMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:12:39 -0400
Received: from kroah.org ([198.145.64.141]:48973 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756492Ab0C3XMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:31 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:35 2010
Message-Id: <20100330225834.938351193@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ben Hutchings <bhutchings@solarflare.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [43/89] sfc: Fix DMA mapping cleanup in case of an error in TSO
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Neil Turton <nturton@solarflare.com>

commit a7ebd27a13757248863cd61e541af7fa9e7727ee upstream.

We need buffer->len to remain valid to work out the correct address to
be unmapped.  We therefore need to clear buffer->len after the unmap
operation.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/sfc/tx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/sfc/tx.c
+++ b/drivers/net/sfc/tx.c
@@ -823,8 +823,6 @@ static void efx_enqueue_unwind(struct ef
 					   tx_queue->efx->type->txd_ring_mask];
 		efx_tsoh_free(tx_queue, buffer);
 		EFX_BUG_ON_PARANOID(buffer->skb);
-		buffer->len = 0;
-		buffer->continuation = true;
 		if (buffer->unmap_len) {
 			unmap_addr = (buffer->dma_addr + buffer->len -
 				      buffer->unmap_len);
@@ -838,6 +836,8 @@ static void efx_enqueue_unwind(struct ef
 					       PCI_DMA_TODEVICE);
 			buffer->unmap_len = 0;
 		}
+		buffer->len = 0;
+		buffer->continuation = true;
 	}
 }
 


