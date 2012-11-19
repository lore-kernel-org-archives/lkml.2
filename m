Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab2KSF3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:29:13 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:53842 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab2KSF3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:29:11 -0500
X-Originating-IP: 217.70.178.131
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <matthew@wil.cx>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 09/58] fs/locks.c: Mark generic_add_lease and generic_delete_lease static
Date: Sun, 18 Nov 2012 21:27:48 -0800
Message-Id: <1353302917-13995-10-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing outside of fs/locks.c references these functions, so mark them
static.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/locks.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index a94e331..01051de 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1338,7 +1338,7 @@ int fcntl_getlease(struct file *filp)
 	return type;
 }
 
-int generic_add_lease(struct file *filp, long arg, struct file_lock **flp)
+static int generic_add_lease(struct file *filp, long arg, struct file_lock **flp)
 {
 	struct file_lock *fl, **before, **my_before = NULL, *lease;
 	struct dentry *dentry = filp->f_path.dentry;
@@ -1403,7 +1403,7 @@ out:
 	return error;
 }
 
-int generic_delete_lease(struct file *filp, struct file_lock **flp)
+static int generic_delete_lease(struct file *filp, struct file_lock **flp)
 {
 	struct file_lock *fl, **before;
 	struct dentry *dentry = filp->f_path.dentry;
-- 
1.7.10.4

