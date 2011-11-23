Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab1KWIcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 03:32:42 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56899 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab1KWIck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 03:32:40 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 23 Nov 2011 17:31:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>
Subject: [RFC][PATCH 1/3] add cgroup_xxxx_disabled functions
Message-Id: <20111123173133.e7ba96df.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111123172840.acd53c41.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111123172840.acd53c41.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1a9e228c2a28bb918ea8cb9aecc11fd80444acaa Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 23 Nov 2011 15:36:22 +0900
Subject: [PATCH 1/3] add cgroup_xxxx_disabled() functions

Now, memory cgroup uses mem_cgroup_disabled() for checking
cgroup is disabled or not. This patch adds cgroup_xxxx_disabled()
functions for all subsys. After all works, mem_cgroup_disabled()
can be disappeared.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/cgroup.h        |   18 ++++++++++++++++++
 include/linux/cgroup_subsys.h |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 1b7f9d5..9eaa6fe 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -526,6 +526,16 @@ struct cgroup_subsys {
 #include <linux/cgroup_subsys.h>
 #undef SUBSYS
 
+#define SUBSYS(_x)\
+	static inline bool cgroup_ ## _x ## _disabled(void){\
+		return _x ## _subsys.disabled;}
+#define SUBSYS_UNDEFINED(_x)\
+	static inline bool cgroup_ ## _x ## _disabled(void){\
+		return true;}
+#include <linux/cgroup_subsys.h>
+#undef SUBSYS
+#undef SUBSYS_UNDEFINED
+
 static inline struct cgroup_subsys_state *cgroup_subsys_state(
 	struct cgroup *cgrp, int subsys_id)
 {
@@ -655,6 +665,14 @@ static inline int cgroup_attach_task_current_cg(struct task_struct *t)
 	return 0;
 }
 
+#define SUBSYS(_x)
+#define SUBSYS_UNDEFINED(_x)\
+	static inline bool cgroup_ ## _x ## _disabled(void){\
+		return true;}
+#include <linux/cgroup_subsys.h>
+#undef SUBSYS
+#undef SUBSYS_UNDEFINED
+
 #endif /* !CONFIG_CGROUPS */
 
 #endif /* _LINUX_CGROUP_H */
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index ac663c1..f3eaee8 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -9,58 +9,98 @@
 
 #ifdef CONFIG_CPUSETS
 SUBSYS(cpuset)
+#else
+#ifdef SUBSYS_DEFINED
+SUBSYS_UNDEFINED(cpuset)
+#endif
 #endif
 
 /* */
 
 #ifdef CONFIG_CGROUP_DEBUG
 SUBSYS(debug)
+#else
+#ifdef SUBSYS_UNDEFINED
+SUBSYS_UNDEFINED(debug)
+#endif
 #endif
 
 /* */
 
 #ifdef CONFIG_CGROUP_SCHED
 SUBSYS(cpu_cgroup)
+#else
+#ifdef SUBSYS_UNDEFINED
+SUBSYS_UNDEFINED(cpu_cgroup)
+#endif
 #endif
 
 /* */
 
 #ifdef CONFIG_CGROUP_CPUACCT
 SUBSYS(cpuacct)
+#else
+#ifdef SUBSYS_UNDEFINED
+SUBSYS_UNDEFINED(cpuacct)
+#endif
 #endif
 
 /* */
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 SUBSYS(mem_cgroup)
+#else
+#ifdef SUBSYS_UNDEFINED
+SUBSYS_UNDEFINED(mem_cgroup)
+#endif
 #endif
 
 /* */
 
 #ifdef CONFIG_CGROUP_DEVICE
 SUBSYS(devices)
+#else
+#ifdef SUBSYS_UNDEFINED
+SUBSYS_UNDEFINED(devices)
+#endif
 #endif
 
 /* */
 
 #ifdef CONFIG_CGROUP_FREEZER
 SUBSYS(freezer)
+#else
+#ifdef SUBSYS_UNDEFINED
+SUBSYS_UNDEFINED(freezer)
+#endif
 #endif
 
 /* */
 
 #ifdef CONFIG_NET_CLS_CGROUP
 SUBSYS(net_cls)
+#else
+#ifdef SUBSYS_DEFINED
+SUBSYS_UNDEFINED(net_cls)
+#endif
 #endif
 
 /* */
 
 #ifdef CONFIG_BLK_CGROUP
 SUBSYS(blkio)
+#else
+#ifdef SUBSYS_UNDEFINED
+SUBSYS_UNDEFINED(blkio)
+#endif
 #endif
 
 #ifdef CONFIG_CGROUP_PERF
 SUBSYS(perf)
+#else
+#ifdef SUBSYS_UNDEFINED
+SUBSYS_UNDEFINED(perf)
+#endif
 #endif
 
 /* */
-- 
1.7.4.1


