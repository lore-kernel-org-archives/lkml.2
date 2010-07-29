Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab0G2QhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 12:37:05 -0400
Received: from p01c11o144.mxlogic.net ([208.65.144.67]:57595 "EHLO
	p01c11o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab0G2QhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 12:37:03 -0400
X-MXL-Hash: 4c51ae2f64ba6452-b32e88bca7fddaf473b3588eea246f508e671dec
X-MXL-Hash: 4c51ae27786c9b59-0ba37c6cc41b3caef5b09bcce03a812e1ad2278d
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Staging: dt3155: remove useless dt3155_major parameter
Date: Thu, 29 Jul 2010 09:35:57 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <gregkh@suse.de>, <ss@aao.gov.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201007290935.57883.hartleys@visionengravers.com>
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010070601)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.32]
X-AnalysisOut: [v=1.0 c=1 a=dU6_AAMVDREA:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=zbe46bahRtDx8aUBN1lPzQ==:17 a=i00gxMtYAAAA:8 a=N_b]
X-AnalysisOut: [b6REVpTXJPe_PrGoA:9 a=yAeFqUUhPl2ItOOVgMkA:7 a=qxwlUsHgtkE]
X-AnalysisOut: [W4LVixjPInIRxOVIA:4 a=QEXdDO2ut3YA:10 a=x1WnkoZAwusA:10 a=]
X-AnalysisOut: [0kPLrQdw3YYA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dt3155_major variable was never exposed as a parameter so just make it
static and always allocate a dynamic major when registering the driver.

Also, remove a couple unnecessary comments and printk noise associated with
the major/minor numbers and registration.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Scott Smedley <ss@aao.gov.au>

---

diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index 7316996..95f9f0c 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -97,14 +97,7 @@ int dt3155_errno = 0;
 /* wait queue for interrupts */
 wait_queue_head_t dt3155_read_wait_queue[MAXBOARDS];
 
-/* set to dynamicaly allocate, but it is tunable: */
-/* insmod DT_3155 dt3155 dt3155_major=XX */
-int dt3155_major = 0;
-
-/* The minor numbers are 0 and 1 ... they are not tunable.
- * They are used as the indices for the structure vectors,
- * and register address vectors
- */
+static int dt3155_major;
 
 /* Global structures and variables */
 
@@ -955,16 +948,9 @@ static int __init dt3155_init(void)
   printk(KERN_INFO "DT3155: Loading module...\n");
 
   /* Register the device driver */
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
+  dt3155_major = register_chrdev(0, "dt3155", &dt3155_fops);
+  if (dt3155_major < 0)
+      return dt3155_major;
 
   /* init the status variables.                     */
   /* DMA memory is taken care of in setup_buffers() */
