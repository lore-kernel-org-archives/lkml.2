Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab2GYRps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:45:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55604 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab2GYRln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:41:43 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/19] perf hists: Return correct number of characters printed in callchain
Date: Wed, 25 Jul 2012 14:41:22 -0300
Message-Id: <1343238094-12481-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1343238094-12481-1-git-send-email-acme@infradead.org>
References: <1343238094-12481-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Include the omitted number of characters printed for the first entry.

Not that it really matters because nobody seem to care about the number
of printed characters for now. But just in case.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1342631456-7233-2-git-send-email-fweisbec@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 514e2a4..90dc35a 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -708,7 +708,7 @@ static size_t callchain__fprintf_graph(FILE *fp, struct rb_root *root,
 	bool printed = false;
 	struct rb_node *node;
 	int i = 0;
-	int ret;
+	int ret = 0;
 
 	/*
 	 * If have one single callchain root, don't bother printing
@@ -747,8 +747,9 @@ static size_t callchain__fprintf_graph(FILE *fp, struct rb_root *root,
 		root = &cnode->rb_root;
 	}
 
-	return __callchain__fprintf_graph(fp, root, total_samples,
+	ret += __callchain__fprintf_graph(fp, root, total_samples,
 					  1, 1, left_margin);
+	return ret;
 }
 
 static size_t __callchain__fprintf_flat(FILE *fp,
-- 
1.7.1

