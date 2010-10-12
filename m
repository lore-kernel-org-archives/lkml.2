Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab0JLIZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 04:25:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55625 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757138Ab0JLIY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 04:24:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YfZy9VPz+DwWtm0IGWxeCjQMmSNbfM8YzxZxHvabwLx1j8daVvDbFF5YnQ7+tTVmCW
         zOpHcxlTBvExoMLcj0+dcKHK6jLNCNsxvHYt0XNH6TBwjYzzkjZzBCVLtE4azumMkidJ
         8MLazBGyQtrfNdNWqlU476AMvk34tRDRVzyyY=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Vasiliy Kulikov <segooon@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 3/4] staging: ft1000: Remove unused/unnecessary comments.
Date: Tue, 12 Oct 2010 10:26:42 +0200
Message-Id: <1286872003-12449-4-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286872003-12449-1-git-send-email-marek.belisko@gmail.com>
References: <1286872003-12449-1-git-send-email-marek.belisko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c |   50 ++++--------------------
 1 files changed, 8 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index dc2ef98..1a05148 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -6,7 +6,6 @@
 //
 // $Id:
 //====================================================
-// 20090926; aelias; removed all compiler warnings; ubuntu 9.04; 2.6.28-15-generic
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -16,16 +15,6 @@
 #include <linux/firmware.h>
 #include "ft1000_usb.h"
 
-//#include <linux/sched.h>
-//#include <linux/ptrace.h>
-//#include <linux/slab.h>
-//#include <linux/string.h>
-//#include <linux/timer.h>
-//#include <linux/netdevice.h>
-//#include <linux/ioport.h>
-//#include <linux/delay.h>
-//#include <asm/io.h>
-//#include <asm/system.h>
 #include <linux/kthread.h>
 
 MODULE_DESCRIPTION("FT1000 EXPRESS CARD DRIVER");
@@ -65,8 +54,7 @@ int ft1000_poll_thread(void *arg)
             }
         }
     }
-    //DEBUG("returned from polling thread\n");
-    return STATUS_SUCCESS;
+	return STATUS_SUCCESS;
 }
 
 
@@ -104,7 +92,6 @@ static int ft1000_probe(struct usb_interface *interface, const struct usb_device
 
     memset(ft1000dev, 0, sizeof(*ft1000dev));
 
-	//get usb device
     dev = interface_to_usbdev(interface);
     DEBUG("ft1000_probe: usb device descriptor info:\n");
     DEBUG("ft1000_probe: number of configuration is %d\n", dev->descriptor.bNumConfigurations);
@@ -112,7 +99,6 @@ static int ft1000_probe(struct usb_interface *interface, const struct usb_device
 	ft1000dev->dev = dev;
 	ft1000dev->status = 0;
 	ft1000dev->net = NULL;
-	//ft1000dev->device_lock = SPIN_LOCK_UNLOCKED;
 	spin_lock_init(&ft1000dev->device_lock);
 	ft1000dev->tx_urb = usb_alloc_urb(0, GFP_ATOMIC);
 	ft1000dev->rx_urb = usb_alloc_urb(0, GFP_ATOMIC);
@@ -171,26 +157,20 @@ static int ft1000_probe(struct usb_interface *interface, const struct usb_device
 	FileLength = dsp_fw->size;
 	release_firmware(dsp_fw);
 
-    //for ( i=0; i< MAX_NUM_CARDS+2; i++)
-    //    pdevobj[i] = NULL;
-
-    //download dsp image
     DEBUG("ft1000_probe: start downloading dsp image...\n");
     init_ft1000_netdev(ft1000dev);
     pft1000info = (FT1000_INFO *) netdev_priv (ft1000dev->net);
 
-//    DEBUG("In probe: pft1000info=%x\n", pft1000info);				// aelias [-] reason: warning: format ???%x??? expects type ???unsigned int???, but argument 2 has type ???struct FT1000_INFO *???
-    DEBUG("In probe: pft1000info=%p\n", pft1000info);		// aelias [+] reason: up
-
+	DEBUG("In probe: pft1000info=%p\n", pft1000info);
 	ret = dsp_reload(ft1000dev);
 	if (ret) {
 		printk(KERN_ERR "Problem with DSP image loading\n");
 		goto err_load;
 	}
 
-    gPollingfailed = FALSE;  //mbelian
+	gPollingfailed = FALSE;
     pft1000info->pPollThread = kthread_run(ft1000_poll_thread, ft1000dev, "ft1000_poll");
-	msleep(500); //mbelian
+	msleep(500);
 
     while (!pft1000info->CardReady)
     {
@@ -208,14 +188,13 @@ static int ft1000_probe(struct usb_interface *interface, const struct usb_device
     }
 
 
-    //initialize network device
     DEBUG("ft1000_probe::Card Ready!!!! Registering network device\n");
 
     reg_ft1000_netdev(ft1000dev, interface);
 
     pft1000info->NetDevRegDone = 1;
 
-		ft1000InitProc(ft1000dev->net);// +mbelian
+		ft1000InitProc(ft1000dev->net);
 
        return 0;
 
@@ -245,14 +224,13 @@ static void ft1000_disconnect(struct usb_interface *interface)
     DEBUG("ft1000_disconnect is called\n");
 
     pft1000info = (PFT1000_INFO)usb_get_intfdata(interface);
-//    DEBUG("In disconnect pft1000info=%x\n", pft1000info);	// aelias [-] reason: warning: format ???%x??? expects type ???unsigned int???, but argument 2 has type ???struct FT1000_INFO *???
-    DEBUG("In disconnect pft1000info=%p\n", pft1000info);	// aelias [+] reason: up
+	DEBUG("In disconnect pft1000info=%p\n", pft1000info);
 
 
 
     if (pft1000info)
     {
-		ft1000CleanupProc(pft1000info);	//+mbelian
+		ft1000CleanupProc(pft1000info);
         if ( pft1000info->pPollThread )
         {
             kthread_stop(pft1000info->pPollThread );
@@ -264,9 +242,6 @@ static void ft1000_disconnect(struct usb_interface *interface)
         {
             DEBUG("ft1000_disconnect: destroy char driver\n");
             ft1000_DestroyDevice(pft1000info->pFt1000Dev->net);
-            //DEBUG("ft1000_disconnect: calling ft1000_close\n");
-            //ft1000_close(pft1000info->pFt1000Dev->net);
-            //DEBUG("ft1000_disconnect: ft1000_close is called\n");
             unregister_netdev(pft1000info->pFt1000Dev->net);
             DEBUG("ft1000_disconnect: network device unregisterd\n");
             free_netdev(pft1000info->pFt1000Dev->net);
@@ -278,23 +253,14 @@ static void ft1000_disconnect(struct usb_interface *interface)
 
         DEBUG("ft1000_disconnect: urb freed\n");
 
-		kfree(pft1000info->pFt1000Dev); //+mbelian
+		kfree(pft1000info->pFt1000Dev);
     }
 	kfree(pFileStart);
-    //terminate other kernel threads
-    //in multiple instances case, first find the device
-    //in the link list
-    /**if (pPollThread)
-    {
-        kthread_stop(pPollThread);
-        DEBUG("Polling thread is killed \n");
-    }**/
 
     return;
 }
 
 static struct usb_driver ft1000_usb_driver = {
-    //.owner =    THIS_MODULE,
     .name  =    "ft1000usb",
     .probe =    ft1000_probe,
     .disconnect = ft1000_disconnect,
-- 
1.7.1

