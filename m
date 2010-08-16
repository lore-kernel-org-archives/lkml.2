Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab0HPQ1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 12:27:05 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:50750 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754642Ab0HPQ1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 12:27:01 -0400
Date: Mon, 16 Aug 2010 18:26:57 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, linux-hams@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 8/16] net/ax25: Use available error codes
Message-ID: <Pine.LNX.4.64.1008161826390.19313@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error codes are stored in err, but the return value is always 0.  Return
err instead.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
local idexpression x;
constant C;
@@

if (...) { ...
  x = -C
  ... when != x
(
  return <+...x...+>;
|
  return NULL;
|
  return;
|
* return ...;
)
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
This changes the semantics and has not been tested.

 net/ax25/ax25_route.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
index 7805945..a169084 100644
--- a/net/ax25/ax25_route.c
+++ b/net/ax25/ax25_route.c
@@ -412,7 +412,7 @@ int ax25_rt_autobind(ax25_cb *ax25, ax25_address *addr)
 {
 	ax25_uid_assoc *user;
 	ax25_route *ax25_rt;
-	int err;
+	int err = 0;
 
 	if ((ax25_rt = ax25_get_route(addr, NULL)) == NULL)
 		return -EHOSTUNREACH;
@@ -453,7 +453,7 @@ int ax25_rt_autobind(ax25_cb *ax25, ax25_address *addr)
 put:
 	ax25_put_route(ax25_rt);
 
-	return 0;
+	return err;
 }
 
 struct sk_buff *ax25_rt_build_path(struct sk_buff *skb, ax25_address *src,
