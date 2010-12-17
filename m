Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab0LQUzM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 15:55:12 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46095 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204Ab0LQUzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 15:55:09 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 20/20] rcu: remove unused __list_for_each_rcu() macro
Date: Fri, 17 Dec 2010 12:54:51 -0800
Message-Id: <1292619291-2468-20-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20101217205433.GA10199@linux.vnet.ibm.com>
References: <20101217205433.GA10199@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rculist.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index 70d3ba5..2dea94f 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -241,11 +241,6 @@ static inline void list_splice_init_rcu(struct list_head *list,
 #define list_first_entry_rcu(ptr, type, member) \
 	list_entry_rcu((ptr)->next, type, member)
 
-#define __list_for_each_rcu(pos, head) \
-	for (pos = rcu_dereference_raw(list_next_rcu(head)); \
-		pos != (head); \
-		pos = rcu_dereference_raw(list_next_rcu(pos)))
-
 /**
  * list_for_each_entry_rcu	-	iterate over rcu list of given type
  * @pos:	the type * to use as a loop cursor.
-- 
1.7.3.2

