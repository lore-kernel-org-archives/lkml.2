Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab2GRRLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 13:11:33 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44953 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab2GRRLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 13:11:05 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 2/3] perf tools: Return correct number of characters printed in callchain
Date: Wed, 18 Jul 2012 19:10:55 +0200
Message-Id: <1342631456-7233-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1342631456-7233-1-git-send-email-fweisbec@gmail.com>
References: <1342631456-7233-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include the omitted number of characters printed for the first entry.

Not that it really matters because nobody seem to care about the number
of printed characters for now. But just in case.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
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
1.7.5.4

