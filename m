Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab0KWM1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 07:27:31 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56408 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab0KWM11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 07:27:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=ak25l/01R4vmVPcg7EC5HuBHmwCF6ce4CAucDXQXJcvYOjsSRDx1yL/dtUVD32xDdn
         LeXeqAwPQnE8U6NDuq2UiBeN4yt1gcqUhm248hsWNJlGyTTZUQBqWLIbcz9wmMSswsEl
         17iBHzuQMnl/p5qW9DiJsrxYkLbN/z3joSo70=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 5/6] staging: ft1000: Remove dead code
Date: Tue, 23 Nov 2010 13:29:32 +0100
Message-Id: <1290515373-16145-6-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290515373-16145-1-git-send-email-marek.belisko@open-nandra.com>
References: <1290515373-16145-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c |   68 +---------------------
 1 files changed, 1 insertions(+), 67 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
index 3df4b4c..768cad0 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
@@ -35,8 +35,6 @@
 
 static int ft1000_flarion_cnt = 0;
 
-//need to looking usage of ft1000Handle
-
 static int ft1000_ChOpen (struct inode *Inode, struct file *File);
 static unsigned int ft1000_ChPoll(struct file *file, poll_table *wait);
 static long ft1000_ChIoctl(struct file *File, unsigned int Command,
@@ -45,7 +43,6 @@ static int ft1000_ChRelease (struct inode *Inode, struct file *File);
 
 // Global pointer to device object
 static struct ft1000_device *pdevobj[MAX_NUM_CARDS + 2];
-//static devfs_handle_t ft1000Handle[MAX_NUM_CARDS];
 
 // List to free receive command buffer pool
 struct list_head freercvpool;
@@ -55,12 +52,6 @@ spinlock_t free_buff_lock;
 
 int numofmsgbuf = 0;
 
-// Global variable to indicate that all provisioning data is sent to DSP
-//bool fProvComplete;
-
-//
-// Table of entry-point routines for char device
-//
 static struct file_operations ft1000fops =
 {
 	.unlocked_ioctl	= ft1000_ChIoctl,
@@ -207,9 +198,8 @@ int ft1000_CreateDevice(struct ft1000_device *dev)
     //save the device info to global array
     pdevobj[info->CardNumber] = dev;
 
-    DEBUG("ft1000_CreateDevice: ******SAVED pdevobj[%d]=%p\n", info->CardNumber, pdevobj[info->CardNumber]);	//aelias [+] reason:up
+    DEBUG("ft1000_CreateDevice: ******SAVED pdevobj[%d]=%p\n", info->CardNumber, pdevobj[info->CardNumber]);
 
-    // register the device
 	DEBUG("ft1000_CreateDevice: \"%s\" device registration\n",
 		ft1000dev[i].dev.nodename);
 	result = misc_register(&ft1000dev[i].dev);
@@ -221,30 +211,6 @@ int ft1000_CreateDevice(struct ft1000_device *dev)
 	DEBUG("ft1000_CreateDevice: registered misc device \"%s\"\n",
 		ft1000dev[i].dev.nodename);
 
-
-    // initialize application information
-
-//    if (ft1000_flarion_cnt == 0) {
-//
-//    	  DEBUG("Initialize free_buff_lock and freercvpool\n");
-//        spin_lock_init(&free_buff_lock);
-//
-//        // initialize a list of buffers to be use for queuing up receive command data
-//        INIT_LIST_HEAD (&freercvpool);
-//
-//        // create list of free buffers
-//        for (i=0; i<NUM_OF_FREE_BUFFERS; i++) {
-//            // Get memory for DPRAM_DATA link list
-//            pdpram_blk = kmalloc ( sizeof(struct dpram_blk), GFP_KERNEL );
-//            // Get a block of memory to store command data
-//            pdpram_blk->pbuffer = kmalloc ( MAX_CMD_SQSIZE, GFP_KERNEL );
-//            // link provisioning data
-//            list_add_tail (&pdpram_blk->list, &freercvpool);
-//        }
-//        numofmsgbuf = NUM_OF_FREE_BUFFERS;
-//    }
-
-
     // initialize application information
     info->appcnt = 0;
     for (i=0; i<MAX_NUM_APP; i++) {
@@ -260,13 +226,6 @@ int ft1000_CreateDevice(struct ft1000_device *dev)
         INIT_LIST_HEAD (&info->app_info[i].app_sqlist);
     }
 
-
-
-
-//    ft1000Handle[info->CardNumber] = devfs_register(NULL, info->DeviceName, DEVFS_FL_AUTO_DEVNUM, 0, 0,
-//                                  S_IFCHR | S_IRUGO | S_IWUGO, &ft1000fops, NULL);
-
-
     ft1000_flarion_cnt++;
 
     return result;
@@ -333,9 +292,6 @@ void ft1000_DestroyDevice(struct net_device *dev)
             }
         }
 
