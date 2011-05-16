Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab1EPTmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 15:42:22 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40928 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857Ab1EPTmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 15:42:21 -0400
Subject: [PATCH V5 6/6 net-next] example: enable zero-copy support in ixgbe
From: Shirley Ma <mashirle@us.ibm.com>
To: David Miller <davem@davemloft.net>, mst@redhat.com,
        Eric Dumazet <eric.dumazet@gmail.com>, Avi Kivity <avi@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 12:42:15 -0700
Message-ID: <1305574935.3456.37.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device can enable zero-copy flag when HIGHDMA is supported.

Signed-off-by: Shirley Ma <xma@us.ibm.com>
---

 drivers/net/ixgbe/ixgbe_main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ixgbe/ixgbe_main.c b/drivers/net/ixgbe/ixgbe_main.c
index 2dce3d0..7e9e881 100644
--- a/drivers/net/ixgbe/ixgbe_main.c
+++ b/drivers/net/ixgbe/ixgbe_main.c
@@ -7553,6 +7553,10 @@ static int __devinit ixgbe_probe(struct pci_dev *pdev,
 		netdev->vlan_features |= NETIF_F_HIGHDMA;
 	}
 
+	/* enable zero-copy when device supports HIGHDMA */
+	if (netdev->features & NETIF_F_HIGHDMA)
+		netdev->features |= NETIF_F_ZEROCOPY;
+
 	if (adapter->flags2 & IXGBE_FLAG2_RSC_ENABLED)
 		netdev->features |= NETIF_F_LRO;
 


