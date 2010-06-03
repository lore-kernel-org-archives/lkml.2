Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750977Ab0FCEGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 00:06:18 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37778 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab0FCEGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 00:06:11 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: devicetree-discuss@ozlabs.org
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 2/2] of/crypto: n2_core: fix build breakage
Date: Thu,  3 Jun 2010 06:03:47 +0200
Message-Id: <1275537827-28921-2-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <AANLkTikNcAvyHf1yHPweNBVSCSPNmq-JaEOgYW2FYUGJ@mail.gmail.com>
References: <AANLkTikNcAvyHf1yHPweNBVSCSPNmq-JaEOgYW2FYUGJ@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/crypto/n2_core.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 8566be8..3f813d3 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1398,7 +1398,7 @@ static int find_devino_index(struct of_device *dev, struct spu_mdesc_info *ip,
 
 	intr = ip->ino_table[i].intr;
 
-	dev_intrs = of_get_property(dev->node, "interrupts", NULL);
+	dev_intrs = of_get_property(dev->dev.of_node, "interrupts", NULL);
 	if (!dev_intrs)
 		return -ENODEV;
 
@@ -1574,7 +1574,7 @@ static int spu_mdesc_walk_arcs(struct mdesc_handle *mdesc,
 		id = mdesc_get_property(mdesc, tgt, "id", NULL);
 		if (table[*id] != NULL) {
 			dev_err(&dev->dev, "%s: SPU cpu slot already set.\n",
-				dev->node->full_name);
+				dev->dev.of_node->full_name);
 			return -EINVAL;
 		}
 		cpu_set(*id, p->sharing);
@@ -1595,7 +1595,7 @@ static int handle_exec_unit(struct spu_mdesc_info *ip, struct list_head *list,
 	p = kzalloc(sizeof(struct spu_queue), GFP_KERNEL);
 	if (!p) {
 		dev_err(&dev->dev, "%s: Could not allocate SPU queue.\n",
-			dev->node->full_name);
+			dev->dev.of_node->full_name);
 		return -ENOMEM;
 	}
 
@@ -1684,7 +1684,7 @@ static int __devinit grab_mdesc_irq_props(struct mdesc_handle *mdesc,
 	const unsigned int *reg;
 	u64 node;
 
-	reg = of_get_property(dev->node, "reg", NULL);
+	reg = of_get_property(dev->dev.of_node, "reg", NULL);
 	if (!reg)
 		return -ENODEV;
 
@@ -1836,7 +1836,7 @@ static int __devinit n2_crypto_probe(struct of_device *dev,
 
 	n2_spu_driver_version();
 
-	full_name = dev->node->full_name;
+	full_name = dev->dev.of_node->full_name;
 	pr_info("Found N2CP at %s\n", full_name);
 
 	np = alloc_n2cp();
@@ -1948,7 +1948,7 @@ static int __devinit n2_mau_probe(struct of_device *dev,
 
 	n2_spu_driver_version();
 
-	full_name = dev->node->full_name;
+	full_name = dev->dev.of_node->full_name;
 	pr_info("Found NCP at %s\n", full_name);
 
 	mp = alloc_ncp();
-- 
1.7.0

