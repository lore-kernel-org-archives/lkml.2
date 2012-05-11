Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761093Ab2EKGqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:46:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57390 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab2EKGqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:46:36 -0400
Date: Thu, 10 May 2012 23:45:27 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-04480d01105324dc5b77ca3fbdf85037a7d80dbb@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@kernel.org, gorcunov@openvz.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, drepper@gmail.com,
        robert.richter@amd.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, asharma@fb.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
        paulus@samba.org, tzanussi@gmail.com, masami.hiramatsu.pt@hitachi.com,
        mingo@elte.hu
Reply-To: mingo@kernel.org, eranian@google.com, acme@redhat.com,
        gorcunov@openvz.org, a.p.zijlstra@chello.nl, jolsa@redhat.com,
        fweisbec@gmail.com, drepper@gmail.com, robert.richter@amd.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, asharma@fb.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
        paulus@samba.org, tzanussi@gmail.com, masami.hiramatsu.pt@hitachi.com,
        mingo@elte.hu
In-Reply-To: <1335958638-5160-7-git-send-email-jolsa@redhat.com>
References: <1335958638-5160-7-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report:
  Fix format string for x86-32 compilation
Git-Commit-ID: 04480d01105324dc5b77ca3fbdf85037a7d80dbb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 10 May 2012 23:45:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  04480d01105324dc5b77ca3fbdf85037a7d80dbb
Gitweb:     http://git.kernel.org/tip/04480d01105324dc5b77ca3fbdf85037a7d80dbb
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 2 May 2012 13:37:07 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 May 2012 11:27:08 -0300

perf report: Fix format string for x86-32 compilation

Using PRIu64 for printing out u64 nr_events to fix compilation
for x86 32 bits.

Cc: Arun Sharma <asharma@fb.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Frank C. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Ulrich Drepper <drepper@gmail.com>
Link: http://lkml.kernel.org/r/1335958638-5160-7-git-send-email-jolsa@redhat.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 5df829f..7477655 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -304,7 +304,7 @@ static size_t hists__fprintf_nr_sample_events(struct hists *self,
 	if (evname != NULL)
 		ret += fprintf(fp, " of event '%s'", evname);
 
-	ret += fprintf(fp, "\n# Event count (approx.): %lu", nr_events);
+	ret += fprintf(fp, "\n# Event count (approx.): %" PRIu64, nr_events);
 	return ret + fprintf(fp, "\n#\n");
 }
 
