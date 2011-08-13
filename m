Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab1HMEb2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 00:31:28 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51631 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab1HMEb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 00:31:27 -0400
MIME-Version: 1.0
In-Reply-To: <1312824109.1539.39.camel@vkoul-udesk3>
References: <CAJd=RBCO=Hhb4oCsmXgQ+HHRL6CWCDe6yRvo7wg+qXOcr6UsAg@mail.gmail.com>
	<1312824109.1539.39.camel@vkoul-udesk3>
Date: Sat, 13 Aug 2011 12:31:26 +0800
Message-ID: <CAJd=RBBhEtRW4gxqzyN6PerCFen9mujH5KUb0kx3wMBUYpC0qg@mail.gmail.com>
Subject: [RFC patch resend] DMAengine/Langwell: put dev object in error path
From: Hillf Danton <dhillf@gmail.com>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When allocating resources for DMA channel, if error encountered, the dev object
of the relevant DMA device should be put, corresponding to the get operation.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/dma/intel_mid_dma.c	Sat Aug 13 11:44:46 2011
+++ intel_mid_dma.c	Sat Aug 13 12:39:53 2011
@@ -871,6 +871,7 @@ static int intel_mid_dma_alloc_chan_reso
 	if (mid->state == SUSPENDED) {
 		if (dma_resume(mid->pdev)) {
 			pr_err("ERR_MDMA: resume failed");
+			pm_runtime_put(&mid->pdev->dev);
 			return -EFAULT;
 		}
 	}
