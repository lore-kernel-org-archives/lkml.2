Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab2GYTWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 15:22:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58307 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab2GYTWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 15:22:09 -0400
Date: Wed, 25 Jul 2012 12:21:50 -0700
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Message-ID: <tip-8760db726e2afcd1a78e2ff58965c6b35a5826cb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, a.p.zijlstra@chello.nl,
        dsahern@gmail.com, tglx@linutronix.de, namhyung@gmail.com,
        jolsa@redhat.com
In-Reply-To: <1342631456-7233-2-git-send-email-fweisbec@gmail.com>
References: <1342631456-7233-2-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists:
  Return correct number of characters printed in callchain
Git-Commit-ID: 8760db726e2afcd1a78e2ff58965c6b35a5826cb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 25 Jul 2012 12:21:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8760db726e2afcd1a78e2ff58965c6b35a5826cb
Gitweb:     http://git.kernel.org/tip/8760db726e2afcd1a78e2ff58965c6b35a5826cb
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Wed, 18 Jul 2012 19:10:55 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 25 Jul 2012 11:31:37 -0300

perf hists: Return correct number of characters printed in callchain

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
