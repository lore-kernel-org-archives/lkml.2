Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933462Ab1LFNma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 08:42:30 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:64351 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933445Ab1LFNm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 08:42:28 -0500
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Ball <cjb@laptop.org>,
        =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [MXS MMC 2/5] Some cleanups for the MMC driver
Date: Tue,  6 Dec 2011 14:41:27 +0100
Message-Id: <d935557e044d2ebc56b4e70487b519fe722e9017.1323177907.git.LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1ebaeb7f7ed88b1d82f5fc3a01c0661f38e2a16d.1323177907.git.LW@KARO-electronics.de>
References: <cover.1323177907.git.LW@KARO-electronics.de>
 <1ebaeb7f7ed88b1d82f5fc3a01c0661f38e2a16d.1323177907.git.LW@KARO-electronics.de>
In-Reply-To: <cover.1323177907.git.LW@KARO-electronics.de>
References: <cover.1323177907.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - Remove bogus parens around numerical arguments in #define's
 - When defining bit masks, use the #def for the shift count
   instead of repeating the numbers
 - Remove bogus whitespace in indentation
 - Remove 'break' at end of switch statement

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/mmc/host/mxs-mmc.c |   57 +++++++++++++++++++++----------------------
 1 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index 99b449d..a9b70d2 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -47,7 +47,7 @@
 #define DRIVER_NAME	"mxs-mmc"
 
 /* card detect polling timeout */
-#define MXS_MMC_DETECT_TIMEOUT			(HZ/2)
+#define MXS_MMC_DETECT_TIMEOUT			(HZ / 2)
 
 #define SSP_VERSION_LATEST	4
 #define ssp_is_old()		(host->version < SSP_VERSION_LATEST)
@@ -59,39 +59,39 @@
 #define  BM_SSP_CTRL0_IGNORE_CRC		(1 << 26)
 #define  BM_SSP_CTRL0_READ			(1 << 25)
 #define  BM_SSP_CTRL0_DATA_XFER			(1 << 24)
-#define  BP_SSP_CTRL0_BUS_WIDTH			(22)
-#define  BM_SSP_CTRL0_BUS_WIDTH			(0x3 << 22)
+#define  BP_SSP_CTRL0_BUS_WIDTH			22
+#define  BM_SSP_CTRL0_BUS_WIDTH			(0x3 << BP_SSP_CTRL0_BUS_WIDTH)
 #define  BM_SSP_CTRL0_WAIT_FOR_IRQ		(1 << 21)
 #define  BM_SSP_CTRL0_LONG_RESP			(1 << 19)
 #define  BM_SSP_CTRL0_GET_RESP			(1 << 17)
 #define  BM_SSP_CTRL0_ENABLE			(1 << 16)
-#define  BP_SSP_CTRL0_XFER_COUNT		(0)
-#define  BM_SSP_CTRL0_XFER_COUNT		(0xffff)
+#define  BP_SSP_CTRL0_XFER_COUNT		0
+#define  BM_SSP_CTRL0_XFER_COUNT		0xffff
 #define HW_SSP_CMD0				0x010
 #define  BM_SSP_CMD0_DBL_DATA_RATE_EN		(1 << 25)
 #define  BM_SSP_CMD0_SLOW_CLKING_EN		(1 << 22)
 #define  BM_SSP_CMD0_CONT_CLKING_EN		(1 << 21)
 #define  BM_SSP_CMD0_APPEND_8CYC		(1 << 20)
-#define  BP_SSP_CMD0_BLOCK_SIZE			(16)
-#define  BM_SSP_CMD0_BLOCK_SIZE			(0xf << 16)
-#define  BP_SSP_CMD0_BLOCK_COUNT		(8)
-#define  BM_SSP_CMD0_BLOCK_COUNT		(0xff << 8)
-#define  BP_SSP_CMD0_CMD			(0)
-#define  BM_SSP_CMD0_CMD			(0xff)
+#define  BP_SSP_CMD0_BLOCK_SIZE			16
+#define  BM_SSP_CMD0_BLOCK_SIZE			(0xf << BP_SSP_CMD0_BLOCK_SIZE)
+#define  BP_SSP_CMD0_BLOCK_COUNT		8
+#define  BM_SSP_CMD0_BLOCK_COUNT		(0xff << BP_SSP_CMD0_BLOCK_COUNT)
+#define  BP_SSP_CMD0_CMD			0
+#define  BM_SSP_CMD0_CMD			0xff
 #define HW_SSP_CMD1				0x020
 #define HW_SSP_XFER_SIZE			0x030
 #define HW_SSP_BLOCK_SIZE			0x040
