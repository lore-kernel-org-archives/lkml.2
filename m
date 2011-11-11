Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006Ab1KKBkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 20:40:00 -0500
Received: from mail-vx0-f202.google.com ([209.85.220.202]:40629 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326Ab1KKBj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 20:39:58 -0500
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Nov 2011 20:39:58 EST
From: David Decotigny <david.decotigny@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>,
        David Decotigny <david.decotigny@google.com>
Subject: [PATCH net-next v2 05/10] forcedeth: stats for rx_packets based on hardware registers
Date: Thu, 10 Nov 2011 17:31:30 -0800
Message-Id: <5a426eed778ea6dbe314c8d5932fb09f4e98dd8b.1320974990.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1320974990.git.david.decotigny@google.com>
References: <cover.1320974990.git.david.decotigny@google.com>
In-Reply-To: <cover.1320974990.git.david.decotigny@google.com>
References: <cover.1320974990.git.david.decotigny@google.com>
Organization: Google, Inc.
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the hardware registers instead of a software implementation to
account for the number of RX packets.



Signed-off-by: David Decotigny <david.decotigny@google.com>
---
 drivers/net/ethernet/nvidia/forcedeth.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 10d1e37..1a1972b 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -1722,6 +1722,7 @@ static struct net_device_stats *nv_get_stats(struct net_device *dev)
 			dev->stats.tx_packets = np->estats.tx_packets;
 			dev->stats.rx_bytes = np->estats.rx_bytes;
 		}
+		dev->stats.rx_packets = np->estats.rx_packets;
 		dev->stats.tx_bytes = np->estats.tx_bytes;
 		dev->stats.tx_fifo_errors = np->estats.tx_fifo_errors;
 		dev->stats.tx_carrier_errors = np->estats.tx_carrier_errors;
@@ -2709,7 +2710,6 @@ static int nv_rx_process(struct net_device *dev, int limit)
 		skb_put(skb, len);
 		skb->protocol = eth_type_trans(skb, dev);
 		napi_gro_receive(&np->napi, skb);
-		dev->stats.rx_packets++;
 		if (unlikely(!(np->driver_data & DEV_HAS_STATISTICS_V23)))
 			dev->stats.rx_bytes += len;
 next_pkt:
@@ -2794,7 +2794,6 @@ static int nv_rx_process_optimized(struct net_device *dev, int limit)
 				__vlan_hwaccel_put_tag(skb, vid);
 			}
 			napi_gro_receive(&np->napi, skb);
-			dev->stats.rx_packets++;
 			if (unlikely(!(np->driver_data
 				       & DEV_HAS_STATISTICS_V23)))
 				dev->stats.rx_bytes += len;
-- 
1.7.3.1

