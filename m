Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946542Ab2I1V4L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:56:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34785 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031988Ab2I1UWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:22:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sebastian Poehn <sebastian.poehn@belden.com>,
        Claudiu Manoil <claudiu.manoil@freescale.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 027/218] gianfar: fix default tx vlan offload feature flag
Date: Fri, 28 Sep 2012 13:14:04 -0700
Message-Id: <20120928201504.514949518@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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


