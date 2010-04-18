Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab0DRUZe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 16:25:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38320 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab0DRUZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 16:25:33 -0400
Date: Sun, 18 Apr 2010 21:25:11 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
       Eric Paris <eparis@parisplace.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Fix "undefined reference to `anon_inode_getfd'"
Message-ID: <20100418202511.GB17939@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix:

fs/built-in.o: In function `sys_inotify_init1':
summary.c:(.text+0x347a4): undefined reference to `anon_inode_getfd'

found by kautobuild with arms bcmring_defconfig, which ends up with
INOTIFY_USER enabled (through the 'default y') but leaves ANON_INODES
unset.  However, inotify_user.c uses anon_inode_getfd().

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 fs/notify/inotify/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/notify/inotify/Kconfig b/fs/notify/inotify/Kconfig
index 3e56dbf..af2fc8e 100644
--- a/fs/notify/inotify/Kconfig
+++ b/fs/notify/inotify/Kconfig
@@ -16,6 +16,7 @@ config INOTIFY
 config INOTIFY_USER
 	bool "Inotify support for userspace"
 	select FSNOTIFY
+	select ANON_INODES
 	default y
 	---help---
 	  Say Y here to enable inotify support for userspace, including the

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
