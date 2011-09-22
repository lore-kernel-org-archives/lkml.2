Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab1IVJEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 05:04:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33503 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab1IVJES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 05:04:18 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        "Kai.Jiang" <Kai.Jiang@freescale.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mike Williams <mike@mikebwilliams.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Michal Marek <mmarek@suse.cz>
Subject: [PATCH 31/55] EDAC: irq: Remove IRQF_DISABLED
Date: Thu, 22 Sep 2011 16:58:58 +0800
Message-Id: <1316681962-8217-32-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com>
References: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [e58aa3d2: genirq: Run irq handlers with interrupts disabled],
We run all interrupt handlers with interrupts disabled
and we even check and yell when an interrupt handler
returns with interrupts enabled (see commit [b738a50a:
genirq: Warn when handler enables interrupts]).

So now this flag is a NOOP and can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 drivers/edac/mpc85xx_edac.c |    6 +++---
 drivers/edac/mv64x60_edac.c |    8 ++++----
 drivers/edac/ppc4xx_edac.c  |    4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index 8af8e86..5cf8620 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -275,7 +275,7 @@ static int __devinit mpc85xx_pci_err_probe(struct platform_device *op)
 	if (edac_op_state == EDAC_OPSTATE_INT) {
 		pdata->irq = irq_of_parse_and_map(op->dev.of_node, 0);
 		res = devm_request_irq(&op->dev, pdata->irq,
-				       mpc85xx_pci_isr, IRQF_DISABLED,
+				       mpc85xx_pci_isr, 0,
 				       "[EDAC] PCI err", pci);
 		if (res < 0) {
 			printk(KERN_ERR
@@ -577,7 +577,7 @@ static int __devinit mpc85xx_l2_err_probe(struct platform_device *op)
 	if (edac_op_state == EDAC_OPSTATE_INT) {
 		pdata->irq = irq_of_parse_and_map(op->dev.of_node, 0);
 		res = devm_request_irq(&op->dev, pdata->irq,
-				       mpc85xx_l2_isr, IRQF_DISABLED,
+				       mpc85xx_l2_isr, 0,
 				       "[EDAC] L2 err", edac_dev);
 		if (res < 0) {
 			printk(KERN_ERR
@@ -1057,7 +1057,7 @@ static int __devinit mpc85xx_mc_err_probe(struct platform_device *op)
 		pdata->irq = irq_of_parse_and_map(op->dev.of_node, 0);
 		res = devm_request_irq(&op->dev, pdata->irq,
 				       mpc85xx_mc_isr,
-					IRQF_DISABLED | IRQF_SHARED,
+					IRQF_SHARED,
 				       "[EDAC] MC err", mci);
 		if (res < 0) {
 			printk(KERN_ERR "%s: Unable to request irq %d for "
diff --git a/drivers/edac/mv64x60_edac.c b/drivers/edac/mv64x60_edac.c
index 7e5ff36..224d9f1 100644
--- a/drivers/edac/mv64x60_edac.c
+++ b/drivers/edac/mv64x60_edac.c
@@ -178,7 +178,7 @@ static int __devinit mv64x60_pci_err_probe(struct platform_device *pdev)
 		res = devm_request_irq(&pdev->dev,
 				       pdata->irq,
 				       mv64x60_pci_isr,
-				       IRQF_DISABLED,
+				       0,
 				       "[EDAC] PCI err",
 				       pci);
 		if (res < 0) {
@@ -345,7 +345,7 @@ static int __devinit mv64x60_sram_err_probe(struct platform_device *pdev)
 		res = devm_request_irq(&pdev->dev,
 				       pdata->irq,
 				       mv64x60_sram_isr,
-				       IRQF_DISABLED,
+				       0,
 				       "[EDAC] SRAM err",
 				       edac_dev);
 		if (res < 0) {
@@ -540,7 +540,7 @@ static int __devinit mv64x60_cpu_err_probe(struct platform_device *pdev)
 		res = devm_request_irq(&pdev->dev,
 				       pdata->irq,
 				       mv64x60_cpu_isr,
-				       IRQF_DISABLED,
+				       0,
 				       "[EDAC] CPU err",
 				       edac_dev);
 		if (res < 0) {
@@ -785,7 +785,7 @@ static int __devinit mv64x60_mc_err_probe(struct platform_device *pdev)
 		res = devm_request_irq(&pdev->dev,
 				       pdata->irq,
 				       mv64x60_mc_isr,
-				       IRQF_DISABLED,
+				       0,
 				       "[EDAC] MC err",
 				       mci);
 		if (res < 0) {
diff --git a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
index 3840096..2c36d4a 100644
--- a/drivers/edac/ppc4xx_edac.c
+++ b/drivers/edac/ppc4xx_edac.c
@@ -1122,7 +1122,7 @@ ppc4xx_edac_register_irq(struct platform_device *op, struct mem_ctl_info *mci)
 
 	status = request_irq(ded_irq,
 			     ppc4xx_edac_isr,
-			     IRQF_DISABLED,
+			     0,
 			     "[EDAC] MC ECCDED",
 			     mci);
 
@@ -1136,7 +1136,7 @@ ppc4xx_edac_register_irq(struct platform_device *op, struct mem_ctl_info *mci)
 
 	status = request_irq(sec_irq,
 			     ppc4xx_edac_isr,
-			     IRQF_DISABLED,
+			     0,
 			     "[EDAC] MC ECCSEC",
 			     mci);
 
-- 
1.7.4.1

