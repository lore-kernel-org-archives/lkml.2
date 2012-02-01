Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab2BATn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:43:27 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40816 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756783Ab2BATnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:43:24 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 04/41] rcu: Add diagnostic for misaligned rcu_head structures
Date: Wed,  1 Feb 2012 11:41:22 -0800
Message-Id: <1328125319-5205-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-1976-0000-0000-00000A09ADD1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The push for energy efficiency will require that RCU tag rcu_head
structures to indicate whether or not their invocation is time critical.
This tagging is best carried out in the bottom bits of the ->next
pointers in the rcu_head structures.  This tagging requires that the
rcu_head structures be properly aligned, so this commit adds the required
diagnostics.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d0f8e64..4655f3e 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1707,6 +1707,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	unsigned long flags;
 	struct rcu_data *rdp;
 
+	WARN_ON_ONCE((unsigned long)head & 0x3); /* Misaligned rcu_head! */
 	debug_rcu_head_queue(head);
 	head->func = func;
 	head->next = NULL;
-- 
1.7.8

