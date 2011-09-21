Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab1IUNBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 09:01:48 -0400
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:54612 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753770Ab1IUNBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 09:01:47 -0400
From: Daniel Drake <dsd@laptop.org>
To: grant.likely@secretlab.ca
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
Cc: dilinger@queued.net
Subject: [PATCH 2/3] mfd: link vx855 GPIO cell with device tree
Message-Id: <20110921120207.AD6719D401D@zog.reactivated.net>
Date: Wed, 21 Sep 2011 13:02:07 +0100 (BST)
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=fCaE1IvjAYoA:10 a=vJ1w_8FsMGIA:10 a=Op-mwl0xAAAA:8 a=Yw2oxTKiaapzeAHUPnIA:9 a=d4CUUju0HPYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The child driver will then pass the handle to gpiolib, which
enables device-tree-probed gpio-leds and more.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/mfd/vx855.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/vx855.c b/drivers/mfd/vx855.c
index d698703..6466c21 100644
--- a/drivers/mfd/vx855.c
+++ b/drivers/mfd/vx855.c
@@ -101,6 +101,11 @@ static __devinit int vx855_probe(struct pci_dev *pdev,
 	vx855_gpio_resources[1].start = gpio_io_offset + VX855_PMIO_R_GPO;
 	vx855_gpio_resources[1].end = vx855_gpio_resources[1].start + 3;
 
+#ifdef CONFIG_OF_GPIO
+	vx855_cells[0].of_node = of_find_compatible_node(NULL, NULL,
+							 "via,vx855-gpio");
+#endif
+
 	ret = mfd_add_devices(&pdev->dev, -1, vx855_cells, ARRAY_SIZE(vx855_cells),
 			NULL, 0);
 
-- 
1.7.6.2

