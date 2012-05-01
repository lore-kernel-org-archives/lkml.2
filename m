Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249Ab2EAPSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 11:18:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46414 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab2EAPR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 11:17:59 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Andy Whitcroft <apw@canonical.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH 3/5] overlayfs: follow header cleanup
Date: Tue,  1 May 2012 16:17:53 +0100
Message-Id: <1335885475-11990-4-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1335885475-11990-1-git-send-email-apw@canonical.com>
References: <1335885475-11990-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The headers cleanup has removed a number of unnecessary includes from
various headers.  Fix up the now missing headers in overlayfs.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 fs/overlayfs/copy_up.c |    1 +
 fs/overlayfs/dir.c     |    1 +
 fs/overlayfs/readdir.c |    1 +
 fs/overlayfs/super.c   |    2 ++
 4 files changed, 5 insertions(+)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 398fa1c..87dbeee 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -14,6 +14,7 @@
 #include <linux/xattr.h>
 #include <linux/security.h>
 #include <linux/uaccess.h>
+#include <linux/sched.h>
 #include "overlayfs.h"
 
 #define OVL_COPY_UP_CHUNK_SIZE (1 << 20)
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 57bbb94..00aa6d9 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -11,6 +11,7 @@
 #include <linux/namei.h>
 #include <linux/xattr.h>
 #include <linux/security.h>
+#include <linux/cred.h>
 #include "overlayfs.h"
 
 static const char *ovl_whiteout_symlink = "(overlay-whiteout)";
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index ed8fbad..0797efb 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -14,6 +14,7 @@
 #include <linux/xattr.h>
 #include <linux/rbtree.h>
 #include <linux/security.h>
+#include <linux/cred.h>
 #include "overlayfs.h"
 
 struct ovl_cache_entry {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 10cafe0..b679019 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -16,6 +16,8 @@
 #include <linux/parser.h>
 #include <linux/module.h>
 #include <linux/seq_file.h>
+#include <linux/cred.h>
+#include <linux/sched.h>
 #include "overlayfs.h"
 
 MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
-- 
1.7.9.5

