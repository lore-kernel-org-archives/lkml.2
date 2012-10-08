Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab2JHWdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 18:33:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:41338 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab2JHWdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 18:33:07 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 15/25] perf annotate: Handle PERF_RECORD_EXIT events
Date: Mon,  8 Oct 2012 19:32:40 -0300
Message-Id: <1349735570-19339-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349735570-19339-1-git-send-email-acme@infradead.org>
References: <1349735570-19339-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Noticed annotate wasn't handling those events while introducing
perf_event__process_{fork,exit}.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-of7tc8eqeuk3cupc6f7jtuq6@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index cca2fb5..690fa9a 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -246,6 +246,7 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 			.sample	= process_sample_event,
 			.mmap	= perf_event__process_mmap,
 			.comm	= perf_event__process_comm,
+			.exit	= perf_event__process_exit,
 			.fork	= perf_event__process_fork,
 			.ordered_samples = true,
 			.ordering_requires_timestamps = true,
-- 
1.7.9.2.358.g22243

