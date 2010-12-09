Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab0LIPLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 10:11:37 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:36848 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab0LIPLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 10:11:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Frxo1qbFN57U15t8bwYE4l+14nW3Xw2Yfh1Rrp4Q/x0uW/5wHRFHo4GBSS/U2I08rv
         4X8zNaO0yeTrS53SCdQTnka4afSqQJnCz8nI4jbFvI83SmjJ0+qKkUxdYw+7sDSDAJBr
         yLGewJDYt21IjZ4FEjRSzgrc25b7QvucDH0BI=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 4/8] staging: ft1000: Fix coding style in ft1000NotifyProc.
Date: Thu,  9 Dec 2010 16:13:50 +0100
Message-Id: <1291907634-22437-4-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291907634-22437-1-git-send-email-marek.belisko@open-nandra.com>
References: <1291907634-22437-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c |   33 +++++++++++------------
 1 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
index f197523..c3fca23 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
@@ -166,30 +166,29 @@ ft1000ReadProc (char *page, char **start, off_t off, int count, int *eof,
 }
 
 static int
-ft1000NotifyProc (struct notifier_block *this, unsigned long event, void *ptr)
+ft1000NotifyProc(struct notifier_block *this, unsigned long event, void *ptr)
 {
-  struct net_device *dev = ptr;
+	struct net_device *dev = ptr;
 	struct ft1000_info *info;
-  struct proc_dir_entry *ft1000_proc_file;
+	struct proc_dir_entry *ft1000_proc_file;
 
-info = netdev_priv(dev);
+	info = netdev_priv(dev);
 
+	switch (event) {
+	case NETDEV_CHANGENAME:
+		remove_proc_entry(info->netdevname, info->ft1000_proc_dir);
+		ft1000_proc_file = create_proc_read_entry(dev->name, 0644,
+					info->ft1000_proc_dir,
+					ft1000ReadProc, dev);
+		snprintf(info->netdevname, IFNAMSIZ, "%s", dev->name);
+		break;
+	}
 
-  switch (event)
-    {
-    case NETDEV_CHANGENAME:
-      remove_proc_entry (info->netdevname, info->ft1000_proc_dir);
-      ft1000_proc_file = create_proc_read_entry (dev->name, 0644,
-						 info->ft1000_proc_dir,
-						 ft1000ReadProc, dev);
-      snprintf (info->netdevname, IFNAMSIZ, "%s", dev->name);
-      break;
-    }
-  return NOTIFY_DONE;
+	return NOTIFY_DONE;
 }
 
 static struct notifier_block ft1000_netdev_notifier = {
-  .notifier_call = ft1000NotifyProc
+	.notifier_call = ft1000NotifyProc,
 };
 
 
-- 
1.7.1

