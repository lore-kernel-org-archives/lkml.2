Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab0LNIkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 03:40:10 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:32957 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603Ab0LNIkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 03:40:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=YT3kJVYwTop2KdNBdi4RTqMAhwKpothA6RrdOoqzDd0cCN8bHnDMnPPp5O5hO6brHA
         0GifRuSsGjzoGEp43ed0fFvcus6fkEHQ4SpIwMajq6qqfa6cVvKzx61DkzQOLViwPUmW
         XronP98j2giKr4gGbwEZrLY90O0b9H9f+mnmU=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 1/2] staging: ft1000: Fix camelcase function names.
Date: Tue, 14 Dec 2010 09:42:27 +0100
Message-Id: <1292316148-9769-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c |    4 ++--
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c  |    4 ++--
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h  |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
index 0f271c2..b87542a 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
@@ -201,7 +201,7 @@ static struct notifier_block ft1000_netdev_notifier = {
 };
 
 
-int ft1000InitProc(struct net_device *dev)
+int ft1000_init_proc(struct net_device *dev)
 {
 	struct ft1000_info *info;
 	struct proc_dir_entry *ft1000_proc_file;
@@ -243,7 +243,7 @@ fail:
 	return ret;
 }
 
-void ft1000CleanupProc(struct ft1000_info *info)
+void ft1000_cleanup_proc(struct ft1000_info *info)
 {
 	remove_proc_entry(info->netdevname, info->ft1000_proc_dir);
 	remove_proc_entry(FT1000_PROC_DIR, FTNET_PROC);
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index 0e1fc3f..79482ac 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -198,7 +198,7 @@ static int ft1000_probe(struct usb_interface *interface,
 	if (ret)
 		goto err_thread;
 
-	ret = ft1000InitProc(ft1000dev->net);
+	ret = ft1000_init_proc(ft1000dev->net);
 	if (ret)
 		goto err_proc;
 
@@ -228,7 +228,7 @@ static void ft1000_disconnect(struct usb_interface *interface)
 	DEBUG("In disconnect pft1000info=%p\n", pft1000info);
 
 	if (pft1000info) {
-		ft1000CleanupProc(pft1000info);
+		ft1000_cleanup_proc(pft1000info);
 		if (pft1000info->pPollThread)
 			kthread_stop(pft1000info->pPollThread);
 
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 4a91469..a143e9c 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -594,8 +594,8 @@ struct usb_interface;
 int reg_ft1000_netdev(struct ft1000_device *ft1000dev, struct usb_interface *intf);
 int ft1000_poll(void* dev_id);
 
-int ft1000InitProc(struct net_device *dev);
-void ft1000CleanupProc(struct ft1000_info *info);
+int ft1000_init_proc(struct net_device *dev);
+void ft1000_cleanup_proc(struct ft1000_info *info);
 
 
 
-- 
1.7.1

