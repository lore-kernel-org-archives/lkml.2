Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab3AHXcI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:32:08 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:15732 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306Ab3AHXcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:32:05 -0500
X-AuditID: cbfee61b-b7f616d00000319b-74-50ecac73e05c
From: Byungho An <bh74.an@samsung.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "'Giuseppe CAVALLARO'" <peppe.cavallaro@st.com>, davem@davemloft.net,
        jeffrey.t.kirsher@intel.com, kgene.kim@samsung.com
Subject: [PATCH v2 3/3] net: stmmac: add gmac autonego set for ethtool support
Date: Tue, 08 Jan 2013 15:32:02 -0800
Message-id: <000601cdedf8$5d39bdf0$17ad39d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac3t+FtJH0LrKcltSo2EIxumOw3VeQ==
Content-language: en-zw
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zQ93iNW8CDO5c47C4vGsOm8WxBWIO
	TB6fN8kFMEZx2aSk5mSWpRbp2yVwZWxewV7wlLNiQd8PlgbG+RxdjJwcEgImEvMvr2KBsMUk
	Ltxbz9bFyMUhJLCMUeL9wjPsXYwcYEX/GrQh4osYJf5f3cAM4fxmlLj1fQZYN5uAmkTzzMts
	IA0iAhYSJ9qyQMLMAjUSVy/fYASxhQX8JH4e2ckOYrMIqEpsf7sGzOYVsJRYt+QTE4QtKPFj
	8j0WiF4tifU7jzNB2PISm9e8ZYY4VEFix9nXYDNFBPQk3n6fAnYns4C4xLSmIojxAhLfJh9i
	gThfVmLTAbCLJQT62SUOt0CMlBCQlDi44gbLBEaxWUg2z0KyeRaSzbMQNixgZFnFKJpakFxQ
	nJSea6RXnJhbXJqXrpecn7uJERIr0jsYVzVYHGIU4GBU4uF9OO1NgBBrYllxZe4hRgkOZiUR
	3rveQCHelMTKqtSi/Pii0pzU4kOMPkCHT2SWEk3OB8ZxXkm8obGxiZmJqYm5pam5KQ5hJXFe
	xlNPAoQE0hNLUrNTUwtSi2DGMXFwSjUwegeGCcTuz1aRuRXM+em1gqBP+R/VrHkWV7a1qcss
	EzB8ePyvSdyl3FWiDJe+XNotdFjjknvgtGuv525u/S9iuU7Kkbn5BsPRMwanZf7aFvdNTlQO
	VjL3X5V7rt5aqGEig8spw2uPfViDdC1SN9fPm3rJcItghMnhgxvXfUqdaPAnZK1xTsFUJZbi
	jERDLeai4kQA0AEEcsICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t9jAd3iNW8CDL4dZ7a4vGsOm8WxBWIO
	TB6fN8kFMEY1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+ATo
	umXmAE1WUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWZsXsFe8JSzYkHf
	D5YGxvkcXYwcHBICJhL/GrS7GDmBTDGJC/fWs3UxcnEICSxilPh/dQMzhPObUeLW9xksIFVs
	AmoSzTMvs4E0iwhYSJxoywIJMwvUSFy9fIMRxBYW8JP4eWQnO4jNIqAqsf3tGjCbV8BSYt2S
	T0wQtqDEj8n3WCB6tSTW7zzOBGHLS2xe85YZ4iAFiR1nX4PNFBHQk3j7fQo7yFpmAXGJaU1F
	ExgFZiGZNAvJpFlIJs1C6FjAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzgSn0nvYFzV
	YHGIUYCDUYmH9+G0NwFCrIllxZW5hxglOJiVRHjvegOFeFMSK6tSi/Lji0pzUosPMfoA/TmR
	WUo0OR+YJPJK4g2NTcyMLI3MLIxMzM1xCCuJ8zKeehIgJJCeWJKanZpakFoEM46Jg1OqgVEg
	X07DUmSJTI1QCt8EK9NTE8T0AzYyKP/sf/6rLY15/7G0iW6Bu1mknm1dkOHus1FFuYFx14Jw
	5+15L5qZQm9qfpm0p+LFG9YlHeWn2efVZR08qjo7/I5GlMAv9o0RxxaLSk/UeWj460PI7B+G
	nYxn2K2T9dcl1t+++24R14IdC1p9flj78SuxFGckGmoxFxUnAgCJMLOd8QIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds gmac auto-negotiation setting for ethtool.
If interface is SGMII, TBI or RTBI, gmac's auto-negotiation
enable bit is need to set.

Signed-off-by: Byungho An <bh74.an@samsung.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 1372ce2..457c1a4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -335,6 +335,7 @@ stmmac_set_pauseparam(struct net_device *netdev,
 	struct phy_device *phy = priv->phydev;
 	int new_pause = FLOW_OFF;
 	int ret = 0;
+	int interface = priv->plat->interface;
 
 	spin_lock(&priv->lock);
 
@@ -348,6 +349,10 @@ stmmac_set_pauseparam(struct net_device *netdev,
 
 	if (phy->autoneg) {
 		if (netif_running(netdev))
+			if((interface == PHY_INTERFACE_MODE_SGMII) ||
+				(interface == PHY_INTERFACE_MODE_TBI) ||
+				(interface == PHY_INTERFACE_MODE_RTBI)) 
+				priv->hw->mac->set_autoneg(priv->ioaddr);
 			ret = phy_start_aneg(phy);
 	} else
 		priv->hw->mac->flow_ctrl(priv->ioaddr, phy->duplex,
-- 
1.7.10.4


