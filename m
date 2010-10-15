Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab0JOHTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 03:19:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45248 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273Ab0JOHTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 03:19:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=X2CS0UTzsiNJ+BqveZkatknrcspufZ0olYzs2BojbmqZmUU+natJc7VQCzda524Cl5
         aG9Ub0lCChwRD7TljroGyoMUBJ/gZG0PsdoCbVbpK2ZyI6qcneDN28aXeOM7F5F7uafv
         MJXNftbZ6UmidKEifbi1pPHk71e6YEfF4iMdU=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH] staging:ft1000: Get rid of using typedef.
Date: Fri, 15 Oct 2010 09:21:19 +0200
Message-Id: <1287127279-14209-1-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c |   26 +++++++++++-----------
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c    |    8 +++---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h   |    8 +++---
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
index 3325e87..539607f 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
@@ -172,10 +172,10 @@ static int rm_mknod (void *pdata)
 // Notes:
 //
 //---------------------------------------------------------------------------
-PDPRAM_BLK ft1000_get_buffer (struct list_head *bufflist)
+struct dpram_blk *ft1000_get_buffer (struct list_head *bufflist)
 {
     unsigned long flags;
-    PDPRAM_BLK ptr;
+    struct dpram_blk *ptr;
 
     spin_lock_irqsave(&free_buff_lock, flags);
     // Check if buffer is available
@@ -185,7 +185,7 @@ PDPRAM_BLK ft1000_get_buffer (struct list_head *bufflist)
     }
     else {
         numofmsgbuf--;
-        ptr = list_entry(bufflist->next, DPRAM_BLK, list);
+        ptr = list_entry(bufflist->next, struct dpram_blk, list);
         list_del(&ptr->list);
         //DEBUG("ft1000_get_buffer: number of free msg buffers = %d\n", numofmsgbuf);
     }
@@ -209,7 +209,7 @@ PDPRAM_BLK ft1000_get_buffer (struct list_head *bufflist)
 // Notes:
 //
 //---------------------------------------------------------------------------
