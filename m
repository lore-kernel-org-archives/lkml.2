Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab1K3CQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:16:35 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:56367 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756637Ab1K3CQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:16:32 -0500
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/28] file: Use current logging style
Date: Tue, 29 Nov 2011 18:14:09 -0800
Message-Id: <b91776fa10d2674123d38fac206a51d57358ece9.1322609673.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1322609672.git.joe@perches.com>
References: <cover.1322609672.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add and use pr_fmt and pr_<level>
Now prefixed a single message with "file: " and
changed an embedded function name to "%s: ", __func__.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/file.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 4c6992d..a88b110 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -6,6 +6,8 @@
  *  Manage the dynamic fd arrays in the process files_struct.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
@@ -469,7 +471,7 @@ repeat:
 #if 1
 	/* Sanity check */
 	if (rcu_dereference_raw(fdt->fd[fd]) != NULL) {
-		printk(KERN_WARNING "alloc_fd: slot %d not NULL!\n", fd);
+		pr_warn("%s: slot %d not NULL!\n", __func__, fd);
 		rcu_assign_pointer(fdt->fd[fd], NULL);
 	}
 #endif
-- 
1.7.6.405.gc1be0

