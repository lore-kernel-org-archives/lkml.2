Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab1GKNzD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 09:55:03 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41715 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757468Ab1GKNzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 09:55:00 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 14/14] Staging: comedi: fix line over 80 chracter issue in pcl818.c
Date: Mon, 11 Jul 2011 19:37:41 +0530
Message-Id: <1310393261-30778-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH 13/13]Staging: comedi: fix line over 80 character issue in pcl818.c>
References: <[PATCH 13/13]Staging: comedi: fix line over 80 character issue in pcl818.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the pcl818.c file that fixes up a line over 80 character warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/pcl818.c |   30 +++++++++++++++++++++---------
 1 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 37dcd7c..4fa6d08 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -262,12 +262,15 @@ struct pcl818_board {
 	int n_ranges;		/*  len of range list */
 	int n_aichan_se;	/*  num of A/D chans in single ended  mode */
 	int n_aichan_diff;	/*  num of A/D chans in diferencial mode */
-	unsigned int ns_min;	/*  minimal allowed delay between samples (in ns) */
+	/* minimal allowed delay between samples (in ns) */
+	unsigned int ns_min;
 	int n_aochan;		/*  num of D/A chans */
 	int n_dichan;		/*  num of DI chans */
 	int n_dochan;		/*  num of DO chans */
-	const struct comedi_lrange *ai_range_type;	/*  default A/D rangelist */
-	const struct comedi_lrange *ao_range_type;	/*  default D/A rangelist */
+	/* default A/D rangelist */
+	const struct comedi_lrange *ai_range_type;
+	/* default D/A rangelist */
+	const struct comedi_lrange *ao_range_type;
 	unsigned int io_range;	/*  len of IO space */
 	unsigned int IRQbits;	/*  allowed interrupts */
 	unsigned int DMAbits;	/*  allowed DMA chans */
@@ -336,7 +339,8 @@ struct pcl818_private {
 	unsigned long rtc_iobase;	/*  RTC port region */
 	unsigned int rtc_iosize;
 	unsigned int rtc_irq;
-	struct timer_list rtc_irq_timer;	/*  timer for RTC sanity check */
+	/* timer for RTC sanity check */
+	struct timer_list rtc_irq_timer;
 	unsigned long rtc_freq;	/*  RTC int freq */
 	int rtc_irq_blocked;	/*  1=we now do AI with DMA&RTC */
 #endif
@@ -346,11 +350,19 @@ struct pcl818_private {
 	unsigned int hwdmasize[2];	/*  len of DMA buffers in Bytes */
 	unsigned int dmasamplsize;	/*  size in samples hwdmasize[0]/2 */
 	unsigned int last_top_dma;	/*  DMA pointer in last RTC int */
-	int next_dma_buf;	/*  which DMA buffer will be used next round */
-	long dma_runs_to_end;	/*  how many we must permorm DMA transfer to end of record */
-	unsigned long last_dma_run;	/*  how many bytes we must transfer on last DMA page */
-	unsigned char neverending_ai;	/*  if=1, then we do neverending record (you must use cancel()) */
-	unsigned int ns_min;	/*  manimal allowed delay between samples (in us) for actual card */
+	/* which DMA buffer will be used next round */
+	int next_dma_buf;
+	/* how many we must permorm DMA transfer to end of record */
+	long dma_runs_to_end;
+	/* how many bytes we must transfer on last DMA page */
+	unsigned long last_dma_run;
+	/* if=1, then we do neverending record
+	 * (you must use cancel ())
+	 */
+	unsigned char neverending_ai;
+	/* manimal allowed delay between samples (in us) for actual
+	 * card
+	 */
+	unsigned int ns_min;
 	int i8253_osc_base;	/*  1/frequency of on board oscilator in ns */
 	int irq_free;		/*  1=have allocated IRQ */
 	int irq_blocked;	/*  1=IRQ now uses any subdev */
-- 
1.6.5.2

