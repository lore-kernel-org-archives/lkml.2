Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711Ab0EMUCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:02:30 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:42001 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759063Ab0EMUC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:02:26 -0400
Date: Thu, 13 May 2010 22:02:21 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 10/20] drivers/block/drbd: Use kzalloc
Message-ID: <Pine.LNX.4.64.1005132202040.6282@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kzalloc rather than the combination of kmalloc and memset.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,size,flags;
statement S;
@@

-x = kmalloc(size,flags);
+x = kzalloc(size,flags);
 if (x == NULL) S
-memset(x, 0, size);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/block/drbd/drbd_nl.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -u -p a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1199,13 +1199,12 @@ static int drbd_nl_net_conf(struct drbd_
 	}
 
 	/* allocation not in the IO path, cqueue thread context */
-	new_conf = kmalloc(sizeof(struct net_conf), GFP_KERNEL);
+	new_conf = kzalloc(sizeof(struct net_conf), GFP_KERNEL);
 	if (!new_conf) {
 		retcode = ERR_NOMEM;
 		goto fail;
 	}
 
-	memset(new_conf, 0, sizeof(struct net_conf));
 	new_conf->timeout	   = DRBD_TIMEOUT_DEF;
 	new_conf->try_connect_int  = DRBD_CONNECT_INT_DEF;
 	new_conf->ping_int	   = DRBD_PING_INT_DEF;
