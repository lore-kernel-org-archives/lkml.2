Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab2JIReF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:34:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33117 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab2JIReA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:34:00 -0400
Date: Tue, 9 Oct 2012 10:33:40 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-of7tc8eqeuk3cupc6f7jtuq6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Handle PERF_RECORD_EXIT events
Git-Commit-ID: ec4622f5fdfa2467befa6d750675db3d3258edc5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 09 Oct 2012 10:33:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ec4622f5fdfa2467befa6d750675db3d3258edc5
Gitweb:     http://git.kernel.org/tip/ec4622f5fdfa2467befa6d750675db3d3258edc5
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 6 Oct 2012 15:53:41 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 6 Oct 2012 16:33:56 -0300

perf annotate: Handle PERF_RECORD_EXIT events

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
 1 files changed, 1 insertions(+), 0 deletions(-)

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
