Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab1KOU3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 15:29:13 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54079 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932278Ab1KOU3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 15:29:10 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 9/9] tile: Make tile use the new is_idle_task() API
Date: Tue, 15 Nov 2011 12:28:05 -0800
Message-Id: <1321388885-11211-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111115202736.GA11030@linux.vnet.ibm.com>
References: <20111115202736.GA11030@linux.vnet.ibm.com>
x-cbid: 11111520-3534-0000-0000-000001F6316D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Change from direct comparison of ->pid with zero to is_idle_task().

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/tile/mm/fault.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
index 25b7b90..c1eaaa1 100644
--- a/arch/tile/mm/fault.c
+++ b/arch/tile/mm/fault.c
@@ -54,7 +54,7 @@ static noinline void force_sig_info_fault(const char *type, int si_signo,
 	if (unlikely(tsk->pid < 2)) {
 		panic("Signal %d (code %d) at %#lx sent to %s!",
 		      si_signo, si_code & 0xffff, address,
-		      tsk->pid ? "init" : "the idle task");
+		      is_idle_task(tsk) ? "the idle task" : "init");
 	}
 
 	info.si_signo = si_signo;
@@ -515,7 +515,7 @@ no_context:
 
 	if (unlikely(tsk->pid < 2)) {
 		panic("Kernel page fault running %s!",
-		      tsk->pid ? "init" : "the idle task");
+		      is_idle_task(tsk) ? "the idle task" : "init");
 	}
 
 	/*
-- 
1.7.3.2

