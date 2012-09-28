Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031839Ab2I1UEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:04:32 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:63190 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758884Ab2I1SzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:55:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sebastian Poehn <sebastian.poehn@belden.com>,
        Claudiu Manoil <claudiu.manoil@freescale.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 029/262] gianfar: fix default tx vlan offload feature flag
Date: Fri, 28 Sep 2012 11:49:18 -0700
Message-Id: <20120928183001.417978501@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Claudiu Manoil <claudiu.manoil@freescale.com>

[ Upstream commit e2c53be223aca36cf93eb6a0f6bafa079e78f52b ]

Commit -
"b852b72 gianfar: fix bug caused by
87c288c6e9aa31720b72e2bc2d665e24e1653c3e"
disables by default (on mac init) the hw vlan tag insertion.
The "features" flags were not updated to reflect this, and
"ethtool -K" shows tx-vlan-offload to be "on" by default.

Cc: Sebastian Poehn <sebastian.poehn@belden.com>
Signed-off-by: Claudiu Manoil <claudiu.manoil@freescale.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/gianfar.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -1037,7 +1037,7 @@ static int gfar_probe(struct platform_de
 
 	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_VLAN) {
 		dev->hw_features |= NETIF_F_HW_VLAN_TX | NETIF_F_HW_VLAN_RX;
-		dev->features |= NETIF_F_HW_VLAN_TX | NETIF_F_HW_VLAN_RX;
+		dev->features |= NETIF_F_HW_VLAN_RX;
 	}
 
 	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_EXTENDED_HASH) {


