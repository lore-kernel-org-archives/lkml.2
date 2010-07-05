Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab0GEROP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 13:14:15 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54763 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab0GEROM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 13:14:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=m9t05exztGaaGbBwoc4aRNalsSPt6wsXZ3EnH6o2LC/+93FLQ3shsUJPyDfVp2NgkD
         /zSId8EhQ4cdM6q5nuZ9guFh/sI0CeygumMh5ddBIoglwQ2t8x95vNwZAnxT5alUsHDW
         GOAdMQ+PCISMf625uNW1eo0PuUeKxWfgu8nqY=
Subject: [PATCH 1/2] Staging: dt3155: fix coding style issues in
 dt3155_drv.c
From: Joe Eloff <kagen101@gmail.com>
Reply-To: kagen101@gmail.com
To: Greg Kroah-Hartman <gregkh@suse.de>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Simon Horman <horms@verge.net.au>
Cc: devel <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Jul 2010 19:13:50 +0200
Message-ID: <1278350030.5396.25.camel@dermezel>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a19d065175340cdf0b93e3b23c134b887678fdf4 Mon Sep 17 00:00:00 2001
From: Joe Eloff <kagen101@gmail.com>
Date: Mon, 5 Jul 2010 18:55:08 +0200
Subject: [PATCH] Staging: dt3155: fix coding style issues in dt3155_drv.c

This is a patch to the dt3155_drv.c file that fixes up most warnings and errors found by the checkpatch.pl tool.
    * Errors:   93 -> 10
    * Warnings: 103-> 14
Signed-off-by: Joe Eloff <kagen101@gmail.com>
---
 drivers/staging/dt3155/dt3155_drv.c | 1443 +++++++++++++++++------------------
 1 files changed, 695 insertions(+), 748 deletions(-)

diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index 6d35a6f..75a2244 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -1,7 +1,7 @@
 /*
 
 Copyright 1996,2002,2005 Gregory D. Hager, Alfred A. Rizzi, Noah J. Cowan,
-                         Jason Lapenta, Scott Smedley, Greg Sharp
+			 Jason Lapenta, Scott Smedley, Greg Sharp
 
 This file is part of the DT3155 Device Driver.
 
@@ -27,14 +27,14 @@ MA 02111-1307 USA
   03-Jul-2000 JML       n/a
   10-Oct-2001 SS        port to 2.4 kernel
   02-Apr-2002 SS        Mods to use allocator as a standalone module;
-                        Merged John Roll's changes (john@cfa.harvard.edu)
-                        to make work with multiple boards.
+			Merged John Roll's changes (john@cfa.harvard.edu)
+			to make work with multiple boards.
   02-Jul-2002 SS        Merged James Rose's chages (rosejr@purdue.edu) to:
-                         * fix successive interrupt-driven captures
-                         * add select/poll support.
+			 * fix successive interrupt-driven captures
+			 * add select/poll support.
   10-Jul-2002 GCS       Add error check when ndevices > MAXBOARDS.
   02-Aug-2002 GCS       Fix field mode so that odd (lower) field is stored
-                        in lower half of buffer.
+			in lower half of buffer.
   05-Aug-2005 SS        port to 2.6 kernel.
   26-Oct-2009 SS	port to 2.6.30 kernel.
 
@@ -66,7 +66,7 @@ extern void printques(int);
 #include <linux/smp_lock.h>
 #include <linux/io.h>
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include "dt3155.h"
 #include "dt3155_drv.h"
@@ -89,9 +89,9 @@ int dt3155_errno = 0;
 #define MAXPCI    16
 
 #ifdef DT_DEBUG
-#define DT_3155_DEBUG_MSG(x,y) printk(x,y)
+#define DT_3155_DEBUG_MSG(x, y) printk(x, y)
 #else
-#define DT_3155_DEBUG_MSG(x,y)
+#define DT_3155_DEBUG_MSG(x, y)
 #endif
 
 /* wait queue for interrupts */
@@ -133,34 +133,34 @@ u32 unique_tag = 0;;
  * to idle.  I don't know why this works and the other way doesn't.
  * (James Rose)
  */
