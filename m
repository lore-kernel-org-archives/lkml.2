Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab0GVUBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 16:01:10 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33286 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab0GVUBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 16:01:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=arhpQJWs6ZJolSahay0hW5Kc4lpJkFvGcCtkULymxth2fMUcZNWnvqy26/Htugu5z0
         KVhumnQ45QXmWN3OCEayX53k6K1g7gcfbDdIb3o6d7w9u3MsySfkORHW/lS9soGFtWym
         kK3XYHpNaesKLOCJTBpzUPL4R0UlcfD4twShw=
Subject: [PATCH 2/2] Staging: dt3155: Fixed all printk warnings found by
 checkpatch.pl
From: Joe Eloff <kagen101@gmail.com>
Reply-To: kagen101@gmail.com
To: Greg Kroah-Hartman <gregkh@suse.de>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Simon Horman <horms@verge.net.au>
Cc: devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 22:00:47 +0200
Message-ID: <1279828847.759.4.camel@dermezel>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8f5fff4e75aec2d77575c2ca2dd6a166ac473b18 Mon Sep 17 00:00:00 2001
From: Joe Eloff <kagen101@gmail.com>
Date: Thu, 22 Jul 2010 20:42:04 +0200
Subject: [PATCH 2/2] Staging: dt3155: Fixed all printk warnings found by checkpatch.pl

Added all KERN_ levels in printk found by checkpatch.pl
Signed-off-by: Joe Eloff <kagen101@gmail.com>
---
 drivers/staging/dt3155/dt3155_drv.c |   60 +++++++++++++++++-----------------
 1 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index 1d6858c..cd63853 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -210,7 +210,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
       /* and set some flags so that dt3155_read      */
       /* returns an error next time it is called     */
       dt3155_errno = DT_ERR_CORRUPT;
-      printk("dt3155:  corrupt field\n");
+      printk(KERN_ERR "dt3155:  corrupt field\n");
       return;
     }
 
