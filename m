Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab2BTFss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 00:48:48 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:42753 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab2BTFsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 00:48:47 -0500
Date: Mon, 20 Feb 2012 00:46:31 -0500 (EST)
Message-Id: <20120220.004631.1816710786293972830.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, danny.kukawka@bisect.de
Subject: Re: linux-next: build failure after merge of the final tree
 (net-next tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120220161545.0078a76d8050c56955427455@canb.auug.org.au>
References: <20120220161545.0078a76d8050c56955427455@canb.auug.org.au>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 19 Feb 2012 21:46:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 20 Feb 2012 16:15:45 +1100

> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/net/ethernet/xilinx/ll_temac_main.c: In function 'temac_set_mac_address':
> drivers/net/ethernet/xilinx/ll_temac_main.c:332:3: error: 'dev' undeclared (first use in this function)
> 
> Caused by commit 5a5e7c364486 ("xilinx ll_temac: use eth_hw_addr_random()
> instead of random_ether_addr()").
> 
> I have reverted that commit for today.

I've fixed it as follows:

--------------------
ll_temac: Fix build.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index eb28541..d21591a 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -329,7 +329,7 @@ static int temac_set_mac_address(struct net_device *ndev, void *address)
 	if (!is_valid_ether_addr(ndev->dev_addr))
 		eth_hw_addr_random(ndev);
 	else
-		dev->addr_assign_type &= ~NET_ADDR_RANDOM;
+		ndev->addr_assign_type &= ~NET_ADDR_RANDOM;
 
 	/* set up unicast MAC address filter set its mac address */
 	mutex_lock(&lp->indirect_mutex);
-- 
1.7.7.6

