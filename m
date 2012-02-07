Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab2BGUaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 15:30:17 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:36694 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439Ab2BGUaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 15:30:16 -0500
Date: Tue, 07 Feb 2012 15:29:05 -0500 (EST)
Message-Id: <20120207.152905.1412072387367320828.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: netdev@pradeepdalvi.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH v5 3/5] netdev: ethernet dev_alloc_skb to
 netdev_alloc_skb
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAMuHMdXFz5zEWUkrJjNvOqkgt-n2uKc3wzD9H5NKKz1LT4BpOw@mail.gmail.com>
References: <cf736034e7bd407297e2ea9fbf247fb410eb7b39.1328445742.git.netdev@pradeepdalvi.com>
	<ef62da964e8660dfdf2a25cd643631bb15914ecf.1328445742.git.netdev@pradeepdalvi.com>
	<CAMuHMdXFz5zEWUkrJjNvOqkgt-n2uKc3wzD9H5NKKz1LT4BpOw@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 07 Feb 2012 12:29:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 7 Feb 2012 21:04:07 +0100

> drivers/net/ethernet/natsemi/sonic.c:425: error: too few arguments to
> function 'netdev_alloc_skb'

I just wrote and committed the following fix, which took less effort
than your report most likely :-)

--------------------
sonice: Fix build due to botched netdev_alloc_skb() conversion.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/ethernet/natsemi/sonic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index 0452e296..46795e4 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -422,7 +422,7 @@ static void sonic_rx(struct net_device *dev)
 		status = sonic_rda_get(dev, entry, SONIC_RD_STATUS);
 		if (status & SONIC_RCR_PRX) {
 			/* Malloc up new buffer. */
-			new_skb = netdev_alloc_skb(SONIC_RBSIZE + 2);
+			new_skb = netdev_alloc_skb(dev, SONIC_RBSIZE + 2);
 			if (new_skb == NULL) {
 				printk(KERN_ERR "%s: Memory squeeze, dropping packet.\n", dev->name);
 				lp->stats.rx_dropped++;
-- 
1.7.7.6

