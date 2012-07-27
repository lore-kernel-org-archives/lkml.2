Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab2G0PjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 11:39:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981Ab2G0PjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 11:39:08 -0400
From: Cong Wang <amwang@redhat.com>
To: netdev@vger.kernel.org
Cc: Cong Wang <amwang@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <shemminger@vyatta.com>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] bridge: call NETDEV_RELEASE notifier in br_del_if()
Date: Fri, 27 Jul 2012 23:38:01 +0800
Message-Id: <1343403484-29347-5-git-send-email-amwang@redhat.com>
In-Reply-To: <1343403484-29347-1-git-send-email-amwang@redhat.com>
References: <1343403484-29347-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a bridge interface deletes its underlying ports, it should
notify netconsole too, like what bonding interface does.

Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Cong Wang <amwang@redhat.com>
---
 net/bridge/br_if.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index e1144e1..d243914 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -427,6 +427,7 @@ int br_del_if(struct net_bridge *br, struct net_device *dev)
 	if (!p || p->br != br)
 		return -EINVAL;
 
+	call_netdevice_notifiers(NETDEV_RELEASE, br->dev);
 	del_nbp(p);
 
 	spin_lock_bh(&br->lock);
-- 
1.7.7.6

