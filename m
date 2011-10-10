Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab1JJPWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 11:22:46 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51544 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab1JJPWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 11:22:45 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 1/4] staging: et131x: Fix et131x sparse warnings
Date: Mon, 10 Oct 2011 16:21:11 +0100
Message-Id: <1318260072-2711-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following warnings:

et1310_mac.c:375:44: warning: incorrect type in initializer (different address spaces)
et1310_mac.c:382:28: warning: incorrect type in argument 2 (different address spaces)
et1310_mac.c:384:31: warning: incorrect type in argument 2 (different address spaces)
et131x_initpci.c:555:5: warning: symbol 'et131x_mii_probe' was not declared. Should it be static?
et131x_netdev.c:267:5: warning: symbol 'et131x_ioctl' was not declared. Should it be static?
et131x_netdev.c:285:5: warning: symbol 'et131x_set_packet_filter' was not declared. Should it be static?
et131x_netdev.c:347:6: warning: symbol 'et131x_multicast' was not declared. Should it be static?
et131x_netdev.c:420:5: warning: symbol 'et131x_tx' was not declared. Should it be static?
et131x_netdev.c:453:6: warning: symbol 'et131x_tx_timeout' was not declared. Should it be static?
et131x_netdev.c:511:5: warning: symbol 'et131x_change_mtu' was not declared. Should it be static?
et131x_netdev.c:564:5: warning: symbol 'et131x_set_mac_addr' was not declared. Should it be static?

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_mac.c     |    2 +-
 drivers/staging/et131x/et131x_initpci.c |    2 +-
 drivers/staging/et131x/et131x_netdev.c  |   14 +++++++-------
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/et131x/et1310_mac.c b/drivers/staging/et131x/et1310_mac.c
index 017ece7..042bc44 100644
--- a/drivers/staging/et131x/et1310_mac.c
+++ b/drivers/staging/et131x/et1310_mac.c
@@ -372,7 +372,7 @@ void et1310_config_rxmac_regs(struct et131x_adapter *adapter)
 
 void et1310_config_txmac_regs(struct et131x_adapter *adapter)
 {
-	struct txmac_regs *txmac = &adapter->regs->txmac;
+	struct txmac_regs __iomem *txmac = &adapter->regs->txmac;
 
 	/* We need to update the Control Frame Parameters
 	 * cfpt - control frame pause timer set to 64 (0x40)
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 33e50e9..9b2dc55 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -552,7 +552,7 @@ static void et131x_adjust_link(struct net_device *netdev)
 	}
 }
 
-int et131x_mii_probe(struct net_device *netdev)
+static int et131x_mii_probe(struct net_device *netdev)
 {
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 	struct  phy_device *phydev = NULL;
diff --git a/drivers/staging/et131x/et131x_netdev.c b/drivers/staging/et131x/et131x_netdev.c
index bcb4756..62070cf 100644
--- a/drivers/staging/et131x/et131x_netdev.c
+++ b/drivers/staging/et131x/et131x_netdev.c
@@ -264,7 +264,7 @@ int et131x_close(struct net_device *netdev)
  *
  * Returns 0 on success, errno on failure (as defined in errno.h)
  */
-int et131x_ioctl(struct net_device *netdev, struct ifreq *reqbuf, int cmd)
+static int et131x_ioctl(struct net_device *netdev, struct ifreq *reqbuf, int cmd)
 {
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 
@@ -282,7 +282,7 @@ int et131x_ioctl(struct net_device *netdev, struct ifreq *reqbuf, int cmd)
  *
  * Returns 0 on success, errno on failure
  */
-int et131x_set_packet_filter(struct et131x_adapter *adapter)
+static int et131x_set_packet_filter(struct et131x_adapter *adapter)
 {
 	int status = 0;
 	uint32_t filter = adapter->packet_filter;
@@ -344,7 +344,7 @@ int et131x_set_packet_filter(struct et131x_adapter *adapter)
  * et131x_multicast - The handler to configure multicasting on the interface
  * @netdev: a pointer to a net_device struct representing the device
  */
-void et131x_multicast(struct net_device *netdev)
+static void et131x_multicast(struct net_device *netdev)
 {
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 	uint32_t packet_filter = 0;
@@ -417,7 +417,7 @@ void et131x_multicast(struct net_device *netdev)
  *
  * Returns 0 on success, errno on failure (as defined in errno.h)
  */
-int et131x_tx(struct sk_buff *skb, struct net_device *netdev)
+static int et131x_tx(struct sk_buff *skb, struct net_device *netdev)
 {
 	int status = 0;
 
@@ -450,7 +450,7 @@ int et131x_tx(struct sk_buff *skb, struct net_device *netdev)
  * specified by the 'tx_timeo" element in the net_device structure (see
  * et131x_alloc_device() to see how this value is set).
  */
-void et131x_tx_timeout(struct net_device *netdev)
+static void et131x_tx_timeout(struct net_device *netdev)
 {
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 	struct tcb *tcb;
@@ -508,7 +508,7 @@ void et131x_tx_timeout(struct net_device *netdev)
  *
  * Returns 0 on success, errno on failure (as defined in errno.h)
  */
-int et131x_change_mtu(struct net_device *netdev, int new_mtu)
+static int et131x_change_mtu(struct net_device *netdev, int new_mtu)
 {
 	int result = 0;
 	struct et131x_adapter *adapter = netdev_priv(netdev);
@@ -561,7 +561,7 @@ int et131x_change_mtu(struct net_device *netdev, int new_mtu)
  *
  * IMPLEMENTED BY : blux http://berndlux.de 22.01.2007 21:14
  */
-int et131x_set_mac_addr(struct net_device *netdev, void *new_mac)
+static int et131x_set_mac_addr(struct net_device *netdev, void *new_mac)
 {
 	int result = 0;
 	struct et131x_adapter *adapter = netdev_priv(netdev);
-- 
1.7.6.4

