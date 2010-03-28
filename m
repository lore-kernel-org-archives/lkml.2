Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab0C1N7z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 09:59:55 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33214 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab0C1N7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 09:59:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=XjzRc7JJ8rcQWMxnfuXR1zn4FrlLNj55y1YaCiXpCLUGncpo7v790f3lpO+qXbi7d7
         Z+kuQ1DhXi8dvQMduu6B9H24yUtIMusXgdH6EzSvi6C3hLRwwGMn5lCckQbHtsnXVquu
         rm3rVDnua7Pgb3AWTfczAG8wA9WrME7d2aidA=
From: Jason Baldus <jason.baldus@gmail.com>
To: gregkh@suse.de, horms@verge.net.au, ss@aao.gov.au,
       hsweeten@visionengravers.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Jason Baldus <jason.baldus@gmail.com>
Subject: [PATCH] Staging: dt3155: fix parentheses and bracket spacing style issues
Date: Sun, 28 Mar 2010 09:59:37 -0400
Message-Id: <1269784777-13037-1-git-send-email-jason.baldus@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the dt3155_drv.c file that removes spaces after open
parentheses and brackets and before close parentheses and brackets.

Signed-off-by: Jason Baldus <jason.baldus@gmail.com>
---
 drivers/staging/dt3155/dt3155_drv.c |  338 +++++++++++++++++-----------------
 1 files changed, 169 insertions(+), 169 deletions(-)

diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index a67c622..d629be4 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -102,7 +102,7 @@ int dt3155_errno = 0;
 #endif
 
 /* wait queue for interrupts */
-wait_queue_head_t dt3155_read_wait_queue[ MAXBOARDS ];
+wait_queue_head_t dt3155_read_wait_queue[MAXBOARDS];
 
 #define DT_3155_SUCCESS 0
 #define DT_3155_FAILURE -EIO
@@ -119,10 +119,10 @@ int dt3155_major = 0;
 /* Global structures and variables */
 
 /* Status of each device */
-struct dt3155_status_s dt3155_status[ MAXBOARDS ];
+struct dt3155_status_s dt3155_status[MAXBOARDS];
 
 /* kernel logical address of the board */
