Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab1CVAvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 20:51:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754737Ab1CVAvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 20:51:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] VFS: Remove detached-dentry counter from
 shrink_dcache_for_umount_subtree()
To: hch@infradead.org, viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Tue, 22 Mar 2011 00:51:30 +0000
Message-ID: <20110322005130.10291.94709.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the detached-dentry counter from shrink_dcache_for_umount_subtree() as
the value it computes is no longer used as of commit
312d3ca856d369bb04d0443846b85b4cdde6fa8a which made the nr_dentry counters
summed per-CPU rather than global atomic.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/dcache.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index ad25c4c..2d5a5dc 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -894,7 +894,6 @@ EXPORT_SYMBOL(shrink_dcache_sb);
 static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
 {
 	struct dentry *parent;
-	unsigned detached = 0;
 
 	BUG_ON(!IS_ROOT(dentry));
 
@@ -958,8 +957,6 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
 				spin_unlock(&parent->d_lock);
 			}
 
-			detached++;
-
 			inode = dentry->d_inode;
 			if (inode) {
 				dentry->d_inode = NULL;

