Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937376Ab0CPBlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 21:41:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:9498 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932845Ab0CPBlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 21:41:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,647,1262592000"; 
   d="scan'208";a="549329864"
Message-Id: <20100316013841.420794929@intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 16 Mar 2010 09:36:56 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>
Subject: [PATCH 3/3] vfs: O_* bit numbers uniqueness check fix 2
References: <20100316013653.367442879@intel.com>
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

--- linux-mm.orig/fs/fcntl.c	2010-03-16 09:36:01.000000000 +0800
+++ linux-mm/fs/fcntl.c	2010-03-16 09:36:23.000000000 +0800
@@ -742,13 +742,14 @@ EXPORT_SYMBOL(kill_fasync);
 static int __init fcntl_init(void)
 {
 	/* please add new bits here to ensure allocation uniqueness */
-	BUILD_BUG_ON(18 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
+	BUILD_BUG_ON(19 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
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


