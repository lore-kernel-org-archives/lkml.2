Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab0E3TsM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 15:48:12 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:58059 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803Ab0E3TsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 15:48:10 -0400
Date: Sun, 30 May 2010 21:48:03 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: "David S. Miller" <davem@davemloft.net>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
       James Morris <jmorris@namei.org>,
       Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
       Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Subject: [PATCH] net/ipv6: Use GFP_ATOMIC when a lock is held
Message-ID: <Pine.LNX.4.64.1005302147310.19253@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

A spin lock is taken near the beginning of the enclosing function.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
@@

spin_lock(...)
... when != spin_unlock(...)
-GFP_KERNEL
+GFP_ATOMIC
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 net/ipv6/sit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/net/ipv6/sit.c b/net/ipv6/sit.c
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -358,7 +358,7 @@ ipip6_tunnel_add_prl(struct ip_tunnel *t
 		goto out;
 	}
 
-	p = kzalloc(sizeof(struct ip_tunnel_prl_entry), GFP_KERNEL);
+	p = kzalloc(sizeof(struct ip_tunnel_prl_entry), GFP_ATOMIC);
 	if (!p) {
 		err = -ENOBUFS;
 		goto out;
