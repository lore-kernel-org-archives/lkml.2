Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab1AIDrR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 22:47:17 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:58892 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab1AIDrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 22:47:15 -0500
Date: Sat, 8 Jan 2011 19:36:21 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Linus <torvalds@linux-foundation.org>, Nick Piggin <npiggin@kernel.dk>
Subject: [PATCH 1/6] fs: fix namei.c kernel-doc notation
Message-Id: <20110108193621.1b489d56.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix new kernel-doc notation warnings in fs/namei.c and spell
ECHILD correctly.

Warning(fs/namei.c:218): No description found for parameter 'flags'
Warning(fs/namei.c:425): Excess function parameter 'Returns' description in 'nameidata_drop_rcu'
Warning(fs/namei.c:478): Excess function parameter 'Returns' description in 'nameidata_dentry_drop_rcu'
Warning(fs/namei.c:540): Excess function parameter 'Returns' description in 'nameidata_drop_rcu_last'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Nick Piggin <npiggin@kernel.dk>
---
 fs/namei.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- lnx0107.orig/fs/namei.c
+++ lnx0107/fs/namei.c
@@ -202,7 +202,7 @@ static int acl_permission_check(struct i
  * @inode:	inode to check access rights for
  * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
  * @check_acl:	optional callback to check for Posix ACLs
- * @flags	IPERM_FLAG_ flags.
+ * @flags:	IPERM_FLAG_ flags.
  *
  * Used to check for read/write/execute permissions on a file.
  * We use "fsuid" for this, letting us set arbitrary permissions
@@ -407,7 +407,7 @@ void path_put_long(struct path *path)
 /**
  * nameidata_drop_rcu - drop this nameidata out of rcu-walk
  * @nd: nameidata pathwalk data to drop
- * @Returns: 0 on success, -ECHLID on failure
+ * Returns: 0 on success, -ECHILD on failure
  *
  * Path walking has 2 modes, rcu-walk and ref-walk (see
  * Documentation/filesystems/path-lookup.txt). __drop_rcu* functions attempt
@@ -468,7 +468,7 @@ static inline int nameidata_drop_rcu_may
  * nameidata_dentry_drop_rcu - drop nameidata and dentry out of rcu-walk
  * @nd: nameidata pathwalk data to drop
  * @dentry: dentry to drop
- * @Returns: 0 on success, -ECHLID on failure
+ * Returns: 0 on success, -ECHILD on failure
  *
  * nameidata_dentry_drop_rcu attempts to drop the current nd->path and nd->root,
  * and dentry into ref-walk. @dentry must be a path found by a do_lookup call on
@@ -530,7 +530,7 @@ static inline int nameidata_dentry_drop_
 /**
  * nameidata_drop_rcu_last - drop nameidata ending path walk out of rcu-walk
  * @nd: nameidata pathwalk data to drop
- * @Returns: 0 on success, -ECHLID on failure
+ * Returns: 0 on success, -ECHILD on failure
  *
  * nameidata_drop_rcu_last attempts to drop the current nd->path into ref-walk.
  * nd->path should be the final element of the lookup, so nd->root is discarded.
