Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964871Ab2GLVvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 17:51:43 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35733 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964827Ab2GLVvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 17:51:11 -0400
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 8/8] staging: ft1000-usb: Fix various checkpach warnings in ft1000_usb.h
Date: Thu, 12 Jul 2012 23:50:50 +0200
Message-Id: <1342129850-32209-8-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342129850-32209-1-git-send-email-marek.belisko@open-nandra.com>
References: <1342129850-32209-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 58cc54b..642bb89 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -24,7 +24,7 @@ struct app_info_block {
 	int NumOfMsg;                   /* number of messages queued up */
 	wait_queue_head_t wait_dpram_msg;
 	struct list_head app_sqlist;   /* link list of msgs for applicaton on slow queue */
-} __attribute__((packed));
+} __packed;
 
 #define DEBUG(args...) printk(KERN_INFO args)
 
@@ -57,8 +57,7 @@ struct app_info_block {
 
 #define MAX_BUF_SIZE            4096
 
-struct ft1000_device
-{
+struct ft1000_device {
 	struct usb_device *dev;
 	struct net_device *net;
 
@@ -72,7 +71,7 @@ struct ft1000_device
 
 	u8 bulk_in_endpointAddr;
 	u8 bulk_out_endpointAddr;
-} __attribute__ ((packed));
+} __packed;
 
 struct ft1000_debug_dirs {
 	struct list_head list;
@@ -142,10 +141,10 @@ struct ft1000_info {
 struct dpram_blk {
 	struct list_head list;
 	u16 *pbuffer;
-} __attribute__ ((packed));
+} __packed;
 
 int ft1000_read_register(struct ft1000_device *ft1000dev,
-			u16* Data, u16 nRegIndx);
+			u16 *Data, u16 nRegIndx);
 int ft1000_write_register(struct ft1000_device *ft1000dev,
 			u16 value, u16 nRegIndx);
 int ft1000_read_dpram32(struct ft1000_device *ft1000dev,
@@ -165,7 +164,7 @@ extern void *pFileStart;
 extern size_t FileLength;
 extern int numofmsgbuf;
 
-int ft1000_close (struct net_device *dev);
+int ft1000_close(struct net_device *dev);
 u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart,
 		u32  FileLength);
 
@@ -186,7 +185,7 @@ int init_ft1000_netdev(struct ft1000_device *ft1000dev);
 struct usb_interface;
 int reg_ft1000_netdev(struct ft1000_device *ft1000dev,
 			struct usb_interface *intf);
-int ft1000_poll(void* dev_id);
+int ft1000_poll(void *dev_id);
 
 int ft1000_init_proc(struct net_device *dev);
 void ft1000_cleanup_proc(struct ft1000_info *info);
-- 
1.7.9.5

