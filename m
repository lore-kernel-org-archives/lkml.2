Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab1KBNOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 09:14:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46976 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab1KBNON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 09:14:13 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: davem@davemloft.net, ian.campbell@citrix.com, eric.dumazet@gmail.com,
        jeffrey.t.kirsher@intel.com, jpirko@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] ll_temac: Add support for phy_mii_ioctl
Date: Wed,  2 Nov 2011 14:14:06 +0100
Message-Id: <1320239646-15377-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the ioctl support for the driver. So userspace
programs like mii-tool can work.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 4d1658e..b26e5ee 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -915,12 +915,26 @@ temac_poll_controller(struct net_device *ndev)
 }
 #endif
 
+static int temac_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
+{
+	struct temac_local *lp = netdev_priv(ndev);
+
+	if (!netif_running(ndev))
+		return -EINVAL;
+
+	if (!lp->phy_dev)
+		return -EINVAL;
+
+	return phy_mii_ioctl(lp->phy_dev, rq, cmd);
+}
+
 static const struct net_device_ops temac_netdev_ops = {
 	.ndo_open = temac_open,
 	.ndo_stop = temac_stop,
 	.ndo_start_xmit = temac_start_xmit,
 	.ndo_set_mac_address = netdev_set_mac_address,
 	.ndo_validate_addr = eth_validate_addr,
+	.ndo_do_ioctl = temac_ioctl,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller = temac_poll_controller,
 #endif
-- 
1.7.7.1

