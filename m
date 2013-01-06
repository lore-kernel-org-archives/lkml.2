Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab3AFWpZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 17:45:25 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:36712 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753286Ab3AFWno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 17:43:44 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/8] dma: coh901318: remove hardcoded target addresses
Date: Sun, 6 Jan 2013 23:43:30 +0100
Message-ID: <1357512210-5672-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Nowadays the clients should use the dmaengine framework to
tell the DMA driver what target address to use, so delete
these addresses, they are for an out-of-tree driver anyway.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/coh901318.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index 06d9795..15e314a 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -23,7 +23,6 @@
 #include <linux/debugfs.h>
 #include <linux/platform_data/dma-coh901318.h>
 #include <mach/coh901318.h>
-#include <mach/u300-regs.h>
 
 #include "coh901318_lli.h"
 #include "dmaengine.h"
@@ -99,13 +98,11 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.number = U300_DMA_MSL_TX_0,
 		.name = "MSL TX 0",
 		.priority_high = 0,
-		.dev_addr = U300_MSL_BASE + 0 * 0x40 + 0x20,
 	},
 	{
 		.number = U300_DMA_MSL_TX_1,
 		.name = "MSL TX 1",
 		.priority_high = 0,
-		.dev_addr = U300_MSL_BASE + 1 * 0x40 + 0x20,
 		.param.config = COH901318_CX_CFG_CH_DISABLE |
 				COH901318_CX_CFG_LCR_DISABLE |
 				COH901318_CX_CFG_TC_IRQ_ENABLE |
@@ -157,7 +154,6 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.number = U300_DMA_MSL_TX_2,
 		.name = "MSL TX 2",
 		.priority_high = 0,
-		.dev_addr = U300_MSL_BASE + 2 * 0x40 + 0x20,
 		.param.config = COH901318_CX_CFG_CH_DISABLE |
 				COH901318_CX_CFG_LCR_DISABLE |
 				COH901318_CX_CFG_TC_IRQ_ENABLE |
@@ -210,7 +206,6 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.number = U300_DMA_MSL_TX_3,
 		.name = "MSL TX 3",
 		.priority_high = 0,
-		.dev_addr = U300_MSL_BASE + 3 * 0x40 + 0x20,
 		.param.config = COH901318_CX_CFG_CH_DISABLE |
 				COH901318_CX_CFG_LCR_DISABLE |
 				COH901318_CX_CFG_TC_IRQ_ENABLE |
@@ -262,7 +257,6 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.number = U300_DMA_MSL_TX_4,
 		.name = "MSL TX 4",
 		.priority_high = 0,
-		.dev_addr = U300_MSL_BASE + 4 * 0x40 + 0x20,
 		.param.config = COH901318_CX_CFG_CH_DISABLE |
 				COH901318_CX_CFG_LCR_DISABLE |
 				COH901318_CX_CFG_TC_IRQ_ENABLE |
@@ -314,25 +308,21 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.number = U300_DMA_MSL_TX_5,
 		.name = "MSL TX 5",
 		.priority_high = 0,
-		.dev_addr = U300_MSL_BASE + 5 * 0x40 + 0x20,
 	},
 	{
 		.number = U300_DMA_MSL_TX_6,
 		.name = "MSL TX 6",
 		.priority_high = 0,
-		.dev_addr = U300_MSL_BASE + 6 * 0x40 + 0x20,
 	},
 	{
 		.number = U300_DMA_MSL_RX_0,
 		.name = "MSL RX 0",
 		.priority_high = 0,
-		.dev_addr = U300_MSL_BASE + 0 * 0x40 + 0x220,
 	},
 	{
 		.number = U300_DMA_MSL_RX_1,
 		.name = "MSL RX 1",
 		.priority_high = 0,
-		.dev_addr = U300_MSL_BASE + 1 * 0x40 + 0x220,
 		.param.config = COH901318_CX_CFG_CH_DISABLE |
 				COH901318_CX_CFG_LCR_DISABLE |
 				COH901318_CX_CFG_TC_IRQ_ENABLE |
@@ -371,7 +361,6 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.number = U300_DMA_MSL_RX_2,
 		.name = "MSL RX 2",
 		.priority_high = 0,
-		.dev_addr = U300_MSL_BASE + 2 * 0x40 + 0x220,
 		.param.config = COH901318_CX_CFG_CH_DISABLE |
 				COH901318_CX_CFG_LCR_DISABLE |
 				COH901318_CX_CFG_TC_IRQ_ENABLE |
@@ -423,7 +412,6 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.number = U300_DMA_MSL_RX_3,
 		.name = "MSL RX 3",
 		.priority_high = 0,
-		.dev_addr = U300_MSL_BASE + 3 * 0x40 + 0x220,
 		.param.config = COH901318_CX_CFG_CH_DISABLE |
 				COH901318_CX_CFG_LCR_DISABLE |
 				COH901318_CX_CFG_TC_IRQ_ENABLE |
@@ -475,7 +463,6 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.number = U300_DMA_MSL_RX_4,
 		.name = "MSL RX 4",
 		.priority_high = 0,
-		.dev_addr = U300_MSL_BASE + 4 * 0x40 + 0x220,
 		.param.config = COH901318_CX_CFG_CH_DISABLE |
 				COH901318_CX_CFG_LCR_DISABLE |
 				COH901318_CX_CFG_TC_IRQ_ENABLE |
@@ -527,7 +514,6 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.number = U300_DMA_MSL_RX_5,
 		.name = "MSL RX 5",
 		.priority_high = 0,
-		.dev_addr = U300_MSL_BASE + 5 * 0x40 + 0x220,
 		.param.config = COH901318_CX_CFG_CH_DISABLE |
 				COH901318_CX_CFG_LCR_DISABLE |
 				COH901318_CX_CFG_TC_IRQ_ENABLE |
@@ -579,7 +565,6 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.number = U300_DMA_MSL_RX_6,
 		.name = "MSL RX 6",
 		.priority_high = 0,
-		.dev_addr = U300_MSL_BASE + 6 * 0x40 + 0x220,
 	},
 	/*
 	 * Don't set up device address, burst count or size of src
@@ -715,7 +700,6 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.number = U300_DMA_PCM_I2S0_TX,
 		.name = "PCM I2S0 TX",
 		.priority_high = 1,
-		.dev_addr = U300_PCM_I2S0_BASE + 0x14,
 		.param.config = COH901318_CX_CFG_CH_DISABLE |
 				COH901318_CX_CFG_LCR_DISABLE |
 				COH901318_CX_CFG_TC_IRQ_ENABLE |
@@ -767,7 +751,6 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.number = U300_DMA_PCM_I2S0_RX,
 		.name = "PCM I2S0 RX",
 		.priority_high = 1,
-		.dev_addr = U300_PCM_I2S0_BASE + 0x10,
 		.param.config = COH901318_CX_CFG_CH_DISABLE |
 				COH901318_CX_CFG_LCR_DISABLE |
 				COH901318_CX_CFG_TC_IRQ_ENABLE |
@@ -819,7 +802,6 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.number = U300_DMA_PCM_I2S1_TX,
 		.name = "PCM I2S1 TX",
 		.priority_high = 1,
-		.dev_addr =  U300_PCM_I2S1_BASE + 0x14,
 		.param.config = COH901318_CX_CFG_CH_DISABLE |
 				COH901318_CX_CFG_LCR_DISABLE |
 				COH901318_CX_CFG_TC_IRQ_ENABLE |
@@ -871,7 +853,6 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.number = U300_DMA_PCM_I2S1_RX,
 		.name = "PCM I2S1 RX",
 		.priority_high = 1,
-		.dev_addr = U300_PCM_I2S1_BASE + 0x10,
 		.param.config = COH901318_CX_CFG_CH_DISABLE |
 				COH901318_CX_CFG_LCR_DISABLE |
 				COH901318_CX_CFG_TC_IRQ_ENABLE |
-- 
1.7.11.3

