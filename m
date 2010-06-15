Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731Ab0FOCAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 22:00:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56975 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab0FOCAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 22:00:46 -0400
Date: Tue, 15 Jun 2010 12:00:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Emil Tantilov <emil.s.tantilov@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Andy Gospodarek <andy@greyhouse.net>
Subject: linux-next: manual merge of the net tree with the net-current tree
Message-Id: <20100615120041.27b02c6f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the net tree got a conflict in
drivers/net/ixgbe/ixgbe_ethtool.c between commit
28c8e4790ca5ef75f54895ca46437f9fbb433ddf ("ixgbe: fix automatic LRO/RSC
settings for low latency") from the net-current tree and commit
849c45423c0c108e08d67644728cc9b0ed225fa1 ("ixgbe: Use netdev_<level>,
dev_<level>, pr_<level>") from the net tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/ixgbe/ixgbe_ethtool.c
index 3a93a81,644e3d2..0000000
--- a/drivers/net/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ixgbe/ixgbe_ethtool.c
@@@ -2132,11 -2155,9 +2130,10 @@@ static int ixgbe_set_coalesce(struct ne
  		 */
  		if (adapter->flags2 & IXGBE_FLAG2_RSC_ENABLED) {
  			adapter->flags2 &= ~IXGBE_FLAG2_RSC_ENABLED;
 -			netdev->features &= ~NETIF_F_LRO;
 -			e_info("rx-usecs set to 0, disabling RSC\n");
 -
 +			if (netdev->features & NETIF_F_LRO) {
 +				netdev->features &= ~NETIF_F_LRO;
- 				DPRINTK(PROBE, INFO, "rx-usecs set to 0, "
- 					"disabling LRO/RSC\n");
++				e_info("rx-usecs set to 0, disabling LRO/RSC\n");
 +			}
  			need_reset = true;
  		}
  	}
