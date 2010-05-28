Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab0E1R6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 13:58:36 -0400
Received: from mxout1.idt.com ([157.165.5.25]:50661 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631Ab0E1R60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 13:58:26 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
       Matt Porter <mporter@kernel.crashing.org>,
       Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Thomas Moll <thomas.moll@sysgo.com>
Subject: [PATCH -next] RapidIO,powerpc/85xx: fix device node pointer
Date: Fri, 28 May 2010 13:56:17 -0400
Message-Id: <1275069378-21548-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes compile problem caused by overlapped patches.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Moll <thomas.moll@sysgo.com>
---
 arch/powerpc/sysdev/fsl_rio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index cd37e49..30e1626 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -1426,7 +1426,7 @@ int fsl_rio_setup(struct of_device *dev)
 	port->iores.flags = IORESOURCE_MEM;
 	port->iores.name = "rio_io_win";
 
-	priv->pwirq   = irq_of_parse_and_map(dev->node, 0);
+	priv->pwirq   = irq_of_parse_and_map(dev->dev.of_node, 0);
 	priv->bellirq = irq_of_parse_and_map(dev->dev.of_node, 2);
 	priv->txirq = irq_of_parse_and_map(dev->dev.of_node, 3);
 	priv->rxirq = irq_of_parse_and_map(dev->dev.of_node, 4);
-- 
1.7.0.5

