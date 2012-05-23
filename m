Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759698Ab2EWNOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 09:14:21 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3148 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911Ab2EWNOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 09:14:20 -0400
X-Server-Uuid: B730DE51-FC43-4C83-941F-F1F78A914BDD
From: "Arend van Spriel" <arend@broadcom.com>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
cc: linux-kernel@vger.kernel.org, "Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for-3.6] debugfs: change parameter check in
 debugfs_remove() functions
Date: Wed, 23 May 2012 15:13:07 +0200
Message-ID: <1337778788-7069-1-git-send-email-arend@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
X-WSS-ID: 63A23D483E037182399-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dentry parameter in debugfs_remove() and debugfs_remove_recursive()
is checked being a NULL pointer. To make cleanup by callers easier this
check is extended using the IS_ERR_OR_NULL macro instead because the
debugfs_create_... functions can return a ERR_PTR() value.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
I was adding the check in driver code before calling the recursive remove,
but considered it might be a better idea to do it in debugfs itself.

No rush so I target to include it in v3.6. The patch is based on v3.4 tag.

Gr. AvS
---
 fs/debugfs/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index b80bc84..0de5e26 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -498,7 +498,7 @@ void debugfs_remove(struct dentry *dentry)
 	struct dentry *parent;
 	int ret;
 
-	if (!dentry)
+	if (IS_ERR_OR_NULL(dentry))
 		return;
 
 	parent = dentry->d_parent;
@@ -530,7 +530,7 @@ void debugfs_remove_recursive(struct dentry *dentry)
 	struct dentry *child;
 	struct dentry *parent;
 
-	if (!dentry)
+	if (IS_ERR_OR_NULL(dentry))
 		return;
 
 	parent = dentry->d_parent;
-- 
1.7.9.5


