Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab1HEKIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 06:08:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:32981 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756053Ab1HEKIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 06:08:50 -0400
Date: Fri, 5 Aug 2011 10:08:20 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-ag9fz2wd17mbbfjsbznq1wms@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, phyomh@gmail.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, asharma@fb.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, phyomh@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, asharma@fb.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf report: Use ui__warning in some more places
Git-Commit-ID: 00894ce9b85887caa0c16e18757004b9cc9f64cf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Aug 2011 10:08:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  00894ce9b85887caa0c16e18757004b9cc9f64cf
Gitweb:     http://git.kernel.org/tip/00894ce9b85887caa0c16e18757004b9cc9f64cf
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 3 Aug 2011 12:33:24 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 3 Aug 2011 12:33:24 -0300

perf report: Use ui__warning in some more places

So that we get a proper warning in the TUI in cases like:

 $ perf report --stdio -g fractal,0.5,caller --sort pid
 Selected -g but no callchain data. Did you call 'perf record' without -g?
 $

The --stdio case is ok because it uses fprintf, ui__warning is needed to
figure out if --stdio or --tui is being used.

Cc: Arun Sharma <asharma@fb.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sam Liao <phyomh@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ag9fz2wd17mbbfjsbznq1wms@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f854efd..d7ff277 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -162,23 +162,22 @@ static int perf_session__setup_sample_type(struct perf_session *self)
 {
 	if (!(self->sample_type & PERF_SAMPLE_CALLCHAIN)) {
 		if (sort__has_parent) {
-			fprintf(stderr, "selected --sort parent, but no"
-					" callchain data. Did you call"
-					" perf record without -g?\n");
+			ui__warning("Selected --sort parent, but no "
+				    "callchain data. Did you call "
+				    "'perf record' without -g?\n");
 			return -EINVAL;
 		}
 		if (symbol_conf.use_callchain) {
-			fprintf(stderr, "selected -g but no callchain data."
-					" Did you call perf record without"
-					" -g?\n");
+			ui__warning("Selected -g but no callchain data. Did "
+				    "you call 'perf record' without -g?\n");
 			return -1;
 		}
 	} else if (!dont_use_callchains && callchain_param.mode != CHAIN_NONE &&
 		   !symbol_conf.use_callchain) {
 			symbol_conf.use_callchain = true;
 			if (callchain_register_param(&callchain_param) < 0) {
-				fprintf(stderr, "Can't register callchain"
-						" params\n");
+				ui__warning("Can't register callchain "
+					    "params.\n");
 				return -EINVAL;
 			}
 	}
