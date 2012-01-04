Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab2ADMlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 07:41:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47296 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab2ADMle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 07:41:34 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, rmallon@gmail.com, joe@perches.com,
        valdis.kletnieks@vt.edu,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 11/11] Staging: comedi: fix line over 80 character issue in pcl818.c
Date: Wed,  4 Jan 2012 18:10:06 +0530
Message-Id: <1325680806-10917-11-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1325680806-10917-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1325680806-10917-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the pcl818.c file that fixes up a line
over 80 character warning found by the checkpatch.pl tool.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/pcl818.c |   36 ++++++++++++++++++++----------
 1 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 7344a53..a87871e 100644
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
@@ -347,19 +351,27 @@ struct pcl818_private {
 	unsigned int dmasamplsize;	/*  size in samples hwdmasize[0]/2 */
 	unsigned int last_top_dma;	/*  DMA pointer in last RTC int */
 	int next_dma_buf;	/*  which DMA buffer will be used next round */
-	long dma_runs_to_end;	/*  how many we must permorm DMA transfer to end of record */
-	unsigned long last_dma_run;	/*  how many bytes we must transfer on last DMA page */
-	unsigned char neverending_ai;	/*  if=1, then we do neverending record (you must use cancel()) */
-	unsigned int ns_min;	/*  manimal allowed delay between samples (in us) for actual card */
+	/* how many we must permorm DMA transfer to end of record */
+	long dma_runs_to_end;
+	/* how many bytes we must transfer on last DMA page */
+	unsigned long last_dma_run;
+	/* if=1, then we do neverending record (you must use cancel()) */
+	unsigned char neverending_ai;
+	/* manimal allowed delay between samples (in us) for actual card */
+	unsigned int ns_min;
 	int i8253_osc_base;	/*  1/frequency of on board oscilator in ns */
 	int irq_free;		/*  1=have allocated IRQ */
 	int irq_blocked;	/*  1=IRQ now uses any subdev */
-	int irq_was_now_closed;	/*  when IRQ finish, there's stored int818_mode for last interrupt */
-	int ai_mode;		/*  who now uses IRQ - 1=AI1 int, 2=AI1 dma, 3=AI3 int, 4AI3 dma */
-	struct comedi_subdevice *last_int_sub;	/*  ptr to subdevice which now finish */
+	/* when IRQ finish, there's stored int818_mode for last interrupt */
+	int irq_was_now_closed;
+	/* who now uses IRQ - 1=AI1 int, 2=AI1 dma, 3=AI3 int, 4AI3 dma */
+	int ai_mode;
+	/* ptr to subdevice which now finish */
+	struct comedi_subdevice *last_int_sub;
 	int ai_act_scan;	/*  how many scans we finished */
 	int ai_act_chan;	/*  actual position in actual scan */
-	unsigned int act_chanlist[16];	/*  MUX setting for actual AI operations */
+	/* MUX setting for actual AI operations */
+	unsigned int act_chanlist[16];
 	unsigned int act_chanlist_len;	/*  how long is actual MUX list */
 	unsigned int act_chanlist_pos;	/*  actual position in MUX list */
 	unsigned int ai_scans;	/*  len of scanlist */
-- 
1.7.0.4

