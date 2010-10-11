Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab0JKNiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 09:38:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45902 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab0JKNiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 09:38:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HsTD6pf+YWMmKMq58BnUyXvovDM690yNGIi9hk72iAOVLJW0EVy/YbfpX66e2JFFNL
         eWRyPqIG/3yTv8IkLO1h6p3JH3ny8ggtedQNIBQn4xVnCvBZLwQUlClg2XCLaXdzQDKi
         JQyX6RnK2SJFBuFFFSL2x5VDTlSvJFcXZOW/w=
From: Namhyung Kim <namhyung@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] lockdep: fixup checking of dir inode annotation
Date: Mon, 11 Oct 2010 22:38:00 +0900
Message-Id: <1286804280-5706-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since inode->i_mode shares its bits for S_IFMT, S_ISDIR should be
used to distinguish whether it is a dir or not.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 8646433..db58813 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -663,7 +663,7 @@ EXPORT_SYMBOL(new_inode);
 void unlock_new_inode(struct inode *inode)
 {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-	if (inode->i_mode & S_IFDIR) {
+	if (S_ISDIR(inode->i_mode)) {
 		struct file_system_type *type = inode->i_sb->s_type;
 
 		/* Set new key only if filesystem hasn't already changed it */
-- 
1.7.0.4

