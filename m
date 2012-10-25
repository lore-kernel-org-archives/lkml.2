Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935638Ab2JYNQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:16:38 -0400
Received: from forward5.mail.yandex.net ([77.88.46.21]:33353 "EHLO
	forward5.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759520Ab2JYNQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:16:35 -0400
X-Greylist: delayed 348 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Oct 2012 09:16:35 EDT
From: Igor Murzov <e-mail@date.by>
To: Alex Deucher <alexander.deucher@amd.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Igor Murzov <e-mail@date.by>
Subject: [PATCH 2/2] vga_switcheroo: Drop unused include and unused variables.
Date: Thu, 25 Oct 2012 17:09:01 +0400
Message-Id: <1351170541-22570-2-git-send-email-e-mail@date.by>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1351170541-22570-1-git-send-email-e-mail@date.by>
References: <1351170541-22570-1-git-send-email-e-mail@date.by>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Igor Murzov <e-mail@date.by>
---
 drivers/gpu/vga/vga_switcheroo.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/gpu/vga/vga_switcheroo.c b/drivers/gpu/vga/vga_switcheroo.c
index e25cf31..fa60add 100644
--- a/drivers/gpu/vga/vga_switcheroo.c
+++ b/drivers/gpu/vga/vga_switcheroo.c
@@ -18,7 +18,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/dmi.h>
 #include <linux/seq_file.h>
 #include <linux/uaccess.h>
 #include <linux/fs.h>
@@ -376,7 +375,6 @@ vga_switcheroo_debugfs_write(struct file *filp, const char __user *ubuf,
 			     size_t cnt, loff_t *ppos)
 {
 	char usercmd[64];
-	const char *pdev_name;
 	int ret;
 	bool delay = false, can_switch;
 	bool just_mux = false;
@@ -468,7 +466,6 @@ vga_switcheroo_debugfs_write(struct file *filp, const char __user *ubuf,
 		goto out;
 
 	if (can_switch) {
-		pdev_name = pci_name(client->pdev);
 		ret = vga_switchto_stage1(client);
 		if (ret)
 			printk(KERN_ERR "vga_switcheroo: switching failed stage 1 %d\n", ret);
@@ -540,7 +537,6 @@ fail:
 int vga_switcheroo_process_delayed_switch(void)
 {
 	struct vga_switcheroo_client *client;
-	const char *pdev_name;
 	int ret;
 	int err = -EINVAL;
 
@@ -555,7 +551,6 @@ int vga_switcheroo_process_delayed_switch(void)
 	if (!client || !check_can_switch())
 		goto err;
 
-	pdev_name = pci_name(client->pdev);
 	ret = vga_switchto_stage2(client);
 	if (ret)
 		printk(KERN_ERR "vga_switcheroo: delayed switching failed stage 2 %d\n", ret);
@@ -567,4 +562,3 @@ err:
 	return err;
 }
 EXPORT_SYMBOL(vga_switcheroo_process_delayed_switch);
-
-- 
1.7.12.1

