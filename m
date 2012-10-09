Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab2JIRkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:40:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33481 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434Ab2JIRkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:40:45 -0400
Date: Tue, 9 Oct 2012 10:40:14 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-355afe816312faf20d81fdcade29e0361d72a7b4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        haodong@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
        haodong@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1349716656-48165-9-git-send-email-dsahern@gmail.com>
References: <1349716656-48165-9-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm: Add braces around multi-line statements
Git-Commit-ID: 355afe816312faf20d81fdcade29e0361d72a7b4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 09 Oct 2012 10:40:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  355afe816312faf20d81fdcade29e0361d72a7b4
Gitweb:     http://git.kernel.org/tip/355afe816312faf20d81fdcade29e0361d72a7b4
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Mon, 8 Oct 2012 11:17:32 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 8 Oct 2012 17:15:54 -0300

perf kvm: Add braces around multi-line statements

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
 1 files changed, 6 insertions(+), 3 deletions(-)

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
