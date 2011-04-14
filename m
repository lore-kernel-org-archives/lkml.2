Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab1DNCrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 22:47:41 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64191 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758379Ab1DNCrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 22:47:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=xfIoarRwgAJXRgSolaa8N+M4AolYWXI7YOI6r05LyK3KvosuhayqbdiIwObmqvDg+n
         aMnt2kBd+YR6EX4rRNYhwIgloMEzTibyeFm+XigZBp6BbQX6FNwePPXkM+BBmZughsnp
         uTWey8ZSRGpDCGgQFR1ycnbiFqmoUW3VmN94I=
From: Timothy Courrejou <timcour@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: eparis@redhat.com, linux-kernel@vger.kernel.org, trivial@kernel.org,
        Timothy Courrejou <timcour@gmail.com>
Subject: [PATCH] audit: fixed line length and space coding style issues.
Date: Wed, 13 Apr 2011 19:47:25 -0700
Message-Id: <1302749245-29303-1-git-send-email-timcour@gmail.com>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issues.

Signed-off-by: Timothy Courrejou <timcour@gmail.com>
---
 kernel/audit_watch.c |   41 ++++++++++++++++++++++++-----------------
 1 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index e683869..ffe2ee4 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -35,13 +35,14 @@
 /*
  * Reference counting:
  *
- * audit_parent: lifetime is from audit_init_parent() to receipt of an FS_IGNORED
- * 	event.  Each audit_watch holds a reference to its associated parent.
+ * audit_parent: lifetime is from audit_init_parent() to receipt of an
+ *      FS_IGNORED event.  Each audit_watch holds a reference to its associated
+ *      parent.
  *
  * audit_watch: if added to lists, lifetime is from audit_init_watch() to
- * 	audit_remove_watch().  Additionally, an audit_watch may exist
- * 	temporarily to assist in searching existing filter data.  Each
- * 	audit_krule holds a reference to its associated watch.
+ *      audit_remove_watch().  Additionally, an audit_watch may exist
+ *      temporarily to assist in searching existing filter data.  Each
+ *      audit_krule holds a reference to its associated watch.
  */
 
 struct audit_watch {
@@ -158,7 +159,8 @@ static struct audit_parent *audit_init_parent(struct path *path)
 
 	fsnotify_init_mark(&parent->mark, audit_watch_free_mark);
 	parent->mark.mask = AUDIT_FS_WATCH;
-	ret = fsnotify_add_mark(&parent->mark, audit_watch_group, inode, NULL, 0);
+	ret = fsnotify_add_mark(&parent->mark, audit_watch_group,
+				inode, NULL, 0);
 	if (ret < 0) {
 		audit_free_parent(parent);
 		return ERR_PTR(ret);
@@ -235,7 +237,8 @@ out:
 	return new;
 }
 
-static void audit_watch_log_rule_change(struct audit_krule *r, struct audit_watch *w, char *op)
+static void audit_watch_log_rule_change(struct audit_krule *r,
+					struct audit_watch *w, char *op)
 {
 	if (audit_enabled) {
 		struct audit_buffer *ab;
@@ -306,7 +309,8 @@ static void audit_update_watch(struct audit_parent *parent,
 				audit_get_watch(nwatch);
 				nentry->rule.watch = nwatch;
 				list_add(&nentry->rule.rlist, &nwatch->rules);
-				list_add_rcu(&nentry->list, &audit_inode_hash[h]);
+				list_add_rcu(&nentry->list,
+					     &audit_inode_hash[h]);
 				list_replace(&oentry->rule.list,
 					     &nentry->rule.list);
 			}
@@ -481,12 +485,13 @@ void audit_remove_watch_rule(struct audit_krule *krule)
 	}
 }
 
-static bool audit_watch_should_send_event(struct fsnotify_group *group, struct inode *inode,
+static bool audit_watch_should_send_event(struct fsnotify_group *group,
+					  struct inode *inode,
 					  struct fsnotify_mark *inode_mark,
 					  struct fsnotify_mark *vfsmount_mark,
 					  __u32 mask, void *data, int data_type)
 {
-       return true;
+	return true;
 }
 
 /* Update watch data in audit rules based on fsnotify events. */
@@ -518,9 +523,11 @@ static int audit_watch_handle_event(struct fsnotify_group *group,
 	};
 
 	if (mask & (FS_CREATE|FS_MOVED_TO) && inode)
-		audit_update_watch(parent, dname, inode->i_sb->s_dev, inode->i_ino, 0);
+		audit_update_watch(parent, dname, inode->i_sb->s_dev,
+				   inode->i_ino, 0);
 	else if (mask & (FS_DELETE|FS_MOVED_FROM))
-		audit_update_watch(parent, dname, (dev_t)-1, (unsigned long)-1, 1);
+		audit_update_watch(parent, dname,
+				   (dev_t)-1, (unsigned long)-1, 1);
 	else if (mask & (FS_DELETE_SELF|FS_UNMOUNT|FS_MOVE_SELF))
 		audit_remove_parent_watches(parent);
 
@@ -528,11 +535,11 @@ static int audit_watch_handle_event(struct fsnotify_group *group,
 }
 
 static const struct fsnotify_ops audit_watch_fsnotify_ops = {
-	.should_send_event = 	audit_watch_should_send_event,
-	.handle_event = 	audit_watch_handle_event,
-	.free_group_priv = 	NULL,
-	.freeing_mark = 	NULL,
-	.free_event_priv = 	NULL,
+	.should_send_event =    audit_watch_should_send_event,
+	.handle_event =         audit_watch_handle_event,
+	.free_group_priv =      NULL,
+	.freeing_mark =         NULL,
+	.free_event_priv =      NULL,
 };
 
 static int __init audit_watch_init(void)
-- 
1.7.4.2

