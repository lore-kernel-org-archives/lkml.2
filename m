Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab1GHFHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:07:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42637 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755454Ab1GHFGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:06:09 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:17:02 2011
Message-Id: <20110708001702.733789542@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:17:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Wei Yongjun <yjwei@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [103/107] vlan: fix typo in vlan_dev_hard_start_xmit()
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Wei Yongjun <yjwei@cn.fujitsu.com>

[ Upstream commit 307f73df2b9829ee5a261d1ed432ff683c426cdf ]

commit 4af429d29b341bb1735f04c2fb960178ed5d52e7 (vlan: lockless
transmit path) have a typo in vlan_dev_hard_start_xmit(), using
u64_stats_update_begin() to end the stat update, it should be
u64_stats_update_end().

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/8021q/vlan_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -338,7 +338,7 @@ static netdev_tx_t vlan_dev_hard_start_x
 		u64_stats_update_begin(&stats->syncp);
 		stats->tx_packets++;
 		stats->tx_bytes += len;
-		u64_stats_update_begin(&stats->syncp);
+		u64_stats_update_end(&stats->syncp);
 	} else {
 		this_cpu_inc(vlan_dev_info(dev)->vlan_pcpu_stats->tx_dropped);
 	}


