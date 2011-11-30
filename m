Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab1K3CRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:17:00 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:56373 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756637Ab1K3CQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:16:57 -0500
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/28] open: Use current logging style
Date: Tue, 29 Nov 2011 18:14:11 -0800
Message-Id: <baa9ed775c8ba43b78547e4b652ce734a5563c9c.1322609673.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1322609672.git.joe@perches.com>
References: <cover.1322609672.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add and use pr_fmt and pr_<level>
No change to output using #define pr_fmt(fmt) fmt

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/open.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 22c41b5..58c8d94 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -4,6 +4,8 @@
  *  Copyright (C) 1991, 1992  Linus Torvalds
  */
 
+#define pr_fmt(fmt) fmt
+
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/file.h>
@@ -1043,7 +1045,7 @@ int filp_close(struct file *filp, fl_owner_t id)
 	int retval = 0;
 
 	if (!file_count(filp)) {
-		printk(KERN_ERR "VFS: Close: file count is 0\n");
+		pr_err("VFS: Close: file count is 0\n");
 		return 0;
 	}
 
-- 
1.7.6.405.gc1be0

