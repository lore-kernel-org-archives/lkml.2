Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab1AaQ5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 11:57:55 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45896 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab1AaQ5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 11:57:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tMXo8VXKaePeb3n8Z0nGiRIOJKar1hmzN8pAZBcr310F7fw36bVjqheK3+20Un45VI
         53K5zaMLi10MncgCZM1EYb6VfulayIScMAYrl8yiW8D4j4JVXEX4F/xIb/USsBar6weJ
         64vFjKDyeYdE3mJ2hWO321jBHYuQKzgERC/D4=
From: Nick Robinson <nrobinson13@gmail.com>
To: gregkh@suse.de
Cc: arun.thomas@gmail.com, hjk@linutronix.de, jkosina@suse.cz,
        devel@driverdec.osuosl.org, linux-kernel@vger.kernel.org,
        Nick Robinson <nr33@msstate.edu>
Subject: [PATCH] Staging: comedi: Fix checpatch.pl issues in file rtd520.c
Date: Mon, 31 Jan 2011 10:56:50 -0600
Message-Id: <1296493010-3196-1-git-send-email-nrobinson13@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: nr33@msstate.edu <nick@Mercury.(none)>

This patch fixes the checkpatch errors listed below:

ERROR: code indent should use tabs where possible
WARNING: space prohibited between function name and open parenthesis '('
WARNING: please, no spaces at the start of a line
WARNING: braces {} are not necessary for single statement blocks
WARNING: printk() should include KERN_ facility level

Signed-off-by: Nick Robinson <nr33@msstate.edu>
---
 drivers/staging/comedi/drivers/rtd520.c |  321 +++++++++++++++----------------
 1 files changed, 157 insertions(+), 164 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index aa8aeee..357858d 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -59,7 +59,7 @@ Configuration options:
     Data sheet: http://www.rtdusa.com/pdf/dm7520.pdf
     Example source: http://www.rtdusa.com/examples/dm/dm7520.zip
     Call them and ask for the register level manual.
-    PCI chip: http://www.plxtech.com/products/io/pci9080 
+    PCI chip: http://www.plxtech.com/products/io/pci9080
 
     Notes:
     This board is memory mapped.  There is some IO stuff, but it isn't needed.
@@ -136,7 +136,7 @@ Configuration options:
 #define RTD_DMA_TIMEOUT	33000	/* 1 msec */
 #else
 /* by delaying, power and electrical noise are reduced somewhat */
-#define WAIT_QUIETLY	udelay (1)
+#define WAIT_QUIETLY	udelay(1)
 #define RTD_ADC_TIMEOUT	2000	/* in usec */
 #define RTD_DAC_TIMEOUT	2000	/* in usec */
 #define RTD_DMA_TIMEOUT	1000	/* in usec */
