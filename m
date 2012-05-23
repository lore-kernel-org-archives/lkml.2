Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760460Ab2EWPb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:31:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41042 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933707Ab2EWPb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:31:56 -0400
Date: Wed, 23 May 2012 08:31:30 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-2jafa6mkrufyekny9ei59lpu@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Bump default sample freq to 4 kHz
Git-Commit-ID: 447a6013e91738c0d4118a7d0c56f235d8623695
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 23 May 2012 08:31:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  447a6013e91738c0d4118a7d0c56f235d8623695
Gitweb:     http://git.kernel.org/tip/447a6013e91738c0d4118a7d0c56f235d8623695
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 22 May 2012 13:14:18 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 22 May 2012 13:14:18 -0300

perf tools: Bump default sample freq to 4 kHz

Quoting Ingo:

"While at it I'd also suggest increasing the default sampling frequency,
from 1000 Hz per CPU to at least 4Khz auto-freq or so - this should work
well all across the board I think. CPUs are getting faster and command/app
run times are getting shorter, 1Khz is a bit low IMO."

Requested-by: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-2jafa6mkrufyekny9ei59lpu@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    2 +-
 tools/perf/builtin-top.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 9c76add..e5cb084 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -753,7 +753,7 @@ static struct perf_record record = {
 		.mmap_pages	     = UINT_MAX,
 		.user_freq	     = UINT_MAX,
 		.user_interval	     = ULLONG_MAX,
-		.freq		     = 1000,
+		.freq		     = 4000,
 		.target		     = {
 			.uses_mmap   = true,
 		},
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 18bd226..6031dce 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1162,7 +1162,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	struct perf_top top = {
 		.count_filter	     = 5,
 		.delay_secs	     = 2,
-		.freq		     = 1000, /* 1 KHz */
+		.freq		     = 4000, /* 4 KHz */
 		.mmap_pages	     = 128,
 		.sym_pcnt_filter     = 5,
 		.target		     = {
