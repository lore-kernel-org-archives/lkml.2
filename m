Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab0LIKYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 05:24:43 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:57067 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224Ab0LIKYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 05:24:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=UZ9/21fVr/VBxJFa3DgReVI+wb78l0FhKD9Ok4xg15UEXTv4GhG02B4SaKvbU6KtTD
         8rls/aiXATiyiPabLwZEZ8KQgDnuwS3FrP/amePI0zY3K56xQgnBE4LdMNpMH398Ue3r
         lTcpvZOxIiWK3OxUA9gYmAP4XXCL5MsYZWPzA=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 5/8] staging: ft1000: Fix camelcase functions and variables.
Date: Thu,  9 Dec 2010 11:26:50 +0100
Message-Id: <1291890413-15255-6-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291890413-15255-1-git-send-email-marek.belisko@open-nandra.com>
References: <1291890413-15255-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c |  156 +++++++++++-----------
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c    |    2 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c   |    2 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h   |    4 +-
 4 files changed, 82 insertions(+), 82 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
index 4e5c8a3..85f67e5 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
@@ -45,11 +45,11 @@ static int ft1000_flarion_cnt = 0;
 
 //need to looking usage of ft1000Handle
 
-static int ft1000_ChOpen (struct inode *Inode, struct file *File);
-static unsigned int ft1000_ChPoll(struct file *file, poll_table *wait);
-static long ft1000_ChIoctl(struct file *File, unsigned int Command,
-                           unsigned long Argument);
-static int ft1000_ChRelease (struct inode *Inode, struct file *File);
+static int ft1000_open (struct inode *inode, struct file *file);
+static unsigned int ft1000_poll_dev(struct file *file, poll_table *wait);
+static long ft1000_ioctl(struct file *file, unsigned int command,
+                           unsigned long argument);
+static int ft1000_release (struct inode *inode, struct file *file);
 
 // List to free receive command buffer pool
 struct list_head freercvpool;
@@ -67,10 +67,10 @@ int numofmsgbuf = 0;
 //
 static struct file_operations ft1000fops =
 {
-	.unlocked_ioctl	= ft1000_ChIoctl,
-	.poll		= ft1000_ChPoll,
-	.open		= ft1000_ChOpen,
-	.release	= ft1000_ChRelease,
+	.unlocked_ioctl	= ft1000_ioctl,
+	.poll		= ft1000_poll_dev,
+	.open		= ft1000_open,
+	.release	= ft1000_release,
 	.llseek		= no_llseek,
 };
 
@@ -147,7 +147,7 @@ void ft1000_free_buffer(struct dpram_blk *pdpram_blk, struct list_head *plist)
 // Notes:       Only called by init_module().
 //
 //---------------------------------------------------------------------------
