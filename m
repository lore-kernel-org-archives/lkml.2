Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640Ab2CAQxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 11:53:16 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:51646 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758273Ab2CAQxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 11:53:11 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Danny Kukawka <dkukawka@suse.de>, John Crispin <blogic@openwrt.org>,
        Joe Perches <joe@perches.com>, Ralf Baechle <ralf@linux-mips.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] lantiq_etop: use dev_set_mac_address() instead of ltq_etop_set_mac_address()
Date: Thu,  1 Mar 2012 17:52:25 +0100
Message-Id: <1330620747-4047-6-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1330620747-4047-1-git-send-email-danny.kukawka@bisect.de>
References: <1330620747-4047-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1330620791;669231a1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_set_mac_address() instead of ltq_etop_set_mac_address() directly
to get validation checks for free.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/ethernet/lantiq_etop.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index 5dc9cbd..2419f51 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -650,11 +650,11 @@ ltq_etop_init(struct net_device *dev)
 		random_mac = true;
 	}
 
-	err = ltq_etop_set_mac_address(dev, &mac);
+	err = dev_set_mac_address(dev, &mac);
 	if (err)
 		goto err_netdev;
 
-	/* Set addr_assign_type here, ltq_etop_set_mac_address would reset it. */
+	/* Set addr_assign_type here, dev_set_mac_address would reset it. */
 	if (random_mac)
 		dev->addr_assign_type |= NET_ADDR_RANDOM;
 
-- 
1.7.8.3

