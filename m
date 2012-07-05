Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab2GEK3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 06:29:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59990 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755716Ab2GEK3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 06:29:54 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 3/7 v2] sh: remove unused DMA device pointer from SIU platform data
Date: Thu,  5 Jul 2012 12:29:39 +0200
Message-Id: <1341484183-10757-4-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1341484183-10757-1-git-send-email-g.liakhovetski@gmx.de>
References: <1341484183-10757-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:epv4LjwCh4uKy0Kgi8SWDIqsq/EViq5PaDz/FR93Ofa
 RU9DDmxC6YWr9qpera3QbKIuTsit6Mm9BUpKVFoblWrub6kXT+
 Kvl+285b7FvOXfi4gZljsUQNmtFat31H5s+PpQLU4I0DtbDyTz
 exJBVLf/p+W89k13zwmx5WzLEC45JSfQLwYlauNU4qo1OZI41+
 +CJr34ao8OKGUpC7/lziSE1CFE58KjUy8sBN8cDUOtYG6LX9Dj
 huO2yRbOhCDeCiKYbxmR1LnP7LpFzLtrKYx/e3eIMCTPIXpJFf
 qb3ZuRvzEXEICCI9U9JMlmhcrXPMDhdJSTlnZZMrDyk6RG8GUC
 25WWB2pi1jTaXPQLjawxvniWOjDianMF31aPi1wKWXeQF7dGuQ
 AeWnsZXWTq2sg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SIU ALSA driver is not using the DMA device pointer for DMA channel
filtering any more, it can be now removed.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/include/asm/siu.h              |    1 -
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/sh/include/asm/siu.h b/arch/sh/include/asm/siu.h
index 1d95c78..580b7ac 100644
--- a/arch/sh/include/asm/siu.h
+++ b/arch/sh/include/asm/siu.h
@@ -14,7 +14,6 @@
 struct device;
 
 struct siu_platform {
-	struct device *dma_dev;
 	unsigned int dma_slave_tx_a;
 	unsigned int dma_slave_rx_a;
 	unsigned int dma_slave_tx_b;
diff --git a/arch/sh/kernel/cpu/sh4a/setup-sh7722.c b/arch/sh/kernel/cpu/sh4a/setup-sh7722.c
index 0f5a219..65786c7 100644
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7722.c
+++ b/arch/sh/kernel/cpu/sh4a/setup-sh7722.c
@@ -512,7 +512,6 @@ static struct platform_device tmu2_device = {
 };
 
 static struct siu_platform siu_platform_data = {
-	.dma_dev	= &dma_device.dev,
 	.dma_slave_tx_a	= SHDMA_SLAVE_SIUA_TX,
 	.dma_slave_rx_a	= SHDMA_SLAVE_SIUA_RX,
 	.dma_slave_tx_b	= SHDMA_SLAVE_SIUB_TX,
-- 
1.7.2.5

