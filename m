Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030465Ab2CFM5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 07:57:05 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58747 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649Ab2CFM47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 07:56:59 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of miklos@szeredi.hu designates 10.14.28.137 as permitted sender) smtp.mail=miklos@szeredi.hu; dkim=pass header.i=miklos@szeredi.hu
MIME-Version: 1.0
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: [PATCH 4/9] vfs: don't revalidate just looked up dentry
Date: Tue,  6 Mar 2012 13:56:36 +0100
Message-Id: <1331038601-20353-5-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331038601-20353-1-git-send-email-miklos@szeredi.hu>
References: <1331038601-20353-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

__lookup_hash() calls ->lookup() if the dentry needs lookup and on success
revalidates the dentry (all under dir->i_mutex).

While this is harmless it doesn't make a lot of sense.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 599e4a0..c93ea6d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1746,9 +1746,7 @@ static struct dentry *__lookup_hash(struct qstr *name,
 		 * __lookup_hash is called with the parent dir's i_mutex already
 		 * held, so we are good to go here.
 		 */
-		dentry = d_inode_lookup(base, dentry, nd);
-		if (IS_ERR(dentry))
-			return dentry;
+		return d_inode_lookup(base, dentry, nd);
 	}
 
 	if (dentry && (dentry->d_flags & DCACHE_OP_REVALIDATE)) {
-- 
1.7.7

