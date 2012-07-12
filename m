Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966Ab2GLGIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 02:08:35 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:62343 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869Ab2GLGId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 02:08:33 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Mark Einon <mark.einon@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Francois Romieu <romieu@fr.zoreil.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 1/2] staging/et131x: use SET_ETHTOOL_OPS directly
Date: Thu, 12 Jul 2012 11:53:17 +0545
Message-Id: <1342073298-11847-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

using a wrapper around SET_ETHTOOL_OPS macro is not actually required,

remove and use SET_ETHTOOL_OPS directly.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/et131x/et131x.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 8f3fc5f..227fca9 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -3943,12 +3943,6 @@ static struct ethtool_ops et131x_ethtool_ops = {
 	.get_regs	= et131x_get_regs,
 	.get_link = ethtool_op_get_link,
 };
-
-static void et131x_set_ethtool_ops(struct net_device *netdev)
-{
-	SET_ETHTOOL_OPS(netdev, &et131x_ethtool_ops);
-}
-
 /**
  * et131x_hwaddr_init - set up the MAC Address on the ET1310
  * @adapter: pointer to our private adapter structure
@@ -5301,7 +5295,7 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 	netdev->netdev_ops     = &et131x_netdev_ops;
 
 	SET_NETDEV_DEV(netdev, &pdev->dev);
-	et131x_set_ethtool_ops(netdev);
+	SET_ETHTOOL_OPS(netdev, &et131x_ethtool_ops);
 
 	adapter = et131x_adapter_init(netdev, pdev);
 
-- 
1.7.9.5