-void ft1000_free_buffer (PDPRAM_BLK pdpram_blk, struct list_head *plist)
+void ft1000_free_buffer (struct dpram_blk *pdpram_blk, struct list_head *plist)
 {
     unsigned long flags;
 
@@ -299,7 +299,7 @@ int ft1000_CreateDevice(struct ft1000_device *dev)
 //        // create list of free buffers
 //        for (i=0; i<NUM_OF_FREE_BUFFERS; i++) {
 //            // Get memory for DPRAM_DATA link list
-//            pdpram_blk = kmalloc ( sizeof(DPRAM_BLK), GFP_KERNEL );
+//            pdpram_blk = kmalloc ( sizeof(struct dpram_blk), GFP_KERNEL );
 //            // Get a block of memory to store command data
 //            pdpram_blk->pbuffer = kmalloc ( MAX_CMD_SQSIZE, GFP_KERNEL );
 //            // link provisioning data
@@ -353,8 +353,8 @@ void ft1000_DestroyDevice(struct net_device *dev)
     int result = 0;
     pid_t pid;
 		int i;
-    PDPRAM_BLK pdpram_blk;
-    DPRAM_BLK *ptr;
+    struct dpram_blk *pdpram_blk;
+    struct dpram_blk *ptr;
 
     DEBUG("ft1000_chdev:ft1000_DestroyDevice called\n");
 
@@ -372,7 +372,7 @@ void ft1000_DestroyDevice(struct net_device *dev)
         // Make sure we free any memory reserve for slow Queue
         for (i=0; i<MAX_NUM_APP; i++) {
             while (list_empty(&info->app_info[i].app_sqlist) == 0) {
-                pdpram_blk = list_entry(info->app_info[i].app_sqlist.next, DPRAM_BLK, list);
+                pdpram_blk = list_entry(info->app_info[i].app_sqlist.next, struct dpram_blk, list);
                 list_del(&pdpram_blk->list);
                 ft1000_free_buffer(pdpram_blk, &freercvpool);
 
@@ -383,7 +383,7 @@ void ft1000_DestroyDevice(struct net_device *dev)
         // Remove buffer allocated for receive command data
         if (ft1000_flarion_cnt == 0) {
             while (list_empty(&freercvpool) == 0) {
-                ptr = list_entry(freercvpool.next, DPRAM_BLK, list);
+                ptr = list_entry(freercvpool.next, struct dpram_blk, list);
                 list_del(&ptr->list);
                 kfree(ptr->pbuffer);
                 kfree(ptr);
@@ -817,7 +817,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
         break;
     case IOCTL_GET_DPRAM_CMD:
         {
-            PDPRAM_BLK pdpram_blk;
+            struct dpram_blk *pdpram_blk;
             IOCTL_DPRAM_BLK __user *pioctl_dpram;
             int msglen;
 
@@ -847,7 +847,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
             if (list_empty(&info->app_info[i].app_sqlist) == 0) {
                 //DEBUG("FT1000:ft1000_ChIoctl:Message detected in slow queue\n");
                 spin_lock_irqsave(&free_buff_lock, flags);
-                pdpram_blk = list_entry(info->app_info[i].app_sqlist.next, DPRAM_BLK, list);
+                pdpram_blk = list_entry(info->app_info[i].app_sqlist.next, struct dpram_blk, list);
                 list_del(&pdpram_blk->list);
                 info->app_info[i].NumOfMsg--;
                 //DEBUG("FT1000:ft1000_ChIoctl:NumOfMsg for app %d = %d\n", i, info->app_info[i].NumOfMsg);
@@ -896,7 +896,7 @@ static int ft1000_ChRelease (struct inode *Inode, struct file *File)
     PFT1000_INFO info;
     struct net_device *dev;
     int i;
-    PDPRAM_BLK pdpram_blk;
+    struct dpram_blk *pdpram_blk;
 
     DEBUG("ft1000_ChRelease called\n");
 
@@ -921,7 +921,7 @@ static int ft1000_ChRelease (struct inode *Inode, struct file *File)
 
     while (list_empty(&info->app_info[i].app_sqlist) == 0) {
         DEBUG("Remove and free memory queue up on slow queue\n");
-        pdpram_blk = list_entry(info->app_info[i].app_sqlist.next, DPRAM_BLK, list);
+        pdpram_blk = list_entry(info->app_info[i].app_sqlist.next, struct dpram_blk, list);
         list_del(&pdpram_blk->list);
         ft1000_free_buffer(pdpram_blk, &freercvpool);
     }
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index a218455..999abb6 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -947,7 +947,7 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
 {
     struct net_device *netdev;
     FT1000_INFO *pInfo = NULL;
-    PDPRAM_BLK pdpram_blk;
+    struct dpram_blk *pdpram_blk;
 	int i, ret_val;
 	struct list_head *cur, *tmp;
 	char card_nr[2];
@@ -1063,7 +1063,7 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
         // create list of free buffers
         for (i=0; i<NUM_OF_FREE_BUFFERS; i++) {
             // Get memory for DPRAM_DATA link list
-            pdpram_blk = kmalloc ( sizeof(DPRAM_BLK), GFP_KERNEL );
+            pdpram_blk = kmalloc ( sizeof(struct dpram_blk), GFP_KERNEL );
 		if (pdpram_blk == NULL) {
 			ret_val = -ENOMEM;
 			goto err_free;
@@ -1086,7 +1086,7 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
 
 err_free:
 	list_for_each_safe(cur, tmp, &pdpram_blk->list) {
-		pdpram_blk = list_entry(cur, DPRAM_BLK, list);
+		pdpram_blk = list_entry(cur, struct dpram_blk, list);
 		list_del(&pdpram_blk->list);
 		kfree(pdpram_blk->pbuffer);
 		kfree(pdpram_blk);
@@ -2526,7 +2526,7 @@ int ft1000_poll(void* dev_id) {
     USHORT modulo;
     USHORT portid;
     u16 nxtph;
-    PDPRAM_BLK pdpram_blk;
+    struct dpram_blk *pdpram_blk;
     PPSEUDO_HDR ppseudo_hdr;
     unsigned long flags;
 
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 764e9f2..27ee304 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -598,10 +598,10 @@ typedef struct _FT1000_INFO {
 } FT1000_INFO, *PFT1000_INFO;
 
 
-typedef struct _DPRAM_BLK {
+struct dpram_blk {
     struct list_head list;
     u16 *pbuffer;
-} __attribute__ ((packed)) DPRAM_BLK, *PDPRAM_BLK;
+} __attribute__ ((packed));
 
 u16 ft1000_read_register(struct ft1000_device *ft1000dev, u16* Data, u16 nRegIndx);
 u16 ft1000_write_register(struct ft1000_device *ft1000dev, USHORT value, u16 nRegIndx);
@@ -626,8 +626,8 @@ int ft1000_CreateDevice(struct ft1000_device *dev);
 void ft1000_DestroyDevice(struct net_device *dev);
 extern void CardSendCommand(struct ft1000_device *ft1000dev, void *ptempbuffer, int size);
 
-PDPRAM_BLK ft1000_get_buffer (struct list_head *bufflist);
-void ft1000_free_buffer (PDPRAM_BLK pdpram_blk, struct list_head *plist);
+struct dpram_blk *ft1000_get_buffer (struct list_head *bufflist);
+void ft1000_free_buffer (struct dpram_blk *pdpram_blk, struct list_head *plist);
 
 char *getfw (char *fn, size_t *pimgsz);
 
-- 
1.7.1