-static void quick_stop (int minor)
+static void quick_stop(int minor)
 {
-  struct dt3155_status *dts = &dt3155_status[minor];
-  struct dt3155_fbuffer *fb = &dts->fbuffer;
+	struct dt3155_status *dts = &dt3155_status[minor];
+	struct dt3155_fbuffer *fb = &dts->fbuffer;
 
-  // TODO: scott was here
+	/* TODO: scott was here */
 #if 1
-  int_csr_r.reg = readl(dt3155_lbase[minor] + INT_CSR);
-  /* disable interrupts */
-  int_csr_r.fld.FLD_END_EVE_EN = 0;
-  int_csr_r.fld.FLD_END_ODD_EN = 0;
-  writel(int_csr_r.reg, dt3155_lbase[minor] + INT_CSR);
-
-  dts->state &= ~(DT3155_STATE_STOP|0xff);
-  /* mark the system stopped: */
-  dts->state |= DT3155_STATE_IDLE;
-  fb->stop_acquire = 0;
-  fb->even_stopped = 0;
+	int_csr_r.reg = readl(dt3155_lbase[minor] + INT_CSR);
+	/* disable interrupts */
+	int_csr_r.fld.FLD_END_EVE_EN = 0;
+	int_csr_r.fld.FLD_END_ODD_EN = 0;
+	writel(int_csr_r.reg, dt3155_lbase[minor] + INT_CSR);
+
+	dts->state &= ~(DT3155_STATE_STOP|0xff);
+	/* mark the system stopped: */
+	dts->state |= DT3155_STATE_IDLE;
+	fb->stop_acquire = 0;
+	fb->even_stopped = 0;
 #else
-  dts->state |= DT3155_STATE_STOP;
-  fb->stop_acquire = 1;
+	dts->state |= DT3155_STATE_STOP;
+	fb->stop_acquire = 1;
 #endif
 
 }
 
 
 /*****************************************************
- *  dt3155_isr() Interrupt service routien
+ *  dt3155_isr() Interrupt service routine
  *
  * - looks like this isr supports IRQ sharing (or could) JML
  * - Assumes irq's are disabled, via SA_INTERRUPT flag
@@ -168,237 +168,210 @@ static void quick_stop (int minor)
  *****************************************************/
 static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
 {
-  int    minor = -1;
-  int    index;
-  unsigned long flags;
-  u32 buffer_addr;
-  void __iomem *mmio;
-  struct dt3155_status *dts;
-  struct dt3155_fbuffer *fb;
-
-  /* find out who issued the interrupt */
-  for (index = 0; index < ndevices; index++) {
-    if(dev_id == (void*) &dt3155_status[index])
-      {
-	minor = index;
-	break;
-      }
-  }
-
-  /* hopefully we should not get here */
-  if (minor < 0 || minor >= MAXBOARDS) {
-    printk(KERN_ERR "dt3155_isr called with invalid dev_id\n");
-    return;
-  }
-
-  mmio = dt3155_lbase[minor];
-  dts = &dt3155_status[minor];
-  fb = &dts->fbuffer;
-
-  /* Check for corruption and set a flag if so */
-  csr1_r.reg = readl(mmio + CSR1);
-
-  if ((csr1_r.fld.FLD_CRPT_EVE) || (csr1_r.fld.FLD_CRPT_ODD))
-    {
-      /* TODO: this should probably stop acquisition */
-      /* and set some flags so that dt3155_read      */
-      /* returns an error next time it is called     */
-      dt3155_errno = DT_ERR_CORRUPT;
-      printk("dt3155:  corrupt field\n");
-      return;
-    }
-
-  int_csr_r.reg = readl(mmio + INT_CSR);
-
-  /* Handle the even field ... */
-  if (int_csr_r.fld.FLD_END_EVE)
-    {
-      if ((dts->state & DT3155_STATE_MODE) == DT3155_STATE_FLD)
-	{
-	  fb->frame_count++;
+	int    minor = -1;
+	int    index;
+	unsigned long flags;
+	u32 buffer_addr;
+	void __iomem *mmio;
+	struct dt3155_status *dts;
+	struct dt3155_fbuffer *fb;
+
+	/* find out who issued the interrupt */
+	for (index = 0; index < ndevices; index++) {
+		if (dev_id == (void *) &dt3155_status[index]) {
+			minor = index;
+			break;
+		}
+	}
+
+	/* hopefully we should not get here */
+	if (minor < 0 || minor >= MAXBOARDS) {
+		printk(KERN_ERR "dt3155_isr called with invalid dev_id\n");
+		return;
 	}
 
-      ReadI2C(mmio, EVEN_CSR, &i2c_even_csr.reg);
+	mmio = dt3155_lbase[minor];
+	dts = &dt3155_status[minor];
+	fb = &dts->fbuffer;
 
-      /* Clear the interrupt? */
-      int_csr_r.fld.FLD_END_EVE = 1;
+	/* Check for corruption and set a flag if so */
+	csr1_r.reg = readl(mmio + CSR1);
 
-      /* disable the interrupt if last field */
-      if (fb->stop_acquire)
-	{
-	  printk("dt3155:  even stopped.\n");
-	  fb->even_stopped = 1;
-	  if (i2c_even_csr.fld.SNGL_EVE)
-	    {
-	      int_csr_r.fld.FLD_END_EVE_EN = 0;
-	    }
-	  else
-	    {
-	      i2c_even_csr.fld.SNGL_EVE  = 1;
-	    }
+	if ((csr1_r.fld.FLD_CRPT_EVE) || (csr1_r.fld.FLD_CRPT_ODD)) {
+		/* TODO: this should probably stop acquisition */
+		/* and set some flags so that dt3155_read      */
+		/* returns an error next time it is called     */
+		dt3155_errno = DT_ERR_CORRUPT;
+		printk(KERN_DEBUG "dt3155:  corrupt field\n");
+		return;
 	}
 
-      writel(int_csr_r.reg, mmio + INT_CSR);
+	int_csr_r.reg = readl(mmio + INT_CSR);
 
-      /* Set up next DMA if we are doing FIELDS */
-      if ((dts->state & DT3155_STATE_MODE) == DT3155_STATE_FLD)
-	{
-	  /* GCS (Aug 2, 2002) -- In field mode, dma the odd field
-	     into the lower half of the buffer */
-	  const u32 stride =  dts->config.cols;
-	  buffer_addr = fb->frame_info[fb->active_buf].addr +
-			(DT3155_MAX_ROWS / 2) * stride;
-	  local_save_flags(flags);
-	  local_irq_disable();
-	  wake_up_interruptible(&dt3155_read_wait_queue[minor]);
-
-	  /* Set up the DMA address for the next field */
-	  local_irq_restore(flags);
-	  writel(buffer_addr, mmio + ODD_DMA_START);
-	}
+	/* Handle the even field ... */
+	if (int_csr_r.fld.FLD_END_EVE) {
+		if ((dts->state & DT3155_STATE_MODE) == DT3155_STATE_FLD)
+			fb->frame_count++;
 
-      /* Check for errors. */
-      i2c_even_csr.fld.DONE_EVE = 1;
-      if (i2c_even_csr.fld.ERROR_EVE)
-	dt3155_errno = DT_ERR_OVERRUN;
+		ReadI2C(mmio, EVEN_CSR, &i2c_even_csr.reg);
 
-      WriteI2C(mmio, EVEN_CSR, i2c_even_csr.reg);
+		/* Clear the interrupt? */
+		int_csr_r.fld.FLD_END_EVE = 1;
 
-      /* Note that we actually saw an even field meaning  */
-      /* that subsequent odd field complete the frame     */
-      fb->even_happened = 1;
+		/* disable the interrupt if last field */
+		if (fb->stop_acquire) {
+			printk(KERN_DEBUG "dt3155:  even stopped.\n");
+			fb->even_stopped = 1;
+			if (i2c_even_csr.fld.SNGL_EVE)
+				int_csr_r.fld.FLD_END_EVE_EN = 0;
+			else
+				i2c_even_csr.fld.SNGL_EVE  = 1;
+		}
 
-      /* recording the time that the even field finished, this should be */
-      /* about time in the middle of the frame */
-      do_gettimeofday(&fb->frame_info[fb->active_buf].time);
-      return;
-    }
+		writel(int_csr_r.reg, mmio + INT_CSR);
+
+		/* Set up next DMA if we are doing FIELDS */
+		if ((dts->state & DT3155_STATE_MODE) == DT3155_STATE_FLD) {
+			/* GCS (Aug 2, 2002) -- In field mode, dma the odd field
+			into the lower half of the buffer */
+			const u32 stride =  dts->config.cols;
+			buffer_addr = fb->frame_info[fb->active_buf].addr +
+				(DT3155_MAX_ROWS / 2) * stride;
+			local_save_flags(flags);
+			local_irq_disable();
+			wake_up_interruptible(&dt3155_read_wait_queue[minor]);
+
+			/* Set up the DMA address for the next field */
+			local_irq_restore(flags);
+			writel(buffer_addr, mmio + ODD_DMA_START);
+		}
 
-  /* ... now handle the odd field */
-  if (int_csr_r.fld.FLD_END_ODD)
-    {
-      ReadI2C(mmio, ODD_CSR, &i2c_odd_csr.reg);
+		/* Check for errors. */
+		i2c_even_csr.fld.DONE_EVE = 1;
+		if (i2c_even_csr.fld.ERROR_EVE)
+			dt3155_errno = DT_ERR_OVERRUN;
 
-      /* Clear the interrupt? */
-      int_csr_r.fld.FLD_END_ODD = 1;
+		WriteI2C(mmio, EVEN_CSR, i2c_even_csr.reg);
 
-      if (fb->even_happened ||
-	  (dts->state & DT3155_STATE_MODE) == DT3155_STATE_FLD)
-	{
-	  fb->frame_count++;
-	}
+		/* Note that we actually saw an even field meaning  */
+		/* that subsequent odd field complete the frame     */
+		fb->even_happened = 1;
 
-      if (fb->stop_acquire && fb->even_stopped)
-	{
-	  printk(KERN_DEBUG "dt3155:  stopping odd..\n");
-	  if (i2c_odd_csr.fld.SNGL_ODD)
-	    {
-	      /* disable interrupts */
-	      int_csr_r.fld.FLD_END_ODD_EN = 0;
-	      dts->state &= ~(DT3155_STATE_STOP|0xff);
-
-	      /* mark the system stopped: */
-	      dts->state |= DT3155_STATE_IDLE;
-	      fb->stop_acquire = 0;
-	      fb->even_stopped = 0;
-
-	      printk(KERN_DEBUG "dt3155:  state is now %x\n", dts->state);
-	    }
-	  else
-	    {
-	      i2c_odd_csr.fld.SNGL_ODD  = 1;
-	    }
+		/* recording the time that the even field finished,
+		this should be about time in the middle of the frame */
+		do_gettimeofday(&fb->frame_info[fb->active_buf].time);
+		return;
 	}
 
-      writel(int_csr_r.reg, mmio + INT_CSR);
+	/* ... now handle the odd field */
+	if (int_csr_r.fld.FLD_END_ODD) {
+		ReadI2C(mmio, ODD_CSR, &i2c_odd_csr.reg);
+
+		/* Clear the interrupt? */
+		int_csr_r.fld.FLD_END_ODD = 1;
+
+		if (fb->even_happened ||
+		(dts->state & DT3155_STATE_MODE) == DT3155_STATE_FLD)
+			fb->frame_count++;
+
+		if (fb->stop_acquire && fb->even_stopped) {
+			printk(KERN_DEBUG "dt3155:  stopping odd..\n");
+			if (i2c_odd_csr.fld.SNGL_ODD) {
+				/* disable interrupts */
+				int_csr_r.fld.FLD_END_ODD_EN = 0;
+				dts->state &= ~(DT3155_STATE_STOP|0xff);
+
+				/* mark the system stopped: */
+				dts->state |= DT3155_STATE_IDLE;
+				fb->stop_acquire = 0;
+				fb->even_stopped = 0;
+
+				printk(KERN_DEBUG "dt3155:  state is now %x\n",
+				dts->state);
+			} else
+				i2c_odd_csr.fld.SNGL_ODD  = 1;
+		}
 
-      /* if the odd field has been acquired, then     */
-      /* change the next dma location for both fields */
-      /* and wake up the process if sleeping          */
-      if (fb->even_happened ||
-	   (dts->state & DT3155_STATE_MODE) == DT3155_STATE_FLD)
-	{
+		writel(int_csr_r.reg, mmio + INT_CSR);
 
-	  local_save_flags(flags);
-	  local_irq_disable();
+		/* if the odd field has been acquired, then     */
+		/* change the next dma location for both fields */
+		/* and wake up the process if sleeping          */
+		if (fb->even_happened ||
+		(dts->state & DT3155_STATE_MODE) == DT3155_STATE_FLD) {
+
+			local_save_flags(flags);
+			local_irq_disable();
 
 #ifdef DEBUG_QUES_B
-	  printques(minor);
+			printques(minor);
 #endif
-	  if (fb->nbuffers > 2)
-	    {
-	      if (!are_empty_buffers(minor))
-		{
-		  /* The number of active + locked buffers is
-		   * at most 2, and since there are none empty, there
-		   * must be at least nbuffers-2 ready buffers.
-		   * This is where we 'drop frames', oldest first. */
-		  push_empty(pop_ready(minor),  minor);
-		}
-
-	      /* The ready_que can't be full, since we know
-	       * there is one active buffer right now, so it's safe
-	       * to push the active buf on the ready_que. */
-	      push_ready(minor, fb->active_buf);
-	      /* There's at least 1 empty -- make it active */
-	      fb->active_buf = pop_empty(minor);
-	      fb->frame_info[fb->active_buf].tag = ++unique_tag;
-	    }
-	  else /* nbuffers == 2, special case */
-	    { /* There is 1 active buffer.
-	       * If there is a locked buffer, keep the active buffer
-	       * the same -- that means we drop a frame.
-	       */
-	      if (fb->locked_buf < 0)
-		{
-		  push_ready(minor, fb->active_buf);
-		  if (are_empty_buffers(minor))
-		    {
-		      fb->active_buf = pop_empty(minor);
-		    }
-		  else
-		    { /* no empty or locked buffers, so use a readybuf */
-		      fb->active_buf = pop_ready(minor);
-		    }
-		}
-	    }
+			if (fb->nbuffers > 2) {
+				if (!are_empty_buffers(minor)) {
+					/* The number of active + locked buffers is
+					 * at most 2, and since there are none empty, there
+					 * must be at least nbuffers-2 ready buffers.
+					 * This is where we 'drop frames', oldest first. */
+					push_empty(pop_ready(minor),  minor);
+				}
+
+				/* The ready_que can't be full, since we know
+				 * there is one active buffer right now, so it's safe
+				 * to push the active buf on the ready_que. */
+				push_ready(minor, fb->active_buf);
+				/* There's at least 1 empty -- make it active */
+				fb->active_buf = pop_empty(minor);
+				fb->frame_info[fb->active_buf].tag = ++unique_tag;
+			} else {  /* nbuffers == 2, special case */
+
+				/* There is 1 active buffer.
+				 * If there is a locked buffer, keep the active buffer
+				 * the same -- that means we drop a frame.
+				 */
+				if (fb->locked_buf < 0) {
+					push_ready(minor, fb->active_buf);
+					if (are_empty_buffers(minor))
+						fb->active_buf = pop_empty(minor);
+					else {
+						/* no empty or locked buffers, so use a readybuf */
+						fb->active_buf = pop_ready(minor);
+					}
+				}
+			}
 
 #ifdef DEBUG_QUES_B
-	  printques(minor);
+			printques(minor);
 #endif
 
-	  fb->even_happened = 0;
+			fb->even_happened = 0;
 
-	  wake_up_interruptible(&dt3155_read_wait_queue[minor]);
+			wake_up_interruptible(&dt3155_read_wait_queue[minor]);
 
-	  local_irq_restore(flags);
-	}
+			local_irq_restore(flags);
+		}
 
 
-      /* Set up the DMA address for the next frame/field */
-      buffer_addr = fb->frame_info[fb->active_buf].addr;
-      if ((dts->state & DT3155_STATE_MODE) == DT3155_STATE_FLD)
-	{
-	  writel(buffer_addr, mmio + EVEN_DMA_START);
-	}
-      else
-	{
-	  writel(buffer_addr, mmio + EVEN_DMA_START);
+		/* Set up the DMA address for the next frame/field */
+		buffer_addr = fb->frame_info[fb->active_buf].addr;
+		if ((dts->state & DT3155_STATE_MODE) == DT3155_STATE_FLD)
+			writel(buffer_addr, mmio + EVEN_DMA_START);
+		else {
+			writel(buffer_addr, mmio + EVEN_DMA_START);
 
-	  writel(buffer_addr + dts->config.cols, mmio + ODD_DMA_START);
-	}
+			writel(buffer_addr + dts->config.cols, mmio + ODD_DMA_START);
+		}
 
-      /* Do error checking */
-      i2c_odd_csr.fld.DONE_ODD = 1;
-      if (i2c_odd_csr.fld.ERROR_ODD)
-	dt3155_errno = DT_ERR_OVERRUN;
+		/* Do error checking */
+		i2c_odd_csr.fld.DONE_ODD = 1;
+		if (i2c_odd_csr.fld.ERROR_ODD)
+			dt3155_errno = DT_ERR_OVERRUN;
 
-      WriteI2C(mmio, ODD_CSR, i2c_odd_csr.reg);
+		WriteI2C(mmio, ODD_CSR, i2c_odd_csr.reg);
 
-      return;
-    }
-  /* If we get here, the Odd Field wasn't it either... */
-  printk("neither even nor odd.  shared perhaps?\n");
+		return;
+	}
+	/* If we get here, the Odd Field wasn't it either... */
+	printk(KERN_DEBUG "neither even nor odd.  shared perhaps?\n");
 }
 
 /*****************************************************
@@ -409,87 +382,82 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
  *****************************************************/
 static void dt3155_init_isr(int minor)
 {
-  struct dt3155_status *dts = &dt3155_status[minor];
-  struct dt3155_fbuffer *fb = &dts->fbuffer;
-  const u32 stride = dts->config.cols;
-  void __iomem *mmio = dt3155_lbase[minor];
-
-  switch (dts->state & DT3155_STATE_MODE)
-    {
-    case DT3155_STATE_FLD:
-      {
-	even_dma_start_r  = fb->frame_info[fb->active_buf].addr;
-	even_dma_stride_r = 0;
-	odd_dma_stride_r  = 0;
-
-	writel(even_dma_start_r, mmio + EVEN_DMA_START);
-	writel(even_dma_stride_r, mmio + EVEN_DMA_STRIDE);
-	writel(odd_dma_stride_r, mmio + ODD_DMA_STRIDE);
-	break;
-      }
-
-    case DT3155_STATE_FRAME:
-    default:
-      {
-	even_dma_start_r  = fb->frame_info[fb->active_buf].addr;
-	odd_dma_start_r   =  even_dma_start_r + stride;
-	even_dma_stride_r =  stride;
-	odd_dma_stride_r  =  stride;
-
-	writel(even_dma_start_r, mmio + EVEN_DMA_START);
-	writel(odd_dma_start_r, mmio + ODD_DMA_START);
-	writel(even_dma_stride_r, mmio + EVEN_DMA_STRIDE);
-	writel(odd_dma_stride_r, mmio + ODD_DMA_STRIDE);
-	break;
-      }
-    }
-
-  /* 50/60 Hz should be set before this point but let's make sure it is */
-  /* right anyway */
-
-  ReadI2C(mmio, CSR2, &i2c_csr2.reg);
-  i2c_csr2.fld.HZ50 = FORMAT50HZ;
-  WriteI2C(mmio, CSR2, i2c_csr2.reg);
-
-  /* enable busmaster chip, clear flags */
-
-  /*
-   * TODO:
-   * shouldn't we be concered with continuous values of
-   * DT3155_SNAP & DT3155_ACQ here? (SS)
-   */
-
-  csr1_r.reg                = 0;
-  csr1_r.fld.CAP_CONT_EVE   = 1; /* use continuous capture bits to */
-  csr1_r.fld.CAP_CONT_ODD   = 1; /* enable */
-  csr1_r.fld.FLD_DN_EVE     = 1; /* writing a 1 clears flags */
-  csr1_r.fld.FLD_DN_ODD     = 1;
-  csr1_r.fld.SRST           = 1; /* reset        - must be 1 */
-  csr1_r.fld.FIFO_EN        = 1; /* fifo control - must be 1 */
-  csr1_r.fld.FLD_CRPT_EVE   = 1; /* writing a 1 clears flags */
-  csr1_r.fld.FLD_CRPT_ODD   = 1;
-
-  writel(csr1_r.reg, mmio + CSR1);
-
-  /* Enable interrupts at the end of each field */
-
-  int_csr_r.reg = 0;
-  int_csr_r.fld.FLD_END_EVE_EN = 1;
-  int_csr_r.fld.FLD_END_ODD_EN = 1;
-  int_csr_r.fld.FLD_START_EN = 0;
-
-  writel(int_csr_r.reg, mmio + INT_CSR);
-
-  /* start internal BUSY bits */
-
-  ReadI2C(mmio, CSR2, &i2c_csr2.reg);
-  i2c_csr2.fld.BUSY_ODD  = 1;
-  i2c_csr2.fld.BUSY_EVE  = 1;
-  WriteI2C(mmio, CSR2, i2c_csr2.reg);
-
-  /* Now its up to the interrupt routine!! */
-
-  return;
+	struct dt3155_status *dts = &dt3155_status[minor];
+	struct dt3155_fbuffer *fb = &dts->fbuffer;
+	const u32 stride = dts->config.cols;
+	void __iomem *mmio = dt3155_lbase[minor];
+
+	switch (dts->state & DT3155_STATE_MODE) {
+	case DT3155_STATE_FLD:
+		even_dma_start_r  = fb->frame_info[fb->active_buf].addr;
+		even_dma_stride_r = 0;
+		odd_dma_stride_r  = 0;
+
+		writel(even_dma_start_r, mmio + EVEN_DMA_START);
+		writel(even_dma_stride_r, mmio + EVEN_DMA_STRIDE);
+		writel(odd_dma_stride_r, mmio + ODD_DMA_STRIDE);
+		break;
+
+	case DT3155_STATE_FRAME:
+	default:
+		even_dma_start_r  = fb->frame_info[fb->active_buf].addr;
+		odd_dma_start_r   =  even_dma_start_r + stride;
+		even_dma_stride_r =  stride;
+		odd_dma_stride_r  =  stride;
+
+		writel(even_dma_start_r, mmio + EVEN_DMA_START);
+		writel(odd_dma_start_r, mmio + ODD_DMA_START);
+		writel(even_dma_stride_r, mmio + EVEN_DMA_STRIDE);
+		writel(odd_dma_stride_r, mmio + ODD_DMA_STRIDE);
+		break;
+	}
+
+	/* 50/60 Hz should be set before this point
+	but let's make sure it is right anyway */
+
+	ReadI2C(mmio, CSR2, &i2c_csr2.reg);
+	i2c_csr2.fld.HZ50 = FORMAT50HZ;
+	WriteI2C(mmio, CSR2, i2c_csr2.reg);
+
+	/* enable busmaster chip, clear flags */
+
+	/*
+	* TODO:
+	* shouldn't we be concered with continuous values of
+	* DT3155_SNAP & DT3155_ACQ here? (SS)
+	*/
+
+	csr1_r.reg                = 0;
+	csr1_r.fld.CAP_CONT_EVE   = 1; /* use continuous capture bits to */
+	csr1_r.fld.CAP_CONT_ODD   = 1; /* enable */
+	csr1_r.fld.FLD_DN_EVE     = 1; /* writing a 1 clears flags */
+	csr1_r.fld.FLD_DN_ODD     = 1;
+	csr1_r.fld.SRST           = 1; /* reset        - must be 1 */
+	csr1_r.fld.FIFO_EN        = 1; /* fifo control - must be 1 */
+	csr1_r.fld.FLD_CRPT_EVE   = 1; /* writing a 1 clears flags */
+	csr1_r.fld.FLD_CRPT_ODD   = 1;
+
+	writel(csr1_r.reg, mmio + CSR1);
+
+	/* Enable interrupts at the end of each field */
+
+	int_csr_r.reg = 0;
+	int_csr_r.fld.FLD_END_EVE_EN = 1;
+	int_csr_r.fld.FLD_END_ODD_EN = 1;
+	int_csr_r.fld.FLD_START_EN = 0;
+
+	writel(int_csr_r.reg, mmio + INT_CSR);
+
+	/* start internal BUSY bits */
+
+	ReadI2C(mmio, CSR2, &i2c_csr2.reg);
+	i2c_csr2.fld.BUSY_ODD  = 1;
+	i2c_csr2.fld.BUSY_EVE  = 1;
+	WriteI2C(mmio, CSR2, i2c_csr2.reg);
+
+	/* Now its up to the interrupt routine!! */
+
+	return;
 }
 
 
@@ -502,111 +470,110 @@ static int dt3155_ioctl(struct inode *inode,
 			unsigned int cmd,
 			unsigned long arg)
 {
-  int minor = MINOR(inode->i_rdev); /* What device are we ioctl()'ing? */
-  void __user *up = (void __user *)arg;
-  struct dt3155_status *dts = &dt3155_status[minor];
-  struct dt3155_fbuffer *fb = &dts->fbuffer;
-
-  if (minor >= MAXBOARDS || minor < 0)
-    return -ENODEV;
-
-  /* make sure it is valid command */
-  if (_IOC_NR(cmd) > DT3155_IOC_MAXNR)
-    {
-      printk("DT3155: invalid IOCTL(0x%x)\n",cmd);
-      printk("DT3155: Valid commands (0x%x), (0x%x), (0x%x), (0x%x), (0x%x)\n",
-	     (unsigned int)DT3155_GET_CONFIG,
-	     (unsigned int)DT3155_SET_CONFIG,
-	     (unsigned int)DT3155_START,
-	     (unsigned int)DT3155_STOP,
-	     (unsigned int)DT3155_FLUSH);
-      return -EINVAL;
-    }
-
-  switch (cmd)
-    {
-    case DT3155_SET_CONFIG:
-      {
-	if (dts->state != DT3155_STATE_IDLE)
-	  return -EBUSY;
+	/* What device are we ioctl()'ing? */
+	int minor = MINOR(inode->i_rdev);
+	void __user *up = (void __user *)arg;
+	struct dt3155_status *dts = &dt3155_status[minor];
+	struct dt3155_fbuffer *fb = &dts->fbuffer;
+
+	/* Temp struct to use when setting config */
+	struct dt3155_config tmp;
+
+	if (minor >= MAXBOARDS || minor < 0)
+		return -ENODEV;
+
+	/* make sure it is valid command */
+	if (_IOC_NR(cmd) > DT3155_IOC_MAXNR) {
+		printk(KERN_INFO "DT3155: invalid IOCTL(0x%x)\n", cmd);
+		printk(KERN_INFO "DT3155: Valid commands (0x%x), (0x%x), \
+				   (0x%x), (0x%x), (0x%x)\n",
+			(unsigned int)DT3155_GET_CONFIG,
+			(unsigned int)DT3155_SET_CONFIG,
+			(unsigned int)DT3155_START,
+			(unsigned int)DT3155_STOP,
+			(unsigned int)DT3155_FLUSH);
+		return -EINVAL;
+	}
 
+	switch (cmd) {
+	case DT3155_SET_CONFIG:
 	{
-	  struct dt3155_config tmp;
-	  if (copy_from_user(&tmp, up, sizeof(tmp)))
-	      return -EFAULT;
-	  /* check for valid settings */
-	  if (tmp.rows > DT3155_MAX_ROWS ||
-	      tmp.cols > DT3155_MAX_COLS ||
-	      (tmp.acq_mode != DT3155_MODE_FRAME &&
-	       tmp.acq_mode != DT3155_MODE_FIELD) ||
-	      (tmp.continuous != DT3155_SNAP &&
-	       tmp.continuous != DT3155_ACQ))
-	    {
-	      return -EINVAL;
-	    }
-	  dts->config = tmp;
+		if (dts->state != DT3155_STATE_IDLE)
+			return -EBUSY;
+
+		if (copy_from_user(&tmp, up, sizeof(tmp)))
+			return -EFAULT;
+		/* check for valid settings */
+		if (tmp.rows > DT3155_MAX_ROWS ||
+		    tmp.cols > DT3155_MAX_COLS ||
+		   (tmp.acq_mode != DT3155_MODE_FRAME &&
+		    tmp.acq_mode != DT3155_MODE_FIELD) ||
+		   (tmp.continuous != DT3155_SNAP &&
+		    tmp.continuous != DT3155_ACQ))
+			return -EINVAL;
+
+		/* set the current config to tmp */
+		dts->config = tmp;
+		/* return success */
+		return 0;
 	}
-	return 0;
-      }
-    case DT3155_GET_CONFIG:
-      {
-	if (copy_to_user(up, dts, sizeof(*dts)))
-	    return -EFAULT;
-	return 0;
-      }
-    case DT3155_FLUSH: /* Flushes the buffers -- ensures fresh data */
-      {
-	if (dts->state != DT3155_STATE_IDLE)
-	  return -EBUSY;
-	return dt3155_flush(minor);
-      }
-    case DT3155_STOP:
-      {
-	if (dts->state & DT3155_STATE_STOP || fb->stop_acquire)
-	  return -EBUSY;
-
-	if (dts->state == DT3155_STATE_IDLE)
-	  return 0;
-
-	quick_stop(minor);
-	if (copy_to_user(up, dts, sizeof(*dts)))
-	    return -EFAULT;
-	return 0;
-      }
-    case DT3155_START:
-      {
-	if (dts->state != DT3155_STATE_IDLE)
-	  return -EBUSY;
+	case DT3155_GET_CONFIG:
+	{
+		if (copy_to_user(up, dts, sizeof(*dts)))
+			return -EFAULT;
+		return 0;
+	}
+	/* Flushes the buffers -- ensures fresh data */
+	case DT3155_FLUSH:
+	{
+		if (dts->state != DT3155_STATE_IDLE)
+			return -EBUSY;
+		return dt3155_flush(minor);
+	}
+	case DT3155_STOP:
+	{
+		if (dts->state & DT3155_STATE_STOP || fb->stop_acquire)
+			return -EBUSY;
 
-	fb->stop_acquire = 0;
-	fb->frame_count = 0;
-
-	/* Set the MODE in the status -- we default to FRAME */
-	if (dts->config.acq_mode == DT3155_MODE_FIELD)
-	  {
-	    dts->state = DT3155_STATE_FLD;
-	  }
-	else
-	  {
-	    dts->state = DT3155_STATE_FRAME;
-	  }
-
-	dt3155_init_isr(minor);
-	if (copy_to_user(up, dts, sizeof(*dts)))
-	    return -EFAULT;
-	return 0;
-      }
-    default:
-      {
-	printk("DT3155: invalid IOCTL(0x%x)\n",cmd);
-      printk("DT3155: Valid commands (0x%x), (0x%x), (0x%x), (0x%x), (0x%x)\n",
-	     (unsigned int)DT3155_GET_CONFIG,
-	     (unsigned int)DT3155_SET_CONFIG,
-	     DT3155_START, DT3155_STOP, DT3155_FLUSH);
+		if (dts->state == DT3155_STATE_IDLE)
+			return 0;
+
+		quick_stop(minor);
+
+		if (copy_to_user(up, dts, sizeof(*dts)))
+			return -EFAULT;
+		return 0;
+	}
+	case DT3155_START:
+	{
+		if (dts->state != DT3155_STATE_IDLE)
+			return -EBUSY;
+
+		fb->stop_acquire = 0;
+		fb->frame_count = 0;
+
+		/* Set the MODE in the status -- we default to FRAME */
+		if (dts->config.acq_mode == DT3155_MODE_FIELD)
+			dts->state = DT3155_STATE_FLD;
+		else
+			dts->state = DT3155_STATE_FRAME;
+
+		dt3155_init_isr(minor);
+		if (copy_to_user(up, dts, sizeof(*dts)))
+			return -EFAULT;
+
+		return 0;
+	}
+	default:
+		printk(KERN_INFO "DT3155: invalid IOCTL(0x%x)\n", cmd);
+		printk(KERN_INFO "DT3155: Valid commands (0x%x), (0x%x), \
+				   (0x%x), (0x%x), (0x%x)\n",
+		(unsigned int)DT3155_GET_CONFIG,
+		(unsigned int)DT3155_SET_CONFIG,
+		DT3155_START, DT3155_STOP, DT3155_FLUSH);
+		return -ENOSYS;
+	}
 	return -ENOSYS;
-      }
-    }
-  return -ENOSYS;
 }
 
 /*****************************************************
@@ -618,42 +585,38 @@ static int dt3155_ioctl(struct inode *inode,
  * It *looks* like it should work but since I'm not
  * sure how to use it, I'm not actually sure. (NJC? ditto by SS)
  *****************************************************/
-static int dt3155_mmap (struct file * file, struct vm_area_struct * vma)
+static int dt3155_mmap(struct file *file, struct vm_area_struct *vma)
 {
-  /* which device are we mmapping? */
-  int minor = MINOR(file->f_dentry->d_inode->i_rdev);
-  struct dt3155_status *dts = &dt3155_status[minor];
-  unsigned long	offset;
-  offset = vma->vm_pgoff << PAGE_SHIFT;
-
-  if (offset >= __pa(high_memory) || (file->f_flags & O_SYNC))
-    vma->vm_flags |= VM_IO;
-
-  /* Don't try to swap out physical pages.. */
-  vma->vm_flags |= VM_RESERVED;
-
-  /* they are mapping the registers or the buffer */
-  if ((offset == dts->reg_addr &&
-       vma->vm_end - vma->vm_start == PCI_PAGE_SIZE) ||
-      (offset == dts->mem_addr &&
-       vma->vm_end - vma->vm_start == dts->mem_size))
-    {
-      if (remap_pfn_range(vma,
-			vma->vm_start,
-			offset >> PAGE_SHIFT,
-			vma->vm_end - vma->vm_start,
-			vma->vm_page_prot)) {
-	  printk("DT3155: remap_page_range() failed.\n");
-	  return -EAGAIN;
+	/* which device are we mmapping? */
+	int minor = MINOR(file->f_dentry->d_inode->i_rdev);
+	struct dt3155_status *dts = &dt3155_status[minor];
+	unsigned long	offset;
+	offset = vma->vm_pgoff << PAGE_SHIFT;
+
+	if (offset >= __pa(high_memory) || (file->f_flags & O_SYNC))
+		vma->vm_flags |= VM_IO;
+
+	/* Don't try to swap out physical pages.. */
+	vma->vm_flags |= VM_RESERVED;
+
+	/* they are mapping the registers or the buffer */
+	if ((offset == dts->reg_addr &&
+	    vma->vm_end - vma->vm_start == PCI_PAGE_SIZE) ||
+	    (offset == dts->mem_addr &&
+	    vma->vm_end - vma->vm_start == dts->mem_size)) {
+		if (remap_pfn_range(vma, vma->vm_start,
+		    offset >> PAGE_SHIFT,
+		    vma->vm_end - vma->vm_start,
+		    vma->vm_page_prot)) {
+			printk(KERN_INFO "DT3155: remap_page_range() failed.\n");
+			return -EAGAIN;
+		}
+	} else {
+		printk(KERN_INFO "DT3155: dt3155_mmap() bad call.\n");
+		return -ENXIO;
 	}
-    }
-  else
-    {
-      printk("DT3155: dt3155_mmap() bad call.\n");
-      return -ENXIO;
-    }
-
-  return 0;
+
+	return 0;
 }
 
 
@@ -664,42 +627,41 @@ static int dt3155_mmap (struct file * file, struct vm_area_struct * vma)
  * MOD_INC_USE_COUNT make sure that the driver memory is not freed
  * while the device is in use.
  *****************************************************/
-static int dt3155_open(struct inode* inode, struct file* filep)
+static int dt3155_open(struct inode *inode, struct file *filep)
 {
-  int minor = MINOR(inode->i_rdev); /* what device are we opening? */
-  struct dt3155_status *dts = &dt3155_status[minor];
+	int minor = MINOR(inode->i_rdev); /* what device are we opening? */
+	struct dt3155_status *dts = &dt3155_status[minor];
 
-  if (dt3155_dev_open[minor]) {
-    printk ("DT3155:  Already opened by another process.\n");
-    return -EBUSY;
-  }
+	if (dt3155_dev_open[minor]) {
+		printk(KERN_INFO "DT3155: Already opened by another process.\n");
+		return -EBUSY;
+	}
 
-  if (dts->device_installed==0)
-    {
-      printk("DT3155 Open Error: No such device dt3155 minor number %d\n",
-	     minor);
-      return -EIO;
-    }
+	if (dts->device_installed == 0) {
+		printk(KERN_INFO "DT3155 Open Error: No such device dt3155 minor number %d\n",
+			minor);
+		return -EIO;
+	}
 
-  if (dts->state != DT3155_STATE_IDLE) {
-    printk ("DT3155:  Not in idle state (state = %x)\n",
-	    dts->state);
-    return -EBUSY;
-  }
+	if (dts->state != DT3155_STATE_IDLE) {
+		printk(KERN_INFO "DT3155:  Not in idle state (state = %x)\n",
+			dts->state);
+		return -EBUSY;
+	}
 
-  printk("DT3155: Device opened.\n");
+	printk(KERN_INFO "DT3155: Device opened.\n");
 
-  dt3155_dev_open[minor] = 1 ;
+	dt3155_dev_open[minor] = 1 ;
 
-  dt3155_flush(minor);
+	dt3155_flush(minor);
 
-  /* Disable ALL interrupts */
-  int_csr_r.reg = 0;
-  writel(int_csr_r.reg, dt3155_lbase[minor] + INT_CSR);
+	/* Disable ALL interrupts */
+	int_csr_r.reg = 0;
+	writel(int_csr_r.reg, dt3155_lbase[minor] + INT_CSR);
 
-  init_waitqueue_head(&(dt3155_read_wait_queue[minor]));
+	init_waitqueue_head(&(dt3155_read_wait_queue[minor]));
 
-  return 0;
+	return 0;
 }
 
 
@@ -711,23 +673,19 @@ static int dt3155_open(struct inode* inode, struct file* filep)
  *****************************************************/
 static int dt3155_close(struct inode *inode, struct file *filep)
 {
-  int minor = MINOR(inode->i_rdev); /* which device are we closing */
-  struct dt3155_status *dts = &dt3155_status[minor];
-
-  if (!dt3155_dev_open[minor])
-    {
-      printk("DT3155: attempt to CLOSE a not OPEN device\n");
-    }
-  else
-    {
-      dt3155_dev_open[minor] = 0;
-
-      if (dts->state != DT3155_STATE_IDLE)
-	{
-	  quick_stop(minor);
+	/* which device are we closing */
+	int minor = MINOR(inode->i_rdev);
+	struct dt3155_status *dts = &dt3155_status[minor];
+
+	if (!dt3155_dev_open[minor])
+		printk(KERN_INFO "DT3155: attempt to CLOSE a not OPEN device\n");
+	else {
+		dt3155_dev_open[minor] = 0;
+
+		if (dts->state != DT3155_STATE_IDLE)
+			quick_stop(minor);
 	}
-    }
-  return 0;
+	return 0;
 }
 
 /*****************************************************
@@ -737,89 +695,89 @@ static int dt3155_close(struct inode *inode, struct file *filep)
 static ssize_t dt3155_read(struct file *filep, char __user *buf,
 			   size_t count, loff_t *ppos)
 {
-  /* which device are we reading from? */
-  int		minor = MINOR(filep->f_dentry->d_inode->i_rdev);
-  u32		offset;
-  int		frame_index;
-  struct dt3155_status *dts = &dt3155_status[minor];
-  struct dt3155_fbuffer *fb = &dts->fbuffer;
-  struct frame_info	*frame_info;
-
-  /* TODO: this should check the error flag and */
-  /*   return an error on hardware failures */
-  if (count != sizeof(struct dt3155_read))
-    {
-      printk("DT3155 ERROR (NJC): count is not right\n");
-      return -EINVAL;
-    }
-
-
-  /* Hack here -- I'm going to allow reading even when idle.
-   * this is so that the frames can be read after STOP has
-   * been called.  Leaving it here, commented out, as a reminder
-   * for a short while to make sure there are no problems.
-   * Note that if the driver is not opened in non_blocking mode,
-   * and the device is idle, then it could sit here forever! */
-
-  /*  if (dts->state == DT3155_STATE_IDLE)*/
-  /*    return -EBUSY;*/
-
-  /* non-blocking reads should return if no data */
-  if (filep->f_flags & O_NDELAY)
-    {
-      if ((frame_index = dt3155_get_ready_buffer(minor)) < 0) {
-	/*printk("dt3155:  no buffers available (?)\n");*/
-	/* 		printques(minor); */
-	return -EAGAIN;
-      }
-    }
-  else
-    {
-      /*
-       * sleep till data arrives , or we get interrupted.
-       * Note that wait_event_interruptible() does not actually
-       * sleep/wait if it's condition evaluates to true upon entry.
-       */
-      wait_event_interruptible(dt3155_read_wait_queue[minor],
-			       (frame_index = dt3155_get_ready_buffer(minor))
-			       >= 0);
-
-      if (frame_index < 0)
-	{
-	  printk ("DT3155: read: interrupted\n");
-	  quick_stop (minor);
-	  printques(minor);
-	  return -EINTR;
+	/* which device are we reading from? */
+	int minor = MINOR(filep->f_dentry->d_inode->i_rdev);
+	u32 offset;
+	int frame_index;
+
+	struct dt3155_status *dts = &dt3155_status[minor];
+	struct dt3155_fbuffer *fb = &dts->fbuffer;
+	struct frame_info	*frame_info;
+
+	/* TODO: this should check the error flag and */
+	/*   return an error on hardware failures */
+	if (count != sizeof(struct dt3155_read)) {
+		printk(KERN_ERR "DT3155 ERROR (NJC): count is not right\n");
+		return -EINVAL;
 	}
-    }
 
-  frame_info = &fb->frame_info[frame_index];
+	/* Hack here -- I'm going to allow reading even when idle.
+	 * this is so that the frames can be read after STOP has
+	 * been called.  Leaving it here, commented out, as a reminder
+	 * for a short while to make sure there are no problems.
+	 * Note that if the driver is not opened in non_blocking mode,
+	 * and the device is idle, then it could sit here forever! */
+
+	/*  if (dts->state == DT3155_STATE_IDLE)*/
+	/*    return -EBUSY;*/
+
+	/* non-blocking reads should return if no data */
+	if (filep->f_flags & O_NDELAY) {
+		frame_index = dt3155_get_ready_buffer(minor);
+		if (frame_index < 0) {
+			/* printk("dt3155:  no buffers available (?)\n");*/
+			/* printques(minor); */
+			return -EAGAIN;
+		}
+	} else {
+		/*
+		 * sleep till data arrives , or we get interrupted.
+		 * Note that wait_event_interruptible() does not actually
+		 * sleep/wait if it's condition evaluates to true upon entry.
+		 */
+		wait_event_interruptible(dt3155_read_wait_queue[minor],
+			(frame_index = dt3155_get_ready_buffer(minor))
+				>= 0);
+
+		if (frame_index < 0) {
+			printk(KERN_INFO "DT3155: read: interrupted\n");
+			quick_stop(minor);
+			printques(minor);
+			return -EINTR;
+		}
+	}
 
-  /* make this an offset */
-  offset = frame_info->addr - dts->mem_addr;
+	frame_info = &fb->frame_info[frame_index];
 
-  put_user(offset, (unsigned int __user *)buf);
-  buf += sizeof(u32);
-  put_user(fb->frame_count, (unsigned int __user *)buf);
-  buf += sizeof(u32);
-  put_user(dts->state, (unsigned int __user *)buf);
-  buf += sizeof(u32);
-  if (copy_to_user(buf, frame_info, sizeof(*frame_info)))
-      return -EFAULT;
+	/* make this an offset */
+	offset = frame_info->addr - dts->mem_addr;
 
-  return sizeof(struct dt3155_read);
+	put_user(offset, (unsigned int __user *)buf);
+	buf += sizeof(u32);
+	put_user(fb->frame_count, (unsigned int __user *)buf);
+	buf += sizeof(u32);
+	put_user(dts->state, (unsigned int __user *)buf);
+	buf += sizeof(u32);
+	if (copy_to_user(buf, frame_info, sizeof(*frame_info)))
+		return -EFAULT;
+
+	return sizeof(struct dt3155_read);
 }
 
-static unsigned int dt3155_poll (struct file * filp, poll_table *wait)
+/*****************************************************
+ * poll()
+ *
+ *****************************************************/
+static unsigned int dt3155_poll(struct file *filp, poll_table *wait)
 {
-  int minor = MINOR(filp->f_dentry->d_inode->i_rdev);
+	int minor = MINOR(filp->f_dentry->d_inode->i_rdev);
 
-  if (!is_ready_buf_empty(minor))
-    return POLLIN | POLLRDNORM;
+	if (!is_ready_buf_empty(minor))
+		return POLLIN | POLLRDNORM;
 
-  poll_wait (filp, &dt3155_read_wait_queue[minor], wait);
+	poll_wait(filp, &dt3155_read_wait_queue[minor], wait);
 
-  return 0;
+	return 0;
 }
 
 static long
@@ -839,7 +797,7 @@ dt3155_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
  *  needed by init_module
  *  register_chrdev
  *****************************************************/
-static struct file_operations dt3155_fops = {
+static const struct file_operations dt3155_fops = {
 	.read		= dt3155_read,
 	.unlocked_ioctl	= dt3155_unlocked_ioctl,
 	.mmap		= dt3155_mmap,
@@ -854,85 +812,84 @@ static struct file_operations dt3155_fops = {
  *
  * PCI has been totally reworked in 2.1..
  *****************************************************/
-static int find_PCI (void)
+static int find_PCI(void)
 {
-  struct pci_dev *pci_dev = NULL;
-  struct dt3155_status *dts;
-  int error, pci_index = 0;
-  unsigned short rev_device;
-  unsigned long base;
-  unsigned char irq;
-
-  while ((pci_dev = pci_get_device
-	  (DT3155_VENDORID, DT3155_DEVICEID, pci_dev)) != NULL)
-    {
-      dts = &dt3155_status[pci_index++];
-
-      /* Is it really there? */
-      if ((error =
-	   pci_read_config_word(pci_dev, PCI_CLASS_DEVICE, &rev_device)))
-	continue;
-
-      /* Found a board */
-      DT_3155_DEBUG_MSG("DT3155: Device number %d \n", pci_index);
-
-      /* Make sure the driver was compiled with enough buffers to handle
-	 this many boards */
-      if (pci_index > MAXBOARDS) {
-	printk("DT3155: ERROR - found %d devices, but driver only configured "
-	       "for %d devices\n"
-	       "DT3155: Please change MAXBOARDS in dt3155.h\n",
-	       pci_index, MAXBOARDS);
-	goto err;
-      }
-
-      /* Now, just go out and make sure that this/these device(s) is/are
-	 actually mapped into the kernel address space */
-      if ((error = pci_read_config_dword(pci_dev, PCI_BASE_ADDRESS_0,
-					  (u32 *) &base)))
-	{
-	  printk("DT3155: Was not able to find device \n");
-	  goto err;
-	}
+	struct pci_dev *pci_dev = NULL;
+	struct dt3155_status *dts;
+	int error, pci_index = 0;
+	unsigned short rev_device;
+	unsigned long base;
+	unsigned char irq;
+
+	while ((pci_dev = pci_get_device
+	       (DT3155_VENDORID, DT3155_DEVICEID, pci_dev)) != NULL) {
+
+		dts = &dt3155_status[pci_index++];
+
+		/* Is it really there? */
+		if ((error = pci_read_config_word(pci_dev,
+		    PCI_CLASS_DEVICE, &rev_device)))
+			continue;
+
+		/* Found a board */
+		DT_3155_DEBUG_MSG("DT3155: Device number %d\n", pci_index);
+
+		/* Make sure the driver was compiled with enough
+		 * buffers to handle this many boards
+		 */
+		if (pci_index > MAXBOARDS) {
+			printk(KERN_ERR "DT3155: ERROR - found %d devices, "
+				"but driver only configured for %d devices\n"
+				"DT3155: Please change MAXBOARDS in dt3155.h\n",
+				pci_index, MAXBOARDS);
+			goto err;
+		}
+
+		/* Now, just go out and make sure that this/these device(s)
+		   is/are actually mapped into the kernel address space */
+		if ((error = pci_read_config_dword(pci_dev, PCI_BASE_ADDRESS_0,
+		    (u32 *) &base))) {
+			printk(KERN_INFO "DT3155: Was not able to find device\n");
+			goto err;
+		}
 
-      DT_3155_DEBUG_MSG("DT3155: Base address 0 for device is %lx \n", base);
-      dts->reg_addr = base;
+		DT_3155_DEBUG_MSG(KERN_INFO "DT3155: Base address 0 for device is %lx\n",
+			base);
+		dts->reg_addr = base;
 
-      /* Remap the base address to a logical address through which we
-       * can access it. */
-      dt3155_lbase[pci_index - 1] = ioremap(base, PCI_PAGE_SIZE);
-      dts->reg_addr = base;
-      DT_3155_DEBUG_MSG("DT3155: New logical address is %p \n",
+		/* Remap the base address to a logical address through which we
+		 * can access it. */
+		dt3155_lbase[pci_index - 1] = ioremap(base, PCI_PAGE_SIZE);
+		dts->reg_addr = base;
+		DT_3155_DEBUG_MSG(KERN_INFO "DT3155: New logical address is %p\n",
 			dt3155_lbase[pci_index-1]);
-      if (!dt3155_lbase[pci_index-1])
-	{
-	  printk("DT3155: Unable to remap control registers\n");
-	  goto err;
-	}
 
-      if ((error = pci_read_config_byte(pci_dev, PCI_INTERRUPT_LINE, &irq)))
-	{
-	  printk("DT3155: Was not able to find device \n");
-	  goto err;
-	}
+		if (!dt3155_lbase[pci_index-1]) {
+			printk(KERN_INFO "DT3155: Unable to remap control registers\n");
+			goto err;
+		}
 
-      DT_3155_DEBUG_MSG("DT3155: IRQ is %d \n",irq);
-      dts->irq = irq;
-      /* Set flag: kth device found! */
-      dts->device_installed = 1;
-      printk("DT3155: Installing device %d w/irq %d and address %p\n",
-	     pci_index,
-	     dts->irq,
-	     dt3155_lbase[pci_index-1]);
+		if ((error = pci_read_config_byte(pci_dev,
+		    PCI_INTERRUPT_LINE, &irq))) {
+			printk(KERN_INFO "DT3155: Was not able to find device\n");
+			goto err;
+		}
 
-    }
-  ndevices = pci_index;
+		DT_3155_DEBUG_MSG("DT3155: IRQ is %d\n", irq);
+		dts->irq = irq;
+		/* Set flag: kth device found! */
+		dts->device_installed = 1;
+		printk(KERN_INFO "DT3155: Installing device %d w/irq %d \
+			and address %p\n",
+			pci_index, dts->irq, dt3155_lbase[pci_index-1]);
+	}
+	ndevices = pci_index;
 
-  return 0;
+	return 0;
 
 err:
-  pci_dev_put(pci_dev);
-  return -EIO;
+ pci_dev_put(pci_dev);
+ return -EIO;
 }
 
 u32 allocatorAddr = 0;
@@ -942,122 +899,114 @@ u32 allocatorAddr = 0;
  *****************************************************/
 int init_module(void)
 {
-  struct dt3155_status *dts;
-  int index;
-  int rcode = 0;
-  char *devname[MAXBOARDS];
+	struct dt3155_status *dts;
+	int index;
+	int rcode = 0;
+	char *devname[MAXBOARDS];
 
-  devname[0] = "dt3155a";
+	devname[0] = "dt3155a";
 #if MAXBOARDS == 2
-  devname[1] = "dt3155b";
+	devname[1] = "dt3155b";
 #endif
 
-  printk("DT3155: Loading module...\n");
-
-  /* Register the device driver */
-  rcode = register_chrdev(dt3155_major, "dt3155", &dt3155_fops);
-  if(rcode < 0)
-    {
-      printk(KERN_INFO "DT3155: register_chrdev failed \n");
-      return rcode;
-    }
-
-  if(dt3155_major == 0)
-    dt3155_major = rcode; /* dynamic */
-
-
-  /* init the status variables.                     */
-  /* DMA memory is taken care of in setup_buffers() */
-  for (index = 0; index < MAXBOARDS; index++)
-    {
-      dts = &dt3155_status[index];
-
-      dts->config.acq_mode   = DT3155_MODE_FRAME;
-      dts->config.continuous = DT3155_ACQ;
-      dts->config.cols       = DT3155_MAX_COLS;
-      dts->config.rows       = DT3155_MAX_ROWS;
-      dts->state = DT3155_STATE_IDLE;
-
-      /* find_PCI() will check if devices are installed; */
-      /* first assume they're not:                       */
-      dts->mem_addr          = 0;
-      dts->mem_size          = 0;
-      dts->state             = DT3155_STATE_IDLE;
-      dts->device_installed  = 0;
-    }
-
-  /* Now let's find the hardware.  find_PCI() will set ndevices to the
-   * number of cards found in this machine. */
-    {
-      if ((rcode = find_PCI()) != 0)
-	{
-	  printk("DT3155 error: find_PCI() failed to find dt3155 board(s)\n");
-	  unregister_chrdev(dt3155_major, "dt3155");
-	  return rcode;
+	printk(KERN_INFO "DT3155: Loading module...\n");
+
+	/* Register the device driver */
+	rcode = register_chrdev(dt3155_major, "dt3155", &dt3155_fops);
+	if (rcode < 0) {
+		printk(KERN_INFO "DT3155: register_chrdev failed\n");
+		return rcode;
 	}
-    }
-
-  /* Ok, time to setup the frame buffers */
-  if((rcode = dt3155_setup_buffers(&allocatorAddr)) < 0)
-    {
-      printk("DT3155: Error: setting up buffer not large enough.");
-      unregister_chrdev(dt3155_major, "dt3155");
-      return rcode;
-    }
-
-  /* If we are this far, then there is enough RAM */
-  /* for the buffers: Print the configuration.    */
-  for( index = 0;  index < ndevices;  index++)
-    {
-      dts = &dt3155_status[index];
-
-      printk("DT3155: Device = %d; acq_mode = %d; "
-	     "continuous = %d; cols = %d; rows = %d;\n",
-	     index ,
-	     dts->config.acq_mode,
-	     dts->config.continuous,
-	     dts->config.cols,
-	     dts->config.rows);
-      printk("DT3155: m_addr = 0x%x; m_size = %ld; "
-	     "state = %d; device_installed = %d\n",
-	     dts->mem_addr,
-	     (long int)dts->mem_size,
-	     dts->state,
-	     dts->device_installed);
-    }
-
-  /* Disable ALL interrupts */
-  int_csr_r.reg = 0;
-  for( index = 0;  index < ndevices;  index++)
-    {
-      dts = &dt3155_status[index];
-
-      writel(int_csr_r.reg, dt3155_lbase[index] + INT_CSR);
-      if(dts->device_installed)
-	{
-	  /*
-	   * This driver *looks* like it can handle sharing interrupts,
-	   * but I can't actually test myself. I've had reports that it
-	   * DOES work so I'll enable it for now. This comment will remain
-	   * as a reminder in case any problems arise. (SS)
-	   */
-	  /* in older kernels flags are: SA_SHIRQ | SA_INTERRUPT */
-	  rcode = request_irq(dts->irq, (void *)dt3155_isr,
-			       IRQF_SHARED | IRQF_DISABLED, devname[index],
-			       (void *)dts);
-	  if(rcode < 0)
-	    {
-	      printk("DT3155: minor %d request_irq failed for IRQ %d\n",
-		     index, dts->irq);
-	      unregister_chrdev(dt3155_major, "dt3155");
-	      return rcode;
-	    }
+
+	if (dt3155_major == 0)
+		dt3155_major = rcode; /* dynamic */
+
+
+	/* init the status variables.                     */
+	/* DMA memory is taken care of in setup_buffers() */
+	for (index = 0; index < MAXBOARDS; index++) {
+		dts = &dt3155_status[index];
+
+		dts->config.acq_mode   = DT3155_MODE_FRAME;
+		dts->config.continuous = DT3155_ACQ;
+		dts->config.cols       = DT3155_MAX_COLS;
+		dts->config.rows       = DT3155_MAX_ROWS;
+		dts->state = DT3155_STATE_IDLE;
+
+		/* find_PCI() will check if devices are installed; */
+		/* first assume they're not:                       */
+		dts->mem_addr          = 0;
+		dts->mem_size          = 0;
+		dts->state             = DT3155_STATE_IDLE;
+		dts->device_installed  = 0;
+	}
+	/* Now let's find the hardware.  find_PCI() will set ndevices to the
+	 * number of cards found in this machine. */
+
+	if ((rcode = find_PCI()) != 0) {
+		printk(KERN_ERR "DT3155 error: find_PCI() failed to find dt3155 board(s)\n");
+		unregister_chrdev(dt3155_major, "dt3155");
+		return rcode;
+	}
+
+	/* Ok, time to setup the frame buffers */
+	if ((rcode = dt3155_setup_buffers(&allocatorAddr)) < 0) {
+		printk(KERN_ERR "DT3155: Error: setting up buffer not large enough.");
+		unregister_chrdev(dt3155_major, "dt3155");
+		return rcode;
+	}
+
+	/* If we are this far, then there is enough RAM */
+	/* for the buffers: Print the configuration.    */
+	for (index = 0;  index < ndevices;  index++) {
+		dts = &dt3155_status[index];
+
+		printk(KERN_INFO "DT3155: Device = %d; acq_mode = %d; "
+			"continuous = %d; cols = %d; rows = %d;\n",
+			index ,
+			dts->config.acq_mode,
+			dts->config.continuous,
+			dts->config.cols,
+			dts->config.rows);
+		printk(KERN_INFO "DT3155: m_addr = 0x%x; m_size = %ld; "
+			"state = %d; device_installed = %d\n",
+			dts->mem_addr,
+			(long int)dts->mem_size,
+			dts->state,
+			dts->device_installed);
+	}
+
+	/* Disable ALL interrupts */
+	int_csr_r.reg = 0;
+	for (index = 0;  index < ndevices;  index++) {
+		dts = &dt3155_status[index];
+
+		writel(int_csr_r.reg, dt3155_lbase[index] + INT_CSR);
+		if (dts->device_installed) {
+			/*
+			 * This driver *looks* like it can handle sharing
+			 * interrupts, but I can't actually test myself.
+			 * I've had reports that it DOES work so I'll
+			 * enable it for now. This comment will remain
+			 * as a reminder in case any problems arise. (SS)
+			 */
+			/* in older kernels flags are: SA_SHIRQ |
+			   SA_INTERRUPT */
+			rcode = request_irq(dts->irq, (void *)dt3155_isr,
+				IRQF_SHARED | IRQF_DISABLED, devname[index],
+				(void *)dts);
+			if (rcode < 0) {
+				printk(KERN_INFO "DT3155: minor %d request_irq failed for IRQ %d\n",
+					index, dts->irq);
+				unregister_chrdev(dt3155_major, "dt3155");
+				return rcode;
+			}
+		}
 	}
-    }
 
-  printk("DT3155: finished loading\n");
+	printk(KERN_INFO "DT3155: finished loading\n");
 
-  return 0;
+	return 0;
 }
 
 /*****************************************************
@@ -1066,30 +1015,28 @@ int init_module(void)
  *****************************************************/
 void cleanup_module(void)
 {
-  struct dt3155_status *dts;
-  int index;
+	struct dt3155_status *dts;
+	int index;
 
-  printk("DT3155:  cleanup_module called\n");
+	printk(KERN_INFO "DT3155:  cleanup_module called\n");
 
-  /* removed DMA allocated with the allocator */
+	/* removed DMA allocated with the allocator */
 #ifdef STANDALONE_ALLOCATOR
-  if (allocatorAddr != 0)
-    allocator_free_dma(allocatorAddr);
+	if (allocatorAddr != 0)
+		allocator_free_dma(allocatorAddr);
 #else
-  allocator_cleanup();
+	allocator_cleanup();
 #endif
 
-  unregister_chrdev(dt3155_major, "dt3155");
+	unregister_chrdev(dt3155_major, "dt3155");
 
-  for(index = 0; index < ndevices; index++)
-    {
-      dts = &dt3155_status[index];
-      if(dts->device_installed == 1)
-	{
-	  printk("DT3155: Freeing irq %d for device %d\n",
-		  dts->irq, index);
-	  free_irq(dts->irq, (void *)dts);
+	for (index = 0; index < ndevices; index++) {
+		dts = &dt3155_status[index];
+		if (dts->device_installed == 1) {
+			printk(KERN_INFO "DT3155: Freeing irq %d for device %d\n",
+				dts->irq, index);
+			free_irq(dts->irq, (void *)dts);
+		}
 	}
-    }
 }
 
-- 
1.6.3.3



