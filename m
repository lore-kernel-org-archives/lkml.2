Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965115Ab2CUWSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 18:18:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42808 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964858Ab2CUWSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 18:18:11 -0400
From: Tejun Heo <tj@kernel.org>
To: glommer@parallels.com, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rni@google.com,
        ctalbott@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/12] cgroup: relocate __d_cgrp() and __d_cft()
Date: Wed, 21 Mar 2012 15:17:43 -0700
Message-Id: <1332368265-21586-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332368265-21586-1-git-send-email-tj@kernel.org>
References: <1332368265-21586-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the two macros upwards as they'll be used earlier in the file.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 02e131e..d64f16d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -282,6 +282,16 @@ list_for_each_entry(_ss, &_root->subsys_list, sibling)
 #define for_each_active_root(_root) \
 list_for_each_entry(_root, &roots, root_list)
 
+static inline struct cgroup *__d_cgrp(struct dentry *dentry)
+{
+	return dentry->d_fsdata;
+}
+
+static inline struct cftype *__d_cft(struct dentry *dentry)
+{
+	return dentry->d_fsdata;
+}
+
 /* the list of cgroups eligible for automatic release. Protected by
  * release_list_lock */
 static LIST_HEAD(release_list);
@@ -1708,16 +1718,6 @@ static struct file_system_type cgroup_fs_type = {
 
 static struct kobject *cgroup_kobj;
 
-static inline struct cgroup *__d_cgrp(struct dentry *dentry)
-{
-	return dentry->d_fsdata;
-}
-
-static inline struct cftype *__d_cft(struct dentry *dentry)
-{
-	return dentry->d_fsdata;
-}
-
 /**
  * cgroup_path - generate the path of a cgroup
  * @cgrp: the cgroup in question
-- 
1.7.7.3

