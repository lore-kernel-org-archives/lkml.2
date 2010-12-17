Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab0LQUzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 15:55:44 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:45610 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756244Ab0LQUzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 15:55:14 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        Mariusz Kozlowski <mk@lab.zgora.pl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 19/20] rculist: fix borked __list_for_each_rcu() macro
Date: Fri, 17 Dec 2010 12:54:50 -0800
Message-Id: <1292619291-2468-19-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20101217205433.GA10199@linux.vnet.ibm.com>
References: <20101217205433.GA10199@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Kozlowski <mk@lab.zgora.pl>

This restores parentheses blance.

Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rculist.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index f31ef61..70d3ba5 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -244,7 +244,7 @@ static inline void list_splice_init_rcu(struct list_head *list,
 #define __list_for_each_rcu(pos, head) \
 	for (pos = rcu_dereference_raw(list_next_rcu(head)); \
 		pos != (head); \
-		pos = rcu_dereference_raw(list_next_rcu((pos)))
+		pos = rcu_dereference_raw(list_next_rcu(pos)))
 
 /**
  * list_for_each_entry_rcu	-	iterate over rcu list of given type
-- 
1.7.3.2

