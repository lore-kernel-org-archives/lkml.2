Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab1K3CQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:16:24 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:36591 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756637Ab1K3CQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:16:21 -0500
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <matthew@wil.cx>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/28] fcntl: Use current logging style
Date: Tue, 29 Nov 2011 18:14:08 -0800
Message-Id: <bd7e5e5bfb6786bd030a94b3b749a00b84ecf266.1322609673.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1322609672.git.joe@perches.com>
References: <cover.1322609672.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add and use pr_fmt and pr_<level>.
Output message now prefixed with "fcntl: " and
%s:, __func__, (kill_fasync_rcu) now used as well.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/fcntl.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 22764c7..5d16b1d 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -4,6 +4,8 @@
  *  Copyright (C) 1991, 1992  Linus Torvalds
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/syscalls.h>
 #include <linux/init.h>
 #include <linux/mm.h>
@@ -797,8 +799,8 @@ static void kill_fasync_rcu(struct fasync_struct *fa, int sig, int band)
 		unsigned long flags;
 
 		if (fa->magic != FASYNC_MAGIC) {
-			printk(KERN_ERR "kill_fasync: bad magic number in "
-			       "fasync_struct!\n");
+			pr_err("%s: bad magic number in fasync_struct!\n",
+			       __func__);
 			return;
 		}
 		spin_lock_irqsave(&fa->fa_lock, flags);
-- 
1.7.6.405.gc1be0

