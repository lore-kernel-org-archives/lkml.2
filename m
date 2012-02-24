Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457Ab2BXNqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 08:46:39 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:43936 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750802Ab2BXNqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 08:46:37 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Lennert Buytenhek <kernel@wantstofly.org>
Cc: Danny Kukawka <dkukawka@suse.de>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] xscale/ixp2000/ixpdev: print MAC via printk format specifier
Date: Fri, 24 Feb 2012 14:45:58 +0100
Message-Id: <1330091162-8141-8-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1330091162-8141-1-git-send-email-danny.kukawka@bisect.de>
References: <1330091162-8141-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1330091197;6c473491;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print MAC/dev_addr via printk extended format specifier %pM
instead of custom code.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/ethernet/xscale/ixp2000/ixpdev.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp2000/ixpdev.c b/drivers/net/ethernet/xscale/ixp2000/ixpdev.c
index e122493..4500837 100644
--- a/drivers/net/ethernet/xscale/ixp2000/ixpdev.c
+++ b/drivers/net/ethernet/xscale/ixp2000/ixpdev.c
@@ -398,11 +398,8 @@ int ixpdev_init(int __nds_count, struct net_device **__nds,
 	}
 
 	for (i = 0; i < nds_count; i++) {
-		printk(KERN_INFO "%s: IXP2000 MSF ethernet (port %d), "
-			"%.2x:%.2x:%.2x:%.2x:%.2x:%.2x.\n", nds[i]->name, i,
-			nds[i]->dev_addr[0], nds[i]->dev_addr[1],
-			nds[i]->dev_addr[2], nds[i]->dev_addr[3],
-			nds[i]->dev_addr[4], nds[i]->dev_addr[5]);
+		printk(KERN_INFO "%s: IXP2000 MSF ethernet (port %d), %pM.\n",
+				 nds[i]->name, i, nds[i]->dev_addr);
 	}
 
 	return 0;
-- 
1.7.8.3

