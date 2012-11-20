Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab2KTIaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 03:30:35 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:46901 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab2KTIaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 03:30:30 -0500
From: Tejun Heo <tj@kernel.org>
To: daniel.wagner@bmw-carit.de, serge.hallyn@canonical.com,
        ebiederm@xmission.com, nhorman@tuxdriver.com, tgraf@suug.ch
Cc: davem@davemloft.net, lizefan@huawei.com, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/7] netprio_cgroup: shorten variable names in extend_netdev_table()
Date: Tue, 20 Nov 2012 00:30:07 -0800
Message-Id: <1353400211-5182-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353400211-5182-1-git-send-email-tj@kernel.org>
References: <1353400211-5182-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function is about to go through a rewrite.  In preparation,
shorten the variable names so that we don't repeat "priomap" so often.

This patch is cosmetic.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
---
 net/core/netprio_cgroup.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
index 66d98da..92cc54c 100644
--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -71,26 +71,25 @@ static int extend_netdev_table(struct net_device *dev, u32 new_len)
 {
 	size_t new_size = sizeof(struct netprio_map) +
 			   ((sizeof(u32) * new_len));
-	struct netprio_map *new_priomap = kzalloc(new_size, GFP_KERNEL);
-	struct netprio_map *old_priomap;
+	struct netprio_map *new = kzalloc(new_size, GFP_KERNEL);
+	struct netprio_map *old;
 
-	old_priomap  = rtnl_dereference(dev->priomap);
+	old = rtnl_dereference(dev->priomap);
 
-	if (!new_priomap) {
+	if (!new) {
 		pr_warn("Unable to alloc new priomap!\n");
 		return -ENOMEM;
 	}
 
-	if (old_priomap)
-		memcpy(new_priomap->priomap, old_priomap->priomap,
-		       old_priomap->priomap_len *
-		       sizeof(old_priomap->priomap[0]));
+	if (old)
+		memcpy(new->priomap, old->priomap,
+		       old->priomap_len * sizeof(old->priomap[0]));
 
-	new_priomap->priomap_len = new_len;
+	new->priomap_len = new_len;
 
-	rcu_assign_pointer(dev->priomap, new_priomap);
-	if (old_priomap)
-		kfree_rcu(old_priomap, rcu);
+	rcu_assign_pointer(dev->priomap, new);
+	if (old)
+		kfree_rcu(old, rcu);
 	return 0;
 }
 
-- 
1.7.11.7

