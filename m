Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162091Ab2CPXgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:36:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40344 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161982Ab2CPXgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:36:25 -0400
From: Tejun Heo <tj@kernel.org>
To: glommer@parallels.com, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rni@google.com,
        ctalbott@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/10] cgroup: relocate __d_cgrp() and __d_cft()
Date: Fri, 16 Mar 2012 16:36:01 -0700
Message-Id: <1331940963-15756-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331940963-15756-1-git-send-email-tj@kernel.org>
References: <1331940963-15756-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the two macros upwards as they'll be used earlier in the file.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 33383cb..765d9f5 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -292,6 +292,16 @@ list_for_each_entry(_ss, &_root->subsys_list, sibling)
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
@@ -1718,16 +1728,6 @@ static struct file_system_type cgroup_fs_type = {
 
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

