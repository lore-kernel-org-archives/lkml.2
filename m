Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab2H3Vnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:43:49 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:40543 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab2H3Vnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:43:43 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 15/15] kmemleak: Replace list_for_each_continue_rcu with new interface
Date: Thu, 30 Aug 2012 11:56:28 -0700
Message-Id: <1346352988-32444-15-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083021-4242-0000-0000-000002BA070F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

This patch replaces list_for_each_continue_rcu() with
list_for_each_entry_continue_rcu() to save a few lines
of code and allow removing list_for_each_continue_rcu().

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 mm/kmemleak.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 45eb621..0de83b4 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1483,13 +1483,11 @@ static void *kmemleak_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	struct kmemleak_object *prev_obj = v;
 	struct kmemleak_object *next_obj = NULL;
-	struct list_head *n = &prev_obj->object_list;
+	struct kmemleak_object *obj = prev_obj;
 
 	++(*pos);
 
-	list_for_each_continue_rcu(n, &object_list) {
-		struct kmemleak_object *obj =
-			list_entry(n, struct kmemleak_object, object_list);
+	list_for_each_entry_continue_rcu(obj, &object_list, object_list) {
 		if (get_object(obj)) {
 			next_obj = obj;
 			break;
-- 
1.7.8

