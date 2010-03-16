Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937402Ab0CPBms (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 21:42:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:12660 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367Ab0CPBmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 21:42:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,647,1262592000"; 
   d="scan'208";a="604702393"
Message-Id: <20100316013841.269383897@intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 16 Mar 2010 09:36:55 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Andreas Dilger <adilger@sun.com>
Subject: [PATCH 2/3] vfs: O_* bit numbers uniqueness check fix
References: <20100316013653.367442879@intel.com>
Content-Disposition: inline; filename=fcntl_init-O_RDONLY-2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow the comment by Andreas:

	It's non-obvious why there are 18 flags listed here, but the hweight
	is only 17?  Presumably this is because O_RDONLY has value 0, but that
	should at least be
	listed in a comment, or the test could be written more explicitly, like:

		  BUILD_BUG_ON(18 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(


CC: Andreas Dilger <adilger@sun.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fcntl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-mm.orig/fs/fcntl.c	2010-03-16 09:35:47.000000000 +0800
+++ linux-mm/fs/fcntl.c	2010-03-16 09:36:01.000000000 +0800
@@ -742,7 +742,7 @@ EXPORT_SYMBOL(kill_fasync);
 static int __init fcntl_init(void)
 {
 	/* please add new bits here to ensure allocation uniqueness */
-	BUILD_BUG_ON(17 != HWEIGHT32(
+	BUILD_BUG_ON(18 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
 		O_RDONLY	| O_WRONLY	| O_RDWR	|
 		O_CREAT		| O_EXCL	| O_NOCTTY	|
 		O_TRUNC		| O_APPEND	| O_NONBLOCK	|


