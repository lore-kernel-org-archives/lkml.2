Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab1LUOdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 09:33:05 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54893 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab1LUOcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 09:32:20 -0500
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Michal Simek <monstr@monstr.eu>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Ryan Mallon <rmallon@gmail.com>
Subject: [PATCH 3/4] input: xilinx_ps2: Don't use NO_IRQ
Date: Wed, 21 Dec 2011 15:32:11 +0100
Message-Id: <1324477932-19262-3-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1324477932-19262-2-git-send-email-monstr@monstr.eu>
References: <1324477932-19262-1-git-send-email-monstr@monstr.eu>
 <1324477932-19262-2-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers shouldn't use NO_IRQ. Microblaze and PPC
define NO_IRQ as 0 and this reference will be removed
in near future.

Signed-off-by: Michal Simek <monstr@monstr.eu>
CC: Grant Likely <grant.likely@secretlab.ca>
CC: Rob Herring <rob.herring@calxeda.com>
CC: Ryan Mallon <rmallon@gmail.com>
---
 drivers/input/serio/xilinx_ps2.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/serio/xilinx_ps2.c b/drivers/input/serio/xilinx_ps2.c
index d64c5a4..f3e54b9 100644
--- a/drivers/input/serio/xilinx_ps2.c
+++ b/drivers/input/serio/xilinx_ps2.c
@@ -253,7 +253,7 @@ static int __devinit xps2_of_probe(struct platform_device *ofdev)
 	}
 
 	/* Get IRQ for the device */
-	if (of_irq_to_resource(ofdev->dev.of_node, 0, &r_irq) == NO_IRQ) {
+	if (!of_irq_to_resource(ofdev->dev.of_node, 0, &r_irq)) {
 		dev_err(dev, "no IRQ found\n");
 		return -ENODEV;
 	}
-- 
1.7.5.4

