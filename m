Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab1CGIVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:21:44 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49168 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab1CGIVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:21:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Jyrk2IbiCRX0F9QusSKb/NQLLKp/BTpDHpcJBb8d5y6XWcR9+MKguppXKh9I4xTEN3
         celyhmKFDdAMx+rOAyjUk+J8fhvkI5DfJbE4Lt9+YEiV9ix5nYIyrzuIvorzpcxEh5r8
         x6l+O9B0TJ9N6ikDDtqFk6Nx3qamgLQKMYUZI=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 01/21] staging: ft1000: Replace camelcase CardSendCommand function name.
Date: Mon,  7 Mar 2011 09:21:06 +0100
Message-Id: <1299486086-7325-2-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299486086-7325-1-git-send-email-marek.belisko@open-nandra.com>
References: <1299486086-7325-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace CardSendCommand by card_send_command.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c |    6 +++---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c    |   18 +++++++++---------
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h   |    2 +-
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
index 149ba59..19db23f 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
@@ -471,14 +471,14 @@ static long ft1000_ioctl (struct file *file, unsigned int command,
         // Connect Message
         DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_CONNECT\n");
         ConnectionMsg[79] = 0xfc;
-			   CardSendCommand(ft1000dev, (unsigned short *)ConnectionMsg, 0x4c);
+			   card_send_command(ft1000dev, (unsigned short *)ConnectionMsg, 0x4c);
 
         break;
     case IOCTL_DISCONNECT:
         // Disconnect Message
         DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_DISCONNECT\n");
         ConnectionMsg[79] = 0xfd;
-			   CardSendCommand(ft1000dev, (unsigned short *)ConnectionMsg, 0x4c);
+			   card_send_command(ft1000dev, (unsigned short *)ConnectionMsg, 0x4c);
         break;
     case IOCTL_GET_DSP_STAT_CMD:
         //DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_GET_DSP_STAT called\n");
@@ -642,7 +642,7 @@ static long ft1000_ioctl (struct file *file, unsigned int command,
                             }
                             pmsg++;
 				ppseudo_hdr = (struct pseudo_hdr *)pmsg;
-                           CardSendCommand(ft1000dev,(unsigned short*)dpram_data,total_len+2);
+                           card_send_command(ft1000dev,(unsigned short*)dpram_data,total_len+2);
 
 
                             info->app_info[app_index].nTxMsg++;
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index e3b9934..293a469 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -467,7 +467,7 @@ static void card_reset_dsp(struct ft1000_device *ft1000dev, bool value)
 }
 
 //---------------------------------------------------------------------------
-// Function:    CardSendCommand
+// Function:    card_send_command
 //
 // Parameters:  ft1000_device  - device structure
 //              ptempbuffer - command buffer
@@ -481,17 +481,17 @@ static void card_reset_dsp(struct ft1000_device *ft1000dev, bool value)
 // Notes:
 //
 //---------------------------------------------------------------------------
-void CardSendCommand(struct ft1000_device *ft1000dev, void *ptempbuffer, int size)
+void card_send_command(struct ft1000_device *ft1000dev, void *ptempbuffer, int size)
 {
     unsigned short temp;
     unsigned char *commandbuf;
 
-    DEBUG("CardSendCommand: enter CardSendCommand... size=%d\n", size);
+    DEBUG("card_send_command: enter card_send_command... size=%d\n", size);
 
     commandbuf =(unsigned char*) kmalloc(size+2, GFP_KERNEL);
     memcpy((void*)commandbuf+2, (void*)ptempbuffer, size);
 
-    //DEBUG("CardSendCommand: Command Send\n");
+    //DEBUG("card_send_command: Command Send\n");
 
     ft1000_read_register(ft1000dev, &temp, FT1000_REG_DOORBELL);
 
@@ -509,18 +509,18 @@ void CardSendCommand(struct ft1000_device *ft1000dev, void *ptempbuffer, int siz
     }
 
 
-    //DEBUG("CardSendCommand: write dpram ... size=%d\n", size);
+    //DEBUG("card_send_command: write dpram ... size=%d\n", size);
     ft1000_write_dpram32(ft1000dev, 0,commandbuf, size);
     msleep(1);
-    //DEBUG("CardSendCommand: write into doorbell ...\n");
+    //DEBUG("card_send_command: write into doorbell ...\n");
     ft1000_write_register(ft1000dev,  FT1000_DB_DPRAM_TX ,FT1000_REG_DOORBELL) ;
     msleep(1);
 
     ft1000_read_register(ft1000dev, &temp, FT1000_REG_DOORBELL);
-    //DEBUG("CardSendCommand: read doorbell ...temp=%x\n", temp);
+    //DEBUG("card_send_command: read doorbell ...temp=%x\n", temp);
     if ( (temp & 0x0100) == 0)
     {
-       //DEBUG("CardSendCommand: Message sent\n");
+       //DEBUG("card_send_command: Message sent\n");
     }
 
 }
@@ -1811,7 +1811,7 @@ static int ft1000_proc_drvmsg (struct ft1000_device *dev, u16 size) {
                   *pmsg++ = convert.wrd;
                   *pmsg++ = htons(info->DrvErrNum);
 
-                  CardSendCommand (dev, (unsigned char*)&tempbuffer[0], (u16)(0x0012 + PSEUDOSZ));
+                  card_send_command (dev, (unsigned char*)&tempbuffer[0], (u16)(0x0012 + PSEUDOSZ));
                   info->DrvErrNum = 0;
               }
               info->DrvMsgPend = 0;
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 88183fe..84ff53d 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -581,7 +581,7 @@ extern spinlock_t free_buff_lock;   // lock to arbitrate free buffer list for re
 
 int ft1000_create_dev(struct ft1000_device *dev);
 void ft1000_destroy_dev(struct net_device *dev);
-extern void CardSendCommand(struct ft1000_device *ft1000dev, void *ptempbuffer, int size);
+extern void card_send_command(struct ft1000_device *ft1000dev, void *ptempbuffer, int size);
 
 struct dpram_blk *ft1000_get_buffer(struct list_head *bufflist);
 void ft1000_free_buffer(struct dpram_blk *pdpram_blk, struct list_head *plist);
-- 
1.7.1

