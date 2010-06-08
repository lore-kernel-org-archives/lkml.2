Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab0FHPiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 11:38:12 -0400
Received: from p01c12o142.mxlogic.net ([208.65.145.65]:33662 "EHLO
	p01c12o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab0FHPiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 11:38:10 -0400
X-MXL-Hash: 4c0e63e24af7941f-9250d239689a57252d69cf7f06ee39dc1fb7addb
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
CC: Greg KH <gregkh@suse.de>, "ss@aao.gov.au" <ss@aao.gov.au>
Date: Tue, 8 Jun 2010 10:36:57 -0500
Subject: [PATCH] Staging: dt3155: remove DT_3155_* errno defines
Thread-Topic: [PATCH] Staging: dt3155: remove DT_3155_* errno defines
Thread-Index: AcsHIG4oLqsD+ETkRBiXngi/SzrGYA==
Message-ID: <0D753D10438DA54287A00B027084269763708AFE4C@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010052801)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [(unknown)]
X-AnalysisOut: [v=1.0 c=1 a=0vg5piGxXicA:10 a=hO-oPbc3tlwA:10 a=VphdPIyG4k]
X-AnalysisOut: [EA:10 a=IkcTkHD0fZMA:10 a=qS3xps/WtSuafY8lc/WARg==:17 a=i0]
X-AnalysisOut: [0gxMtYAAAA:8 a=c5nlV6Vr_ayBDvffL6UA:9 a=0eKx0zlqyjadYEMh6E]
X-AnalysisOut: [yaOe4sdKsA:4 a=QEXdDO2ut3YA:10 a=x1WnkoZAwusA:10 a=0kPLrQd]
X-AnalysisOut: [w3YYA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o58FcQim005889

Remove the DT_3155_{SUCCESS/FAILURE} errno defines and use the
kernel provided ones.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Scott Smedley <ss@aao.gov.au>

---

diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index 40ef97f..35c1111 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -97,9 +97,6 @@ int dt3155_errno = 0;
 /* wait queue for interrupts */
 wait_queue_head_t dt3155_read_wait_queue[MAXBOARDS];
 
-#define DT_3155_SUCCESS 0
-#define DT_3155_FAILURE -EIO
-
 /* set to dynamicaly allocate, but it is tunable: */
 /* insmod DT_3155 dt3155 dt3155_major=XX */
 int dt3155_major = 0;
@@ -941,11 +938,11 @@ static int find_PCI (void)
     }
   ndevices = pci_index;
 
-  return DT_3155_SUCCESS;
+  return 0;
 
 err:
   pci_dev_put(pci_dev);
-  return DT_3155_FAILURE;
+  return -EIO;
 }
 
 u32 allocatorAddr = 0;
@@ -999,7 +996,7 @@ int init_module(void)
   /* Now let's find the hardware.  find_PCI() will set ndevices to the
    * number of cards found in this machine. */
     {
-      if ((rcode = find_PCI()) !=  DT_3155_SUCCESS)
+      if ((rcode = find_PCI()) != 0)
 	{
 	  printk("DT3155 error: find_PCI() failed to find dt3155 board(s)\n");
 	  unregister_chrdev(dt3155_major, "dt3155");
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
