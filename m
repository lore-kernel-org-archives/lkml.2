Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab2ICOO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 10:14:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38825 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab2ICOOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 10:14:25 -0400
From: yan <clouds.yan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] proc: return -ENOMEM when inode allocation failed
Date: Mon,  3 Sep 2012 22:14:05 +0800
Message-Id: <1346681648-21427-2-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346681648-21427-1-git-send-email-clouds.yan@gmail.com>
References: <1346681648-21427-1-git-send-email-clouds.yan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: yan <clouds.yan@gmail.com>
---
 fs/proc/generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index b3647fe..9e8f631 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -427,7 +427,7 @@ struct dentry *proc_lookup_de(struct proc_dir_entry *de, struct inode *dir,
 		if (!memcmp(dentry->d_name.name, de->name, de->namelen)) {
 			pde_get(de);
 			spin_unlock(&proc_subdir_lock);
-			error = -EINVAL;
+			error = -ENOMEM;
 			inode = proc_get_inode(dir->i_sb, de);
 			goto out_unlock;
 		}
-- 
1.7.9.5