-int ft1000_CreateDevice(struct ft1000_device *dev)
+int ft1000_create_dev(struct ft1000_device *dev)
 {
 	struct ft1000_info *info = netdev_priv(dev->net);
     int result;
@@ -265,7 +265,7 @@ fail:
 // Notes:       Only called by cleanup_module().
 //
 //---------------------------------------------------------------------------
-void ft1000_DestroyDevice(struct net_device *dev)
+void ft1000_destroy_dev(struct net_device *dev)
 {
 	struct ft1000_info *info = netdev_priv(dev);
 		int i;
@@ -323,7 +323,7 @@ void ft1000_DestroyDevice(struct net_device *dev)
 }
 
 //---------------------------------------------------------------------------
-// Function:    ft1000_ChOpen
+// Function:    ft1000_open
 //
 // Parameters:
 //
@@ -332,19 +332,19 @@ void ft1000_DestroyDevice(struct net_device *dev)
 // Notes:
 //
 //---------------------------------------------------------------------------
-static int ft1000_ChOpen (struct inode *Inode, struct file *File)
+static int ft1000_open (struct inode *inode, struct file *file)
 {
 	struct ft1000_info *info;
-	struct ft1000_device *dev = (struct ft1000_device *)Inode->i_private;
+	struct ft1000_device *dev = (struct ft1000_device *)inode->i_private;
     int i,num;
 
-    DEBUG("ft1000_ChOpen called\n");
-    num = (MINOR(Inode->i_rdev) & 0xf);
-    DEBUG("ft1000_ChOpen: minor number=%d\n", num);
+    DEBUG("ft1000_open called\n");
+    num = (MINOR(inode->i_rdev) & 0xf);
+    DEBUG("ft1000_open: minor number=%d\n", num);
 
-	info = File->private_data = netdev_priv(dev->net);
+	info = file->private_data = netdev_priv(dev->net);
 
-    DEBUG("f_owner = %p number of application = %d\n", (&File->f_owner), info->appcnt );
+    DEBUG("f_owner = %p number of application = %d\n", (&file->f_owner), info->appcnt );
 
     // Check if maximum number of application exceeded
     if (info->appcnt > MAX_NUM_APP) {
@@ -366,19 +366,19 @@ static int ft1000_ChOpen (struct inode *Inode, struct file *File)
     }
 
     info->appcnt++;
-    info->app_info[i].fileobject = &File->f_owner;
+    info->app_info[i].fileobject = &file->f_owner;
     info->app_info[i].nTxMsg = 0;
     info->app_info[i].nRxMsg = 0;
     info->app_info[i].nTxMsgReject = 0;
     info->app_info[i].nRxMsgMiss = 0;
 
-	nonseekable_open(Inode, File);
+	nonseekable_open(inode, file);
     return 0;
 }
 
 
 //---------------------------------------------------------------------------
-// Function:    ft1000_ChPoll
+// Function:    ft1000_poll_dev
 //
 // Parameters:
 //
@@ -388,15 +388,15 @@ static int ft1000_ChOpen (struct inode *Inode, struct file *File)
 //
 //---------------------------------------------------------------------------
 
-static unsigned int ft1000_ChPoll(struct file *file, poll_table *wait)
+static unsigned int ft1000_poll_dev(struct file *file, poll_table *wait)
 {
     struct net_device *dev = file->private_data;
 	struct ft1000_info *info;
     int i;
 
-    //DEBUG("ft1000_ChPoll called\n");
+    //DEBUG("ft1000_poll_dev called\n");
     if (ft1000_flarion_cnt == 0) {
-        DEBUG("FT1000:ft1000_ChPoll called when ft1000_flarion_cnt is zero\n");
+        DEBUG("FT1000:ft1000_poll_dev called when ft1000_flarion_cnt is zero\n");
         return (-EBADF);
     }
 
@@ -405,30 +405,30 @@ static unsigned int ft1000_ChPoll(struct file *file, poll_table *wait)
     // Search for matching file object
     for (i=0; i<MAX_NUM_APP; i++) {
         if ( info->app_info[i].fileobject == &file->f_owner) {
-            //DEBUG("FT1000:ft1000_ChIoctl: Message is for AppId = %d\n", info->app_info[i].app_id);
+            //DEBUG("FT1000:ft1000_ioctl: Message is for AppId = %d\n", info->app_info[i].app_id);
             break;
         }
     }
 
     // Could not find application info block
     if (i == MAX_NUM_APP) {
-        DEBUG("FT1000:ft1000_ChIoctl:Could not find application info block\n");
+        DEBUG("FT1000:ft1000_ioctl:Could not find application info block\n");
         return ( -EACCES );
     }
 
     if (list_empty(&info->app_info[i].app_sqlist) == 0) {
-        DEBUG("FT1000:ft1000_ChPoll:Message detected in slow queue\n");
+        DEBUG("FT1000:ft1000_poll_dev:Message detected in slow queue\n");
         return(POLLIN | POLLRDNORM | POLLPRI);
     }
 
     poll_wait (file, &info->app_info[i].wait_dpram_msg, wait);
-    //DEBUG("FT1000:ft1000_ChPoll:Polling for data from DSP\n");
+    //DEBUG("FT1000:ft1000_poll_dev:Polling for data from DSP\n");
 
     return (0);
 }
 
 //---------------------------------------------------------------------------
-// Function:    ft1000_ChIoctl
+// Function:    ft1000_ioctl
 //
 // Parameters:
 //
@@ -437,10 +437,10 @@ static unsigned int ft1000_ChPoll(struct file *file, poll_table *wait)
 // Notes:
 //
 //---------------------------------------------------------------------------
-static long ft1000_ChIoctl (struct file *File, unsigned int Command,
-                           unsigned long Argument)
+static long ft1000_ioctl (struct file *file, unsigned int command,
+                           unsigned long argument)
 {
-    void __user *argp = (void __user *)Argument;
+    void __user *argp = (void __user *)argument;
     struct net_device *dev;
 	struct ft1000_info *info;
     struct ft1000_device *ft1000dev;
@@ -462,25 +462,25 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
     unsigned short ledStat=0;
     unsigned short conStat=0;
 
-    //DEBUG("ft1000_ChIoctl called\n");
+    //DEBUG("ft1000_ioctl called\n");
 
     if (ft1000_flarion_cnt == 0) {
-        DEBUG("FT1000:ft1000_ChIoctl called when ft1000_flarion_cnt is zero\n");
+        DEBUG("FT1000:ft1000_ioctl called when ft1000_flarion_cnt is zero\n");
         return (-EBADF);
     }
 
-    //DEBUG("FT1000:ft1000_ChIoctl:Command = 0x%x Argument = 0x%8x\n", Command, (u32)Argument);
+    //DEBUG("FT1000:ft1000_ioctl:command = 0x%x argument = 0x%8x\n", command, (u32)argument);
 
-    dev = File->private_data;
+    dev = file->private_data;
 	info = netdev_priv(dev);
     ft1000dev = info->pFt1000Dev;
-    cmd = _IOC_NR(Command);
-    //DEBUG("FT1000:ft1000_ChIoctl:cmd = 0x%x\n", cmd);
+    cmd = _IOC_NR(command);
+    //DEBUG("FT1000:ft1000_ioctl:cmd = 0x%x\n", cmd);
 
     // process the command
     switch (cmd) {
     case IOCTL_REGISTER_CMD:
-            DEBUG("FT1000:ft1000_ChIoctl: IOCTL_FT1000_REGISTER called\n");
+            DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_REGISTER called\n");
             result = get_user(tempword, (__u16 __user*)argp);
             if (result) {
                 DEBUG("result = %d failed to get_user\n", result);
@@ -489,9 +489,9 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
             if (tempword == DSPBCMSGID) {
                 // Search for matching file object
                 for (i=0; i<MAX_NUM_APP; i++) {
-                    if ( info->app_info[i].fileobject == &File->f_owner) {
+                    if ( info->app_info[i].fileobject == &file->f_owner) {
                         info->app_info[i].DspBCMsgFlag = 1;
-                        DEBUG("FT1000:ft1000_ChIoctl:Registered for broadcast messages\n");
+                        DEBUG("FT1000:ft1000_ioctl:Registered for broadcast messages\n");
                         break;
                     }
                 }
@@ -499,34 +499,34 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
             break;
 
     case IOCTL_GET_VER_CMD:
-        DEBUG("FT1000:ft1000_ChIoctl: IOCTL_FT1000_GET_VER called\n");
+        DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_GET_VER called\n");
 
         get_ver_data.drv_ver = FT1000_DRV_VER;
 
         if (copy_to_user(argp, &get_ver_data, sizeof(get_ver_data)) ) {
-            DEBUG("FT1000:ft1000_ChIoctl: copy fault occurred\n");
+            DEBUG("FT1000:ft1000_ioctl: copy fault occurred\n");
             result = -EFAULT;
             break;
         }
 
-        DEBUG("FT1000:ft1000_ChIoctl:driver version = 0x%x\n",(unsigned int)get_ver_data.drv_ver);
+        DEBUG("FT1000:ft1000_ioctl:driver version = 0x%x\n",(unsigned int)get_ver_data.drv_ver);
 
         break;
     case IOCTL_CONNECT:
         // Connect Message
-        DEBUG("FT1000:ft1000_ChIoctl: IOCTL_FT1000_CONNECT\n");
+        DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_CONNECT\n");
         ConnectionMsg[79] = 0xfc;
 			   CardSendCommand(ft1000dev, (unsigned short *)ConnectionMsg, 0x4c);
 
         break;
     case IOCTL_DISCONNECT:
         // Disconnect Message
-        DEBUG("FT1000:ft1000_ChIoctl: IOCTL_FT1000_DISCONNECT\n");
+        DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_DISCONNECT\n");
         ConnectionMsg[79] = 0xfd;
 			   CardSendCommand(ft1000dev, (unsigned short *)ConnectionMsg, 0x4c);
         break;
     case IOCTL_GET_DSP_STAT_CMD:
-        //DEBUG("FT1000:ft1000_ChIoctl: IOCTL_FT1000_GET_DSP_STAT called\n");
+        //DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_GET_DSP_STAT called\n");
 	memset(&get_stat_data, 0, sizeof(get_stat_data));
         memcpy(get_stat_data.DspVer, info->DspVer, DSPVERSZ);
         memcpy(get_stat_data.HwSerNum, info->HwSerNum, HWSERNUMSZ);
@@ -536,10 +536,10 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
             if (info->ProgConStat != 0xFF) {
                 ft1000_read_dpram16(ft1000dev, FT1000_MAG_DSP_LED, (u8 *)&ledStat, FT1000_MAG_DSP_LED_INDX);
                 get_stat_data.LedStat = ntohs(ledStat);
-                DEBUG("FT1000:ft1000_ChIoctl: LedStat = 0x%x\n", get_stat_data.LedStat);
+                DEBUG("FT1000:ft1000_ioctl: LedStat = 0x%x\n", get_stat_data.LedStat);
                 ft1000_read_dpram16(ft1000dev, FT1000_MAG_DSP_CON_STATE, (u8 *)&conStat, FT1000_MAG_DSP_CON_STATE_INDX);
                 get_stat_data.ConStat = ntohs(conStat);
-                DEBUG("FT1000:ft1000_ChIoctl: ConStat = 0x%x\n", get_stat_data.ConStat);
+                DEBUG("FT1000:ft1000_ioctl: ConStat = 0x%x\n", get_stat_data.ConStat);
             }
             else {
                 get_stat_data.ConStat = 0x0f;
@@ -554,7 +554,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
         get_stat_data.ConTm = (u32)(tv.tv_sec - info->ConTm);
         DEBUG("Connection Time = %d\n", (int)get_stat_data.ConTm);
         if (copy_to_user(argp, &get_stat_data, sizeof(get_stat_data)) ) {
-            DEBUG("FT1000:ft1000_ChIoctl: copy fault occurred\n");
+            DEBUG("FT1000:ft1000_ioctl: copy fault occurred\n");
             result = -EFAULT;
             break;
         }
@@ -572,7 +572,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
             u16 app_index;
             u16 status;
 
-            //DEBUG("FT1000:ft1000_ChIoctl: IOCTL_FT1000_SET_DPRAM called\n");
+            //DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_SET_DPRAM called\n");
 
 
             if (ft1000_flarion_cnt == 0) {
@@ -591,15 +591,15 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
 
             if (info->CardReady) {
 
-               //DEBUG("FT1000:ft1000_ChIoctl: try to SET_DPRAM \n");
+               //DEBUG("FT1000:ft1000_ioctl: try to SET_DPRAM \n");
 
                 // Get the length field to see how many bytes to copy
                 result = get_user(msgsz, (__u16 __user *)argp);
                 msgsz = ntohs (msgsz);
-                //DEBUG("FT1000:ft1000_ChIoctl: length of message = %d\n", msgsz);
+                //DEBUG("FT1000:ft1000_ioctl: length of message = %d\n", msgsz);
 
                 if (msgsz > MAX_CMD_SQSIZE) {
-                    DEBUG("FT1000:ft1000_ChIoctl: bad message length = %d\n", msgsz);
+                    DEBUG("FT1000:ft1000_ioctl: bad message length = %d\n", msgsz);
                     result = -EINVAL;
                     break;
                 }
@@ -609,7 +609,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
 		if (!dpram_data)
 			break;
 
-                //if ( copy_from_user(&(dpram_command.dpram_blk), (PIOCTL_DPRAM_BLK)Argument, msgsz+2) ) {
+                //if ( copy_from_user(&(dpram_command.dpram_blk), (PIOCTL_DPRAM_BLK)argument, msgsz+2) ) {
                 if ( copy_from_user(dpram_data, argp, msgsz+2) ) {
                     DEBUG("FT1000:ft1000_ChIoctl: copy fault occurred\n");
                     result = -EFAULT;
@@ -624,7 +624,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
 #endif
                     // Check if this message came from a registered application
                     for (i=0; i<MAX_NUM_APP; i++) {
-                        if ( info->app_info[i].fileobject == &File->f_owner) {
+                        if ( info->app_info[i].fileobject == &file->f_owner) {
                             break;
                         }
                     }
@@ -639,14 +639,14 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
                     // Check message qtype type which is the lower byte within qos_class
                     //qtype = ntohs(dpram_command.dpram_blk.pseudohdr.qos_class) & 0xff;
                     qtype = ntohs(dpram_data->pseudohdr.qos_class) & 0xff;
-                    //DEBUG("FT1000_ft1000_ChIoctl: qtype = %d\n", qtype);
+                    //DEBUG("FT1000_ft1000_ioctl: qtype = %d\n", qtype);
                     if (qtype) {
                     }
                     else {
                         // Put message into Slow Queue
                         // Only put a message into the DPRAM if msg doorbell is available
                         status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOORBELL);
-                        //DEBUG("FT1000_ft1000_ChIoctl: READ REGISTER tempword=%x\n", tempword);
+                        //DEBUG("FT1000_ft1000_ioctl: READ REGISTER tempword=%x\n", tempword);
                         if (tempword & FT1000_DB_DPRAM_TX) {
                             // Suspend for 2ms and try again due to DSP doorbell busy
                             mdelay(2);
@@ -662,7 +662,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
                                         mdelay(3);
                                         status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOORBELL);
                                         if (tempword & FT1000_DB_DPRAM_TX) {
-                                            DEBUG("FT1000:ft1000_ChIoctl:Doorbell not available\n");
+                                            DEBUG("FT1000:ft1000_ioctl:Doorbell not available\n");
                                             result = -ENOTTY;
 						kfree(dpram_data);
                                             break;
@@ -672,7 +672,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
                             }
                         }
 
-                        //DEBUG("FT1000_ft1000_ChIoctl: finished reading register\n");
+                        //DEBUG("FT1000_ft1000_ioctl: finished reading register\n");
 
                         // Make sure we are within the limits of the slow queue memory limitation
                         if ( (msgsz < MAX_CMD_SQSIZE) && (msgsz > PSEUDOSZ) ) {
@@ -719,7 +719,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
                 }
             }
             else {
-                DEBUG("FT1000:ft1000_ChIoctl: Card not ready take messages\n");
+                DEBUG("FT1000:ft1000_ioctl: Card not ready take messages\n");
                 result = -EACCES;
             }
 	    kfree(dpram_data);
@@ -732,7 +732,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
             IOCTL_DPRAM_BLK __user *pioctl_dpram;
             int msglen;
 
-            //DEBUG("FT1000:ft1000_ChIoctl: IOCTL_FT1000_GET_DPRAM called\n");
+            //DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_GET_DPRAM called\n");
 
             if (ft1000_flarion_cnt == 0) {
                 return (-EBADF);
@@ -740,15 +740,15 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
 
             // Search for matching file object
             for (i=0; i<MAX_NUM_APP; i++) {
-                if ( info->app_info[i].fileobject == &File->f_owner) {
-                    //DEBUG("FT1000:ft1000_ChIoctl: Message is for AppId = %d\n", info->app_info[i].app_id);
+                if ( info->app_info[i].fileobject == &file->f_owner) {
+                    //DEBUG("FT1000:ft1000_ioctl: Message is for AppId = %d\n", info->app_info[i].app_id);
                     break;
                 }
             }
 
             // Could not find application info block
             if (i == MAX_NUM_APP) {
-                DEBUG("FT1000:ft1000_ChIoctl:Could not find application info block\n");
+                DEBUG("FT1000:ft1000_ioctl:Could not find application info block\n");
                 result = -EBADF;
                 break;
             }
@@ -756,22 +756,22 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
             result = 0;
             pioctl_dpram = argp;
             if (list_empty(&info->app_info[i].app_sqlist) == 0) {
-                //DEBUG("FT1000:ft1000_ChIoctl:Message detected in slow queue\n");
+                //DEBUG("FT1000:ft1000_ioctl:Message detected in slow queue\n");
                 spin_lock_irqsave(&free_buff_lock, flags);
                 pdpram_blk = list_entry(info->app_info[i].app_sqlist.next, struct dpram_blk, list);
                 list_del(&pdpram_blk->list);
                 info->app_info[i].NumOfMsg--;
-                //DEBUG("FT1000:ft1000_ChIoctl:NumOfMsg for app %d = %d\n", i, info->app_info[i].NumOfMsg);
+                //DEBUG("FT1000:ft1000_ioctl:NumOfMsg for app %d = %d\n", i, info->app_info[i].NumOfMsg);
                 spin_unlock_irqrestore(&free_buff_lock, flags);
                 msglen = ntohs(*(u16 *)pdpram_blk->pbuffer) + PSEUDOSZ;
                 result = get_user(msglen, &pioctl_dpram->total_len);
 		if (result)
 			break;
 		msglen = htons(msglen);
-                //DEBUG("FT1000:ft1000_ChIoctl:msg length = %x\n", msglen);
+                //DEBUG("FT1000:ft1000_ioctl:msg length = %x\n", msglen);
                 if(copy_to_user (&pioctl_dpram->pseudohdr, pdpram_blk->pbuffer, msglen))
 				{
-					DEBUG("FT1000:ft1000_ChIoctl: copy fault occurred\n");
+					DEBUG("FT1000:ft1000_ioctl: copy fault occurred\n");
 	             	result = -EFAULT;
 	             	break;
 				}
@@ -779,12 +779,12 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
                 ft1000_free_buffer(pdpram_blk, &freercvpool);
                 result = msglen;
             }
-            //DEBUG("FT1000:ft1000_ChIoctl: IOCTL_FT1000_GET_DPRAM no message\n");
+            //DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_GET_DPRAM no message\n");
         }
         break;
 
     default:
-        DEBUG("FT1000:ft1000_ChIoctl:unknown command: 0x%x\n", Command);
+        DEBUG("FT1000:ft1000_ioctl:unknown command: 0x%x\n", command);
         result = -ENOTTY;
         break;
     }
@@ -793,7 +793,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
 }
 
 //---------------------------------------------------------------------------
-// Function:    ft1000_ChRelease
+// Function:    ft1000_release
 //
 // Parameters:
 //
@@ -802,16 +802,16 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
 // Notes:
 //
 //---------------------------------------------------------------------------
-static int ft1000_ChRelease (struct inode *Inode, struct file *File)
+static int ft1000_release (struct inode *inode, struct file *file)
 {
 	struct ft1000_info *info;
     struct net_device *dev;
     int i;
 	struct dpram_blk *pdpram_blk;
 
-    DEBUG("ft1000_ChRelease called\n");
+    DEBUG("ft1000_release called\n");
 
-    dev = File->private_data;
+    dev = file->private_data;
 	info = netdev_priv(dev);
 
     if (ft1000_flarion_cnt == 0) {
@@ -821,8 +821,8 @@ static int ft1000_ChRelease (struct inode *Inode, struct file *File)
 
     // Search for matching file object
     for (i=0; i<MAX_NUM_APP; i++) {
-        if ( info->app_info[i].fileobject == &File->f_owner) {
-            //DEBUG("FT1000:ft1000_ChIoctl: Message is for AppId = %d\n", info->app_info[i].app_id);
+        if ( info->app_info[i].fileobject == &file->f_owner) {
+            //DEBUG("FT1000:ft1000_ioctl: Message is for AppId = %d\n", info->app_info[i].app_id);
             break;
         }
     }
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 69f920f..7456787 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -952,7 +952,7 @@ int reg_ft1000_netdev(struct ft1000_device *ft1000dev, struct usb_interface *int
 
 
     //Create character device, implemented by Jim
-    ft1000_CreateDevice(ft1000dev);
+    ft1000_create_dev(ft1000dev);
 
     DEBUG ("reg_ft1000_netdev returned\n");
 
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index d71ac30..7dfed41 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -231,7 +231,7 @@ static void ft1000_disconnect(struct usb_interface *interface)
 
 		if (pft1000info->pFt1000Dev->net) {
 			DEBUG("ft1000_disconnect: destroy char driver\n");
-			ft1000_DestroyDevice(pft1000info->pFt1000Dev->net);
+			ft1000_destroy_dev(pft1000info->pFt1000Dev->net);
 			unregister_netdev(pft1000info->pFt1000Dev->net);
 			DEBUG
 			    ("ft1000_disconnect: network device unregisterd\n");
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 2c89d14..045ef30 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -579,8 +579,8 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, u32  FileLeng
 extern struct list_head freercvpool;
 extern spinlock_t free_buff_lock;   // lock to arbitrate free buffer list for receive command data
 
-int ft1000_CreateDevice(struct ft1000_device *dev);
-void ft1000_DestroyDevice(struct net_device *dev);
+int ft1000_create_dev(struct ft1000_device *dev);
+void ft1000_destroy_dev(struct net_device *dev);
 extern void CardSendCommand(struct ft1000_device *ft1000dev, void *ptempbuffer, int size);
 
 struct dpram_blk *ft1000_get_buffer(struct list_head *bufflist);
-- 
1.7.1

