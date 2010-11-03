Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab0KCVTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 17:19:51 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49641 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab0KCVTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 17:19:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uprLEusgPsGZIough0rXEGGa3knOYIViY6Y7/awvuyW4no/e/DOWDOAbvnQGA8v17Z
         +ckWjLv5Ob8tBdXkv8cqO4dYJ0Y//lXcy9oXgmM+t6W9vrg9VK52I+eDrJ80lkcMAjeM
         z36UsiIklTkzj3q/lHPBUzNclE/7e5FgrYZcM=
From: Damian Varayud <davarayud@gmail.com>
To: gregkh@suse.de, harmonco@engr.orst.edu, sam.j.richardson@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Acosta Brian Miguel <nickcs_4@hotmail.com>
Subject: [PATCH 2/3] Staging: comedi: fix brace coding style issue in pcl816.c
Date: Wed,  3 Nov 2010 18:19:21 -0300
Message-Id: <1288819162-6330-2-git-send-email-user@netbu>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1288819162-6330-1-git-send-email-user@netbu>
References: <1288819162-6330-1-git-send-email-user@netbu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ni_labpc.c file that fixes up lineovers warning and error at initializing variables found by the checkpatch.pl tool

Signed-off-by: Acosta Brian Miguel <nickcs_4@hotmail.com>
---
 drivers/staging/comedi/drivers/pcl816.c |  112 ++++++++++++++++++++-----------
 1 files changed, 73 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl816.c b/drivers/staging/comedi/drivers/pcl816.c
