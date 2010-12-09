Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab0LIKZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 05:25:07 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:36647 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002Ab0LIKYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 05:24:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=pAF/0YHPtJyeVRJhsOqcC+Yhi27lzrpKxXK9ReoVwPVamkEkDmxLdXFHJN81WjL+dE
         702PjxkZyY+p/HXsqmsfmRJ9uD9h2/rkvNwjDk1p+1P1XkUJAxrD9xc8RbrUTdjhkkV4
         Z4G7Oi6oPtZSzbGEGMhbhkRPZPzRxBiG9+inM=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 6/8] staging: ft1000: Remove dead code.
Date: Thu,  9 Dec 2010 11:26:51 +0100
Message-Id: <1291890413-15255-7-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291890413-15255-1-git-send-email-marek.belisko@open-nandra.com>
References: <1291890413-15255-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c |   61 +---------------------
 1 files changed, 1 insertions(+), 60 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
index 85f67e5..58aee36 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
@@ -39,12 +39,9 @@
 #include <linux/unistd.h>
 #include <linux/debugfs.h>
 #include "ft1000_usb.h"
-//#include "ft1000_ioctl.h"
 
 static int ft1000_flarion_cnt = 0;
 
-//need to looking usage of ft1000Handle
-
 static int ft1000_open (struct inode *inode, struct file *file);
 static unsigned int ft1000_poll_dev(struct file *file, poll_table *wait);
 static long ft1000_ioctl(struct file *file, unsigned int command,
@@ -59,9 +56,6 @@ spinlock_t free_buff_lock;
 
 int numofmsgbuf = 0;
 
-// Global variable to indicate that all provisioning data is sent to DSP
-//bool fProvComplete;
-
 //
 // Table of entry-point routines for char device
 //
@@ -198,29 +192,6 @@ int ft1000_create_dev(struct ft1000_device *dev)
     DEBUG("ft1000_CreateDevice: registered char device \"%s\"\n", info->DeviceName);
 
     // initialize application information
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
-    // initialize application information
     info->appcnt = 0;
     for (i=0; i<MAX_NUM_APP; i++) {
         info->app_info[i].nTxMsg = 0;
@@ -235,13 +206,6 @@ int ft1000_create_dev(struct ft1000_device *dev)
         INIT_LIST_HEAD (&info->app_info[i].app_sqlist);
     }
 
-
-
-
-//    ft1000Handle[info->CardNumber] = devfs_register(NULL, info->DeviceName, DEVFS_FL_AUTO_DEVNUM, 0, 0,
-//                                  S_IFCHR | S_IRUGO | S_IWUGO, &ft1000fops, NULL);
-
-
     info->DeviceCreated = TRUE;
     ft1000_flarion_cnt++;
 
@@ -313,9 +277,6 @@ void ft1000_destroy_dev(struct net_device *dev)
                 kfree(ptr);
             }
         }
-
-//        devfs_unregister(ft1000Handle[info->CardNumber]);
-
 		info->DeviceCreated = FALSE;
 	}
 
@@ -609,19 +570,11 @@ static long ft1000_ioctl (struct file *file, unsigned int command,
 		if (!dpram_data)
 			break;
 
-                //if ( copy_from_user(&(dpram_command.dpram_blk), (PIOCTL_DPRAM_BLK)argument, msgsz+2) ) {
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
                         if ( info->app_info[i].fileobject == &file->f_owner) {
@@ -637,7 +590,6 @@ static long ft1000_ioctl (struct file *file, unsigned int command,
                     app_index = i;
 
                     // Check message qtype type which is the lower byte within qos_class
-                    //qtype = ntohs(dpram_command.dpram_blk.pseudohdr.qos_class) & 0xff;
                     qtype = ntohs(dpram_data->pseudohdr.qos_class) & 0xff;
                     //DEBUG("FT1000_ft1000_ioctl: qtype = %d\n", qtype);
                     if (qtype) {
@@ -677,7 +629,6 @@ static long ft1000_ioctl (struct file *file, unsigned int command,
                         // Make sure we are within the limits of the slow queue memory limitation
                         if ( (msgsz < MAX_CMD_SQSIZE) && (msgsz > PSEUDOSZ) ) {
                             // Need to put sequence number plus new checksum for message
-                            //pmsg = (u16 *)&dpram_command.dpram_blk.pseudohdr;
                             pmsg = (u16 *)&dpram_data->pseudohdr;
 				ppseudo_hdr = (struct pseudo_hdr *)pmsg;
                             total_len = msgsz+2;
@@ -697,17 +648,7 @@ static long ft1000_ioctl (struct file *file, unsigned int command,
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
-                            CardSendCommand(ft1000dev,(unsigned short*)dpram_data,total_len+2);
+                           CardSendCommand(ft1000dev,(unsigned short*)dpram_data,total_len+2);
 
 
                             info->app_info[app_index].nTxMsg++;
-- 
1.7.1

