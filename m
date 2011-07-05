Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab1GERnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 13:43:49 -0400
Received: from mail.perches.com ([173.55.12.10]:3593 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239Ab1GERns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 13:43:48 -0400
From: Joe Perches <joe@perches.com>
To: Gary Zambrano <zambrano@broadcom.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] b44: Use pr_<level>_once and DRV_DESCRIPTION
Date: Tue,  5 Jul 2011 10:43:46 -0700
Message-Id: <c57bb53427d6b56cf18ef7302033e58ef5eb92fb.1309887804.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.131.g99019
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert a printk with a static to pr_<level>_once
Add and use DRV_DESCRIPTION to reduce string duplication.
Remove now unused version.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/b44.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/b44.c b/drivers/net/b44.c
index cced4fd..6acf73d 100644
--- a/drivers/net/b44.c
+++ b/drivers/net/b44.c
@@ -39,6 +39,7 @@
 
 #define DRV_MODULE_NAME		"b44"
 #define DRV_MODULE_VERSION	"2.0"
+#define DRV_DESCRIPTION		"Broadcom 44xx/47xx 10/100 PCI ethernet driver"
 
 #define B44_DEF_MSG_ENABLE	  \
 	(NETIF_MSG_DRV		| \
@@ -91,11 +92,8 @@
 #define B44_ETHIPV6UDP_HLEN	62
 #define B44_ETHIPV4UDP_HLEN	42
 
-static char version[] __devinitdata =
-	DRV_MODULE_NAME ".c:v" DRV_MODULE_VERSION "\n";
-
 MODULE_AUTHOR("Felix Fietkau, Florian Schirmer, Pekka Pietikainen, David S. Miller");
-MODULE_DESCRIPTION("Broadcom 44xx/47xx 10/100 PCI ethernet driver");
+MODULE_DESCRIPTION(DRV_DESCRIPTION);
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_MODULE_VERSION);
 
@@ -2130,16 +2128,13 @@ static const struct net_device_ops b44_netdev_ops = {
 static int __devinit b44_init_one(struct ssb_device *sdev,
 				  const struct ssb_device_id *ent)
 {
-	static int b44_version_printed = 0;
 	struct net_device *dev;
 	struct b44 *bp;
 	int err;
 
 	instance++;
 
-	if (b44_version_printed++ == 0)
-		pr_info("%s", version);
-
+	pr_info_once("%s version %s\n", DRV_DESCRIPTION, DRV_MODULE_VERSION);
 
 	dev = alloc_etherdev(sizeof(*bp));
 	if (!dev) {
@@ -2225,8 +2220,7 @@ static int __devinit b44_init_one(struct ssb_device *sdev,
 	if (b44_phy_reset(bp) < 0)
 		bp->phy_addr = B44_PHY_ADDR_NO_PHY;
 
-	netdev_info(dev, "Broadcom 44xx/47xx 10/100BaseT Ethernet %pM\n",
-		    dev->dev_addr);
+	netdev_info(dev, "%s %pM\n", DRV_DESCRIPTION, dev->dev_addr);
 
 	return 0;
 
-- 
1.7.6.131.g99019

