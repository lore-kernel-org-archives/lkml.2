Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157Ab2B2Ppl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 10:45:41 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:38768 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756515Ab2B2PnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 10:43:13 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Eilon Greenstein <eilong@broadcom.com>
Cc: Danny Kukawka <dkukawka@suse.de>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] bnx2x: adopt bnx2x_validate_addr() to .ndo_validate_addr changes
Date: Wed, 29 Feb 2012 16:42:50 +0100
Message-Id: <1330530176-24952-3-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1330530176-24952-1-git-send-email-danny.kukawka@bisect.de>
References: <1330530176-24952-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1330530193;94273f35;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adopted bnx2x_validate_addr() to changes in .ndo_validate_addr,
handle second parameter to be validated.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index b4afef6..d25ef1e 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -10532,12 +10532,19 @@ static void poll_bnx2x(struct net_device *dev)
 }
 #endif
 
-static int bnx2x_validate_addr(struct net_device *dev)
+static int bnx2x_validate_addr(struct net_device *dev, void *addr)
 {
 	struct bnx2x *bp = netdev_priv(dev);
+	struct sockaddr *saddr; 
 
-	if (!bnx2x_is_valid_ether_addr(bp, dev->dev_addr))
-		return -EADDRNOTAVAIL;
+	if (addr) {
+		saddr = addr;
+		if (!bnx2x_is_valid_ether_addr(bp, saddr->sa_data))	
+			return -EADDRNOTAVAIL;
+	} else {
+		if (!bnx2x_is_valid_ether_addr(bp, dev->dev_addr))
+			return -EADDRNOTAVAIL;
+	}
 	return 0;
 }
 
-- 
1.7.8.3

