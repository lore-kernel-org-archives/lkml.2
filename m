Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab2JHWes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 18:34:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:41438 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab2JHWdj (ORCPT
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
Subject: [PATCH 20/25] perf kvm: Remove typecast in init_kvm_event_record
Date: Mon,  8 Oct 2012 19:32:45 -0300
Message-Id: <1349735570-19339-21-git-send-email-acme@infradead.org>
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

Not needed after changing i to unsigned int.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Dong Hao <haodong@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1349716656-48165-7-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index b98095e..8416754 100644
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
1.7.9.2.358.g22243

