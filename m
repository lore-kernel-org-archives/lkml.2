Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab1GMNQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 09:16:40 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44076 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab1GMNQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 09:16:38 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 25/25] Staging: comedi: fix warning: line over 80 character issue in das1800.c
Date: Wed, 13 Jul 2011 18:59:15 +0530
Message-Id: <1310563755-20911-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH 1/3]Staging: comedi:fix line over 80 character issue in das1800.c>
References: <[PATCH 1/3]Staging: comedi:fix line over 80 character issue in das1800.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the das1800.c file that fixes up a  warning: line over 80 character found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/das1800.c |   40 +++++++++++++++++++----------
 1 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index a6df30b..639979b 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -95,8 +95,8 @@ Only the DAS-1801ST has been tested by me.
 Unipolar and bipolar ranges cannot be mixed in the channel/gain list.
 
 TODO:
-	Make it automatically allocate irq and dma channels if they are not specified
-	Add support for analog out on 'ao' cards
+	Make it automatically allocate irq and dma channels if they are not
+	specified Add support for analog out on 'ao' cards
 	read insn for analog out
 */
 
@@ -115,7 +115,8 @@ TODO:
 #define DAS1800_SIZE           16	/* uses 16 io addresses */
 #define FIFO_SIZE              1024	/*  1024 sample fifo */
 #define TIMER_BASE             200	/*  5 Mhz master clock */
-#define UNIPOLAR               0x4	/*  bit that determines whether input range is uni/bipolar */
+/* bit that determines whether input range is uni/bipolar */
+#define UNIPOLAR               0x4
 #define DMA_BUF_SIZE           0x1ff00	/*  size in bytes of dma buffers */
 
 /* Registers for the das1800 */
@@ -141,7 +142,8 @@ TODO:
 #define   DMA_CH5_CH6             0x5
 #define   DMA_CH6_CH7             0x6
 #define   DMA_CH7_CH5             0x7
-#define   DMA_ENABLED             0x3	/* mask used to determine if dma is enabled */
+/* mask used to determine if dma is enabled */
+#define   DMA_ENABLED             0x3
 #define   DMA_DUAL                0x4
 #define   IRQ3                    0x8
 #define   IRQ5                    0x10
@@ -159,7 +161,9 @@ TODO:
 #define   SD                      0x40
 #define   UB                      0x80
 #define DAS1800_STATUS          0x7
-/* bits that prevent interrupt status bits (and CVEN) from being cleared on write */
+/* bits that prevent interrupt status bits
+ * (and CVEN) on write from being cleared
+ */
 #define   CLEAR_INTR_MASK         (CVEN_MASK | 0x1f)
 #define   INT                     0x1
 #define   DMATC                   0x2
@@ -173,8 +177,8 @@ TODO:
 #define DAS1800_BURST_RATE      0x9
 #define DAS1800_QRAM_ADDRESS    0xa
 #define DAS1800_COUNTER         0xc
-
-#define IOBASE2                   0x400	/* offset of additional ioports used on 'ao' cards */
+/* offset of additional ioports used on 'ao' cards */
+#define IOBASE2                   0x400
 
 enum {
 	das1701st, das1701st_da, das1702st, das1702st_da, das1702hr,
@@ -262,7 +266,9 @@ struct das1800_board {
 	int qram_len;		/* length of card's channel / gain queue */
 	int common;		/* supports AREF_COMMON flag */
 	int do_n_chan;		/* number of digital output channels */
-	int ao_ability;		/* 0 == no analog out, 1 == basic analog out, 2 == waveform analog out */
+	int ao_ability;		/* 0 == no analog out, 1 == basic analog out,
+				 * 2 == waveform analog out
+				 */
 	int ao_n_chan;		/* number of analog out channels */
 	const struct comedi_lrange *range_ai;	/* available input ranges */
 };
@@ -479,8 +485,10 @@ static const struct das1800_board das1800_boards[] = {
 
 struct das1800_private {
 	volatile unsigned int count;	/* number of data points left to be taken */
-	unsigned int divisor1;	/* value to load into board's counter 1 for timed conversions */
-	unsigned int divisor2;	/* value to load into board's counter 2 for timed conversions */
+	/* value to load into board's counter 1 for timed conversions */
+	unsigned int divisor1;
+	/* value to load into board's counter 2 for timed conversions */
+	unsigned int divisor2;
 	int do_bits;		/* digital output bits */
 	int irq_dma_bits;	/* bits for control register b */
 	/* dma bits for control register b, stored so that dma can be
@@ -491,10 +499,14 @@ struct das1800_private {
 	volatile unsigned int dma_current;	/* dma channel currently in use */
 	uint16_t *ai_buf0;	/* pointers to dma buffers */
 	uint16_t *ai_buf1;
-	uint16_t *dma_current_buf;	/* pointer to dma buffer currently being used */
-	unsigned int dma_transfer_size;	/* size of transfer currently used, in bytes */
-	unsigned long iobase2;	/* secondary io address used for analog out on 'ao' boards */
-	short ao_update_bits;	/* remembers the last write to the 'update' dac */
+	/* pointer to dma buffer currently being used */
+	uint16_t *dma_current_buf;
+	/* size of transfer currently used, in bytes */
+	unsigned int dma_transfer_size;
+	/* secondary io address used for analog out on 'ao' boards */
+	unsigned long iobase2;
+	/* remembers the last write to the 'update' dac */
+	short ao_update_bits;
 };
 
 #define devpriv ((struct das1800_private *)dev->private)
-- 
1.6.5.2

