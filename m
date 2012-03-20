Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520Ab2CTWI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 18:08:57 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57418 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab2CTWIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 18:08:55 -0400
Date: Wed, 21 Mar 2012 02:08:51 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm] c/r: prctl: Add missing minus in error code
Message-ID: <20120320220851.GJ14269@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error code should be a negative value.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 Hi Andrew, could you please check if this patch
 is valid for -mm tree and it is not some left-over
 dangling in my local tree (found this typo while trying
 to describe error codes for man-page).

 kernel/sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.git/kernel/sys.c
===================================================================
--- linux-2.6.git.orig/kernel/sys.c
+++ linux-2.6.git/kernel/sys.c
@@ -1881,7 +1881,7 @@ static int prctl_set_mm(int opt, unsigne
 		up_read(&mm->mmap_sem);
 
 		if (copy_from_user(user_auxv, (const void __user *)addr, arg4))
-			return EFAULT;
+			return -EFAULT;
 
 		/* Make sure the last entry is always AT_NULL */
 		user_auxv[AT_VECTOR_SIZE - 2] = 0;
