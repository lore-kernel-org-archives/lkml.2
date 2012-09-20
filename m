Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab2ITBRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 21:17:47 -0400
Received: from noserose.net ([66.220.18.76]:40265 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751027Ab2ITBRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 21:17:45 -0400
Date: Wed, 19 Sep 2012 18:17:43 -0700
Message-Id: <72368962c6414543ce7d2c3f1ab5f36154fdd710.1348088283.git.ecashin@coraid.com>
In-Reply-To: <cover.1348088283.git.ecashin@coraid.com>
References: <1348079358.4585@cat.he.net>
	<cover.1348088283.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 1/2] aoe: mark AoE packets as requiring no checksumming
To: davem@davemloft.net
Cc: ecashin@coraid.com, akpm@linux-foundation.org, bhutchings@solarflare.com,
        jesse@nicira.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order for the network layer to see that AoE requires
no checksumming in a generic way, packets should be marked
CHECKSUM_NONE.

Rather than relying on the current behavior of alloc_skb,
this change causes the aoe driver to explicitly mark its
packets as requiring no checksum.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoecmd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index de0435e..0ba1b63 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -35,6 +35,7 @@ new_skb(ulong len)
 		skb_reset_mac_header(skb);
 		skb_reset_network_header(skb);
 		skb->protocol = __constant_htons(ETH_P_AOE);
+		skb->ip_summed = CHECKSUM_NONE;
 	}
 	return skb;
 }
-- 
1.7.2.5

