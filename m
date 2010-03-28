Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab0C1Tn7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 15:43:59 -0400
Received: from smtp1.rdslink.ro ([81.196.12.70]:37912 "EHLO smtp.rdslink.ro"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755104Ab0C1Tn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 15:43:57 -0400
X-Mail-Scanner: Scanned by qSheff-II-2.1-r3 (http://www.enderunix.org/qsheff/)
Subject: Staging: dt3155: fixed some checkpatch.pl warnings and errors in
 dt3155_isr.c
From: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>
To: gregkh@suse.de, hsweeten@visionengravers.com, horms@verge.net.au,
       ss@aao.gov.au
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Sun, 28 Mar 2010 22:43:45 +0300
Message-ID: <1269805425.7079.16.camel@tuxtm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 72b1cd159a8eb704e85945c907d71f0a8c024b3f Mon Sep 17 00:00:00 2001
From: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>
Date: Sun, 28 Mar 2010 22:33:51 +0300
Subject: [PATCH 8/8] Staging: dt3155: fixed some checkpatch.pl warnings and errors in dt3155_isr.c
 This is a patch to the dt3155_isr.c file that fixes up errors and warnings found by the checkpatch.pl tool
 Signed-off-by: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>

---
 drivers/staging/dt3155/dt3155_isr.c |  453 +++++++++++++++++------------------
 1 files changed, 225 insertions(+), 228 deletions(-)

diff --git a/drivers/staging/dt3155/dt3155_isr.c b/drivers/staging/dt3155/dt3155_isr.c
index fd7f93d..8a25876 100644
--- a/drivers/staging/dt3155/dt3155_isr.c
+++ b/drivers/staging/dt3155/dt3155_isr.c
@@ -1,48 +1,47 @@
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
-   File: dt3155_isr.c
-Purpose: Buffer management routines, and other routines for the ISR
-         (the actual isr is in dt3155_drv.c)
-
--- Changes --
-
-  Date       Programmer  Description of changes made
-  -------------------------------------------------------------------
-  03-Jul-2000 JML       n/a
-  02-Apr-2002 SS        Mods to make work with separate allocator
-                        module; Merged John Roll's mods to make work with
-                        multiple boards.
-  10-Jul-2002 GCS       Complete rewrite of setup_buffers to disallow
-                        buffers which span a 4MB boundary.
-  24-Jul-2002 SS        GPL licence.
-  30-Jul-2002 NJC       Added support for buffer loop.
-  31-Jul-2002 NJC       Complete rewrite of buffer management
-  02-Aug-2002 NJC       Including slab.h instead of malloc.h (no warning).
-                        Also, allocator_init() now returns allocator_max
-                        so cleaned up allocate_buffers() accordingly.
-  08-Aug-2005 SS        port to 2.6 kernel.
-
-*/
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
+ *    File: dt3155_isr.c
+ * Purpose: Buffer management routines, and other routines for the ISR
+ *          (the actual isr is in dt3155_drv.c)
+ *
+ * -- Changes --
+ *
+ * Date       Programmer  Description of changes made
+ * -------------------------------------------------------------------
+ * 03-Jul-2000 JML       n/a
+ * 02-Apr-2002 SS        Mods to make work with separate allocator
+ *                       module; Merged John Roll's mods to make work with
+ *                       multiple boards.
+ * 10-Jul-2002 GCS       Complete rewrite of setup_buffers to disallow
+ *                       buffers which span a 4MB boundary.
+ * 24-Jul-2002 SS        GPL licence.
+ * 30-Jul-2002 NJC       Added support for buffer loop.
+ * 31-Jul-2002 NJC       Complete rewrite of buffer management
+ * 02-Aug-2002 NJC       Including slab.h instead of malloc.h (no warning).
+ *                       Also, allocator_init() now returns allocator_max
+ *                       so cleaned up allocate_buffers() accordingly.
+ * 08-Aug-2005 SS        port to 2.6 kernel.
+ */
 
 #include <asm/system.h>
 #include <linux/slab.h>
@@ -66,23 +65,23 @@ struct dt3155_fbuffer_s *dt3155_fbuffer[MAXBOARDS] = {NULL
 #endif
 };
 
-/******************************************************************************
+/*
  * Simple array based que struct
  *
  * Some handy functions using the buffering structure.
- *****************************************************************************/
+ */
 
 
-/***************************
+/*
  * are_empty_buffers
  * m is minor # of device
- ***************************/
-inline bool are_empty_buffers( int m )
+ */
+inline bool are_empty_buffers(int m)
 {
-  return ( dt3155_fbuffer[ m ]->empty_len );
+  return dt3155_fbuffer[m]->empty_len;
 }
 
-/**************************
+/*
  * push_empty
  * m is minor # of device
  *
@@ -91,156 +90,156 @@ inline bool are_empty_buffers( int m )
  * empty buffer stack.  So, if empty_len == 1, there is one empty buffer,
  * given by dt3155_fbuffer[m]->empty_buffers[0].
  * empty_buffers should never fill up, though this is not checked.
- **************************/
-inline void push_empty( int index, int m )
+ */
+inline void push_empty(int index, int m)
 {
-  dt3155_fbuffer[m]->empty_buffers[ dt3155_fbuffer[m]->empty_len ] = index;
+  dt3155_fbuffer[m]->empty_buffers[dt3155_fbuffer[m]->empty_len] = index;
   dt3155_fbuffer[m]->empty_len++;
 }
 
-/**************************
+/*
  * pop_empty( m )
  * m is minor # of device
- **************************/
-inline int pop_empty( int m )
+ */
+inline int pop_empty(int m)
 {
   dt3155_fbuffer[m]->empty_len--;
-  return dt3155_fbuffer[m]->empty_buffers[ dt3155_fbuffer[m]->empty_len ];
+  return dt3155_fbuffer[m]->empty_buffers[dt3155_fbuffer[m]->empty_len];
 }
 
-/*************************
+/*
  * is_ready_buf_empty( m )
  * m is minor # of device
- *************************/
-inline bool is_ready_buf_empty( int m )
+ */
+inline bool is_ready_buf_empty(int m)
 {
-  return ((dt3155_fbuffer[ m ]->ready_len) == 0);
+  return (dt3155_fbuffer[m]->ready_len) == 0;
 }
 
-/*************************
+/*
  * is_ready_buf_full( m )
  * m is minor # of device
  * this should *never* be true if there are any active, locked or empty
  * buffers, since it corresponds to nbuffers ready buffers!!
  * 7/31/02: total rewrite. --NJC
- *************************/
-inline bool is_ready_buf_full( int m )
+ */
+inline bool is_ready_buf_full(int m)
 {
-  return ( dt3155_fbuffer[ m ]->ready_len == dt3155_fbuffer[ m ]->nbuffers );
+  return dt3155_fbuffer[m]->ready_len == dt3155_fbuffer[m]->nbuffers;
 }
 
-/*****************************************************
+/*
  * push_ready( m, buffer )
  * m is minor # of device
  *
- *****************************************************/
-inline void push_ready( int m, int index )
+ */
+inline void push_ready(int m, int index)
 {
   int head = dt3155_fbuffer[m]->ready_head;
 
-  dt3155_fbuffer[ m ]->ready_que[ head ] = index;
-  dt3155_fbuffer[ m ]->ready_head = ( (head + 1) %
-				      (dt3155_fbuffer[ m ]->nbuffers) );
-  dt3155_fbuffer[ m ]->ready_len++;
+  dt3155_fbuffer[m]->ready_que[head] = index;
+  dt3155_fbuffer[m]->ready_head = ((head + 1) %
+				   (dt3155_fbuffer[m]->nbuffers));
+  dt3155_fbuffer[m]->ready_len++;
 
 }
 
-/*****************************************************
+/*
  * get_tail()
  * m is minor # of device
  *
  * Simply comptutes the tail given the head and the length.
- *****************************************************/
-static inline int get_tail( int m )
+ */
+static inline int get_tail(int m)
 {
-  return ((dt3155_fbuffer[ m ]->ready_head -
-	   dt3155_fbuffer[ m ]->ready_len +
-	   dt3155_fbuffer[ m ]->nbuffers)%
-	  (dt3155_fbuffer[ m ]->nbuffers));
+  return (dt3155_fbuffer[m]->ready_head -
+	   dt3155_fbuffer[m]->ready_len +
+	   dt3155_fbuffer[m]->nbuffers)%
+	  (dt3155_fbuffer[m]->nbuffers);
 }
 
 
 
-/*****************************************************
+/**
  * pop_ready()
  * m is minor # of device
  *
  * This assumes that there is a ready buffer ready... should
  * be checked (e.g. with is_ready_buf_empty()  prior to call.
- *****************************************************/
-inline int pop_ready( int m )
+ */
+inline int pop_ready(int m)
 {
   int tail;
   tail = get_tail(m);
-  dt3155_fbuffer[ m ]->ready_len--;
-  return dt3155_fbuffer[ m ]->ready_que[ tail ];
+  dt3155_fbuffer[m]->ready_len--;
+  return dt3155_fbuffer[m]->ready_que[tail];
 }
 
 
-/*****************************************************
+/*
  * printques
  * m is minor # of device
- *****************************************************/
-inline void printques( int m )
+ */
+inline void printques(int m)
 {
-  int head = dt3155_fbuffer[ m ]->ready_head;
+  int head = dt3155_fbuffer[m]->ready_head;
   int tail;
-  int num = dt3155_fbuffer[ m ]->nbuffers;
+  int num = dt3155_fbuffer[m]->nbuffers;
   int frame_index;
   int index;
 
   tail = get_tail(m);
 
   printk("\n R:");
-  for ( index = tail; index != head; index++, index = index % (num) )
-    {
-      frame_index = dt3155_fbuffer[ m ]->ready_que[ index ];
-      printk(" %d ", frame_index );
-    }
+  for (index = tail; index != head; index++, index = index % (num)) {
+	frame_index = dt3155_fbuffer[m]->ready_que[index];
+	printk(" %d ", frame_index);
+  }
 
   printk("\n E:");
-  for ( index = 0; index < dt3155_fbuffer[ m ]->empty_len; index++ )
-    {
-      frame_index = dt3155_fbuffer[ m ]->empty_buffers[ index ];
-      printk(" %d ", frame_index );
-    }
+  for (index = 0; index < dt3155_fbuffer[m]->empty_len; index++) {
+	frame_index = dt3155_fbuffer[m]->empty_buffers[index];
+	printk(" %d ", frame_index);
+  }
 
-  frame_index = dt3155_fbuffer[ m ]->active_buf;
+  frame_index = dt3155_fbuffer[m]->active_buf;
   printk("\n A: %d", frame_index);
 
-  frame_index = dt3155_fbuffer[ m ]->locked_buf;
-  printk("\n L: %d \n", frame_index );
+  frame_index = dt3155_fbuffer[m]->locked_buf;
+  printk("\n L: %d\n", frame_index);
 
 }
 
-/*****************************************************
+/*
  * adjust_4MB
  *
  *  If a buffer intersects the 4MB boundary, push
  *  the start address up to the beginning of the
  *  next 4MB chunk (assuming bufsize < 4MB).
- *****************************************************/
-u32 adjust_4MB (u32 buf_addr, u32 bufsize) {
+ */
+u32 adjust_4MB(u32 buf_addr, u32 bufsize)
+{
   if (((buf_addr+bufsize) & UPPER_10_BITS) != (buf_addr & UPPER_10_BITS))
-    return (buf_addr+bufsize) & UPPER_10_BITS;
+	return (buf_addr+bufsize) & UPPER_10_BITS;
   else
-    return buf_addr;
+	return buf_addr;
 }
 
 
-/*****************************************************
+/*
  * allocate_buffers
  *
  *  Try to allocate enough memory for all requested
  *  buffers.  If there is not enough free space
  *  try for less memory.
- *****************************************************/
-void allocate_buffers (u32 *buf_addr, u32* total_size_kbs,
+ */
+void allocate_buffers(u32 *buf_addr, u32 *total_size_kbs,
 		       u32 bufsize)
 {
   /* Compute the minimum amount of memory guaranteed to hold all
-     MAXBUFFERS such that no buffer crosses the 4MB boundary.
-     Store this value in the variable "full_size" */
+   * MAXBUFFERS such that no buffer crosses the 4MB boundary.
+   * Store this value in the variable "full_size"
+   */
 
   u32 allocator_max;
   u32 bufs_per_chunk = (FOUR_MB / bufsize);
@@ -269,14 +268,15 @@ void allocate_buffers (u32 *buf_addr, u32* total_size_kbs,
   printk("DT3155: ...the allocator has: %d KB\n", allocator_max);
   size_kbs = (full_size_kbs <= allocator_max ? full_size_kbs : allocator_max);
   if (size_kbs > min_size_kbs) {
-    if ((*buf_addr = allocator_allocate_dma (size_kbs, GFP_KERNEL)) != 0) {
-      printk("DT3155:  Managed to allocate: %d KB\n", size_kbs);
-      *total_size_kbs = size_kbs;
-      return;
-    }
+	*buf_addr = allocator_allocate_dma(size_kbs, GFP_KERNEL);
+	if (*buf_addr != 0) {
+		printk("DT3155:  Managed to allocate: %d KB\n", size_kbs);
+		*total_size_kbs = size_kbs;
+		return;
+	}
   }
   /* If we got here, the allocation failed */
-  printk ("DT3155: Allocator failed!\n");
+  printk("DT3155: Allocator failed!\n");
   *buf_addr = 0;
   *total_size_kbs = 0;
   return;
@@ -284,7 +284,7 @@ void allocate_buffers (u32 *buf_addr, u32* total_size_kbs,
 }
 
 
-/*****************************************************
+/*
  * dt3155_setup_buffers
  *
  *  setup_buffers just puts the buffering system into
@@ -297,9 +297,8 @@ void allocate_buffers (u32 *buf_addr, u32* total_size_kbs,
  * GCS : Fix DMA problems when buffer spans
  * 4MB boundary.  Also, add error checking.  This
  * function will return -ENOMEM when not enough memory.
- *****************************************************/
+ */
 u32 dt3155_setup_buffers(u32 *allocatorAddr)
-
 {
   u32 index;
   u32 rambuff_addr; /* start of allocation */
@@ -312,128 +311,127 @@ u32 dt3155_setup_buffers(u32 *allocatorAddr)
   int m;               /* minor # of device, looped for all devs */
 
   /* zero the fbuffer status and address structure */
-  for ( m = 0; m < ndevices; m++)
-    {
-      dt3155_fbuffer[ m ] = &(dt3155_status[ m ].fbuffer);
-
-      /* Make sure the buffering variables are consistent */
-      {
-	u8 *ptr = (u8 *) dt3155_fbuffer[ m ];
-	for( index = 0; index < sizeof(struct dt3155_fbuffer_s); index++)
-	  *(ptr++)=0;
-      }
-    }
+  for (m = 0; m < ndevices; m++) {
+	dt3155_fbuffer[m] = &(dt3155_status[m].fbuffer);
+
+	/* Make sure the buffering variables are consistent */
+	{
+	  u8 *ptr = (u8 *) dt3155_fbuffer[m];
+	  for (index = 0; index < sizeof(struct dt3155_fbuffer_s); index++)
+		*(ptr++) = 0;
+	}
+  }
 
   /* allocate a large contiguous chunk of RAM */
-  allocate_buffers (&rambuff_addr, &rambuff_size, bufsize);
+  allocate_buffers(&rambuff_addr, &rambuff_size, bufsize);
   printk("DT3155: mem info\n");
-  printk("  - rambuf_addr = 0x%x \n", rambuff_addr);
-  printk("  - length (kb) = %u \n", rambuff_size);
-  if( rambuff_addr == 0 )
-    {
-      printk( KERN_INFO
-	      "DT3155: Error setup_buffers() allocator dma failed \n" );
-      return -ENOMEM;
-    }
+  printk("  - rambuf_addr = 0x%x\n", rambuff_addr);
+  printk("  - length (kb) = %u\n", rambuff_size);
+  if (rambuff_addr == 0) {
+	printk(KERN_INFO
+	      "DT3155: Error setup_buffers() allocator dma failed\n");
+	return -ENOMEM;
+  }
   *allocatorAddr = rambuff_addr;
   rambuff_end = rambuff_addr + 1024 * rambuff_size;
 
   /* after allocation, we need to count how many useful buffers there
-     are so we can give an equal number to each device */
+   * are so we can give an equal number to each device
+   */
   rambuff_acm = rambuff_addr;
-  for ( index = 0; index < MAXBUFFERS; index++) {
-    rambuff_acm = adjust_4MB (rambuff_acm, bufsize);/*avoid spanning 4MB bdry*/
-    if (rambuff_acm + bufsize > rambuff_end)
-      break;
-    rambuff_acm += bufsize;
+  for (index = 0; index < MAXBUFFERS; index++) {
+	/*avoid spanning 4MB bdry*/
+	rambuff_acm = adjust_4MB(rambuff_acm, bufsize);
+	if (rambuff_acm + bufsize > rambuff_end)
+		break;
+	rambuff_acm += bufsize;
   }
   /* Following line is OK, will waste buffers if index
-   * not evenly divisible by ndevices -NJC*/
+   * not evenly divisible by ndevices -NJC
+   */
   numbufs = index / ndevices;
   printk("  - numbufs = %u\n", numbufs);
   if (numbufs < 2) {
-    printk( KERN_INFO
-	    "DT3155: Error setup_buffers() couldn't allocate 2 bufs/board\n" );
-    return -ENOMEM;
+	printk(KERN_INFO
+	    "DT3155: Error setup_buffers() couldn't allocate 2 bufs/board\n");
+	return -ENOMEM;
   }
 
-  /* now that we have board memory we spit it up */
-  /* between the boards and the buffers          */
+  /* now that we have board memory we spit it up
+   * between the boards and the buffers
+   */
   rambuff_acm = rambuff_addr;
-  for ( m = 0; m < ndevices; m ++)
-    {
-      rambuff_acm = adjust_4MB (rambuff_acm, bufsize);
-
-      /* Save the start of this boards buffer space (for mmap).  */
-      dt3155_status[ m ].mem_addr = rambuff_acm;
-
-      for (index = 0; index < numbufs; index++)
-	{
-	  rambuff_acm = adjust_4MB (rambuff_acm, bufsize);
-	  if (rambuff_acm + bufsize > rambuff_end) {
-	    /* Should never happen */
-	    printk ("DT3155 PROGRAM ERROR (GCS)\n"
-		    "Error distributing allocated buffers\n");
-	    return -ENOMEM;
-	  }
-
-	  dt3155_fbuffer[ m ]->frame_info[ index ].addr = rambuff_acm;
-	  push_empty( index, m );
-	  /* printk("  - Buffer : %lx\n",
-	   * dt3155_fbuffer[ m ]->frame_info[ index ].addr );
-	   */
-	  dt3155_fbuffer[ m ]->nbuffers += 1;
-	  rambuff_acm += bufsize;
+  for (m = 0; m < ndevices; m++) {
+	rambuff_acm = adjust_4MB(rambuff_acm, bufsize);
+
+	/* Save the start of this boards buffer space (for mmap).  */
+	dt3155_status[m].mem_addr = rambuff_acm;
+
+	for (index = 0; index < numbufs; index++) {
+		rambuff_acm = adjust_4MB(rambuff_acm, bufsize);
+		if (rambuff_acm + bufsize > rambuff_end) {
+			/* Should never happen */
+			printk("DT3155 PROGRAM ERROR (GCS)\n"
+				"Error distributing allocated buffers\n");
+			return -ENOMEM;
+		}
+
+		dt3155_fbuffer[m]->frame_info[index].addr = rambuff_acm;
+		push_empty(index, m);
+		/* printk("  - Buffer : %lx\n",
+		 * dt3155_fbuffer[ m ]->frame_info[ index ].addr );
+		 */
+		dt3155_fbuffer[m]->nbuffers += 1;
+		rambuff_acm += bufsize;
 	}
 
-      /* Make sure there is an active buffer there. */
-      dt3155_fbuffer[ m ]->active_buf    = pop_empty( m );
-      dt3155_fbuffer[ m ]->even_happened = 0;
-      dt3155_fbuffer[ m ]->even_stopped  = 0;
+	/* Make sure there is an active buffer there. */
+	dt3155_fbuffer[m]->active_buf = pop_empty(m);
+	dt3155_fbuffer[m]->even_happened = 0;
+	dt3155_fbuffer[m]->even_stopped  = 0;
 
-      /* make sure there is no locked_buf JML 2/28/00 */
-      dt3155_fbuffer[ m ]->locked_buf = -1;
+	/* make sure there is no locked_buf JML 2/28/00 */
+	dt3155_fbuffer[m]->locked_buf = -1;
 
-      dt3155_status[ m ].mem_size =
-	rambuff_acm - dt3155_status[ m ].mem_addr;
+	dt3155_status[m].mem_size =
+	rambuff_acm - dt3155_status[m].mem_addr;
 
-      /* setup the ready queue */
-      dt3155_fbuffer[ m ]->ready_head = 0;
-      dt3155_fbuffer[ m ]->ready_len = 0;
-      printk("Available buffers for device %d: %d\n",
-	     m, dt3155_fbuffer[ m ]->nbuffers);
-    }
+	/* setup the ready queue */
+	dt3155_fbuffer[m]->ready_head = 0;
+	dt3155_fbuffer[m]->ready_len = 0;
+	printk("Available buffers for device %d: %d\n",
+		m, dt3155_fbuffer[m]->nbuffers);
+  }
 
   return 1;
 }
 
-/*****************************************************
+/*
  * internal_release_locked_buffer
  *
  * The internal function for releasing a locked buffer.
  * It assumes interrupts are turned off.
  *
  * m is minor number of device
- *****************************************************/
-static inline void internal_release_locked_buffer( int m )
+ */
+static inline void internal_release_locked_buffer(int m)
 {
   /* Pointer into global structure for handling buffers */
-  if ( dt3155_fbuffer[ m ]->locked_buf >= 0 )
-    {
-      push_empty( dt3155_fbuffer[ m ]->locked_buf, m );
-      dt3155_fbuffer[ m ]->locked_buf = -1;
-    }
+  if (dt3155_fbuffer[m]->locked_buf >= 0) {
+	push_empty(dt3155_fbuffer[m]->locked_buf, m);
+	dt3155_fbuffer[m]->locked_buf = -1;
+  }
 }
 
 
-/*****************************************************
+/*
  * dt3155_release_locked_buffer()
  * m is minor # of device
  *
  * The user function of the above.
  *
- *****************************************************/
-inline void dt3155_release_locked_buffer( int m )
+ */
+inline void dt3155_release_locked_buffer(int m)
 {
 	unsigned long int flags;
 	local_save_flags(flags);
@@ -443,40 +441,40 @@ inline void dt3155_release_locked_buffer( int m )
 }
 
 
-/*****************************************************
+/*
  * dt3155_flush()
  * m is minor # of device
  *
- *****************************************************/
-inline int dt3155_flush( int m )
+ */
+inline int dt3155_flush(int m)
 {
   int index;
   unsigned long int flags;
   local_save_flags(flags);
   local_irq_disable();
 
-  internal_release_locked_buffer( m );
-  dt3155_fbuffer[ m ]->empty_len = 0;
+  internal_release_locked_buffer(m);
+  dt3155_fbuffer[m]->empty_len = 0;
 
-  for ( index = 0; index < dt3155_fbuffer[ m ]->nbuffers; index++ )
-    push_empty( index,  m );
+  for (index = 0; index < dt3155_fbuffer[m]->nbuffers; index++)
+	push_empty(index, m);
 
   /* Make sure there is an active buffer there. */
-  dt3155_fbuffer[ m ]->active_buf = pop_empty( m );
+  dt3155_fbuffer[m]->active_buf = pop_empty(m);
 
-  dt3155_fbuffer[ m ]->even_happened = 0;
-  dt3155_fbuffer[ m ]->even_stopped  = 0;
+  dt3155_fbuffer[m]->even_happened = 0;
+  dt3155_fbuffer[m]->even_stopped  = 0;
 
   /* setup the ready queue  */
-  dt3155_fbuffer[ m ]->ready_head = 0;
-  dt3155_fbuffer[ m ]->ready_len = 0;
+  dt3155_fbuffer[m]->ready_head = 0;
+  dt3155_fbuffer[m]->ready_len = 0;
 
   local_irq_restore(flags);
 
   return 0;
 }
 
-/*****************************************************
+/*
  * dt3155_get_ready_buffer()
  * m is minor # of device
  *
@@ -484,8 +482,8 @@ inline int dt3155_flush( int m )
  * if it is already there, otherwise it returns 0.
  * If the user has a buffer locked it will unlock
  * that buffer before returning the new one.
- *****************************************************/
-inline int dt3155_get_ready_buffer( int m )
+ */
+inline int dt3155_get_ready_buffer(int m)
 {
   int frame_index;
   unsigned long int flags;
@@ -493,21 +491,20 @@ inline int dt3155_get_ready_buffer( int m )
   local_irq_disable();
 
 #ifdef DEBUG_QUES_A
-  printques( m );
+  printques(m);
 #endif
 
-  internal_release_locked_buffer( m );
+  internal_release_locked_buffer(m);
 
-  if (is_ready_buf_empty( m ))
-    frame_index = -1;
-  else
-    {
-      frame_index = pop_ready( m );
-      dt3155_fbuffer[ m ]->locked_buf = frame_index;
-    }
+  if (is_ready_buf_empty(m)) {
+	frame_index = -1;
+  } else {
+	frame_index = pop_ready(m);
+	dt3155_fbuffer[m]->locked_buf = frame_index;
+  }
 
 #ifdef DEBUG_QUES_B
-  printques( m );
+  printques(m);
 #endif
 
   local_irq_restore(flags);
-- 
1.7.0



