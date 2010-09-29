Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab0I2Fwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 01:52:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56054 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab0I2Fwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 01:52:42 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, edgar.iglesias@gmail.com, duyl@xilinx.com,
        linnj@xilinx.com, grant.likely@secretlab.ca,
        microblaze-uclinux@itee.uq.edu.au, Michal Simek <monstr@monstr.eu>,
        Tejun Heo <tj@kernel.org>, Anton Vorontsov <avorontsov@ru.mvista.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 1/7] of: GPIO: Fix OF probing on little-endian systems
Date: Wed, 29 Sep 2010 15:52:12 +1000
Message-Id: <1285739538-29058-2-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1285739538-29058-1-git-send-email-monstr@monstr.eu>
References: <1285739538-29058-1-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DTB is always big-endian that's why is necessary
to convert it.

Signed-off-by: Michal Simek <monstr@monstr.eu>
CC: Grant Likely <grant.likely@secretlab.ca>
CC: Tejun Heo <tj@kernel.org>
CC: Anton Vorontsov <avorontsov@ru.mvista.com>
CC: linux-kernel@vger.kernel.org
CC: devicetree-discuss@lists.ozlabs.org
---
 drivers/gpio/xilinx_gpio.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/xilinx_gpio.c b/drivers/gpio/xilinx_gpio.c
index 7096909..846fbd5 100644
--- a/drivers/gpio/xilinx_gpio.c
+++ b/drivers/gpio/xilinx_gpio.c
@@ -171,13 +171,13 @@ static int __devinit xgpio_of_probe(struct device_node *np)
 	/* Update GPIO state shadow register with default value */
 	tree_info = of_get_property(np, "xlnx,dout-default", NULL);
 	if (tree_info)
-		chip->gpio_state = *tree_info;
+		chip->gpio_state = be32_to_cpup(tree_info);
 
 	/* Update GPIO direction shadow register with default value */
 	chip->gpio_dir = 0xFFFFFFFF; /* By default, all pins are inputs */
 	tree_info = of_get_property(np, "xlnx,tri-default", NULL);
 	if (tree_info)
-		chip->gpio_dir = *tree_info;
+		chip->gpio_dir = be32_to_cpup(tree_info);
 
 	/* Check device node and parent device node for device width */
 	chip->mmchip.gc.ngpio = 32; /* By default assume full GPIO controller */
@@ -186,7 +186,7 @@ static int __devinit xgpio_of_probe(struct device_node *np)
 		tree_info = of_get_property(np->parent,
 					    "xlnx,gpio-width", NULL);
 	if (tree_info)
-		chip->mmchip.gc.ngpio = *tree_info;
+		chip->mmchip.gc.ngpio = be32_to_cpup(tree_info);
 
 	spin_lock_init(&chip->gpio_lock);
 
-- 
1.5.5.1

