Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab2FOUNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 16:13:48 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:59760 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757638Ab2FOUNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 16:13:45 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 05/14] rcu: Use new INIT_RCU_POINTER for gcc-style initializations
Date: Fri, 15 Jun 2012 13:13:06 -0700
Message-Id: <1339791195-26389-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1339791195-26389-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120615201256.GA26120@linux.vnet.ibm.com>
 <1339791195-26389-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061520-7408-0000-0000-000005E491C9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit applies the INIT_RCU_POINTER() macro to all uses of
RCU_INIT_POINTER() that were all too cleverly creating gcc-style
initializations.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/init_task.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index e4baff5..cdaa339 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -168,8 +168,8 @@ extern struct cred init_cred;
 	.children	= LIST_HEAD_INIT(tsk.children),			\
 	.sibling	= LIST_HEAD_INIT(tsk.sibling),			\
 	.group_leader	= &tsk,						\
-	RCU_INIT_POINTER(.real_cred, &init_cred),			\
-	RCU_INIT_POINTER(.cred, &init_cred),				\
+	INIT_RCU_POINTER(real_cred, &init_cred),			\
+	INIT_RCU_POINTER(cred, &init_cred),				\
 	.comm		= INIT_TASK_COMM,				\
 	.thread		= INIT_THREAD,					\
 	.fs		= &init_fs,					\
-- 
1.7.8

