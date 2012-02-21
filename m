Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab2BUR7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 12:59:42 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:60803 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab2BUR7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 12:59:37 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        Hugh Dickins <hughd@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/4] rcu: Stop spurious warnings from synchronize_sched_expedited
Date: Tue, 21 Feb 2012 09:58:29 -0800
Message-Id: <1329847110-10897-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1329847110-10897-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120221175810.GA10708@linux.vnet.ibm.com>
 <1329847110-10897-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022117-6148-0000-0000-000003A1B65E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

synchronize_sched_expedited() is spamming CONFIG_DEBUG_PREEMPT=y
users with an unintended warning from the cpu_is_offline() check:
use raw_smp_processor_id() instead of smp_processor_id() there.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index eacc10b..1050d6d 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2014,7 +2014,7 @@ void synchronize_sched_expedited(void)
 	/* Note that atomic_inc_return() implies full memory barrier. */
 	firstsnap = snap = atomic_inc_return(&sync_sched_expedited_started);
 	get_online_cpus();
-	WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));
+	WARN_ON_ONCE(cpu_is_offline(raw_smp_processor_id()));
 
 	/*
 	 * Each pass through the following loop attempts to force a
-- 
1.7.8

