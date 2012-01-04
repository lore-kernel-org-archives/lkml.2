Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab2ADMmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 07:42:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47296 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab2ADMlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 07:41:03 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, rmallon@gmail.com, joe@perches.com,
        valdis.kletnieks@vt.edu,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 06/11] Staging: comedi: fix line over 80 character issue in ni_at_a2150.c
Date: Wed,  4 Jan 2012 18:10:01 +0530
Message-Id: <1325680806-10917-6-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1325680806-10917-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1325680806-10917-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ni_at_a2150.c file that fixes up a line
over 80 character warning found by the checkpatch.pl tool.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/ni_at_a2150.c |   40 ++++++++++++++++++--------
 1 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index f1a15ed..4f105fa 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -88,8 +88,10 @@ TRIG_WAKE_EOS
 #define   CLOCK_SELECT_BITS(x)		(((x) & 0x3) << 3)
 #define   CLOCK_DIVISOR_BITS(x)		(((x) & 0x3) << 5)
 #define   CLOCK_MASK		(0xf << 3)
-#define   ENABLE0_BIT		0x80	/*  enable (don't internally ground) channels 0 and 1 */
-#define   ENABLE1_BIT		0x100	/*  enable (don't internally ground) channels 2 and 3 */
+/* enable (don't internally ground) channels 0 and 1 */
+#define   ENABLE0_BIT           0x80
+/* enable (don't internally ground) channels 2 and 3 */
+#define   ENABLE1_BIT           0x100
 #define   AC0_BIT		0x200	/*  ac couple channels 0,1 */
 #define   AC1_BIT		0x400	/*  ac couple channels 2,3 */
 #define   APD_BIT		0x800	/*  analog power down */
@@ -101,26 +103,31 @@ TRIG_WAKE_EOS
 #define FIFO_START_REG		0x6	/*  software start aquistion trigger */
 #define FIFO_RESET_REG		0x8	/*  clears fifo + fifo flags */
 #define FIFO_DATA_REG		0xa	/*  read data */
-#define DMA_TC_CLEAR_REG		0xe	/*  clear dma terminal count interrupt */
+/* clear dma terminal count interrupt */
+#define DMA_TC_CLEAR_REG                0xe
 #define STATUS_REG		0x12	/*  read only */
 #define   FNE_BIT		0x1	/*  fifo not empty */
 #define   OVFL_BIT		0x8	/*  fifo overflow */
 #define   EDAQ_BIT		0x10	/*  end of acquisition interrupt */
 #define   DCAL_BIT		0x20	/*  offset calibration in progress */
 #define   INTR_BIT		0x40	/*  interrupt has occurred */
-#define   DMA_TC_BIT		0x80	/*  dma terminal count interrupt has occurred */
+/* dma terminal count interrupt has occurred */
+#define   DMA_TC_BIT            0x80
 #define   ID_BITS(x)	(((x) >> 8) & 0x3)
 #define IRQ_DMA_CNTRL_REG		0x12	/*  write only */
 #define   DMA_CHAN_BITS(x)		((x) & 0x7)	/*  sets dma channel */
 #define   DMA_EN_BIT		0x8	/*  enables dma */
-#define   IRQ_LVL_BITS(x)		(((x) & 0xf) << 4)	/*  sets irq level */
+/* sets irq level */
+#define   IRQ_LVL_BITS(x)               (((x) & 0xf) << 4)
 #define   FIFO_INTR_EN_BIT		0x100	/*  enable fifo interrupts */
 #define   FIFO_INTR_FHF_BIT		0x200	/*  interrupt fifo half full */
-#define   DMA_INTR_EN_BIT 		0x800	/*  enable interrupt on dma terminal count */
+/* enable interrupt on dma terminal count */
+#define   DMA_INTR_EN_BIT               0x800
 #define   DMA_DEM_EN_BIT	0x1000	/*  enables demand mode dma */
 #define I8253_BASE_REG		0x14
 #define I8253_MODE_REG		0x17
-#define   HW_COUNT_DISABLE		0x30	/*  disable hardware counting of conversions */
+/* disable hardware counting of conversions */
+#define   HW_COUNT_DISABLE             0x30
 
 struct a2150_board {
 	const char *name;
@@ -512,7 +519,9 @@ static int a2150_ai_cmdtest(struct comedi_device *dev,
 	if (err)
 		return 1;
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/* step 2: make sure trigger sources are unique and mutually
+	 * compatible
+	 */
 
 	if (cmd->start_src != TRIG_NOW && cmd->start_src != TRIG_EXT)
 		err++;
@@ -697,7 +706,10 @@ static int a2150_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	if (cmd->start_src == TRIG_EXT) {
 		trigger_bits |= HW_TRIG_EN;
 	} else if (cmd->start_src == TRIG_OTHER) {
-		/*  XXX add support for level/slope start trigger using TRIG_OTHER */
+		/*
+		 * XXX add support for level/slope start trigger using
+		 * TRIG_OTHER
+		 */
 		comedi_error(dev, "you shouldn't see this?");
 	}
 	/*  send trigger config bits */
@@ -744,7 +756,9 @@ static int a2150_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 	/*  start acquisition for soft trigger */
 	outw(0, dev->iobase + FIFO_START_REG);
 
-	/* there is a 35.6 sample delay for data to get through the antialias filter */
+	/* there is a 35.6 sample delay for data to get through the antialias
+	 * filter
+	 */
 	for (n = 0; n < filter_delay; n++) {
 		for (i = 0; i < timeout; i++) {
 			if (inw(dev->iobase + STATUS_REG) & FNE_BIT)
@@ -785,8 +799,10 @@ static int a2150_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 	return n;
 }
 
-/* sets bits in devpriv->clock_bits to nearest approximation of requested period,
- * adjusts requested period to actual timing. */
+/*
+ * sets bits in devpriv->clock_bits to nearest approximation of requested
+ * period, adjusts requested period to actual timing.
+ */
 static int a2150_get_timing(struct comedi_device *dev, unsigned int *period,
 			    int flags)
 {
-- 
1.7.0.4

