Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730Ab2HYDX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 23:23:26 -0400
Received: from mail-vc0-f202.google.com ([209.85.220.202]:44250 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab2HYDXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 23:23:12 -0400
From: David Decotigny <decot@googlers.com>
To: Ayaz Abdulla <aabdulla@nvidia.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Joe Perches <joe@perches.com>,
        David Decotigny <decot@googlers.com>
Subject: [PATCH net-next v1 1/3] forcedeth: fix buffer overflow
Date: Fri, 24 Aug 2012 20:22:51 -0700
Message-Id: <527de689e5eff49f66a8da7aff05ad72b8b97c04.1345864542.git.decot@googlers.com>
X-Mailer: git-send-email 1.7.10.2.5.g20d7bc9
In-Reply-To: <cover.1345864542.git.decot@googlers.com>
References: <cover.1345864542.git.decot@googlers.com>
In-Reply-To: <cover.1345864542.git.decot@googlers.com>
References: <cover.1345864542.git.decot@googlers.com>
Organization: Google, Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found by manual code inspection.

Tested: compile, reboot, ethtool -d ethX


Signed-off-by: David Decotigny <decot@googlers.com>
---
 drivers/net/ethernet/nvidia/forcedeth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index f45def0..51d19d8 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -4435,7 +4435,7 @@ static void nv_get_regs(struct net_device *dev, struct ethtool_regs *regs, void
 
 	regs->version = FORCEDETH_REGS_VER;
 	spin_lock_irq(&np->lock);
-	for (i = 0; i <= np->register_size/sizeof(u32); i++)
+	for (i = 0; i < np->register_size/sizeof(u32); i++)
 		rbuf[i] = readl(base + i*sizeof(u32));
 	spin_unlock_irq(&np->lock);
 }
-- 
1.7.10.2.5.g20d7bc9

