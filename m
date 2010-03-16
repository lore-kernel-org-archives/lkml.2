Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937317Ab0CPBLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 21:11:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:13189 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937302Ab0CPBLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 21:11:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,647,1262592000"; 
   d="scan'208";a="604693974"
Message-Id: <20100316011118.680475965@intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 16 Mar 2010 09:08:53 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>
Subject: [PATCH 2/3] vfs: O_* bit numbers uniqueness check fix
References: <20100316010851.331048488@intel.com>
Content-Disposition: inline; filename=fcntl_init-O_RDONLY
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow the comment by Eric:

	Until the FMODE_ and O_ bits do not overload I think we need to check
	FMODE_EXEC and FMODE_NONOTIFY (if you have that one) inside fcntl_init()
	as well.  I guess I'll send a patch to someone ?Al? to add FMODE_EXEC to
	the list....

CC: Eric Paris <eparis@redhat.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fcntl.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-mm.orig/fs/fcntl.c	2010-03-12 21:27:12.000000000 +0800
+++ linux-mm/fs/fcntl.c	2010-03-12 23:11:46.000000000 +0800
@@ -742,13 +742,14 @@ EXPORT_SYMBOL(kill_fasync);
 static int __init fcntl_init(void)
 {
 	/* please add new bits here to ensure allocation uniqueness */
-	BUILD_BUG_ON(17 != HWEIGHT32(
+	BUILD_BUG_ON(18 != HWEIGHT32(
 		O_RDONLY	| O_WRONLY	| O_RDWR	|
 		O_CREAT		| O_EXCL	| O_NOCTTY	|
 		O_TRUNC		| O_APPEND	| O_NONBLOCK	|
 		__O_SYNC	| O_DSYNC	| FASYNC	|
 		O_DIRECT	| O_LARGEFILE	| O_DIRECTORY	|
-		O_NOFOLLOW	| O_NOATIME	| O_CLOEXEC
+		O_NOFOLLOW	| O_NOATIME	| O_CLOEXEC	|
+		FMODE_EXEC
 		));
 
 	fasync_cache = kmem_cache_create("fasync_cache",


