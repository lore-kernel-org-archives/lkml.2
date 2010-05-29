Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab0E2NR0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 09:17:26 -0400
Received: from mail.eleftheriou.eu ([86.35.2.10]:37409 "EHLO
	enigma.wired-net.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab0E2NRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 09:17:24 -0400
Date: Sat, 29 May 2010 16:16:26 +0300
From: Nanakos Chrysostomos <nanakos@wired-net.gr>
To: gregkh@suse.de
Cc: horms@verge.net.au, hsweeten@visionengravers.com, ss@aao.gov.au,
       tj@kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: dt3155: dt3155_isr.c: Fix checkpatch.pl issues.
Message-ID: <20100529131448.GA5036@limpeloula>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix resolves checkpatch.pl issues for dt3155_isr.c file.

Signed-off-by: Nanakos Chrysostomos <nanakos@wired-net.gr>
---
 drivers/staging/dt3155/dt3155_isr.c |   47 +++++++++++++++++++---------------
 1 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/dt3155/dt3155_isr.c b/drivers/staging/dt3155/dt3155_isr.c
index 33ddc9c..59b7bfd 100644
--- a/drivers/staging/dt3155/dt3155_isr.c
+++ b/drivers/staging/dt3155/dt3155_isr.c
@@ -153,10 +153,12 @@ void push_ready(int m, int index)
  *****************************************************/
 static int get_tail(int m)
 {
-  return (dt3155_fbuffer[m]->ready_head -
-	   dt3155_fbuffer[m]->ready_len +
-	   dt3155_fbuffer[m]->nbuffers)%
-	  (dt3155_fbuffer[m]->nbuffers);
+	int ncount;
+	ncount = (dt3155_fbuffer[m]->ready_head -
+			dt3155_fbuffer[m]->ready_len +
+			dt3155_fbuffer[m]->nbuffers)%
+		(dt3155_fbuffer[m]->nbuffers);
+	return ncount;
 }
 
 
@@ -191,23 +193,23 @@ void printques(int m)
 
   tail = get_tail(m);
 
-  printk("\n R:");
+  printk(KERN_INFO "\n R:");
     for (index = tail; index != head; index++, index = index % (num)) {
 	frame_index = dt3155_fbuffer[m]->ready_que[index];
 	printk(" %d ", frame_index);
     }
 
-  printk("\n E:");
+  printk(KERN_INFO "\n E:");
     for (index = 0; index < dt3155_fbuffer[m]->empty_len; index++) {
 	frame_index = dt3155_fbuffer[m]->empty_buffers[index];
 	printk(" %d ", frame_index);
     }
 
   frame_index = dt3155_fbuffer[m]->active_buf;
-  printk("\n A: %d", frame_index);
+  printk(KERN_INFO "\n A: %d", frame_index);
 
   frame_index = dt3155_fbuffer[m]->locked_buf;
-  printk("\n L: %d\n", frame_index);
+  printk(KERN_INFO "\n L: %d\n", frame_index);
 
 }
 
@@ -263,19 +265,21 @@ void allocate_buffers(u32 *buf_addr, u32* total_size_kbs,
 #endif
   size_kbs = full_size_kbs;
   *buf_addr = 0;
-  printk("DT3155: We would like to get: %d KB\n", full_size_kbs);
-  printk("DT3155: ...but need at least: %d KB\n", min_size_kbs);
-  printk("DT3155: ...the allocator has: %d KB\n", allocator_max);
+  printk(KERN_INFO "DT3155: We would like to get: %d KB\n", full_size_kbs);
+  printk(KERN_INFO "DT3155: ...but need at least: %d KB\n", min_size_kbs);
+  printk(KERN_INFO "DT3155: ...the allocator has: %d KB\n", allocator_max);
   size_kbs = (full_size_kbs <= allocator_max ? full_size_kbs : allocator_max);
     if (size_kbs > min_size_kbs) {
-	if ((*buf_addr = allocator_allocate_dma(size_kbs, GFP_KERNEL)) != 0) {
-		printk("DT3155:  Managed to allocate: %d KB\n", size_kbs);
+		*buf_addr = allocator_allocate_dma(size_kbs, GFP_KERNEL);
+	if (*buf_addr != 0) {
+		printk(KERN_INFO "DT3155:  Managed to allocate: %d KB\n",
+				size_kbs);
 		*total_size_kbs = size_kbs;
 		return;
 	}
     }
   /* If we got here, the allocation failed */
-  printk("DT3155: Allocator failed!\n");
+  printk(KERN_INFO "DT3155: Allocator failed!\n");
   *buf_addr = 0;
   *total_size_kbs = 0;
   return;
@@ -324,9 +328,9 @@ u32 dt3155_setup_buffers(u32 *allocatorAddr)
 
   /* allocate a large contiguous chunk of RAM */
   allocate_buffers(&rambuff_addr, &rambuff_size, bufsize);
-  printk("DT3155: mem info\n");
-  printk("  - rambuf_addr = 0x%x\n", rambuff_addr);
-  printk("  - length (kb) = %u\n", rambuff_size);
+  printk(KERN_INFO "DT3155: mem info\n");
+  printk(KERN_INFO "  - rambuf_addr = 0x%x\n", rambuff_addr);
+  printk(KERN_INFO "  - length (kb) = %u\n", rambuff_size);
     if (rambuff_addr == 0) {
 	printk(KERN_INFO
 	    "DT3155: Error setup_buffers() allocator dma failed\n");
@@ -339,7 +343,8 @@ u32 dt3155_setup_buffers(u32 *allocatorAddr)
      are so we can give an equal number to each device */
   rambuff_acm = rambuff_addr;
     for (index = 0; index < MAXBUFFERS; index++) {
-	rambuff_acm = adjust_4MB(rambuff_acm, bufsize);/*avoid spanning 4MB bdry*/
+	/*avoid spanning 4MB bdry*/
+	rambuff_acm = adjust_4MB(rambuff_acm, bufsize);
 	if (rambuff_acm + bufsize > rambuff_end)
 		break;
 	rambuff_acm += bufsize;
@@ -347,7 +352,7 @@ u32 dt3155_setup_buffers(u32 *allocatorAddr)
   /* Following line is OK, will waste buffers if index
    * not evenly divisible by ndevices -NJC*/
   numbufs = index / ndevices;
-  printk("  - numbufs = %u\n", numbufs);
+  printk(KERN_INFO "  - numbufs = %u\n", numbufs);
     if (numbufs < 2) {
 	printk(KERN_INFO
 	"DT3155: Error setup_buffers() couldn't allocate 2 bufs/board\n");
@@ -367,7 +372,7 @@ u32 dt3155_setup_buffers(u32 *allocatorAddr)
 		rambuff_acm = adjust_4MB(rambuff_acm, bufsize);
 		if (rambuff_acm + bufsize > rambuff_end) {
 			/* Should never happen */
-			printk("DT3155 PROGRAM ERROR (GCS)\n"
+			printk(KERN_INFO "DT3155 PROGRAM ERROR (GCS)\n"
 			"Error distributing allocated buffers\n");
 			return -ENOMEM;
 		}
@@ -395,7 +400,7 @@ u32 dt3155_setup_buffers(u32 *allocatorAddr)
 	/* setup the ready queue */
 	dt3155_fbuffer[m]->ready_head = 0;
 	dt3155_fbuffer[m]->ready_len = 0;
-	printk("Available buffers for device %d: %d\n",
+	printk(KERN_INFO "Available buffers for device %d: %d\n",
 	    m, dt3155_fbuffer[m]->nbuffers);
     }
 
-- 
1.5.6.5

