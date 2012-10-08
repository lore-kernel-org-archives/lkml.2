Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab2JHRSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 13:18:43 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39941 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab2JHRSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 13:18:40 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Dong Hao <haodong@linux.vnet.ibm.com>
Subject: [PATCH 08/12] perf kvm: add braces around multi-line statements
Date: Mon,  8 Oct 2012 11:17:32 -0600
Message-Id: <1349716656-48165-9-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1349716656-48165-1-git-send-email-dsahern@gmail.com>
References: <1349716656-48165-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Multi-line statements should have braces. Improves readability.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Dong Hao <haodong@linux.vnet.ibm.com>
---
 tools/perf/builtin-kvm.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index af74a97..43fd71c 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -372,9 +372,10 @@ static struct kvm_event *find_create_kvm_event(struct perf_kvm *kvm,
 	BUG_ON(key->key == INVALID_KEY);
 
 	head = &kvm->kvm_events_cache[kvm_events_hash_fn(key->key)];
-	list_for_each_entry(event, head, hash_entry)
+	list_for_each_entry(event, head, hash_entry) {
 		if (event->key.key == key->key && event->key.info == key->info)
 			return event;
+	}
 
 	event = kvm_alloc_init_event(key);
 	if (!event)
@@ -599,13 +600,15 @@ static void sort_result(struct perf_kvm *kvm)
 	int vcpu = kvm->trace_vcpu;
 	struct kvm_event *event;
 
-	for (i = 0; i < EVENTS_CACHE_SIZE; i++)
-		list_for_each_entry(event, &kvm->kvm_events_cache[i], hash_entry)
+	for (i = 0; i < EVENTS_CACHE_SIZE; i++) {
+		list_for_each_entry(event, &kvm->kvm_events_cache[i], hash_entry) {
 			if (event_is_valid(event, vcpu)) {
 				update_total_count(kvm, event);
 				insert_to_result(&kvm->result, event,
 						 kvm->compare, vcpu);
 			}
+		}
+	}
 }
 
 /* returns left most element of result, and erase it */
-- 
1.7.10.1

