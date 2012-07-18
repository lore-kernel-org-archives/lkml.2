Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab2GRQyC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 12:54:02 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:32344 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996Ab2GRQx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 12:53:59 -0400
Message-ID: <201207181653.q6IGrwxw007622@lab-41.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 18 Jul 2012 12:53:03 -0400
Subject: [PATCH 3/3] tilegx net: use eth_hw_addr_random(), not random_ether_addr()
To: "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <201207181650.q6IGodZ7007565@lab-41.internal.tilera.com>
References: <201207181650.q6IGodZ7007565@lab-41.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 drivers/net/ethernet/tile/tilegx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/tile/tilegx.c b/drivers/net/ethernet/tile/tilegx.c
index f78effc..4e2a162 100644
--- a/drivers/net/ethernet/tile/tilegx.c
+++ b/drivers/net/ethernet/tile/tilegx.c
@@ -1851,7 +1851,7 @@ static void tile_net_dev_init(const char *name, const uint8_t *mac)
 		memcpy(dev->dev_addr, mac, 6);
 		dev->addr_len = 6;
 	} else {
-		random_ether_addr(dev->dev_addr);
+		eth_hw_addr_random(dev);
 	}
 
 	/* Register the network device. */
-- 
1.7.10.3