-#define  BP_SSP_BLOCK_SIZE_BLOCK_COUNT		(4)
-#define  BM_SSP_BLOCK_SIZE_BLOCK_COUNT		(0xffffff << 4)
-#define  BP_SSP_BLOCK_SIZE_BLOCK_SIZE		(0)
-#define  BM_SSP_BLOCK_SIZE_BLOCK_SIZE		(0xf)
+#define  BP_SSP_BLOCK_SIZE_BLOCK_COUNT		4
+#define  BM_SSP_BLOCK_SIZE_BLOCK_COUNT		(0xffffff << BP_SSP_BLOCK_SIZE_BLOCK_COUNT)
+#define  BP_SSP_BLOCK_SIZE_BLOCK_SIZE		0
+#define  BM_SSP_BLOCK_SIZE_BLOCK_SIZE		0xf
 #define HW_SSP_TIMING				(ssp_is_old() ? 0x050 : 0x070)
-#define  BP_SSP_TIMING_TIMEOUT			(16)
-#define  BM_SSP_TIMING_TIMEOUT			(0xffff << 16)
-#define  BP_SSP_TIMING_CLOCK_DIVIDE		(8)
-#define  BM_SSP_TIMING_CLOCK_DIVIDE		(0xff << 8)
-#define  BP_SSP_TIMING_CLOCK_RATE		(0)
-#define  BM_SSP_TIMING_CLOCK_RATE		(0xff)
+#define  BP_SSP_TIMING_TIMEOUT			16
+#define  BM_SSP_TIMING_TIMEOUT			(0xffff << BP_SSP_TIMING_TIMEOUT)
+#define  BP_SSP_TIMING_CLOCK_DIVIDE		8
+#define  BM_SSP_TIMING_CLOCK_DIVIDE		(0xff << BP_SSP_TIMING_CLOCK_DIVIDE)
+#define  BP_SSP_TIMING_CLOCK_RATE		0
+#define  BM_SSP_TIMING_CLOCK_RATE		0xff
 #define HW_SSP_CTRL1				(ssp_is_old() ? 0x060 : 0x080)
 #define  BM_SSP_CTRL1_SDIO_IRQ			(1 << 31)
 #define  BM_SSP_CTRL1_SDIO_IRQ_EN		(1 << 30)
@@ -111,10 +111,10 @@
 #define  BM_SSP_CTRL1_FIFO_OVERRUN_IRQ_EN	(1 << 14)
 #define  BM_SSP_CTRL1_DMA_ENABLE		(1 << 13)
 #define  BM_SSP_CTRL1_POLARITY			(1 << 9)
-#define  BP_SSP_CTRL1_WORD_LENGTH		(4)
-#define  BM_SSP_CTRL1_WORD_LENGTH		(0xf << 4)
-#define  BP_SSP_CTRL1_SSP_MODE			(0)
-#define  BM_SSP_CTRL1_SSP_MODE			(0xf)
+#define  BP_SSP_CTRL1_WORD_LENGTH		4
+#define  BM_SSP_CTRL1_WORD_LENGTH		(0xf << BP_SSP_CTRL1_WORD_LENGTH)
+#define  BP_SSP_CTRL1_SSP_MODE			0
+#define  BM_SSP_CTRL1_SSP_MODE			0xf
 #define HW_SSP_SDRESP0				(ssp_is_old() ? 0x080 : 0x0a0)
 #define HW_SSP_SDRESP1				(ssp_is_old() ? 0x090 : 0x0b0)
 #define HW_SSP_SDRESP2				(ssp_is_old() ? 0x0a0 : 0x0c0)
@@ -123,7 +123,7 @@
 #define  BM_SSP_STATUS_CARD_DETECT		(1 << 28)
 #define  BM_SSP_STATUS_SDIO_IRQ			(1 << 17)
 #define HW_SSP_VERSION				(cpu_is_mx23() ? 0x110 : 0x130)
-#define  BP_SSP_VERSION_MAJOR			(24)
+#define  BP_SSP_VERSION_MAJOR			24
 
 #define BF_SSP(value, field)	(((value) << BP_SSP_##field) & BM_SSP_##field)
 
@@ -151,7 +151,7 @@ struct mxs_mmc_host {
 	struct clk			*clk;
 	unsigned int			clk_rate;
 
-	struct dma_chan         	*dmach;
+	struct dma_chan			*dmach;
 	struct mxs_dma_data		dma_data;
 	unsigned int			dma_dir;
 	u32				ssp_pio_words[SSP_PIO_NUM];
@@ -277,7 +277,7 @@ static irqreturn_t mxs_mmc_irq_handler(int irq, void *dev_id)
 
 	stat = readl(host->base + HW_SSP_CTRL1);
 	writel(stat & MXS_MMC_IRQ_BITS,
-	       host->base + HW_SSP_CTRL1 + MXS_CLR_ADDR);
+		host->base + HW_SSP_CTRL1 + MXS_CLR_ADDR);
 
 	if ((stat & BM_SSP_CTRL1_SDIO_IRQ) && (stat & BM_SSP_CTRL1_SDIO_IRQ_EN))
 		mmc_signal_sdio_irq(host->mmc);
@@ -550,7 +550,6 @@ static void mxs_mmc_start_cmd(struct mxs_mmc_host *host,
 	default:
 		dev_warn(mmc_dev(host->mmc),
 			 "%s: unknown MMC command\n", __func__);
-		break;
 	}
 }
 
-- 
1.5.6.5

