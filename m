Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab2JHRT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 13:19:59 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:39227 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350Ab2JHRS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 13:18:29 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Dong Hao <haodong@linux.vnet.ibm.com>
Subject: [PATCH 06/12] perf kvm: remove typecast in init_kvm_event_record
Date: Mon,  8 Oct 2012 11:17:30 -0600
Message-Id: <1349716656-48165-7-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1349716656-48165-1-git-send-email-dsahern@gmail.com>
References: <1349716656-48165-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not needed after changing i to unsigned int.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Dong Hao <haodong@linux.vnet.ibm.com>
---
 tools/perf/builtin-kvm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 260abc5..a23db89 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -313,9 +313,9 @@ struct vcpu_event_record {
 
 static void init_kvm_event_record(struct perf_kvm *kvm)
 {
-	int i;
+	unsigned int i;
 
-	for (i = 0; i < (int)EVENTS_CACHE_SIZE; i++)
+	for (i = 0; i < EVENTS_CACHE_SIZE; i++)
 		INIT_LIST_HEAD(&kvm->kvm_events_cache[i]);
 }
 
-- 
1.7.10.1