index 3d0f018..133ac6e 100644
--- a/drivers/staging/comedi/drivers/pcl816.c
+++ b/drivers/staging/comedi/drivers/pcl816.c
@@ -104,16 +104,24 @@ static const struct comedi_lrange range_pcl816 = { 8, {
 };
 
 struct pcl816_board {
-
-	const char *name;	/*  board name */
-	int n_ranges;		/*  len of range list */
-	int n_aichan;		/*  num of A/D chans in diferencial mode */
-	unsigned int ai_ns_min;	/*  minimal alllowed delay between samples (in ns) */
-	int n_aochan;		/*  num of D/A chans */
-	int n_dichan;		/*  num of DI chans */
-	int n_dochan;		/*  num of DO chans */
-	const struct comedi_lrange *ai_range_type;	/*  default A/D rangelist */
-	const struct comedi_lrange *ao_range_type;	/*  default D/A rangelist */
+	/*  board name */
+	const char *name;
+	/*  len of range list */
+	int n_ranges;
+	/*  num of A/D chans in diferencial mode */
+	int n_aichan;
+	/*  minimal alllowed delay between samples (in ns) */
+	unsigned int ai_ns_min;
+	/*  num of D/A chans */
+	int n_aochan;
+	/*  num of DI chans */
+	int n_dichan;
+	/*  num of DO chans */
+	int n_dochan;
+	/*  default A/D rangelist */
+	const struct comedi_lrange *ai_range_type;
+	/*  default D/A rangelist */
+	const struct comedi_lrange *ao_range_type;
 	unsigned int io_range;	/*  len of IO space */
 	unsigned int IRQbits;	/*  allowed interrupts */
 	unsigned int DMAbits;	/*  allowed DMA chans */
@@ -154,8 +162,8 @@ static int pcl816_attach(struct comedi_device *dev,
 static int pcl816_detach(struct comedi_device *dev);
 
 #ifdef unused
-static int RTC_lock = 0;	/* RTC lock */
-static int RTC_timer_lock = 0;	/* RTC int lock */
+static int RTC_lock;	/* RTC lock */
+static int RTC_timer_lock;	/* RTC int lock */
 #endif
 
 static struct comedi_driver driver_pcl816 = {
@@ -190,36 +198,60 @@ struct pcl816_private {
 	unsigned int rtc_iosize;
 	unsigned int rtc_irq;
 #endif
-	unsigned long dmabuf[2];	/*  pointers to begin of DMA buffers */
-	unsigned int dmapages[2];	/*  len of DMA buffers in PAGE_SIZEs */
-	unsigned int hwdmaptr[2];	/*  hardware address of DMA buffers */
-	unsigned int hwdmasize[2];	/*  len of DMA buffers in Bytes */
-	unsigned int dmasamplsize;	/*  size in samples hwdmasize[0]/2 */
-	unsigned int last_top_dma;	/*  DMA pointer in last RTC int */
-	int next_dma_buf;	/*  which DMA buffer will be used next round */
-	long dma_runs_to_end;	/*  how many we must permorm DMA transfer to end of record */
-	unsigned long last_dma_run;	/*  how many bytes we must transfer on last DMA page */
-
-	unsigned int ai_scans;	/*  len of scanlist */
-	unsigned char ai_neverending;	/*  if=1, then we do neverending record (you must use cancel()) */
-	int irq_free;		/*  1=have allocated IRQ */
-	int irq_blocked;	/*  1=IRQ now uses any subdev */
+	/*  pointers to begin of DMA buffers */
+	unsigned long dmabuf[2];
+	/*  len of DMA buffers in PAGE_SIZEs */
+	unsigned int dmapages[2];
+	/*  hardware address of DMA buffers */
+	unsigned int hwdmaptr[2];
+	/*  len of DMA buffers in Bytes */
+	unsigned int hwdmasize[2];
+	/*  size in samples hwdmasize[0]/2 */
+	unsigned int dmasamplsize;
+	/*  DMA pointer in last RTC int */
+	unsigned int last_top_dma;
+	/*  which DMA buffer will be used next round */
+	int next_dma_buf;
+	/*  how many we must permorm DMA transfer to end of record */
+	long dma_runs_to_end;
+	/*  how many bytes we must transfer on last DMA page */
+	unsigned long last_dma_run;
+	/*  len of scanlist */
+	unsigned int ai_scans;
+	/*  if=1, then we do neverending record (you must use cancel()) */
+	unsigned char ai_neverending;
+	/*  1=have allocated IRQ */
+	int irq_free;
+	/*  1=IRQ now uses any subdev */
+	int irq_blocked;
 #ifdef unused
 	int rtc_irq_blocked;	/*  1=we now do AI with DMA&RTC */
 #endif
-	int irq_was_now_closed;	/*  when IRQ finish, there's stored int816_mode for last interrupt */
-	int int816_mode;	/*  who now uses IRQ - 1=AI1 int, 2=AI1 dma, 3=AI3 int, 4AI3 dma */
-	struct comedi_subdevice *last_int_sub;	/*  ptr to subdevice which now finish */
-	int ai_act_scan;	/*  how many scans we finished */
-	unsigned int ai_act_chanlist[16];	/*  MUX setting for actual AI operations */
-	unsigned int ai_act_chanlist_len;	/*  how long is actual MUX list */
-	unsigned int ai_act_chanlist_pos;	/*  actual position in MUX list */
-	unsigned int ai_n_chan;		/*  how many channels per scan */
-	unsigned int ai_poll_ptr;	/*  how many sampes transfer poll */
-	struct comedi_subdevice *sub_ai;	/*  ptr to AI subdevice */
+	/*  when IRQ finish, there's stored int816_mode for last interrupt */
+	int irq_was_now_closed;
+	/*  who now uses IRQ - 1=AI1 int, 2=AI1 dma, 3=AI3 int, 4AI3 dma */
+	int int816_mode;
+	/*  ptr to subdevice which now finish */
+	struct comedi_subdevice *last_int_sub;
+	/*  how many scans we finished */
+	int ai_act_scan;
+	/*  MUX setting for actual AI operations */
+	unsigned int ai_act_chanlist[16];
+	/*  how long is actual MUX list */
+	unsigned int ai_act_chanlist_len;
+	/*  actual position in MUX list */
+	unsigned int ai_act_chanlist_pos;
+	/*  how many channels per scan */
+	unsigned int ai_n_chan;
+	/*  how many sampes transfer poll */
+	unsigned int ai_poll_ptr;
+	/*  ptr to AI subdevice */
+	struct comedi_subdevice *sub_ai;
 #ifdef unused
-	struct timer_list rtc_irq_timer;	/*  timer for RTC sanity check */
-	unsigned long rtc_freq;	/*  RTC int freq */
+	/*  timer for RTC sanity check */
+	struct timer_list rtc_irq_timer;
+	/*  RTC int freq */
+	unsigned long rtc_freq;
 #endif
 };
 
@@ -1254,7 +1286,9 @@ no_rtc:
 		devpriv->dmapages[0] = pages;
 		devpriv->hwdmaptr[0] = virt_to_bus((void *)devpriv->dmabuf[0]);
 		devpriv->hwdmasize[0] = (1 << pages) * PAGE_SIZE;
-		/* printk("%d %d %ld, ",devpriv->dmapages[0],devpriv->hwdmasize[0],PAGE_SIZE); */
+		/* printk("%d %d %ld, ",devpriv->dmapages[0],
+			devpriv->hwdmasize[0],PAGE_SIZE);
+		*/
 
 		if (devpriv->dma_rtc == 0) {	/*  we must do duble buff :-( */
 			devpriv->dmabuf[1] = __get_dma_pages(GFP_KERNEL, pages);
-- 
1.7.0.4

