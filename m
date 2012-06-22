Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262Ab2FVPgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:36:52 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:36349 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933224Ab2FVPgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:36:48 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 06/17] rcu: Remove return value from RCU_INIT_POINTER()
Date: Fri, 22 Jun 2012 08:35:01 -0700
Message-Id: <1340379312-6684-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1340379312-6684-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120622153501.GA6626@linux.vnet.ibm.com>
 <1340379312-6684-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062215-5806-0000-0000-00001688E4E6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The return value from RCU_INIT_POINTER() is not used, and using it
would be quite ugly, for example:

	q = RCU_INIT_POINTER(global_p, p);

To prevent this sort of ugliness from appearing, this commit wraps
RCU_INIT_POINTER() in a do-while loop.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/rcupdate.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 88e4e08..267dc77 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -904,7 +904,9 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
  * the reader-accessible portions of the linked structure.
  */
 #define RCU_INIT_POINTER(p, v) \
-		p = (typeof(*v) __force __rcu *)(v)
+	do { \
+		p = (typeof(*v) __force __rcu *)(v); \
+	} while (0)
 
 /**
  * RCU_POINTER_INITIALIZER() - statically initialize an RCU protected pointer
-- 
1.7.8

