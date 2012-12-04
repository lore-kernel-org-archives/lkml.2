Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab2LDH6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 02:58:43 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:29900 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab2LDH6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 02:58:41 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, richard.genoud@gmail.com, JM.Lin@atmel.com,
        wenyou.yang@atmel.com, grant.likely@secretlab.ca,
        spi-devel-general@lists.sourceforge.net
Subject: [v2 PATCH 03/14] spi/atmel_spi: add physical base address
Date: Tue,  4 Dec 2012 15:53:49 +0800
Message-Id: <1354607640-13229-4-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354607640-13229-1-git-send-email-wenyou.yang@atmel.com>
References: <1354607640-13229-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 04 Dec 2012 07:58:23.0421 (UTC) FILETIME=[222D76D0:01CDD1F5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>

Needed for future use with dmaengine enabled driver.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: grant.likely@secretlab.ca
Cc: spi-devel-general@lists.sourceforge.net
---
 drivers/spi/spi-atmel.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 16d6a83..2e040be 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -188,6 +188,7 @@
 struct atmel_spi {
 	spinlock_t		lock;
 
+	resource_size_t		phybase;
 	void __iomem		*regs;
 	int			irq;
 	struct clk		*clk;
@@ -961,6 +962,7 @@ static int __devinit atmel_spi_probe(struct platform_device *pdev)
 	as->regs = ioremap(regs->start, resource_size(regs));
 	if (!as->regs)
 		goto out_free_buffer;
+	as->phybase = regs->start;
 	as->irq = irq;
 	as->clk = clk;
 
-- 
1.7.9.5