-//        devfs_unregister(ft1000Handle[info->CardNumber]);
-
-
 		pdevobj[info->CardNumber] = NULL;
 }
 
@@ -362,7 +318,6 @@ static int ft1000_ChOpen (struct inode *Inode, struct file *File)
         DEBUG("pdevobj[%d]=%p\n", i, pdevobj[i]); //aelias [+] reason: down
 
     if ( pdevobj[num] != NULL )
-        //info = (struct ft1000_info *)(pdevobj[num]->net->priv);
 		info = netdev_priv(pdevobj[num]->net);
     else
     {
@@ -591,7 +546,6 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
     case IOCTL_SET_DPRAM_CMD:
         {
             IOCTL_DPRAM_BLK *dpram_data = NULL;
-            //IOCTL_DPRAM_COMMAND dpram_command;
             u16 qtype;
             u16 msgsz;
 		struct pseudo_hdr *ppseudo_hdr;
@@ -637,19 +591,11 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
 		if (!dpram_data)
 			break;
 
-                //if ( copy_from_user(&(dpram_command.dpram_blk), (PIOCTL_DPRAM_BLK)Argument, msgsz+2) ) {
                 if ( copy_from_user(dpram_data, argp, msgsz+2) ) {
                     DEBUG("FT1000:ft1000_ChIoctl: copy fault occurred\n");
                     result = -EFAULT;
                 }
                 else {
-#if 0
-                    // whc - for debugging only
-                    ptr = (char *)&dpram_data;
-                    for (i=0; i<msgsz; i++) {
-                        DEBUG(1,"FT1000:ft1000_ChIoctl: data %d = 0x%x\n", i, *ptr++);
-                    }
-#endif
                     // Check if this message came from a registered application
                     for (i=0; i<MAX_NUM_APP; i++) {
                         if ( info->app_info[i].fileobject == &File->f_owner) {
@@ -665,7 +611,6 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
                     app_index = i;
 
                     // Check message qtype type which is the lower byte within qos_class
-                    //qtype = ntohs(dpram_command.dpram_blk.pseudohdr.qos_class) & 0xff;
                     qtype = ntohs(dpram_data->pseudohdr.qos_class) & 0xff;
                     //DEBUG("FT1000_ft1000_ChIoctl: qtype = %d\n", qtype);
                     if (qtype) {
@@ -705,7 +650,6 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
                         // Make sure we are within the limits of the slow queue memory limitation
                         if ( (msgsz < MAX_CMD_SQSIZE) && (msgsz > PSEUDOSZ) ) {
                             // Need to put sequence number plus new checksum for message
-                            //pmsg = (u16 *)&dpram_command.dpram_blk.pseudohdr;
                             pmsg = (u16 *)&dpram_data->pseudohdr;
 				ppseudo_hdr = (struct pseudo_hdr *)pmsg;
                             total_len = msgsz+2;
@@ -725,16 +669,6 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
                             }
                             pmsg++;
 				ppseudo_hdr = (struct pseudo_hdr *)pmsg;
-#if 0
-                            ptr = dpram_data;
-                            DEBUG("FT1000:ft1000_ChIoctl: Command Send\n");
-                            for (i=0; i<total_len; i++) {
-                                DEBUG("FT1000:ft1000_ChIoctl: data %d = 0x%x\n", i, *ptr++);
-                            }
-#endif
-                            //dpram_command.extra = 0;
-
-                            //CardSendCommand(ft1000dev,(unsigned char*)&dpram_command,total_len+2);
                             CardSendCommand(ft1000dev,(unsigned short*)dpram_data,total_len+2);
 
 
-- 
1.7.1

