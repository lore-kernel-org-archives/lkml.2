Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab1A1RNJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 12:13:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:54611 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab1A1RNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 12:13:08 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Han Pingtian <phan@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/4] perf test: Fix return values checking
Date: Fri, 28 Jan 2011 15:13:03 -0200
Message-Id: <1296234783-17491-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1296234783-17491-1-git-send-email-acme@infradead.org>
References: <1296234783-17491-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Han Pingtian <phan@redhat.com>

Fixing some cut'n'paste mistakes.

LKML-Reference: <20110124233900.GA3443@epc900.nay.redhat.com>
Signed-off-by: Han Pingtian <phan@redhat.com>
[ committer note: I had already removed the CPU_ALLOC calls ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-test.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 231e3e2..738830d 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -495,8 +495,8 @@ static int test__basic_mmap(void)
 	}
 
 	cpus = cpu_map__new(NULL);
-	if (threads == NULL) {
-		pr_debug("thread_map__new\n");
+	if (cpus == NULL) {
+		pr_debug("cpu_map__new\n");
 		goto out_free_threads;
 	}
 
@@ -510,7 +510,7 @@ static int test__basic_mmap(void)
 	}
 
 	evlist = perf_evlist__new();
-	if (threads == NULL) {
+	if (evlist == NULL) {
 		pr_debug("perf_evlist__new\n");
 		goto out_free_cpus;
 	}
-- 
1.6.2.5

