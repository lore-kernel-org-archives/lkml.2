Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab1DTUOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:14:18 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:39034 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930Ab1DTUOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:14:17 -0400
Subject: [PATCH V3 5/8] Enable cxgb3 to support zerocopy
From: Shirley Ma <mashirle@us.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: mst@redhat.com, Eric Dumazet <eric.dumazet@gmail.com>,
        Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1303328216.19336.18.camel@localhost.localdomain>
References: <1303328216.19336.18.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Apr 2011 13:13:58 -0700
Message-ID: <1303330438.19336.57.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shirley Ma <xma@us.ibm.com>
---

 drivers/net/cxgb3/cxgb3_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/cxgb3/cxgb3_main.c b/drivers/net/cxgb3/cxgb3_main.c
index 9108931..93a1101 100644
--- a/drivers/net/cxgb3/cxgb3_main.c
+++ b/drivers/net/cxgb3/cxgb3_main.c
@@ -3313,7 +3313,7 @@ static int __devinit init_one(struct pci_dev *pdev,
 		netdev->features |= NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO;
 		netdev->features |= NETIF_F_GRO;
 		if (pci_using_dac)
-			netdev->features |= NETIF_F_HIGHDMA;
+			netdev->features |= NETIF_F_HIGHDMA | NETIF_F_ZEROCOPY;
 
 		netdev->features |= NETIF_F_HW_VLAN_TX | NETIF_F_HW_VLAN_RX;
 		netdev->netdev_ops = &cxgb_netdev_ops;


