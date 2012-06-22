Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061Ab2FVPfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:35:34 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:41521 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932969Ab2FVPfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:35:31 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 07/17] key: Remove extraneous parentheses from rcu_assign_keypointer()
Date: Fri, 22 Jun 2012 08:35:02 -0700
Message-Id: <1340379312-6684-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1340379312-6684-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120622153501.GA6626@linux.vnet.ibm.com>
 <1340379312-6684-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062215-7606-0000-0000-000001610723
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit removes the extraneous parentheses from rcu_assign_keypointer()
so that rcu_assign_pointer() can be wrapped in do-while.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/key.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/key.h b/include/linux/key.h
index 4cd22ed..6fafcf4 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -303,7 +303,7 @@ static inline bool key_is_instantiated(const struct key *key)
 				   rwsem_is_locked(&((struct key *)(KEY))->sem)))
 
 #define rcu_assign_keypointer(KEY, PAYLOAD)				\
-	(rcu_assign_pointer((KEY)->payload.rcudata, PAYLOAD))
+	rcu_assign_pointer((KEY)->payload.rcudata, PAYLOAD)
 
 #ifdef CONFIG_SYSCTL
 extern ctl_table key_sysctls[];
-- 
1.7.8

