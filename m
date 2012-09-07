Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391Ab2IGObd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 10:31:33 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34564 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933364Ab2IGObY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 10:31:24 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com,
        zheng.z.yan@intel.com, robert.richter@amd.com
Subject: [PATCH 3/3] perf: remove jiffies_interval
Date: Fri,  7 Sep 2012 16:29:29 +0200
Message-Id: <1347028169-1983-4-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1347028169-1983-1-git-send-email-eranian@google.com>
References: <1347028169-1983-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Obsolete because superseded by hrtimer based
multiplexing.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 include/linux/perf_event.h |    1 -
 kernel/events/core.c       |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 21c3bb0..b0cb209 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1107,7 +1107,6 @@ struct perf_cpu_context {
 	int				active_oncpu;
 	int				exclusive;
 	struct list_head		rotation_list;
-	int				jiffies_interval;
 	struct pmu			*active_pmu;
 	struct perf_cgroup		*cgrp;
 };
diff --git a/kernel/events/core.c b/kernel/events/core.c
index fd53509..e0db140 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6126,7 +6126,6 @@ int perf_pmu_register(struct pmu *pmu, char *name, int type)
 		lockdep_set_class(&cpuctx->ctx.lock, &cpuctx_lock);
 		cpuctx->ctx.type = cpu_context;
 		cpuctx->ctx.pmu = pmu;
-		cpuctx->jiffies_interval = 1;
 		INIT_LIST_HEAD(&cpuctx->rotation_list);
 		cpuctx->active_pmu = pmu;
 	}
-- 
1.7.5.4

