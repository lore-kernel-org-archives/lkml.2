Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab0C1P0c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 11:26:32 -0400
Received: from smtp1.rdslink.ro ([81.196.12.70]:55013 "EHLO smtp.rdslink.ro"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753657Ab0C1P0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 11:26:30 -0400
X-Mail-Scanner: Scanned by qSheff-II-2.1-r3 (http://www.enderunix.org/qsheff/)
Subject: Staging: dt3155: fixed some checkpatch.pl warnings and errors in
 dt3155_drv.c
From: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>
To: gregkh@suse.de, horms@verge.net.au, hsweeten@visionengravers.com,
       ss@aao.gov.au
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Sun, 28 Mar 2010 18:26:14 +0300
Message-ID: <1269789974.7294.1.camel@tuxtm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From cebbf20baee8df57b879a2b6dd1b9a04afe3e5e8 Mon Sep 17 00:00:00 2001
From: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>
Date: Sun, 28 Mar 2010 18:22:06 +0300
Subject: [PATCH 7/7] Staging: dt3155: fixed some checkpatch.pl warnings and errors in dt3155_drv.c
 This is a patch to the dt3155_drv.c file that fixes up errors and warnings found by the checkpatch.pl tool
 Signed-off-by: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>

---
 drivers/staging/dt3155/dt3155_drv.c | 1220 +++++++++++++++++------------------
 1 files changed, 583 insertions(+), 637 deletions(-)

diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index a67c622..6adbeb2 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -1,59 +1,57 @@
 /*
-
-Copyright 1996,2002,2005 Gregory D. Hager, Alfred A. Rizzi, Noah J. Cowan,
-                         Jason Lapenta, Scott Smedley, Greg Sharp
-
-This file is part of the DT3155 Device Driver.
-
-The DT3155 Device Driver is free software; you can redistribute it
-and/or modify it under the terms of the GNU General Public License as
-published by the Free Software Foundation; either version 2 of the
-License, or (at your option) any later version.
-
-The DT3155 Device Driver is distributed in the hope that it will be
-useful, but WITHOUT ANY WARRANTY; without even the implied warranty
-of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-GNU General Public License for more details.
-
-You should have received a copy of the GNU General Public License
-along with the DT3155 Device Driver; if not, write to the Free
-Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
-MA 02111-1307 USA
-
--- Changes --
-
-  Date     Programmer	Description of changes made
-  -------------------------------------------------------------------
-  03-Jul-2000 JML       n/a
-  10-Oct-2001 SS        port to 2.4 kernel
-  02-Apr-2002 SS        Mods to use allocator as a standalone module;
-                        Merged John Roll's changes (john@cfa.harvard.edu)
-                        to make work with multiple boards.
-  02-Jul-2002 SS        Merged James Rose's chages (rosejr@purdue.edu) to:
-                         * fix successive interrupt-driven captures
-                         * add select/poll support.
-  10-Jul-2002 GCS       Add error check when ndevices > MAXBOARDS.
-  02-Aug-2002 GCS       Fix field mode so that odd (lower) field is stored
-                        in lower half of buffer.
-  05-Aug-2005 SS        port to 2.6 kernel.
-  26-Oct-2009 SS	port to 2.6.30 kernel.
-
--- Notes --
-
-** appended "mem=124" in lilo.conf to allow for 4megs free on my 128meg system.
+ *
+ * Copyright 1996,2002,2005 Gregory D. Hager, Alfred A. Rizzi, Noah J. Cowan,
+ *                          Jason Lapenta, Scott Smedley, Greg Sharp
+ *
+ * This file is part of the DT3155 Device Driver.
+ *
+ * The DT3155 Device Driver is free software; you can redistribute it
+ * and/or modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ *
+ * The DT3155 Device Driver is distributed in the hope that it will be
+ * useful, but WITHOUT ANY WARRANTY; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with the DT3155 Device Driver; if not, write to the Free
+ * Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ *
+ * -- Changes --
+ *
+ * Date     Programmer	Description of changes made
+ * -------------------------------------------------------------------
+ * 03-Jul-2000 JML       n/a
+ * 10-Oct-2001 SS        port to 2.4 kernel
+ * 02-Apr-2002 SS        Mods to use allocator as a standalone module;
+ *                       Merged John Roll's changes (john@cfa.harvard.edu)
+ *                       to make work with multiple boards.
+ * 02-Jul-2002 SS        Merged James Rose's chages (rosejr@purdue.edu) to:
+ *                        * fix successive interrupt-driven captures
+ *                        * add select/poll support.
+ * 10-Jul-2002 GCS       Add error check when ndevices > MAXBOARDS.
+ * 02-Aug-2002 GCS       Fix field mode so that odd (lower) field is stored
+ *                       in lower half of buffer.
+ * 05-Aug-2005 SS        port to 2.6 kernel.
+ * 26-Oct-2009 SS	port to 2.6.30 kernel.
+ *
+ * -- Notes --
+ *
+ * appended "mem=124" in lilo.conf to allow for 4megs free on my 128meg system.
  * using allocator.c and allocator.h from o'reilly book (alessandro rubini)
-    ftp://ftp.systemy.it/pub/develop (see README.allocator)
-
- + might want to get rid of MAXboards for allocating initial buffer.
-    confusing and not necessary
-
- + in cleanup_module the MOD_IN_USE looks like it is check after it should
-
+ * ftp://ftp.systemy.it/pub/develop (see README.allocator)
+ *
+ * + might want to get rid of MAXboards for allocating initial buffer.
+ * confusing and not necessary
+ * + in cleanup_module the MOD_IN_USE looks like it is check after it should
+ *
  * GFP_DMA should not be set with a PCI system (pg 291)
-
- - NJC why are only two buffers allowed? (see isr, approx line 358)
-
-*/
+ *
+ * - NJC why are only two buffers allowed? (see isr, approx line 358)
+ */
 
 extern void printques(int);
 
@@ -75,8 +73,8 @@ MODULE_LICENSE("GPL");
 #include <linux/poll.h>
 #include <linux/sched.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
 #include "dt3155.h"
 #include "dt3155_drv.h"
@@ -96,19 +94,20 @@ int dt3155_errno = 0;
 #define MAXPCI    16
 
 #ifdef DT_DEBUG
-#define DT_3155_DEBUG_MSG(x,y) printk(x,y)
+#define DT_3155_DEBUG_MSG(x, y) printk(x, y)
 #else
-#define DT_3155_DEBUG_MSG(x,y)
+#define DT_3155_DEBUG_MSG(x, y)
 #endif
 
 /* wait queue for interrupts */
-wait_queue_head_t dt3155_read_wait_queue[ MAXBOARDS ];
+wait_queue_head_t dt3155_read_wait_queue[MAXBOARDS];
 
 #define DT_3155_SUCCESS 0
 #define DT_3155_FAILURE -EIO
 
-/* set to dynamicaly allocate, but it is tunable: */
-/* insmod DT_3155 dt3155 dt3155_major=XX */
+/* set to dynamicaly allocate, but it is tunable:
+ * insmod DT_3155 dt3155 dt3155_major=XX
+ */
 int dt3155_major = 0;
 
 /* The minor numbers are 0 and 1 ... they are not tunable.
@@ -119,18 +118,21 @@ int dt3155_major = 0;
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
 };
-/* DT3155 registers              */
-u8 *dt3155_bbase = NULL;		  /* kernel logical address of the *
-					   * buffer region                 */
-u32  dt3155_dev_open[ MAXBOARDS ] = {0
+/* DT3155 registers
+ * kernel logical address of the
+ * buffer region
+ */
+u8 *dt3155_bbase = NULL;
+
+u32  dt3155_dev_open[MAXBOARDS] = {0
 #if MAXBOARDS == 2
 				       , 0
 #endif
@@ -145,21 +147,21 @@ u32 unique_tag = 0;;
  * to idle.  I don't know why this works and the other way doesn't.
  * (James Rose)
  */
-static void quick_stop (int minor)
+static void quick_stop(int minor)
 {
-  // TODO: scott was here
+  /* TODO: scott was here */
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
@@ -168,14 +170,14 @@ static void quick_stop (int minor)
 }
 
 
-/*****************************************************
- *  dt3155_isr() Interrupt service routien
+/*
+ * dt3155_isr() Interrupt service routien
  *
  * - looks like this isr supports IRQ sharing (or could) JML
  * - Assumes irq's are disabled, via SA_INTERRUPT flag
  * being set in request_irq() call from init_module()
- *****************************************************/
-static inline void dt3155_isr( int irq, void *dev_id, struct pt_regs *regs )
+ */
+static inline void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
 {
   int    minor = -1;
   int    index;
@@ -183,298 +185,273 @@ static inline void dt3155_isr( int irq, void *dev_id, struct pt_regs *regs )
   u32 buffer_addr;
 
   /* find out who issued the interrupt */
-  for ( index = 0; index < ndevices; index++ ) {
-    if( dev_id == (void*) &dt3155_status[ index ])
-      {
-	minor = index;
-	break;
-      }
+  for (index = 0; index < ndevices; index++) {
+	if (dev_id == (void *) &dt3155_status[index]) {
+		minor = index;
+		break;
+	}
   }
 
   /* hopefully we should not get here */
-  if ( minor < 0 || minor >= MAXBOARDS ) {
-    printk(KERN_ERR "dt3155_isr called with invalid dev_id\n");
-    return;
+  if (minor < 0 || minor >= MAXBOARDS) {
+	printk(KERN_ERR "dt3155_isr called with invalid dev_id\n");
+	return;
   }
 
   /* Check for corruption and set a flag if so */
-  ReadMReg( (dt3155_lbase[ minor ] + CSR1), csr1_r.reg );
-
-  if ( (csr1_r.fld.FLD_CRPT_EVE) || (csr1_r.fld.FLD_CRPT_ODD) )
-    {
-      /* TODO: this should probably stop acquisition */
-      /* and set some flags so that dt3155_read      */
-      /* returns an error next time it is called     */
-      dt3155_errno = DT_ERR_CORRUPT;
-      printk("dt3155:  corrupt field\n");
-      return;
-    }
+  ReadMReg((dt3155_lbase[minor] + CSR1), csr1_r.reg);
+
+  if ((csr1_r.fld.FLD_CRPT_EVE) || (csr1_r.fld.FLD_CRPT_ODD)) {
+	/* TODO: this should probably stop acquisition
+	* and set some flags so that dt3155_read
+	* returns an error next time it is called
+	*/
+	dt3155_errno = DT_ERR_CORRUPT;
+	printk("dt3155:  corrupt field\n");
+	return;
+  }
 
-  ReadMReg((dt3155_lbase[ minor ] + INT_CSR), int_csr_r.reg);
+  ReadMReg((dt3155_lbase[minor] + INT_CSR), int_csr_r.reg);
 
   /* Handle the even field ... */
-  if (int_csr_r.fld.FLD_END_EVE)
-    {
-      if ( (dt3155_status[ minor ].state & DT3155_STATE_MODE) ==
-	   DT3155_STATE_FLD )
-	{
-	  dt3155_fbuffer[ minor ]->frame_count++;
+  if (int_csr_r.fld.FLD_END_EVE) {
+	if ((dt3155_status[minor].state & DT3155_STATE_MODE) ==
+	     DT3155_STATE_FLD)
+		dt3155_fbuffer[minor]->frame_count++;
+
+	ReadI2C(dt3155_lbase[minor], EVEN_CSR, &i2c_even_csr.reg);
+
+	/* Clear the interrupt? */
+	int_csr_r.fld.FLD_END_EVE = 1;
+
+	/* disable the interrupt if last field */
+	if (dt3155_fbuffer[minor]->stop_acquire) {
+		printk("dt3155:  even stopped.\n");
+		dt3155_fbuffer[minor]->even_stopped = 1;
+		if (i2c_even_csr.fld.SNGL_EVE)
+			int_csr_r.fld.FLD_END_EVE_EN = 0;
+		else
+			i2c_even_csr.fld.SNGL_EVE  = 1;
 	}
 
-      ReadI2C(dt3155_lbase[ minor ], EVEN_CSR, &i2c_even_csr.reg);
-
-      /* Clear the interrupt? */
-      int_csr_r.fld.FLD_END_EVE = 1;
-
-      /* disable the interrupt if last field */
-      if (dt3155_fbuffer[ minor ]->stop_acquire)
-	{
-	  printk("dt3155:  even stopped.\n");
-	  dt3155_fbuffer[ minor ]->even_stopped = 1;
-	  if (i2c_even_csr.fld.SNGL_EVE)
-	    {
-	      int_csr_r.fld.FLD_END_EVE_EN = 0;
-	    }
-	  else
-	    {
-	      i2c_even_csr.fld.SNGL_EVE  = 1;
-	    }
-	}
-
-      WriteMReg( (dt3155_lbase[ minor ] + INT_CSR), int_csr_r.reg );
-
-      /* Set up next DMA if we are doing FIELDS */
-      if ( (dt3155_status[ minor ].state & DT3155_STATE_MODE ) ==
-	   DT3155_STATE_FLD)
-	{
-	  /* GCS (Aug 2, 2002) -- In field mode, dma the odd field
-	     into the lower half of the buffer */
-	  const u32 stride =  dt3155_status[ minor ].config.cols;
-	  buffer_addr = dt3155_fbuffer[ minor ]->
-	    frame_info[ dt3155_fbuffer[ minor ]->active_buf ].addr
-	    + (DT3155_MAX_ROWS / 2) * stride;
-	  local_save_flags(flags);
-	  local_irq_disable();
-	  wake_up_interruptible( &dt3155_read_wait_queue[ minor ] );
-
-	  /* Set up the DMA address for the next field */
-	  local_irq_restore(flags);
-	  WriteMReg((dt3155_lbase[ minor ] + ODD_DMA_START), buffer_addr);
+	WriteMReg((dt3155_lbase[minor] + INT_CSR), int_csr_r.reg);
+
+	/* Set up next DMA if we are doing FIELDS */
+	if ((dt3155_status[minor].state & DT3155_STATE_MODE) ==
+	     DT3155_STATE_FLD) {
+		/* GCS (Aug 2, 2002) -- In field mode, dma the odd field
+		 * into the lower half of the buffer
+		 */
+		const u32 stride =  dt3155_status[minor].config.cols;
+		buffer_addr = dt3155_fbuffer[minor]->
+		  frame_info[dt3155_fbuffer[minor]->active_buf].addr
+		  + (DT3155_MAX_ROWS / 2) * stride;
+		local_save_flags(flags);
+		local_irq_disable();
+		wake_up_interruptible(&dt3155_read_wait_queue[minor]);
+
+		/* Set up the DMA address for the next field */
+		local_irq_restore(flags);
+		WriteMReg((dt3155_lbase[minor] + ODD_DMA_START), buffer_addr);
 	}
 
-      /* Check for errors. */
-      i2c_even_csr.fld.DONE_EVE = 1;
-      if ( i2c_even_csr.fld.ERROR_EVE )
-	dt3155_errno = DT_ERR_OVERRUN;
-
-      WriteI2C( dt3155_lbase[ minor ], EVEN_CSR, i2c_even_csr.reg );
-
-      /* Note that we actually saw an even field meaning  */
-      /* that subsequent odd field complete the frame     */
-      dt3155_fbuffer[ minor ]->even_happened = 1;
-
-      /* recording the time that the even field finished, this should be */
-      /* about time in the middle of the frame */
-      do_gettimeofday( &(dt3155_fbuffer[ minor ]->
-			 frame_info[ dt3155_fbuffer[ minor ]->
-				     active_buf ].time) );
-      return;
-    }
+	/* Check for errors. */
+	i2c_even_csr.fld.DONE_EVE = 1;
+	if (i2c_even_csr.fld.ERROR_EVE)
+		dt3155_errno = DT_ERR_OVERRUN;
+
+	WriteI2C(dt3155_lbase[minor], EVEN_CSR, i2c_even_csr.reg);
+
+	/* Note that we actually saw an even field meaning
+	 * that subsequent odd field complete the frame
+	 */
+	dt3155_fbuffer[minor]->even_happened = 1;
+
+	/* recording the time that the even field finished, this should be
+	 * about time in the middle of the frame
+	 */
+	do_gettimeofday(&(dt3155_fbuffer[minor]->
+			  frame_info[dt3155_fbuffer[minor]->
+				     active_buf].time));
+	return;
+  }
 
   /* ... now handle the odd field */
-  if ( int_csr_r.fld.FLD_END_ODD )
-    {
-      ReadI2C( dt3155_lbase[ minor ], ODD_CSR, &i2c_odd_csr.reg );
-
-      /* Clear the interrupt? */
-      int_csr_r.fld.FLD_END_ODD = 1;
-
-      if (dt3155_fbuffer[ minor ]->even_happened ||
-	  (dt3155_status[ minor ].state & DT3155_STATE_MODE) ==
-	  DT3155_STATE_FLD)
-	{
-	  dt3155_fbuffer[ minor ]->frame_count++;
-	}
-
-      if ( dt3155_fbuffer[ minor ]->stop_acquire &&
-	   dt3155_fbuffer[ minor ]->even_stopped )
-	{
-	  printk(KERN_DEBUG "dt3155:  stopping odd..\n");
-	  if ( i2c_odd_csr.fld.SNGL_ODD )
-	    {
-	      /* disable interrupts */
-	      int_csr_r.fld.FLD_END_ODD_EN = 0;
-	      dt3155_status[ minor ].state &= ~(DT3155_STATE_STOP|0xff);
-
-	      /* mark the system stopped: */
-	      dt3155_status[ minor ].state |= DT3155_STATE_IDLE;
-	      dt3155_fbuffer[ minor ]->stop_acquire = 0;
-	      dt3155_fbuffer[ minor ]->even_stopped = 0;
-
-	      printk(KERN_DEBUG "dt3155:  state is now %x\n",
-		     dt3155_status[minor].state);
-	    }
-	  else
-	    {
-	      i2c_odd_csr.fld.SNGL_ODD  = 1;
-	    }
+  if (int_csr_r.fld.FLD_END_ODD) {
+	ReadI2C(dt3155_lbase[minor], ODD_CSR, &i2c_odd_csr.reg);
+
+	/* Clear the interrupt? */
+	int_csr_r.fld.FLD_END_ODD = 1;
+
+	if (dt3155_fbuffer[minor]->even_happened ||
+	   (dt3155_status[minor].state & DT3155_STATE_MODE) ==
+	    DT3155_STATE_FLD)
+		dt3155_fbuffer[minor]->frame_count++;
+
+	if (dt3155_fbuffer[minor]->stop_acquire &&
+	    dt3155_fbuffer[minor]->even_stopped) {
+		printk(KERN_DEBUG "dt3155:  stopping odd..\n");
+		if (i2c_odd_csr.fld.SNGL_ODD) {
+			/* disable interrupts */
+			int_csr_r.fld.FLD_END_ODD_EN = 0;
+			dt3155_status[minor].state &= ~(DT3155_STATE_STOP|0xff);
+
+			/* mark the system stopped: */
+			dt3155_status[minor].state |= DT3155_STATE_IDLE;
+			dt3155_fbuffer[minor]->stop_acquire = 0;
+			dt3155_fbuffer[minor]->even_stopped = 0;
+
+			printk(KERN_DEBUG "dt3155:  state is now %x\n",
+			dt3155_status[minor].state);
+		} else {
+			i2c_odd_csr.fld.SNGL_ODD  = 1;
+		}
 	}
 
-      WriteMReg( (dt3155_lbase[ minor ] + INT_CSR), int_csr_r.reg );
+	WriteMReg((dt3155_lbase[minor] + INT_CSR), int_csr_r.reg);
 
-      /* if the odd field has been acquired, then     */
-      /* change the next dma location for both fields */
-      /* and wake up the process if sleeping          */
-      if ( dt3155_fbuffer[ minor ]->even_happened ||
-	   (dt3155_status[ minor ].state & DT3155_STATE_MODE) ==
-	   DT3155_STATE_FLD )
-	{
+	/* if the odd field has been acquired, then
+	 * change the next dma location for both fields
+	 * and wake up the process if sleeping
+	 */
+	if (dt3155_fbuffer[minor]->even_happened ||
+	   (dt3155_status[minor].state & DT3155_STATE_MODE) ==
+	    DT3155_STATE_FLD) {
 
-	  local_save_flags(flags);
-	  local_irq_disable();
+		local_save_flags(flags);
+		local_irq_disable();
 
 #ifdef DEBUG_QUES_B
-	  printques( minor );
+		printques(minor);
 #endif
-	  if ( dt3155_fbuffer[ minor ]->nbuffers > 2 )
-	    {
-	      if ( !are_empty_buffers( minor ) )
-		{
-		  /* The number of active + locked buffers is
-		   * at most 2, and since there are none empty, there
-		   * must be at least nbuffers-2 ready buffers.
-		   * This is where we 'drop frames', oldest first. */
-		  push_empty( pop_ready( minor ),  minor );
-		}
-
-	      /* The ready_que can't be full, since we know
-	       * there is one active buffer right now, so it's safe
-	       * to push the active buf on the ready_que. */
-	      push_ready( minor, dt3155_fbuffer[ minor ]->active_buf );
-	      /* There's at least 1 empty -- make it active */
-	      dt3155_fbuffer[ minor ]->active_buf = pop_empty( minor );
-	      dt3155_fbuffer[ minor ]->
-		frame_info[ dt3155_fbuffer[ minor ]->
-			    active_buf ].tag = ++unique_tag;
-	    }
-	  else /* nbuffers == 2, special case */
-	    { /* There is 1 active buffer.
-	       * If there is a locked buffer, keep the active buffer
-	       * the same -- that means we drop a frame.
-	       */
-	      if ( dt3155_fbuffer[ minor ]->locked_buf < 0 )
-		{
-		  push_ready( minor,
-			      dt3155_fbuffer[ minor ]->active_buf );
-		  if (are_empty_buffers( minor ) )
-		    {
-		      dt3155_fbuffer[ minor ]->active_buf =
-			pop_empty( minor );
-		    }
-		  else
-		    { /* no empty or locked buffers, so use a readybuf */
-		      dt3155_fbuffer[ minor ]->active_buf =
-			pop_ready( minor );
-		    }
+		if (dt3155_fbuffer[minor]->nbuffers > 2) {
+			if (!are_empty_buffers(minor))
+				/* The number of active + locked buffers is
+				 * at most 2, and since there are none empty,
+				 * there must be at least nbuffers-2 ready
+				 * buffers. This is where we 'drop frames',
+				 * oldest first.
+				 */
+				push_empty(pop_ready(minor), minor);
+
+			/* The ready_que can't be full, since we know
+			 * there is one active buffer right now, so it's safe
+			 * to push the active buf on the ready_que.
+			 */
+			push_ready(minor, dt3155_fbuffer[minor]->active_buf);
+			/* There's at least 1 empty -- make it active */
+			dt3155_fbuffer[minor]->active_buf = pop_empty(minor);
+			dt3155_fbuffer[minor]->
+			  frame_info[dt3155_fbuffer[minor]->
+				     active_buf].tag = ++unique_tag;
+		} else {
+			/* nbuffers == 2, special case
+			 * There is 1 active buffer.
+			 * If there is a locked buffer, keep the active buffer
+			 * the same -- that means we drop a frame.
+			 */
+			if (dt3155_fbuffer[minor]->locked_buf < 0) {
+				push_ready(minor,
+					   dt3155_fbuffer[minor]->active_buf);
+			if (are_empty_buffers(minor))
+				dt3155_fbuffer[minor]->active_buf =
+				  pop_empty(minor);
+			else
+				/* no empty or locked buffers, so use a
+				 * readybuf
+				 */
+				dt3155_fbuffer[minor]->active_buf =
+				  pop_ready(minor);
+			}
 		}
-	    }
 
 #ifdef DEBUG_QUES_B
-	  printques( minor );
+		printques(minor);
 #endif
 
-	  dt3155_fbuffer[ minor ]->even_happened = 0;
+		dt3155_fbuffer[minor]->even_happened = 0;
 
-	  wake_up_interruptible( &dt3155_read_wait_queue[ minor ] );
+		wake_up_interruptible(&dt3155_read_wait_queue[minor]);
 
-	  local_irq_restore(flags);
+		local_irq_restore(flags);
 	}
 
-
-      /* Set up the DMA address for the next frame/field */
-      buffer_addr = dt3155_fbuffer[ minor ]->
-	frame_info[ dt3155_fbuffer[ minor ]->active_buf ].addr;
-      if ( (dt3155_status[ minor ].state & DT3155_STATE_MODE) ==
-	   DT3155_STATE_FLD )
-	{
-	  WriteMReg((dt3155_lbase[ minor ] + EVEN_DMA_START), buffer_addr);
+	/* Set up the DMA address for the next frame/field */
+	buffer_addr = dt3155_fbuffer[minor]->
+	  frame_info[dt3155_fbuffer[minor]->active_buf].addr;
+	if ((dt3155_status[minor].state & DT3155_STATE_MODE) ==
+	     DT3155_STATE_FLD) {
+		WriteMReg((dt3155_lbase[minor] + EVEN_DMA_START), buffer_addr);
+	} else {
+		WriteMReg((dt3155_lbase[minor] + EVEN_DMA_START), buffer_addr);
+		WriteMReg((dt3155_lbase[minor] + ODD_DMA_START), buffer_addr
+			  + dt3155_status[minor].config.cols);
 	}
-      else
-	{
-	  WriteMReg((dt3155_lbase[ minor ] + EVEN_DMA_START), buffer_addr);
 
-	  WriteMReg((dt3155_lbase[ minor ] + ODD_DMA_START), buffer_addr
-		    + dt3155_status[ minor ].config.cols);
-	}
+	/* Do error checking */
+	i2c_odd_csr.fld.DONE_ODD = 1;
+	if (i2c_odd_csr.fld.ERROR_ODD)
+		dt3155_errno = DT_ERR_OVERRUN;
 
-      /* Do error checking */
-      i2c_odd_csr.fld.DONE_ODD = 1;
-      if ( i2c_odd_csr.fld.ERROR_ODD )
-	dt3155_errno = DT_ERR_OVERRUN;
+	WriteI2C(dt3155_lbase[minor], ODD_CSR, i2c_odd_csr.reg);
 
-      WriteI2C(dt3155_lbase[ minor ], ODD_CSR, i2c_odd_csr.reg );
-
-      return;
-    }
+	return;
+  }
   /* If we get here, the Odd Field wasn't it either... */
-  printk( "neither even nor odd.  shared perhaps?\n");
+  printk("neither even nor odd.  shared perhaps?\n");
 }
 
-/*****************************************************
+/*
  * init_isr(int minor)
  *   turns on interupt generation for the card
  *   designated by "minor".
  *   It is called *only* from inside ioctl().
- *****************************************************/
+ */
 static void dt3155_init_isr(int minor)
 {
-  const u32 stride =  dt3155_status[ minor ].config.cols;
-
-  switch (dt3155_status[ minor ].state & DT3155_STATE_MODE)
-    {
-    case DT3155_STATE_FLD:
-      {
-	even_dma_start_r  = dt3155_status[ minor ].
-	  fbuffer.frame_info[ dt3155_status[ minor ].fbuffer.active_buf ].addr;
+  const u32 stride =  dt3155_status[minor].config.cols;
+
+  switch (dt3155_status[minor].state & DT3155_STATE_MODE) {
+  case DT3155_STATE_FLD:
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
-      }
 
-    case DT3155_STATE_FRAME:
-    default:
-      {
-	even_dma_start_r  = dt3155_status[ minor ].
-	  fbuffer.frame_info[ dt3155_status[ minor ].fbuffer.active_buf ].addr;
+  case DT3155_STATE_FRAME:
+  default:
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
-      }
-    }
+  }
 
-  /* 50/60 Hz should be set before this point but let's make sure it is */
-  /* right anyway */
+  /* 50/60 Hz should be set before this point but let's make sure it is
+   * right anyway
+   */
 
-  ReadI2C(dt3155_lbase[ minor ], CONFIG, &i2c_csr2.reg);
+  ReadI2C(dt3155_lbase[minor], CONFIG, &i2c_csr2.reg);
   i2c_csr2.fld.HZ50 = FORMAT50HZ;
-  WriteI2C(dt3155_lbase[ minor ], CONFIG, i2c_config.reg);
+  WriteI2C(dt3155_lbase[minor], CONFIG, i2c_config.reg);
 
   /* enable busmaster chip, clear flags */
 
@@ -494,7 +471,7 @@ static void dt3155_init_isr(int minor)
   csr1_r.fld.FLD_CRPT_EVE   = 1; /* writing a 1 clears flags */
   csr1_r.fld.FLD_CRPT_ODD   = 1;
 
-  WriteMReg((dt3155_lbase[ minor ] + CSR1),csr1_r.reg);
+  WriteMReg((dt3155_lbase[minor] + CSR1), csr1_r.reg);
 
   /* Enable interrupts at the end of each field */
 
@@ -503,14 +480,14 @@ static void dt3155_init_isr(int minor)
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
 
@@ -518,10 +495,10 @@ static void dt3155_init_isr(int minor)
 }
 
 
-/*****************************************************
+/*
  * ioctl()
  *
- *****************************************************/
+ */
 static int dt3155_ioctl(struct inode *inode,
 			struct file *file,
 			unsigned int cmd,
@@ -529,33 +506,30 @@ static int dt3155_ioctl(struct inode *inode,
 {
   int minor = MINOR(inode->i_rdev); /* What device are we ioctl()'ing? */
 
-  if ( minor >= MAXBOARDS || minor < 0 )
-    return -ENODEV;
+  if (minor >= MAXBOARDS || minor < 0)
+	return -ENODEV;
 
   /* make sure it is valid command */
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
+  if (_IOC_NR(cmd) > DT3155_IOC_MAXNR) {
+	printk("DT3155: invalid IOCTL(0x%x)\n", cmd);
+	printk("DT3155: Valid commands (0x%x), (0x%x), (0x%x), (0x%x), (0x%x)\n",
+		(unsigned int)DT3155_GET_CONFIG,
+		(unsigned int)DT3155_SET_CONFIG,
+		(unsigned int)DT3155_START,
+		(unsigned int)DT3155_STOP,
+		(unsigned int)DT3155_FLUSH);
+	return -EINVAL;
+  }
+
+  switch (cmd) {
+  case DT3155_SET_CONFIG:
 	if (dt3155_status[minor].state != DT3155_STATE_IDLE)
-	  return -EBUSY;
+		return -EBUSY;
 
 	{
 	  struct dt3155_config_s tmp;
 	  if (copy_from_user((void *)&tmp, (void *) arg, sizeof(tmp)))
-	      return -EFAULT;
+		return -EFAULT;
 	  /* check for valid settings */
 	  if (tmp.rows > DT3155_MAX_ROWS ||
 	      tmp.cols > DT3155_MAX_COLS ||
@@ -563,79 +537,62 @@ static int dt3155_ioctl(struct inode *inode,
 	       tmp.acq_mode != DT3155_MODE_FIELD) ||
 	      (tmp.continuous != DT3155_SNAP &&
 	       tmp.continuous != DT3155_ACQ))
-	    {
-	      return -EINVAL;
-	    }
+		return -EINVAL;
 	  dt3155_status[minor].config = tmp;
 	}
 	return 0;
-      }
-    case DT3155_GET_CONFIG:
-      {
+  case DT3155_GET_CONFIG:
 	if (copy_to_user((void *) arg, (void *) &dt3155_status[minor],
-		     sizeof(dt3155_status_t) ))
-	    return -EFAULT;
+		     sizeof(dt3155_status_t)))
+		return -EFAULT;
 	return 0;
-      }
-    case DT3155_FLUSH: /* Flushes the buffers -- ensures fresh data */
-      {
+  case DT3155_FLUSH: /* Flushes the buffers -- ensures fresh data */
 	if (dt3155_status[minor].state != DT3155_STATE_IDLE)
-	  return -EBUSY;
+		return -EBUSY;
 	return dt3155_flush(minor);
-      }
-    case DT3155_STOP:
-      {
+  case DT3155_STOP:
 	if (dt3155_status[minor].state & DT3155_STATE_STOP ||
 	    dt3155_status[minor].fbuffer.stop_acquire)
-	  return -EBUSY;
+		return -EBUSY;
 
 	if (dt3155_status[minor].state == DT3155_STATE_IDLE)
-	  return 0;
+		return 0;
 
 	quick_stop(minor);
 	if (copy_to_user((void *) arg, (void *) &dt3155_status[minor],
 		     sizeof(dt3155_status_t)))
-	    return -EFAULT;
+		return -EFAULT;
 	return 0;
-      }
-    case DT3155_START:
-      {
+  case DT3155_START:
 	if (dt3155_status[minor].state != DT3155_STATE_IDLE)
-	  return -EBUSY;
+		return -EBUSY;
 
 	dt3155_status[minor].fbuffer.stop_acquire = 0;
 	dt3155_status[minor].fbuffer.frame_count = 0;
 
 	/* Set the MODE in the status -- we default to FRAME */
 	if (dt3155_status[minor].config.acq_mode == DT3155_MODE_FIELD)
-	  {
-	    dt3155_status[minor].state = DT3155_STATE_FLD;
-	  }
+		dt3155_status[minor].state = DT3155_STATE_FLD;
 	else
-	  {
-	    dt3155_status[minor].state = DT3155_STATE_FRAME;
-	  }
+		dt3155_status[minor].state = DT3155_STATE_FRAME;
 
 	dt3155_init_isr(minor);
-	if (copy_to_user( (void *) arg, (void *) &dt3155_status[minor],
+	if (copy_to_user((void *) arg, (void *) &dt3155_status[minor],
 		      sizeof(dt3155_status_t)))
-	    return -EFAULT;
+		return -EFAULT;
 	return 0;
-      }
-    default:
-      {
-	printk("DT3155: invalid IOCTL(0x%x)\n",cmd);
-      printk("DT3155: Valid commands (0x%x), (0x%x), (0x%x), (0x%x), (0x%x)\n",
-	     (unsigned int)DT3155_GET_CONFIG,
-	     (unsigned int)DT3155_SET_CONFIG,
-	     DT3155_START, DT3155_STOP, DT3155_FLUSH);
+  default:
+	printk("DT3155: invalid IOCTL(0x%x)\n", cmd);
+	printk("DT3155: Valid commands (0x%x), (0x%x), (0x%x), (0x%x), (0x%x)\n",
+	       (unsigned int)DT3155_GET_CONFIG,
+	       (unsigned int)DT3155_SET_CONFIG,
+	       DT3155_START, DT3155_STOP, DT3155_FLUSH);
 	return -ENOSYS;
-      }
-    }
+  }
   return -ENOSYS;
 }
 
-/*****************************************************
+/*
  * mmap()
  *
  * only allow the user to mmap the registers and buffer
@@ -643,8 +600,8 @@ static int dt3155_ioctl(struct inode *inode,
  * addition of of the capacity for two cards!!!!!!!!
  * It *looks* like it should work but since I'm not
  * sure how to use it, I'm not actually sure. (NJC? ditto by SS)
- *****************************************************/
-static int dt3155_mmap (struct file * file, struct vm_area_struct * vma)
+ */
+static int dt3155_mmap(struct file *file, struct vm_area_struct *vma)
 {
   /* which device are we mmapping? */
   int				minor = MINOR(file->f_dentry->d_inode->i_rdev);
@@ -652,7 +609,7 @@ static int dt3155_mmap (struct file * file, struct vm_area_struct * vma)
   offset = vma->vm_pgoff << PAGE_SHIFT;
 
   if (offset >= __pa(high_memory) || (file->f_flags & O_SYNC))
-    vma->vm_flags |= VM_IO;
+	vma->vm_flags |= VM_IO;
 
   /* Don't try to swap out physical pages.. */
   vma->vm_flags |= VM_RESERVED;
@@ -661,64 +618,60 @@ static int dt3155_mmap (struct file * file, struct vm_area_struct * vma)
   if ((offset == dt3155_status[minor].reg_addr &&
        vma->vm_end - vma->vm_start == PCI_PAGE_SIZE) ||
       (offset == dt3155_status[minor].mem_addr &&
-       vma->vm_end - vma->vm_start == dt3155_status[minor].mem_size))
-    {
-      if (remap_pfn_range(vma,
-			vma->vm_start,
-			offset >> PAGE_SHIFT,
-			vma->vm_end - vma->vm_start,
-			vma->vm_page_prot)) {
-	  printk("DT3155: remap_page_range() failed.\n");
-	  return -EAGAIN;
+       vma->vm_end - vma->vm_start == dt3155_status[minor].mem_size)) {
+	if (remap_pfn_range(vma,
+			    vma->vm_start,
+			    offset >> PAGE_SHIFT,
+			    vma->vm_end - vma->vm_start,
+			    vma->vm_page_prot)) {
+		printk("DT3155: remap_page_range() failed.\n");
+		return -EAGAIN;
 	}
-    }
-  else
-    {
-      printk("DT3155: dt3155_mmap() bad call.\n");
-      return -ENXIO;
-    }
+  } else {
+	printk("DT3155: dt3155_mmap() bad call.\n");
+	return -ENXIO;
+  }
 
   return 0;
 }
 
 
-/*****************************************************
+/*
  * open()
  *
  * Our special open code.
  * MOD_INC_USE_COUNT make sure that the driver memory is not freed
  * while the device is in use.
- *****************************************************/
-static int dt3155_open( struct inode* inode, struct file* filep)
+ */
+static int dt3155_open(struct inode *inode, struct file *filep)
 {
   int minor = MINOR(inode->i_rdev); /* what device are we opening? */
-  if (dt3155_dev_open[ minor ]) {
-    printk ("DT3155:  Already opened by another process.\n");
-    return -EBUSY;
+  if (dt3155_dev_open[minor]) {
+	printk("DT3155:  Already opened by another process.\n");
+	return -EBUSY;
   }
 
-  if (dt3155_status[ minor ].device_installed==0)
-    {
-      printk("DT3155 Open Error: No such device dt3155 minor number %d\n",
-	     minor);
-      return -EIO;
-    }
-
-  if (dt3155_status[ minor ].state != DT3155_STATE_IDLE) {
-    printk ("DT3155:  Not in idle state (state = %x)\n",
-	    dt3155_status[ minor ].state);
-    return -EBUSY;
+  if (dt3155_status[minor].device_installed == 0) {
+	printk("DT3155 Open Error: No such device dt3155 minor number %d\n",
+		minor);
+	return -EIO;
+  }
+
+  if (dt3155_status[minor].state != DT3155_STATE_IDLE) {
+	printk("DT3155:  Not in idle state (state = %x)\n",
+		dt3155_status[minor].state);
+	return -EBUSY;
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
 
@@ -726,37 +679,32 @@ static int dt3155_open( struct inode* inode, struct file* filep)
 }
 
 
-/*****************************************************
+/*
  * close()
  *
  * Now decrement the use count.
  *
- *****************************************************/
-static int dt3155_close( struct inode *inode, struct file *filep)
+ */
+static int dt3155_close(struct inode *inode, struct file *filep)
 {
   int minor;
 
   minor = MINOR(inode->i_rdev); /* which device are we closing */
-  if (!dt3155_dev_open[ minor ])
-    {
-      printk("DT3155: attempt to CLOSE a not OPEN device\n");
-    }
-  else
-    {
-      dt3155_dev_open[ minor ] = 0;
-
-      if (dt3155_status[ minor ].state != DT3155_STATE_IDLE)
-	{
-	  quick_stop(minor);
-	}
-    }
+  if (!dt3155_dev_open[minor]) {
+	printk("DT3155: attempt to CLOSE a not OPEN device\n");
+  } else {
+	dt3155_dev_open[minor] = 0;
+
+	if (dt3155_status[minor].state != DT3155_STATE_IDLE)
+		quick_stop(minor);
+  }
   return 0;
 }
 
-/*****************************************************
+/*
  * read()
  *
- *****************************************************/
+ */
 static ssize_t dt3155_read(struct file *filep, char __user *buf,
 			   size_t count, loff_t *ppos)
 {
@@ -768,11 +716,10 @@ static ssize_t dt3155_read(struct file *filep, char __user *buf,
 
   /* TODO: this should check the error flag and */
   /*   return an error on hardware failures */
-  if (count != sizeof(dt3155_read_t))
-    {
-      printk("DT3155 ERROR (NJC): count is not right\n");
-      return -EINVAL;
-    }
+  if (count != sizeof(dt3155_read_t)) {
+	printk("DT3155 ERROR (NJC): count is not right\n");
+	return -EINVAL;
+  }
 
 
   /* Hack here -- I'm going to allow reading even when idle.
@@ -780,39 +727,39 @@ static ssize_t dt3155_read(struct file *filep, char __user *buf,
    * been called.  Leaving it here, commented out, as a reminder
    * for a short while to make sure there are no problems.
    * Note that if the driver is not opened in non_blocking mode,
-   * and the device is idle, then it could sit here forever! */
+   * and the device is idle, then it could sit here forever!
+   */
 
-  /*  if (dt3155_status[minor].state == DT3155_STATE_IDLE)*/
-  /*    return -EBUSY;*/
+  /*  if (dt3155_status[minor].state == DT3155_STATE_IDLE)
+   *	return -EBUSY;
+   */
 
   /* non-blocking reads should return if no data */
-  if (filep->f_flags & O_NDELAY)
-    {
-      if ((frame_index = dt3155_get_ready_buffer(minor)) < 0) {
-	/*printk( "dt3155:  no buffers available (?)\n");*/
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
+  if (filep->f_flags & O_NDELAY) {
+	frame_index = dt3155_get_ready_buffer(minor);
+	if (frame_index < 0) {
+		/* printk( "dt3155:  no buffers available (?)\n");
+		 * printques(minor);
+		 */
+		return -EAGAIN;
 	}
-    }
+  } else {
+	/*
+	 * sleep till data arrives , or we get interrupted.
+	 * Note that wait_event_interruptible() does not actually
+	 * sleep/wait if it's condition evaluates to true upon entry.
+	 */
+	wait_event_interruptible(dt3155_read_wait_queue[minor],
+				 (frame_index = dt3155_get_ready_buffer(minor))
+				 >= 0);
+
+	if (frame_index < 0) {
+		printk("DT3155: read: interrupted\n");
+		quick_stop(minor);
+		printques(minor);
+		return -EINTR;
+	}
+  }
 
   frame_info_p = &dt3155_status[minor].fbuffer.frame_info[frame_index];
 
@@ -821,50 +768,50 @@ static ssize_t dt3155_read(struct file *filep, char __user *buf,
 
   put_user(offset, (unsigned int *) buf);
   buf += sizeof(u32);
-  put_user( dt3155_status[minor].fbuffer.frame_count, (unsigned int *) buf);
+  put_user(dt3155_status[minor].fbuffer.frame_count, (unsigned int *) buf);
   buf += sizeof(u32);
   put_user(dt3155_status[minor].state, (unsigned int *) buf);
   buf += sizeof(u32);
   if (copy_to_user(buf, frame_info_p, sizeof(frame_info_t)))
-      return -EFAULT;
+	return -EFAULT;
 
   return sizeof(dt3155_read_t);
 }
 
-static unsigned int dt3155_poll (struct file * filp, poll_table *wait)
+static unsigned int dt3155_poll(struct file *filp, poll_table *wait)
 {
   int minor = MINOR(filp->f_dentry->d_inode->i_rdev);
 
   if (!is_ready_buf_empty(minor))
-    return POLLIN | POLLRDNORM;
+	return POLLIN | POLLRDNORM;
 
-  poll_wait (filp, &dt3155_read_wait_queue[minor], wait);
+  poll_wait(filp, &dt3155_read_wait_queue[minor], wait);
 
   return 0;
 }
 
 
-/*****************************************************
+/*
  * file operations supported by DT3155 driver
  *  needed by init_module
  *  register_chrdev
- *****************************************************/
-static struct file_operations dt3155_fops = {
-  read:		dt3155_read,
-  ioctl:		dt3155_ioctl,
-  mmap:		dt3155_mmap,
-  poll:           dt3155_poll,
-  open:		dt3155_open,
-  release:	dt3155_close
+ */
+static const struct file_operations dt3155_fops = {
+  .read	= dt3155_read,
+  .ioctl = dt3155_ioctl,
+  .mmap = dt3155_mmap,
+  .poll = dt3155_poll,
+  .open = dt3155_open,
+  .release = dt3155_close
 };
 
 
-/*****************************************************
+/*
  * find_PCI();
  *
  * PCI has been totally reworked in 2.1..
- *****************************************************/
-static int find_PCI (void)
+ */
+static int find_PCI(void)
 {
   struct pci_dev *pci_dev = NULL;
   int error, pci_index = 0;
@@ -873,68 +820,70 @@ static int find_PCI (void)
   unsigned char irq;
 
   while ((pci_dev = pci_get_device
-	  (DT3155_VENDORID, DT3155_DEVICEID, pci_dev)) != NULL)
-    {
-      pci_index ++;
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
-      if ((error = pci_read_config_dword( pci_dev, PCI_BASE_ADDRESS_0,
-					  (u32 *) &base)))
-	{
-	  printk("DT3155: Was not able to find device \n");
-	  goto err;
+	  (DT3155_VENDORID, DT3155_DEVICEID, pci_dev)) != NULL) {
+	pci_index++;
+
+	/* Is it really there? */
+	error = pci_read_config_word(pci_dev, PCI_CLASS_DEVICE, &rev_device);
+	if (error)
+		continue;
+
+	/* Found a board */
+	DT_3155_DEBUG_MSG("DT3155: Device number %d\n", pci_index);
+
+	/* Make sure the driver was compiled with enough buffers to handle
+	 * this many boards
+	 */
+	if (pci_index > MAXBOARDS) {
+		printk(KERN_DEBUG
+		  "DT3155: ERROR - found %d devices, but driver only configured"
+		  " for %d devices\n"
+		  "DT3155: Please change MAXBOARDS in dt3155.h\n",
+		  pci_index, MAXBOARDS);
+		goto err;
 	}
 
-      DT_3155_DEBUG_MSG("DT3155: Base address 0 for device is %lx \n", base);
-      dt3155_status[pci_index-1].reg_addr = base;
+	/* Now, just go out and make sure that this/these device(s) is/are
+	 * actually mapped into the kernel address space
+	 */
+	error = pci_read_config_dword(pci_dev, PCI_BASE_ADDRESS_0,
+				      (u32 *) &base);
+	if (error) {
+		printk("DT3155: Was not able to find device\n");
+		goto err;
+	}
 
-      /* Remap the base address to a logical address through which we
-       * can access it. */
-      dt3155_lbase[ pci_index - 1 ] = ioremap(base,PCI_PAGE_SIZE);
-      dt3155_status[ pci_index - 1 ].reg_addr = base;
-      DT_3155_DEBUG_MSG("DT3155: New logical address is %p \n",
-			dt3155_lbase[pci_index-1]);
-      if ( !dt3155_lbase[pci_index-1] )
-	{
-	  printk("DT3155: Unable to remap control registers\n");
-	  goto err;
+	DT_3155_DEBUG_MSG("DT3155: Base address 0 for device is %lx\n", base);
+	dt3155_status[pci_index-1].reg_addr = base;
+
+	/* Remap the base address to a logical address through which we
+	 * can access it.
+	 */
+	dt3155_lbase[pci_index - 1] = ioremap(base, PCI_PAGE_SIZE);
+	dt3155_status[pci_index - 1].reg_addr = base;
+	DT_3155_DEBUG_MSG("DT3155: New logical address is %p\n",
+			   dt3155_lbase[pci_index-1]);
+	if (!dt3155_lbase[pci_index-1]) {
+		printk("DT3155: Unable to remap control registers\n");
+		goto err;
 	}
 
-      if ( (error = pci_read_config_byte( pci_dev, PCI_INTERRUPT_LINE, &irq)) )
-	{
-	  printk("DT3155: Was not able to find device \n");
-	  goto err;
+	error = pci_read_config_byte(pci_dev, PCI_INTERRUPT_LINE, &irq);
+	if (error) {
+		printk("DT3155: Was not able to find device\n");
+		goto err;
 	}
 
-      DT_3155_DEBUG_MSG("DT3155: IRQ is %d \n",irq);
-      dt3155_status[ pci_index-1 ].irq = irq;
-      /* Set flag: kth device found! */
-      dt3155_status[ pci_index-1 ].device_installed = 1;
-      printk("DT3155: Installing device %d w/irq %d and address %p\n",
-	     pci_index,
-	     dt3155_status[pci_index-1].irq,
-	     dt3155_lbase[pci_index-1]);
+	DT_3155_DEBUG_MSG("DT3155: IRQ is %d\n", irq);
+	dt3155_status[pci_index-1].irq = irq;
+	/* Set flag: kth device found! */
+	dt3155_status[pci_index-1].device_installed = 1;
+	printk("DT3155: Installing device %d w/irq %d and address %p\n",
+		pci_index,
+		dt3155_status[pci_index-1].irq,
+		dt3155_lbase[pci_index-1]);
 
-    }
+  }
   ndevices = pci_index;
 
   return DT_3155_SUCCESS;
@@ -946,126 +895,125 @@ err:
 
 u32 allocatorAddr = 0;
 
-/*****************************************************
+/*
  * init_module()
- *****************************************************/
+ */
 int init_module(void)
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
-    {
-      printk( KERN_INFO "DT3155: register_chrdev failed \n");
-      return rcode;
-    }
-
-  if( dt3155_major == 0 )
-    dt3155_major = rcode; /* dynamic */
-
-
-  /* init the status variables.                     */
-  /* DMA memory is taken care of in setup_buffers() */
-  for ( index = 0; index < MAXBOARDS; index++ )
-    {
-      dt3155_status[ index ].config.acq_mode   = DT3155_MODE_FRAME;
-      dt3155_status[ index ].config.continuous = DT3155_ACQ;
-      dt3155_status[ index ].config.cols       = DT3155_MAX_COLS;
-      dt3155_status[ index ].config.rows       = DT3155_MAX_ROWS;
-      dt3155_status[ index ].state = DT3155_STATE_IDLE;
-
-      /* find_PCI() will check if devices are installed; */
-      /* first assume they're not:                       */
-      dt3155_status[ index ].mem_addr          = 0;
-      dt3155_status[ index ].mem_size          = 0;
-      dt3155_status[ index ].state             = DT3155_STATE_IDLE;
-      dt3155_status[ index ].device_installed  = 0;
-    }
+  rcode = register_chrdev(dt3155_major, "dt3155", &dt3155_fops);
+  if (rcode < 0) {
+	printk(KERN_INFO "DT3155: register_chrdev failed\n");
+	return rcode;
+  }
+
+  if (dt3155_major == 0)
+	dt3155_major = rcode; /* dynamic */
+
+
+  /* init the status variables.
+   * DMA memory is taken care of in setup_buffers()
+   */
+  for (index = 0; index < MAXBOARDS; index++) {
+	dt3155_status[index].config.acq_mode   = DT3155_MODE_FRAME;
+	dt3155_status[index].config.continuous = DT3155_ACQ;
+	dt3155_status[index].config.cols       = DT3155_MAX_COLS;
+	dt3155_status[index].config.rows       = DT3155_MAX_ROWS;
+	dt3155_status[index].state = DT3155_STATE_IDLE;
+
+	/* find_PCI() will check if devices are installed;
+	 * first assume they're not:
+	 */
+	dt3155_status[index].mem_addr          = 0;
+	dt3155_status[index].mem_size          = 0;
+	dt3155_status[index].state             = DT3155_STATE_IDLE;
+	dt3155_status[index].device_installed  = 0;
+  }
 
   /* Now let's find the hardware.  find_PCI() will set ndevices to the
-   * number of cards found in this machine. */
-    {
-      if ( (rcode = find_PCI()) !=  DT_3155_SUCCESS )
-	{
-	  printk("DT3155 error: find_PCI() failed to find dt3155 board(s)\n");
-	  unregister_chrdev( dt3155_major, "dt3155" );
-	  return rcode;
-	}
-    }
+   * number of cards found in this machine.
+   */
+      rcode = find_PCI();
+  if (rcode !=  DT_3155_SUCCESS) {
+	printk("DT3155 error: find_PCI() failed to find dt3155 board(s)\n");
+	unregister_chrdev(dt3155_major, "dt3155");
+	return rcode;
+  }
 
   /* Ok, time to setup the frame buffers */
-  if( (rcode = dt3155_setup_buffers(&allocatorAddr)) < 0 )
-    {
-      printk("DT3155: Error: setting up buffer not large enough.");
-      unregister_chrdev( dt3155_major, "dt3155" );
-      return rcode;
-    }
-
-  /* If we are this far, then there is enough RAM */
-  /* for the buffers: Print the configuration.    */
-  for(  index = 0;  index < ndevices;  index++ )
-    {
-      printk("DT3155: Device = %d; acq_mode = %d; "
-	     "continuous = %d; cols = %d; rows = %d;\n",
-	     index ,
-	     dt3155_status[ index ].config.acq_mode,
-	     dt3155_status[ index ].config.continuous,
-	     dt3155_status[ index ].config.cols,
-	     dt3155_status[ index ].config.rows);
-      printk("DT3155: m_addr = 0x%x; m_size = %ld; "
-	     "state = %d; device_installed = %d\n",
-	     dt3155_status[ index ].mem_addr,
-	     (long int)dt3155_status[ index ].mem_size,
-	     dt3155_status[ index ].state,
-	     dt3155_status[ index ].device_installed);
-    }
+  rcode = dt3155_setup_buffers(&allocatorAddr);
+  if (rcode < 0) {
+	printk("DT3155: Error: setting up buffer not large enough.");
+	unregister_chrdev(dt3155_major, "dt3155");
+	return rcode;
+ }
+
+  /* If we are this far, then there is enough RAM
+   * for the buffers: Print the configuration.
+   */
+  for (index = 0; index < ndevices; index++) {
+	printk("DT3155: Device = %d; acq_mode = %d; "
+	       "continuous = %d; cols = %d; rows = %d;\n",
+	       index ,
+	       dt3155_status[index].config.acq_mode,
+	       dt3155_status[index].config.continuous,
+	       dt3155_status[index].config.cols,
+	       dt3155_status[index].config.rows);
+	printk("DT3155: m_addr = 0x%x; m_size = %ld; "
+	       "state = %d; device_installed = %d\n",
+	       dt3155_status[index].mem_addr,
+	       (long int)dt3155_status[index].mem_size,
+	       dt3155_status[index].state,
+	       dt3155_status[index].device_installed);
+  }
 
   /* Disable ALL interrupts */
   int_csr_r.reg = 0;
-  for(  index = 0;  index < ndevices;  index++ )
-    {
-      WriteMReg( (dt3155_lbase[ index ] + INT_CSR), int_csr_r.reg );
-      if( dt3155_status[ index ].device_installed )
-	{
-	  /*
-	   * This driver *looks* like it can handle sharing interrupts,
-	   * but I can't actually test myself. I've had reports that it
-	   * DOES work so I'll enable it for now. This comment will remain
-	   * as a reminder in case any problems arise. (SS)
-	   */
-	  /* in older kernels flags are: SA_SHIRQ | SA_INTERRUPT */
-	  rcode = request_irq( dt3155_status[ index ].irq, (void *)dt3155_isr,
-			       IRQF_SHARED | IRQF_DISABLED, devname[ index ],
-			       (void*) &dt3155_status[index]);
-	  if( rcode < 0 )
-	    {
-	      printk("DT3155: minor %d request_irq failed for IRQ %d\n",
-		     index, dt3155_status[index].irq);
-	      unregister_chrdev( dt3155_major, "dt3155" );
-	      return rcode;
-	    }
+  for (index = 0; index < ndevices; index++) {
+	WriteMReg((dt3155_lbase[index] + INT_CSR), int_csr_r.reg);
+	if (dt3155_status[index].device_installed) {
+		/*
+		 * This driver *looks* like it can handle sharing interrupts,
+		 * but I can't actually test myself. I've had reports that it
+		 * DOES work so I'll enable it for now. This comment will remain
+		 * as a reminder in case any problems arise. (SS)
+		 *
+		 * in older kernels flags are: SA_SHIRQ | SA_INTERRUPT
+		 */
+		rcode = request_irq(dt3155_status[index].irq,
+				    (void *)dt3155_isr,
+				    IRQF_SHARED | IRQF_DISABLED, devname[index],
+				    (void *) &dt3155_status[index]);
+		if (rcode < 0) {
+			printk(
+			    "DT3155: minor %d request_irq failed for IRQ %d\n",
+			    index, dt3155_status[index].irq);
+			unregister_chrdev(dt3155_major, "dt3155");
+			return rcode;
+		}
 	}
-    }
+  }
 
   printk("DT3155: finished loading\n");
 
   return 0;
 }
 
-/*****************************************************
+/*
  * cleanup_module(void)
  *
- *****************************************************/
+ */
 void cleanup_module(void)
 {
   int index;
@@ -1075,21 +1023,19 @@ void cleanup_module(void)
   /* removed DMA allocated with the allocator */
 #ifdef STANDALONE_ALLOCATOR
   if (allocatorAddr != 0)
-    allocator_free_dma(allocatorAddr);
+	allocator_free_dma(allocatorAddr);
 #else
   allocator_cleanup();
 #endif
 
-  unregister_chrdev( dt3155_major, "dt3155" );
+  unregister_chrdev(dt3155_major, "dt3155");
 
-  for( index = 0; index < ndevices; index++ )
-    {
-      if( dt3155_status[ index ].device_installed == 1 )
-	{
-	  printk( "DT3155: Freeing irq %d for device %d\n",
-		  dt3155_status[ index ].irq, index );
-	  free_irq( dt3155_status[ index ].irq, (void*)&dt3155_status[index] );
+  for (index = 0; index < ndevices; index++) {
+	if (dt3155_status[index].device_installed == 1) {
+		printk("DT3155: Freeing irq %d for device %d\n",
+			dt3155_status[index].irq, index);
+		free_irq(dt3155_status[index].irq,
+			 (void *)&dt3155_status[index]);
 	}
-    }
+  }
 }
-
-- 
1.7.0



