Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142Ab0FOCAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 22:00:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56988 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755912Ab0FOCAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 22:00:53 -0400
Date: Tue, 15 Jun 2010 12:00:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andy Gospodarek <andy@greyhouse.net>,
       Emil Tantilov <emil.s.tantilov@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: linux-next: build failure after merge of the net tree
Message-Id: <20100615120052.7202f20d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

After merging the wireless tree, today's linux-next build (powerpc ppc64_defconfig)
failed like this:

drivers/net/ixgbe/ixgbe_ethtool.c: In function 'ixgbe_set_flags':
drivers/net/ixgbe/ixgbe_ethtool.c:2232: error: implicit declaration of function 'DPRINTK'
drivers/net/ixgbe/ixgbe_ethtool.c:2232: error: 'PROBE' undeclared (first use in this function)
drivers/net/ixgbe/ixgbe_ethtool.c:2232: error: 'INFO' undeclared (first use in this function)

Commit 28c8e4790ca5ef75f54895ca46437f9fbb433ddf ("ixgbe: fix automatic
LRO/RSC settings for low latency") from the net-current tree added
another use of DPRINTK which needs comverting to e_info().  I applied the
following patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 15 Jun 2010 11:43:33 +1000
Subject: [PATCH] net: ixgbe_ethtool merge fix up

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/ixgbe/ixgbe_ethtool.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ixgbe/ixgbe_ethtool.c b/drivers/net/ixgbe/ixgbe_ethtool.c
index 65fe1f5..093461b 100644
--- a/drivers/net/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ixgbe/ixgbe_ethtool.c
@@ -2229,7 +2229,7 @@ static int ixgbe_set_flags(struct net_device *netdev, u32 data)
 		} else if (!adapter->rx_itr_setting) {
 			netdev->features &= ~ETH_FLAG_LRO;
 			if (data & ETH_FLAG_LRO)
-				DPRINTK(PROBE, INFO, "rx-usecs set to 0, "
+				e_info("rx-usecs set to 0, "
 					"LRO/RSC cannot be enabled.\n");
 		}
 	}
-- 
1.7.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
