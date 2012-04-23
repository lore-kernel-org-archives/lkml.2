Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab2DWN42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 09:56:28 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:45199 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab2DWN40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 09:56:26 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Keping Chen <chenkeping@huawei.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v1 3/8] dmaengine: introduce CONFIG_DMA_ENGINE_HOTPLUG for DMA device hotplug
Date: Mon, 23 Apr 2012 21:51:44 +0800
Message-Id: <1335189109-4871-4-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335189109-4871-1-git-send-email-jiang.liu@huawei.com>
References: <1335189109-4871-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce CONFIG_DMA_ENGINE_HOTPLUG to enable/disable DMA device hotplug logic.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/dma/Kconfig |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index cf9da36..aba92f0 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -62,6 +62,7 @@ config INTEL_IOATDMA
 	depends on PCI && X86
 	select DMA_ENGINE
 	select DCA
+	select DMA_ENGINE_HOTPLUG
 	select ASYNC_TX_DISABLE_PQ_VAL_DMA
 	select ASYNC_TX_DISABLE_XOR_VAL_DMA
 	help
@@ -263,6 +264,11 @@ config DMA_SA11X0
 config DMA_ENGINE
 	bool
 
+config DMA_ENGINE_HOTPLUG
+	bool
+	default n
+	depends on DMA_ENGINE
+
 comment "DMA Clients"
 	depends on DMA_ENGINE
 
-- 
1.7.5.4

