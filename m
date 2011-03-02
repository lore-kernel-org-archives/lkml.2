Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab1CBIlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 03:41:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:45246 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756046Ab1CBIlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 03:41:11 -0500
Date: Wed, 2 Mar 2011 08:40:47 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top browser: Handle empty active symbols list
Message-ID: <tip-3166fc8fb6a2f52273d545e970297524e02c3e39@git.kernel.org>
Git-Commit-ID: 3166fc8fb6a2f52273d545e970297524e02c3e39
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Mar 2011 08:40:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3166fc8fb6a2f52273d545e970297524e02c3e39
Gitweb:     http://git.kernel.org/tip/3166fc8fb6a2f52273d545e970297524e02c3e39
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 1 Mar 2011 10:21:44 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 1 Mar 2011 10:21:44 -0300

perf top browser: Handle empty active symbols list

Fixing a SEGV. An empty list could happen when not being able to resolve
symbols, for instance when --vmlinux invalid-file is used.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/top.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/ui/browsers/top.c b/tools/perf/util/ui/browsers/top.c
index e9381ec..5a06538 100644
--- a/tools/perf/util/ui/browsers/top.c
+++ b/tools/perf/util/ui/browsers/top.c
@@ -76,6 +76,12 @@ static void perf_top_browser__update_rb_tree(struct perf_top_browser *browser)
 	browser->root = RB_ROOT;
 	browser->b.top = NULL;
 	browser->sum_ksamples = perf_top__decay_samples(top, &browser->root);
+	/*
+ 	 * No active symbols
+ 	 */
+	if (top->rb_entries == 0)
+		return;
+
 	perf_top__find_widths(top, &browser->root, &browser->dso_width,
 			      &browser->dso_short_width,
                               &browser->sym_width);
