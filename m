Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab0GEWCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 18:02:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64324 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab0GEWCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 18:02:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=ANNImmpI1jmuR06GYJ1O6NV+J2u3RTSb0FHBI1s4sQoYaNl3icOlt5jTtH/4IawCr9
         tWzxIlrgDbFui7zscE/32kCctpZ1KOqNXANP6GiaLlR8Z+6DzGo1w9Ev65DBC+CUNXg6
         ISNZr4ja2D/ztgNjVtTj5S5SF3dE8xkuCIxJs=
Subject: [PATCH 2/2] Staging: dt3155: fix coding style issues in
 dt3155_drv.c
From: Joe Eloff <kagen101@gmail.com>
Reply-To: kagen101@gmail.com
To: Greg Kroah-Hartman <gregkh@suse.de>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Simon Horman <horms@verge.net.au>
Cc: devel <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Jul 2010 00:02:25 +0200
Message-ID: <1278367345.5396.64.camel@dermezel>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From eba804d73097793329e857bebb31bd1de39cad5c Mon Sep 17 00:00:00 2001
From: Joe Eloff <kagen101@gmail.com>
Date: Mon, 5 Jul 2010 23:53:36 +0200
Subject: [PATCH 2/2] Staging: dt3155: fix coding style issues in
dt3155_drv.c

This is a patch to the dt3155_drv.c file that fixes up last errors found
by the checkpatch.pl tool.
Signed-off-by: Joe Eloff <kagen101@gmail.com>
---
 drivers/staging/dt3155/dt3155_drv.c |   33
++++++++++++++++++---------------
 1 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/dt3155/dt3155_drv.c
b/drivers/staging/dt3155/dt3155_drv.c
index 75a2244..66db878 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -78,7 +78,7 @@ extern void printques(int);
 MODULE_LICENSE("GPL");
 
 /* Error variable.  Zero means no error. */
-int dt3155_errno = 0;
+int dt3155_errno ;
 
 #ifndef PCI_DEVICE_ID_INTEL_7116
 #define PCI_DEVICE_ID_INTEL_7116 0x1223
@@ -99,7 +99,7 @@ wait_queue_head_t dt3155_read_wait_queue[MAXBOARDS];
 
 /* set to dynamicaly allocate, but it is tunable: */
 /* insmod DT_3155 dt3155 dt3155_major=XX */
-int dt3155_major = 0;
+int dt3155_major;
 
 /* The minor numbers are 0 and 1 ... they are not tunable.
  * They are used as the indices for the structure vectors,
@@ -124,8 +124,8 @@ u32  dt3155_dev_open[MAXBOARDS] = {0
 #endif
 };
 
-u32  ndevices = 0;
-u32 unique_tag = 0;;
+u32  ndevices;
+u32 unique_tag;
 
 
 /*
@@ -827,8 +827,9 @@ static int find_PCI(void)
 		dts = &dt3155_status[pci_index++];
 
 		/* Is it really there? */
-		if ((error = pci_read_config_word(pci_dev,
-		    PCI_CLASS_DEVICE, &rev_device)))
+		error = pci_read_config_word(pci_dev,
+		    PCI_CLASS_DEVICE, &rev_device);
+		if (error)
 			continue;
 
 		/* Found a board */
@@ -847,8 +848,9 @@ static int find_PCI(void)
 
 		/* Now, just go out and make sure that this/these device(s)
 		   is/are actually mapped into the kernel address space */
-		if ((error = pci_read_config_dword(pci_dev, PCI_BASE_ADDRESS_0,
-		    (u32 *) &base))) {
+		error = pci_read_config_dword(pci_dev, PCI_BASE_ADDRESS_0,
+		    (u32 *) &base);
+		if (error) {
 			printk(KERN_INFO "DT3155: Was not able to find device\n");
 			goto err;
 		}
@@ -868,9 +870,9 @@ static int find_PCI(void)
 			printk(KERN_INFO "DT3155: Unable to remap control registers\n");
 			goto err;
 		}
-
-		if ((error = pci_read_config_byte(pci_dev,
-		    PCI_INTERRUPT_LINE, &irq))) {
+		error = pci_read_config_byte(pci_dev,
+		    PCI_INTERRUPT_LINE, &irq);
+		if (error) {
 			printk(KERN_INFO "DT3155: Was not able to find device\n");
 			goto err;
 		}
@@ -892,7 +894,7 @@ err:
  return -EIO;
 }
 
-u32 allocatorAddr = 0;
+u32 allocatorAddr;
 
 /*****************************************************
  * init_module()
@@ -942,15 +944,16 @@ int init_module(void)
 	}
 	/* Now let's find the hardware.  find_PCI() will set ndevices to the
 	 * number of cards found in this machine. */
-
-	if ((rcode = find_PCI()) != 0) {
+	rcode = find_PCI();
+	if (rcode != 0) {
 		printk(KERN_ERR "DT3155 error: find_PCI() failed to find dt3155
board(s)\n");
 		unregister_chrdev(dt3155_major, "dt3155");
 		return rcode;
 	}
 
 	/* Ok, time to setup the frame buffers */
-	if ((rcode = dt3155_setup_buffers(&allocatorAddr)) < 0) {
+	rcode = dt3155_setup_buffers(&allocatorAddr);
+	if (rcode < 0) {
 		printk(KERN_ERR "DT3155: Error: setting up buffer not large
enough.");
 		unregister_chrdev(dt3155_major, "dt3155");
 		return rcode;
-- 
1.6.3.3



