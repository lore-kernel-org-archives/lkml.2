Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab1KMVuJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 16:50:09 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13600 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab1KMVuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 16:50:08 -0500
Date: Sun, 13 Nov 2011 22:55:50 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Changli Gao <xiaosuo@gmail.com>,
        Ben Greear <greearb@candelatech.com>,
        Chetan Loke <loke.chetan@gmail.com>, waltje@uWalt.NL.Mugnet.ORG,
        gw4pts@gw4pts.ampr.org, waltje@linux.com, ross.biro@gmail.com,
        alan@linux.intel.com
Subject: [PATCH] net/packet: remove dead code and unneeded variable from
 prb_setup_retire_blk_timer()
Message-ID: <alpine.LNX.2.00.1111132247440.3368@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We test for 'tx_ring' being != zero and BUG() if that's the case. So after
that check there is no way that 'tx_ring' could be anything _but_ zero, so
testing it again is just dead code. Once that dead code is removed, the
'pkc' local variable becomes entirely redundant, so remove that as well.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 net/packet/af_packet.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

 only compile tested.

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 82a6f34..ab10e84 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -516,13 +516,11 @@ static void prb_init_blk_timer(struct packet_sock *po,
 
 static void prb_setup_retire_blk_timer(struct packet_sock *po, int tx_ring)
 {
-	struct tpacket_kbdq_core *pkc;
-
 	if (tx_ring)
 		BUG();
 
-	pkc = tx_ring ? &po->tx_ring.prb_bdqc : &po->rx_ring.prb_bdqc;
-	prb_init_blk_timer(po, pkc, prb_retire_rx_blk_timer_expired);
+	prb_init_blk_timer(po, &po->rx_ring.prb_bdqc,
+			   prb_retire_rx_blk_timer_expired);
 }
 
 static int prb_calc_retire_blk_tmo(struct packet_sock *po,
-- 
1.7.7.3


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.
