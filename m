Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab1BVRNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 12:13:44 -0500
Received: from trinity.develer.com ([83.149.158.210]:42563 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab1BVRNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 12:13:41 -0500
From: Andrea Righi <arighi@develer.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Ryo Tsuruta <ryov@valinux.co.jp>,
        Hirokazu Takahashi <taka@valinux.co.jp>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        containers@lists.linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andrea Righi <arighi@develer.com>
Subject: [PATCH 2/5] blk-cgroup: introduce task_to_blkio_cgroup()
Date: Tue, 22 Feb 2011 18:12:53 +0100
Message-Id: <1298394776-9957-3-git-send-email-arighi@develer.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1298394776-9957-1-git-send-email-arighi@develer.com>
References: <1298394776-9957-1-git-send-email-arighi@develer.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a helper function to retrieve a blkio cgroup from a task.

Signed-off-by: Andrea Righi <arighi@develer.com>
---
 block/blk-cgroup.c         |    7 +++++++
 include/linux/blk-cgroup.h |    4 ++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index bf9d354..f283ae1 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -107,6 +107,13 @@ blkio_policy_search_node(const struct blkio_cgroup *blkcg, dev_t dev,
 	return NULL;
 }
 
+struct blkio_cgroup *task_to_blkio_cgroup(struct task_struct *task)
+{
+	return container_of(task_subsys_state(task, blkio_subsys_id),
+				struct blkio_cgroup, css);
+}
+EXPORT_SYMBOL_GPL(task_to_blkio_cgroup);
+
 struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup)
 {
 	return container_of(cgroup_subsys_state(cgroup, blkio_subsys_id),
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 5e48204..41b59db 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -287,6 +287,7 @@ static inline void blkiocg_set_start_empty_time(struct blkio_group *blkg) {}
 extern struct blkio_cgroup blkio_root_cgroup;
 extern bool blkio_cgroup_disabled(void);
 extern struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup);
+extern struct blkio_cgroup *task_to_blkio_cgroup(struct task_struct *task);
 extern void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
 	struct blkio_group *blkg, void *key, dev_t dev,
 	enum blkio_policy_id plid);
@@ -311,6 +312,9 @@ static inline bool blkio_cgroup_disabled(void) { return true; }
 static inline struct blkio_cgroup *
 cgroup_to_blkio_cgroup(struct cgroup *cgroup) { return NULL; }
 
+static inline struct blkio_cgroup *
+task_to_blkio_cgroup(struct task_struct *task) { return NULL; }
+
 static inline void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
 		struct blkio_group *blkg, void *key, dev_t dev,
 		enum blkio_policy_id plid) {}
-- 
1.7.1

