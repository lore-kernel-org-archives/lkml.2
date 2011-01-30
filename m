Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab1A3J70 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 04:59:26 -0500
Received: from shutemov.name ([188.40.19.243]:44520 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab1A3J7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 04:59:25 -0500
From: "Kirill A. Shutsemov" <kirill@shutemov.name>
To: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH 1/2] cgroups: export cgroup_iter_{start,next,end}
Date: Sun, 30 Jan 2011 11:59:21 +0200
Message-Id: <1296381562-14377-1-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill A. Shutemov <kirill@shutemov.name>

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 kernel/cgroup.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b24d702..e3be81a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2443,6 +2443,7 @@ void cgroup_iter_start(struct cgroup *cgrp, struct cgroup_iter *it)
 	it->cg_link = &cgrp->css_sets;
 	cgroup_advance_iter(cgrp, it);
 }
+EXPORT_SYMBOL(cgroup_iter_start);
 
 struct task_struct *cgroup_iter_next(struct cgroup *cgrp,
 					struct cgroup_iter *it)
@@ -2467,11 +2468,13 @@ struct task_struct *cgroup_iter_next(struct cgroup *cgrp,
 	}
 	return res;
 }
+EXPORT_SYMBOL(cgroup_iter_next);
 
 void cgroup_iter_end(struct cgroup *cgrp, struct cgroup_iter *it)
 {
 	read_unlock(&css_set_lock);
 }
+EXPORT_SYMBOL(cgroup_iter_end);
 
 static inline int started_after_time(struct task_struct *t1,
 				     struct timespec *time,
-- 
1.7.3.5

