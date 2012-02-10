Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696Ab2BJFrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 00:47:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932577Ab2BJFrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 00:47:18 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>, netdev@vger.kernel.org
Subject: [PATCH 51/60] net: remove the second argument of k[un]map_atomic()
Date: Fri, 10 Feb 2012 13:40:12 +0800
Message-Id: <1328852421-19678-52-git-send-email-amwang@redhat.com>
In-Reply-To: <1328852421-19678-1-git-send-email-amwang@redhat.com>
References: <1328852421-19678-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Cong Wang <amwang@redhat.com>
---
 net/core/kmap_skb.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/kmap_skb.h b/net/core/kmap_skb.h
index 81e1ed7..52d0a44 100644
--- a/net/core/kmap_skb.h
+++ b/net/core/kmap_skb.h
@@ -7,12 +7,12 @@ static inline void *kmap_skb_frag(const skb_frag_t *frag)
 
 	local_bh_disable();
 #endif
-	return kmap_atomic(skb_frag_page(frag), KM_SKB_DATA_SOFTIRQ);
+	return kmap_atomic(skb_frag_page(frag));
 }
 
 static inline void kunmap_skb_frag(void *vaddr)
 {
-	kunmap_atomic(vaddr, KM_SKB_DATA_SOFTIRQ);
+	kunmap_atomic(vaddr);
 #ifdef CONFIG_HIGHMEM
 	local_bh_enable();
 #endif
-- 
1.7.7.6

