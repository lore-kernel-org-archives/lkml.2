Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab1IUJfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:35:48 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43407 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab1IUJfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:35:43 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net
Subject: [PATCH 47/57] spi: irq: Remove IRQF_DISABLED
Date: Wed, 21 Sep 2011 17:28:48 +0800
Message-Id: <1316597339-29861-48-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
References: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [c58543c8: genirq: Run irq handlers with interrupts disabled],
We run all interrupt handlers with interrupts disabled
and we even check and yell when an interrupt handler
returns with interrupts enabled (see commit [b738a50a:
genirq: Warn when handler enables interrupts]).

So now this flag is a NOOP and can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/spi/spi-bfin5xx.c       |    2 +-
 drivers/spi/spi-coldfire-qspi.c |    2 +-
 drivers/spi/spi-ppc4xx.c        |    2 +-
 drivers/spi/spi-sh-msiof.c      |    2 +-
 drivers/spi/spi-sh.c            |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-bfin5xx.c b/drivers/spi/spi-bfin5xx.c
index b8d25f2..3b83ff8 100644
--- a/drivers/spi/spi-bfin5xx.c
+++ b/drivers/spi/spi-bfin5xx.c
@@ -1098,7 +1098,7 @@ static int bfin_spi_setup(struct spi_device *spi)
 
 	if (chip->pio_interrupt && !drv_data->irq_requested) {
 		ret = request_irq(drv_data->spi_irq, bfin_spi_pio_irq_handler,
-			IRQF_DISABLED, "BFIN_SPI", drv_data);
+			0, "BFIN_SPI", drv_data);
 		if (ret) {
 			dev_err(&spi->dev, "Unable to register spi IRQ\n");
 			goto error;
diff --git a/drivers/spi/spi-coldfire-qspi.c b/drivers/spi/spi-coldfire-qspi.c
index ae2cd1c..7397c4d 100644
--- a/drivers/spi/spi-coldfire-qspi.c
+++ b/drivers/spi/spi-coldfire-qspi.c
@@ -487,7 +487,7 @@ static int __devinit mcfqspi_probe(struct platform_device *pdev)
 		goto fail2;
 	}
 
-	status = request_irq(mcfqspi->irq, mcfqspi_irq_handler, IRQF_DISABLED,
+	status = request_irq(mcfqspi->irq, mcfqspi_irq_handler, 0,
 			     pdev->name, mcfqspi);
 	if (status) {
 		dev_dbg(&pdev->dev, "request_irq failed\n");
diff --git a/drivers/spi/spi-ppc4xx.c b/drivers/spi/spi-ppc4xx.c
index b267fd9..8ec43e0 100644
--- a/drivers/spi/spi-ppc4xx.c
+++ b/drivers/spi/spi-ppc4xx.c
@@ -514,7 +514,7 @@ static int __init spi_ppc4xx_of_probe(struct platform_device *op)
 	/* Request IRQ */
 	hw->irqnum = irq_of_parse_and_map(np, 0);
 	ret = request_irq(hw->irqnum, spi_ppc4xx_int,
-			  IRQF_DISABLED, "spi_ppc4xx_of", (void *)hw);
+			  0, "spi_ppc4xx_of", (void *)hw);
 	if (ret) {
 		dev_err(dev, "unable to allocate interrupt\n");
 		goto free_gpios;
diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
index 2f61a84..51b14c9 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -636,7 +636,7 @@ static int sh_msiof_spi_probe(struct platform_device *pdev)
 		goto err2;
 	}
 
-	ret = request_irq(i, sh_msiof_spi_irq, IRQF_DISABLED,
+	ret = request_irq(i, sh_msiof_spi_irq, 0,
 			  dev_name(&pdev->dev), p);
 	if (ret) {
 		dev_err(&pdev->dev, "unable to request irq\n");
diff --git a/drivers/spi/spi-sh.c b/drivers/spi/spi-sh.c
index 9eedd71..e0343d4 100644
--- a/drivers/spi/spi-sh.c
+++ b/drivers/spi/spi-sh.c
@@ -484,7 +484,7 @@ static int __devinit spi_sh_probe(struct platform_device *pdev)
 		goto error2;
 	}
 
-	ret = request_irq(irq, spi_sh_irq, IRQF_DISABLED, "spi_sh", ss);
+	ret = request_irq(irq, spi_sh_irq, 0, "spi_sh", ss);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "request_irq error\n");
 		goto error3;
-- 
1.7.4.1

