Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153Ab2B2PoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 10:44:09 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:38814 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758117Ab2B2PnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 10:43:17 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Danny Kukawka <dkukawka@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Joe Perches <joe@perches.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] ethoc: add .ndo_validate_addr to net_device_ops
Date: Wed, 29 Feb 2012 16:42:53 +0100
Message-Id: <1330530176-24952-6-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1330530176-24952-1-git-send-email-danny.kukawka@bisect.de>
References: <1330530176-24952-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1330530197;221c76fe;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add eth_validate_addr() to .ndo_validate_addr to get validation
checks in dev_set_mac_address() working. Remove
is_valid_ether_addr() from ethoc_set_mac_address() to prevent
double check.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/ethernet/ethoc.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ethoc.c b/drivers/net/ethernet/ethoc.c
index a381678..ca80f19 100644
--- a/drivers/net/ethernet/ethoc.c
+++ b/drivers/net/ethernet/ethoc.c
@@ -776,9 +776,6 @@ static int ethoc_set_mac_address(struct net_device *dev, void *addr)
 	struct ethoc *priv = netdev_priv(dev);
 	u8 *mac = (u8 *)addr;
 
-	if (!is_valid_ether_addr(mac))
-		return -EADDRNOTAVAIL;
-
 	ethoc_write(priv, MAC_ADDR0, (mac[2] << 24) | (mac[3] << 16) |
 				     (mac[4] <<  8) | (mac[5] <<  0));
 	ethoc_write(priv, MAC_ADDR1, (mac[0] <<  8) | (mac[1] <<  0));
@@ -899,6 +896,7 @@ static const struct net_device_ops ethoc_netdev_ops = {
 	.ndo_change_mtu = ethoc_change_mtu,
 	.ndo_tx_timeout = ethoc_tx_timeout,
 	.ndo_start_xmit = ethoc_start_xmit,
+	.ndo_validate_addr      = eth_validate_addr,
 };
 
 /**
-- 
1.7.8.3

