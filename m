Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527Ab1ALVVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 16:21:41 -0500
Received: from mail.perches.com ([173.55.12.10]:3105 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756375Ab1ALVVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 16:21:22 -0500
From: Joe Perches <joe@perches.com>
To: Rasesh Mody <rmody@brocade.com>, Debashis Dutt <ddutt@brocade.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] bna: Remove unnecessary memset(,0,)
Date: Wed, 12 Jan 2011 13:21:18 -0800
Message-Id: <0ed96bd1a053e61c827f2ac09e38cba59e32a21b.1294867098.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <6f6d4a7a705949a3464471f364f77215f1e796f3.1294867098.git.joe@perches.com>
References: <6f6d4a7a705949a3464471f364f77215f1e796f3.1294867098.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc'd memory doesn't need a memset to 0.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/bna/bnad_ethtool.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/bna/bnad_ethtool.c b/drivers/net/bna/bnad_ethtool.c
index 99be5ae..142d604 100644
--- a/drivers/net/bna/bnad_ethtool.c
+++ b/drivers/net/bna/bnad_ethtool.c
@@ -275,7 +275,6 @@ bnad_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 
 	ioc_attr = kzalloc(sizeof(*ioc_attr), GFP_KERNEL);
 	if (ioc_attr) {
-		memset(ioc_attr, 0, sizeof(*ioc_attr));
 		spin_lock_irqsave(&bnad->bna_lock, flags);
 		bfa_nw_ioc_get_attr(&bnad->bna.device.ioc, ioc_attr);
 		spin_unlock_irqrestore(&bnad->bna_lock, flags);
-- 
1.7.3.3.398.g0b0cd.dirty

