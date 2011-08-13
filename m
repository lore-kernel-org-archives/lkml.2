Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406Ab1HMEZg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 00:25:36 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51150 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab1HMEZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 00:25:34 -0400
MIME-Version: 1.0
In-Reply-To: <1312822837.1539.38.camel@vkoul-udesk3>
References: <CAJd=RBDCLp0hXNtXVSzUd4De+z9cZLpTDftnxWVGeHauAbsWaQ@mail.gmail.com>
	<1312822837.1539.38.camel@vkoul-udesk3>
Date: Sat, 13 Aug 2011 12:25:32 +0800
Message-ID: <CAJd=RBB+E+=JXtD4zxM8cmnbCsXuu73xtYoaR7qibRqzOVVfCQ@mail.gmail.com>
Subject: [RFC patch resend] DMAengine/Langwell: put tx descriptor in error path
From: Hillf Danton <dhillf@gmail.com>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When preparing LLI based periphral transfer, if error encountered, the newly
prepared tx descriptor should be put for later recycling.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/dma/intel_mid_dma.c	Sat Aug 13 11:44:46 2011
+++ intel_mid_dma.c	Sat Aug 13 12:32:42 2011
@@ -793,6 +793,7 @@ static struct dma_async_tx_descriptor *i
 				32, 0);
 	if (NULL == desc->lli_pool) {
 		pr_err("MID_DMA:LLI pool create failed\n");
+		midc_desc_put(midc, desc);
 		return NULL;
 	}

@@ -800,6 +801,7 @@ static struct dma_async_tx_descriptor *i
 	if (!desc->lli) {
 		pr_err("MID_DMA: LLI alloc failed\n");
 		pci_pool_destroy(desc->lli_pool);
+		midc_desc_put(midc, desc);
 		return NULL;
 	}