@@ -414,296 +414,296 @@ struct rtdPrivate {
 
 /* Reset board */
 #define RtdResetBoard(dev) \
-    writel (0, devpriv->las0+LAS0_BOARD_RESET)
+	writel(0, devpriv->las0+LAS0_BOARD_RESET)
 
 /* Reset channel gain table read pointer */
 #define RtdResetCGT(dev) \
-    writel (0, devpriv->las0+LAS0_CGT_RESET)
+	writel(0, devpriv->las0+LAS0_CGT_RESET)
 
 /* Reset channel gain table read and write pointers */
 #define RtdClearCGT(dev) \
-    writel (0, devpriv->las0+LAS0_CGT_CLEAR)
+	writel(0, devpriv->las0+LAS0_CGT_CLEAR)
 
 /* Reset channel gain table read and write pointers */
 #define RtdEnableCGT(dev, v) \
-    writel ((v > 0) ? 1 : 0, devpriv->las0+LAS0_CGT_ENABLE)
+	writel((v > 0) ? 1 : 0, devpriv->las0+LAS0_CGT_ENABLE)
 
 /* Write channel gain table entry */
 #define RtdWriteCGTable(dev, v) \
-    writel (v, devpriv->las0+LAS0_CGT_WRITE)
+	writel(v, devpriv->las0+LAS0_CGT_WRITE)
 
 /* Write Channel Gain Latch */
 #define RtdWriteCGLatch(dev, v) \
-    writel (v, devpriv->las0+LAS0_CGL_WRITE)
+	writel(v, devpriv->las0+LAS0_CGL_WRITE)
 
 /* Reset ADC FIFO */
 #define RtdAdcClearFifo(dev) \
-    writel (0, devpriv->las0+LAS0_ADC_FIFO_CLEAR)
+	writel(0, devpriv->las0+LAS0_ADC_FIFO_CLEAR)
 
 /* Set ADC start conversion source select (write only) */
 #define RtdAdcConversionSource(dev, v) \
-    writel (v, devpriv->las0+LAS0_ADC_CONVERSION)
+	writel(v, devpriv->las0+LAS0_ADC_CONVERSION)
 
 /* Set burst start source select (write only) */
 #define RtdBurstStartSource(dev, v) \
-    writel (v, devpriv->las0+LAS0_BURST_START)
+	writel(v, devpriv->las0+LAS0_BURST_START)
 
 /* Set Pacer start source select (write only) */
 #define RtdPacerStartSource(dev, v) \
-    writel (v, devpriv->las0+LAS0_PACER_START)
+	writel(v, devpriv->las0+LAS0_PACER_START)
 
 /* Set Pacer stop source select (write only) */
 #define RtdPacerStopSource(dev, v) \
-    writel (v, devpriv->las0+LAS0_PACER_STOP)
+	writel(v, devpriv->las0+LAS0_PACER_STOP)
 
 /* Set Pacer clock source select (write only) 0=external 1=internal */
 #define RtdPacerClockSource(dev, v) \
-    writel ((v > 0) ? 1 : 0, devpriv->las0+LAS0_PACER_SELECT)
+	writel((v > 0) ? 1 : 0, devpriv->las0+LAS0_PACER_SELECT)
 
 /* Set sample counter source select (write only) */
 #define RtdAdcSampleCounterSource(dev, v) \
-    writel (v, devpriv->las0+LAS0_ADC_SCNT_SRC)
+	writel(v, devpriv->las0+LAS0_ADC_SCNT_SRC)
 
 /* Set Pacer trigger mode select (write only) 0=single cycle, 1=repeat */
 #define RtdPacerTriggerMode(dev, v) \
-    writel ((v > 0) ? 1 : 0, devpriv->las0+LAS0_PACER_REPEAT)
+	writel((v > 0) ? 1 : 0, devpriv->las0+LAS0_PACER_REPEAT)
 
 /* Set About counter stop enable (write only) */
 #define RtdAboutStopEnable(dev, v) \
-    writel ((v > 0) ? 1 : 0, devpriv->las0+LAS0_ACNT_STOP_ENABLE)
+	writel((v > 0) ? 1 : 0, devpriv->las0+LAS0_ACNT_STOP_ENABLE)
 
 /* Set external trigger polarity (write only) 0=positive edge, 1=negative */
 #define RtdTriggerPolarity(dev, v) \
-    writel ((v > 0) ? 1 : 0, devpriv->las0+LAS0_ETRG_POLARITY)
+	writel((v > 0) ? 1 : 0, devpriv->las0+LAS0_ETRG_POLARITY)
 
 /* Start single ADC conversion */
 #define RtdAdcStart(dev) \
-    writew (0, devpriv->las0+LAS0_ADC)
+	writew(0, devpriv->las0+LAS0_ADC)
 
 /* Read one ADC data value (12bit (with sign extend) as 16bit) */
 /* Note: matches what DMA would get.  Actual value >> 3 */
 #define RtdAdcFifoGet(dev) \
-    readw (devpriv->las1+LAS1_ADC_FIFO)
+	readw(devpriv->las1+LAS1_ADC_FIFO)
 
 /* Read two ADC data values (DOESNT WORK) */
 #define RtdAdcFifoGet2(dev) \
-    readl (devpriv->las1+LAS1_ADC_FIFO)
+	readl(devpriv->las1+LAS1_ADC_FIFO)
 
 /* FIFO status */
 #define RtdFifoStatus(dev) \
-    readl (devpriv->las0+LAS0_ADC)
+	readl(devpriv->las0+LAS0_ADC)
 
 /* pacer start/stop read=start, write=stop*/
 #define RtdPacerStart(dev) \
-    readl (devpriv->las0+LAS0_PACER)
+	readl(devpriv->las0+LAS0_PACER)
 #define RtdPacerStop(dev) \
-    writel (0, devpriv->las0+LAS0_PACER)
+	writel(0, devpriv->las0+LAS0_PACER)
 
 /* Interrupt status */
 #define RtdInterruptStatus(dev) \
-    readw (devpriv->las0+LAS0_IT)
+	readw(devpriv->las0+LAS0_IT)
 
 /* Interrupt mask */
 #define RtdInterruptMask(dev, v) \
-    writew ((devpriv->intMask = (v)), devpriv->las0+LAS0_IT)
+	writew((devpriv->intMask = (v)), devpriv->las0+LAS0_IT)
 
 /* Interrupt status clear (only bits set in mask) */
 #define RtdInterruptClear(dev) \
-    readw (devpriv->las0+LAS0_CLEAR)
+	readw(devpriv->las0+LAS0_CLEAR)
 
 /* Interrupt clear mask */
 #define RtdInterruptClearMask(dev, v) \
-    writew ((devpriv->intClearMask = (v)), devpriv->las0+LAS0_CLEAR)
+	writew((devpriv->intClearMask = (v)), devpriv->las0+LAS0_CLEAR)
 
 /* Interrupt overrun status */
 #define RtdInterruptOverrunStatus(dev) \
-    readl (devpriv->las0+LAS0_OVERRUN)
+	readl(devpriv->las0+LAS0_OVERRUN)
 
 /* Interrupt overrun clear */
 #define RtdInterruptOverrunClear(dev) \
-    writel (0, devpriv->las0+LAS0_OVERRUN)
+	writel(0, devpriv->las0+LAS0_OVERRUN)
 
 /* Pacer counter, 24bit */
 #define RtdPacerCount(dev) \
-    readl (devpriv->las0+LAS0_PCLK)
+	readl(devpriv->las0+LAS0_PCLK)
 #define RtdPacerCounter(dev, v) \
-    writel ((v) & 0xffffff, devpriv->las0+LAS0_PCLK)
+	writel((v) & 0xffffff, devpriv->las0+LAS0_PCLK)
 
 /* Burst counter, 10bit */
 #define RtdBurstCount(dev) \
-    readl (devpriv->las0+LAS0_BCLK)
+	readl(devpriv->las0+LAS0_BCLK)
 #define RtdBurstCounter(dev, v) \
-    writel ((v) & 0x3ff, devpriv->las0+LAS0_BCLK)
+	writel((v) & 0x3ff, devpriv->las0+LAS0_BCLK)
 
 /* Delay counter, 16bit */
 #define RtdDelayCount(dev) \
-    readl (devpriv->las0+LAS0_DCLK)
+	readl(devpriv->las0+LAS0_DCLK)
 #define RtdDelayCounter(dev, v) \
-    writel ((v) & 0xffff, devpriv->las0+LAS0_DCLK)
+	writel((v) & 0xffff, devpriv->las0+LAS0_DCLK)
 
 /* About counter, 16bit */
 #define RtdAboutCount(dev) \
-    readl (devpriv->las0+LAS0_ACNT)
+	readl(devpriv->las0+LAS0_ACNT)
 #define RtdAboutCounter(dev, v) \
-    writel ((v) & 0xffff, devpriv->las0+LAS0_ACNT)
+	writel((v) & 0xffff, devpriv->las0+LAS0_ACNT)
 
 /* ADC sample counter, 10bit */
 #define RtdAdcSampleCount(dev) \
-    readl (devpriv->las0+LAS0_ADC_SCNT)
+	readl(devpriv->las0+LAS0_ADC_SCNT)
 #define RtdAdcSampleCounter(dev, v) \
-    writel ((v) & 0x3ff, devpriv->las0+LAS0_ADC_SCNT)
+	writel((v) & 0x3ff, devpriv->las0+LAS0_ADC_SCNT)
 
 /* User Timer/Counter (8254) */
 #define RtdUtcCounterGet(dev, n) \
-    readb (devpriv->las0 \
-        + ((n <= 0) ? LAS0_UTC0 : ((1 == n) ? LAS0_UTC1 : LAS0_UTC2)))
+	readb(devpriv->las0 \
+		+ ((n <= 0) ? LAS0_UTC0 : ((1 == n) ? LAS0_UTC1 : LAS0_UTC2)))
 
 #define RtdUtcCounterPut(dev, n, v) \
-    writeb ((v) & 0xff, devpriv->las0 \
-        + ((n <= 0) ? LAS0_UTC0 : ((1 == n) ? LAS0_UTC1 : LAS0_UTC2)))
+	writeb((v) & 0xff, devpriv->las0 \
+		+ ((n <= 0) ? LAS0_UTC0 : ((1 == n) ? LAS0_UTC1 : LAS0_UTC2)))
 
 /* Set UTC (8254) control byte  */
 #define RtdUtcCtrlPut(dev, n, v) \
-    writeb (devpriv->utcCtrl[(n) & 3] = (((n) & 3) << 6) | ((v) & 0x3f), \
-      devpriv->las0 + LAS0_UTC_CTRL)
+	writeb(devpriv->utcCtrl[(n) & 3] = (((n) & 3) << 6) | ((v) & 0x3f), \
+		devpriv->las0 + LAS0_UTC_CTRL)
 
 /* Set UTCn clock source (write only) */
 #define RtdUtcClockSource(dev, n, v) \
-    writew (v, devpriv->las0 \
-        + ((n <= 0) ? LAS0_UTC0_CLOCK : \
-           ((1 == n) ? LAS0_UTC1_CLOCK : LAS0_UTC2_CLOCK)))
+	writew(v, devpriv->las0 \
+		+ ((n <= 0) ? LAS0_UTC0_CLOCK : \
+			((1 == n) ? LAS0_UTC1_CLOCK : LAS0_UTC2_CLOCK)))
 
 /* Set UTCn gate source (write only) */
 #define RtdUtcGateSource(dev, n, v) \
-    writew (v, devpriv->las0 \
-        + ((n <= 0) ? LAS0_UTC0_GATE : \
-           ((1 == n) ? LAS0_UTC1_GATE : LAS0_UTC2_GATE)))
+	writew(v, devpriv->las0 \
+		+ ((n <= 0) ? LAS0_UTC0_GATE : \
+			((1 == n) ? LAS0_UTC1_GATE : LAS0_UTC2_GATE)))
 
 /* User output N source select (write only) */
 #define RtdUsrOutSource(dev, n, v) \
-    writel (v, devpriv->las0+((n <= 0) ? LAS0_UOUT0_SELECT : LAS0_UOUT1_SELECT))
+	writel(v, devpriv->las0+((n <= 0) ? LAS0_UOUT0_SELECT : LAS0_UOUT1_SELECT))
 
 /* Digital IO */
 #define RtdDio0Read(dev) \
-    (readw (devpriv->las0+LAS0_DIO0) & 0xff)
+	(readw(devpriv->las0+LAS0_DIO0) & 0xff)
 #define RtdDio0Write(dev, v) \
-    writew ((v) & 0xff, devpriv->las0+LAS0_DIO0)
+	writew((v) & 0xff, devpriv->las0+LAS0_DIO0)
 
 #define RtdDio1Read(dev) \
-    (readw (devpriv->las0+LAS0_DIO1) & 0xff)
+	(readw(devpriv->las0+LAS0_DIO1) & 0xff)
 #define RtdDio1Write(dev, v) \
-    writew ((v) & 0xff, devpriv->las0+LAS0_DIO1)
+	writew((v) & 0xff, devpriv->las0+LAS0_DIO1)
 
 #define RtdDioStatusRead(dev) \
-    (readw (devpriv->las0+LAS0_DIO_STATUS) & 0xff)
+	(readw(devpriv->las0+LAS0_DIO_STATUS) & 0xff)
 #define RtdDioStatusWrite(dev, v) \
-    writew ((devpriv->dioStatus = (v)), devpriv->las0+LAS0_DIO_STATUS)
+	writew((devpriv->dioStatus = (v)), devpriv->las0+LAS0_DIO_STATUS)
 
 #define RtdDio0CtrlRead(dev) \
-    (readw (devpriv->las0+LAS0_DIO0_CTRL) & 0xff)
+	(readw(devpriv->las0+LAS0_DIO0_CTRL) & 0xff)
 #define RtdDio0CtrlWrite(dev, v) \
-    writew ((v) & 0xff, devpriv->las0+LAS0_DIO0_CTRL)
+	writew((v) & 0xff, devpriv->las0+LAS0_DIO0_CTRL)
 
 /* Digital to Analog converter */
 /* Write one data value (sign + 12bit + marker bits) */
 /* Note: matches what DMA would put.  Actual value << 3 */
 #define RtdDacFifoPut(dev, n, v) \
-    writew ((v), devpriv->las1 +(((n) == 0) ? LAS1_DAC1_FIFO : LAS1_DAC2_FIFO))
+	writew((v), devpriv->las1 + (((n) == 0) ? LAS1_DAC1_FIFO : LAS1_DAC2_FIFO))
 
 /* Start single DAC conversion */
 #define RtdDacUpdate(dev, n) \
-    writew (0, devpriv->las0 +(((n) == 0) ? LAS0_DAC1 : LAS0_DAC2))
+	writew(0, devpriv->las0 + (((n) == 0) ? LAS0_DAC1 : LAS0_DAC2))
 
 /* Start single DAC conversion on both DACs */
 #define RtdDacBothUpdate(dev) \
-    writew (0, devpriv->las0+LAS0_DAC)
+	writew(0, devpriv->las0+LAS0_DAC)
 
 /* Set DAC output type and range */
 #define RtdDacRange(dev, n, v) \
-    writew ((v) & 7, devpriv->las0 \
-	+(((n) == 0) ? LAS0_DAC1_CTRL : LAS0_DAC2_CTRL))
+	writew((v) & 7, devpriv->las0 \
+		+(((n) == 0) ? LAS0_DAC1_CTRL : LAS0_DAC2_CTRL))
 
 /* Reset DAC FIFO */
 #define RtdDacClearFifo(dev, n) \
-    writel (0, devpriv->las0+(((n) == 0) ? LAS0_DAC1_RESET : LAS0_DAC2_RESET))
+	writel(0, devpriv->las0+(((n) == 0) ? LAS0_DAC1_RESET : LAS0_DAC2_RESET))
 
 /* Set source for DMA 0 (write only, shadow?) */
 #define RtdDma0Source(dev, n) \
-    writel ((n) & 0xf, devpriv->las0+LAS0_DMA0_SRC)
+	writel((n) & 0xf, devpriv->las0+LAS0_DMA0_SRC)
 
 /* Set source for DMA 1 (write only, shadow?) */
 #define RtdDma1Source(dev, n) \
-    writel ((n) & 0xf, devpriv->las0+LAS0_DMA1_SRC)
+	writel((n) & 0xf, devpriv->las0+LAS0_DMA1_SRC)
 
 /* Reset board state for DMA 0 */
 #define RtdDma0Reset(dev) \
-    writel (0, devpriv->las0+LAS0_DMA0_RESET)
+	writel(0, devpriv->las0+LAS0_DMA0_RESET)
 
 /* Reset board state for DMA 1 */
 #define RtdDma1Reset(dev) \
-    writel (0, devpriv->las0+LAS0_DMA1_SRC)
+	writel(0, devpriv->las0+LAS0_DMA1_SRC)
 
 /* PLX9080 interrupt mask and status */
 #define RtdPlxInterruptRead(dev) \
-    readl (devpriv->lcfg+LCFG_ITCSR)
+	readl(devpriv->lcfg+LCFG_ITCSR)
 #define RtdPlxInterruptWrite(dev, v) \
-    writel (v, devpriv->lcfg+LCFG_ITCSR)
+	writel(v, devpriv->lcfg+LCFG_ITCSR)
 
 /* Set  mode for DMA 0 */
 #define RtdDma0Mode(dev, m) \
-    writel ((m), devpriv->lcfg+LCFG_DMAMODE0)
+	writel((m), devpriv->lcfg+LCFG_DMAMODE0)
 
 /* Set PCI address for DMA 0 */
 #define RtdDma0PciAddr(dev, a) \
-    writel ((a), devpriv->lcfg+LCFG_DMAPADR0)
+	writel((a), devpriv->lcfg+LCFG_DMAPADR0)
 
 /* Set local address for DMA 0 */
 #define RtdDma0LocalAddr(dev, a) \
-    writel ((a), devpriv->lcfg+LCFG_DMALADR0)
+	writel((a), devpriv->lcfg+LCFG_DMALADR0)
 
 /* Set byte count for DMA 0 */
 #define RtdDma0Count(dev, c) \
-    writel ((c), devpriv->lcfg+LCFG_DMASIZ0)
+	writel((c), devpriv->lcfg+LCFG_DMASIZ0)
 
 /* Set next descriptor for DMA 0 */
 #define RtdDma0Next(dev, a) \
-    writel ((a), devpriv->lcfg+LCFG_DMADPR0)
+	writel((a), devpriv->lcfg+LCFG_DMADPR0)
 
 /* Set  mode for DMA 1 */
 #define RtdDma1Mode(dev, m) \
-    writel ((m), devpriv->lcfg+LCFG_DMAMODE1)
+	writel((m), devpriv->lcfg+LCFG_DMAMODE1)
 
 /* Set PCI address for DMA 1 */
 #define RtdDma1PciAddr(dev, a) \
-    writel ((a), devpriv->lcfg+LCFG_DMAADR1)
+	writel((a), devpriv->lcfg+LCFG_DMAADR1)
 
 /* Set local address for DMA 1 */
 #define RtdDma1LocalAddr(dev, a) \
-    writel ((a), devpriv->lcfg+LCFG_DMALADR1)
+	writel((a), devpriv->lcfg+LCFG_DMALADR1)
 
 /* Set byte count for DMA 1 */
 #define RtdDma1Count(dev, c) \
-    writel ((c), devpriv->lcfg+LCFG_DMASIZ1)
+	writel((c), devpriv->lcfg+LCFG_DMASIZ1)
 
 /* Set next descriptor for DMA 1 */
 #define RtdDma1Next(dev, a) \
-    writel ((a), devpriv->lcfg+LCFG_DMADPR1)
+	writel((a), devpriv->lcfg+LCFG_DMADPR1)
 
 /* Set control for DMA 0 (write only, shadow?) */
 #define RtdDma0Control(dev, n) \
-    writeb (devpriv->dma0Control = (n), devpriv->lcfg+LCFG_DMACSR0)
+	writeb(devpriv->dma0Control = (n), devpriv->lcfg+LCFG_DMACSR0)
 
 /* Get status for DMA 0 */
 #define RtdDma0Status(dev) \
-    readb (devpriv->lcfg+LCFG_DMACSR0)
+	readb(devpriv->lcfg+LCFG_DMACSR0)
 
 /* Set control for DMA 1 (write only, shadow?) */
 #define RtdDma1Control(dev, n) \
-    writeb (devpriv->dma1Control = (n), devpriv->lcfg+LCFG_DMACSR1)
+	writeb(devpriv->dma1Control = (n), devpriv->lcfg+LCFG_DMACSR1)
 
 /* Get status for DMA 1 */
 #define RtdDma1Status(dev) \
-    readb (devpriv->lcfg+LCFG_DMACSR1)
+	readb(devpriv->lcfg+LCFG_DMACSR1)
 
 /*
  * The struct comedi_driver structure tells the Comedi core module
@@ -760,9 +760,9 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	int index;
 #endif
 
-	printk("comedi%d: rtd520 attaching.\n", dev->minor);
+	printk(KERN_INFO "comedi%d: rtd520 attaching.\n", dev->minor);
 
-#if defined (CONFIG_COMEDI_DEBUG) && defined (USE_DMA)
+#if defined(CONFIG_COMEDI_DEBUG) && defined(USE_DMA)
 	/* You can set this a load time: modprobe comedi comedi_debug=1 */
 	if (0 == comedi_debug)	/* force DMA debug printks */
 		comedi_debug = 1;
@@ -800,10 +800,10 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 	if (!pcidev) {
 		if (it->options[0] && it->options[1]) {
-			printk("No RTD card at bus=%d slot=%d.\n",
+			printk(KERN_INFO "No RTD card at bus=%d slot=%d.\n",
 			       it->options[0], it->options[1]);
 		} else {
-			printk("No RTD card found.\n");
+			printk(KERN_INFO "No RTD card found.\n");
 		}
 		return -EIO;
 	}
@@ -812,7 +812,7 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	ret = comedi_pci_enable(pcidev, DRV_NAME);
 	if (ret < 0) {
-		printk("Failed to enable PCI device and request regions.\n");
+		printk(KERN_INFO "Failed to enable PCI device and request regions.\n");
 		return ret;
 	}
 	devpriv->got_regions = 1;
@@ -830,9 +830,9 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	devpriv->las1 = ioremap_nocache(physLas1, LAS1_PCISIZE);
 	devpriv->lcfg = ioremap_nocache(physLcfg, LCFG_PCISIZE);
 
-	if (!devpriv->las0 || !devpriv->las1 || !devpriv->lcfg) {
+	if (!devpriv->las0 || !devpriv->las1 || !devpriv->lcfg)
 		return -ENOMEM;
-	}
+
 
 	DPRINTK("%s: LAS0=%llx, LAS1=%llx, CFG=%llx.\n", dev->board_name,
 		(unsigned long long)physLas0, (unsigned long long)physLas1,
@@ -849,7 +849,7 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		pci_read_config_byte(devpriv->pci_dev,
 				     PCI_LATENCY_TIMER, &pci_latency);
 		if (pci_latency < 32) {
-			printk("%s: PCI latency changed from %d to %d\n",
+			printk(KERN_INFO "%s: PCI latency changed from %d to %d\n",
 			       dev->board_name, pci_latency, 32);
 			pci_write_config_byte(devpriv->pci_dev,
 					      PCI_LATENCY_TIMER, 32);
@@ -875,9 +875,9 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	 * Allocate the subdevice structures.  alloc_subdevice() is a
 	 * convenient macro defined in comedidev.h.
 	 */
-	if (alloc_subdevices(dev, 4) < 0) {
+	if (alloc_subdevices(dev, 4) < 0)
 		return -ENOMEM;
-	}
+
 
 	s = dev->subdevices + 0;
 	dev->read_subdev = s;
@@ -887,11 +887,11 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	    SDF_READABLE | SDF_GROUND | SDF_COMMON | SDF_DIFF | SDF_CMD_READ;
 	s->n_chan = thisboard->aiChans;
 	s->maxdata = (1 << thisboard->aiBits) - 1;
-	if (thisboard->aiMaxGain <= 32) {
+	if (thisboard->aiMaxGain <= 32)
 		s->range_table = &rtd_ai_7520_range;
-	} else {
+	else
 		s->range_table = &rtd_ai_4520_range;
-	}
+
 	s->len_chanlist = RTD_MAX_CHANLIST;	/* devpriv->fifoLen */
 	s->insn_read = rtd_ai_rinsn;
 	s->do_cmd = rtd_ai_cmd;
@@ -961,9 +961,9 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	printk("( irq=%u )", dev->irq);
 
 	ret = rtd520_probe_fifo_depth(dev);
-	if (ret < 0) {
+	if (ret < 0)
 		return ret;
-	}
+
 	devpriv->fifoLen = ret;
 	printk("( fifoLen=%d )", devpriv->fifoLen);
 
@@ -1028,7 +1028,7 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		RtdDma0Mode(dev, DMA_MODE_BITS);
 		RtdDma0Source(dev, DMAS_ADFIFO_HALF_FULL);	/* set DMA trigger source */
 	} else {
-		printk("( no IRQ->no DMA )");
+		printk(KERN_INFO "( no IRQ->no DMA )");
 	}
 #endif /* USE_DMA */
 
@@ -1071,18 +1071,18 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 
 	/* release all regions that were allocated */
-	if (devpriv->las0) {
+	if (devpriv->las0)
 		iounmap(devpriv->las0);
-	}
-	if (devpriv->las1) {
+
+	if (devpriv->las1)
 		iounmap(devpriv->las1);
-	}
-	if (devpriv->lcfg) {
+
+	if (devpriv->lcfg)
 		iounmap(devpriv->lcfg);
-	}
-	if (devpriv->pci_dev) {
+
+	if (devpriv->pci_dev)
 		pci_dev_put(devpriv->pci_dev);
-	}
+
 	return ret;
 #endif
 }
@@ -1158,24 +1158,24 @@ static int rtd_detach(struct comedi_device *dev)
 		}
 
 		/* release all regions that were allocated */
-		if (devpriv->las0) {
+		if (devpriv->las0)
 			iounmap(devpriv->las0);
-		}
-		if (devpriv->las1) {
+
+		if (devpriv->las1)
 			iounmap(devpriv->las1);
-		}
-		if (devpriv->lcfg) {
+
+		if (devpriv->lcfg)
 			iounmap(devpriv->lcfg);
-		}
+
 		if (devpriv->pci_dev) {
-			if (devpriv->got_regions) {
+			if (devpriv->got_regions)
 				comedi_pci_disable(devpriv->pci_dev);
-			}
+
 			pci_dev_put(devpriv->pci_dev);
 		}
 	}
 
-	printk("comedi%d: rtd520: removed.\n", dev->minor);
+	printk(KERN_INFO "comedi%d: rtd520: removed.\n", dev->minor);
 
 	return 0;
 }
