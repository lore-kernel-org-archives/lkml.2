Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab0IGXdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 19:33:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40140
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755645Ab0IGXdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 19:33:14 -0400
Date: Tue, 07 Sep 2010 16:33:31 -0700 (PDT)
Message-Id: <20100907.163331.260082741.davem@davemloft.net>
To: matt.causey@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Is via-velocity broken in 2.6.34?
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTinK4VywsJ86jaC8wQjbXjzvP-z44JD3XbZbMM2a@mail.gmail.com>
References: <AANLkTinK4VywsJ86jaC8wQjbXjzvP-z44JD3XbZbMM2a@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please always CC: netdev@vger.kernel.org for networking reports.

Give this patch a try:

--------------------
via-velocity: Turn scatter-gather support back off.

It causes all kinds of DMA API debugging assertions and
all straight-forward attempts to fix it have failed.

So turn off SG, and we'll tackle making this work
properly in net-next-2.6

Reported-by: Dave Jones <davej@redhat.com>
Tested-by: Dave Jones <davej@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/via-velocity.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/via-velocity.c b/drivers/net/via-velocity.c
index fd69095..f534123 100644
--- a/drivers/net/via-velocity.c
+++ b/drivers/net/via-velocity.c
@@ -2824,7 +2824,7 @@ static int __devinit velocity_found1(struct pci_dev *pdev, const struct pci_devi
 	netif_napi_add(dev, &vptr->napi, velocity_poll, VELOCITY_NAPI_WEIGHT);
 
 	dev->features |= NETIF_F_HW_VLAN_TX | NETIF_F_HW_VLAN_FILTER |
-		NETIF_F_HW_VLAN_RX | NETIF_F_IP_CSUM | NETIF_F_SG;
+		NETIF_F_HW_VLAN_RX | NETIF_F_IP_CSUM;
 
 	ret = register_netdev(dev);
 	if (ret < 0)
-- 
1.7.2.2

