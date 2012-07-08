Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab2GHLiT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 07:38:19 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:56591 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751817Ab2GHLhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 07:37:52 -0400
X-IronPort-AV: E=Sophos;i="4.77,546,1336341600"; 
   d="scan'208";a="166023137"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: "David S. Miller" <davem@davemloft.net>
Cc: kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] net/rxrpc/ar-peer.c: remove invalid reference to list iterator variable
Date: Sun,  8 Jul 2012 13:37:39 +0200
Message-Id: <1341747464-1772-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1341747464-1772-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1341747464-1772-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

If list_for_each_entry, etc complete a traversal of the list, the iterator
variable ends up pointing to an address at an offset from the list head,
and not a meaningful structure.  Thus this value should not be used after
the end of the iterator.  This seems to be a copy-paste bug from a previous
debugging message, and so the meaningless value is just deleted.

This problem was found using Coccinelle (http://coccinelle.lip6.fr/).

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 net/rxrpc/ar-peer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/ar-peer.c b/net/rxrpc/ar-peer.c
index 2754f09..bebaa43 100644
--- a/net/rxrpc/ar-peer.c
+++ b/net/rxrpc/ar-peer.c
@@ -229,7 +229,7 @@ found_UDP_peer:
 	return peer;
 
 new_UDP_peer:
-	_net("Rx UDP DGRAM from NEW peer %d", peer->debug_id);
+	_net("Rx UDP DGRAM from NEW peer");
 	read_unlock_bh(&rxrpc_peer_lock);
 	_leave(" = -EBUSY [new]");
 	return ERR_PTR(-EBUSY);

