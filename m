Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab2KZIff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 03:35:35 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45052 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab2KZIfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 03:35:21 -0500
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joel Becker <jlbec@evilplan.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [RFC][PATCH] fs: configfs: allow other kernel parts to
 programmatically create config groups
Date: Mon, 26 Nov 2012 09:35:10 +0100
Message-id: <1353918910-12381-2-git-send-email-andrzej.p@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1353918910-12381-1-git-send-email-andrzej.p@samsung.com>
References: <1353918910-12381-1-git-send-email-andrzej.p@samsung.com>
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 fs/configfs/dir.c        |    5 +++--
 include/linux/configfs.h |    2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 7414ae2..42608dc 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -656,7 +656,7 @@ static void detach_groups(struct config_group *group)
  * We could, perhaps, tweak our parent's ->mkdir for a minute and
  * try using vfs_mkdir.  Just a thought.
  */
-static int create_default_group(struct config_group *parent_group,
+int create_group(struct config_group *parent_group,
 				struct config_group *group)
 {
 	int ret;
@@ -690,6 +690,7 @@ static int create_default_group(struct config_group *parent_group,
 
 	return ret;
 }
+EXPORT_SYMBOL(create_group);
 
 static int populate_groups(struct config_group *group)
 {
@@ -701,7 +702,7 @@ static int populate_groups(struct config_group *group)
 		for (i = 0; group->default_groups[i]; i++) {
 			new_group = group->default_groups[i];
 
-			ret = create_default_group(group, new_group);
+			ret = create_group(group, new_group);
 			if (ret) {
 				detach_groups(group);
 				break;
diff --git a/include/linux/configfs.h b/include/linux/configfs.h
index 34025df..8bf295f 100644
--- a/include/linux/configfs.h
+++ b/include/linux/configfs.h
@@ -252,6 +252,8 @@ static inline struct configfs_subsystem *to_configfs_subsystem(struct config_gro
 int configfs_register_subsystem(struct configfs_subsystem *subsys);
 void configfs_unregister_subsystem(struct configfs_subsystem *subsys);
 
+int create_group(struct config_group *parent_group, struct config_group *group);
+
 /* These functions can sleep and can alloc with GFP_KERNEL */
 /* WARNING: These cannot be called underneath configfs callbacks!! */
 int configfs_depend_item(struct configfs_subsystem *subsys, struct config_item *target);
-- 
1.7.0.4

