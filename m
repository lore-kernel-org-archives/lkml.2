Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab0KWM2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 07:28:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48718 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab0KWM1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 07:27:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=TDu8SmtADza2g9gmi7coWfsubwDs9B+3h+3UIoapRnBJiWNJxxaVrAJIbPePPSj+iz
         CWMC3j7X3CQSRGfQVrArD13NQsYf0+neD9ouy4ZMXNXeCmC3y/ZXe2qrEo0LnmC9El67
         3CZQHnuBIcpMO+LgRyJxaNByC9u4mXe6ZYMDE=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 3/6] staging: ft1000: Remove unused variables.
Date: Tue, 23 Nov 2010 13:29:30 +0100
Message-Id: <1290515373-16145-4-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290515373-16145-1-git-send-email-marek.belisko@open-nandra.com>
References: <1290515373-16145-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove various variables which was used in old character device
interface. When use misc device variables aren't necessary anymore
so remove them.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c |   22 ----------------------
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c    |    2 --
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h   |    3 ---
 3 files changed, 0 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
index d1784a3..8d2c059 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
@@ -212,24 +212,15 @@ int ft1000_CreateDevice(struct ft1000_device *dev)
 	ft1000dev[i].inf_id = info->CardNumber;
 
     DEBUG("ft1000_CreateDevice: number of instance = %d\n", ft1000_flarion_cnt);
-    DEBUG("DeviceCreated = %x\n", info->DeviceCreated);
 
     //save the device info to global array
     pdevobj[info->CardNumber] = dev;
 
     DEBUG("ft1000_CreateDevice: ******SAVED pdevobj[%d]=%p\n", info->CardNumber, pdevobj[info->CardNumber]);	//aelias [+] reason:up
 
-    if (info->DeviceCreated)
-    {
-	DEBUG("ft1000_CreateDevice: \"%s\" already registered\n", info->DeviceName);
-	return -EIO;
-    }
-
-
     // register the device
 	DEBUG("ft1000_CreateDevice: \"%s\" device registration\n",
 		ft1000dev[i].dev.nodename);
-    info->DeviceMajor = 0;
 	result = misc_register(&ft1000dev[i].dev);
 	if (result) {
 		DEBUG("%s: return:  %d\n", __func__, result);
@@ -239,12 +230,6 @@ int ft1000_CreateDevice(struct ft1000_device *dev)
 	DEBUG("ft1000_CreateDevice: registered misc device \"%s\"\n",
 		ft1000dev[i].dev.nodename);
 
-    // save a dynamic device major number
-    if (info->DeviceMajor == 0)
-    {
-	info->DeviceMajor = result;
-	DEBUG("ft1000_PcdCreateDevice: device major = %d\n", info->DeviceMajor);
-    }
 
     // initialize application information
 
@@ -291,7 +276,6 @@ int ft1000_CreateDevice(struct ft1000_device *dev)
 //                                  S_IFCHR | S_IRUGO | S_IWUGO, &ft1000fops, NULL);
 
 
-    info->DeviceCreated = TRUE;
     ft1000_flarion_cnt++;
 
     return result;
@@ -319,8 +303,6 @@ void ft1000_DestroyDevice(struct net_device *dev)
 
 
 
-    if (info->DeviceCreated)
-	{
         ft1000_flarion_cnt--;
 		for (i = 0; i < MAX_DEVICE; i++) {
 			if (info->CardNumber == ft1000dev[i].inf_id)
@@ -362,12 +344,8 @@ void ft1000_DestroyDevice(struct net_device *dev)
 
 //        devfs_unregister(ft1000Handle[info->CardNumber]);
 
-		info->DeviceCreated = FALSE;
 
 		pdevobj[info->CardNumber] = NULL;
-	}
-
-
 }
 
 //---------------------------------------------------------------------------
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 1ca01e2..57a235f 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -834,8 +834,6 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
     pInfo->ft1000_reset = ft1000_reset;
     pInfo->mediastate = 0;
     pInfo->fifo_cnt = 0;
-    pInfo->DeviceCreated = FALSE;
-    pInfo->DeviceMajor = 0;
     pInfo->CurrentInterruptEnableMask = ISR_DEFAULT_MASK;
     pInfo->InterruptsEnabled = FALSE;
     pInfo->CardReady = 0;
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index a07db26..1572985 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -502,12 +502,9 @@ struct ft1000_info {
     int DSPResetNum;
     int NumIOCTLBufs;
     int IOCTLBufLvl;
-    int DeviceCreated;
     int CardReady;
     int NetDevRegDone;
     u8 CardNumber;
-    u8 DeviceName[15];
-    int DeviceMajor;
     int registered;
     int mediastate;
     int dhcpflg;
-- 
1.7.1

