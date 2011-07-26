Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab1GZMs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 08:48:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56081 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab1GZMsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 08:48:50 -0400
MIME-Version: 1.0
Date: Tue, 26 Jul 2011 20:48:49 +0800
Message-ID: <CAJd=RBCx=PGqynuogmq-1M-2JtSLvGRM=2Pm8mjZRARB5ctB0A@mail.gmail.com>
Subject: [RFC patch] DMAengine/Langwell: unmap IO region in error path
From: Hillf Danton <dhillf@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When setting up the Langwell DMA controller, if error encountered, the newly
mapped IO region should be unmapped.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---
 drivers/dma/intel_mid_dma.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index f653517..4c9a572 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -1199,6 +1199,8 @@ static int mid_setup_dma(struct pci_dev *pdev)
 err_engine:
 	free_irq(pdev->irq, dma);
 err_irq:
+	if (dma->mask_reg)
+		iounmap(dma->mask_reg);
 	pci_pool_destroy(dma->dma_pool);
 err_dma_pool:
 	pr_err("ERR_MDMA:setup_dma failed: %d\n", err);
