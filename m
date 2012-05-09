Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab2EIE6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 00:58:14 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50648 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751946Ab2EIE5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 00:57:40 -0400
From: Joe Perches <joe@perches.com>
To: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Subject: [PATCH 02/13] 802: Convert compare_ether_addr to ether_addr_equal
Date: Tue,  8 May 2012 21:56:46 -0700
Message-Id: <ee8418803f60b1a19ccb098cecb7c23396659380.1336538938.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1336538937.git.joe@perches.com>
References: <cover.1336538937.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new bool function ether_addr_equal to add
some clarity and reduce the likelihood for misuse
of compare_ether_addr for sorting.

Done via cocci script:

$ cat compare_ether_addr.cocci
@@
expression a,b;
@@
-	!compare_ether_addr(a, b)
+	ether_addr_equal(a, b)

@@
expression a,b;
@@
-	compare_ether_addr(a, b)
+	!ether_addr_equal(a, b)

@@
expression a,b;
@@
-	!ether_addr_equal(a, b) == 0
+	ether_addr_equal(a, b)

@@
expression a,b;
@@
-	!ether_addr_equal(a, b) != 0
+	!ether_addr_equal(a, b)

@@
expression a,b;
@@
-	ether_addr_equal(a, b) == 0
+	!ether_addr_equal(a, b)

@@
expression a,b;
@@
-	ether_addr_equal(a, b) != 0
+	ether_addr_equal(a, b)

@@
expression a,b;
@@
-	!!ether_addr_equal(a, b)
+	ether_addr_equal(a, b)

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/802/stp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/802/stp.c b/net/802/stp.c
index 15540b7..2c40ba0 100644
--- a/net/802/stp.c
+++ b/net/802/stp.c
@@ -46,7 +46,7 @@ static int stp_pdu_rcv(struct sk_buff *skb, struct net_device *dev,
 		proto = rcu_dereference(garp_protos[eh->h_dest[5] -
 						    GARP_ADDR_MIN]);
 		if (proto &&
-		    compare_ether_addr(eh->h_dest, proto->group_address))
+		    !ether_addr_equal(eh->h_dest, proto->group_address))
 			goto err;
 	} else
 		proto = rcu_dereference(stp_proto);
-- 
1.7.8.111.gad25c.dirty