@@ -232,7 +232,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
       /* disable the interrupt if last field */
       if (fb->stop_acquire)
 	{
-	  printk("dt3155:  even stopped.\n");
+	  printk(KERN_INFO "dt3155:  even stopped.\n");
 	  fb->even_stopped = 1;
 	  if (i2c_even_csr.fld.SNGL_EVE)
 	    {
@@ -404,7 +404,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
       return;
     }
   /* If we get here, the Odd Field wasn't it either... */
-  printk("neither even nor odd.  shared perhaps?\n");
+  printk(KERN_DEBUG "neither even nor odd.  shared perhaps?\n");
 }
 
 /*****************************************************
@@ -514,8 +514,8 @@ static int dt3155_ioctl(struct inode *inode,
   /* make sure it is valid command */
   if (_IOC_NR(cmd) > DT3155_IOC_MAXNR)
     {
-      printk("DT3155: invalid IOCTL(0x%x)\n",cmd);
-      printk("DT3155: Valid commands (0x%x), (0x%x), (0x%x), (0x%x), (0x%x)\n",
+      printk(KERN_INFO "DT3155: invalid IOCTL(0x%x)\n", cmd);
+      printk(KERN_INFO "DT3155: Valid commands (0x%x), (0x%x), (0x%x), (0x%x), (0x%x)\n",
 	     (unsigned int)DT3155_GET_CONFIG,
 	     (unsigned int)DT3155_SET_CONFIG,
 	     (unsigned int)DT3155_START,
@@ -599,8 +599,8 @@ static int dt3155_ioctl(struct inode *inode,
       }
     default:
       {
-	printk("DT3155: invalid IOCTL(0x%x)\n",cmd);
-      printk("DT3155: Valid commands (0x%x), (0x%x), (0x%x), (0x%x), (0x%x)\n",
+	printk(KERN_INFO "DT3155: invalid IOCTL(0x%x)\n", cmd);
+      printk(KERN_INFO "DT3155: Valid commands (0x%x), (0x%x), (0x%x), (0x%x), (0x%x)\n",
 	     (unsigned int)DT3155_GET_CONFIG,
 	     (unsigned int)DT3155_SET_CONFIG,
 	     DT3155_START, DT3155_STOP, DT3155_FLUSH);
@@ -644,13 +644,13 @@ static int dt3155_mmap (struct file * file, struct vm_area_struct * vma)
 			offset >> PAGE_SHIFT,
 			vma->vm_end - vma->vm_start,
 			vma->vm_page_prot)) {
-	  printk("DT3155: remap_page_range() failed.\n");
+	  printk(KERN_INFO "DT3155: remap_page_range() failed.\n");
 	  return -EAGAIN;
 	}
     }
   else
     {
-      printk("DT3155: dt3155_mmap() bad call.\n");
+      printk(KERN_INFO "DT3155: dt3155_mmap() bad call.\n");
       return -ENXIO;
     }
 
@@ -671,24 +671,24 @@ static int dt3155_open(struct inode* inode, struct file* filep)
   struct dt3155_status *dts = &dt3155_status[minor];
 
   if (dt3155_dev_open[minor]) {
-    printk ("DT3155:  Already opened by another process.\n");
+	printk(KERN_INFO "DT3155:  Already opened by another process.\n");
     return -EBUSY;
   }
 
   if (dts->device_installed==0)
     {
-      printk("DT3155 Open Error: No such device dt3155 minor number %d\n",
+      printk(KERN_INFO "DT3155 Open Error: No such device dt3155 minor number %d\n",
 	     minor);
       return -EIO;
     }
 
   if (dts->state != DT3155_STATE_IDLE) {
-    printk ("DT3155:  Not in idle state (state = %x)\n",
+	printk(KERN_INFO "DT3155:  Not in idle state (state = %x)\n",
 	    dts->state);
     return -EBUSY;
   }
 
-  printk("DT3155: Device opened.\n");
+  printk(KERN_INFO "DT3155: Device opened.\n");
 
   dt3155_dev_open[minor] = 1 ;
 
@@ -716,7 +716,7 @@ static int dt3155_close(struct inode *inode, struct file *filep)
 
   if (!dt3155_dev_open[minor])
     {
-      printk("DT3155: attempt to CLOSE a not OPEN device\n");
+      printk(KERN_INFO "DT3155: attempt to CLOSE a not OPEN device\n");
     }
   else
     {
@@ -749,7 +749,7 @@ static ssize_t dt3155_read(struct file *filep, char __user *buf,
   /*   return an error on hardware failures */
   if (count != sizeof(struct dt3155_read))
     {
-      printk("DT3155 ERROR (NJC): count is not right\n");
+      printk(KERN_INFO "DT3155 ERROR (NJC): count is not right\n");
       return -EINVAL;
     }
 
@@ -786,7 +786,7 @@ static ssize_t dt3155_read(struct file *filep, char __user *buf,
 
       if (frame_index < 0)
 	{
-	  printk ("DT3155: read: interrupted\n");
+	  printk(KERN_INFO "DT3155: read: interrupted\n");
 	  quick_stop (minor);
 	  printques(minor);
 	  return -EINTR;
@@ -879,7 +879,7 @@ static int find_PCI (void)
       /* Make sure the driver was compiled with enough buffers to handle
 	 this many boards */
       if (pci_index > MAXBOARDS) {
-	printk("DT3155: ERROR - found %d devices, but driver only configured "
+	printk(KERN_ERR "DT3155: Found %d devices, but driver only configured "
 	       "for %d devices\n"
 	       "DT3155: Please change MAXBOARDS in dt3155.h\n",
 	       pci_index, MAXBOARDS);
@@ -891,7 +891,7 @@ static int find_PCI (void)
       if ((error = pci_read_config_dword(pci_dev, PCI_BASE_ADDRESS_0,
 					  (u32 *) &base)))
 	{
-	  printk("DT3155: Was not able to find device \n");
+	  printk(KERN_INFO "DT3155: Was not able to find device\n");
 	  goto err;
 	}
 
@@ -906,13 +906,13 @@ static int find_PCI (void)
 			dt3155_lbase[pci_index-1]);
       if (!dt3155_lbase[pci_index-1])
 	{
-	  printk("DT3155: Unable to remap control registers\n");
+	  printk(KERN_INFO "DT3155: Unable to remap control registers\n");
 	  goto err;
 	}
 
       if ((error = pci_read_config_byte(pci_dev, PCI_INTERRUPT_LINE, &irq)))
 	{
-	  printk("DT3155: Was not able to find device \n");
+	  printk(KERN_INFO "DT3155: Was not able to find device\n");
 	  goto err;
 	}
 
@@ -920,7 +920,7 @@ static int find_PCI (void)
       dts->irq = irq;
       /* Set flag: kth device found! */
       dts->device_installed = 1;
-      printk("DT3155: Installing device %d w/irq %d and address %p\n",
+      printk(KERN_INFO "DT3155: Installing device %d w/irq %d and address %p\n",
 	     pci_index,
 	     dts->irq,
 	     dt3155_lbase[pci_index-1]);
@@ -952,7 +952,7 @@ int init_module(void)
   devname[1] = "dt3155b";
 #endif
 
-  printk("DT3155: Loading module...\n");
+  printk(KERN_INFO "DT3155: Loading module...\n");
 
   /* Register the device driver */
   rcode = register_chrdev(dt3155_major, "dt3155", &dt3155_fops);
@@ -991,7 +991,7 @@ int init_module(void)
     {
       if ((rcode = find_PCI()) != 0)
 	{
-	  printk("DT3155 error: find_PCI() failed to find dt3155 board(s)\n");
+	  printk(KERN_INFO "DT3155 error: find_PCI() failed to find dt3155 board(s)\n");
 	  unregister_chrdev(dt3155_major, "dt3155");
 	  return rcode;
 	}
@@ -1000,7 +1000,7 @@ int init_module(void)
   /* Ok, time to setup the frame buffers */
   if((rcode = dt3155_setup_buffers(&allocatorAddr)) < 0)
     {
-      printk("DT3155: Error: setting up buffer not large enough.");
+      printk(KERN_INFO "DT3155: Error: setting up buffer not large enough.");
       unregister_chrdev(dt3155_major, "dt3155");
       return rcode;
     }
@@ -1011,14 +1011,14 @@ int init_module(void)
     {
       dts = &dt3155_status[index];
 
-      printk("DT3155: Device = %d; acq_mode = %d; "
+      printk(KERN_INFO "DT3155: Device = %d; acq_mode = %d;"
 	     "continuous = %d; cols = %d; rows = %d;\n",
 	     index ,
 	     dts->config.acq_mode,
 	     dts->config.continuous,
 	     dts->config.cols,
 	     dts->config.rows);
-      printk("DT3155: m_addr = 0x%x; m_size = %ld; "
+      printk(KERN_INFO "DT3155: m_addr = 0x%x; m_size = %ld;"
 	     "state = %d; device_installed = %d\n",
 	     dts->mem_addr,
 	     (long int)dts->mem_size,
@@ -1046,7 +1046,7 @@ int init_module(void)
 			       (void *)dts);
 	  if(rcode < 0)
 	    {
-	      printk("DT3155: minor %d request_irq failed for IRQ %d\n",
+	      printk(KERN_INFO "DT3155: minor %d request_irq failed for IRQ %d\n",
 		     index, dts->irq);
 	      unregister_chrdev(dt3155_major, "dt3155");
 	      return rcode;
@@ -1054,7 +1054,7 @@ int init_module(void)
 	}
     }
 
-  printk("DT3155: finished loading\n");
+  printk(KERN_INFO "DT3155: finished loading\n");
 
   return 0;
 }
@@ -1068,7 +1068,7 @@ void cleanup_module(void)
   struct dt3155_status *dts;
   int index;
 
-  printk("DT3155:  cleanup_module called\n");
+  printk(KERN_INFO "DT3155:  cleanup_module called\n");
 
   /* removed DMA allocated with the allocator */
 #ifdef STANDALONE_ALLOCATOR
@@ -1085,7 +1085,7 @@ void cleanup_module(void)
       dts = &dt3155_status[index];
       if(dts->device_installed == 1)
 	{
-	  printk("DT3155: Freeing irq %d for device %d\n",
+	  printk(KERN_INFO "DT3155: Freeing irq %d for device %d\n",
 		  dts->irq, index);
 	  free_irq(dts->irq, (void *)dts);
 	}
-- 
1.6.3.3



