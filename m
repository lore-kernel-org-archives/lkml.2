Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030385Ab2JSET1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 00:19:27 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55133 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752758Ab2JSEOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 00:14:32 -0400
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH net-next 07/21] infiniband: Convert is_<foo>_ether_addr uses to eth_addr_<foo>
Date: Thu, 18 Oct 2012 21:14:11 -0700
Message-Id: <edc1c1b7e0ed06854627d4f3f5bf39d8236ec296.1350618011.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1350618006.git.joe@perches.com>
References: <cover.1350618006.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the old ether_addr tests to eth_addr_<foo>.
Adds api consistency.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/infiniband/hw/amso1100/c2.c |    2 +-
 drivers/infiniband/hw/nes/nes_nic.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/c2.c b/drivers/infiniband/hw/amso1100/c2.c
index 5ce7b9e..3bb307c 100644
--- a/drivers/infiniband/hw/amso1100/c2.c
+++ b/drivers/infiniband/hw/amso1100/c2.c
@@ -908,7 +908,7 @@ static struct net_device *c2_devinit(struct c2_dev *c2dev,
 	memcpy_fromio(netdev->dev_addr, mmio_addr + C2_REGS_ENADDR, 6);
 
 	/* Validate the MAC address */
-	if (!is_valid_ether_addr(netdev->dev_addr)) {
+	if (!eth_addr_valid(netdev->dev_addr)) {
 		pr_debug("Invalid MAC Address\n");
 		c2_print_macaddr(netdev);
 		free_netdev(netdev);
diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index 0564be7..3cd7d38 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -809,7 +809,7 @@ static int nes_netdev_set_mac_address(struct net_device *netdev, void *p)
 	u32 macaddr_low;
 	u16 macaddr_high;
 
-	if (!is_valid_ether_addr(mac_addr->sa_data))
+	if (!eth_addr_valid(mac_addr->sa_data))
 		return -EADDRNOTAVAIL;
 
 	memcpy(netdev->dev_addr, mac_addr->sa_data, netdev->addr_len);
-- 
1.7.8.111.gad25c.dirty

