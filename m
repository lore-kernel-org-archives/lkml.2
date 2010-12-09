Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab0LIK0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 05:26:00 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:57067 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab0LIKYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 05:24:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=px76ee6uut9TbbZbzAA4fStK9ZpdM0dmir76T/5aWNlwkBq3+EmdfKBrg+BtncANbo
         qOztFocmTbzHhYFqcgt3mH8XuXOrzzTh1V14l+EQbukLWcAbASQCSFoEjZyYPeWKTRcb
         ZOUzirwHy0w/jtaaXkrz2fPuuxOm/JTSTe13Y=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 3/8] staging: ft1000: Remove unused pdevobj array.
Date: Thu,  9 Dec 2010 11:26:48 +0100
Message-Id: <1291890413-15255-4-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291890413-15255-1-git-send-email-marek.belisko@open-nandra.com>
References: <1291890413-15255-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to store pointer to device in some local
array because we always pass to debugfs correct device pointer.
So remove it.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c |   23 ----------------------
 1 files changed, 0 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
index 8b735e4..0871e43 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
@@ -51,10 +51,6 @@ static long ft1000_ChIoctl(struct file *File, unsigned int Command,
                            unsigned long Argument);
 static int ft1000_ChRelease (struct inode *Inode, struct file *File);
 
-// Global pointer to device object
-static struct ft1000_device *pdevobj[MAX_NUM_CARDS + 2];
-//static devfs_handle_t ft1000Handle[MAX_NUM_CARDS];
-
 // List to free receive command buffer pool
 struct list_head freercvpool;
 
@@ -165,11 +161,6 @@ int ft1000_CreateDevice(struct ft1000_device *dev)
     DEBUG("ft1000_CreateDevice: number of instance = %d\n", ft1000_flarion_cnt);
     DEBUG("DeviceCreated = %x\n", info->DeviceCreated);
 
-    //save the device info to global array
-    pdevobj[info->CardNumber] = dev;
-
-    DEBUG("ft1000_CreateDevice: ******SAVED pdevobj[%d]=%p\n", info->CardNumber, pdevobj[info->CardNumber]);	//aelias [+] reason:up
-
     if (info->DeviceCreated)
     {
 	DEBUG("ft1000_CreateDevice: \"%s\" already registered\n", info->DeviceName);
@@ -327,8 +318,6 @@ void ft1000_DestroyDevice(struct net_device *dev)
 //        devfs_unregister(ft1000Handle[info->CardNumber]);
 
 		info->DeviceCreated = FALSE;
-
-		pdevobj[info->CardNumber] = NULL;
 	}
 
 
@@ -356,18 +345,6 @@ static int ft1000_ChOpen (struct inode *Inode, struct file *File)
 
 	info = File->private_data = netdev_priv(dev->net);
 
-    for (i=0; i<5; i++)
-        DEBUG("pdevobj[%d]=%p\n", i, pdevobj[i]); //aelias [+] reason: down
-
-    if ( pdevobj[num] != NULL )
-        //info = (struct ft1000_info *)(pdevobj[num]->net->priv);
-		info = netdev_priv(pdevobj[num]->net);
-    else
-    {
-        DEBUG("ft1000_ChOpen: can not find device object %d\n", num);
-        return -1;
-    }
-
     DEBUG("f_owner = %p number of application = %d\n", (&File->f_owner), info->appcnt );
 
     // Check if maximum number of application exceeded
-- 
1.7.1

