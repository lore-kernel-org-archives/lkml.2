Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab0JNNty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 09:49:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65308 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708Ab0JNNtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 09:49:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rsVY9kMyOmPt0SP7rYu+etds7JwFJYbRtDXpxm1oDXkZBev4Eb5mEMYgjj4Vgfp6C+
         L1u6/mt/LeQKcWHngOqsDP4GqgtttACjzHM5kCvbPMJubVtoXyGqYh20mdzmaPebKJpA
         d5jXW/vM/a2uRaboBjWJq97ZVrfjHeJVtkR6I=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 1/5] staging:ft1000: various checkpatch.pl fixes.
Date: Thu, 14 Oct 2010 11:40:56 +0200
Message-Id: <1287049260-11988-2-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287049260-11988-1-git-send-email-marek.belisko@gmail.com>
References: <1287049260-11988-1-git-send-email-marek.belisko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c |   71 ++++++++++--------------
 1 files changed, 29 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index 1a05148..7c002ab 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -30,25 +30,22 @@ size_t FileLength;
 
 /* table of devices that work with this driver */
 static struct usb_device_id id_table[] = {
-    {USB_DEVICE(VENDOR_ID, PRODUCT_ID) },
+    {USB_DEVICE(VENDOR_ID, PRODUCT_ID)},
     { },
 };
 
