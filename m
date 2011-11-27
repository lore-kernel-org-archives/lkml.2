Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab1K0FgN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:36:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215Ab1K0FgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:36:09 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>
Subject: [PATCH 40/62] minix: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:27:20 +0800
Message-Id: <1322371662-26166-41-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 fs/minix/dir.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/minix/dir.c b/fs/minix/dir.c
index 085a926..685b2d9 100644
--- a/fs/minix/dir.c
+++ b/fs/minix/dir.c
@@ -335,7 +335,7 @@ int minix_make_empty(struct inode *inode, struct inode *dir)
 		goto fail;
 	}
 
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic(page);
 	memset(kaddr, 0, PAGE_CACHE_SIZE);
 
 	if (sbi->s_version == MINIX_V3) {
@@ -355,7 +355,7 @@ int minix_make_empty(struct inode *inode, struct inode *dir)
 		de->inode = dir->i_ino;
 		strcpy(de->name, "..");
 	}
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
 	err = dir_commit_chunk(page, 0, 2 * sbi->s_dirsize);
 fail:
-- 
1.7.4.4

