Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab2KAJg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 05:36:29 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56144 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab2KAJg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 05:36:27 -0400
From: Xiaotian Feng <xtfeng@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Xiaotian Feng <xtfeng@gmail.com>, Xiaotian Feng <dannyfeng@tencent.com>,
        Jeff Layton <jlayton@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] swapfile: fix name leak in swapoff
Date: Thu,  1 Nov 2012 17:36:55 +0800
Message-Id: <1351762616-2060-1-git-send-email-xtfeng@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

there's a name leak introduced by commit 91a27b2, add the missing
putname.

Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
Cc: Jeff Layton <jlayton@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 mm/swapfile.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 71cd288..459fe30 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1608,6 +1608,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 out_dput:
 	filp_close(victim, NULL);
 out:
+	if (pathname && !IS_ERR(pathname))
+		putname(pathname);
 	return err;
 }
 
-- 
1.7.9.5

