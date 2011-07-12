Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab1GLF4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 01:56:17 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49911 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab1GLF4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 01:56:16 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 18/18] Staging: comedi: fix warning:line over 80 character issue in pcl816.c
Date: Tue, 12 Jul 2011 11:38:55 +0530
Message-Id: <1310450935-13110-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH 1/1]Staging: comedi: fix warning: line over 80 character issue in pcl816.c>
References: <[PATCH 1/1]Staging: comedi: fix warning: line over 80 character issue in pcl816.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the pcl816.c file that fixes up a  warning: line over 80 character found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/pcl816.c |   54 +++++++++++++++++++-----------
 1 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl816.c b/drivers/staging/comedi/drivers/pcl816.c
index 0b9bee3..02914d7 100644
--- a/drivers/staging/comedi/drivers/pcl816.c
+++ b/drivers/staging/comedi/drivers/pcl816.c
@@ -109,12 +109,16 @@ struct pcl816_board {
 	const char *name;	/*  board name */
 	int n_ranges;		/*  len of range list */
 	int n_aichan;		/*  num of A/D chans in diferencial mode */
-	unsigned int ai_ns_min;	/*  minimal allowed delay between samples (in ns) */
+	unsigned int ai_ns_min;	/*  minimal allowed delay between
+				 * samples (in ns)
+				 */
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
@@ -155,8 +159,8 @@ static int pcl816_attach(struct comedi_device *dev,
 static int pcl816_detach(struct comedi_device *dev);
 
 #ifdef unused
-static int RTC_lock = 0;	/* RTC lock */
-static int RTC_timer_lock = 0;	/* RTC int lock */
+static int RTC_lock;	/* RTC lock */
+static int RTC_timer_lock;	/* RTC int lock */
 #endif
 
 static struct comedi_driver driver_pcl816 = {
@@ -198,29 +202,39 @@ struct pcl816_private {
 	unsigned int dmasamplsize;	/*  size in samples hwdmasize[0]/2 */
 	unsigned int last_top_dma;	/*  DMA pointer in last RTC int */
 	int next_dma_buf;	/*  which DMA buffer will be used next round */
-	long dma_runs_to_end;	/*  how many we must permorm DMA transfer to end of record */
-	unsigned long last_dma_run;	/*  how many bytes we must transfer on last DMA page */
-
+	long dma_runs_to_end;	/* how many we must permorm DMA transfer
+				 * to end of record
+				 */
+	unsigned long last_dma_run;	/* how many bytes we must transfer
+					 * on last DMA page
+					 */
 	unsigned int ai_scans;	/*  len of scanlist */
-	unsigned char ai_neverending;	/*  if=1, then we do neverending record (you must use cancel()) */
+	/* if=1, then we do neverending record (you must use cancel()) */
+	unsigned char ai_neverending;
 	int irq_free;		/*  1=have allocated IRQ */
 	int irq_blocked;	/*  1=IRQ now uses any subdev */
 #ifdef unused
 	int rtc_irq_blocked;	/*  1=we now do AI with DMA&RTC */
 #endif
-	int irq_was_now_closed;	/*  when IRQ finish, there's stored int816_mode for last interrupt */
-	int int816_mode;	/*  who now uses IRQ - 1=AI1 int, 2=AI1 dma, 3=AI3 int, 4AI3 dma */
-	struct comedi_subdevice *last_int_sub;	/*  ptr to subdevice which now finish */
+	/* when IRQ finish, there's stored int816_mode for last interrupt */
+	int irq_was_now_closed;
+	/* who now uses IRQ - 1=AI1 int, 2=AI1 dma, 3=AI3 int, 4AI3 dma */
+	int int816_mode;
+	/* ptr to subdevice which now finish */
+	struct comedi_subdevice *last_int_sub;
 	int ai_act_scan;	/*  how many scans we finished */
-	unsigned int ai_act_chanlist[16];	/*  MUX setting for actual AI operations */
-	unsigned int ai_act_chanlist_len;	/*  how long is actual MUX list */
-	unsigned int ai_act_chanlist_pos;	/*  actual position in MUX list */
-	unsigned int ai_n_chan;		/*  how many channels per scan */
-	unsigned int ai_poll_ptr;	/*  how many sampes transfer poll */
-	struct comedi_subdevice *sub_ai;	/*  ptr to AI subdevice */
+	/* MUX setting for actual AI  operations */
+	unsigned int ai_act_chanlist[16];
+	/* how long is actual MUX list */
+	unsigned int ai_act_chanlist_len;
+	/* actual position in MUX list */
+	unsigned int ai_act_chanlist_pos;
+	unsigned int ai_n_chan;		/* how many channels per scan */
+	unsigned int ai_poll_ptr;	/* how many sampes transfer poll */
+	struct comedi_subdevice *sub_ai;	/* ptr to AI subdevice */
 #ifdef unused
-	struct timer_list rtc_irq_timer;	/*  timer for RTC sanity check */
-	unsigned long rtc_freq;	/*  RTC int freq */
+	struct timer_list rtc_irq_timer;	/* timer for RTC sanity check */
+	unsigned long rtc_freq;	/* RTC int freq */
 #endif
 };
 
-- 
1.6.5.2