-u8 *dt3155_lbase[ MAXBOARDS ] = { NULL
+u8 *dt3155_lbase[MAXBOARDS] = { NULL
 #if MAXBOARDS == 2
 				      , NULL
 #endif
@@ -130,7 +130,7 @@ u8 *dt3155_lbase[ MAXBOARDS ] = { NULL
 /* DT3155 registers              */
 u8 *dt3155_bbase = NULL;		  /* kernel logical address of the *
 					   * buffer region                 */
-u32  dt3155_dev_open[ MAXBOARDS ] = {0
+u32  dt3155_dev_open[MAXBOARDS] = {0
 #if MAXBOARDS == 2
 				       , 0
 #endif
@@ -149,17 +149,17 @@ static void quick_stop (int minor)
 {
   // TODO: scott was here
 #if 1
-  ReadMReg((dt3155_lbase[ minor ] + INT_CSR), int_csr_r.reg);
+  ReadMReg((dt3155_lbase[minor] + INT_CSR), int_csr_r.reg);
   /* disable interrupts */
   int_csr_r.fld.FLD_END_EVE_EN = 0;
   int_csr_r.fld.FLD_END_ODD_EN = 0;
-  WriteMReg((dt3155_lbase[ minor ] + INT_CSR), int_csr_r.reg );
+  WriteMReg((dt3155_lbase[minor] + INT_CSR), int_csr_r.reg);
 
-  dt3155_status[ minor ].state &= ~(DT3155_STATE_STOP|0xff);
+  dt3155_status[minor].state &= ~(DT3155_STATE_STOP|0xff);
   /* mark the system stopped: */
-  dt3155_status[ minor ].state |= DT3155_STATE_IDLE;
-  dt3155_fbuffer[ minor ]->stop_acquire = 0;
-  dt3155_fbuffer[ minor ]->even_stopped = 0;
+  dt3155_status[minor].state |= DT3155_STATE_IDLE;
+  dt3155_fbuffer[minor]->stop_acquire = 0;
+  dt3155_fbuffer[minor]->even_stopped = 0;
 #else
   dt3155_status[minor].state |= DT3155_STATE_STOP;
   dt3155_status[minor].fbuffer.stop_acquire = 1;
@@ -175,7 +175,7 @@ static void quick_stop (int minor)
  * - Assumes irq's are disabled, via SA_INTERRUPT flag
  * being set in request_irq() call from init_module()
  *****************************************************/
-static inline void dt3155_isr( int irq, void *dev_id, struct pt_regs *regs )
+static inline void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
 {
   int    minor = -1;
   int    index;
@@ -183,8 +183,8 @@ static inline void dt3155_isr( int irq, void *dev_id, struct pt_regs *regs )
   u32 buffer_addr;
 
   /* find out who issued the interrupt */
-  for ( index = 0; index < ndevices; index++ ) {
-    if( dev_id == (void*) &dt3155_status[ index ])
+  for (index = 0; index < ndevices; index++) {
+    if(dev_id == (void*) &dt3155_status[index])
       {
 	minor = index;
 	break;
@@ -192,15 +192,15 @@ static inline void dt3155_isr( int irq, void *dev_id, struct pt_regs *regs )
   }
 
   /* hopefully we should not get here */
-  if ( minor < 0 || minor >= MAXBOARDS ) {
+  if (minor < 0 || minor >= MAXBOARDS) {
     printk(KERN_ERR "dt3155_isr called with invalid dev_id\n");
     return;
   }
 
   /* Check for corruption and set a flag if so */
-  ReadMReg( (dt3155_lbase[ minor ] + CSR1), csr1_r.reg );
+  ReadMReg((dt3155_lbase[minor] + CSR1), csr1_r.reg);
 
-  if ( (csr1_r.fld.FLD_CRPT_EVE) || (csr1_r.fld.FLD_CRPT_ODD) )
+  if ((csr1_r.fld.FLD_CRPT_EVE) || (csr1_r.fld.FLD_CRPT_ODD))
     {
       /* TODO: this should probably stop acquisition */
       /* and set some flags so that dt3155_read      */
@@ -210,27 +210,27 @@ static inline void dt3155_isr( int irq, void *dev_id, struct pt_regs *regs )
       return;
     }
 
-  ReadMReg((dt3155_lbase[ minor ] + INT_CSR), int_csr_r.reg);
+  ReadMReg((dt3155_lbase[minor] + INT_CSR), int_csr_r.reg);
 
   /* Handle the even field ... */
   if (int_csr_r.fld.FLD_END_EVE)
     {
-      if ( (dt3155_status[ minor ].state & DT3155_STATE_MODE) ==
-	   DT3155_STATE_FLD )
+      if ((dt3155_status[minor].state & DT3155_STATE_MODE) ==
+	   DT3155_STATE_FLD)
 	{
-	  dt3155_fbuffer[ minor ]->frame_count++;
+	  dt3155_fbuffer[minor]->frame_count++;
 	}
 
-      ReadI2C(dt3155_lbase[ minor ], EVEN_CSR, &i2c_even_csr.reg);
+      ReadI2C(dt3155_lbase[minor], EVEN_CSR, &i2c_even_csr.reg);
 
       /* Clear the interrupt? */
       int_csr_r.fld.FLD_END_EVE = 1;
 
       /* disable the interrupt if last field */
-      if (dt3155_fbuffer[ minor ]->stop_acquire)
+      if (dt3155_fbuffer[minor]->stop_acquire)
 	{
 	  printk("dt3155:  even stopped.\n");
-	  dt3155_fbuffer[ minor ]->even_stopped = 1;
+	  dt3155_fbuffer[minor]->even_stopped = 1;
 	  if (i2c_even_csr.fld.SNGL_EVE)
 	    {
 	      int_csr_r.fld.FLD_END_EVE_EN = 0;
@@ -241,75 +241,75 @@ static inline void dt3155_isr( int irq, void *dev_id, struct pt_regs *regs )
 	    }
 	}
 
-      WriteMReg( (dt3155_lbase[ minor ] + INT_CSR), int_csr_r.reg );
+      WriteMReg((dt3155_lbase[minor] + INT_CSR), int_csr_r.reg);
 
       /* Set up next DMA if we are doing FIELDS */
-      if ( (dt3155_status[ minor ].state & DT3155_STATE_MODE ) ==
+      if ((dt3155_status[minor].state & DT3155_STATE_MODE) ==
 	   DT3155_STATE_FLD)
 	{
 	  /* GCS (Aug 2, 2002) -- In field mode, dma the odd field
 	     into the lower half of the buffer */
-	  const u32 stride =  dt3155_status[ minor ].config.cols;
-	  buffer_addr = dt3155_fbuffer[ minor ]->
-	    frame_info[ dt3155_fbuffer[ minor ]->active_buf ].addr
+	  const u32 stride =  dt3155_status[minor].config.cols;
+	  buffer_addr = dt3155_fbuffer[minor]->
+	    frame_info[dt3155_fbuffer[minor]->active_buf].addr
 	    + (DT3155_MAX_ROWS / 2) * stride;
 	  local_save_flags(flags);
 	  local_irq_disable();
-	  wake_up_interruptible( &dt3155_read_wait_queue[ minor ] );
+	  wake_up_interruptible(&dt3155_read_wait_queue[minor]);
 
 	  /* Set up the DMA address for the next field */
 	  local_irq_restore(flags);
-	  WriteMReg((dt3155_lbase[ minor ] + ODD_DMA_START), buffer_addr);
+	  WriteMReg((dt3155_lbase[minor] + ODD_DMA_START), buffer_addr);
 	}
 
       /* Check for errors. */
       i2c_even_csr.fld.DONE_EVE = 1;
-      if ( i2c_even_csr.fld.ERROR_EVE )
+      if (i2c_even_csr.fld.ERROR_EVE)
 	dt3155_errno = DT_ERR_OVERRUN;
 
-      WriteI2C( dt3155_lbase[ minor ], EVEN_CSR, i2c_even_csr.reg );
+      WriteI2C(dt3155_lbase[minor], EVEN_CSR, i2c_even_csr.reg);
 
       /* Note that we actually saw an even field meaning  */
       /* that subsequent odd field complete the frame     */
-      dt3155_fbuffer[ minor ]->even_happened = 1;
+      dt3155_fbuffer[minor]->even_happened = 1;
 
       /* recording the time that the even field finished, this should be */
       /* about time in the middle of the frame */
-      do_gettimeofday( &(dt3155_fbuffer[ minor ]->
-			 frame_info[ dt3155_fbuffer[ minor ]->
-				     active_buf ].time) );
+      do_gettimeofday(&(dt3155_fbuffer[minor]->
+			 frame_info[dt3155_fbuffer[minor]->
+				     active_buf].time));
       return;
     }
 
   /* ... now handle the odd field */
-  if ( int_csr_r.fld.FLD_END_ODD )
+  if (int_csr_r.fld.FLD_END_ODD)
     {
-      ReadI2C( dt3155_lbase[ minor ], ODD_CSR, &i2c_odd_csr.reg );
+      ReadI2C(dt3155_lbase[minor], ODD_CSR, &i2c_odd_csr.reg);
 
       /* Clear the interrupt? */
       int_csr_r.fld.FLD_END_ODD = 1;
 
-      if (dt3155_fbuffer[ minor ]->even_happened ||
-	  (dt3155_status[ minor ].state & DT3155_STATE_MODE) ==
+      if (dt3155_fbuffer[minor]->even_happened ||
+	  (dt3155_status[minor].state & DT3155_STATE_MODE) ==
 	  DT3155_STATE_FLD)
 	{
-	  dt3155_fbuffer[ minor ]->frame_count++;
+	  dt3155_fbuffer[minor]->frame_count++;
 	}
 
-      if ( dt3155_fbuffer[ minor ]->stop_acquire &&
-	   dt3155_fbuffer[ minor ]->even_stopped )
+      if (dt3155_fbuffer[minor]->stop_acquire &&
+	   dt3155_fbuffer[minor]->even_stopped)
 	{
 	  printk(KERN_DEBUG "dt3155:  stopping odd..\n");
-	  if ( i2c_odd_csr.fld.SNGL_ODD )
+	  if (i2c_odd_csr.fld.SNGL_ODD)
 	    {
 	      /* disable interrupts */
 	      int_csr_r.fld.FLD_END_ODD_EN = 0;
-	      dt3155_status[ minor ].state &= ~(DT3155_STATE_STOP|0xff);
+	      dt3155_status[minor].state &= ~(DT3155_STATE_STOP|0xff);
 
 	      /* mark the system stopped: */
-	      dt3155_status[ minor ].state |= DT3155_STATE_IDLE;
-	      dt3155_fbuffer[ minor ]->stop_acquire = 0;
-	      dt3155_fbuffer[ minor ]->even_stopped = 0;
+	      dt3155_status[minor].state |= DT3155_STATE_IDLE;
+	      dt3155_fbuffer[minor]->stop_acquire = 0;
+	      dt3155_fbuffer[minor]->even_stopped = 0;
 
 	      printk(KERN_DEBUG "dt3155:  state is now %x\n",
 		     dt3155_status[minor].state);
@@ -320,104 +320,104 @@ static inline void dt3155_isr( int irq, void *dev_id, struct pt_regs *regs )
 	    }
 	}
 
-      WriteMReg( (dt3155_lbase[ minor ] + INT_CSR), int_csr_r.reg );
+      WriteMReg((dt3155_lbase[minor] + INT_CSR), int_csr_r.reg);
 
       /* if the odd field has been acquired, then     */
       /* change the next dma location for both fields */
       /* and wake up the process if sleeping          */
-      if ( dt3155_fbuffer[ minor ]->even_happened ||
-	   (dt3155_status[ minor ].state & DT3155_STATE_MODE) ==
-	   DT3155_STATE_FLD )
+      if (dt3155_fbuffer[minor]->even_happened ||
+	   (dt3155_status[minor].state & DT3155_STATE_MODE) ==
+	   DT3155_STATE_FLD)
 	{
 
 	  local_save_flags(flags);
 	  local_irq_disable();
 
 #ifdef DEBUG_QUES_B
-	  printques( minor );
+	  printques(minor);
 #endif
-	  if ( dt3155_fbuffer[ minor ]->nbuffers > 2 )
+	  if (dt3155_fbuffer[minor]->nbuffers > 2)
 	    {
-	      if ( !are_empty_buffers( minor ) )
+	      if (!are_empty_buffers(minor))
 		{
 		  /* The number of active + locked buffers is
 		   * at most 2, and since there are none empty, there
 		   * must be at least nbuffers-2 ready buffers.
 		   * This is where we 'drop frames', oldest first. */
-		  push_empty( pop_ready( minor ),  minor );
+		  push_empty(pop_ready(minor),  minor);
 		}
 
 	      /* The ready_que can't be full, since we know
 	       * there is one active buffer right now, so it's safe
 	       * to push the active buf on the ready_que. */
-	      push_ready( minor, dt3155_fbuffer[ minor ]->active_buf );
+	      push_ready(minor, dt3155_fbuffer[minor]->active_buf);
 	      /* There's at least 1 empty -- make it active */
-	      dt3155_fbuffer[ minor ]->active_buf = pop_empty( minor );
-	      dt3155_fbuffer[ minor ]->
-		frame_info[ dt3155_fbuffer[ minor ]->
-			    active_buf ].tag = ++unique_tag;
+	      dt3155_fbuffer[minor]->active_buf = pop_empty(minor);
+	      dt3155_fbuffer[minor]->
+		frame_info[dt3155_fbuffer[minor]->
+			    active_buf].tag = ++unique_tag;
 	    }
 	  else /* nbuffers == 2, special case */
 	    { /* There is 1 active buffer.
 	       * If there is a locked buffer, keep the active buffer
 	       * the same -- that means we drop a frame.
 	       */
-	      if ( dt3155_fbuffer[ minor ]->locked_buf < 0 )
+	      if (dt3155_fbuffer[minor]->locked_buf < 0)
 		{
-		  push_ready( minor,
-			      dt3155_fbuffer[ minor ]->active_buf );
-		  if (are_empty_buffers( minor ) )
+		  push_ready(minor,
+			      dt3155_fbuffer[minor]->active_buf);
+		  if (are_empty_buffers(minor))
 		    {
-		      dt3155_fbuffer[ minor ]->active_buf =
-			pop_empty( minor );
+		      dt3155_fbuffer[minor]->active_buf =
+			pop_empty(minor);
 		    }
 		  else
 		    { /* no empty or locked buffers, so use a readybuf */
-		      dt3155_fbuffer[ minor ]->active_buf =
-			pop_ready( minor );
+		      dt3155_fbuffer[minor]->active_buf =
+			pop_ready(minor);
 		    }
 		}
 	    }
 
 #ifdef DEBUG_QUES_B
-	  printques( minor );
+	  printques(minor);
 #endif
 
-	  dt3155_fbuffer[ minor ]->even_happened = 0;
+	  dt3155_fbuffer[minor]->even_happened = 0;
 
-	  wake_up_interruptible( &dt3155_read_wait_queue[ minor ] );
+	  wake_up_interruptible(&dt3155_read_wait_queue[minor]);
 
 	  local_irq_restore(flags);
 	}
 
 
       /* Set up the DMA address for the next frame/field */
-      buffer_addr = dt3155_fbuffer[ minor ]->
-	frame_info[ dt3155_fbuffer[ minor ]->active_buf ].addr;
-      if ( (dt3155_status[ minor ].state & DT3155_STATE_MODE) ==
-	   DT3155_STATE_FLD )
+      buffer_addr = dt3155_fbuffer[minor]->
+	frame_info[dt3155_fbuffer[minor]->active_buf].addr;
+      if ((dt3155_status[minor].state & DT3155_STATE_MODE) ==
+	   DT3155_STATE_FLD)
 	{
-	  WriteMReg((dt3155_lbase[ minor ] + EVEN_DMA_START), buffer_addr);
+	  WriteMReg((dt3155_lbase[minor] + EVEN_DMA_START), buffer_addr);
 	}
       else
 	{
-	  WriteMReg((dt3155_lbase[ minor ] + EVEN_DMA_START), buffer_addr);
+	  WriteMReg((dt3155_lbase[minor] + EVEN_DMA_START), buffer_addr);
 
-	  WriteMReg((dt3155_lbase[ minor ] + ODD_DMA_START), buffer_addr
-		    + dt3155_status[ minor ].config.cols);
+	  WriteMReg((dt3155_lbase[minor] + ODD_DMA_START), buffer_addr
+		    + dt3155_status[minor].config.cols);
 	}
 
       /* Do error checking */
       i2c_odd_csr.fld.DONE_ODD = 1;
-      if ( i2c_odd_csr.fld.ERROR_ODD )
+      if (i2c_odd_csr.fld.ERROR_ODD)
 	dt3155_errno = DT_ERR_OVERRUN;
 
-      WriteI2C(dt3155_lbase[ minor ], ODD_CSR, i2c_odd_csr.reg );
+      WriteI2C(dt3155_lbase[minor], ODD_CSR, i2c_odd_csr.reg);
 
       return;
     }
   /* If we get here, the Odd Field wasn't it either... */
-  printk( "neither even nor odd.  shared perhaps?\n");
+  printk("neither even nor odd.  shared perhaps?\n");
 }
 
 /*****************************************************
@@ -428,22 +428,22 @@ static inline void dt3155_isr( int irq, void *dev_id, struct pt_regs *regs )
  *****************************************************/
 static void dt3155_init_isr(int minor)
 {
-  const u32 stride =  dt3155_status[ minor ].config.cols;
+  const u32 stride =  dt3155_status[minor].config.cols;
 
-  switch (dt3155_status[ minor ].state & DT3155_STATE_MODE)
+  switch (dt3155_status[minor].state & DT3155_STATE_MODE)
     {
     case DT3155_STATE_FLD:
       {
-	even_dma_start_r  = dt3155_status[ minor ].
-	  fbuffer.frame_info[ dt3155_status[ minor ].fbuffer.active_buf ].addr;
+	even_dma_start_r  = dt3155_status[minor].
+	  fbuffer.frame_info[dt3155_status[minor].fbuffer.active_buf].addr;
 	even_dma_stride_r = 0;
 	odd_dma_stride_r  = 0;
 
-	WriteMReg((dt3155_lbase[ minor ] + EVEN_DMA_START),
+	WriteMReg((dt3155_lbase[minor] + EVEN_DMA_START),
 		  even_dma_start_r);
-	WriteMReg((dt3155_lbase[ minor ] + EVEN_DMA_STRIDE),
+	WriteMReg((dt3155_lbase[minor] + EVEN_DMA_STRIDE),
 		  even_dma_stride_r);
-	WriteMReg((dt3155_lbase[ minor ] + ODD_DMA_STRIDE),
+	WriteMReg((dt3155_lbase[minor] + ODD_DMA_STRIDE),
 		  odd_dma_stride_r);
 	break;
       }
@@ -451,19 +451,19 @@ static void dt3155_init_isr(int minor)
     case DT3155_STATE_FRAME:
     default:
       {
-	even_dma_start_r  = dt3155_status[ minor ].
-	  fbuffer.frame_info[ dt3155_status[ minor ].fbuffer.active_buf ].addr;
+	even_dma_start_r  = dt3155_status[minor].
+	  fbuffer.frame_info[dt3155_status[minor].fbuffer.active_buf].addr;
 	odd_dma_start_r   =  even_dma_start_r + stride;
 	even_dma_stride_r =  stride;
 	odd_dma_stride_r  =  stride;
 
-	WriteMReg((dt3155_lbase[ minor ] + EVEN_DMA_START),
+	WriteMReg((dt3155_lbase[minor] + EVEN_DMA_START),
 		  even_dma_start_r);
-	WriteMReg((dt3155_lbase[ minor ] + ODD_DMA_START),
+	WriteMReg((dt3155_lbase[minor] + ODD_DMA_START),
 		  odd_dma_start_r);
-	WriteMReg((dt3155_lbase[ minor ] + EVEN_DMA_STRIDE),
+	WriteMReg((dt3155_lbase[minor] + EVEN_DMA_STRIDE),
 		  even_dma_stride_r);
-	WriteMReg((dt3155_lbase[ minor ] + ODD_DMA_STRIDE),
+	WriteMReg((dt3155_lbase[minor] + ODD_DMA_STRIDE),
 		  odd_dma_stride_r);
 	break;
       }
@@ -472,9 +472,9 @@ static void dt3155_init_isr(int minor)
   /* 50/60 Hz should be set before this point but let's make sure it is */
   /* right anyway */
 
-  ReadI2C(dt3155_lbase[ minor ], CONFIG, &i2c_csr2.reg);
+  ReadI2C(dt3155_lbase[minor], CONFIG, &i2c_csr2.reg);
   i2c_csr2.fld.HZ50 = FORMAT50HZ;
-  WriteI2C(dt3155_lbase[ minor ], CONFIG, i2c_config.reg);
+  WriteI2C(dt3155_lbase[minor], CONFIG, i2c_config.reg);
 
   /* enable busmaster chip, clear flags */
 
@@ -494,7 +494,7 @@ static void dt3155_init_isr(int minor)
   csr1_r.fld.FLD_CRPT_EVE   = 1; /* writing a 1 clears flags */
   csr1_r.fld.FLD_CRPT_ODD   = 1;
 
-  WriteMReg((dt3155_lbase[ minor ] + CSR1),csr1_r.reg);
+  WriteMReg((dt3155_lbase[minor] + CSR1),csr1_r.reg);
 
   /* Enable interrupts at the end of each field */
 
@@ -503,14 +503,14 @@ static void dt3155_init_isr(int minor)
   int_csr_r.fld.FLD_END_ODD_EN = 1;
   int_csr_r.fld.FLD_START_EN = 0;
 
-  WriteMReg((dt3155_lbase[ minor ] + INT_CSR), int_csr_r.reg);
+  WriteMReg((dt3155_lbase[minor] + INT_CSR), int_csr_r.reg);
 
   /* start internal BUSY bits */
 
-  ReadI2C(dt3155_lbase[ minor ], CSR2, &i2c_csr2.reg);
+  ReadI2C(dt3155_lbase[minor], CSR2, &i2c_csr2.reg);
   i2c_csr2.fld.BUSY_ODD  = 1;
   i2c_csr2.fld.BUSY_EVE  = 1;
-  WriteI2C(dt3155_lbase[ minor ], CSR2, i2c_csr2.reg);
+  WriteI2C(dt3155_lbase[minor], CSR2, i2c_csr2.reg);
 
   /* Now its up to the interrupt routine!! */
 
@@ -529,7 +529,7 @@ static int dt3155_ioctl(struct inode *inode,
 {
   int minor = MINOR(inode->i_rdev); /* What device are we ioctl()'ing? */
 
-  if ( minor >= MAXBOARDS || minor < 0 )
+  if (minor >= MAXBOARDS || minor < 0)
     return -ENODEV;
 
   /* make sure it is valid command */
@@ -573,7 +573,7 @@ static int dt3155_ioctl(struct inode *inode,
     case DT3155_GET_CONFIG:
       {
 	if (copy_to_user((void *) arg, (void *) &dt3155_status[minor],
-		     sizeof(dt3155_status_t) ))
+		     sizeof(dt3155_status_t)))
 	    return -EFAULT;
 	return 0;
       }
@@ -617,7 +617,7 @@ static int dt3155_ioctl(struct inode *inode,
 	  }
 
 	dt3155_init_isr(minor);
-	if (copy_to_user( (void *) arg, (void *) &dt3155_status[minor],
+	if (copy_to_user((void *) arg, (void *) &dt3155_status[minor],
 		      sizeof(dt3155_status_t)))
 	    return -EFAULT;
 	return 0;
@@ -689,36 +689,36 @@ static int dt3155_mmap (struct file * file, struct vm_area_struct * vma)
  * MOD_INC_USE_COUNT make sure that the driver memory is not freed
  * while the device is in use.
  *****************************************************/
-static int dt3155_open( struct inode* inode, struct file* filep)
+static int dt3155_open(struct inode* inode, struct file* filep)
 {
   int minor = MINOR(inode->i_rdev); /* what device are we opening? */
-  if (dt3155_dev_open[ minor ]) {
+  if (dt3155_dev_open[minor]) {
     printk ("DT3155:  Already opened by another process.\n");
     return -EBUSY;
   }
 
-  if (dt3155_status[ minor ].device_installed==0)
+  if (dt3155_status[minor].device_installed==0)
     {
       printk("DT3155 Open Error: No such device dt3155 minor number %d\n",
 	     minor);
       return -EIO;
     }
 
-  if (dt3155_status[ minor ].state != DT3155_STATE_IDLE) {
+  if (dt3155_status[minor].state != DT3155_STATE_IDLE) {
     printk ("DT3155:  Not in idle state (state = %x)\n",
-	    dt3155_status[ minor ].state);
+	    dt3155_status[minor].state);
     return -EBUSY;
   }
 
   printk("DT3155: Device opened.\n");
 
-  dt3155_dev_open[ minor ] = 1 ;
+  dt3155_dev_open[minor] = 1 ;
 
-  dt3155_flush( minor );
+  dt3155_flush(minor);
 
   /* Disable ALL interrupts */
   int_csr_r.reg = 0;
-  WriteMReg( (dt3155_lbase[ minor ] + INT_CSR), int_csr_r.reg );
+  WriteMReg((dt3155_lbase[minor] + INT_CSR), int_csr_r.reg);
 
   init_waitqueue_head(&(dt3155_read_wait_queue[minor]));
 
@@ -732,20 +732,20 @@ static int dt3155_open( struct inode* inode, struct file* filep)
  * Now decrement the use count.
  *
  *****************************************************/
-static int dt3155_close( struct inode *inode, struct file *filep)
+static int dt3155_close(struct inode *inode, struct file *filep)
 {
   int minor;
 
   minor = MINOR(inode->i_rdev); /* which device are we closing */
-  if (!dt3155_dev_open[ minor ])
+  if (!dt3155_dev_open[minor])
     {
       printk("DT3155: attempt to CLOSE a not OPEN device\n");
     }
   else
     {
-      dt3155_dev_open[ minor ] = 0;
+      dt3155_dev_open[minor] = 0;
 
-      if (dt3155_status[ minor ].state != DT3155_STATE_IDLE)
+      if (dt3155_status[minor].state != DT3155_STATE_IDLE)
 	{
 	  quick_stop(minor);
 	}
@@ -789,7 +789,7 @@ static ssize_t dt3155_read(struct file *filep, char __user *buf,
   if (filep->f_flags & O_NDELAY)
     {
       if ((frame_index = dt3155_get_ready_buffer(minor)) < 0) {
-	/*printk( "dt3155:  no buffers available (?)\n");*/
+	/*printk("dt3155:  no buffers available (?)\n");*/
 	/* 		printques(minor); */
 	return -EAGAIN;
       }
@@ -821,7 +821,7 @@ static ssize_t dt3155_read(struct file *filep, char __user *buf,
 
   put_user(offset, (unsigned int *) buf);
   buf += sizeof(u32);
-  put_user( dt3155_status[minor].fbuffer.frame_count, (unsigned int *) buf);
+  put_user(dt3155_status[minor].fbuffer.frame_count, (unsigned int *) buf);
   buf += sizeof(u32);
   put_user(dt3155_status[minor].state, (unsigned int *) buf);
   buf += sizeof(u32);
@@ -897,7 +897,7 @@ static int find_PCI (void)
 
       /* Now, just go out and make sure that this/these device(s) is/are
 	 actually mapped into the kernel address space */
-      if ((error = pci_read_config_dword( pci_dev, PCI_BASE_ADDRESS_0,
+      if ((error = pci_read_config_dword(pci_dev, PCI_BASE_ADDRESS_0,
 					  (u32 *) &base)))
 	{
 	  printk("DT3155: Was not able to find device \n");
@@ -909,26 +909,26 @@ static int find_PCI (void)
 
       /* Remap the base address to a logical address through which we
        * can access it. */
-      dt3155_lbase[ pci_index - 1 ] = ioremap(base,PCI_PAGE_SIZE);
-      dt3155_status[ pci_index - 1 ].reg_addr = base;
+      dt3155_lbase[pci_index - 1] = ioremap(base,PCI_PAGE_SIZE);
+      dt3155_status[pci_index - 1].reg_addr = base;
       DT_3155_DEBUG_MSG("DT3155: New logical address is %p \n",
 			dt3155_lbase[pci_index-1]);
-      if ( !dt3155_lbase[pci_index-1] )
+      if (!dt3155_lbase[pci_index-1])
 	{
 	  printk("DT3155: Unable to remap control registers\n");
 	  goto err;
 	}
 
-      if ( (error = pci_read_config_byte( pci_dev, PCI_INTERRUPT_LINE, &irq)) )
+      if ((error = pci_read_config_byte(pci_dev, PCI_INTERRUPT_LINE, &irq)))
 	{
 	  printk("DT3155: Was not able to find device \n");
 	  goto err;
 	}
 
       DT_3155_DEBUG_MSG("DT3155: IRQ is %d \n",irq);
-      dt3155_status[ pci_index-1 ].irq = irq;
+      dt3155_status[pci_index-1].irq = irq;
       /* Set flag: kth device found! */
-      dt3155_status[ pci_index-1 ].device_installed = 1;
+      dt3155_status[pci_index-1].device_installed = 1;
       printk("DT3155: Installing device %d w/irq %d and address %p\n",
 	     pci_index,
 	     dt3155_status[pci_index-1].irq,
@@ -953,89 +953,89 @@ int init_module(void)
 {
   int index;
   int rcode = 0;
-  char *devname[ MAXBOARDS ];
+  char *devname[MAXBOARDS];
 
-  devname[ 0 ] = "dt3155a";
+  devname[0] = "dt3155a";
 #if MAXBOARDS == 2
-  devname[ 1 ] = "dt3155b";
+  devname[1] = "dt3155b";
 #endif
 
   printk("DT3155: Loading module...\n");
 
   /* Register the device driver */
-  rcode = register_chrdev( dt3155_major, "dt3155", &dt3155_fops );
-  if( rcode < 0 )
+  rcode = register_chrdev(dt3155_major, "dt3155", &dt3155_fops);
+  if(rcode < 0)
     {
-      printk( KERN_INFO "DT3155: register_chrdev failed \n");
+      printk(KERN_INFO "DT3155: register_chrdev failed \n");
       return rcode;
     }
 
-  if( dt3155_major == 0 )
+  if(dt3155_major == 0)
     dt3155_major = rcode; /* dynamic */
 
 
   /* init the status variables.                     */
   /* DMA memory is taken care of in setup_buffers() */
-  for ( index = 0; index < MAXBOARDS; index++ )
+  for (index = 0; index < MAXBOARDS; index++)
     {
-      dt3155_status[ index ].config.acq_mode   = DT3155_MODE_FRAME;
-      dt3155_status[ index ].config.continuous = DT3155_ACQ;
-      dt3155_status[ index ].config.cols       = DT3155_MAX_COLS;
-      dt3155_status[ index ].config.rows       = DT3155_MAX_ROWS;
-      dt3155_status[ index ].state = DT3155_STATE_IDLE;
+      dt3155_status[index].config.acq_mode   = DT3155_MODE_FRAME;
+      dt3155_status[index].config.continuous = DT3155_ACQ;
+      dt3155_status[index].config.cols       = DT3155_MAX_COLS;
+      dt3155_status[index].config.rows       = DT3155_MAX_ROWS;
+      dt3155_status[index].state = DT3155_STATE_IDLE;
 
       /* find_PCI() will check if devices are installed; */
       /* first assume they're not:                       */
-      dt3155_status[ index ].mem_addr          = 0;
-      dt3155_status[ index ].mem_size          = 0;
-      dt3155_status[ index ].state             = DT3155_STATE_IDLE;
-      dt3155_status[ index ].device_installed  = 0;
+      dt3155_status[index].mem_addr          = 0;
+      dt3155_status[index].mem_size          = 0;
+      dt3155_status[index].state             = DT3155_STATE_IDLE;
+      dt3155_status[index].device_installed  = 0;
     }
 
   /* Now let's find the hardware.  find_PCI() will set ndevices to the
    * number of cards found in this machine. */
     {
-      if ( (rcode = find_PCI()) !=  DT_3155_SUCCESS )
+      if ((rcode = find_PCI()) !=  DT_3155_SUCCESS)
 	{
 	  printk("DT3155 error: find_PCI() failed to find dt3155 board(s)\n");
-	  unregister_chrdev( dt3155_major, "dt3155" );
+	  unregister_chrdev(dt3155_major, "dt3155");
 	  return rcode;
 	}
     }
 
   /* Ok, time to setup the frame buffers */
-  if( (rcode = dt3155_setup_buffers(&allocatorAddr)) < 0 )
+  if((rcode = dt3155_setup_buffers(&allocatorAddr)) < 0)
     {
       printk("DT3155: Error: setting up buffer not large enough.");
-      unregister_chrdev( dt3155_major, "dt3155" );
+      unregister_chrdev(dt3155_major, "dt3155");
       return rcode;
     }
 
   /* If we are this far, then there is enough RAM */
   /* for the buffers: Print the configuration.    */
-  for(  index = 0;  index < ndevices;  index++ )
+  for( index = 0;  index < ndevices;  index++)
     {
       printk("DT3155: Device = %d; acq_mode = %d; "
 	     "continuous = %d; cols = %d; rows = %d;\n",
 	     index ,
-	     dt3155_status[ index ].config.acq_mode,
-	     dt3155_status[ index ].config.continuous,
-	     dt3155_status[ index ].config.cols,
-	     dt3155_status[ index ].config.rows);
+	     dt3155_status[index].config.acq_mode,
+	     dt3155_status[index].config.continuous,
+	     dt3155_status[index].config.cols,
+	     dt3155_status[index].config.rows);
       printk("DT3155: m_addr = 0x%x; m_size = %ld; "
 	     "state = %d; device_installed = %d\n",
-	     dt3155_status[ index ].mem_addr,
-	     (long int)dt3155_status[ index ].mem_size,
-	     dt3155_status[ index ].state,
-	     dt3155_status[ index ].device_installed);
+	     dt3155_status[index].mem_addr,
+	     (long int)dt3155_status[index].mem_size,
+	     dt3155_status[index].state,
+	     dt3155_status[index].device_installed);
     }
 
   /* Disable ALL interrupts */
   int_csr_r.reg = 0;
-  for(  index = 0;  index < ndevices;  index++ )
+  for( index = 0;  index < ndevices;  index++)
     {
-      WriteMReg( (dt3155_lbase[ index ] + INT_CSR), int_csr_r.reg );
-      if( dt3155_status[ index ].device_installed )
+      WriteMReg((dt3155_lbase[index] + INT_CSR), int_csr_r.reg);
+      if(dt3155_status[index].device_installed)
 	{
 	  /*
 	   * This driver *looks* like it can handle sharing interrupts,
@@ -1044,14 +1044,14 @@ int init_module(void)
 	   * as a reminder in case any problems arise. (SS)
 	   */
 	  /* in older kernels flags are: SA_SHIRQ | SA_INTERRUPT */
-	  rcode = request_irq( dt3155_status[ index ].irq, (void *)dt3155_isr,
-			       IRQF_SHARED | IRQF_DISABLED, devname[ index ],
+	  rcode = request_irq(dt3155_status[index].irq, (void *)dt3155_isr,
+			       IRQF_SHARED | IRQF_DISABLED, devname[index],
 			       (void*) &dt3155_status[index]);
-	  if( rcode < 0 )
+	  if(rcode < 0)
 	    {
 	      printk("DT3155: minor %d request_irq failed for IRQ %d\n",
 		     index, dt3155_status[index].irq);
-	      unregister_chrdev( dt3155_major, "dt3155" );
+	      unregister_chrdev(dt3155_major, "dt3155");
 	      return rcode;
 	    }
 	}
@@ -1080,15 +1080,15 @@ void cleanup_module(void)
   allocator_cleanup();
 #endif
 
-  unregister_chrdev( dt3155_major, "dt3155" );
+  unregister_chrdev(dt3155_major, "dt3155");
 
-  for( index = 0; index < ndevices; index++ )
+  for(index = 0; index < ndevices; index++)
     {
-      if( dt3155_status[ index ].device_installed == 1 )
+      if(dt3155_status[index].device_installed == 1)
 	{
-	  printk( "DT3155: Freeing irq %d for device %d\n",
-		  dt3155_status[ index ].irq, index );
-	  free_irq( dt3155_status[ index ].irq, (void*)&dt3155_status[index] );
+	  printk("DT3155: Freeing irq %d for device %d\n",
+		  dt3155_status[index].irq, index);
+	  free_irq(dt3155_status[index].irq, (void*)&dt3155_status[index]);
 	}
     }
 }
-- 
1.6.3.3

