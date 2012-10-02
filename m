Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab2JBARk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:17:40 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64745 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab2JBARI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:17:08 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v7 02/49] audit: pass in dentry to audit_copy_inode wherever possible
Date: Mon,  1 Oct 2012 20:16:11 -0400
Message-Id: <1349137018-21948-3-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some cases, we were passing in NULL even when we have a dentry.

Reported-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 kernel/auditsc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 4b96415..5c45b9b 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2226,7 +2226,7 @@ void __audit_inode_child(const struct dentry *dentry,
 		if (!strcmp(dname, n->name) ||
 		     !audit_compare_dname_path(dname, n->name, &dirlen)) {
 			if (inode)
-				audit_copy_inode(n, NULL, inode);
+				audit_copy_inode(n, dentry, inode);
 			else
 				n->ino = (unsigned long)-1;
 			found_child = n->name;
@@ -2258,7 +2258,7 @@ add_names:
 		}
 
 		if (inode)
-			audit_copy_inode(n, NULL, inode);
+			audit_copy_inode(n, dentry, inode);
 	}
 }
 EXPORT_SYMBOL_GPL(__audit_inode_child);
-- 
1.7.11.4