@@ -1275,13 +1275,13 @@ static int rtd520_probe_fifo_depth(struct comedi_device *dev)
 		}
 	}
 	if (i == limit) {
-		printk("\ncomedi: %s: failed to probe fifo size.\n", DRV_NAME);
+		printk(KERN_INFO "\ncomedi: %s: failed to probe fifo size.\n", DRV_NAME);
 		return -EIO;
 	}
 	RtdAdcClearFifo(dev);
 	if (fifo_size != 0x400 && fifo_size != 0x2000) {
 		printk
-		    ("\ncomedi: %s: unexpected fifo size of %i, expected 1024 or 8192.\n",
+		    (KERN_INFO "\ncomedi: %s: unexpected fifo size of %i, expected 1024 or 8192.\n",
 		     DRV_NAME, fifo_size);
 		return -EIO;
 	}
@@ -1335,11 +1335,10 @@ static int rtd_ai_rinsn(struct comedi_device *dev,
 		d = RtdAdcFifoGet(dev);	/* get 2s comp value */
 		/*printk ("rtd520: Got 0x%x after %d usec\n", d, ii+1); */
 		d = d >> 3;	/* low 3 bits are marker lines */
-		if (CHAN_ARRAY_TEST(devpriv->chanBipolar, 0)) {
+		if (CHAN_ARRAY_TEST(devpriv->chanBipolar, 0))
 			data[n] = d + 2048;	/* convert to comedi unsigned data */
-		} else {
+		else
 			data[n] = d;
-		}
 	}
 
 	/* return the number of samples read/written */
@@ -1375,11 +1374,11 @@ static int ai_read_n(struct comedi_device *dev, struct comedi_subdevice *s,
 		d = RtdAdcFifoGet(dev);	/* get 2s comp value */
 
 		d = d >> 3;	/* low 3 bits are marker lines */
-		if (CHAN_ARRAY_TEST(devpriv->chanBipolar, s->async->cur_chan)) {
+		if (CHAN_ARRAY_TEST(devpriv->chanBipolar, s->async->cur_chan))
 			sample = d + 2048;	/* convert to comedi unsigned data */
-		} else {
+		else
 			sample = d;
-		}
+
 		if (!comedi_buf_put(s->async, sample))
 			return -1;
 
@@ -1403,11 +1402,11 @@ static int ai_read_dregs(struct comedi_device *dev, struct comedi_subdevice *s)
 		}
 
 		d = d >> 3;	/* low 3 bits are marker lines */
-		if (CHAN_ARRAY_TEST(devpriv->chanBipolar, s->async->cur_chan)) {
+		if (CHAN_ARRAY_TEST(devpriv->chanBipolar, s->async->cur_chan))
 			sample = d + 2048;	/* convert to comedi unsigned data */
-		} else {
+		else
 			sample = d;
-		}
+
 		if (!comedi_buf_put(s->async, sample))
 			return -1;
 
@@ -1493,9 +1492,9 @@ static int ai_process_dma(struct comedi_device *dev, struct comedi_subdevice *s)
 
 		if (CHAN_ARRAY_TEST(devpriv->chanBipolar, s->async->cur_chan)) {
 			sample = (*dp >> 3) + 2048;	/* convert to comedi unsigned data */
-		} else {
+		else
 			sample = *dp >> 3;	/* low 3 bits are marker lines */
-		}
+
 		*dp++ = sample;	/* put processed value back */
 
 		if (++s->async->cur_chan >= s->async->cmd.chanlist_len)
@@ -1546,9 +1545,8 @@ static irqreturn_t rtd_interrupt(int irq,	/* interrupt number (ignored) */
 	u16 fifoStatus;
 	struct comedi_subdevice *s = dev->subdevices + 0;	/* analog in subdevice */
 
-	if (!dev->attached) {
+	if (!dev->attached)
 		return IRQ_NONE;
-	}
 
 	devpriv->intCount++;	/* DEBUG statistics */
 
@@ -1594,9 +1592,8 @@ static irqreturn_t rtd_interrupt(int irq,	/* interrupt number (ignored) */
 
 	status = RtdInterruptStatus(dev);
 	/* if interrupt was not caused by our board, or handled above */
-	if (0 == status) {
+	if (0 == status)
 		return IRQ_HANDLED;
-	}
 
 	if (status & IRQM_ADC_ABOUT_CNT) {	/* sample count -> read FIFO */
 		/* since the priority interrupt controller may have queued a sample
@@ -1734,33 +1731,32 @@ static int rtd_ai_cmdtest(struct comedi_device *dev,
 
 	tmp = cmd->start_src;
 	cmd->start_src &= TRIG_NOW;
-	if (!cmd->start_src || tmp != cmd->start_src) {
+	if (!cmd->start_src || tmp != cmd->start_src)
 		err++;
-	}
 
 	tmp = cmd->scan_begin_src;
 	cmd->scan_begin_src &= TRIG_TIMER | TRIG_EXT;
-	if (!cmd->scan_begin_src || tmp != cmd->scan_begin_src) {
+	if (!cmd->scan_begin_src || tmp != cmd->scan_begin_src)
 		err++;
-	}
+
 
 	tmp = cmd->convert_src;
 	cmd->convert_src &= TRIG_TIMER | TRIG_EXT;
-	if (!cmd->convert_src || tmp != cmd->convert_src) {
+	if (!cmd->convert_src || tmp != cmd->convert_src)
 		err++;
-	}
+
 
 	tmp = cmd->scan_end_src;
 	cmd->scan_end_src &= TRIG_COUNT;
-	if (!cmd->scan_end_src || tmp != cmd->scan_end_src) {
+	if (!cmd->scan_end_src || tmp != cmd->scan_end_src)
 		err++;
-	}
+
 
 	tmp = cmd->stop_src;
 	cmd->stop_src &= TRIG_COUNT | TRIG_NONE;
-	if (!cmd->stop_src || tmp != cmd->stop_src) {
+	if (!cmd->stop_src || tmp != cmd->stop_src)
 		err++;
-	}
+
 
 	if (err)
 		return 1;
@@ -1772,16 +1768,14 @@ static int rtd_ai_cmdtest(struct comedi_device *dev,
 	    cmd->scan_begin_src != TRIG_EXT) {
 		err++;
 	}
-	if (cmd->convert_src != TRIG_TIMER && cmd->convert_src != TRIG_EXT) {
+	if (cmd->convert_src != TRIG_TIMER && cmd->convert_src != TRIG_EXT)
 		err++;
-	}
-	if (cmd->stop_src != TRIG_COUNT && cmd->stop_src != TRIG_NONE) {
+
+	if (cmd->stop_src != TRIG_COUNT && cmd->stop_src != TRIG_NONE)
 		err++;
-	}
 
-	if (err) {
+	if (err)
 		return 2;
-	}
 
 	/* step 3: make sure arguments are trivially compatible */
 
@@ -1882,9 +1876,9 @@ static int rtd_ai_cmdtest(struct comedi_device *dev,
 		}
 	}
 
-	if (err) {
+	if (err)
 		return 3;
-	}
+
 
 	/* step 4: fix up any arguments */
 
@@ -1896,17 +1890,17 @@ static int rtd_ai_cmdtest(struct comedi_device *dev,
 		tmp = cmd->scan_begin_arg;
 		rtd_ns_to_timer(&cmd->scan_begin_arg,
 				cmd->flags & TRIG_ROUND_MASK);
-		if (tmp != cmd->scan_begin_arg) {
+		if (tmp != cmd->scan_begin_arg)
 			err++;
-		}
+
 	}
 	if (cmd->convert_src == TRIG_TIMER) {
 		tmp = cmd->convert_arg;
 		rtd_ns_to_timer(&cmd->convert_arg,
 				cmd->flags & TRIG_ROUND_MASK);
-		if (tmp != cmd->convert_arg) {
+		if (tmp != cmd->convert_arg)
 			err++;
-		}
+
 		if (cmd->scan_begin_src == TRIG_TIMER
 		    && (cmd->scan_begin_arg
 			< (cmd->convert_arg * cmd->scan_end_arg))) {
@@ -1916,9 +1910,8 @@ static int rtd_ai_cmdtest(struct comedi_device *dev,
 		}
 	}
 
-	if (err) {
+	if (err)
 		return 4;
-	}
 
 	return 0;
 }
@@ -2221,7 +2214,7 @@ static int rtd_ao_winsn(struct comedi_device *dev,
 		/* VERIFY: comedi range and offset conversions */
 
 		if ((range > 1)	/* bipolar */
-		    &&(data[i] < 2048)) {
+		    && (data[i] < 2048)) {
 			/* offset and sign extend */
 			val = (((int)data[i]) - 2048) << 3;
 		} else {	/* unipolor */
@@ -2267,9 +2260,9 @@ static int rtd_ao_rinsn(struct comedi_device *dev,
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 
-	for (i = 0; i < insn->n; i++) {
+	for (i = 0; i < insn->n; i++)
 		data[i] = devpriv->aoValue[chan];
-	}
+
 
 	return i;
 }
-- 
1.7.1

