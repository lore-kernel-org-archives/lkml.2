Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab2H0Ucm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 16:32:42 -0400
Received: from smtp.outflux.net ([198.145.64.163]:37764 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484Ab2H0Ucl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 16:32:41 -0400
Date: Mon, 27 Aug 2012 13:32:15 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>, Rob Landley <rob@landley.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Ludwig Nussel <ludwig.nussel@suse.de>,
        Alessandro Rubini <rubini@gnudd.com>,
        Kees Cook <keescook@chromium.org>, linux-doc@vger.kernel.org
Subject: [PATCH] debugfs: more tightly restrict default mount mode
Message-ID: <20120827203215.GA16637@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the debugfs is mostly only used by root, make the default mount
mode 0700. Most system owners do not need a more permissive value,
but they can choose to weaken the restrictions via their fstab.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/filesystems/debugfs.txt |    4 ++--
 fs/debugfs/inode.c                    |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/debugfs.txt b/Documentation/filesystems/debugfs.txt
index 7a34f82..3a863f6 100644
--- a/Documentation/filesystems/debugfs.txt
+++ b/Documentation/filesystems/debugfs.txt
@@ -15,8 +15,8 @@ Debugfs is typically mounted with a command like:
     mount -t debugfs none /sys/kernel/debug
 
 (Or an equivalent /etc/fstab line).
-The debugfs root directory is accessible by anyone by default. To
-restrict access to the tree the "uid", "gid" and "mode" mount
+The debugfs root directory is accessible only to the root user by
+default. To change access to the tree the "uid", "gid" and "mode" mount
 options can be used.
 
 Note that the debugfs API is exported GPL-only to modules.
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 4733eab..2d22c81 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -28,7 +28,7 @@
 #include <linux/magic.h>
 #include <linux/slab.h>
 
-#define DEBUGFS_DEFAULT_MODE	0755
+#define DEBUGFS_DEFAULT_MODE	0700
 
 static struct vfsmount *debugfs_mount;
 static int debugfs_mount_count;
-- 
1.7.0.4


-- 
Kees Cook
Chrome OS Security
