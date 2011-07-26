Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab1GZMqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 08:46:46 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34713 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab1GZMqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 08:46:39 -0400
MIME-Version: 1.0
Date: Tue, 26 Jul 2011 20:46:38 +0800
Message-ID: <CAJd=RBCykRq99Xsaq97vOkQvJ5GK_RkTBSQibsGnMXuXQbDOCg@mail.gmail.com>
Subject: [RFC patch] DMAengine/Langwell: destroy PCI DMA pool in error path
From: Hillf Danton <dhillf@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When setting up the Langwell DMA controller, if error encountered, the newly
created PCI DMA pool should be destroied.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---
 drivers/dma/intel_mid_dma.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index f653517..130bb77 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -1100,6 +1100,7 @@ static int mid_setup_dma(struct pci_dev *pdev)
 					LNW_PERIPHRAL_MASK_SIZE);
 		if (dma->mask_reg == NULL) {
 			pr_err("ERR_MDMA:Can't map periphral intr space !!\n");
+			pci_pool_destroy(dma->dma_pool);
 			return -ENOMEM;
 		}
 	} else
