Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761261Ab2CNWlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 18:41:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50529 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab2CNWlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 18:41:49 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: viro@zeniv.linux.org.uk, akpm@linux-foundation.org, ak@linux.intel.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        davej@redhat.com, rusty@rustcorp.com.au,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH] vfs: Fix dup_mnt_ns
Date: Wed, 14 Mar 2012 20:41:25 -0400
Message-Id: <1331772085-26321-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f8b88187 ("brlocks/lglocks: cleanups") has accidently dropped the
assignment of the new root into the mnt_fs.

This leads to NULL dereferences since ->root is assumed to be always non-NULL.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 fs/namespace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 5a6208b..224aff1 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2250,6 +2250,7 @@ static struct mnt_namespace *dup_mnt_ns(struct mnt_namespace *mnt_ns,
 		kfree(new_ns);
 		return ERR_PTR(-ENOMEM);
 	}
+	new_ns->root = new;
 	br_write_lock(&vfsmount_lock);
 	list_add_tail(&new_ns->list, &new->mnt_list);
 	br_write_unlock(&vfsmount_lock);
-- 
1.7.8.4

