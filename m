Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab1BAKII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 05:08:08 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:44277 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab1BAKIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 05:08:02 -0500
From: Simon Horman <horms@verge.net.au>
To: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvs-devel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Hans Schillstrom <hans@schillstrom.com>,
        Patrick McHardy <kaber@trash.net>, Simon Horman <horms@verge.net.au>
Subject: [PATCH 2/5] IPVS: remove duplicate initialisation or rs_table
Date: Tue,  1 Feb 2011 21:07:45 +1100
Message-Id: <1296554868-17002-3-git-send-email-horms@verge.net.au>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1296554868-17002-1-git-send-email-horms@verge.net.au>
References: <1296554868-17002-1-git-send-email-horms@verge.net.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Hans Schillstrom <hans@schillstrom.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 net/netfilter/ipvs/ip_vs_ctl.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 98df59a..d7c2fa8 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -3515,9 +3515,6 @@ int __net_init __ip_vs_control_init(struct net *net)
 	}
 	spin_lock_init(&ipvs->tot_stats->lock);
 
-	for (idx = 0; idx < IP_VS_RTAB_SIZE; idx++)
-		INIT_LIST_HEAD(&ipvs->rs_table[idx]);
-
 	proc_net_fops_create(net, "ip_vs", 0, &ip_vs_info_fops);
 	proc_net_fops_create(net, "ip_vs_stats", 0, &ip_vs_stats_fops);
 	proc_net_fops_create(net, "ip_vs_stats_percpu", 0,
-- 
1.7.2.3

