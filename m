Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965109Ab2B1KmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 05:42:01 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:59643 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964941Ab2B1Kl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 05:41:58 -0500
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Turner <pjt@google.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH 2/2] sched: load-tracking compile when cgroup undefined
Date: Wed, 29 Feb 2012 10:37:39 +0000
Message-Id: <1330511859-22032-3-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20120202013827.20844.49057.stgit@kitami.mtv.corp.google.com>
References: <20120202013827.20844.49057.stgit@kitami.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.7.1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------1.7.1
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


Fix compilation when CGROUPs are not configured.
---
 kernel/sched/fair.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)


--------------1.7.1
Content-Type: text/x-patch; name="0002-sched-load-tracking-compile-when-cgroup-undefined.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="0002-sched-load-tracking-compile-when-cgroup-undefined.patch"

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0cea5e4..127fbd2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1306,7 +1306,7 @@ inline void remove_task_load_avg_async(struct task_struct *p)
 }
 
 #else
-static inline update_entity_load_avg(struct sched_entity *se,
+static inline void update_entity_load_avg(struct sched_entity *se,
 				     int update_cfs_rq) {}
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable) {}
 static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
@@ -1316,6 +1316,8 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
 						  struct sched_entity *se,
 						  int sleep) {}
 inline void remove_task_load_avg_async(struct task_struct *p) {}
+static inline void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq,
+	int force_update) {}
 #endif
 
 static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)

--------------1.7.1--


