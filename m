Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253Ab2ATDzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 22:55:39 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65362 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab2ATDzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 22:55:36 -0500
Message-ID: <4F18E651.2000109@cn.fujitsu.com>
Date: Fri, 20 Jan 2012 11:58:09 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 1/2] cgroup: remove cgroup_attach_task_current_cg()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-20 11:54:22,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-20 11:54:23,
	Serialize complete at 2012-01-20 11:54:23
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's just a wrapper of cgroup_attach_task_all(), and it's no longer
used after commit 87d6a412bd1ed82c14cabd4b408003b23bbd2880
(vhost: fix attach to cgroups regression)

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/cgroup.h |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index e9b6021..dee53bd 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -602,11 +602,6 @@ int cgroup_scan_tasks(struct cgroup_scanner *scan);
 int cgroup_attach_task(struct cgroup *, struct task_struct *);
 int cgroup_attach_task_all(struct task_struct *from, struct task_struct *);
 
-static inline int cgroup_attach_task_current_cg(struct task_struct *tsk)
-{
-	return cgroup_attach_task_all(current, tsk);
-}
-
 /*
  * CSS ID is ID for cgroup_subsys_state structs under subsys. This only works
  * if cgroup_subsys.use_id == true. It can be used for looking up and scanning.
@@ -669,10 +664,6 @@ static inline int cgroup_attach_task_all(struct task_struct *from,
 {
 	return 0;
 }
-static inline int cgroup_attach_task_current_cg(struct task_struct *t)
-{
-	return 0;
-}
 
 #endif /* !CONFIG_CGROUPS */
 
-- 
1.7.3.1
