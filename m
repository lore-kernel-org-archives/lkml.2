Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab2ITBqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 21:46:43 -0400
Received: from noserose.net ([66.220.18.76]:44232 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753010Ab2ITBql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 21:46:41 -0400
Date: Wed, 19 Sep 2012 18:46:39 -0700
Message-Id: <b4821fa88e0a0047eaa40011e8440e3d68575f75.1348105262.git.ecashin@coraid.com>
In-Reply-To: <cover.1348105262.git.ecashin@coraid.com>
References: <cover.1348105262.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 1/2] aoe: assert AoE packets marked as requiring no checksum
To: davem@davemloft.net
Cc: ecashin@coraid.com, akpm@linux-foundation.org, bhutchings@solarflare.com,
        jesse@nicira.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order for the network layer to see that AoE requires
no checksumming in a generic way, the packets must be
marked as requiring no checksum, so we make this requirement
explicit with the assertion.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoecmd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index de0435e..887f68f 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -35,6 +35,7 @@ new_skb(ulong len)
 		skb_reset_mac_header(skb);
 		skb_reset_network_header(skb);
 		skb->protocol = __constant_htons(ETH_P_AOE);
+		skb_checksum_none_assert(skb);
 	}
 	return skb;
 }
-- 
1.7.2.5

