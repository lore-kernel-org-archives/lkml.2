Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab0KGCGv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 22:06:51 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38307 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720Ab0KGCFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 22:05:41 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 07/12] rcu: get rid of obsolete "classic" names in TREE_RCU tracing
Date: Sat,  6 Nov 2010 19:05:27 -0700
Message-Id: <1289095532-5398-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20101107020507.GA4974@linux.vnet.ibm.com>
References: <20101107020507.GA4974@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TREE_RCU tracing had obsolete rcuclassic_trace_init() and
rcuclassic_trace_cleanup() function names.  This commit brings them
up to date: rcutree_trace_init() and rcutree_trace_cleanup(),
respectively.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_trace.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index d15430b..78ad3c3 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -300,7 +300,7 @@ static const struct file_operations rcu_pending_fops = {
 
 static struct dentry *rcudir;
 
-static int __init rcuclassic_trace_init(void)
+static int __init rcutree_trace_init(void)
 {
 	struct dentry *retval;
 
@@ -337,14 +337,14 @@ free_out:
 	return 1;
 }
 
-static void __exit rcuclassic_trace_cleanup(void)
+static void __exit rcutree_trace_cleanup(void)
 {
 	debugfs_remove_recursive(rcudir);
 }
 
 
-module_init(rcuclassic_trace_init);
-module_exit(rcuclassic_trace_cleanup);
+module_init(rcutree_trace_init);
+module_exit(rcutree_trace_cleanup);
 
 MODULE_AUTHOR("Paul E. McKenney");
 MODULE_DESCRIPTION("Read-Copy Update tracing for hierarchical implementation");
-- 
1.7.0.6

