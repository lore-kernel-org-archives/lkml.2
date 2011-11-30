Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab1K3CQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:16:46 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:50551 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756637Ab1K3CQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:16:43 -0500
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <matthew@wil.cx>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/28] locks: Use current logging style
Date: Tue, 29 Nov 2011 18:14:10 -0800
Message-Id: <68be456c6718acb068c35dc7045fd7a9c6fc3f77.1322609673.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1322609672.git.joe@perches.com>
References: <cover.1322609672.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add and use pr_fmt and pr_<level>.
Prefix message with "file: " and convert embedded function name
to "%s: ", __func__.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/locks.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 3b0d05d..10f2bdb 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -114,6 +114,8 @@
  *  Stephen Rothwell <sfr@canb.auug.org.au>, June, 2000.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/capability.h>
 #include <linux/file.h>
 #include <linux/fdtable.h>
@@ -581,7 +583,7 @@ static void locks_delete_lock(struct file_lock **thisfl_p)
 
 	fasync_helper(0, fl->fl_file, 0, &fl->fl_fasync);
 	if (fl->fl_fasync != NULL) {
-		printk(KERN_ERR "locks_delete_lock: fasync == %p\n", fl->fl_fasync);
+		pr_err("%s: fasync == %p\n", __func__, fl->fl_fasync);
 		fl->fl_fasync = NULL;
 	}
 
-- 
1.7.6.405.gc1be0

