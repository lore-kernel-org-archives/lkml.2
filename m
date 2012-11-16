Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745Ab2KPKRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 05:17:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35798 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2KPKRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 05:17:16 -0500
Message-ID: <50A612AA.7040206@canonical.com>
Date: Fri, 16 Nov 2012 11:17:14 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: x86@kernel.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: bump PREALLOC_DMA_DEBUG_ENTRIES
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I ran out of free entries when I had CONFIG_DMA_API_DEBUG enabled.
Some other archs seem to default to 65536, so increase this limit for x86 too.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
----
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index de2b7ad..f5597c5 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -56,7 +56,7 @@ struct device x86_dma_fallback_dev = {
 EXPORT_SYMBOL(x86_dma_fallback_dev);
 
 /* Number of entries preallocated for DMA-API debugging */
-#define PREALLOC_DMA_DEBUG_ENTRIES       32768
+#define PREALLOC_DMA_DEBUG_ENTRIES       65536
 
 int dma_set_mask(struct device *dev, u64 mask)
 {

