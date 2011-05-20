Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513Ab1ETNPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:15:14 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42322 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933094Ab1ETNPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:15:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jPW8Ks5gdYNVtFSTHeXDHCQV/JKNtESVgUMncqvjVsuISWO9VMt54f2LvHYUO0sk52
         lVvUT5ma2laLVtTDnysCTi+dEa8RWdl4wd+6lcCtAFiVA8Q5Rk8n1SUBwnfDojJuygE1
         XTbdHVlAkzIFAh6vIGaxjDlpjEI7i1ITeRbpc=
From: Wanlong Gao <wanlong.gao@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH] drivers:mtd:fix the bad format in the mtdcore.c
Date: Fri, 20 May 2011 21:14:30 +0800
Message-Id: <1305897270-3685-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the spare spaces in the head of the lines.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 drivers/mtd/mtdcore.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 8e19091..f3c9400 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -444,7 +444,7 @@ void register_mtd_user (struct mtd_notifier *new)
 
 	list_add(&new->list, &mtd_notifiers);
 
- 	__module_get(THIS_MODULE);
+	__module_get(THIS_MODULE);
 
 	mtd_for_each_device(mtd)
 		new->add(mtd);
@@ -707,9 +707,9 @@ static int mtd_proc_show(struct seq_file *m, void *v)
 		seq_printf(m, "mtd%d: %8.8llx %8.8x \"%s\"\n",
 			   mtd->index, (unsigned long long)mtd->size,
 			   mtd->erasesize, mtd->name);
-        }
+	}
 	mutex_unlock(&mtd_table_mutex);
-        return 0;
+	return 0;
 }
 
 static int mtd_proc_open(struct inode *inode, struct file *file)
@@ -781,7 +781,7 @@ err_reg:
 static void __exit cleanup_mtd(void)
 {
 #ifdef CONFIG_PROC_FS
-        if (proc_mtd)
+	if (proc_mtd)
 		remove_proc_entry( "mtd", NULL);
 #endif /* CONFIG_PROC_FS */
 	class_unregister(&mtd_class);
-- 
1.7.4.1

