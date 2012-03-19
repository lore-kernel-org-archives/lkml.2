Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030223Ab2CSDiT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 23:38:19 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54369 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932332Ab2CSDiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 23:38:17 -0400
From: Joe Perches <joe@perches.com>
To: Patrick McHardy <kaber@trash.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] if_vlan: Remove VLAN_ETH_ALEN define and the 1 use of it
Date: Sun, 18 Mar 2012 20:37:56 -0700
Message-Id: <89fdd9882355bacb4771a0c6c1f7a6ed43ab3f8b.1332128181.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1332128181.git.joe@perches.com>
References: <cover.1332128181.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just use ETH_ALEN.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/if_vlan.h |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 13aff1e..33a6e19 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -18,10 +18,9 @@
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
 
-#define VLAN_HLEN	4		/* The additional bytes (on top of the Ethernet header)
-					 * that VLAN requires.
+#define VLAN_HLEN	4		/* The additional bytes required by VLAN
+					 * (in addition to the Ethernet header)
 					 */
-#define VLAN_ETH_ALEN	6		/* Octets in one ethernet addr	 */
 #define VLAN_ETH_HLEN	18		/* Total octets in header.	 */
 #define VLAN_ETH_ZLEN	64		/* Min. octets in frame sans FCS */
 
@@ -177,7 +176,7 @@ static inline struct sk_buff *vlan_insert_tag(struct sk_buff *skb, u16 vlan_tci)
 	veth = (struct vlan_ethhdr *)skb_push(skb, VLAN_HLEN);
 
 	/* Move the mac addresses to the beginning of the new header. */
-	memmove(skb->data, skb->data + VLAN_HLEN, 2 * VLAN_ETH_ALEN);
+	memmove(skb->data, skb->data + VLAN_HLEN, 2 * ETH_ALEN);
 	skb->mac_header -= VLAN_HLEN;
 
 	/* first, the ethernet type */
-- 
1.7.8.111.gad25c.dirty

