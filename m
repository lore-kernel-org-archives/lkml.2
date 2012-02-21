Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab2BUSIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:08:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981Ab2BUSIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:08:19 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 66/73] ext2: Split ext2_add_entry() from ext2_add_link() [ver
 #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@kernel.org
Date: Tue, 21 Feb 2012 18:05:46 +0000
Message-ID: <20120221180546.25235.50961.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valerie Aurora <vaurora@redhat.com>

Allow future code to use the guts of ext2_add_link().

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: linux-ext4@kernel.org
---

 fs/ext2/dir.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 89015f1..d8382dc 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -489,10 +489,7 @@ void ext2_set_link(struct inode *dir, struct ext2_dir_entry_2 *de,
 	mark_inode_dirty(dir);
 }
 
-/*
- *	Parent is locked.
- */
-int ext2_add_link (struct dentry *dentry, struct inode *inode)
+int ext2_add_entry(struct dentry *dentry, struct inode *inode)
 {
 	struct inode *dir = dentry->d_parent->d_inode;
 	const char *name = dentry->d_name.name;
@@ -588,6 +585,11 @@ out_unlock:
 	goto out_put;
 }
 
+int ext2_add_link(struct dentry *dentry, struct inode *inode)
+{
+	return ext2_add_entry(dentry, inode);
+}
+
 /*
  * ext2_delete_entry deletes a directory entry by merging it with the
  * previous entry. Page is up-to-date. Releases the page.

