Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685Ab1AKTvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 14:51:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:52665 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932646Ab1AKTvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 14:51:13 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Kirill Smelkov <kirr@mns.spb.ru>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/3] perf top: Fix annotate segv
Date: Tue, 11 Jan 2011 17:50:37 -0200
Message-Id: <1294775438-14324-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1294775438-14324-1-git-send-email-acme@infradead.org>
References: <1294775438-14324-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Before we had sym_counter, it was initialized to zero and we used that
as an index in the global attrs variable, now we have a list of evsel
entries, and sym_counter became sym_evsel, that remained initialized to
zero (NULL): b00m.

Fix it by initializing it to the first entry in the evsel list.

Bug-introduced: 69aad6f
Reported-by: Kirill Smelkov <kirr@mns.spb.ru>
Tested-by: Kirill Smelkov <kirr@mns.spb.ru>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Kirill Smelkov <kirr@mns.spb.ru>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 4b995ee..568b195 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1473,6 +1473,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		pos->attr.sample_period = default_interval;
 	}
 
+	sym_evsel = list_entry(evsel_list.next, struct perf_evsel, node);
+
 	symbol_conf.priv_size = (sizeof(struct sym_entry) +
 				 (nr_counters + 1) * sizeof(unsigned long));
 
-- 
1.6.2.5

