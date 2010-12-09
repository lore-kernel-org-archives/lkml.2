Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab0LIPLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 10:11:34 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:39761 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214Ab0LIPLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 10:11:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=ZLW1k07CPfY+dKafPk4XrfwVoRAnTqBPVASO6e5wD1wAX4VcryBb+sXB4J9qHKC6Jc
         5pB8GBZIyb5F/8Pkg0Ulw40I5+LNSUdv7V4z6CKzPLJpk+Uc1NfDO8t7EgcgqkFjvFEi
         km2lOMBJD4ybzmSu2Ikmrbf9nG1EmPhFIffPA=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 2/8] staging: ft1000: Fix coding style.
Date: Thu,  9 Dec 2010 16:13:48 +0100
Message-Id: <1291907634-22437-2-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291907634-22437-1-git-send-email-marek.belisko@open-nandra.com>
References: <1291907634-22437-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style in ft1000CleanupProc and ft1000InitProc
functions.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c |   25 +++++++++++------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
index dbd4a1c..f197523 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
@@ -196,12 +196,12 @@ static struct notifier_block ft1000_netdev_notifier = {
 int ft1000InitProc(struct net_device *dev)
 {
 	struct ft1000_info *info;
-  struct proc_dir_entry *ft1000_proc_file;
+	struct proc_dir_entry *ft1000_proc_file;
 	int ret = 0;
 
 	info = netdev_priv(dev);
 
-  info->ft1000_proc_dir = proc_mkdir (FT1000_PROC_DIR, FTNET_PROC);
+	info->ft1000_proc_dir = proc_mkdir(FT1000_PROC_DIR, FTNET_PROC);
 	if (info->ft1000_proc_dir == NULL) {
 		printk(KERN_WARNING "Unable to create %s dir.\n",
 			FT1000_PROC_DIR);
@@ -209,16 +209,18 @@ int ft1000InitProc(struct net_device *dev)
 		goto fail;
 	}
 
-  ft1000_proc_file =
-    create_proc_read_entry (dev->name, 0644, info->ft1000_proc_dir,
-			    ft1000ReadProc, dev);
+	ft1000_proc_file =
+		create_proc_read_entry(dev->name, 0644,
+			info->ft1000_proc_dir, ft1000ReadProc, dev);
+
 	if (ft1000_proc_file == NULL) {
 		printk(KERN_WARNING "Unable to create /proc entry.\n");
 		ret = -EINVAL;
 		goto fail_entry;
 	}
 
-  snprintf (info->netdevname, IFNAMSIZ, "%s", dev->name);
+	snprintf(info->netdevname, IFNAMSIZ, "%s", dev->name);
+
 	ret = register_netdevice_notifier(&ft1000_netdev_notifier);
 	if (ret)
 		goto fail_notif;
@@ -233,12 +235,9 @@ fail:
 	return ret;
 }
 
-void
-ft1000CleanupProc(struct ft1000_info *info)
+void ft1000CleanupProc(struct ft1000_info *info)
 {
-  remove_proc_entry (info->netdevname, info->ft1000_proc_dir);
-  remove_proc_entry (FT1000_PROC_DIR, FTNET_PROC);
-  unregister_netdevice_notifier (&ft1000_netdev_notifier);
-
-  return;
+	remove_proc_entry(info->netdevname, info->ft1000_proc_dir);
+	remove_proc_entry(FT1000_PROC_DIR, FTNET_PROC);
+	unregister_netdevice_notifier(&ft1000_netdev_notifier);
 }
-- 
1.7.1

