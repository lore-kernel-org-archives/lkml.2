Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab1K1XfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:35:22 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:36993 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755026Ab1K1Xd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:33:58 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 04/13] rcu: Update trace_rcu_dyntick() header comment
Date: Mon, 28 Nov 2011 15:32:56 -0800
Message-Id: <1322523185-456-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111128233212.GA32279@linux.vnet.ibm.com>
References: <20111128233212.GA32279@linux.vnet.ibm.com>
x-cbid: 11112823-8974-0000-0000-00000380646F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

This commit updates the trace_rcu_dyntick() header comment to reflect
events added by commit 4b4f421.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/trace/events/rcu.h |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index c29fb2f..7f6877a 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -241,8 +241,16 @@ TRACE_EVENT(rcu_fqs,
 
 /*
  * Tracepoint for dyntick-idle entry/exit events.  These take a string
- * as argument: "Start" for entering dyntick-idle mode and "End" for
- * leaving it.
+ * as argument: "Start" for entering dyntick-idle mode, "End" for
+ * leaving it, "--=" for events moving towards idle, and "++=" for events
+ * moving away from idle.  "Error on entry: not idle task" and "Error on
+ * exit: not idle task" indicate that a non-idle task is erroneously
+ * toying with the idle loop.
+ *
+ * These events also take a pair of numbers, which indicate the nesting
+ * depth before and after the event of interest.  Note that task-related
+ * events use the upper bits of each number, while interrupt-related
+ * events use the lower bits.
  */
 TRACE_EVENT(rcu_dyntick,
 
-- 
1.7.3.2

