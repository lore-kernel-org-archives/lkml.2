Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab2JHWe3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 18:34:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:41443 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab2JHWdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 18:33:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Dong Hao <haodong@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 22/25] perf kvm: Add braces around multi-line statements
Date: Mon,  8 Oct 2012 19:32:47 -0300
Message-Id: <1349735570-19339-23-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349735570-19339-1-git-send-email-acme@infradead.org>
References: <1349735570-19339-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Multi-line statements should have braces. Improves readability.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Dong Hao <haodong@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1349716656-48165-9-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 72a302e..836c82f 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -369,9 +369,10 @@ static struct kvm_event *find_create_kvm_event(struct perf_kvm *kvm,
 	BUG_ON(key->key == INVALID_KEY);
 
 	head = &kvm->kvm_events_cache[kvm_events_hash_fn(key->key)];
-	list_for_each_entry(event, head, hash_entry)
+	list_for_each_entry(event, head, hash_entry) {
 		if (event->key.key == key->key && event->key.info == key->info)
 			return event;
+	}
 
 	event = kvm_alloc_init_event(key);
 	if (!event)
@@ -610,13 +611,15 @@ static void sort_result(struct perf_kvm *kvm)
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
1.7.9.2.358.g22243

