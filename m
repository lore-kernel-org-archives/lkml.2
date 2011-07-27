Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab1G0NYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 09:24:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39150 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab1G0NYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 09:24:32 -0400
MIME-Version: 1.0
Date: Wed, 27 Jul 2011 21:24:32 +0800
Message-ID: <CAJd=RBCO=Hhb4oCsmXgQ+HHRL6CWCDe6yRvo7wg+qXOcr6UsAg@mail.gmail.com>
Subject: [RFC patch] DMAengine/Langwell: put dev object in error path
From: Hillf Danton <dhillf@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When allocating resources for DMA channel, if error encountered, the dev object
of the relevant DMA device should be put, corresponding to the get operation.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---
 drivers/dma/intel_mid_dma.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index f653517..85bd8f3 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -871,6 +871,7 @@ static int
intel_mid_dma_alloc_chan_resources(struct dma_chan *chan)
 	if (mid->state == SUSPENDED) {
 		if (dma_resume(mid->pdev)) {
 			pr_err("ERR_MDMA: resume failed");
+			pm_runtime_put(&mid->pdev->dev);
 			return -EFAULT;
 		}
 	}
