Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762637Ab2FVPga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:36:30 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:35643 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755747Ab2FVPg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:36:27 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 05/17] rcu: Use new RCU_POINTER_INITIALIZER for gcc-style initializations
Date: Fri, 22 Jun 2012 08:35:00 -0700
Message-Id: <1340379312-6684-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1340379312-6684-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120622153501.GA6626@linux.vnet.ibm.com>
 <1340379312-6684-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062215-5806-0000-0000-00001688E1DA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit applies the INIT_RCU_POINTER() macro to all uses of
RCU_POINTER_INITIALIZER() that were all too cleverly creating gcc-style
initializations.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/init_task.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index e4baff5..771b272 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -168,8 +168,8 @@ extern struct cred init_cred;
 	.children	= LIST_HEAD_INIT(tsk.children),			\
 	.sibling	= LIST_HEAD_INIT(tsk.sibling),			\
 	.group_leader	= &tsk,						\
-	RCU_INIT_POINTER(.real_cred, &init_cred),			\
-	RCU_INIT_POINTER(.cred, &init_cred),				\
+	RCU_POINTER_INITIALIZER(real_cred, &init_cred),			\
+	RCU_POINTER_INITIALIZER(cred, &init_cred),			\
 	.comm		= INIT_TASK_COMM,				\
 	.thread		= INIT_THREAD,					\
 	.fs		= &init_fs,					\
-- 
1.7.8

