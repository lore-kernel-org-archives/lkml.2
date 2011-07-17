Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab1GQR4l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 13:56:41 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20523 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab1GQR4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 13:56:40 -0400
Date: Sun, 17 Jul 2011 19:56:38 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        coreteam@netfilter.org, netfilter@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <shemminger@linux-foundation.org>,
        Patrick McHardy <kaber@trash.net>,
        Bart De Schuymer <bart.de.schuymer@pandora.be>, trivial@kernel.org
Subject: [PATCH][TRIVIAL] net, netfilter: Remove redundant goto in
 ebt_ulog_packet
Message-ID: <alpine.LNX.2.00.1107171953500.32359@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In net/bridge/netfilter/ebt_ulog.c:ebt_ulog_packet() the 'goto unlock'
before the 'alloc_failure' label is completely redundant. This patch
removes it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 net/bridge/netfilter/ebt_ulog.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index 26377e9..bf2a333 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -216,7 +216,6 @@ unlock:
 nlmsg_failure:
 	pr_debug("error during NLMSG_PUT. This should "
 		 "not happen, please report to author.\n");
-	goto unlock;
 alloc_failure:
 	goto unlock;
 }
-- 
1.7.6


PS. Please CC me on replies since I'm not subscribed to all the lists 
copied on this mail.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

