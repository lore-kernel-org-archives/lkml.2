Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab2LXI7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 03:59:15 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:48565 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab2LXI7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 03:59:13 -0500
MIME-Version: 1.0
Date: Mon, 24 Dec 2012 16:59:13 +0800
Message-ID: <CAEk7JKYFESRP2wSTzS34d5e2c5FuaW2KhzJaZYwn43j7TruFWg@mail.gmail.com>
Subject: Clear tags in dmar.c
From: "Li, Zhen-Hua" <lizhenhua.dev@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In dmar.c: qi_check_fault, I think the tags should be clear when
finished processing.
See this patch:

--- drivers/iommu/dmar.c.orig   2012-12-25 00:56:16.000000000 +0800
+++ drivers/iommu/dmar.c.new    2012-12-25 00:56:37.000000000 +0800
@@ -759,7 +759,7 @@ static int qi_check_fault(struct intel_i
                                        sizeof(struct qi_desc));
                        __iommu_flush_cache(iommu, &qi->desc[index],
                                        sizeof(struct qi_desc));
-                       writel(DMA_FSTS_IQE, iommu->reg + DMAR_FSTS_REG);
+                       writel(~DMA_FSTS_IQE, iommu->reg + DMAR_FSTS_REG);
                        return -EINVAL;
                }
        }
@@ -775,7 +775,7 @@ static int qi_check_fault(struct intel_i
                tail = readl(iommu->reg + DMAR_IQT_REG);
                tail = ((tail >> DMAR_IQ_SHIFT) - 1 + QI_LENGTH) % QI_LENGTH;

-               writel(DMA_FSTS_ITE, iommu->reg + DMAR_FSTS_REG);
+               writel(~DMA_FSTS_ITE, iommu->reg + DMAR_FSTS_REG);

                do {
                        if (qi->desc_status[head] == QI_IN_USE)
@@ -788,7 +788,7 @@ static int qi_check_fault(struct intel_i
        }

        if (fault & DMA_FSTS_ICE)
-               writel(DMA_FSTS_ICE, iommu->reg + DMAR_FSTS_REG);
+               writel(~DMA_FSTS_ICE, iommu->reg + DMAR_FSTS_REG);

        return 0;
 }
