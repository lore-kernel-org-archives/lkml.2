Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab2FOUNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 16:13:36 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44375 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958Ab2FOUNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 16:13:32 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 06/14] rcu: Remove return value from RCU_INIT_POINTER()
Date: Fri, 15 Jun 2012 13:13:07 -0700
Message-Id: <1339791195-26389-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1339791195-26389-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120615201256.GA26120@linux.vnet.ibm.com>
 <1339791195-26389-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061520-7182-0000-0000-000001C1C9AA
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
---
 include/linux/rcupdate.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index eb92c21..f2cca02 100644
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
  * INIT_RCU_POINTER() - statically initialize an RCU protected pointer
-- 
1.7.8

