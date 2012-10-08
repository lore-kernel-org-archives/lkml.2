Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab2JHXwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 19:52:31 -0400
Received: from ozlabs.org ([203.10.76.45]:36293 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab2JHXw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 19:52:28 -0400
From: Michael Neuling <mikey@neuling.org>
To: Eric Dumazet <edumazet@google.com>
cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Maxime Bizon <mbizon@freebox.fr>,
        "David S. Miller" <davem@davemloft.net>, linuxppc-dev@ozlabs.org
Subject: net: fix typo in freescale/ucc_geth.c
In-reply-to: <20121008173653.1d17895964980c98af59c8ea@canb.auug.org.au>
References: <20121008173653.1d17895964980c98af59c8ea@canb.auug.org.au>
Comments: In-reply-to Stephen Rothwell <sfr@canb.auug.org.au>
   message dated "Mon, 08 Oct 2012 17:36:53 +1100."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.3.1
Date: Tue, 09 Oct 2012 10:52:25 +1100
Message-ID: <23452.1349740345@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch: 
  acb600d net: remove skb recycling
added dev_free_skb() to drivers/net/ethernet/freescale/ucc_geth.c

This is a typo and should be dev_kfree_skb().  This fixes this.

Signed-off-by: Michael Neuling <mikey@neuling.org>
---
This hit as a compile error in next-20121008 with mpc85xx_defconfig.

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index dfa0aaa..0a70bb5 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -3268,7 +3268,7 @@ static int ucc_geth_rx(struct ucc_geth_private *ugeth, u8 rxQ, int rx_work_limit
 			if (netif_msg_rx_err(ugeth))
 				ugeth_err("%s, %d: ERROR!!! skb - 0x%08x",
 					   __func__, __LINE__, (u32) skb);
-			dev_free_skb(skb);
+			dev_kfree_skb(skb);
 
 			ugeth->rx_skbuff[rxQ][ugeth->skb_currx[rxQ]] = NULL;
 			dev->stats.rx_dropped++;
