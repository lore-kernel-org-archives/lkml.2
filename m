Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003Ab0C3X1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:27:12 -0400
Received: from kroah.org ([198.145.64.141]:46801 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754968Ab0C3XWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:22:10 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:54 2010
Message-Id: <20100330224853.402913400@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alexander Duyck <alexander.h.duyck@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [143/156] skbuff: remove unused dma_head & dma_maps fields
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexander Duyck <alexander.h.duyck@intel.com>

[ Upstream commit 03e6d819c2cb2cc8ce5642669a0a7c72336ee7a2 ]

The dma map fields in the skb_shared_info structure no longer has any users
and can be dropped since it is making the skb_shared_info unecessarily larger.

Running slabtop show that we were using 4K slabs for the skb->head on x86_64 w/
an allocation size of 1522.  It turns out that the dma_head and dma_maps array
made skb_shared large enough that we had crossed over the 2k boundary with
standard frames and as such we were using 4k blocks of memory for all skbs.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/skbuff.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -190,9 +190,6 @@ struct skb_shared_info {
 	atomic_t	dataref;
 	unsigned short	nr_frags;
 	unsigned short	gso_size;
-#ifdef CONFIG_HAS_DMA
-	dma_addr_t	dma_head;
-#endif
 	/* Warning: this field is not always filled in (UFO)! */
 	unsigned short	gso_segs;
 	unsigned short  gso_type;
@@ -201,9 +198,6 @@ struct skb_shared_info {
 	struct sk_buff	*frag_list;
 	struct skb_shared_hwtstamps hwtstamps;
 	skb_frag_t	frags[MAX_SKB_FRAGS];
-#ifdef CONFIG_HAS_DMA
-	dma_addr_t	dma_maps[MAX_SKB_FRAGS];
-#endif
 	/* Intermediate layers must ensure that destructor_arg
 	 * remains valid until skb destructor */
 	void *		destructor_arg;


