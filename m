Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab1AOPk6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 10:40:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:37043 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab1AOPk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 10:40:57 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Han Pingtian <phan@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 14/16] perf test: check if cpu_map__new() return NULL
Date: Sat, 15 Jan 2011 13:40:43 -0200
Message-Id: <1295106045-31192-15-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295106045-31192-1-git-send-email-acme@infradead.org>
References: <1295106045-31192-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Han Pingtian <phan@redhat.com>

It looks like we should check if cpus is NULL after

	cpus = cpu_map__new(NULL);

in test__open_syscall_event_on_all_cpus().

LKML-Reference: <20110114230050.GA7011@localhost>
Signed-off-by: Han Pingtian <phan@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-test.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 438d8a9..b03cb3a 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -348,9 +348,9 @@ static int test__open_syscall_event_on_all_cpus(void)
 	}
 
 	cpus = cpu_map__new(NULL);
-	if (threads == NULL) {
-		pr_debug("thread_map__new\n");
-		return -1;
+	if (cpus == NULL) {
+		pr_debug("cpu_map__new\n");
+		goto out_thread_map_delete;
 	}
 
 	cpu_set = CPU_ALLOC(cpus->nr);
-- 
1.6.2.5

