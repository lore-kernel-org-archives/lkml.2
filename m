Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab2L1V2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 16:28:35 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:55613 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab2L1V2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 16:28:33 -0500
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Dec 2012 16:28:33 EST
Date: Fri, 28 Dec 2012 16:22:46 -0500
From: Tejun Heo <tj@kernel.org>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: rjw@sisk.pl, oleg@redhat.com, linux-kernel@vger.kernel.org,
        lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] cgroup: remove unused dummy cgroup_fork_callbacks()
Message-ID: <20121228212246.GC3062@mtj.dyndns.org>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
 <1350426526-14254-2-git-send-email-tj@kernel.org>
 <20121220052533.GA17190@herton-Z68MA-D2H-B3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121220052533.GA17190@herton-Z68MA-D2H-B3>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a0a4bddd2779a51b6529afa113c5671ebcc21b14 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Fri, 28 Dec 2012 13:18:28 -0800

5edee61ede ("cgroup: cgroup_subsys->fork() should be called after the
task is added to css_set") removed cgroup_fork_callbacks() but forgot
to remove its dummy version for !CONFIG_CGROUPS.  Remove it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
Applied to cgroup/for-3.9.  Thanks.

 include/linux/cgroup.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 7d73905..942e687 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -706,7 +706,6 @@ struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id);
 static inline int cgroup_init_early(void) { return 0; }
 static inline int cgroup_init(void) { return 0; }
 static inline void cgroup_fork(struct task_struct *p) {}
-static inline void cgroup_fork_callbacks(struct task_struct *p) {}
 static inline void cgroup_post_fork(struct task_struct *p) {}
 static inline void cgroup_exit(struct task_struct *p, int callbacks) {}
 
-- 
1.8.0.2