-MODULE_DEVICE_TABLE (usb, id_table);
+MODULE_DEVICE_TABLE(usb, id_table);
 
 static BOOLEAN gPollingfailed = FALSE;
 int ft1000_poll_thread(void *arg)
 {
     int ret = STATUS_SUCCESS;
 
-    while(!kthread_should_stop() )
-    {
+    while (!kthread_should_stop()) {
         msleep(10);
-        if ( ! gPollingfailed )
-        {
+        if (!gPollingfailed) {
             ret = ft1000_poll(arg);
-            if ( ret != STATUS_SUCCESS )
-            {
+            if (ret != STATUS_SUCCESS) {
                 DEBUG("ft1000_poll_thread: polling failed\n");
                 gPollingfailed = TRUE;
             }
@@ -84,11 +81,12 @@ static int ft1000_probe(struct usb_interface *interface, const struct usb_device
 	const struct firmware *dsp_fw;
 
 
-    if(!(ft1000dev = kmalloc(sizeof(struct ft1000_device), GFP_KERNEL)))
-    {
-        printk("out of memory allocating device structure\n");
-	return 0;
-    }
+	ft1000dev = kmalloc(sizeof(struct ft1000_device), GFP_KERNEL);
+
+	if (!ft1000dev) {
+		printk(KERN_ERR "out of memory allocating device structure\n");
+		return 0;
+	}
 
     memset(ft1000dev, 0, sizeof(*ft1000dev));
 
@@ -106,7 +104,7 @@ static int ft1000_probe(struct usb_interface *interface, const struct usb_device
 
     DEBUG("ft1000_probe is called\n");
     numaltsetting = interface->num_altsetting;
-    DEBUG("ft1000_probe: number of alt settings is :%d\n",numaltsetting);
+    DEBUG("ft1000_probe: number of alt settings is :%d\n", numaltsetting);
     iface_desc = interface->cur_altsetting;
     DEBUG("ft1000_probe: number of endpoints is %d\n", iface_desc->desc.bNumEndpoints);
     DEBUG("ft1000_probe: descriptor type is %d\n", iface_desc->desc.bDescriptorType);
@@ -118,19 +116,16 @@ static int ft1000_probe(struct usb_interface *interface, const struct usb_device
     DEBUG("ft1000_probe: descriptor1 type -- %d\n", iface_desc->endpoint[1].desc.bmAttributes);
     DEBUG("ft1000_probe: descriptor2 type -- %d\n", iface_desc->endpoint[2].desc.bmAttributes);
 
-    for (i=0; i< iface_desc->desc.bNumEndpoints;i++ )
-    {
+    for (i = 0; i < iface_desc->desc.bNumEndpoints; i++) {
 		endpoint = (struct usb_endpoint_descriptor *)&iface_desc->endpoint[i].desc;
                 DEBUG("endpoint %d\n", i);
                 DEBUG("bEndpointAddress=%x, bmAttributes=%x\n", endpoint->bEndpointAddress, endpoint->bmAttributes);
-		if ( (endpoint->bEndpointAddress & USB_DIR_IN) && ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) == USB_ENDPOINT_XFER_BULK))
-		{
+		if ((endpoint->bEndpointAddress & USB_DIR_IN) && ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) == USB_ENDPOINT_XFER_BULK)) {
 			ft1000dev->bulk_in_endpointAddr = endpoint->bEndpointAddress;
 			DEBUG("ft1000_probe: in: %d\n", endpoint->bEndpointAddress);
 		}
 
-		if (!(endpoint->bEndpointAddress & USB_DIR_IN) && ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) == USB_ENDPOINT_XFER_BULK))
-		{
+		if (!(endpoint->bEndpointAddress & USB_DIR_IN) && ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) == USB_ENDPOINT_XFER_BULK)) {
 			ft1000dev->bulk_out_endpointAddr = endpoint->bEndpointAddress;
 			DEBUG("ft1000_probe: out: %d\n", endpoint->bEndpointAddress);
 		}
@@ -159,7 +154,7 @@ static int ft1000_probe(struct usb_interface *interface, const struct usb_device
 
     DEBUG("ft1000_probe: start downloading dsp image...\n");
     init_ft1000_netdev(ft1000dev);
-    pft1000info = (FT1000_INFO *) netdev_priv (ft1000dev->net);
+    pft1000info = (FT1000_INFO *) netdev_priv(ft1000dev->net);
 
 	DEBUG("In probe: pft1000info=%p\n", pft1000info);
 	ret = dsp_reload(ft1000dev);
@@ -172,20 +167,16 @@ static int ft1000_probe(struct usb_interface *interface, const struct usb_device
     pft1000info->pPollThread = kthread_run(ft1000_poll_thread, ft1000dev, "ft1000_poll");
 	msleep(500);
 
-    while (!pft1000info->CardReady)
-    {
-        if ( gPollingfailed )
-        {
-            if ( pft1000info->pPollThread )
-            {
-                kthread_stop(pft1000info->pPollThread );
-            }
-		ret = -EIO;
-		goto err_load;
-        }
-        msleep(100);
-        DEBUG("ft1000_probe::Waiting for Card Ready\n");
-    }
+	while (!pft1000info->CardReady) {
+		if (gPollingfailed) {
+			if (pft1000info->pPollThread)
+				kthread_stop(pft1000info->pPollThread);
+			ret = -EIO;
+			goto err_load;
+		}
+		msleep(100);
+		DEBUG("ft1000_probe::Waiting for Card Ready\n");
+	}
 
 
     DEBUG("ft1000_probe::Card Ready!!!! Registering network device\n");
@@ -228,18 +219,14 @@ static void ft1000_disconnect(struct usb_interface *interface)
 
 
 
-    if (pft1000info)
-    {
+    if (pft1000info) {
 		ft1000CleanupProc(pft1000info);
-        if ( pft1000info->pPollThread )
-        {
+        if (pft1000info->pPollThread)
             kthread_stop(pft1000info->pPollThread );
-        }
 
         DEBUG("ft1000_disconnect: threads are terminated\n");
 
-        if (pft1000info->pFt1000Dev->net)
-        {
+        if (pft1000info->pFt1000Dev->net) {
             DEBUG("ft1000_disconnect: destroy char driver\n");
             ft1000_DestroyDevice(pft1000info->pFt1000Dev->net);
             unregister_netdev(pft1000info->pFt1000Dev->net);
-- 
1.7.1

