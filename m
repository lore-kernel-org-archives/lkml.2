Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab2CAImu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 03:42:50 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39681 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758067Ab2CAIms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 03:42:48 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of b.van.den.berg.nl@gmail.com designates 10.14.48.77 as permitted sender) smtp.mail=b.van.den.berg.nl@gmail.com; dkim=pass header.i=b.van.den.berg.nl@gmail.com
Date: Thu, 1 Mar 2012 09:42:42 +0100
From: Bas van den Berg <b.van.den.berg.nl@gmail.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sriram <srk@ti.com>, Vinay Hegde <vinay.hegde@ti.com>,
        Cyril Chemparathy <cyril@ti.com>,
        Richard Cochran <richard.cochran@omicron.at>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Sascha Hauer <s.hauer@pengutronix.de>, Joe Perches <joe@perches.com>
Subject: [PATCH] davinci_emac: fixed setting MAC at init time
Message-ID: <20120301084239.GA17146@altenpts-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this patch, the MAC number will show up as zero's until the interface
is brought up for the first time. (eg. with ifconfig -a)

Signed-off-by: Bas van den Berg <b.van.den.berg.nl@gmail.com>
---
 drivers/net/ethernet/ti/davinci_emac.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index 4b2f545..11b169a 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -1904,6 +1904,7 @@ static int __devinit davinci_emac_probe(struct platform_device *pdev)
 		dev_warn(&pdev->dev, "using random MAC addr: %pM\n",
 							priv->mac_addr);
 	}
+	memcpy(ndev->dev_addr, priv->mac_addr, ndev->addr_len);
 
 	ndev->netdev_ops = &emac_netdev_ops;
 	SET_ETHTOOL_OPS(ndev, &ethtool_ops);
-- 
1.7.0.4

